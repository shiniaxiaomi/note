[TOC]

# 介绍

SSM框架是由Spring,SpringMVC和Mybatis三大框架组合而成的,这也是目前企业中比较流行的三个框架

Spring的核心是IOC和AOP,通过IOC容器可以管理很多的JavaBean,并可以维护JavaBean之间的相互依赖关系,通过AOP可以将代码解耦,我们通过Spring的两个核心功能,可以将SpringMVC和Mybatis两大框架进行整合,得到一个具有与数据库交互的持久层和使用了MVC设计模式的Web应用的一个框架,一般称为SSM框架

# 原理

1. Tomcat启动一个web项目时,会去读取web/WEB-INF下的web.xml文件,读取`<listener>`和`<context-param>`两个节点的内容

2. 接着,容器会根据`<context-param>`节点的配置文件内容创建一个SpringContext(被所有的Servlet共享,全局的,也称ServletContext),这个web项目的所有JavaBean都将共享这个上下文

   > 





web.xml中的配置分析:

1. Spring容器的初始化

   在启动web项目时,配置的

   Spring容器在初始化时,配置`ContextLoaderListener`监听器的作用就是启动web容器时,自动装配ApplicationContext的配置信息, 

2. SpringMVC容器的初始化

3. 创建Spring容器和SpringMVC容器的区别







# XML-Demo

# 注解-Demo



配置文件:

spring.xml:

> 公共共享的bean

1. spring的内容

   service层

2. 两个mybaits-spring整合的内容

   dao层(mapper),线程安全,因为SqlSessionTempalate

springmvc.xml

> 独有的bean

1. controller层,会产生线程不安全

# 参考文档

[csdn-博客](https://blog.csdn.net/a4019069/article/details/79507718)

[spring中的web上下文，spring上下文，springmvc上下文区别(超详细)](https://blog.csdn.net/crazylzxlzx/article/details/53648625) 

[ssm框架搭建流程及原理分析](https://www.cnblogs.com/MrRightZhao/p/7851565.html)