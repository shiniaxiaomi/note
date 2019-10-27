[TOC]

# 介绍

SSM框架是由Spring,SpringMVC和Mybatis三大框架组合而成的,这也是目前企业中比较流行的三个框架

Spring的核心是IOC和AOP,通过IOC容器可以管理很多的JavaBean,并可以维护JavaBean之间的相互依赖关系,通过AOP可以将代码解耦,我们通过Spring的两个核心功能,可以将SpringMVC和Mybatis两大框架进行整合,得到一个具有与数据库交互的持久层和使用了MVC设计模式的Web应用的一个框架,一般称为SSM框架

# 原理

在xml项目中,使用`ContextLoaderListener`类来引导监听器启动和关闭Spring的根WebApplicationContext(Spring的根上下文);

所以,我们会在web.xml中配置`<listener>`标签来监听wen应用的启动

当web应用启动时,我们会加载`spring.xml`配置文件,来加载Spring的上下文,该上下文是被所有的Javabean共享的

> spring.xml中包含了Spring的上下文和Mybatis整合的内容
>
> 它会将Service层和Dao层(由Mybatis-Spring创建)的Javabean放入到spring的上下文中,这些bean是会被所有bean共享的(在Controller中共享,Dao使用了SqlSessionTemplate保证了线程安全,而Service可能会存在线程不安全问题)
>
> > 需要注意的是在Service中尽量不要创建和使用成员变量和静态变量,这样会导致Service层在多线程环境下数据不一致,即线程不安全
> >
> > 如果非要使用成员变量,可以使用ThreadLocal来解决

之后我们会在web.xml中配置DispatchServlet的初始化和映射,在DispatchServlet初始化时,会加载springmvc.xml,该文件会扫描Controller层,并将其放入到ServletContext(Servlet上下文)中,Controller层的Javabean只能被Servlet所共享

> ServletContext被称为子容器,而Spring的上下文被称为父容器,子容器可以读取父容器中的bean,而父容器不能读取子容器中的bean,所以父容器的bean是被所有Javabean共享的,而子容器的bean只能在子容器使用

在扫描完Controller层之后,将扫描后的url映射关系都交由DispatchServlet,他会统筹管理这些映射,当请求访问时,会先经过DispatchServlet,询问后找到对应的映射和对应处理的适配器,然后交由适配器去处理对应的请求,然后在返回响应给用户

---

SSM各自起到的作用:

