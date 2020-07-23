# 介绍

# 使用SpringBoot

## 构建系统(Build Systems)

### Dependency Management

Spring Boot提供了版本管理工具`Dependency Management`来帮我们管理所有依赖的版本，SpringBoot非常的不建议我们自己去指定依赖的版本

### Maven

使用maven来管理依赖，你可以继承`spring-boot-starter-parent`，springboot推荐这样做，因为，当你的Springboot都已经为你选好了最好的依赖版本

当然，不是每个人都喜欢继承，springboot也允许你自定义依赖版本

使用maven可以将springboot打包成可以单独运行的jar包

### Starters

启动器，引入启动器依赖就可以将所需的所有依赖全部自动的引入，并且springboot会为你做好自动配置，非常的方便

例如：我们要使用Spring和JPA Data，那么我们只需要引入`spring-boot-starter-data-jpa`依赖即可将所需的依赖全部自动引入

启动器的命名规范：

- 所有Spring官方的启动器命名都是以`spring-boot-starter-*`开头的，`*`是应用的名称

- 创建自定义的started（启动器）可以参考该链接：[Creating Your Own Starter](https://docs.spring.io/spring-boot/docs/2.2.0.RELEASE/reference/html/spring-boot-features.html#boot-features-custom-starter)

- 第三方的启动器的命令规则为：`*-spring-boot-starter`,`*`是第三方应用的名称

更多的springboot starters可以参考[文档](https://docs.spring.io/spring-boot/docs/2.2.0.RELEASE/reference/html/using-spring-boot.html#using-boot-starter)

## 规定项目结构

- 使用默认的包名，Springboot推荐使用域名反转的包名，例如：`com.example.project`

- 定位主启动类：springboot推荐主启动类位于根包下（在所有class的上一级），因为`@SpringBootApplication`注解通常标注在主启动类上，它默认的规定扫描位于主启动类同包下的所有子包

## 配置类

标注有`@Configuration`注解的类就成为配置类

在springboot，你可以使用XML的方式进行对项目的配置，但是springboot推荐使用以java代码方式的配置类来替换XML方式的配置

> 我们可以在配置类上标注`Enable*`注解来启动某些功能

### 导入其他的配置类

使用`@Import`注解可以在导入额外的配置类（只需指定类即可），或者你也可以使用`@ComponentScan`注解自动的扫描配置类

### 导入XML配置

使用`@ImportResource`注解可以导入xml配置文件中的配置

## 自动配置

Springboot会自动配置一些你添加的依赖，如果你标注了`@EnableAutoConfiguration` or `@SpringBootApplication`注解

例如：如果在依赖中添加了`HSQLDB`，那么springboot会为你自动配置好内存数据库

> Springboot建议将`@SpringBootApplication`或`@EnableAutoConfiguration`注解只标注在最主要的配置类上

SpringBean

依赖注入

# SpringBoot功能总结

## 13.Messaging

### JMS

### AMQP

AMQP的全名为：Advanced Message Queuing Protocol（先进的消息队列协议）

AMQP时一个与平台无关的，面向消息的中间件

SpringBoot提供了方便使用RabbitMQ的starter：`spring-boot-starter-amqp`

#### RabbitMQ配置

```java
spring.rabbitmq.host=localhost
spring.rabbitmq.port=5672
spring.rabbitmq.username=guest
spring.rabbitmq.password=guest
```

具体详细的使用可以参考[文档](https://spring.io/blog/2010/06/14/understanding-amqp-the-protocol-used-by-rabbitmq/)

#### 发送消息

当我们在依赖中引入`spring-boot-starter-amqp`依赖时，Spring就为我们自动配置好了`AmqpTemplate` and `AmqpAdmin`

具体使用如下：

```java
import org.springframework.amqp.core.AmqpAdmin;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class MyBean {

      @Autowired
    private final AmqpAdmin amqpAdmin;
      @Autowired
    private final AmqpTemplate amqpTemplate;

      //...
}
```

如果需要设置重试可以配置以下代码：

```java
spring.rabbitmq.template.retry.enabled=true
spring.rabbitmq.template.retry.initial-interval=2s
```

#### 接受消息

当配置好RabbitMQ的配置后，任何的Bean都可以使用`@RabbitListener`注解来创建消息监听点，如果`RabbitListenerContainerFactory`实例没有注入，Spring会创建一个默认的bean（`SimpleRabbitListenerContainerFactory`）

下面是一个简单的创建消息监听的代码：

```java
package com.lyj.springboot_rabbitmq.consumer;

import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping
public class TestProducer {

    @Autowired
    RabbitTemplate rabbitTemplate; //注入rabbitmq模版

    @RequestMapping("test")
    public String test(){
        rabbitTemplate.convertSendAndReceive("someQueue","111");
        return "发送成功！";
    }
}
```

> 注意：
> 
> 当使用`RabbitListener`注解时，需要使用`@EnableRabbit`注解开启RabbitMQ注解

如果需要创建多个消息监听的`RabbitListenerContainerFactory`实例或者需要覆盖默认的bean，Spring提供了`SimpleRabbitListenerContainerFactoryConfigurer` 和 `DirectRabbitListenerContainerFactoryConfigurer`类，我们只需要在容器中初始化他们就可以了，自动配置还是会生效的

如果需要进行消息的转化，可以参考以下配置：

```java
@Configuration(proxyBeanMethods = false)
static class RabbitConfiguration {

  @Bean
  public SimpleRabbitListenerContainerFactory myFactory(
    SimpleRabbitListenerContainerFactoryConfigurer configurer) {
    SimpleRabbitListenerContainerFactory factory =
      new SimpleRabbitListenerContainerFactory();
    configurer.configure(factory, connectionFactory);
    factory.setMessageConverter(myMessageConverter());
    return factory;
  }

}
```

当配置好消息转换后，我们可以在消息监听的时候通过注解进行指定，将接受到的消息进行指定的转换，代码如下：

```java
package com.lyj.springboot_rabbitmq.producer;

import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

@Component
public class TestConsumer {

    //创建消息监听，并指定了监听队列的名称为someQueue
    @RabbitListener(queues = "someQueue")
    public void processMessage(String content) {
        System.out.println(content);
    }

}
```

如果需要配置消息接受重试，可以配置`RetryTemplate`

#### 创建多实例的RabbitMQ代码实例

创建application.properties配置文件

```properties
spring.rabbitmq.first.host=localhost
spring.rabbitmq.first.port=5672
spring.rabbitmq.first.username=guest
spring.rabbitmq.first.password=guest

spring.rabbitmq.second.host=localhost
spring.rabbitmq.second.port=5672
spring.rabbitmq.second.username=guest
spring.rabbitmq.second.password=guest
```

创建配置类

1. FirstRabbitConfig
   
   ```java
   package com.lyj.springboot_rabbitmq_demo.config;
   
   import org.springframework.amqp.rabbit.config.SimpleRabbitListenerContainerFactory;
   import org.springframework.amqp.rabbit.connection.CachingConnectionFactory;
   import org.springframework.amqp.rabbit.connection.ConnectionFactory;
   import org.springframework.amqp.rabbit.core.RabbitTemplate;
   import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
   import org.springframework.beans.factory.annotation.Qualifier;
   import org.springframework.beans.factory.annotation.Value;
   import org.springframework.boot.autoconfigure.amqp.SimpleRabbitListenerContainerFactoryConfigurer;
   import org.springframework.context.annotation.Bean;
   import org.springframework.context.annotation.Configuration;
   import org.springframework.context.annotation.Primary;
   
   @Configuration
   public class FirstRabbitConfig {
       //配置具有缓存的连接工厂
       @Bean(name = "firstConnectionFactory")
       @Primary
       public CachingConnectionFactory firstConnectionFactory(
               @Value("${spring.rabbitmq.first.host}") String host,
               @Value("${spring.rabbitmq.first.port}") int port,
               @Value("${spring.rabbitmq.first.username}") String username,
               @Value("${spring.rabbitmq.first.password}") String password
       )  {
           CachingConnectionFactory connectionFactory = new CachingConnectionFactory();
           connectionFactory.setHost(host);
           connectionFactory.setPort(port);
           connectionFactory.setUsername(username);
           connectionFactory.setPassword(password);
           return connectionFactory;
       }
   
       //rabbitmq模版
       @Bean(name = "firstTemplate")
       @Primary
       public RabbitTemplate firstTemplate(
               @Qualifier("firstConnectionFactory") ConnectionFactory connectionFactory
       ) {
           RabbitTemplate rabbitTemplate = new RabbitTemplate(connectionFactory);
           rabbitTemplate.setMessageConverter(new Jackson2JsonMessageConverter());
           return rabbitTemplate;
       }
   
       //监听工厂
       @Bean(name = "firstListenerFactory")
       @Primary
       public SimpleRabbitListenerContainerFactory firstListenerFactory(
               SimpleRabbitListenerContainerFactoryConfigurer configurer,
               @Qualifier("firstConnectionFactory") ConnectionFactory connectionFactory
       ) {
           SimpleRabbitListenerContainerFactory factory = new SimpleRabbitListenerContainerFactory();
           configurer.configure(factory, connectionFactory);
   
           return factory;
       }
   }
   ```

2. SecondRabbitConfig
   
   ```java
   package com.lyj.springboot_rabbitmq_demo.config;
   
   import org.springframework.amqp.rabbit.config.SimpleRabbitListenerContainerFactory;
   import org.springframework.amqp.rabbit.connection.CachingConnectionFactory;
   import org.springframework.amqp.rabbit.connection.ConnectionFactory;
   import org.springframework.amqp.rabbit.core.RabbitTemplate;
   import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
   import org.springframework.beans.factory.annotation.Qualifier;
   import org.springframework.beans.factory.annotation.Value;
   import org.springframework.boot.autoconfigure.amqp.SimpleRabbitListenerContainerFactoryConfigurer;
   import org.springframework.context.annotation.Bean;
   import org.springframework.context.annotation.Configuration;
   
   @Configuration
   public class SecondRabbitConfig {
       //配置具有缓存的连接工厂
       @Bean(name = "secondConnectionFactory")
       public CachingConnectionFactory SecondConnectionFactory(
               @Value("${spring.rabbitmq.second.host}") String host,
               @Value("${spring.rabbitmq.second.port}") int port,
               @Value("${spring.rabbitmq.second.username}") String username,
               @Value("${spring.rabbitmq.second.password}") String password
       )  {
           CachingConnectionFactory connectionFactory = new CachingConnectionFactory();
           connectionFactory.setHost(host);
           connectionFactory.setPort(port);
           connectionFactory.setUsername(username);
           connectionFactory.setPassword(password);
           return connectionFactory;
       }
   
       //rabbitmq模版
       @Bean(name = "secondTemplate")
       public RabbitTemplate SecondTemplate(
               @Qualifier("secondConnectionFactory") ConnectionFactory connectionFactory
       ) {
           RabbitTemplate rabbitTemplate = new RabbitTemplate(connectionFactory);
           rabbitTemplate.setMessageConverter(new Jackson2JsonMessageConverter());
           return rabbitTemplate;
       }
   
       //监听工厂
       @Bean(name = "secondListenerFactory")
       public SimpleRabbitListenerContainerFactory SecondListenerFactory(
               SimpleRabbitListenerContainerFactoryConfigurer configurer,
               @Qualifier("secondConnectionFactory") ConnectionFactory connectionFactory
       ) {
           SimpleRabbitListenerContainerFactory factory = new SimpleRabbitListenerContainerFactory();
           configurer.configure(factory, connectionFactory);
   
           return factory;
       }
   
   }
   ```

> 注意：
> 
> 两份配置代码几乎一样，但是必须其中一个配置文件的bean要打上`@Primary`注解，不然会报找到两个类型相同的错误
> 
> 两份配置代码的bean必须要标明bean的名称，注入时也需要使用`@Qualifier`注解指定注入哪个名称的bean

创建生产者

```java
package com.lyj.springboot_rabbitmq_demo.controller;

import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

@RestController
@RequestMapping
public class TestController {
    @Resource(name = "firstTemplate")
    RabbitTemplate firstTemplate;
    @Resource(name = "secondTemplate")
    RabbitTemplate secondTemplate;

    @RequestMapping("test1")
    public String test1(String str){
        firstTemplate.convertAndSend("test1",str);
        return "success";
    }

    @RequestMapping("test2")
    public String test2(String str){
        secondTemplate.convertAndSend("test2",str);
        return "success";
    }

}
```

创建消费者

```java
package com.lyj.springboot_rabbitmq_demo.consumer;

import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

@Component
public class TestConsumer {
    //消息监听firstRabbit
    @RabbitListener(queues ="test1",containerFactory = "firstListenerFactory")
    public void process1(byte[] message) {
        System.out.println("test1:"+new String(message));
    }

    //消息监听secondRabbit
    @RabbitListener(queues ="test2",containerFactory = "secondListenerFactory")
    public void process2(byte[] message) {
        System.out.println("test2:"+new String(message));
    }
}
```

主入口

```java
package com.lyj.springboot_rabbitmq_demo;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
@SpringBootApplication
public class SpringbootRabbitmqDemoApplication {
    public static void main(String[] args) {
        SpringApplication.run(SpringbootRabbitmqDemoApplication.class, args);
    }
}
```

运行代码后，在浏览器端进行生产数据，查看控制台的数据消费情况

测试连接1：http://localhost:8080/test1?str=test

测试连接1：http://localhost:8080/test2?str=test

本地输出情况：

```java
test1:"test"
test2:"test"
```

### Kafaka

# 辅助功能

监控

指标

审核

# 部署SpringBoot应用程序

# SpringBoot CLI

安装

使用

配置

# 生成工具插件

Maven插件

Gradle插件

Antlib

# 其他相关记录

## 多配置文件

创建多个配置文件：

- application.properties
  
  主配置文件，可以决定是哪个配置文件生效
  
  ```properties
  spring.profiles.active=test
  ```

- application-dev.properties

- application-prod.properties

## 使用java -jar命令启动项目

- 指定生效的配置文件
  
  ```java
  java -jar xxx.jar --spring.profiles.active=prod
  ```

- 指定启动的端口
  
  ```java
  java -jar xxx.jar --server.port=8181
  ```

- 全都指定
  
  ```java
  java -jar plantip-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod --server.port=8002
  ```

## 使用java -jar命令后台启动项目

直接在命令后天添加`&`符号即可

项目的日志会输出到当前窗口，退出命令行窗口或使用`Ctrl+C`都不会终止应用

缺点是没有指定项目日志输出到指定目录，之后是无法查看日志的

```shell
java -jar xxx.jar --spring.profiles.active=prod &
```

- 添加日志输出的方法
  
  ```shell
  java -jar xxx.jar --spring.profiles.active=prod >log &
  ```

## 直接获取项目的pid

```shell
pgrep -f 项目相关名称或信息
```

示例：

```shell
pgrep -f plantip
```

# 其他

## 静态资源

配置多个静态资源路径

```properties
spring.resources.static-locations=classpath:/static/,file:/Users/yingjie.lu/Documents/note/.img
```

> 使用`,`分隔多个静态资源路径即可
> 
> 如果配置外部的静态资源，需要在路径前面加上`file:`关键字

## 多配置文件

- application.properties
- application-dev.properties
- application-prod.properties

在application.properties中使用`spring.profiles.active=dev`可以配置激活哪个配置文件

## 定时任务

开启定时任务注解

> 注意：
> 
> 在定时任务中，需要捕获异常后自行处理，而不能直接抛出，不然会导致定时任务异常，最终会终止项目

## 配置文件变量

### 单个变量

在配置文件中配置变量

```properties
isDev=true
```

直接获取配置文件中的变量

```java
@Value("${isDev}")
boolean isDev;
```

### 前缀变量

配置有前缀的变量

```properties
person.age=1
person.name=a
```

获取前缀变量

```properties
@Component
@ConfigurationProperties(prefix="person") 
public class Test(){
        int age;
        String name;
}
```

> 这样就可以将配置文件的前缀为person的变量的值注入到Test类的两个成员变量中

### 读取指定配置文件

```java
@PropertySource(value="classpath:conf/url.properties")
```

## 重定向请求

将需要重定向的链接先返回给客户端，让客户端重新发起请求访问指定的链接

### 使用redirect进行重定向

```java
@RequestMapping("test")
public String test(){
  return "redirect:/";
}
```

> 将`/test`请求重定向到`/`页面

### 使用ModelAndView重定向

```java
@RequestMapping("test")
public ModelAndView test(){
  ModelAndView index = new ModelAndView("redirect:/");
  return index;
}
```

### 使用HttpServletResponse重定向

```java
protected void doGet(HttpServletRequest servletRequest, HttpServletResponse servletResponse){
      servletResponse.sendRedirect("/");
}
```

## 转发请求

将请求转发给其他Controller处理

### 使用forward进行转发

```java
@RequestMapping("/test")
public String test(){
  return "forward:/";
}
```

> 将`/test`请求转交给`/`请求的Controller请求

### 使用ModelAndView进行转发

```java
@RequestMapping("test")
public ModelAndView test(){
  ModelAndView index = new ModelAndView("forward:/");
  return index;
}
```

### 使用HttpServletRequest进行转发

```java
protected void doGet(HttpServletRequest servletRequest, HttpServletResponse servletResponse){
  RequestDispatcher dispatcher = request.getRequestDispatcher("/");
  dispatcher.forward(request, response);//执行转发
}
```

## 启动项目后才执行一段代码

实现`ApplicationRunner`接口即可

```java
@Component
public class ApplicationRunnerImpl implements ApplicationRunner {
    @Override
    public void run(ApplicationArguments args) throws Exception {
        System.out.println("应用启动成功！");
    }
}
```

## 统一异常处理

```java
@ControllerAdvice
public class MyHandler {
  @ExceptionHandler(Exception.class)
  public void handler(HttpServletRequest request, HttpServletResponse response, Exception e){
    System.out.println("异常！");
}
```

# 参考文档

[SpringBoot官方文档](https://docs.spring.io/spring-boot/docs/2.2.0.RELEASE/reference/html/)

[SpringBoot 官方API](https://docs.spring.io/spring-boot/docs/2.2.0.RELEASE/api/)