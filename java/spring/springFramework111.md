[TOC]

# 概述

spring framework的核心是配置模型(AOP)和依赖注入(IOC),除此之外,spring framework还提供了基础服务,包括消息传递,事务处理和基于servlet的web服务框架(包含了springmvc和响应式的webFlux框架)

## spring和J2EE的关系

spring为了简化J2EE的开发而诞生的,spring遵循了J2EE的部分规范

- Servlet API 
- WebSocket API
- Concurrency Utilities (并发工具包)
- JSON Binding API 
- Bean Validation (校验)
- JPA 
- JMS (消息服务)

spring framework还遵循了IOC和AOP规范,我们可以根据我们的需要进行替换具体的实例

## servlet container 

springboot内嵌了tomcat容器,使得创建项目更加的快捷和便利,而且我们也可以根据我们的需要进行替换servlet容器,甚至于可以不是一个servlet容器(如netty)

## 设计理念

- 在每一个层级上都给用户提供回调的函数

  spring允许我们推迟决策,例如通过配置文件来修改属性,从而不会变动代码; 在其他基础设施上和第三方api的集成上也如此

- 容纳不同的观点

  spring非常的灵活,可以支持不同的应用场景

- 具有强大的向后兼容性

  spring的每个版本都会给我们选好对应的jdk版本和第三方库的版本

- 关心api接口的设计

- 为代码质量设置高标准,具有有意义的,最新和准确的javadoc

# Core

spring最重要的两个核心技术是IOC(控制反转)和AOP(面向切面)

- IOC在spring框架中起到了承上启下的作用,包括对于AOP来说,都需要使用到IOC
- spring framework有自己的AOP框架,它在概念上易于理解,并且能够解决80%的面向切面的编程需求

spring还提供了与AspectJ的AOP框架集成的接口,能够无缝的进行切换

## [IOC Container](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#beans)

### 简介 the Spring IoC Container and Beans

bean: 由spring容器管理的对象成为bean;它是由spring IoC容器实例化,组装和管理的对象,bean之间的依赖关系也由spring Ioc容器进行管理

ioc的原理: 通过构造函数参数,工厂方法的参数或在构造函数和工厂方法返回后的对象来设置bean的依赖关系,容器在创建bean时将其依赖注入



`org.springframework.beans`和`org.springframework.context`包是Spring Framework的IoC容器的基础

`BeanFactory`接口提供了一种能够产生任何对象的高级配置机制,`ApplicationContext`是`BeanFactory`的子接口。

`ApplicationContext`:

- 更容易和AOP集成
- 更好的国际化
- 利于事件发布(回调)
- 特定与应用层的上下文,如`WebApplicationContext`,用于web应用程序

简单的说,`BeanFactory`是一个非常抽象的类,提供了框节配置和基本功能,而`ApplicationContext`则是它的一个子类,针对一些特殊的场景进行了完善

### IoC Container 概述

`org.springframework.context.ApplicationContext`接口负责为IOC容器实例化、配置和组装bean,该类通过读取配置原数据来实例化、配置和组装bean,配置元数据的方式可以是xml、java注解或者是Java代码来实现。

spring提供了几个`ApplicationContext`接口的实现,`Class PathXmlApplicationContext`或者`FileSystemApplicationContext`,他们都可以使用在单一应用中。我们可以在xml中声名容器使用java注解或代码来作为配置元数据。

ioc的流程图

![1568091058850](.img/.springFramework/1568091058850.png)

通过实例化类和配置元数据，即可创建一个可用和可配置的应用程序系统

#### 创建ioc容器

spring提供了`ApplicationContext`构造器,我们可以为其指定配置元数据来创建ico容器

```java
ApplicationContext context = new ClassPathXmlApplicationContext("services.xml", "daos.xml");//可以传入多个xml配置文件
```

services.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <!-- services -->

    <bean id="petStore" class="org.springframework.samples.jpetstore.services.PetStoreServiceImpl">
        <property name="accountDao" ref="accountDao"/>
        <property name="itemDao" ref="itemDao"/>
        <!-- additional collaborators and configuration for this bean go here -->
    </bean>

    <!-- more bean definitions for services go here -->

</beans>
```

xml配置文件可以相互的引用

```xml
<beans>
    <import resource="services.xml"/>
    <import resource="resources/messageSource.xml"/>
    <import resource="/resources/themeSource.xml"/><!-- 该xml需要位于resources目录下 -->

    <bean id="bean1" class="..."/>
    <bean id="bean2" class="..."/>
</beans>
```

spring推荐使用指定xml的绝对路径,而不是相对路径或者是classpath下的路径,因为这样会使得配置文件和应用耦合

#### 使用ioc容器

```java
// create and configure beans(创建并配置bean)
ApplicationContext context = new ClassPathXmlApplicationContext("services.xml", "daos.xml");

// retrieve configured instance(取回配置实例)
PetStoreService service = context.getBean("petStore", PetStoreService.class);

