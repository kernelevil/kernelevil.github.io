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