[TOC]

# 介绍

SpringMVC是目前主流的实现MVC设计模式的企业级开发框架,Spring框架的一个子模块,无需整合,开发起来更加快捷(需要使用到spring,即依赖spring)

MVC设计模式将应用程序分为Controller,Model,View三层,Cotroller接收客户端请求,调用Model生成业务数据,传递给View

SpringMVC就是对这套流程的封装,屏蔽了很多底层代码,开放出接口,让开发这可以更加轻松便捷的完成基于MVC模式的Web开发

# SpringMVC入门Demo

## 创建一个Java Web项目

使用idea创建一个Java Web项目

![1571579177965](D:\note\.img\1571579177965.png)

创建完项目后,idea会默认给你配置好tomcat跟要部署的文件和创建好项目的结构

> 前提是你在你的idea中配置过tomcat,如果没有,自行查询配置tomcat

接下来将使用maven去管理项目,那么就需要创建pom.xml文件,如图所示:

![1571580020454](D:\note\.img\1571580020454.png)

然后在pom文件上点击右键,选择`Add as Maven Project`即可将项目转换成maven项目,便于依赖管理,操作如图所示:

![1571580076853](D:\note\.img\1571580076853.png)

编辑pom文件,引入依赖

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.lyj</groupId>
    <artifactId>springmvcTest</artifactId>
    <version>1.0-SNAPSHOT</version>

    <dependencies>
        <!--spring相关依赖-->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
            <version>5.2.0.RELEASE</version>
        </dependency>
        <!--springmvc相关依赖-->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-webmvc</artifactId>
            <version>5.1.8.RELEASE</version>
        </dependency>
    </dependencies>
</project>
```

## 编写配置文件

### springmvc.xml

在src目录下创建`springmvc.xml`配置文件(也可以在resource目录下创建,只要是在项目根路径下创建即可)

```xml
<?xml version="1.0" encoding="utf-8" ?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-4.0.xsd
http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd">

    <!--开启注解扫描并扫描指定包下的bean-->
    <context:component-scan base-package="controller"/>

    <!--配置视图解释器:把handler返回的字符串解析成实际的物理视图地址-->
    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="prefix" value="/WEB-INF/views/"/>
        <property name="suffix" value=".jsp"/>
    </bean>
</beans>
```

springmvc.xml就相当于是配置了spring的上下文,在其中做了以下操作:

1. 开启注解扫描,并扫描指定包下的bean,将标有`@Controller`,`@Service`,`@Component`等注解的类添加到IOC容器中,Spring会管理这些bean
2. 配置视图解析器`InternalResourceViewResolver`,将handler中返回的字符串解析成实际的物理视图地址

### web.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
         version="3.1">

    <servlet>
        <servlet-name>springmvc</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <!--指定springmvc.xml配置文件-->
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>classpath:springmvc.xml</param-value>
        </init-param>
    </servlet>

    <!--拦截所有请求-->
    <servlet-mapping>
        <servlet-name>springmvc</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>

</web-app>
```

在web.xml中配置了以下内容:

1. 配置`DispatcherServlet`(前置控制器)

   它是整个流程控制的核心,所有交给它的请求都能够被它统一调度;

   在DispatchServlet中配置了contextConfigLocation参数,其值为springmvc.xml配置文件所在的路径,它的作用是可以将配置好路径的配置文件读取,并加载(springmvc.xml配置的就是spring的上下文,所以可以理解为spring就是在这个地方被加载的)

2. 配置`servlet-mapping`

   指定哪些url请求会被拦截,拦截之后会交给哪个servlet去处理这个请求

> 在上述的配置文件中,我将所有的请求都进行了拦截.然后全部转交给`DispatchServlet`处理,让它做统一调度

---

web.xml是很重要的配置文件,是项目启动的入口; 

Tomcat启动时会先读取web.xml文件;然后加载`DispatcherServlet`,并加载springmvc.xml,然后根据springmvc.xml配置文件进行初始化spring的上下文; 等tomcat启动完后,项目就会等待客户端的请求,当请求到达后,就会被配置的`servlet-mapping`拦截,转交给对应的servlet去处理(这里指的就是`DispatcherServlet`),然后就按照springmvc的流程往下走了

## 编写控制器(Controller)

在src下创建`controller.TestController`

```java
@Controller
public class TestController {
    @RequestMapping("/test")
    public String test() {
        return "success";//返回success页面
    }
}
```

## 创建视图(jsp)

在`WEB-INF`下创建`views`文件夹,并创建`success.jsp`文件

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
    success
</body>
</html>
```

## 启动项目

在启动项目的时候,我们需要去`Arifacts`选项卡中的`WEB-INF`下创建一个`lib`文件夹,然后把maven依赖的jar包导入到`lib`文件夹下

> 这样的目的是: 在项目编译完成之后,我们使用maven依赖的jar包也能被放到编译后的`WEB-INF/lib`目录下,这样项目才可以正常的访问(如果使用maven进行依赖管理,这一步很重要)

![1571582038423](D:\note\.img\1571582038423.png)

如果上述步骤操作完毕后,直接点击运行tomcat即可

---

**发起请求进行验证**

在浏览器端发起一个请求` http://localhost:8080/test `

