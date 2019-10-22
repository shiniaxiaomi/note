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

# SpringMVC核心内容

- DispatchServlet: 前置控制器,是整个流程控制的核心,控制其他组件的执行,进行统一调度,降低组件之间的耦合度,相当于总指挥
- HandlerMapping: DispatchServlet接收到请求后,通过HandlerMapping将不同的请求映射到不同的Handler
- Handler: 处理器,完成具体的业务逻辑,相当于Servlet或Action
- HandlerInterceptor: 处理器拦截器; 是一个接口,如果需要完成一些拦截处理,可以实现该接口
- HandlerExecutionChain: 处理器执行链; 包括两部分内容: Handler和HandlerInterceptor(系统会有一个默认的HandlerInterceptor,如果需要额外设置拦截,可以添加拦截器)
- HandlerAdapter: 处理器适配器; Handler执行业务方法之前,需要进行一系列的操作,包括表单数据的验证,数据类型的转换,将表单数据封装到Javabean等,这些操作都是由HandlerAdapter来玩车个的,开发者只需要将注意力集中在业务的处理上
- ModelAndView: 装载了模型数据和视图信息,作为Handler的处理结果,返回给DispatchServlet
- ViewResolver: 视图解析器; DispatchServlet通过它将逻辑视图解析为物理视图,最终将渲染结果响应给客户端

## DispatchServlet

和许多其他Web框架一样,SpringMVC也是围绕前端控制器模式设计的,其中中央的Servlet是DispatchServlet,它负责请求的同一转发(转发给其他委托组件去处理)

与其他Servlet一样,DispatchServlet也需要使用Java配置或web.xml配置Servlet的映射规则; 然后DispatchServlet使用Spring配置来发现请求映射,视图解析异常处理等所需要的委托组件

下面是使用web.xml来配置DispatchServlet:

```xml
<web-app>

    <!-- 配置上下文启动时的监听器 -->
    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

    <!-- 加载父容器的上下文配置文件 -->
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>/WEB-INF/spring.xml</param-value>
    </context-param>

    <!-- 配置DispatchServlet -->
    <servlet>
        <servlet-name>app</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <!-- 将父容器的上下文设置为自己的上下文 -->
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value></param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>

    <!-- 拦截所有请求,转交给DispatchServlet处理 -->
    <servlet-mapping>
        <servlet-name>app</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>

</web-app>
```

### 上下文的层级

在DispatchServlet中,可以配置多个上下文,从而构建成上下文的父子关系

在父容器中,通常包含基础设施bean，比如需要共享的Service和Dao; 

而对于DispatchServlet中,都会有一个自己的子容器配置,该子容器是该实例所独有的,并且该实例也可以访问到父容器中的bean(现在子容器找,如果没找到,则去父容器找)

> 为什么要将将容器分割成多个容器(父容器和多个子容器)?
>
> 因为父容器中保存是大家所共享的bean,所以只需要一份即可
>
> 而每个DispatchServlet中的子容器来说,他们是相互独立的,他们没有共性的地方需要被引用,所以被分开

上下文的层级关系图如下:

![mvc context hierarchy](D:\note\.img\mvc-context-hierarchy.png)

> 根容器保存一些公共的bean,这些bean可以共享使用,可以被子容器访问;
>
> 而子容器的内容是不能被根容器所访问的,是子容器独享的,如Controller等

下面使用web.xml配置多个上下文容器的示例:

```xml
<web-app>

    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

    <!-- 配置父容器 -->
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>/WEB-INF/root-context.xml</param-value>
    </context-param>

    <!-- 配置DispatchServlet -->
    <servlet>
        <servlet-name>app1</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <!-- 配置子容器 -->
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>/WEB-INF/app1-context.xml</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>

    <servlet-mapping>
        <servlet-name>app1</servlet-name>
        <url-pattern>/app1/*</url-pattern>
    </servlet-mapping>

</web-app>
```

> 如果不需要应用程序上下文层次结构(即多个上下文)，那么应用程序可能只配置一个“根”上下文，而将Servlet参数中的上下文设置为空即可。

### 其他特殊的bean

这些特殊的bean会被DispatchServlet发现并注册到IOC容器中

DispatchServlet会将请求转发给以下的bean去处理

#### HandlerMapping

