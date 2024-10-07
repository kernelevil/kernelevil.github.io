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

