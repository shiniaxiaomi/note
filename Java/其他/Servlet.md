[TOC]

# 介绍

Servlet是运行在Web服务器中的小型Java程序; Servlet通常使用Http(超文本传输协议)接收和相应来自Web客户端的请求

1. 接收浏览器发送过来的消息
2. 给浏览器返回消息; 浏览器认识html,而Servlet可以动态的生成html并返回用户

# 快速入门

1. 创建Java Web项目

   ![1571579177965](D:\note\.img\1571579177965.png)

   创建完项目后,idea会默认给你配置好tomcat跟要部署的文件和创建好项目的结构

   > 前提是你在你的idea中配置过tomcat,如果没有,自行查询配置Tomcat

   接下来将使用maven去管理项目,那么就需要创建pom.xml文件,如图所示:

   ![1571580020454](D:\note\.img\1571580020454.png)

   然后在pom文件上点击右键,选择`Add as Maven Project`即可将项目转换成maven项目,便于依赖管理,操作如图所示:

   ![1571580076853](D:\note\.img\1571580076853.png)

   编辑pom文件,引入servlet-api依赖(Servlet接口)

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>
   
       <groupId>com.lyj</groupId>
       <artifactId>servletTest</artifactId>
       <version>1.0-SNAPSHOT</version>
   
       <dependencies>
           <dependency>
               <groupId>javax.servlet</groupId>
               <artifactId>servlet-api</artifactId>
               <version>2.5</version>
           </dependency>
       </dependencies>
   </project>
   ```

2. 编写Servlet实现

   1. 实现Servlet接口(Servlet是一个接口规范,由sun公司定义)
   2. 把Servlet实现类部署到Tomcat中

   > sun公司定义了Servlet的规范,定义了Servlet应该有哪些方法,已经方法需要的参数:
   >
   > 1. 实现Servlet接口(javax.servlet.Servlet)
   > 2. 重写service方法(service方法每次请求都会被调用一次)

   ```java
   package servlet;
   
   import javax.servlet.*;
   import java.io.IOException;
   
   public class MyServlet implements Servlet {
       //当该Servlet被创建时就会执行该init方法
       public void init(ServletConfig servletConfig) throws ServletException {
           System.out.println("init");
       }
   
       public ServletConfig getServletConfig() {
           return null;
       }
   
       //当请求交给该Servlet去处理后,会执行该Servlet的service()方法,该方法会传入ServletRequest对象和ServletResponse对象
       //ServletRequest对象封装了url请求的一些的相关信息,可以很方便的从该对象中获取到
       //ServletResponse对象封装了该Servlet的返回给客户端的响应信息,你可以在service()方法中对其进行设置
       public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
           System.out.println("执行了service方法");
       }
   
       public String getServletInfo() {
           return null;
       }
   
       //当该Servlet销毁时会调用destroy()方法
       public void destroy() {
           System.out.println("destroy");
       }
   }
   
   ```

3. 在项目的WEB-INF下的web.xml中配置servlet的访问路径

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
            version="3.1">
   
       <!--定义名称为servletTest的servlet-->
       <servlet>
           <servlet-name>servletTest</servlet-name>
           <servlet-class>servlet.MyServlet</servlet-class>
       </servlet>
       
       <!--配置url映射,即将/test的请求交给名字为servletTest的servlet去处理-->
       <servlet-mapping>
           <servlet-name>servletTest</servlet-name>
           <url-pattern>/test</url-pattern>
       </servlet-mapping>
   </web-app>
   ```

   > 为什么在web.xml中配置好`servlet-mapping`映射就可以了呢?
   >
   > 在Tomcat启动时,会加载WEB-INF下的web.xml文件,并将其中配置的`servlet-mapping`映射数据进行处理,当客户端发送对应的请求到Tomcat服务器时,那么就会被Tomcat拦截,然后将请求进行封装成`ServletRequest`对象转交给对应的Servlet去处理,而这个Servlet就是我们在web.xml中已经指定好的对应的Servlet实现类

