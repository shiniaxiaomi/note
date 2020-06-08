首先新建`EnableXXX`注解

例如：

```java
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE})
@Documented
@Import({SwaggerToMdAutoConfiguration.class})
public @interface EnableSwaggerToMD {

}
```



在`EnableXXX`注解中，我们可以通过`@Import`注解，往SpringIOC容器中导入自动配置类

>  前提是该类是交给spring管理的，即标注了`@Component`注解，才能够生效



在自动配置类中，我们就可以随意的进行配置了，因为它已经是交由spring管理的配置类了

示例：

```java
@Configuration
@ComponentScan(
        basePackages = {"com.lyj.swagger2markdown.service"}
)
@Import(ToMarkdown.class)
public class SwaggerToMdAutoConfiguration {
    @Bean
    public RestTemplate restTemplate(){
        return new RestTemplate();
    }
}
```



我们可以在自动配置类中做以下事情：

- 可以通过`@ComponentScan`注解告诉spring去扫描哪些包
- 可以通过`@Import`注解再导入其他的类（前提是被spring管理才能生效）
- 可以在配置类中通过`@Bean`注解配置一些bean
- ...



接下来看一下通过`@Import`注解`ToMarkdown`类

代码：

```java
@Component
public class ToMarkdown implements ApplicationRunner {
    @Value("${server.port}")
    int port;
    
    @Autowired
    ProcessService processService;

    //服务启动完成后，开始生成md文件
    @Override
    public void run(ApplicationArguments args) throws Exception {
        ...
    }
}
```

- 我们通过`@Component`将该类交给spring管理

  > 前提是我们在自动配置类中告诉spring要扫描的bean的路径

  然后我们就可以使用springIOC来自动注入一些需要的配置和类

- 该类还实现了`ApplicationRunner`接口，在springboot启动成功后会回调该接口

---



这个小项目最终是要打成jar发布的，然后被其他项目引用

其他项目在配置类上只要通过`EnableXXX`注解就可以对相应的功能进行开关操作



