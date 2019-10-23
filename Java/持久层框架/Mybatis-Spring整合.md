[TOC]

# 简介

Mybatis-Spring会帮助你将Mybatis代码无缝的整合到Spring中; 

作用:

1. 它将允许Mybatis参与到Spring的事务管理之中
2. 创建映射器mapper和SqlSession并注入到bean中
3. 以及将Mybatis的异常转换为Spring的DataAccessException; 

最终,可以做到应用代码不依赖于Mybaits,Spring和Mybatis-Spring;

# 入门

本章将会以简略的步骤告诉你如何安装和配置Mybatis-Spring,并构建一个简单的具备事务管理功能的数据访问应用程序

## 安装

引入Mybatis-Spring的相关依赖即可进行安装

```xml
<dependency>
  <groupId>org.mybatis</groupId>
  <artifactId>mybatis-spring</artifactId>
  <version>2.0.3</version>
</dependency>
```

## 快速上手

要和Spring一起使用Mybaits,需要在Spring上下文定义至少两个东西: 

1. SqlSessionFactory

   在Mybaits-Spring中,可使用`SqlSessionFactoryBean`来创建`SqlSessionFactory`; 要配置这个`SqlSessionFactoryBean`,需要在Spring的xml配置文件中配置以下代码:

   ```xml
   <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
     <property name="dataSource" ref="dataSource" />
   </bean>
   ```

   > 需要在属性中配置好数据源

   或者是使用Java代码进行配置:

   ```java
   @Bean
   public SqlSessionFactory sqlSessionFactory() throws Exception {
     SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
     factoryBean.setDataSource(dataSource());
     return factoryBean.getObject();
   }
   ```

2. 至少一个数据映射器类

   假如已经定义了一个如下的mapper接口:

   ```java
   public interface UserMapper {
     @Select("SELECT * FROM users WHERE id = #{userId}")
     User getUser(@Param("userId") String userId);
   }
   ```

   那么可以通过 `MapperFactoryBean` 将接口加入到 Spring 中: 

   ```xml
   <bean id="userMapper" class="org.mybatis.spring.mapper.MapperFactoryBean">
       <property name="mapperInterface" value="org.mybatis.spring.sample.mapper.UserMapper" />
       <property name="sqlSessionFactory" ref="sqlSessionFactory" />
   </bean>
   ```

   > 注意:  所指定的映射器类**必须**是一个接口，而不是具体的实现类 
   >
   > 在这个示例中，通过注解来指定 SQL 语句，但是也可以使用 MyBatis 映射器的 XML 配置文件。 
   >
   > 配置好之后，你就可以像 Spring 中普通的 bean 注入方法那样，将映射器注入到你的业务或服务对象中。`MapperFactoryBean` 将会负责 `SqlSession` 的创建和关闭。如果使用了 Spring 的事务功能，那么当事务完成时，session 将会被提交或回滚。最终任何异常都会被转换成 Spring 的 `DataAccessException` 异常 

   

# SqlSessionFactoryBean

# 事务

# 使用SqlSession

# 注入映射器

# 使用SpringBoot

# 使用Mybaits API

# 使用Spring Batch

# 示例代码

# 参考文档

[Mybatis-Spring整合官方文档](https://mybatis.org/spring/zh/)



