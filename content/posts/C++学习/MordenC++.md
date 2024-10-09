---
title: "MordenC++"
date: 2024-10-03 07:57:55
draft: false
categories: ["MordenC++"]
tags: ["读书"]
summary: "MordenC++"
typora-root-url: ./..\..\..\static
---

> ### 按值或按引用推导模版类型

结论：至于推倒结果中含不含const要根据语境判断，如果传递的内容不会改变原来值则推导结果中不含const（不会携带过来），否则含有const

```c++
//按引用传递
template<typename T>
void f(T& param) {};
int a = 27;//param推导为int&
const int b;//param推导为const int&
const int& c;//param推导为const int&
template<typename T>
void q(const T& param) {};
int a = 27;//param推导为const int&
const int b;//param推导为const int&
const int& c;//param推导为const int&

//按值传递
template<typename T>
void s(T param) {};
int a = 27;//param推导为int
const int b;//param推导为int
const int& c;//param推导为int
```

> ### 数组和函数指针auto推导

```c++
    //数组推导
    const char name[] = "YHJ";
    auto str1 = name;//推导为const char *
    auto& str2 = name;//推导为const char(&)[13]

    //函数指针推导
    void func(int, double);
    auto f1 = func;//推导为void(*)(int,double)
    auto& f2 = func;//推导为void(&)(int,double)
```

> ### decltype(C++14)

占位符用法：

```c++
Widget w;
const Widget& cw = w;
auto myWidget1 = cw;                    //myWidget1的类型为Widget
decltype(auto) myWidget2 = cw;          //myWidget2的类型是const Widget&,这里auto是cw的占位符

```

两个括号用法,加上引用

```c++
int x = 10;
decltype(x) y = x;//y推导为int
decltype((x)) y = x;//y推导为int&
```

