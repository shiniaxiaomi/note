# 介绍

本文推荐使用slf4j日志门面和logback日志实现

# 日志体系

## 所有相关的名词

- 日志门面
  - slf4j：Gülcü作者写的日志API
  - commons-logging（jcl）：Apache写的日志API
- 日志实现
  - log4j：Gülcü作者写的日志实现
  - log4j2：其他的写的日志实现
  - logback：Gülcü作者写的日志实现，是log4j的升级版
  - jul：java.util.logging，jdk默认提供的一个日志框架

## 发展史

- Log4j：首先，Gülcü作者在2001年发布了Log4j日志框架，后来成为了Apache的顶级项目，它定义了Logger、Appender、Level等概念，但是由于性能原因，现在被使用的比较少

- JUL：受Log4j的启发，Sun公司在jdk1.4版本中引入了java.util.logging，并在jdk1.5中得到改善

- JCL（commons-logging）：当时出现了Log4j和JUL两个日志框架，但项目中必须要选择一个使用，这时Apache就提供了该日志API（commons-logging），而它的实现也就是Log4j和JUL

  > Spring使用的就是commons-logging日志门面

- SLF4J & Logback：Gülcü作者认为当时的JCL日志API写的不好，所以重新写了SLF4J的日志API，并且还写了更高性能的日志实现Logback

  Logback是log4j的升级版

- Log4j2：因为有了更好的SLF4J 和 Logback来取代JCL 和 Log4j ，维护 Log4j 不希望用户被抢占，继而推出了Log4j2，相比于Log4j性能得到了很大提升，但是它与Log4j并不兼容，更多是模仿SLF4J & Logback。

  因此，Log4j2只是在命名上与Log4j有点联系，但是并不是出于同一个作者。而Log4j、SLF4J、Logback都是出于Gülcü之手。

## 总结

|    日志门面     |     日志框架      |
| :-------------: | :---------------: |
| commons-logging |       Log4j       |
|      SLF4J      | java.util.logging |
|  jboss-logging  |      Logback      |
|                 |      Log4j2       |

> Log4j、SLF4J、Logback都是同一个作者写的
>
> commons-logging是Apache写的
>
> java.util.logging是jdk默认提供的
>
> Log4j2是其他人写的
>
> jboss-logging是日志门面，Hibernate使用了该日志门面

Springboot使用的是SLF4J的日志门面和Logback的日志实现，因此本文也紧跟Springboot的步伐，使用SLF4J和Logback进行记录和学习

# SLF4J+LogBack的优点

- LogBack 自身实现了 SLF4J 的日志接口，不需要 SLF4J 去做进一步的适配
- LogBack 自身是在 Log4J 的基础上优化而成的，其运行速度和效率都比 Log4J 高
- SLF4J + LogBack 支持占位符，方便日志代码的阅读，而 Log4J 则不支持

# SLF4j的适配

![Java日志体系总结__3](/Users/yingjie.lu/Documents/note/.img/Java日志体系总结__3.png)

## 让Spring统一输出

![Java日志体系总结__4](/Users/yingjie.lu/Documents/note/.img/Java日志体系总结__4.png)

## 适配思路

1. 将系统中其他日志框架先排除出去
2. 用中间包来替换原有的日志框架，即sfl4j的适配器
3. 导入 slf4j 其他的实现

## 在springboot中的日志关系

![image-20191223182219083](/Users/yingjie.lu/Documents/note/.img/image-20191223182219083.png)

可见，
 1、SpringBoot2.x 底层也是使用 slf4j+logback 或 log4j 的方式进行日志记录；​
 2、SpringBoot 引入中间替换包把其他的日志都替换成了 slf4j；
 3、 如果我们要引入其他框架、可以把这个框架的默认日志依赖移除掉。

比如 Spring 使用的是 commons-logging 框架，我们可以这样移除：

```xml
<dependency>
  <groupId>org.springframework</groupId>
  <artifactId>spring-core</artifactId>
  <exclusions>
    <exclusion>
      <groupId>commons-logging</groupId>
      <artifactId>commons-logging</artifactId>
    </exclusion>
  </exclusions>
</dependency>
```