- Spring: 将SpringMVC和Mybatis整合到一起,把所有的JavaBean的关系维护起来(Spring的核心IOC),然后解析注解,如@Transactional等注解,实现声明式事务(Spring的核心AOP),为我们的开发带来了极大的便利,并且没有代码入侵,而且可以随意的扩展
- SpringMVC: 采用了MVC的设计模式,将请求,模型和视图分离,实现了解耦; 它在多线程的环境下,Controller层会存在线程不安全的问题,详细的解决方法可以参考[SpringMVC中的线程安全问题](D:\note\Java\Spring\SpringFramework\SpringMVC.md#5.SpringMVC的线程安全)
- Mybatis: 它承担了和数据交互的任务,在和Spring整合的时候,通过Mybatis-Spring,将原本Mybatis默认的Mapper升级为通过SqlSessionTemplate来实现线程安全,即通过ThreadLocal可以保证每个线程拿到的Session都是不同的,保证了线程安全

---

在注解配置的项目中,通过Java配置类来实现去xml配置,但是这需要在Spring3.1之后才能够被支持; 从Spring 3.1开始，ContextLoaderListener支持通过ContextLoaderListener(WebApplicationContext)构造函数注入根web应用程序上下文，允许在Servlet 3.0+环境中编程配置; 

即我们无需再配置web.xml,而是编写一个Java类并实现`WebApplicationInitializer`接口的`onStartup()`方法,在web项目启动时,该`onStartup()`方法会被调用,从而在`onStartup()`中进行初始化对应的容器(Spring上下文和DispatchServlet上下文),初始化的步骤就和xml项目是基本一致的,这里就不多赘述了

# 基本的环境搭建

## 项目搭建

该项目环境为使用maven管理依赖,并配置好tomcat

> 该环境在XML-Demo中和注解-Demo中都需要使用到

1. 创建一个maven项目

   ![1572167797787](D:\note\.img\1572167797787.png)

   ![1572167828392](D:\note\.img\1572167828392.png)

2. 添加maven依赖(pom.xml文件)

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>
   
       <groupId>com.lyj</groupId>
       <artifactId>SSM-Annotation</artifactId>
       <version>1.0-SNAPSHOT</version>
   
       <dependencies>
           <!--spring依赖-->
           <dependency>
               <groupId>org.springframework</groupId>
               <artifactId>spring-context</artifactId>
               <version>5.1.3.RELEASE</version>
           </dependency>
   
           <!--mybatis依赖-->
           <dependency>
               <groupId>org.mybatis</groupId>
               <artifactId>mybatis</artifactId>
               <version>3.4.6</version>
           </dependency>
   
           <!--spring整合mybatis依赖-->
           <dependency>
               <groupId>org.mybatis</groupId>
               <artifactId>mybatis-spring</artifactId>
               <version>1.3.2</version>
           </dependency>
   
           <!--springMVC依赖-->
           <dependency>
               <groupId>org.springframework</groupId>
               <artifactId>spring-webmvc</artifactId>
               <version>5.1.3.RELEASE</version>
           </dependency>
   
           <!--mysql依赖-->
           <dependency>
               <groupId>mysql</groupId>
               <artifactId>mysql-connector-java</artifactId>
               <version>5.1.47</version>
           </dependency>
   
           <!--spring-jdbc依赖-->
           <dependency>
               <groupId>org.springframework</groupId>
               <artifactId>spring-jdbc</artifactId>
               <version>5.1.3.RELEASE</version>
           </dependency>
   
           <!--使得Controller中直接返回model序列化的结果-->
           <dependency>
               <groupId>com.fasterxml.jackson.core</groupId>
               <artifactId>jackson-databind</artifactId>
               <version>2.10.0</version>
           </dependency>
           
           <!--在纯注解-Demo中需要添加servlet-api 3.0+的依赖-->
           <dependency>
               <groupId>javax.servlet</groupId>
               <artifactId>javax.servlet-api</artifactId>
               <version>3.1.0</version>
               <scope>provided</scope>
           </dependency>
       </dependencies>
   
   </project>
   ```

3. 配置tomcat

   ![1572167924834](D:\note\.img\1572167924834.png)

   ![1572167955842](D:\note\.img\1572167955842.png)

   点击Fix按钮,然后点击下方的选项

   ![1572168052961](D:\note\.img\1572168052961.png)

   将右边的Maven依赖添加到Tomcat中

   ![1572168140593](D:\note\.img\1572168140593.png)

   在项目中创建web目录以及WEB-INF和web.xml等重要的文件

   > 我们可以通过idea自带的功能来自动创建,参考下图

   ![1572168890701](D:\note\.img\1572168890701.png)

   点击下方的按钮,然后点击OK即可自动创建web目录

   ![1572169013573](D:\note\.img\1572169013573.png)

   然后一步finish或next即可

4. 创建数据库表

   ```sql
   CREATE TABLE `user` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `name` varchar(20) DEFAULT NULL,
      `age` int(11) DEFAULT NULL,
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8
   ```

   并插入初始数据

   ```sql
   insert into `user` (`id`, `name`, `age`) values('1','A','1');
   insert into `user` (`id`, `name`, `age`) values('2','B','2');
   insert into `user` (`id`, `name`, `age`) values('3','C','3');
   insert into `user` (`id`, `name`, `age`) values('4','D','4');
   insert into `user` (`id`, `name`, `age`) values('5','E','5');
   ```

## 创建对应的每一层模型

### controller层

```java
package controller;

import model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import service.UserService;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    UserService userService;

    @RequestMapping("/selectUser")
    @ResponseBody
    public User selectUser(int id){
        User user = userService.selectUser(id);
        return user;
    }

    @RequestMapping("/updateUser")
    public String updateUser(String name,int id) throws Exception {
        boolean b = userService.updateUser(name, id);
        if(b){
            return "success";
        }else{
            return "failed";
        }
    }
}
```

### dao层

```java
package dao;

