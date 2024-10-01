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