4. 启动Tomcat,并访问项目

   http://localhost:8080/test

   > 控制台输出结果:
   >
   > init
   > 执行了service方法

# Servlet原理解析

## Servlet的作用

对应浏览器端的请求做出对应的操作(可以是数据库操作或者其他操作)

## Servlet的工作原理

原理图如下:

![img](D:\note\.img\1251492-20180507132038095-966635725.jpg)

1. 在web.xml中配置好`servlet-mapping`和`servlet`的映射关系

   因为在Tomcat启动时,会加载WEB-INF下的web.xml文件,并将其中配置的`servlet-mapping`映射数据进行处理,当客户端发送对应的请求到Tomcat服务器时,那么就会被Tomcat拦截,然后将请求进行封装成`ServletRequest`对象转交给对应的`Servlet`去处理,而这个`Servlet`就是我们在web.xml中已经指定好的对应的`Servlet`实现类

2. 当第一次接收到用户的url请求时(**此时Servlet未创建**)

   在Tomcat项目启动时,并不会马上创建我们的Servlet, 当请求的url和我们在web.xml中配置的url映射一致时,那么该请求就会被Tomcat拦截,然后交由我们指定的Servlet处理

   因为Servlet还未被创建,所以Tomcat会加载对应的Servlet类,并进行实例化,然后调用该Servlet对应的init()方法

   初始化完成后,该Servlet还需要完成请求对应的处理,那么就会调用其service()方法,该方法会传入`ServletRequest`对象和`ServletResponse`对象,并对请求进行对应的处理,然后将请求后的数据返回给客户端

   > ServletRequest对象封装了url请求的一些的相关信息,可以很方便的从该对象中获取到
   >
   > ServletResponse对象封装了该Servlet的返回给客户端的响应信息,你可以在service()方法中对其进行设置

3. 当再次接收到用户的url请求时(**此时Servlet已创建**)

   因为此时的Servlet已经被实例化,那么就直接调用该Servlet对应的service()方法,然后将响应再返回给客户端

4. 当Servlet被销毁时

   当MyServlet被Tomcat容器销毁时,会被调用其`destroy()`方法,进行一些善后的处理

## Servlet的生命周期

1. 初始化Servlet,并调用inti()方法

   当服务器创建一个serlvet的时候，会去调用init方法。当我们第一次去访问一个servlet的时候，会去创建这个servlet对象。并且只会创建一次。如果配置了load-on-startup 表示服务器启动的时候就创建servlet实例。 

2. 调用Servlet中的service()方法,处理请求操作

   客户端每一次请求，都会去调用Servlet的servcie()方法。处理用户的请求。并且给其响应。

3. 销毁Servlet时,调用destroy()方法

   当服务器销毁一个servlet的时候，会调用其destory()方法(在服务器正常关闭时才会被调用)

## Servlet中重要的对象

### ServletConfig

 servlet配置对象

- 该对象的创建时间

  在创建完Servlet对象的时候,接着就会创建ServletConfig对象

- 如何得到该对象

  `ServletConfig config = this.getServletConfig(); `

- 通过ServletConfig对象可以获取到Servlet上下文对象

  `ServletContext servletContext = servletConfig.getServletContext();`

### ServletContext

 servlet的上下文对象 

- 创建时间

  加载web应用时创建ServletContext对象

- 如何得到该对象

  通过ServletConfig对象来获取

  `ServletContext servletContext = servletConfig.getServletContext();`

- 作用

  在一个web项目中共享数据,管理web项目资源,为整个web配置公共信息等

###  HttpServletRequest

请求对象 

当接收到用户的请求后,Tomcat会将url请求的相关信息封装成HttpServletRequest对象,并传入到Servlet的service()方法中,以便使用

###  HttpServletResponse

 响应对象 