将请求映射到对应的handler,并且映射到一个前置拦截器和后置拦截器的一个列表。映射基于一些标准，其细节因HandlerMapping实现而异。

两个主要的HandlerMapping实现是:

- RequestMappingHandlerMapping(它支持@RequestMapping注释的方法)
- simpleUrlHandlerMapping(它用于将url直接映射到视图)。

#### HandlerAdapter

帮助DispatcherServlet调用映射到请求的处理程序，不考虑处理程序的实际调用方式。例如，nvoking带注释的控制器需要解析注释。HandlerAdapter的主要目的是保护Dispatcherservlet不受这些细节的影响。

#### ViewResolver 

将从处理程序返回的基于逻辑字符串的视图名称解析为要呈现给响应的实际视图。

#### ...

### Web MVC Config

在这里可以配置一些特殊的bean用来处理请求,如果没有在这里配置,那么DispatchServlet会为我们初始化默认配置好的所需要的用来处理请求的bean,如InterceptorViewResolver等我们需要自定义的bean

> 该文件是用来覆盖默认的bean的,如果我们有需要配置我们自定义功能的用于处理请求的bean,如:
>
> 一般我们会配置InterceptorViewResolver来自定义返回的视图路径
>
> ```xml
> <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
>     <property name="prefix" value="/WEB-INF/views/"/>
>     <property name="suffix" value=".jsp"/>
> </bean>
> ```

### Servlet Config

我们可以把servlet的配置直接写在web.xml中

如:

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

web.xml文件是一个启动的入口,程序加载web.xml配置文件后

- web.xml会加载`context-param`标签中的配置文件,他作为一个父容器而存在

- 加载DispatchServlet,DispatchServlet会进而加载配置了它参数的对应的配置文件,当作它的子容器(DispatchServlet也可以直接将父容器当作自己的容器)

### url请求的处理过程

DispatchServlet对url请求的处理过程如下:

- 寻找合适的处理程序。如果找到处理程序，则执行与处理程序(前处理器、控制器和后处理器,按顺序执行)关联的执行链，以便准备模型或呈现。另外，对于带注释的控制器，可以(在HandlerAdapter中)呈现响应，而不是返回视图。

- 如果返回模型，则呈现视图。如果没有返回模型(可能是由于预处理程序或后处理程序拦截了请求，也可能是出于安全原因)，就不会呈现视图，因为请求可能已经被满足了。

我们可以通过向web.xml文件中的Servlet声明添加Servlet初始化参数(init参数元素)来定制各个Dispatcherservlet实例。下表列出了支持的参数:

- contextConfigLocation 

  传递给上下文实例(由contextclass指定)的字符串，以指示在何处可以找到上下文。字符串可能由多个字符串(使用逗号作为分隔符)组成，以支持多个上下文。对于定义了两次的多个上下文位置的bean，最新位置优先。

- contextClass 

  类实现ConfigurablewebApplicationContext，由这个Servlet实例化并在本地配置。

  默认情况下，使用XmlwebApplicationContext。

- namespace 

  WebApplicationContext的名称空间。默认为[servlet-name]-servlet

- throwExceptionIfNoHandlerFound 

### 拦截器

所有HandlerMapping实现都支持处理程序拦截器，当我们希望将特定功能应用于特定请求时，这些拦截器非常有用

例如，检查主体等。拦截器必须从`org.springframe.web`实现`HandlerInterceptor`接口。servlet包有三种方法，可以提供足够的灵活性来进行各种预处理和后处理:

- `preHandle(..)`:  在实际的处理程序执行之前执行
- `postHandle(..)`:  在实际的处理程序执行之前后执行
- `afterCompletion(..)`:  完成完整的请求后执行

preHandle(..)方法返回一个布尔值。您可以使用此方法中断或继续执行链的处理。当此方法返回true时，处理程序执行链将继续。当它返回false时，DispatcherServlet假设拦截器本身已经处理了请求，并且没有继续执行执行链中的其他拦截器和实际的处理程序。

> 注意，postHandle在@ResponseBody和ResponseEntity方法中不太有用，因为响应是在HandlerAdapter中写入并提交的，而且是在postHandle之前。这意味着对响应进行任何更改都太晚了，比如添加额外的标题。对于这样的场景，您可以实现ResponseBodyAdvice，或者将它声明为控制器通知bean，或者直接在RequestMappingHandlerAdapter上配置它

