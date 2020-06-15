首先新建`EnableXXX`注解

例如：

```java
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE})
@Documented
@Import({SwaggerToMdAutoConfiguration.class, URLParam.class})
public @interface EnableSwaggerToMD {

}
```

在`EnableXXX`注解中，我们可以通过`@Import`注解，往SpringIOC容器中导入自动配置类

> 导入`SwaggerToMdAutoConfiguration`自动配置类
>
> 导入`URLParam`类，用来处理并保存从注解导入的参数值

---

在自动配置类中，我们就可以随意的进行配置了，因为它已经是交由spring管理的配置类了

示例：

```java
@Configuration
@ComponentScan(
        basePackages = {"com.lyj.swagger2markdown.service"}
)
@Import(ToMarkdown.class)
public class SwaggerToMdAutoConfiguration  {

    @Bean
    @ConditionalOnMissingBean //如果bean存在，则不创建
    public RestTemplate restTemplate(){
        return new RestTemplate();
    }

}
```

> 通过`@Configuration`标识自动配置类，但是自动配置类不能实现`ImportBeanDefinitionRegistrar`接口，因为这样会导致自动配置类失效

我们可以在自动配置类中做以下事情：

- 可以通过`@ComponentScan`注解告诉spring去扫描哪些包
- 可以通过`@Import`注解再导入其他的类（通过import导入的类可以直接被spring管理）
- 可以在配置类中通过`@Bean`注解配置一些bean
- ...

---

URL参数处理类

```java
public class URLParam implements ImportBeanDefinitionRegistrar {

    //使用static的原因是不让其被重新初始化，覆盖原始值
    public static String url;

    //在导入类的时候回调，用于获取Enable注解的值
    @Override
    public void registerBeanDefinitions(AnnotationMetadata importingClassMetadata, BeanDefinitionRegistry registry) {
        url= (String) importingClassMetadata.
                getAnnotationAttributes("com.lyj.swagger2markdown.annotation.EnableSwaggerToMD")
                .get("url");
    }

}

```

实现`ImportBeanDefinitionRegistrar`接口后，使用注解导入指定类时，会回调接口的方法，并可以拿到注解中传入的参数值

---

接下来看一下通过`@Import`注解`ToMarkdown`类

代码：

```java
public class ToMarkdown implements ApplicationRunner {
    private String host="localhost";
    @Value("${server.port}")
    private int port;
	@Autowired
    ProcessService processService;
    //注入Swagger相关的类
    @Autowired
    DocumentationCache documentationCache;

    //入口
    //服务启动完成后，开始生成md文件
    @Override
    public void run(ApplicationArguments args) throws Exception {
        swaggerToMarkdown(URLParam.url);
    }
    
    ...
}
```

- 我们通过`@Import`在配置类中就将`ToMarkdown`类导入spring中

- 该类还实现了`ApplicationRunner`接口，在springboot启动成功后会回调该接口

---



这个小项目最终是要打成jar发布的，然后被其他项目引用

其他项目在配置类上只要通过`EnableXXX`注解就可以对相应的功能进行开关操作