// use configured instance(使用实例)
List<String> userList = service.getUsernameList();
```

spring不推荐使用上述方法进行获取对应的bean,而是通过@Autowire注解自动注入

### (元数据配置)Configuration Metadata

spring Ioc容器接受一个配置元数据，就可以将为我们实例化，配置和组装一系列的beans

#### 三种元数据配置方式

配置元数据支持简单直观的XML格式进行配置，也支持java注解进行配置

- xml的配置方式：能够快速的修改并无需触及源代码或重新编译他们
- 注解配置方式：注解在其声名中提供了大量的上下文，使得配置更加的简短和简洁，但是这样会导致配置去中心化并且难易控制
- spring还支持xml和注解公用的方式

#### xml方式

```xml
<beans>
	<bean id="people" class="com.lyj.People">
    	... <!-- 依赖bean或配置该bean的属性 -->
    </bean>
</beans>
```

#### 注解方式

```java
@Configuration
public void ConfigurationClasss(){
    @Bean
    public People getPeople(){
        return new People();
    }
}
```

更多注解

 [`@Configuration`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/Configuration.html), [`@Bean`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/Bean.html), [`@Import`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/Import.html), and [`@DependsOn`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/DependsOn.html)

### bean 概述

在容器中的bean的父类就是BeanDefinition对象,其中包含了以下内容

- 包限定的类名: 通常是由实际的实现类定义
- bean的行为配置: bean在容器中的行为方式(范围,生命周期等等)
- bean的相互引用
- 在创建对应bean中设置一些配置,例如创建连接池相关的bean是可以配置连接池的大小等等

bean可配置的属性

| Property                 | Explained in…                                                |
| :----------------------- | :----------------------------------------------------------- |
| Class                    | [Instantiating Beans](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#beans-factory-class) |
| Name                     | [Naming Beans](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#beans-beanname) |
| Scope                    | [Bean Scopes](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#beans-factory-scopes) |
| Constructor arguments    | [Dependency Injection](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#beans-factory-collaborators) |
| Properties               | [Dependency Injection](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#beans-factory-collaborators) |
| Autowiring mode          | [Autowiring Collaborators](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#beans-factory-autowire) |
| Lazy initialization mode | [Lazy-initialized Beans](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#beans-factory-lazy-init) |
| Initialization method    | [Initialization Callbacks](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#beans-factory-lifecycle-initializingbean) |
| Destruction method       | [Destruction Callbacks](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#beans-factory-lifecycle-disposablebean) |

#### bean的命名

name和id都不是必须的,如果我们都没有指定,则ioc容器会为bean生成一个唯一的名称

通过类路径中的组件扫描, 容器为bean生成的名称通常以类名的小写字母开头,并使用了驼峰命名

为bean定义别名

- xml

  ```xml
  <alias name="fromName" alias="toName"/>
  ```

- 注解

  ```java
  @Autowired("people1") //默认容器为其生成的名称为people
  People people;
  ```

#### 实例化bean

bean的定义本质上是为了创建一个或多个实例对象

- 使用构造函数实例化

  1. spring使用反射获取类的构造函数,然后进行实例化

  2. spring要bean需要有一个空构造器,如果有重写了构造器,则还需要手动创建一个空的构造器,因为此时java不会为你自动创建一个空的构造器了

  3. 示例

     实体类

     ```Java
     public class ThingOne {
         public ThingOne(ThingTwo thingTwo, int years, String ultimateAnswer) {
             // ...
         }
     }
     ```

     xml配置

     - 配置对象

       ```xml
       <beans>
           <bean id="beanOne" class="x.y.ThingOne">
               <constructor-arg ref="beanTwo"/>
           </bean>
       </beans>
       ```

     - 配置其他类型参数

       使用type进行匹配

       ```xml
       <beans>
           <bean id="beanOne" class="x.y.ThingOne">
               <!-- 使用type进行匹配 -->
               <constructor-arg type="int" value="7500000"/>
               <constructor-arg type="java.lang.String" value="42"/>
           </bean>
       </beans>
       ```

       使用index进行匹配

       ```xml
       <beans>
           <bean id="beanOne" class="x.y.ThingOne">
               <!-- 或使用index进行匹配 -->
               <constructor-arg index="1" value="7500000"/>
           	<constructor-arg index="2" value="42"/>
           </bean>
       </beans>
       ```

       使用name进行匹配

       ```xml
       <beans>
           <bean id="beanOne" class="x.y.ThingOne">
               <!-- 使用name进行匹配 -->
               <constructor-arg name="years" value="7500000"/>
               <constructor-arg name="ultimateAnswer" value="42"/>
           </bean>
       </beans>
       ```

- 使用静态工厂方法实例化

- 使用实例工厂方法实例化













## [Resource](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#resources)

## [Validation,Data Binding,Type Conversion](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#validation)

## [Spring Expression Language (SpEL)](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#expressions)

## [Aspect Oriented Programming(AOP)](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#aop)

## [Spring AOP APIs](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#aop-api)

## [Null-safety](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#null-safety)

## [Data Buffers and Codecs](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#databuffers)

## [Appendix](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#appendix)

# Testing

# Data Access

# Web Servlet

# Web Reactive

# Integration