import model.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

@Mapper //标记是一个接口映射类
public interface UserMapper {
    @Update("update user set name=#{name} where id = #{id}")
    int updateUser(@Param("name") String name, @Param("id") int id);

    User selectUser(int id);//sql在xml中
}
```

### model层

```java
package model;

public class User{
    int id;
    String name;
    int age;

    //生成get和set方法才能在Controller中直接返回model序列化的结果
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }
}
```

### service层

```java
package service;

import dao.UserMapper;
import model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    @Transactional
    public boolean updateUser(String name,int id) throws Exception {
        int i = userMapper.updateUser(name, id);
        return i==1?true:false;
    }

    public User selectUser(int id){
        User user = userMapper.selectUser(id);
        return user;
    }

}
```

### mapper.xml映射文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<!-- 1.mapper:根标签; 2.namespace：命名空间,保证命名空间唯一即可 -->
<mapper namespace="dao.UserMapper">

    <select id="selectUser" parameterType="Integer" resultType="model.User">
        SELECT * from user where id=#{id}
    </select>

</mapper>
```

### 创建视图页面

failed.jsp

```html
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
失败
</body>
</html>
```

success.jsp

```html
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
成功
</body>
</html>
```

# XML-Demo

## 环境搭建-项目搭建

参考上一节的环境搭建-项目搭建

## 创建配置文件

### web.xml

该文件在创建web项目的时候就会被自动创建,所以我们编辑即可

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
         version="3.1">

    <!--监听启动时加载容器-->
    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

    <!--配置父容器(共享)-->
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:spring.xml</param-value>
    </context-param>

    <!--定义中央处理器DispatcherServlet-->
    <servlet>
        <servlet-name>DispatcherServlet</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <!--配置子容器(独享,子容器找不到bean会去父容器找)-->
        <!--指定springmvc.xml配置文件-->
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>classpath:springmvc.xml</param-value>
        </init-param>
        <!--在启动时就装配好该servlet,而并不是请求的时候才去创建-->
        <load-on-startup>1</load-on-startup>
    </servlet>

    <!--拦截所有请求-->
    <servlet-mapping>
        <servlet-name>DispatcherServlet</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>

    <!-- 编码过滤器 -->
    <filter>
        <filter-name>encoding</filter-name>
        <filter-class>
            org.springframework.web.filter.CharacterEncodingFilter
        </filter-class>
        <init-param>
            <param-name>encoding</param-name>
            <param-value>UTF-8</param-value>
        </init-param>
        <init-param>
            <param-name>forceEncoding</param-name>
            <param-value>true</param-value>
        </init-param>
    </filter>
    <filter-mapping>
        <filter-name>encoding</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

</web-app>
```

### spring.xml

在项目的根路径下创建该文件,用来配置spring的上下文,并将mybatis整合进来

> spring扫描的是Service层和Dao层(由Mybatis生成并放入Spring容器)

```xml
<?xml version="1.0" encoding="utf-8" ?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tx="http://www.springframework.org/schema/tx"
       xmlns:mybatis="http://mybatis.org/schema/mybatis-spring"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-4.0.xsd