### 异常

如果在请求映射期间发生异常，或者从请求处理程序(例如@controller)抛出异常，Dispatcherservlet将委托给`HandlerExceptionResolver` 来解决异常并提供替代处理，这通常是一个错误响应。

### 视图解析器

Spring MVC定义了ViewResolver和View接口，它们允许您在浏览器中呈现模型，而不必将您绑定到特定的视图技术。ViewResolver提供了视图名称和实际视图之间的映射。视图处理数据在移交给特定视图技术之前的准备工作。

## Filters

 spring-web模块提供了一些有用的过滤器: 

- Form Data

  进行url参数的绑定

- Forwarded Headers

- Shallow ETag

- CORS

## 注解Controller

Spring MVC提供了一个基于注释的编程模型，其中@controller和@RestController使用注释来表示请求映射、请求输入、异常处理等。带注释的控制器具有灵活的方法签名，不需要扩展基类或实现特定的接口。下面的例子展示了一个由注解定义的控制器:

```java
@Controller
public class HelloController {
    @GetMapping("/hello")
    public String handle(Model model) {
        model.addAttribute("message", "Hello World!");
        return "index";
    }
}
```

### 声名注解

您可以在Servlet的WebApplicationContext中使用标准的Spring bean定义来定义控制器bean。@Controller注解将会自动检测，与Spring一般支持的在类路径中检测@Component类以及为它们自动注册bean定义相一致。您可以将组件扫描添加到您的Java配置中，如下面的示例所示:

```java
@Configuration
@ComponentScan("org.example.web")
public class WebConfig {

    // ...
}
```

或者使用xml的方式开启

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:p="http://www.springframework.org/schema/p"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        https://www.springframework.org/schema/context/spring-context.xsd">

    <context:component-scan base-package="org.example.web"/>

</beans>
```

### Request Mapping

可以使用@RequestMapping注释将请求映射到控制器方法。它有各种属性，可以根据URL、HTTP方法、请求参数、标题和媒体类型进行匹配。您可以在类级使用它来表示共享映射，或者在方法级使用它来缩小到特定端点映射。

## Controller中的方法

### 方法参数

### 方法返回值

### 类型转换

### @RequestParam 

### @RequestHeader

### @CookieValue 

### @SessionAttributes 

直接获取session中的对象

```java
@RequestMapping("/")
public String handle(@SessionAttribute User user) { 
    // ...
}
```

### @RequestAttribute 

### Redirect Attributes

在进行转发后的变量可以继续使用

```java
@PostMapping("/files/{path}")
public String upload(...) {
    // ...
    return "redirect:files/{path}";
}
```

### @RequestBody 

### @ResponseBody 

```java
@GetMapping("/accounts/{id}")
@ResponseBody
public Account handle() {
    // ...
}
```

### ResponseEntity

```java
@GetMapping("/something")
public ResponseEntity<String> handle() {
    String body = ... ;
    String etag = ... ;
    return ResponseEntity.ok().eTag(etag).build(body);
}
```

### JSON Views 

```java
@RestController
public class UserController {

    @GetMapping("/user")
    @JsonView(User.WithoutPasswordView.class)
    public User getUser() {
        return new User("eric", "7!jd#h23");
    }
}

public class User {

    public interface WithoutPasswordView {};
    public interface WithPasswordView extends WithoutPasswordView {};

    private String username;
    private String password;

    public User() {
    }

    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }

    @JsonView(WithoutPasswordView.class)
    public String getUsername() {
        return this.username;
    }

    @JsonView(WithPasswordView.class)
    public String getPassword() {
        return this.password;
    }
}
```

## Model

## 数据绑定器

## Exceptions

可以指定抛出抛出异常后有哪个类去同一处理这个异常

## Asynchronous Requests

## CORS(跨域)

## MVC Config

### Enable MVC Configuration

在Java配置中，可以使用@EnablewebMvc注释来启用MVC配置，如下例所示:

```java
@Configuration
@EnableWebMvc
public class WebConfig {
}
```

 在XML配置中，可以使用`mvc:annotation-driven`元素来启用mvc配置，如下例所示: 

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:mvc="http://www.springframework.org/schema/mvc"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/mvc
        https://www.springframework.org/schema/mvc/spring-mvc.xsd">

    <mvc:annotation-driven/>

</beans>
```

