[TOC]

# 事务的基本原理

Spring事务的本质其实就是数据库对事务的支持,使用[JDBC](D:\note\Java\数据库\JDBC.md)的事务管理机制,就是利用java.sql.Connection对象完成对事务的提交,那在没有Spring帮我们管理事务之前,我们要这么做:





# 参考文档

[官方文档](https://docs.spring.io/spring/docs/5.2.0.RELEASE/spring-framework-reference/data-access.html#transaction)

[博客参考](https://blog.csdn.net/trigl/article/details/50968079)