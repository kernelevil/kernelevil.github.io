---
title: "Hugo时间配置"
date: 2024-08-25 17:59:11
draft: false
categories: ["博客文章"]
tags: ["Hugo", "时间"]
summary: "搜狗输入法自定义短语插入时间以及Hugo开启UTC"
typora-root-url: ./..\..\..\static
---

## 配置搜狗

```
rq,3=#$year-$month_mm-$day_dd
sj,3=#$year-$month_mm-$day_dd $fullhour_hh:$minute:$second
```

## 配置Hugo

```
buildFuture: true
```



