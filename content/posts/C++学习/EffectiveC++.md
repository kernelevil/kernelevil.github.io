---
title: "Effectiv C++"
date: 2024-09-26 05:16:47
draft: false
categories: ["Effectiv C++"]
tags: ["读书"]
summary: "Effective"
typora-root-url: ./..\..\..\static
---

> ### 用const替换#define

因为#define不会进行类型检查

```c++
//#define PI 3.1415926
const double PI = 3.1415926;
```

> ### 用enum在类内定义常数

```c++
class Test{
    public:
          enum {num = 5};
          int sz[num];
}
```

> ### 用内敛函数模版替换#deifne定义函数

![image-20240926055445863](/images/image-20240926055445863.png)

> ### const放于函数后实现函数重载

```c++
#include <iostream>
using namespace std;
class Test {

public:
    std::string text = "hellow";
public:
   const char& operator[](const std::size_t n) const{
       std::cout << "带const"<<endl;
       return text[n];
   }
     char& operator[](const std::size_t n)  {
       std::cout << "不带const"<<endl;
       return text[n];
   }
};
int main()
{     
    Test nt;
    nt[1];
    const Test ct;
    ct[1];
    return 0;
}
```

> ### const位置

const位于星号左侧内容不可改，const位于星号右侧指针不可改。

> ### 迭代器加const

```c++
    std::vector<int> vec = {1,2,3};
    const auto iter = vec.begin();
    *iter = 10;//指针不可变，内容可变
    auto citer = vec.cbegin();
    citer = vec.cend();//ok,指针可变
    *citer = 10;//error,内容不可变
```

> ### mutable打破const约束

![image-20240928111330179](/images/image-20240928111330179.png)

> ### 减少重复代码

```c++
//改进前
#include <iostream>
void myPrint(std::string type) {
    std::cout << type << std::endl;
}
class TextBlock {
public:
    TextBlock(std::string t){
        this->text = t;
    }
    const char& operator[](std::size_t pos) const {
        myPrint("const版本打印");
        return text[pos];
    }
    char& operator[](std::size_t pos){
        myPrint("非const版本打印");
        return text[pos];
    }
private:
    std::string text;
};
int main() 
{
    TextBlock text("yhj");
    text[1];
    const TextBlock c_text("jhh");
    c_text[0];
    return 0;
}
```

```c++
//改进后，少调用了一次打印
#include <iostream>
void myPrint() {
    std::cout << "开始打印" << std::endl;
}
class TextBlock {
public:
    TextBlock(std::string t){
        this->text = t;
    }
    const char& operator[](std::size_t pos) const {
        std::cout << "进入带const"<<std::endl;
        myPrint();
        return text[pos];
    }
    char& operator[](std::size_t pos){
        std::cout << "进入不带const"<<std::endl;
        return const_cast<char&>(
            static_cast<const TextBlock&>(*this)[pos]
            );
    }
private:
    std::string text;
};
int main() 
{
    TextBlock text("yhj");
    text[1];
    //const TextBlock c_text("jhh");
    //c_text[0];
    return 0;
}
```

> ### 编译单元

![image-20240928123505654](/images/image-20240928123505654.png)

![image-20240928123632119](/images/image-20240928123632119.png)

> ### 全局变量延迟到调用时初始化

```c++
#include <iostream>

class Foo{};

Foo& getFoo() {
    std::cout << "开始初始化全局foo" << std::endl;
    static Foo foo;
    return foo;
}

int main() 
{
    std::cout << "进入main" << std::endl;
    getFoo();
    return 0;
}
```

> ### 阻止拷贝

1、通过=delete阻止拷贝构造和拷贝赋值

```c++
#include <iostream>
class Uncopy {
public:
    Uncopy() {};
    ~Uncopy() {};
    Uncopy(const Uncopy&) = delete;
    Uncopy& operator=(const Uncopy&) = delete;
};
int main() {
    Uncopy cls,cls2;
    cls = cls2;//erro禁止拷贝
    return 0;
}
```

2、通过私有化拷贝构造和拷贝赋值来阻止拷贝，拷贝构造函数和拷贝赋值函数不用实现，只声明即可。

