[TOC]

# 代理的理解

在Java设计模式中，代理模式是这样定义的：给某个对象提供一个代理对象，并由代理对象控制原对象的引用。

举个生活中的例子: 比如我们要买一间二手房，虽然我们可以自己去找房源，但是这太花费时间精力了,那么怎么办呢？最简单快捷的方法就是找二手房中介公司,我们只要告诉中介公司我们要什么样的二手房,然后委托中介公司去找房子,这就是代理,中介公司帮我们代理找二手房这件事情

代理简单来说，就是如果我们想做什么，但又不想直接去做，那么这时候就找另外一个人帮我们去做。那么这个例子里面的中介公司就是给我们做代理服务的，我们委托中介公司帮我们找房子。

Nginx 主要能够代理如下几种协议，其中用到的最多的就是做Http代理服务器。

![img](D:\note\.img\1120165-20180905232339438-913760288.png)

## 正向代理

弄清楚什么是代理了，那么什么又是正向代理呢？

再举一个例子：大家都知道，现在国内是访问不了 Google的，那么怎么才能访问 Google呢？我们又想，美国人不是能访问 Google吗,如果我们电脑的对外公网 IP 地址能变成美国的 IP 地址，那不就可以访问 Google了。VPN 就是这样产生的。我们在访问 Google 时，先连上 VPN 服务器将我们的 IP 地址变成美国的 IP 地址，然后就可以顺利的访问了。

这里的 VPN 就是做正向代理的。正向代理服务器位于客户端和服务器之间，为了向服务器获取数据，客户端要向代理服务器发送一个请求，并指定目标服务器，代理服务器将目标服务器返回的数据转交给客户端。这里客户端是要进行一些正向代理的设置的。

> VPN 通俗的讲就是一种中转服务，当我们电脑接入 VPN 后，我们对外 IP 地址就会变成 VPN 服务器的 公网 IP，我们请求或接受任何数据都会通过这个VPN 服务器然后传入到我们本机。

## 反向代理

反向代理和正向代理的区别就是：**正向代理代理客户端，反向代理代理服务器。**

反向代理，其实客户端对代理是无感知的，因为客户端不需要任何配置就可以访问，**我们只需要将请求发送到反向代理服务器，由反向代理服务器去选择目标服务器获取数据后，再返回给客户端，此时反向代理服务器和目标服务器对外就是一个服务器**，暴露的是代理服务器地址，隐藏了真实服务器IP地址。

下面我们通过两张图来对比正向代理和方向代理：

![img](D:\note\.img\1120165-20180730224449157-560730759.png)

![img](./.img/.Nginx/1120165-20180730224512924-952923331.png)

理解这两种代理的关键在于代理服务器所代理的对象是什么，正向代理代理的是客户端，我们需要在客户端进行一些代理的设置。而反向代理代理的是服务器，作为客户端的我们是无法感知到服务器的真实存在的。

总结起来还是一句话：**正向代理代理客户端，反向代理代理服务器。**



# nginx反向代理示例

示例: 使用 nginx 反向代理 `www.123.com` 直接跳转到`127.0.0.1:8080`

- 启动一个tomcat,浏览器地址栏输入 127.0.0.1:8080，出现如下界面

  ![img](D:\note\.img\1120165-20180905235823351-2004614694.png)

- 通过修改本地 host 文件，将 `www.123.com` 映射到 `127.0.0.1`

  > 配置完成之后，我们便可以通过 `www.123.com:8080` 访问到第一步出现的 Tomcat初始界面。

- 在 nginx.conf 配置文件中增加如下配置:

  ```nginx
  server {
          listen       80;
          server_name  www.123.com;
  
          location / {
              proxy_pass http://127.0.0.1:8080;
              index  index.html index.htm index.jsp;
          }
      }
  ```

  如上配置，我们监听80端口，访问域名为`www.123.com`，不加端口号时默认为80端口，故访问该域名时会跳转到`127.0.0.1:8080`路径上。

  我们在浏览器端输入 `www.123.com` 结果如下：

  ![img](D:\note\.img\1120165-20180906073551600-75534434.png)



总结:

其实这里更贴切的说是通过nginx代理端口，原先访问的是8080端口，通过nginx代理之后，通过80端口就可以访问了。



# nginx安装

## windows安装

