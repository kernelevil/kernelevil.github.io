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

![image-20240928112550253](/images/image-20240928112550253.png)

> ### 编译单元

![image-20240928123505654](/images/image-20240928123505654.png)

![image-20240928123632119](/images/image-20240928123632119.png)

> ### 全局变量延迟到调用时初始化

![image-20240928123826124](/images/image-20240928123826124.png)

> ### 阻止拷贝

1、通过=delete阻止拷贝构造和拷贝赋值

![image-20240928140542420](/images/image-20240928140542420.png)

2、通过私有化拷贝构造和拷贝赋值来阻止拷贝，拷贝构造函数和拷贝赋值函数不用实现，只声明即可。

![image-20240928141437727](/images/image-20240928141437727.png)

3、通过继承来阻止拷贝

![image-20240928141559654](/images/image-20240928141559654.png)

> ### 基类析构函数一定要声明为虚函数，否则子类析构不被调用，造成泄露

原因是delete父类指针时不能利用多态特性析构子类