```c++
#include <iostream>
class Uncopy {
public:
    Uncopy() {};
    ~Uncopy() {};
private:
    Uncopy(const Uncopy&);
    Uncopy& operator=(const Uncopy&);
};

int main() {
    Uncopy cls,cls2;
    cls = cls2;//erro禁止拷贝
    return 0;
}
```

3、通过继承来阻止拷贝

```c++
#include <iostream>
class Uncopy {
public:
    Uncopy() {};
    ~Uncopy() {};
private:
    Uncopy(const Uncopy&);
    Uncopy& operator=(const Uncopy&);
};
class MyCls : private Uncopy {

};
int main() {
    MyCls cls,cls2;
    cls = cls2;//erro禁止拷贝
    return 0;
}
```

> ### 基类析构函数一定要声明为虚函数，否则子类析构不被调用，造成泄露

原因是delete父类指针时不能利用多态特性析构子类

> ### =default请求编译器生成默认构造函数

```c++
#include <iostream>

class MyClass {
public:
    // 默认构造函数被指定为=default，编译器将生成它
    MyClass() = default;

    // 自定义构造函数
    MyClass(int value) : value(value) {}

    void printValue() {
        std::cout << "Value: " << value << std::endl;
    }

private:
    int value = 0;
};

int main() {
    MyClass obj1;      // 使用生成的默认构造函数
    MyClass obj2(42);  // 使用自定义构造函数

    obj1.printValue(); // 输出: Value: 0
    obj2.printValue(); // 输出: Value: 42

    return 0;
}

```

> ### 抽取方法将异常处理留给调用者

```c++
class DBConnectoin {
public:
    void close() {};
};
class DBConn {
public:
    void close() {
        mydb.close();
        closed = true;
    }
    ~DBConn() {
        if (!closed) {  
            try {
                close();
            }
            catch (...) {
                std::cout << "记录出错原因";
            }
        }   
    };
private:
    DBConnectoin mydb;
    bool closed;
};
```

> ### 连等通常返回自身引用

```c++
#include <iostream>
class Base {
public:
    Base& operator=(const Base& b){

        return *this;
    }
public:
    std::string name;
};

int main() {
    Base base1,base2,base3;
    base1 = base2 = base3;//连等
    return 0;
}
```

> ### 三五法则

