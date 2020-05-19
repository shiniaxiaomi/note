# 概述

Feign 是一个声明式的伪RPC的REST客户端，它用了基于接口的注解方式，很方便的客户端配置。Spring Cloud 给 Feign 添加了支持Spring MVC注解 



 Feign的使用很简单，有以下几步：

- 添加依赖和配置文件
- 启动类添加 @EnableFeignClients 注解支持
- 建立Client接口，并在接口中定义需调用的服务方法
- 使用Client接口。



---



## 创建服务消费者



添加maven依赖：

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>
```

开启Feign注解：

```java
@SpringBootApplication
@EnableFeignClients //开启Feign注解
public class FeigndemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(FeigndemoApplication.class, args);
    }

}
```

新建接口，指定调用要调用的服务和url

```java
@FeignClient(name = "nacos-producer") //通过name指定要请求微服务名称
public interface NacosFeignClient {
 
    @GetMapping("/hello")
    public String index();
 
}
```

使用feign定义的接口（接口通过jdk生成代理类）：

```java
@Controller
public class TestController {
    @Autowired
    public NacosFeignClient nacosFeignClient;
 
    @GetMapping("/test")
    @ResponseBody
    public String test()
    {
        return nacosFeignClient.index();
    }
}
```



## 创建服务提供者

就是普通的一个web应用，用于提供http请求服务

```java
@Controller
public class TestController {
    @Autowired
    public NacosFeignClient nacosFeignClient;
 
    @GetMapping("/hello")
    @ResponseBody
    public String hello()
    {
        return "hello from producer";
    }
}
```



# 请求参数

Feign在处理接口中的参数时，默认是按照RequestBody进行处理的，如果标注了@RequestParam，则会按照将参数添加到query中，而非body中

---

- 如果全部都是基本类型参数，那么就使用Get请求，并标注@RequestParam注解在参数上，在接受端参数上@RequestParam注解可标可不标
- 如果全部是对象参数，那么就使用Post请求，参数不用标注@RequestBody注解（因为默认使用的就是@RequestBody），而接受端需要在参数上标注@RequestBody注解
- 如果既有基本类型参数，又有对象参数，则使用Post请求，基本类型参数必须要标注@RequestParam注解，对象参数可以标注@RequestBody。而接受端：基本类型参数可以标注@RequestParam，而对象类型必须标注@RequestBody

---

造成以上的主要原因是：

- Feign在通过接口生成代理类时，处理参数默认使用的是body类型，如果标注`@RequestParam`，则按照query进行处理
- 在接受端，springmvc默认会按照query进行参数匹配，如果标注`@RequestBody`，则按照body进行处理参数

---

总结：

发送端：

- 只要有对象参数，则使用Post请求，如果还有基本类型参数，则标注`@RequestParam`即可
- 如果没有对象参数，则使用Get请求，参数都要标注`@RequestParam`

接受端：

- 只要有对象参数，则通过`@RequestBody`进行标注
- 如果没有对象参数，则可以不用标注任何注解





# 问题记录

如果遇到以下报错：

```java
nested exception is feign.codec.EncodeException: Could not write request: no suitable HttpMessageConverter found for request type [com.example.springcloudalibabaconsumerdemo.model.User]] with root cause
```

- 因为要传递的对象没有添加get/set方法，最好添加上无参构造方法