http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx.xsd http://mybatis.org/schema/mybatis-spring http://mybatis.org/schema/mybatis-spring.xsd">

    <!--配置数据源-->
    <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
        <property name="driverClassName" value="com.mysql.jdbc.Driver"></property>
        <property name="url" value="jdbc:mysql://127.0.0.1:3306/test"></property>
        <property name="username" value="root"></property>
        <property name="password" value="123456"></property>
    </bean>

    <!--公共的service层-->
    <!--开启spring的注解扫描,扫描service层-->
    <context:component-scan base-package="service"/>

    <!--=========================Mybatis和Spring的整合========================-->
    <!--公共的Dao层-->
    <!--扫描标注有@Mapper的接口映射文件
    生成的Mapper对象里面会包含sqlSession(SqlSessionTemplate),mapperInterface(映射文件接口类)-->
    <mybatis:scan base-package="dao.**" />

    <!--注入sqlSessionFactory(Mybatis-Spring整合的核心,
    通过sqlSessionFactory来产生线程安全的sqlSession,即SqlSessionTemplate)-->
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <!--指定数据源-->
        <property name="dataSource" ref="dataSource" />
        <!--可以指定mybatis的配置文件,用来覆盖一些默认的配置-->
        <!--<property name="configLocation" value="classpath:mybatis-config.xml"></property>-->
        <!--指定mapper.xml映射文件路径-->
        <property name="mapperLocations" value="classpath:mappers/**/*.xml" />
    </bean>
    <!--============================================================-->

    <!--创建事务管理器-->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <constructor-arg ref="dataSource" />
    </bean>
    <!--开启spring事务,并指定事务管理器-->
    <tx:annotation-driven transaction-manager="transactionManager"/>
</beans>
```

### springmvc.xml

在项目的根路径下创建该文件,用来配置springmvc(Servlet)的上下文,该上下文不共享

> springmvc扫描的是Controller层

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-4.3.xsd
    http://www.springframework.org/schema/mvc
    http://www.springframework.org/schema/mvc/spring-mvc-4.3.xsd
    http://www.springframework.org/schema/context
    http://www.springframework.org/schema/context/spring-context-4.3.xsd">

    <!--扫描@Controller注解-->
    <context:component-scan base-package="controller"/>

    <!--配置视图解析器-->
    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="prefix" value="/WEB-INF/views/"/>
        <property name="suffix" value=".jsp"/>
    </bean>

    <!--开启mvc注解扫描(会扫描如@ResponseBody等)-->
    <mvc:annotation-driven/>

</beans>
```

## 创建对应的每一层

对应的目录结构:

![1572167190304](D:\note\.img\1572167190304.png)

