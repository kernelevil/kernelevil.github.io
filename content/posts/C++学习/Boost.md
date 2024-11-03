---
title: "Boost学习"
date: 2024-10-28 06:32:56
draft: false
categories: ["Boost学习"]
tags: ["Boost"]
summary: "Boost学习"
typora-root-url: ./..\..\..\static
---

> ### Boost安装

1、为避免PC中多个VS版本影响，利用VS自带构建工具构建b2.exe,这里我们选择第一个

![image-20241103061328723](/images/image-20241103061328723.png)

2、修改配置

修改project-config.jam为

import option ; 

using msvc : 14.2 : "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Tools\MSVC\14.29.30133\bin\HostX86\x86\cl.exe";; 

option.set keep-going : false ; 

3、执行命令

b2.exe install --prefix=C:\Boost-vc142 --build-type=complete --toolset=msvc-14.2 threading=multi address-model=32  debug release

4、工程配置

![image-20241103125441402](/images/image-20241103125441402.png)

![image-20241103125517530](/images/image-20241103125517530.png)

参考文章：

[【Boost】Windows 下个人在配置 Boost 踩到的坑以及解决方案 - RioTian - 博客园](https://www.cnblogs.com/RioTian/p/17581582.html)

[VS2010编译Boost 1.57 - jeffkuang - 博客园](https://www.cnblogs.com/jeffkuang/articles/4330669.html)