那么就会看到一个success页面返回

![1571582370580](D:\note\.img\1571582370580.png)

# SpringMVC的核心组件

- DispatchServlet: 前置控制器,是整个流程控制的核心,控制其他组件的执行,进行统一调度,降低组件之间的耦合度,相当于总指挥
- HandlerMapping: DispatchServlet接收到请求后,通过HandlerMapping将不同的请求映射到不同的Handler
- Handler: 处理器,完成具体的业务逻辑,相当于Servlet或Action
- HandlerInterceptor: 处理器拦截器; 是一个接口,如果需要完成一些拦截处理,可以实现该接口
- HandlerExecutionChain: 处理器执行链; 包括两部分内容: Handler和HandlerInterceptor(系统会有一个默认的HandlerInterceptor,如果需要额外设置拦截,可以添加拦截器)
- HandlerAdapter: 处理器适配器; Handler执行业务方法之前,需要进行一系列的操作,包括表单数据的验证,数据类型的转换,将表单数据封装到Javabean等,这些操作都是由HandlerAdapter来玩车个的,开发者只需要将注意力集中在业务的处理上
- ModelAndView: 装载了模型数据和视图信息,作为Handler的处理结果,返回给DispatchServlet
- ViewResolver: 视图解析器; DispatchServlet通过它将逻辑视图解析为物理视图,最终将渲染结果响应给客户端

# SpringMVC的具体流程

![在这里插入图片描述](D:\note\.img\20190630145911981.png)

具体流程:

1. 浏览器发送请求--->`DispatchServlet`(前端控制器),前端控制器收到请求后自己不进行处理,而是将请求交给`HandlerMapping`(映射处理器)进行处理,他作为统一的访问点,进行全局的流程控制
2. `DispatchServlet`--->`HandlerMapping`,映射处理器会把请求映射为HandlerExecutionChain对象(包括了Handler处理器对象和多个HandlerInterceptor拦截器对象)
3. `DispatchServlet`--->`HandlerAdapter`,适配处理器将会把处理器包装为适配器,从而支持多种类型的处理器,级适配器设计模式的应用,从而很容易支持很多类型的处理器
4. `HandlerAdapter`--->调用`Handler`处理器,并返回一个`ModelAndView`对象(包含模型数据,逻辑视图)
5. `ModelAndView`对象--->`ViewResolver`(视图解析器),视图解析器把逻辑视图名解析为具体的`View`对象
6. `View`--->渲染,View会更具传进来的Model数据进行渲染,此处的Model实际是一个Map数据结构
7. 返回控制权给DispatchServlet,由DispatchServlet返回响应给用户,到此一个流程结束

更具体的流程图如下:

![img](D:\note\.img\1251492-20180705094400040-827941963.png)

# SpringMVC的线程安全

SpringMVC和Servlet一样也是线程不安全的

导致线程不安全的原因:

1. 由于SpringMVC默认的Controller都是Singleton(单例),所以如果存在全局变量时就容易导致线程不安全的问题

   > 线程安全问题其实归根结底就是数据共享的问题,每个线程都会有自己的工作内存,当定义了全局变量后,线程会读取全局变量保存到自己的工作内存中,这样多个线程中的变量就可能有各自修改的可能,导致数据的不一致

SpringMVC的Controller默认使用单例的优点:

1. 提高性能,不同每次创建Controller对象,减少了对象创建和垃圾收回的时间

2. 没有多例的必要

   在大多数情况下,我们很少需要考虑Controller的线程安全问题

   由于只有一个Controller实例.当多个线程同时调用它时,它的成员变量就是线程不安全的

怎么解决SpringMVC中的线程不安全的问题:

1. 在控制器中不适用成员变量和有状态的Javabean

2. 将控制器的作用域从单例(Singleton)改成原型(prototype),这样每次请求时都会创建一个新的Controller

   ```java
   @Scope("prototype") //添加@Scope注解,修改作用域
   @Controller
   public class TestController {
       @RequestMapping("/test")
       public String test() {
           return "success";//返回success页面
       }
   }
   ```

3. 在Controller中使用ThreadLocal变量

   ```java
   private ThreadLocal<Integer> count = new ThreadLocal<Integer>();
   ```

# ...(待完善)







# 参考手册

[Spring API官方文档](https://docs.spring.io/spring/docs/current/javadoc-api/)

# 参考文档

[官网文档](https://docs.spring.io/spring/docs/current/spring-framework-reference/web.html)

[csdn-博客](https://blog.csdn.net/litianxiang_kaola/article/details/79169148#commentsedit)