C++三法则：如果需要[析构函数](https://so.csdn.net/so/search?q=析构函数&spm=1001.2101.3001.7020)，则一定需要拷贝构造函数和拷贝赋值操作符。

在较新的 C++11 标准中，为了支持移动语义，又增加了移动构造函数和移动赋值运算符，这样共有五个特殊的成员函数，所以又称为“C++五法则”；

> ### 拷贝构造函数和拷贝赋值运算符

1、拷贝构造函数

```c++
class Base {
public:
    //拷贝构造函数
    Base(const Base&) {};
};
```

2、拷贝赋值运算符

```c++
class Base {
public:
    //拷贝赋值运算符
    Base& operator=(const Base&) {};
};
```

> ### 移动构造函数和移动赋值运算符

1、移动构造函数

```c++
#include <iostream>
class Base {
public:
    Base(Base&& b) noexcept :name(b.name)  {//初始化器接管b中资源
        b.name = nullptr; //令析构是安全的
    }
public:
    std::string name;
};
```

2、移动赋值运算符

```c++
class Base {
public:
    //移动赋值运算符
    Base& operator=(Base&& b) noexcept{
       //检测自赋值
        if (this != &b) {
            name = b.name;
            b.name = nullptr;
        }
        return *this;
    }
public:
    std::string name;
};
```

> ### 对象切片

```c++
#include <iostream>
class Base {
public:
    virtual void display() {
        std::cout << "Base display";
    };
};
class MyClass : public Base{
public:
    int age = 99;
    void display() {
        std::cout << "MyClass display";
    }
};
void PrintFun(Base b) {
    b.display();
};
int main() {

    MyClass obj;  
    PrintFun(obj);//由于传递的不是指针发生了对象切片，MyClass变为了Base,输出Base display

    return 0;
}

```

> ### 命名空间将类的成员函数划分到模块中

```c++
#include <iostream>
namespace stuff {
    class WebBrowser {
    public:
        void clearCach() { std::cout << "clearCach"; };
        void clearHistory() { std::cout << "clearHistory"; };
        void clearCookie() { std::cout << "clearCookie"; };
    };
}
namespace stuff {
    void clearCash(WebBrowser& web) { web.clearCach(); }
}
namespace stuff {
    void clearHistory(WebBrowser& web) { web.clearHistory(); }
}
namespace stuff {
    void clearCookie(WebBrowser& web) { web.clearCookie(); }
}

int main() 
{
    stuff::WebBrowser web;
    stuff::clearCash(web);
    return 0;
}
```

> ### 通过12个问题高效设计类

1、新类型对象，构造和析构如何写。

2、对象的初始化和赋值如何写。

3、对象按值传递时应考虑拷贝构造和移动构造如何写。

4、类的成员变量应考虑约束和范围。

5、考虑设计的这个类是否可能被继承，继承的话要将析构设计成虚函数。

6、新的类型是否需要类型转换，是否允许隐式类型转换。

7、新的类型需要有哪些操作，哪些成员函数。

8、新的类型哪些函数需要删除，根据设计类的语义是否对象允许拷贝或赋值，不允许则要delete掉。

9、考虑成员函数或成员变量的访问限定符。

10、根据语境该类是否要设计成线程安全的。

11、新的类型是否足够通用，例如是否定义为模版类。

12、是否真的需要定义一个新的类型，是否通过继承就能实现。

> ### 类模版的特化与偏特化

```c++
// 基本模板
template <typename T>
class MyClass {
public:
    void print() {
        std::cout << "General template" << std::endl;
    }
};

// 完全特化
template <>
class MyClass<int> {
public:
    void print() {
        std::cout << "Specialized for int" << std::endl;
    }
};

// 使用示例
MyClass<double> obj1; // 使用基本模板
obj1.print(); // 输出：General template

MyClass<int> obj2; // 使用特化版本
obj2.print(); // 输出：Specialized for int

```

```c++
// 基本模板
template <typename T, typename U>
class MyClass {
public:
    void print() {
        std::cout << "General template" << std::endl;
    }
};

// 偏特化
template <typename T>
class MyClass<T, int> {
public:
    void print() {
        std::cout << "Partially specialized for second argument of type int" << std::endl;
    }
};

// 使用示例
MyClass<double, double> obj1; // 使用基本模板
obj1.print(); // 输出：General template

MyClass<double, int> obj2; // 使用偏特化版本
obj2.print(); // 输出：Partially specialized for second argument of type int

```

> ### ADL优化机制---using std::swap

STL `std::pair` 中的 swap 函数是这样实现的：（来自 stl_pair.h，仅展示部分源代码）

```c++
namespace std
{
  template<typename _T1, typename _T2>
    struct pair
    {
      _T1 first;                 ///< The first member
      _T2 second;                ///< The second member
        
      /// Swap the first members and then the second members.
      void swap(pair& __p)
      {
	using std::swap;
	swap(first, __p.first);
	swap(second, __p.second);
      }
 
    }
}
```

显然这里是想对 pair 中的两个元素依次调用我们熟知的 `std::swap` 函数。那为什么要提前写一句 `using std::swap;` 而不是直接使用 `std::swap(first, __p.first);` 的写法呢？其实这里 STL 选择的写法是必须的。

来看一个例子：

```c++
#include <iostream>  // for std::cout
int main() {
    std::cout << "Hello World!\n";
    return 0;
}
```

一段很平凡的代码。

但仔细想想，`std::ostream` 重载的 `<<` 流运算符是定义在标准命名空间 `std` 中的，也就是说按上面的写法，本该是因为找不到流运算符的定义而编译失败的，似乎下面这种写法才是正确的：

```c++
#include <iostream>  // for std::cout
int main() {
    std::operator<<(std::cout, "Hello World!\n");
    return 0;
}
```

即，使用 作用域解析运算符 `::`。

那么，第一种写法为什么可以？

这是因为，第一种写法中，编译器发现流运算符的左参数 `std::cout` 是隶属于命名空间 `std` 中的，同时又因为编译器没有在全局中找到流运算符的定义，于是编译器就会把搜查范围扩展到命名空间 `std` ，继续搜索流运算符的定义，当然就成功找到了。也就是说，下面这种写法也是可以的：

```c++
#include <iostream>  // for std::cout
int main() {
    operator<<(std::cout, "Hello World!\n");
    return 0;
}
```

不使用 作用域解析运算符。

这种**根据函数参数所属作用域，来扩展所调用的函数的查找范围**的机制，称为**参数依赖查找（Argument-Dependent Lookup，ADL）**。ADL 机制可以帮助提升 C++ namespace 场景中模板的适应性，同时简化了我们的代码编写。

这时候再来看`std::pair` 中的 swap 函数，你就会知道，如果用 `std::swap(first, __p.first);` 的写法，swap 函数就被限定在了命名空间 `std` 中；而如果使用 STL 中 `using std::swap;` 的写法，则会触发 ADL 机制，编译器会在全局范围（包括通过 using 引入的 `std` 命名空间）内查找 swap 函数。

## 为什么要触发 ADL 机制？

如果你使用的是一般的数据类型，那么这里是否触发 ADL 机制都毫无区别。

这里的“一般”指诸如以下几种：

```c++
#include <utility> for std::pair
std::pair<int, int*> pii;
std::pair<long long, double> pld;
std::pair<char, unsigned short> pcs;
```

等等。

但如果是用户定义的某些复杂的类、结构体呢？

`std::swap` 会把这些数据类型中的所有数据逐个复制、拷贝三次，进行交换操作，同时还会进行构造、析构等操作，这就会造成许多时间上和空间上的浪费。

通常，对于数据量大的类，我们会采取一些特殊方法来实现交换操作。特别实现的交换操作可以节约很多空间和时间。但是，`std::swap` 并不知道它可以调用我们已实现的交换操作，所以我们每次使用不同的类时，就必须调用不同的专门的函数。这显然是不符合模板化的“通用性”的精神的。

为了解决这个问题，我们可以针对自己的类重载 swap 函数，但不必在标准命名空间 `std` 中。由于 `std::pair` 中的 swap 触发了 ADL，编译器就会同时搜索到 `std::swap` 和我们的 swap。因为一系列重载函数的参数匹配原则，编译器就会优先调用我们特化过的 swap，而不是使用了模板的 `std::swap`。

同样的原理，除了 `std::pair` 中的 swap 函数，STL 也在许多其他地方使用了 ADL 机制进行相应的优化。

## 验证 ADL 的触发

我写了一个短程序来模拟验证 STL 的写法触发了 ADL 机制，并实现了上中所说的我们想要的效果。

程序的大体思路：

在命名空间中，定义一个模板函数 fun，模拟 `std::swap`。

全局中，定义一个特殊类型 myType。

定义针对 myType 的函数 fun 的特化版本。

定义模板类 test，模拟 `std::pair`。

在 test 中定义函数 fun1 和 fun2，分别用两种写法调用 fun 函数。

主函数中，依次调用 fun1 和 fun2，输出查看两种写法实际调用的是哪个版本的 fun 函数。

程序如下：

```c++
#include <iostream>  // for std::cout
 
namespace _std
{
	/// 模拟 std 中的模板函数
  template<typename Tp>
	void fun(const Tp&) {
		std::cout << "Call fun() in _std.\n";
	}
}
 
/// 一个特殊的类型
struct myType { };
 
/// 对 myType 进行特化
void fun(const myType&) {
	std::cout << "Call fun() specially for myType.\n";
}
 
template<typename T>
  struct test {
  	
	T x;
  /// 不使用 using 技法
	void fun1() {
		std::cout << "fun1, without 'using':\t";
		_std::fun(x);
	}
	
  /// 使用 using 技法
	void fun2() {
		std::cout << "fun2, with 'using':\t";
		using _std::fun;//触发ADL
		fun(x);
	}
};
 
int main()
{
	test<int> t_int;       /// 用于对照
	test<myType> t_myType;
	
	std::cout << "t_int:\n";
	t_int.fun1();
	t_int.fun2();
	
	std::cout << "\nt_myType:\n";
	t_myType.fun1();
	t_myType.fun2();
	
	return 0;
}
```

