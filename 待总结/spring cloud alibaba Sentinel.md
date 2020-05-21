## 参考文档

参考文档：https://github.com/alibaba/spring-cloud-alibaba/blob/master/spring-cloud-alibaba-examples/sentinel-example/sentinel-core-example/readme-zh.md

## 概述

所有微服务都引入Sentinel依赖，然后通过`@SentinelResource`注解用于标识资源是否受速率限制或降级，如果当该服务的调用超过设置值时，服务将会被熔断



所有的微服务都可以连接到Sentinel的dataBoard仪表盘来进行数据统计，进行可视化的展示

## 功能

流量监控（限流），服务降级

## 依赖

添加Sentinel依赖：

```xml
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-sentinel</artifactId>
</dependency>
```



## 仪表盘

> 可选项，它是独立与整个微服务的，所有微服务将数据上传仪表盘进行数据统计并可视化

通过运行Sentinel的dataBoard对所有微服务进行可视化



下载仪表盘应用： [Dashboard](https://github.com/alibaba/Sentinel/tree/master/sentinel-dashboard) 

启动命令：

```shell
java -Dserver.port=8080 -Dcsp.sentinel.dashboard.server=localhost:8080 -Dproject.name=sentinel-dashboard -jar sentinel-dashboard.jar
```

该应用使用的是springboot开发

仪表盘默认的访问路径：localhost:8080(即Dashboard启动的ip+端口)

默认的用户名和密码都是：sentinel



在配置文件中的配置：

```yml
spring:
  cloud:
    sentinel:
      transport:
        port: 8719
        dashboard: localhost:8080 #仪表盘启动的地址和端口
```

> 在`spring.cloud.sentinel.transport.port`中指定的端口号。端口将在应用程序的相应服务器上启动一个HTTP服务器，该服务器将与Sentinel指示板进行交互。 



## 限流

### 简单使用

添加Sentinel的starter依赖

```xml
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-sentinel</artifactId>
</dependency>
```

使用：

```java
@RestController
public class TestController {
    //该请求标识为资源，资源名为hello，用于后续的流量和断路等设置
    //通过fallback来指定限流后的回调
    @SentinelResource("hello",fallback = "error") 
    @GetMapping(value = "/hello")
    public String hello() {
        return "Hello Sentinel";
    }
    
    //用于限流后的回调
    public String error(){
        return "请稍后再试";
    }
}
```

> @SentinelResource还提供了属性，例如`blockHandler`，`blockHandlerClass`，和`fallback`，以确定速率限制或降解操作。有关更多详细信息，请参阅 [Sentinel注释支持](https://github.com/alibaba/Sentinel/wiki/注解支持)。 

### 添加限流规则

添加限流规则总共有两种方式：

第一种：直接通过Sentinel Dashboard进行设置限流规则

第二种：通过代码方式，设置对应资源的限流规则

```java
//该配置类必须要由spring管理
@Component
public class SentinelConfig {
    
    //在spring加载bean过程中执行设置限流规则的操作
    @PostConstruct
    private void initFlowQpsRule() {
        List<FlowRule> rules = new ArrayList<>();

        //设置hello请求的限流
        FlowRule rule = new FlowRule("hello");
        //设置限流为1
        rule.setCount(1);// set limit qps to 1
        rule.setGrade(RuleConstant.FLOW_GRADE_QPS);
        rule.setLimitApp("default");

        rules.add(rule); //将规则添加到集合
        FlowRuleManager.loadRules(rules); //加载集合中的规则
    }
}
```

> 当项目启动后，设置的限流规则就会生效，我们可以在Sentinel Dashboard中看到
>
> 我们可以在Sentinel Dashboard中动态的修改限流规则

## 与其他项目结合

### 与OpenFeign结合

如果需要与OpenFeign结合，需要做以下两步操作：

1. 在保证已经添加`spring-cloud-starter-alibaba-sentinel`依赖的前提下，添加openfeing的依赖

   ```xml
   <dependency>
       <groupId>org.springframework.cloud</groupId>
       <artifactId>spring-cloud-starter-openfeign</artifactId>
   </dependency>
   ```

2. 开启整合

   ```properties
   feign.sentinel.enabled=true
   ```



使用示例：

接口,用于生成http代理类，在Feign注解中指定回调类和配置类

```java
@FeignClient(name = "service-provider", fallback = EchoServiceFallback.class, configuration = FeignConfiguration.class)
public interface EchoService {
    @GetMapping(value = "/echo/{str}")
    String echo(@PathVariable("str") String str);
}
```

> 当调用远程服务的` http://service-provider/echo/{str} `接口时，如果发生阻塞，则回调EchoServiceFallback类中指定的处理函数，用于熔断降级

配置类：

```java
class FeignConfiguration {
    @Bean
    public EchoServiceFallback echoServiceFallback() {
        return new EchoServiceFallback();
    }
}
```

回调类：

```java
class EchoServiceFallback implements EchoService {
    @Override
    public String echo(@PathVariable("str") String str) {
        return "echo fallback";
    }
}
```



### 与RestTemplate结合

在返回RestTemplate bean时，使用`@SentinelRestTemplate`注解进行指定即可与该返回的RestTemplate进行结合，返回一个被代理的类

代码如下：

```java
@Bean
@SentinelRestTemplate(blockHandler = "handleException", blockHandlerClass = ExceptionUtil.class)
public RestTemplate restTemplate() {
    return new RestTemplate();
}
```

通过指定`blockHandler`和`blockHandlerClass`进行控流

通过指定进行 `fallback`和`fallbackClass` 进行断路



`blockHandler`和 `fallback`指定的方法都必须是`blockHandlerClass`或`fallbackClass`类中的静态方法,例如：

```java
//blockHandlerClass
public class ExceptionUtil {
    //blockHandler(静态方法)
    public static ClientHttpResponse handleException(HttpRequest request, byte[] body, ClientHttpRequestExecution execution, BlockException exception) {
        ...
    }
}
```



### 与Zuul结合

如果想让Sentinel与Spring Cloud Netflix zuul进行结合，需要添加以下依赖：

1. 添加sentinel的starter

   ```xml
   <dependency>
       <groupId>com.alibaba.cloud</groupId>
       <artifactId>spring-cloud-starter-alibaba-sentinel</artifactId>
   </dependency>
   ```

2. 添加sentinel的网关整合依赖

   ```xml
   <dependency>
       <groupId>com.alibaba.cloud</groupId>
       <artifactId>spring-cloud-alibaba-sentinel-gateway</artifactId>
   </dependency>
   ```

3. 添加zuul的starter

   ```xml
   <dependency>
       <groupId>org.springframework.cloud</groupId>
       <artifactId>spring-cloud-starter-netflix-zuul</artifactId>
   </dependency>
   ```

具体内容参考： [Sentinel 网关限流](https://github.com/alibaba/Sentinel/wiki/网关限流) 



### 与Gateway结合

如果想让Sentinel与Spring Cloud Gateway进行结合，需要添加以下依赖：

1. 添加sentinel的starter

   ```xml
   <dependency>
       <groupId>com.alibaba.cloud</groupId>
       <artifactId>spring-cloud-starter-alibaba-sentinel</artifactId>
   </dependency>
   ```

2. 添加sentinel的网关整合依赖

   ```xml
   <dependency>
       <groupId>com.alibaba.cloud</groupId>
       <artifactId>spring-cloud-alibaba-sentinel-gateway</artifactId>
   </dependency>
   ```

3. 添加spring cloud gateway的starter

   ```xml
   <dependency>
       <groupId>org.springframework.cloud</groupId>
       <artifactId>spring-cloud-starter-gateway</artifactId>
   </dependency>
   ```

具体内容参考： [Sentinel 网关限流](https://github.com/alibaba/Sentinel/wiki/网关限流) 

## 配置相关

### 配置bean

如果在spring中存在以下bean，则会应用到Sentinel上：

1. 如果存在 UrlCleaner ，则每个请求都会回调 WebCallbackManager.setUrlCleaner(urlCleaner) 方法，用于清理url

2. 如果存在 UrlBlockHandler ，会回调 WebCallbackManager.setUrlBlockHandler(urlBlockHandler) 方法，用于自定义限流规则

   > 实现UrlBlockHandler 接口

3. 如果存在 RequestOriginParser ，则每个请求都会回调 WebCallbackManager.setRequestOriginParser(requestOriginParser) 方法，用于设置origin

### Sentinel的所有相关配置项

https://spring-cloud-alibaba-group.github.io/github-pages/greenwich/spring-cloud-alibaba.html#_configuration





















