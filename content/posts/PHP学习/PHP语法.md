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

6、字符串连接需要用点号

```php
<?php
$a = "51";
$b = "cto";
$c = $a.$b;
echo $c;//输出51cto
```

7、字符串双引号和单引号区别：双引号能够解析其中变量，单引号原封不动输出

```php
$a = "baidu";
$b = "xxx$a";
$c = 'xxx$a';
echo $b,$c;//输出xxxbaidu  xxx$a
```

8、字符串常用函数

```php
[strlen]
$a = "baidu";
echo strlen($a);//输出5

[mb_strlen]
header("content-type:text/html;charset=utf-8");
$a = "baidu";
$b = "北京";
echo mb_strlen($b, 'utf-8');//输出2

[strpos — 查找字符串首次出现的位置]
$a = "edu.51cto.com";
$b = "北京";
echo strpos($a,'51');//返回4，从零计数

[strrpos — 查找字符串最后一次出现的位置]
$a = "edu.51cto.co51m";
$b = "北京";
echo strrpos($a,'51');//返回12，从零计数

[stripos — 查找字符串首次出现的位置,不区分大小写]

[strstr — 查找字符串的首次出现,并截取出来]
$a = "edu.51cto.co51m";
echo strstr($a,"co");//输出co51m

[substr — 返回字符串的子串]
$a = "edu.51cto.co51m";
echo substr($a,4,5);//输出51cto,从偏移4截取5个字符

[strrchr — 输出拓展名]
$a = "filename.txt";
echo strrchr($a,".");//输出.txt

[str_replace — 子字符串替换]
$a = "edu.51cto.co51m";
echo str_replace("51cto","baidu",$a);//输出：edu.baidu.co51m

[explode — 使用一个字符串分割另一个字符串]
$a = "www.51cto.com";
$array =  explode(".",$a);//获取分割字符串
print_r($array);//打印数组Array ( [0] => www [1] => 51cto [2] => com )
[implode:explode的逆运算，将数组连接成字符串]

[trim 去除首尾空白符]
[ltrim 除去左侧空格]
[rtrim 除去右侧空格]



```

9、解决汉字乱码

```php
header("content-type:text/html;charset=utf-8");
```

10、数组

```php
[array() 定义数组]
$a = array(1,2,3,"baidu",false);
print_r($a);//输出Array ( [0] => 1 [1] => 2 [2] => 3 [3] => baidu [4] => )

[键值对数组]
$a = array(
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => "baidu"
);
print_r($a);//Array ( [one] => 1 [two] => 2 [three] => 3 [four] => baidu )

[count 计算数组长度]
echo count($a);

[foreach 遍历数组方法一]
$a = array(
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => "baidu"
);
foreach ($a as $key => $value) {
    echo $key . "=>" . $value . "<br>";
}
//输出
one=>1
two=>2
three=>3
four=>baidu
    
[list each 遍历数组方法二]
 $a = array(
1,2,3
);
while($row = each($a)){
    list($k,$v) = $row;
    echo $k."---".$v."<br>";
}

[数组增删]
 $a = array(1,2,3);
$a[] = 4;//数组增加元素
unset($a[3]);//数组删除
foreach ($a as $key => $value) {
    echo $key . "=>" . $value . "<br>";
}

[array_key_exists 判断键值是否存在]
$a = array(
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => "baidu"
);
$ishas = array_key_exists("two", $a);
var_dump($ishas);//返回true
```

11、函数

```php
function a()
{
    echo "www.baidu.com<br>";
    echo "www.sinia.com<br>";
}
a();
```

12、超全局变量

```php
var_dump($GLOBALS);
var_dump($_SERVER);
var_dump($_GET);
var_dump($_POST);
var_dump($_REQUEST);//GET与POST的集合
```

13、常量

```php
define("PI",3.1415926535898);
echo  PI;
```

14、利用cookie统计网页访问次数

```php
setcookie("aaa","www.baidu.com");
$num = 0;
if(empty($_COOKIE["access"])){
    setcookie("access",1);
    echo 1;
}else{
    $num = $_COOKIE["access"];
    $num = $num+1;
    setcookie("access",$num);
    echo $num;
}
```

15、文件包含

```php
#include "x.php":报错继续执行
require "x.php":报错终止执行后面的 
```

