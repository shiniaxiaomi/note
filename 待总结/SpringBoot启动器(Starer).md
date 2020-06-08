## 创建Enbale的注解

```java
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE})
@Documented
@Import({SwaggerToMdAutoConfiguration.class})
public @interface EnableSwaggerToMD {
    String url() default "";
}
```

> 该Enbale注解会导入一个自动配置类

## 自动配置类

```java
@Configuration //标识为自动配置类
@ComponentScan( //指定要扫描的包
        basePackages = {"com.lyj.swagger2markdown.service"}
)
@Import(ToMarkdown.class) //指定要导入的类
//该类实现了ImportBeanDefinitionRegistrar接口，则Spring处理对应的Enable注解时，在导入实现了该接口的类时，会回调registerBeanDefinitions方法，可以获取到注解中的参数值
//实现ApplicationRunner接口，可以在SpringBoot应用启动完成之后，会回调run方法，在run方法中，做swagger转md的事情
public class SwaggerToMdAutoConfiguration implements ImportBeanDefinitionRegistrar, ApplicationRunner {

    //使用static的原因是不让其被重新初始化，覆盖原始值
    private static String url;

    //注入swagger转md的类
    @Autowired
    ToMarkdown toMarkdown;

    //在导入类的时候回调，用于获取Enable注解的值
    @Override
    public void registerBeanDefinitions(AnnotationMetadata importingClassMetadata, BeanDefinitionRegistry registry) {
        url= (String) importingClassMetadata.
                getAnnotationAttributes("com.lyj.swagger2markdown.annotation.EnableSwaggerToMD")
                .get("url");
    }

    //入口
    //服务启动完成后，开始生成md文件
    @Override
    public void run(ApplicationArguments args) throws Exception {
        try {
            toMarkdown.swaggerToMarkdown(url);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
```

## 打包

然后将项目打成jar包或者install到maven仓库中，再引入到其他项目中即可使用

使用`EnableXXX`即可进行自动配置