SpringBoot 能自动适配所有的日志，而且底层使用 slf4j+logback 的方式记录日志，引入其他框架的时候，只需要把这个框架依赖的日志框架排除掉即可

# Logback

## 原理

LogBack 被分为3个组件：`logback-core`、`logback-classic` 和 `logback-access`。

- logback-core 提供了 LogBack 的核心功能，是另外两个组件的基础。

- logback-classic 则实现了 SLF4J 的API，所以当想配合 SLF4J 使用时，需要将 logback-classic 引入依赖中。

- logback-access 是为了集成Servlet环境而准备的，可提供HTTP-access的日志接口。

下图可以看出 LogBack 的日志记录数据流是从 Class 或 Package 流到 Logger，再从Logger到Appender，最后从Appender到具体的输出终端

![5a2e524700012d5213020826](/Users/yingjie.lu/Documents/note/.img/5a2e524700012d5213020826.png)
具体的配置文件配置可以参考该[链接](https://www.imooc.com/article/details/id/21908)

## 日志级别

日志级别：error > warn > info > debug > trace

默认的日志输出级别为info

## 使用

### pom依赖

```xml
<!-- logback -->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-logging</artifactId>
</dependency>
```

### 添加properties日志配置

```properties
# 配置logbach的xml文件的路径
logging.config=classpath:logback.xml

# 配置整个项目的日志级别
logging.level.root=debug

# 配置指定包下的日志级别
logging.level.com.muses.taoshop=info

# 指定日志文件的名称，如果不指定，日志只在控制台输出，而不输出到文件
logging.file.name=D:/springboot.log

# 指定日志文件的路径，如果不指定，文件将存放在项目根目录下
logging.path=/data/logs

# 控制台输出日志的格式
logging.pattern.console 

# 文件中输出日志的格式
logging.pattern.file
```

### 日志xml配置文件

创建logback.xml配置文件

> springboot会直接识别logback.xml配置文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<configuration debug="false" scan="true">
  <!-- 日志级别 -->
  <springProperty scope="context" name="LOG_ROOT_LEVEL" source="logging.level.root" defaultValue="DEBUG"/>
  <!--  标识这个"STDOUT" 将会添加到这个logger -->
  <springProperty scope="context" name="STDOUT" source="log.stdout" defaultValue="STDOUT"/>
  <!-- 日志格式，%d：日期；%thread：线程名；%-5level：日志级别从左显示5个字符长度，列如:DEBUG；
        %logger{36}：java类名，例如:com.muses.taoshop.MyTest，36表示字符长度；%msg：日志内容；%d：换行 -->
  <property name="LOG_PATTERN"
            value="%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n" />
  <!-- root日志级别-->
  <property name="${LOG_ROOT_LEVEL}" value="DEBUG" />
  <!-- 日志跟目录 -->
  <property name="LOG_HOME" value="data/logs" />
  <!-- 日志文件路径-->
  <property name="LOG_DIR" value="${LOG_HOME}/%d{yyyyMMdd}" />
  <!-- 日志文件名称 -->
  <property name="LOG_PREFIX" value="portal" />
  <!-- 日志文件编码 -->
  <property name="LOG_CHARSET" value="utf-8" />
  <!-- 配置日志的滚动时间，保存时间为15天-->
  <property name="MAX_HISTORY" value="15" />
  <!-- 文件大小，默认为10MB-->
  <property name="MAX_FILE_SIZE" value="10" />


  <!-- 打印到控制台 -->
  <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
    <!-- 格式化日志内容-->
    <encoder>
      <pattern>${LOG_PATTERN}</pattern>
    </encoder>
  </appender>
  <!-- 打印所有日志，保存到文件-->
  <appender name="FILE_ALL"
            class="ch.qos.logback.core.rolling.RollingFileAppender">
    <file>${LOG_HOME}/all_${LOG_PREFIX}.log</file>
    <!-- 设置滚动策略，当日志文件大小超过${MAX_FILE_SIZE}时，新的日志内容写到新的日志文件-->
    <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
      <!-- 新的日志文件路径名称，%d:日期 %i:i是变量 -->
      <fileNamePattern>${LOG_DIR}/all_${LOG_PREFIX}%d{yyyy-MM-dd}.%i.log</fileNamePattern>
      <!-- 保存日志15天 -->
      <maxHistory>${MAX_HISTORY}</maxHistory>
      <timeBasedFileNamingAndTriggeringPolicy
                                              class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
        <!-- 日志文件的最大大小 -->
        <maxFileSize>${MAX_FILE_SIZE}</maxFileSize>
      </timeBasedFileNamingAndTriggeringPolicy>
    </rollingPolicy>
    <!-- 格式日志文件内容-->
    <layout class="ch.qos.logback.classic.PatternLayout">
      <pattern>${LOG_PATTERN}</pattern>
    </layout>
  </appender>

  <!-- 打印错误日志，保存到文件-->
  <appender name="FILE_ERR"
            class="ch.qos.logback.core.rolling.RollingFileAppender">
    <file>${LOG_HOME}/err_${LOG_PREFIX}.log</file>
    <!-- 设置滚动策略，当日志文件大小超过${MAX_FILE_SIZE}时，新的日志内容写到新的日志文件-->
    <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
      <!-- 新的日志文件路径名称，%d:日期 %i:i是变量 -->
      <fileNamePattern>${LOG_DIR}/err_${LOG_PREFIX}%d{yyyy-MM-dd}.%i.log</fileNamePattern>
      <!-- 保存日志15天 -->
      <maxHistory>${MAX_HISTORY}</maxHistory>
      <timeBasedFileNamingAndTriggeringPolicy
                                              class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
        <!-- 日志文件的最大大小 -->
        <maxFileSize>${MAX_FILE_SIZE}</maxFileSize>
      </timeBasedFileNamingAndTriggeringPolicy>
    </rollingPolicy>
    <!-- 格式日志文件内容-->
    <layout class="ch.qos.logback.classic.PatternLayout">
      <pattern>${LOG_PATTERN}</pattern>
    </layout>
  </appender>

  <!-- rest template logger-->
  <!--<logger name="org.springframework.web.client.RestTemplate" level="DEBUG" />-->
  <!--<logger name="org.springframework" level="DEBUG" />-->

  <!-- jdbc-->
  <!--<logger name="jdbc.sqltiming" level="DEBUG" />-->
  <logger name="org.mybatis" level="DEBUG" />

  <!-- zookeeper-->
  <logger name="org.apache.zookeeper"    level="ERROR"  />

  <!-- dubbo -->
  <logger name="com.alibaba.dubbo.monitor" level="ERROR"/>
  <logger name="com.alibaba.dubbo.remoting" level="ERROR" />

  <!-- 日志输出级别 -->
  <root leve="${LOG_ROOT_LEVEL}">
    <appender-ref ref="STDOUT" />
    <appender-ref ref="FILE_ALL" />
    <appender-ref ref="FILE_ERR" />
  </root>

</configuration>
```

### 在slf4j推荐的使用方式

```java
//记录器
Logger logger = LoggerFactory.getLogger(getClass());
//日志的级别；
//由低到高   trace<debug<info<warn<error
//可以调整输出的日志级别；日志就只会在这个级别以以后的高级别生效
logger.trace("这是trace日志...");
logger.debug("这是debug日志...");
// SpringBoot 默认给我们使用的是 info 级别的，没有指定级别的就用SpringBoot 默认规定的级别；root 级别
logger.info("这是info日志...");
logger.warn("这是warn日志...");
logger.error("这是error日志...");
```

### 使用lombok注解可以更便捷的使用

```java
@ControllerAdvice
@Slf4j
public class MyHandler {
    @ExceptionHandler(Exception.class)
    public void handler(HttpServletRequest request, HttpServletResponse response, Exception e){
        log.error("异常:",e);
    }
}
```

### 占位符语法

```java
log.error("Controller请求异常：{},异常为：{}",request.getServletPath(),e);
```





# 参考文档

[Java日志体系总结](https://albenw.github.io/posts/854fc091/)

[在JAVA中记录日志的十个小建议](https://www.cnblogs.com/lilinwei340/p/9697287.html)

[slf4j官网](http://www.slf4j.org/)

[logback官网](http://logback.qos.ch/)