Tomcat将返回给浏览器端的相关数据封装成HttpServletResponse对象,并传入Servlet的service()方法中,以便使用,当处理完请求后,会将其要返回的数据信息封装到HttpServletResponse对象中,返回给客户端

## Servlet的线程安全问题

### 引出线程不安全的问题

Servlet是线程不安全的; Servlet的生命周期是由Tomcat来维护的,当客户端第一次请求Servlet的时候,Tomcat会根据web.xml配置文件实例化servlet,当又有一个客户端访问该Servlet时,就不会再实例化该Servlet

当多个客户端并发访问同一个Servlet时,Web服务器会为每个客户端的请求创建一个线程,并在这个线程上调用Servlet的service()方法,因此service()方法如果访问了**同一个资源**的话,就有可能引发线程安全问题

> 这里的同一个资源指的是:
>
> 在该Servlet类中的全局变量,如static或public的成员变量,如果在该Servlet中使用到了这些全局变量,那么在多线程的环境下必然后造成数不一致的情况
>
> 但是在Servlet的service()方法中使用到的局部变量是不会产生该问题的,因为局部变量在每个线程中都会有一个备份,是不共享的,所以不会产生数据不一致的问题

### 解决方案

1. 如果某个Servlet实现了`SingleThreadModel`接口(是一个标记接口),那么Servlet引擎将会根据每个请求去都会产生一个对应的Servlet实例对象(只有实现了`SingleThreadModel`接口的Servlet才会是多实例),这样每个线程分别调用一个独立的Servlet实例对象,这样对于public的成员变量来说,就不会造成数据不一致的问题,但是对于static成员变量来说,还是存在线程不安全的问题,解决方法如下:
   1. 在service()方法中如果使用到了static成员变量,可以使用synchronized同步块或者使用对象锁来包裹static成员变量,使其在多线程访问时在同一时刻只能有一个线程改成该static成员变量
2. 因为上述第一种方法只能解决public变量的线程安全,而不能解决static变量的线程安全,而且还要付出多实例的代价,所以我们可以直接使用单例的Servlet对象,并且在static和public变量在service()方法中调用时加上synchronized同步块或加上对象锁即可,这样也能保证数据的一致性

### 总结

1. Servlet是线程不安全的,我们在使用全局变量的时候需要考虑到这个因素,可以使用synchronized同步块或对象锁来决解该问题

# 编写Servlet的三种方式

## 实现Servlet接口

```java
public class MyServlet implements Servlet {
    //当该Servlet被创建时就会执行该init方法
    public void init(ServletConfig servletConfig) throws ServletException {
        System.out.println("init");
    }

    public ServletConfig getServletConfig() {
        return null;
    }

    //当请求交给该Servlet去处理后,会执行该Servlet的service()方法,该方法会传入ServletRequest对象和ServletResponse对象
    //ServletRequest对象封装了url请求的一些的相关信息,可以很方便的从该对象中获取到
    //ServletResponse对象封装了该Servlet的返回给客户端的响应信息,你可以在service()方法中对其进行设置
    public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
        System.out.println("执行了service方法");
    }

    public String getServletInfo() {
        return null;
    }

    //当该Servlet销毁时会调用destroy()方法
    public void destroy() {
        System.out.println("destroy");
    }
}
```

## 继承GenericServlet抽象类

```java
public class MyServlet3 extends GenericServlet {
    public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
        System.out.println("service");
    }
}
```

## 继承HttpServlet类(常用)

```java
public class MyServlet2 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doGet(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doPost(req, resp);
    }

    @Override
    public void destroy() {
        super.destroy();
    }

    @Override
    public void init() throws ServletException {
        super.init();
    }
}
```

# 参考文档

[Servlet官方API文档](http://tomcat.apache.org/tomcat-5.5-doc/servletapi/)

[JavaWeb-Servlet-csdn博客](https://blog.csdn.net/qq_19782019/article/details/80292110)

[Tomcat的使用-servlet](https://blog.csdn.net/weixin_40396459/article/details/81706543#t28)

