---
title: "PHP语法"
date: 2025-12-05 13:41:09
draft: false
categories: ["PHP学习"]
tags: ["PHP"]
summary: "PHP学习"
typora-root-url: ./..\..\..\static
---

> ## php开发环境搭建

1、安装wamp

![image-20251205140455921](/images/image-20251205140455921.png)

2、关注安装后的bin目录和www目录

3、一台服务器配置多个网站，修改配置文件

![image-20251205175703642](/images/image-20251205175703642.png)

增加配置：

```c++
<VirtualHost *:80>
  ServerName www.f.com
  #设定网站目录
  DocumentRoot "C:/wamp/www/f.com"
  <Directory "C:/wamp/www/f.com">
  Order Deny,allow
  Allow from all
  </Directory>
  #给默认的首页
  Options Indexes FollowSymLinks
</VirtualHost>
```

