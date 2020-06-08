# 文档地址

官方文档地址：https://spring-cloud-alibaba-group.github.io/github-pages/greenwich/spring-cloud-alibaba.html

官方Demo：https://github.com/alibaba/spring-cloud-alibaba/tree/master/spring-cloud-alibaba-examples

- [spring-cloud-alibaba-dubbo-examples](https://github.com/alibaba/spring-cloud-alibaba/tree/master/spring-cloud-alibaba-examples/spring-cloud-alibaba-dubbo-examples) 
-  [nacos-example](https://github.com/alibaba/spring-cloud-alibaba/tree/master/spring-cloud-alibaba-examples/nacos-example) 



# 依赖管理

在项目中中添加依赖：

```xml
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-alibaba-dependencies</artifactId>
    <version>2.1.0.RELEASE</version>
    <type>pom</type>
    <scope>import</scope>
</dependency>
```



# Nacos注册与发现

Nacos官方网站：https://nacos.io/zh-cn/docs/quick-start.html



引入Nacos Discovery依赖

```xml
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
</dependency>
```



使用Nacos Discovery进行服务的注册与发现：

- 现在Nacos Server， 启动后，请访问http://localhost:8848 即可（默认用户名和密码为admin/admin）



完成的pom文件示例：

```xml
<?xml version="1.0" encoding="UTF-8"? >
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>open.source.test</groupId>
    <artifactId>nacos-discovery-test</artifactId>
    <version>1.0-SNAPSHOT</version>
    <name>nacos-discovery-test</name>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>${spring.boot.version}</version>
        <relativePath/>
    </parent>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <java.version>1.8</java.version>
    </properties>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring.cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <dependency>
                <groupId>com.alibaba.cloud</groupId>
                <artifactId>spring-cloud-alibaba-dependencies</artifactId>
                <version>${spring.cloud.alibaba.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

	
    <dependencies>
		<!--web starter-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

		<!--健康监控-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>

		<!--服务注册与发现-->
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```



添加服务提供者的`bootstrap.properties`配置文件

```properties
# 端口
server.port=8081
# 服务名称
spring.application.name=nacos-provider
# 注册地址
spring.cloud.nacos.discovery.server-addr=127.0.0.1:8848
management.endpoints.web.exposure.include=*
```



简单的服务提供者：

```java
@SpringBootApplication
@EnableDiscoveryClient //开启服务注册发现
public class NacosProviderDemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(NacosProviderDemoApplication.class, args);
    }

    @RestController
    public class EchoController {
        @GetMapping(value = "/echo/{string}")
        public String echo(@PathVariable String string) {
            return "Hello Nacos Discovery " + string;
        }
    }
}
```



添加服务消费者的配置文件:

```properties
# 端口
server.port=8082
# 服务名称
spring.application.name=nacos-consumer
# 注册地址
spring.cloud.nacos.discovery.server-addr=127.0.0.1:8848
management.endpoints.web.exposure.include=*
```



简单的服务消费者：

> 方式一：通过restTemplate方式进行微服务调用

```java
@SpringBootApplication
@EnableDiscoveryClient //开启服务注册发现
public class NacosConsumerApp {

    @RestController
    public class NacosController{

        //注入负载平衡客户端
        @Autowired
        private LoadBalancerClient loadBalancerClient;
        @Autowired
        private RestTemplate restTemplate;

        @Value("${spring.application.name}")
        private String appName;

        @GetMapping("/echo/app-name")
        public String echoAppName(){
            //通过应用名称和负载平衡客户端拿到服务提供者的信息
            ServiceInstance serviceInstance = loadBalancerClient.choose("nacos-provider");
            //通过服务提供者的host和port生成请求链接
            String path = String.format("http://%s:%s/echo/%s",serviceInstance.getHost(),serviceInstance.getPort(),appName);
            System.out.println("request path:" +path);
            //通过restTemplate进行请求服务提供者
            return restTemplate.getForObject(path,String.class);
        }

    }

    //注入restTemplate实例
    @Bean
    public RestTemplate restTemplate(){

        return new RestTemplate();
    }

    public static void main(String[] args) {

        SpringApplication.run(NacosConsumerApp.class,args);
    }
}
```

---

> 方式二：通过Feign方式进行微服务调用

添加依赖

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>
```

开启feign注解功能：`@EnableFeignClients`

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
    public String test() {
        return nacosFeignClient.index();
    }
}
```





Nacos Discovery Endpoint(发现端点)

Nacos Discovery内部提供了一个端点，其端点ID为 `nacos-discovery `

端点公开的json包括两个属性：

- 订阅者的信息
-  当前服务的当前基本Nacos配置 





Nacos Discovery Starter配置的更多信息：https://spring-cloud-alibaba-group.github.io/github-pages/greenwich/spring-cloud-alibaba.html#_more_information_about_nacos_discovery_starter_configurations





# Nacos Config（配置中心）

## 快速开始

Nacos Config使用`DataId`和`GROUP`来确定配置 

> DataId的默认文件扩展名是properties



如果要使用配置中心，则需要添加以下依赖：

```xml
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>
</dependency>
```

> 只需引入nacos-config的starter即可开启，再添加上配置文件配好配置中心的地址即可



我们在nacos配置中心中创建相应配置：

![image-20200513155624840](D:\note\.img\image-20200513155624840.png)

>  DataId的默认文件扩展名是properties 
>
> 在创建配置时， DataId需要带上后缀名，在应用程序中指定配置名称时不需要加上后缀名，默认使用properties 后缀，如果使用的是yml格式，需要在配置文件中额外指定文件扩展名为yml：`spring.cloud.nacos.config.file-extension = yaml`



创建一个标准的springboot应用程序

```java
@SpringBootApplication
public class NacosConfigApplication {

    public static void main(String[] args) {
        //通过spring加载NacosConfigApplication，从而加载配置中心中的配置到环境变量
        ConfigurableApplicationContext applicationContext = SpringApplication.run(NacosConfigApplication.class, args);
        //通过环境变量获取配置
        String userName = applicationContext.getEnvironment().getProperty("user.name");
        String userAge = applicationContext.getEnvironment().getProperty("user.age");
        //打印
        System.err.println("user name :" +userName+"; age: "+userAge);
    }
}
```



---



添加`bootstrap.properties` 配置文件

```properties
spring.application.name=nacos-config
spring.cloud.nacos.config.server-addr=127.0.0.1:8848
```

> NacosConfig程序会从`bootstrap.properties`配置文件中读取对应的配置地址信息

默认情况下，配置文件的后缀名是`.properties`，配置文件的名称为默认使用` spring.cloud.nacos.config.prefix `前缀名，如果没有再是` spring.cloud.nacos.config.name `配置名，如果没有再是` spring.application.name `应用名

默认情况下，`GROUP`默认为`DEFAULT_GROUP`,  `namespace`默认为`public`



所以，如上述配置文件配置，则会去地址为`127.0.0.1:8848`的配置中心，寻找DataID为`nacos-config.properties`,`GROUP`为`DEFAULT_GROUP`，`namespace`为`public`的配置文件



---



使用yml格式的DataID配置：

需要在 `bootstrap.properties` 配置文件中额外添加配置文件的扩展名：

```properties
spring.cloud.nacos.config.file-extension = yaml
```



在nacos数据中心配置的信息如下：

![image-20200513161339007](D:\note\.img\image-20200513161339007.png)



---



根据 `spring.profiles.active`来加载配置中心的不同的环境的配置文件：

当通过Nacos Config加载配置时，会加载两个配置文件：

-  DataId为`${spring.application.name}. ${file-extension:properties}` 的配置文件

- DataId为 `${spring.application.name}-${profile}. ${file-extension:properties} `的配置文件

  > ${profile}用指定使用哪个环境的配置文件



Nacos Config Starter配置的更多信息：https://spring-cloud-alibaba-group.github.io/github-pages/greenwich/spring-cloud-alibaba.html#_more_information_about_nacos_config_starter_configurations

## Sentinel（前哨）

 作用：流量控制，断路和负载保护 ； 提供实时监控功能 









​		