[下载地址](http://nginx.org/en/download.html)

- 选择windows版的.zip文件,下载后解压

- 启动nginx

  切换到nginx解压目录下，输入命令 `start ./nginx.exe`

  > 虽然会有一个黑窗口一闪而过,但是nginx已经启动了

- 关闭ngixn

  `./nginx.exe -s stop`

  > 必须使用这种方式关闭或者是在任务管理器中将其关闭

- 配置文件nginx.conf修改重装载命令

  `./nginx.exe -s reload`

## linux安装

- 下载安装所需要的依赖文件

  ```shell
  [root@bogon src]# yum install pcre pcre-devel zlib zlib-devel
  [root@bogon src]# yum install gcc-c++
  ```

- 下载nginx

  ```shell
  [root@bogon src]# cd /usr/local/src/
  [root@bogon src]# wget http://nginx.org/download/nginx-1.6.2.tar.gz
  ```

- 解压安装包

  ```shell
  [root@bogon src]# tar zxvf nginx-1.6.2.tar.gz
  ```

- 进入安装包目录

  ```shell
  [root@bogon src]# cd nginx-1.6.2
  ```

- 编译安装

  ```shell
  [root@bogon nginx-1.6.2]# ./configure && make && make install
  ```

  > nginx的configure命令支持以下参数：
  >
  > - `--prefix=*path*`    定义一个目录，存放服务器上的文件 ，也就是nginx的安装目录。默认使用 `/usr/local/nginx。`
  >
  > 示例:
  >
  > ```nginx
  > ./configure --prefix=/usr/local/nginx/
  > ```

- 启动nginx

  ```shell
  [root@bogon nginx-1.6.2]# /usr/local/nginx/sbin/nginx
  ```

## nginx的文件夹组成

cd /usr/local/nginx目录下:,看到如下4个文件

- conf配置文件
- html网页文件
- logs日志文件
- sbin主要二进制程序

# nginx命令

## nginx常用命令

### 启动命令

`/usr/local/nginx/sbin/nginx`

> 这里的路径要看真实nginx安装的路径,但是只要找到`nginx/sbin`目录即可

### 关闭命令

`/usr/local/nginx/sbin/nginx -s stop`

### 重启命令

`/usr/local/nginx/sbin/nginx -s reload`

## nginx常用设置

### 设置开机启动

`systemctl enable nginx.service`

### 停止开机启动

`systemctl disable nginx.service`

### 重新启动服务

`systemctl restart nginx.service`

### 启动nginx服务

`systemctl start nginx.service`

### 查看nginx服务的当前状态

`systemctl status nginx.service`

### 查看所有已启动的服务

`systemctl list-units --type=service`

# nginx模块

nginx语法

所有的语句都通过`;`来结束,没有`;`则会报错

## [http核心模块](http://www.Nginx.cn/doc/standard/httpcore.html)

http核心模块是指一个http包裹的代码块中,如

```nginx
http{
 	default_type : text/html;
    location / {
        ...
    }
    ...
}
```

http模块中包含了一些重要的参数

- location
- listen
- root
- server
- ...

### server

语法: server { ... }

上下文: http

> 指定虚拟服务器的配置

参数

#### server_name

语法: server_name name [... ]

> 该参数用来区分请求到该服务器使用的hostname(即域名),如果server都监听着80端口,那么可以指定不同的server_name用来区别来自不同的域名访问的请求,并做对应的处理
>
> 默认为hostname, 所以可以不填写

示例

```nginx
server {
    listen 80;
    default_type text/plain;
    server_name www.aaa.com;
    location /{
        return 200 "aaa";
    }
}
server {
    listen 80;
    default_type text/plain;
    server_name www.bbb.com;
    location /{
        return 200 "bbb";
    }
}
```

> 前提条件: `www.aaa.com`和`www.bbb.com`的ip都指向当前这台nginx服务所在的ip
>
> 上面两台虚拟服务器都监听着80端口,如果现在使用`www.aaa.com`网址访问时,将会返回`aaa`,如果使用`www.bbb.com`访问,则会返回`bbb`

#### location

语法: location 正则表达式 { ... }

使用范围: 在server代码块中使用

location会根据请求的url进行正则表达式的匹配,如果匹配到之后,则会执行其代码块中的一些操作

------

location的匹配规则 ( 优先级从高到低 )

1. `=` 精确匹配,优先级为1(最高)

2. `^~` 普通字符串匹配,不会使用正则表达式进行匹配,当匹配成功后则停止location匹配,优先级为2

3. `~`或`~*` 正则匹配,优先级为3

   > `~`为区分大小写,`~*`为不区分大小写

4. `/xxx`其他匹配,优先级为4

示例

```nginx
# 优先级1(精确匹配)
location =/abc{
	default_type    text/html;
    return 200 '= /abc';
}
# 优先级2(普通字符串匹配)
location ^~ /abcd{
    default_type    text/html;
    return 200 '/abcd111';
}
# 优先级3(正则匹配)
location ~ /abc.*d{
    default_type    text/html;
    return 200 '/abcde';
}
# 优先级4(其他匹配)
location /abcrrrr{
    default_type    text/html;
    return 200 '/abcde33';
}
# 优先级4(其他匹配)
# 该匹配模式被最后匹配,因为在相同优先级下,匹配的越多的优先级会越高
location / {
    default_type    text/html;
    return 200 "/"
}
```

- 当请求`/abc`时,返回`= /abc`

- 当请求`/abcd`时,返回`/abcd111`

- 当请求`/abcddd`时,返回`/abcde`

- 当请求`/abcrrrr111`时,返回`/abcde33`

- 当请求`/fff`时,返回`/`

  > 因为全都没有匹配上,只有`/`匹配上了,`/`的匹配规则无论如何都会匹配上任何请求

注意点

- 不同的匹配模式只是匹配url的前面部分,如果匹配到后
  - 匹配的优先级不同,根据优先级从高到低进行选择
  - 匹配的优先级相同,根据匹配url的个数越多,优先级越高,则优先选择
- 当匹配完成后,进入到了对应的location中,则根据location中的定义进行返回数据
  - 如果返回资源,则location中可以指定资源的根路径,然后根据url去找,如果找到了则返回,如果没找到返回error_page
  - 如果是转发,则可以修改url或者保持url不变进行转发到不同的服务器中

#### listen

语法: listen address:port

作用域: server

> 指定监听服务器的哪个端口, 默认`80`端口

示例:

```nginx
listen 8000; # 监听服务器的8000端口
listen 443 default ssl; # 监听服务器的443端口,并开启ssl
```

### default_type

语法: default_type 类型

上下文: http, server, location

> 设置返回值的类型, 默认值为`text/plain`

其他参数值

- `text/html`

  > 返回html格式

- `application/x-ns-proxy-autoconfig;`

- `application/octet-stream`

  > 返回文件类型

- ...

### root

语法: root path

上下文: http, server, location

> 指定资源文件的根目录 , 默认的根目录是html目录

### index

语法: index file [file...]

作用域: http, server, location

> 可以指定首页文件 默认: index index.html
>
> 注意: `index`需要配合`root`进行使用

**可以指定首页的文件;文件按其枚举的顺序进行先后显示**

示例:

```nginx
http{
	index  0.html  /index.html;
}
```

### error_page

语法: error_page code [code...] [=|= 指定返回状态码] url

上下文:  http, server, location

> 如果发生错误的状态和code相同,则会匹配到该error_page,你可以修改返回的状态码(通过`= 状态码`来修改),并指定返回发生错误时返回对应的页面
>
> 该参数相当于重定向,即如果发生错误,则在重定向到指定url
>
> 注意: `error_page`如果要返回资源目录中的页面,则需要配合`root`进行使用

示例:

```nginx
error_page 404 /404.html; # 发生404错误时,返回404.html页面
error_page 502 503 504  /50x.html; # 发生502,503,504这三种其中一种错误时,返回50x.html页面
error_page 403 http://example.com/forbidden.html; # 可以指定返回对应的url
error_page 404 =200 /.empty.gif; #发生404错误时,修改返回的状态码为200,并返回empty.gif文件
```

### nginx变量

nginx的日志打印示例

```nginx
log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';  
```

> nginx日志将会输出对应的变量到日志中,nginx对于`$`开头的变量会进行字符串替换操作(即将`$remote_addr - $remote_user`替换成`127.0.0.1 - lyj`)

详细的变量查看可以看本文的`调试nginx`中的`将nginx的常用参数打印在页面上`

## upstream模块

该模块提供了一个简单方法来实现服务器的负载均衡

通过轮询和ip_hash来实现负载均衡

### 轮询实现

```nginx
# 设置轮询器,取名为myServer
upstream myServer {
    server 47.105.165.211:80 weight=5;
    server 47.105.165.211:8000;
    server 47.105.165.211:8001;
}
 
server {
  location / {
    proxy_pass  http://myServer;
  }
}
```

### ip_hash

语法: ip_hash

作用域: upstream

> 该命令可以根据客户端的ip进行分发,客户端分发到同一台服务器的可能性很大

示例:

```nginx
upstream myServer {
  ip_hash;
  server   backend1.example.com;
  server   backend2.example.com;
}
```

> 在轮询的基础上加上`ip_hash`命令即可

## Proxy模块

### proxy_pass

语法: proxy_pass URL

上下文: location

> 该指令会将url转发到指定的服务器

```nginx
location  / {
	proxy_pass   http://127.0.0.1;
}
```

轮询

```nginx
upstream myServer {
    server 47.105.165.211:8000;
    server 47.105.165.211:8001;
}
server {
  location / {
    proxy_pass  http://myServer;
    # proxy_pass  http://72cun.cn; # 也可以直接转发到指定的服务上
  }
}
```

### proxy_redirect

语法: proxy_redirect [ default|off|redirect replacement ]

上下文: http, server, location

> 该指令可以修改请求的url,并进行转发, 默认值为`default`

示例:

> 原本的url: `http://localhost:8000/two/some/uri/`
>
> 现在的设置为: `proxy_redirect   http://localhost:8000/two/   http://frontend/one/;`
>
> 最后转发的结果为: `http://frontend/one/some/uri/`

总结: `proxy_redirect `指令可以将后面的前面的url拿后面的url进行替换

---

## Rewrite模块

该模块允许使用正则表达式改变URI，并且根据变量来转向以及选择配置。

如果在server级别设置该选项，那么他们将在location之前生效。如果在location还有更进一步的重写规则，location部分的规则依然会被执行。如果这个URI重写是因为location部分的规则造成的，那么location部分会再次被执行作为新的URI。

这个循环会执行10次，然后Nginx会返回一个500错误。

---

### break

语法: *break*

默认值: *none*

作用域: *server, location, if*

**退出当前的规则列**

示例:

```nginx
if ($slow) {
    limit_rate  10k;
    break;
}
```

---

### if

语法: *if (condition) { ... }*

默认: *none*

作用域: *server, location*

**检查条件的真实性。如果条件的值为true，则执行花括号中指示的代码，并按照下面块中的配置处理请求。配置内指令如果继承自上一级。**

示例:

```nginx
if ($http_user_agent ~ MSIE) {
: rewrite  ^(.*)$  /msie/$1  break;
}
if ($http_cookie ~* "id=([^;] +)(?:;|$)" ) {
: set  $id  $1;
}
if ($request_method = POST ) {
: return 405;
}
if (!-f $request_filename) {
: break;
: proxy_pass  http://127.0.0.1;
}
if ($slow) {
: limit_rate  10k;
}
if ($invalid_referer) {
: return   403;
}
```

---

### return

语法: return code url

上下文: server,location

> 用于返回给客户端的状态码和对应的文件

---

### rewrite

语法: *rewrite regex replacement [flag]*

默认: *none*

作用域: *server, location, if*

**这个指令根据表达式来更改URI，或者修改字符串。指令根据配置文件中的顺序来执行。**可以理解成是重定向

示例:

```nginx
rewrite ^/(.*) http://www.baidu.com/ permanent;     # 匹配成功后跳转到百度，执行永久301跳转
```

常用正则表达式：

| 字符      | 描述                                                         |
| --------- | ------------------------------------------------------------ |
| \         | 将后面接着的字符标记为一个特殊字符或者一个原义字符或一个向后引用 |
| ^         | 匹配输入字符串的起始位置                                     |
| $         | 匹配输入字符串的结束位置                                     |
| *         | 匹配前面的字符零次或者多次                                   |
| +         | 匹配前面字符串一次或者多次                                   |
| ?         | 匹配前面字符串的零次或者一次                                 |
| .         | 匹配除“\n”之外的所有单个字符                                 |
| (pattern) | 匹配括号内的pattern                                          |

rewrite 最后一项flag参数：

| 标记符号  | 说明                                               |
| --------- | -------------------------------------------------- |
| last      | 本条规则匹配完成后继续向下匹配新的location URI规则 |
| break     | 本条规则匹配完成后终止，不在匹配任何规则           |
| redirect  | 返回302临时重定向                                  |
| permanent | 返回301永久重定向                                  |

示例:

```nginx
# 添加个server区块做https跳转
server {　　　　　　　　　　　　　　　　　　
    listen     80;
    server_name  brian.com;
    rewrite ^/(.*) https://www.brian.com/$1 permanent;
}
# 添加个server区块做域名跳转
server {
    listen       80;
    server_name  brian.com;

    if ( $http_host ~* "^(.*)") {
        set $domain $1;
        rewrite ^(.*) http://www.baidu.com break;
    }     
}
```

---

### set

语法:*set variable value*

默认值:*none*

作用域:*server, location, if*

**指令为所指示的变量建立值。作为值，可以使用文本、变量及其组合。**

示例:

```nginx
if ($host ~* www\.(.*)) {
    set $host_without_www $1;
    rewrite ^(.*)$ http://$host_without_www$1 permanent; # $1 contains '/foo', not 'www.mydomain.com/foo'
}
```

## SSL模块

此模块支持HTTPS。

示例:

```nginx
http {
  server {
    server_name YOUR_DOMAINNAME_HERE;
    listen               443;
    ssl                  on;	# 为服务器启用HTTPS。
    ssl_certificate      /usr/local/nginx/conf/cert.pem; # 表示此虚拟服务器的密钥为PEM格式的文件,文件名路径相对于nginx配置文件nginx的目录。但不是nginx前缀目录。
    ssl_certificate_key  /usr/local/nginx/conf/cert.key; # 指示具有PEM格式证书CA的文件，用于检查客户端证书。
    keepalive_timeout    70;
  }
}
```



# nginx配置文件

```nginx
//配置工作进程,几个cpu就配几
worker_processes  1; 
events {
    //配置单个cpu的最大连接个数
    worker_connections  1024;  
}

//配置http(在http内server外的配置都属于server的全局配置,这个配置都是共同作用于多个server的)
//在http下可以有多个server配置
http { 
    include       mime.types;
    default_type  application/octet-stream;

    //定义日志的格式
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '    
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    
    //记录访问日志,最后的main是日志的格式
    access_log  logs/access.log  main; 

    sendfile        on;
    keepalive_timeout  65;
    
    //配置server(可以配置多个server)
    server { 
        listen       80; 			//监听的端口
        server_name  localhost; 	//地址,可以写ip,也可以写域名
            
        //资源的位置以及匹配的请求
        location / {  
            root   html;  			//资源位于哪个文件夹
            index  index.html index.htm;   //配置欢迎页
        }
    
        error_page   500 502 503 504  /50x.html;  //配置错误的页面
        location = /50x.html { 		//精准匹配
            root   html;
        }
    }
}
```

# 在租赁的服务器上默认nginx的配置

- nginx.conf配置文件在/etc/nginx下
  vim /etc/nginx/nginx.conf
- 资源文件目录在/usr/share/nginx下
- 日志文件目录在/var/log/nginx下
- nginx.pid文件在/run下
- 启动命令 : /usr/sbin/nginx
- 关闭命令 : /usr/sbin/nginx -s stop
- 重启命令 : /usr/sbin/nginx -s reload

# 调试nginx

## 将nginx的常用参数打印在页面上

```nginx
worker_processes  1;
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       7000;
        server_name  localhost;

        location / {
            default_type    text/html;
            return 200 
            '
            arg_name : $arg_name</br>
            hostname : $hostname</br>
            args : $args</br>
            content_length : $content_length</br>
            content_type : $content_type</br>
            document_root : $document_root</br>
            host : $host </br>
            http_user_agent : $http_user_agent</br>
            http_cookie : $http_cookie</br>
            limit_rate : $limit_rate</br>
            request_method : $request_method</br>
            remote_addr : $remote_addr</br>
            remote_port : $remote_port</br>
            remote_user : $remote_user</br>
            request_filename : $request_filename</br>
            scheme : $scheme</br>
            server_protocol : $server_protocol</br>
            server_addr : $server_addr</br>
            server_name : $server_name</br>
            server_port : $server_port</br>
            request_uri : $request_uri</br>
            uri : $uri</br>
            document_uri : $document_uri</br>
            ';
        }
    }
}

```

![1569254819744](D:\note\.img\1569254819744.png)

## nginx直接输出文本

```nginx
# 返回文本
location / {
    return 502 "服务正在升级，请稍后再试……";
}
# 返回文本
location / {
    default_type    text/plain;
    return 502 "服务正在升级，请稍后再试……";
}
# 返回html
location / {
    default_type    text/html;
    return 502 "服务正在升级，请稍后再试……";
}
# 返回json
location / {
    default_type    application/json;
    return 502 '{"status":502,"msg":"服务正在升级，请稍后再试……"}';
}
```

## 自己服务器上的配置

```nginx

worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server{
        listen  80;
        server_name luyingjie.cn;
        location / {
            proxy_pass   http://xxx.xxx.xxx.xxx:7999;
        }
    }

    server{
        listen  80;
        server_name mytodo.cn;
        location / {
            proxy_pass   http://xxx.xxx.xxx.xxx:8000;
        }
    }

    server{
        listen  80;
        server_name fileserver.top;
        location / {
            proxy_pass   http://xxx.xxx.xxx.xxx:8001;
        }
    }

    include servers/*;
}

```





# 参考文档

[nginx官方文档](http://nginx.org/en/docs/)

[nginx中文文档](http://www.Nginx.cn/doc/)

[nginx 反向代理](https://www.cnblogs.com/ysocean/p/9392908.html)

https://www.cnblogs.com/linuxws/p/10588156.html