### MVC Config API

 在Java配置中，您可以实现WebMvcConfigurer接口，如下面的示例所示: 

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    // Implement configuration methods...
}
```

### Interceptors

在Java配置中，您可以注册拦截器来应用于传入的请求，如下面的示例所示:

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LocaleChangeInterceptor());
        registry.addInterceptor(new ThemeChangeInterceptor()).addPathPatterns("/**").excludePathPatterns("/admin/**");
        registry.addInterceptor(new SecurityInterceptor()).addPathPatterns("/secure/*");
    }
}
```

 下面的例子展示了如何在XML中实现相同的配置: 

```xml
<mvc:interceptors>
    <bean class="org.springframework.web.servlet.i18n.LocaleChangeInterceptor"/>
    <mvc:interceptor>
        <mvc:mapping path="/**"/>
        <mvc:exclude-mapping path="/admin/**"/>
        <bean class="org.springframework.web.servlet.theme.ThemeChangeInterceptor"/>
    </mvc:interceptor>
    <mvc:interceptor>
        <mvc:mapping path="/secure/*"/>
        <bean class="org.example.SecurityInterceptor"/>
    </mvc:interceptor>
</mvc:interceptors>
```

### View Controllers

这是定义一个ParameterizableViewController的快捷方式，它在调用时立即转发到视图。如果在视图生成响应之前没有要执行的Java控制器逻辑，您可以在静态情况下使用它。

下面的Java配置示例将一个对/的请求转发给一个名为home的视图: 

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/").setViewName("home");
    }
}
```

 下面的示例实现了与前面的示例相同的功能，但是使用的是XML，使用的是`mvc:view-controller`元素: 

```xml
<mvc:view-controller path="/" view-name="home"/>
```

### Static Resources

此选项提供了一种方便的方式来从基于资源的位置列表中提供静态资源。

在下一个示例中，给定一个以/resources开始的请求，相对路径用于在web应用程序根目录下或在/static类路径下查找和提供相对于/public的静态资源。这些资源有一年的有效期，以确保最大限度地使用浏览器缓存并减少浏览器发出的HTTP请求。最后修改的标头也会被计算，如果有，则返回304状态码。

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/resources/**")
            .addResourceLocations("/public", "classpath:/static/")
            .setCachePeriod(31556926);
    }
}
```

 下面的例子展示了如何在XML中实现相同的配置: 

```xml
<mvc:resources mapping="/resources/**"
    location="/public, classpath:/static/"
    cache-period="31556926" />
```

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

总结:

1. 在`@Controller`/`@Service`注解的类中,scope值是默认是(singleton)单例的,是线程不安全的。
2. 尽量不要在`@Controller`/`@Service`注解的类中定义静态变量，不论是单例(singleton)还是多实例(prototype),都是线程不安全的。
3. 默认注入的Bean对象(如果该对象的状态是不确定的话,即会被修改和查询),在不设置scope为原型(prototype)的时候也是线程不安全的。
4. 如果一定要定义变量的话，用ThreadLocal来封装，这个是线程安全的

---

当DispatchServlet在做转发的时候,实现线程安全的:

在由spring管理的下,所有的servlet在IOC容器初始化的时候都已经加载完毕,包含这个最重要的DispatchServlet

DispatchServlet在多个用户同时访问的情况下,每个用户的请求都会起一个线程来进行访问web服务,但是web服务中DispatchServlet是单例的,那么多个线程都会使用同一个DispatchSevlet进行请求的转发,但是在DispatchServlet转发的过程中,并没有涉及到修改数据的内容,而都是进行查询映射,查询handler,使用反射调用方法,new一个参数对象并设值,这些操作都不会导致多线程中的数据不一致(大部分是查询的,不会有线程不安全的问题;还有一个是new对象并设置,这个操作是每个线程都会new一个各自对应的对象并设置,所以也不会冲突),所以在用户并发访问导致多线程请求时,在DispatchServlet进行转发时,是不会造成线程不安全的问题的

# SpringMVC源码解析

...

# 参考手册

[Spring API官方文档](https://docs.spring.io/spring/docs/current/javadoc-api/)

# 参考文档

[官网文档](https://docs.spring.io/spring/docs/current/spring-framework-reference/web.html)

[csdn-博客](https://blog.csdn.net/litianxiang_kaola/article/details/79169148#commentsedit)