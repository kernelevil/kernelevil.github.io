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

> ### 使用限定范围的枚举

```c++
enum class Color {A=0,B,C}//限定范围枚举
//使用
Color c = Color::A
enum Color{A=0,B,C}//不限定范围
//使用
Color = A
```

> ### 利用模版简化类型编写

```c++
#include <iostream>
#include <tuple>

enum class COLOR {
    R = 0,
    G,
    B
};
//模版改进版
template<typename E>
constexpr typename std::underlying_type<E>::type toUType(E e) noexcept {
    return
        static_cast<typename std::underlying_type<E>::type>(e);
}
int main() {
    
    using User = std::tuple<std::size_t, std::size_t, std::size_t>;
    auto u = std::make_tuple(125, 233, 30);
    auto r = std::get<0>(u);
    auto g = std::get<1>(u);
    auto b = std::get<2>(u);
    //用枚举改进
    using User = std::tuple<std::size_t, std::size_t, std::size_t>;
    auto u = std::make_tuple(125, 233, 30);
    auto r = std::get<static_cast<size_t>(COLOR::R)>(u);
    auto g = std::get<static_cast<size_t>(COLOR::G)>(u);
    auto b = std::get<static_cast<size_t>(COLOR::B)>(u);
    //用模版改进
    using User = std::tuple<std::size_t, std::size_t, std::size_t>;
    auto u = std::make_tuple(125, 233, 30);
    auto r = std::get<toUType(COLOR::R)>(u);
    auto g = std::get<toUType(COLOR::G)>(u);
    auto b = std::get<toUType(COLOR::B)>(u);
    return 0;
}
```

