## 使用

导入springboot的自动配置依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-autoconfigure</artifactId>
    <version>2.2.1.RELEASE</version>
</dependency>
```



在springboot中，提供了以下几种配置表达式：

- [Class Conditions](https://docs.spring.io/spring-boot/docs/current/reference/html/spring-boot-features.html#boot-features-class-conditions)
  -  @ConditionalOnClass：如果指定的类存在，才生效
  -  @ConditionalOnMissingClass ：如果指定的类存在，不生效
- [Bean Conditions](https://docs.spring.io/spring-boot/docs/current/reference/html/spring-boot-features.html#boot-features-bean-conditions)
  -  @ConditionalOnBean ：如果指定的bean存在，才生效
  -  @ConditionalOnMissingBean ：如果指定的bean已存在，则不生效
- [Property Conditions](https://docs.spring.io/spring-boot/docs/current/reference/html/spring-boot-features.html#boot-features-property-conditions)
  -  @ConditionalOnProperty ：如果在配置文件中存在指定配置，则生效
- [Resource Conditions](https://docs.spring.io/spring-boot/docs/current/reference/html/spring-boot-features.html#boot-features-resource-conditions)
  -  @ConditionalOnResource ：根据如果存在指定静态资源，则生效
- [Web Application Conditions](https://docs.spring.io/spring-boot/docs/current/reference/html/spring-boot-features.html#boot-features-web-application-conditions)
- [SpEL Expression Conditions](https://docs.spring.io/spring-boot/docs/current/reference/html/spring-boot-features.html#boot-features-spel-conditions)



## 注解原理

