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

> ## php语法

1、变量以$开头

```php
$a = 10.9;
echo $a;//输出10.9
```

2、isset — 检测变量是否设置

```php
$a = 10.9;
echo isset($a);//输出1
```

3、var_dump — 打印变量的相关信息

```php
$b = 3.1;
$c = TRUE;
var_dump($b,$c);
```

结果：

![image-20251205184848136](/images/image-20251205184848136.png)

4、gettype — 获取变量的类型

```php
$a = -1;
$b = 1.1;
$c = "51CTO";
$d = false;
$e = array(1,2,"baidu",2.1);
echo gettype($a).PHP_EOL;
echo gettype($b).PHP_EOL;
echo gettype($c).PHP_EOL;
echo gettype($d).PHP_EOL;
echo gettype($e).PHP_EOL;
```

结果：

![image-20251205185932387](/images/image-20251205185932387.png)

5、加减乘除

```php
$a = 10;
$b = 20;
echo $a+$b;
echo "<br>";#换行操作
echo $a-$b;
echo "<br>";
echo $a*$b;
echo "<br>";
echo $a/$b;
```

结果：

![image-20251205190505451](/images/image-20251205190505451.png)
