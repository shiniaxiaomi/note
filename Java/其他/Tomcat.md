[TOC]

# 介绍

Tomcat服务器是一个开源的轻量级Web应用服务器,在中小型系统和并发量肖的场合下被普遍使用; 它是一个Servlet容器; 

Tomcat和Servlet的关系如图所示:

![img](D:\note\.img\1251492-20180507132038095-966635725.jpg)

# 快速入门

## 下载安装

1. [Tomcat9下载链接](https://tomcat.apache.org/download-90.cgi)

2. 下载安装后解压即可

3. 配置Java环境变量

4. 启动Tomcat

   在window系统中直接双击在bin目录下的startup.bat即可启动

5. 访问服务

   http://localhost:8080/

   看到一只三只脚的猫即成功

   ![1571623061231](D:\note\.img\1571623061231.png)

## 快速配置

配置Tomcat的启动端口

1. 找到Tomcat安装目录下的conf/server.xml文件

2. 找到8080端口,修改port的值,将port端口的值修改为80端口

   ![1571624164175](D:\note\.img\1571624164175.png)

3. 重启Tomcat

4. 访问服务

   http://127.0.0.1/

## 快速部署

共有以下几种方式:

1. 修改Tomcat目录下的conf/server.xml配置文件

   找到Host标签

   ![1571624585757](D:\note\.img\1571624585757.png)

   在Host标签内添加一下内容

   ```xml
   <Context  path="/lyj"  docBase="D:\lyj"/>
   ```

   > path:  浏览器要访问的目录---虚拟目录 
   >
   > docBase:  网站所在磁盘目录 

   重启Tomcat即可

   > 如果要实验的话,可以在D盘创建lyj文件夹,并将Tomcat安装目录下的`webapps`文件夹下的任意项目拷贝一份当到`lyj`文件夹下即可
   >
   > 如:
   >
   > ![1571624918230](D:\note\.img\1571624918230.png)
   >
   > 重启项目访问: http://localhost:8080/lyj/examples/即可

   缺点(Tomcat7.0之后): 如果配置错误,Tomcat会启动失败(如果Tomcat中还有其他的项目,会导致其他项目也无法被启动) 

2. 将网站目录复制到Tomcat安装目录下的`webapps`目录下

   一个文件夹就对应一个网站项目

   文件夹的名字就是访问的url,相当于之前使用`Context`标签配置的`path`参数是一样的

3. 把网站目录压缩成war包部署到Tomcat中

   war包: 就是一个压缩文件

   把我们的项目进行压缩成zip,然后修改后缀为`.war`,再把war文件拷贝到Tomcat安装目录下的`webapps`目录下即可,在Tomcat启动时,会自动将该war包进行解压之后部署

# Tomcat原理

## 概述

Tomcat主要组件：服务器Server，服务Service，连接器Connector、容器Container。连接器Connector和容器Container是Tomcat的核心。 

Tomcat结构图:

![img](D:\note\.img\20180308114704839.png)

一个Container容器和一个或多个Connector组合在一起，加上其他一些支持的组件共同组成一个Service服务，有了Service服务便可以对外提供能力了，但是Service服务的生存需要一个环境，这个环境便是Server，Server组件为Service服务的正常使用提供了生存环境，Server组件可以同时管理一个或多个Service服务。

对应流程描述的流程图如下所示:

![img](D:\note\.img\20161106234422066)

## Tomcat组件

### Connector

### Container

### 其他组件

## server.xml配置

Tomcat各组件的关系图:

![img](D:\note\.img\2018031313095610.png)

### Server

### Listener 

### GlobalNamingResources

### Service

### Executor

### Connector

### Engine

### Host 

### Context

### Cluster

### Realm

### Valve

# Tomcat日志

## 日志概述

## 日志级别

##  系统日志 

##  控制台日志 

# 发布和优化

## 发布的三种方式

##  加载JVM配置 





# 参考文档

[Tomcat9官方文档](http://tomcat.apache.org/tomcat-9.0-doc/index.html)

[csdn-博客1](https://blog.csdn.net/weixin_40396459/article/details/81706543)

csdn-博客2

- [简介](https://blog.csdn.net/u014231646/article/details/79482195)
- [server.xml配置](https://blog.csdn.net/u014231646/article/details/79535925)
- [日志](https://blog.csdn.net/u014231646/article/details/79525071)
- [发布和优化](https://blog.csdn.net/u014231646/article/details/79539709)