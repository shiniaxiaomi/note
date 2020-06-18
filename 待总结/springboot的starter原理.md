springboot的配置文件中所有的可配置参数 

参考文档：https://docs.spring.io/spring-boot/docs/2.1.0.RELEASE/reference/htmlsingle/#common-application-properties



我们应该从`@SpringBootApplication`注解入手，因为每一个springboot项目都不能缺少这个注解，所以，他的自动配置肯定是从这个注解开启的



在`@SpringBootApplication`注解上，又标注了`@EnableAutoConfiguration`注解，即开启自动配置

在`@EnableAutoConfiguration`注解中，又