[参考本文的环境搭建内容](D:\note\Java\Spring\Spring整合(SSM框架).md#3.2.创建对应的每一层模型)

## 启动项目

启动tomcat,并访问`http://localhost:8080/user/selectUser?id=1`

# 注解-Demo

## 环境搭建

参考上一节的环境搭建

## 创建配置类

在src目录下创建一个config目录,在config目录下分别创建以下两个个配置类和一个启动类:

1. WebInitializer.java(启动类)
2. SpringConfig.java(配置类)
3. SpringMVCConfig.java(配置类)

### WebInitializer替代web.xml文件

WebInitializer类实现了`WebApplicationInitializer`接口,可以看做是Web.xml的替代

> 当有了WebInitializer类后,在WEB-INF下的web.xml文件就无作用了,所有web.xml文件可删可不删

在加载Web项目的时候会加载WebApplicationInitializer接口实现类，并调用onStartup()方法

```java
package config;

import org.springframework.web.WebApplicationInitializer;
import org.springframework.web.context.ContextLoaderListener;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;
import org.springframework.web.servlet.DispatcherServlet;

import javax.servlet.ServletContext;
import javax.servlet.ServletRegistration;

//Webinitializer实现WebApplicationInitializer这个类的Onstartup方法，可以看做是Web.xml的替代
//它是一个接口，在其中可以添加Servlet，Listener等
//在加载Web项目的时候会加载WebApplicationInitializer接口实现类，并调用onStartup()方法
public class WebInitializer implements WebApplicationInitializer {

    //通过实现WebApplicationInitializer的onStartup()方法,来初始化Spring和DispatchServlet的上下文
    //该方法可以获取到servletContext
    public void onStartup(ServletContext container) {
        //创建根容器(Spring的上下文)
        AnnotationConfigWebApplicationContext rootContext = new AnnotationConfigWebApplicationContext();
        rootContext.register(SpringConfig.class);

        //添加监听器,管理根容器的生命周期
        container.addListener(new ContextLoaderListener(rootContext));

        //创建DispatchServlet的上下文
        AnnotationConfigWebApplicationContext dispatcherContext = new AnnotationConfigWebApplicationContext();
        dispatcherContext.register(SpringMVCConfig.class);

        //注册和映射DispatchServlet
        ServletRegistration.Dynamic dispatcher = container.addServlet("dispatcher", new DispatcherServlet(dispatcherContext));
        dispatcher.addMapping("/");
        dispatcher.setLoadOnStartup(1);
    }
}
```

### SpringConfig来替代spring.xml文件

该配置文件包含了Spring的上下文,并且整合了Mybatis

> 将Service层和Dao层(通过Mybatis-Spring扫描产生)的JavaBean保存在Spring上下文中,供所有类使用(全部共享)

```java
package config;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;

@Configuration
@ComponentScan("service") //开启spring的注解扫描,扫描service层
@MapperScan("dao") //扫描标注有@Mapper的接口映射文件,通过Mybatis-Spring扫描并创建bean
@EnableTransactionManagement //开始事务注解
public class SpringConfig {

    //配置数据源
    @Bean
    public DataSource dataSource(){
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        dataSource.setUrl("jdbc:mysql://127.0.0.1:3306/test");
        dataSource.setUsername("root");
        dataSource.setPassword("123456");
        return dataSource;
    }


    //配置sqlSessionFactory(Mybatis-Spring整合的核心)
    //通过sqlSessionFactory来产生线程安全的sqlSession,即SqlSessionTemplate)
    @Bean
    public SqlSessionFactory sqlSessionFactory() throws Exception {
        SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
        factoryBean.setDataSource(dataSource());

        // 指定并设置xml映射文件路径
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        factoryBean.setMapperLocations(resolver.getResources("classpath:mappers/**/*.xml"));

        return factoryBean.getObject();
    }


    //配置事务管理器
    @Bean
    public DataSourceTransactionManager transactionManager(){
        DataSourceTransactionManager transactionManager = new DataSourceTransactionManager();
        transactionManager.setDataSource(dataSource());
        return transactionManager;
    }

}
```

### SpringMVCConfig来替代springmvc.xml文件

该配置文件包含了DispatchServlet的上下文

```java
package config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

@Configuration
@ComponentScan("controller") //扫描@Controller注解
@EnableWebMvc //开启mvc注解(会扫描如@ResponseBody等)
public class SpringMVCConfig {

    //配置视图解析器
    @Bean
    public ViewResolver internalResourceViewResolver(){
        InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();
        viewResolver.setPrefix("/WEB-INF/views/");
        viewResolver.setSuffix(".jsp");
        return viewResolver;
    }
}
```

## 创建对应的每一层

对应的目录结构:

![1572187364808](D:\note\.img\1572187364808.png)

[参考本文的环境搭建内容](D:\note\Java\Spring\Spring整合(SSM框架).md#3.2.创建对应的每一层模型)

## 启动项目

启动tomcat,并访问`http://localhost:8080/user/selectUser?id=1`

# 参考文档

[csdn-博客](https://blog.csdn.net/a4019069/article/details/79507718)

[spring中的web上下文，spring上下文，springmvc上下文区别(超详细)](https://blog.csdn.net/crazylzxlzx/article/details/53648625) 

[ssm框架搭建流程及原理分析](https://www.cnblogs.com/MrRightZhao/p/7851565.html)

[SSM框架整合基于JavaConfig配置方式](https://blog.csdn.net/qq_22067469/article/details/82253194)