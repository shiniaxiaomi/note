[TOC]

# 介绍

SSM框架是由Spring,SpringMVC和Mybatis三大框架组合而成的,这也是目前企业中比较流行的三个框架

# 原理

Springe

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