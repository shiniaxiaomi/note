[TOC]

# 总览

SpringFramework的核心就是IOC(自动注入,也称为控制反转)和AOP(面向切面),除此之外,还提供了一些基础服务等...

# 核心

## IOC(重要)

### IOC容器

IOC容器负责实例化,配置和组装java bean,它会根据我们配置的元数据去创建bean,我们可以通过xml或注解的方式去配置元数据

spring提供了IOC容器接口的几种实现:

- 我们通常创建[`ClassPathXmlApplicationContext`](https://docs.spring.io/spring-framework/docs/5.2.0.RELEASE/javadoc-api/org/springframework/context/support/ClassPathXmlApplicationContext.html)类去加载xml配置文件来创建IOC容器
- 我们也可以使用`AnnotationConfigApplicationContext`类去加载使用`@Configuration`注解标注的类来创建IOC容器
- 可以使用[`AnnotationConfigWebApplicationContext`](https://docs.spring.io/spring/docs/5.2.0.RELEASE/spring-framework-reference/core.html#beans-java-instantiating-container-web)类来创建web应用相关的容器

`org.springframework.context.ApplicationContext`接口代表Spring IoC容器

下图是IOC容器实例化和配置java bean的过程图:

![容器魔术](.img/.SpringFramework/container-magic.png)

> Spring容器先去加载所有的元数据配置,然后通过读取我们的实例类,在初始化时将元数据配置好,再将java bean返回

#### 基于xml配置

##### xml的配置详解

##### 基于xml的Demo

1. 创建一个maven工程,导入`spring-context`的pom依赖

   它会将springFramework所用到的jar包引入,如下图所示

   ![1570684755986](.img/.SpringFramework/1570684755986.png)

   ```xml
   <dependency>
       <groupId>org.springframework</groupId>
       <artifactId>spring-context</artifactId>
       <version>5.2.0.RELEASE</version>
   </dependency>
   ```

2. 在src中创建一个Cat类,并创建get和set方法(因为IOC在注入的时候会使用set方法注入)

   ```java
   public class Cat {
       String name;
       public String getName() {
           return name;
       }
       public void setName(String name) {
           this.name = name;
       }
       @Override
       public String toString() {
           return "Cat{" +
                   "name='" + name + '\'' +
                   '}';
       }
   }
   ```

3. 在src中创建一个Dog类,并创建get和set方法(在Dog类中还需要注入一个Cat对象)

   ```java
   public class Dog {
   
       int age;
       String name;
   
       Cat cat;//需要注入一个Cat对象
   
       public int getAge() {
           return age;
       }
   
       public void setAge(int age) {
           this.age = age;
       }
   
       public String getName() {
           return name;
       }
   
       public void setName(String name) {
           this.name = name;
       }
   
       public Cat getCat() {
           return cat;
       }
   
       public void setCat(Cat cat) {
           this.cat = cat;
       }
   
       @Override
       public String toString() {
           return "Dog{" +
                   "age=" + age +
                   ", name='" + name + '\'' +
                   ", cat=" + cat +
                   '}';
       }
   }
   ```

3. 创建spring.xml配置文件(配置元数据)

   ```xml
   <?xml version="1.0" encoding="UTF-8" ?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://www.springframework.org/schema/beans
           https://www.springframework.org/schema/beans/spring-beans.xsd">
   	
       <!-- 自动注入一个dog对象,并设置好成员变量的值 -->
       <bean id="dog" class="xml.Dog">
           <property name="age" value="1"></property>
           <property name="name" value="jack"></property>
           <!-- 使用ref来引用外部的bean当作属性注入 -->
           <property name="cat" ref="cat"></property>
       </bean>
   
   	<!-- 配置一个cat对象 -->
       <bean id="cat" class="xml.Cat">
           <property name="name" value="cat"></property>
       </bean>
   </beans>
   ```

4. 创建Test类

   ```java
   public class Test {
       public static void main(String[] args) {
           ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
           Dog dog = (Dog) context.getBean("dog");
           System.out.println(dog);
       }
   }
   ```

   > 结果: Dog{age=1, name='jack', cat=Cat{name='cat'}}

#### 基于注解配置详解

> 详细的参考文档: https://docs.spring.io/spring/docs/5.2.0.RELEASE/spring-framework-reference/core.html#beans-annotation-config

##### @Autowired

默认首先使用类型匹配,将要注入的对象注入

- 可以标注在构造函数上(一般不使用)

  ```java
  @Autowired
  public MovieRecommender(CustomerPreferenceDao customerPreferenceDao) {
      this.customerPreferenceDao = customerPreferenceDao;
  }
  ```

- 可以标注在set方法上

  ```java
  @Autowired
  public void setMovieFinder(MovieFinder movieFinder) {
      this.movieFinder = movieFinder;
  }
  ```

- 可以标注在字段上

  ```java
  @Autowired
  private MovieCatalog movieCatalog;
  ```

##### @Primary

当有多个bean都符合要求时,被标志@Primary的bean拥有优先的特权被先装配; 如果候选对象中仅存在一个主bean，则它将成为自动装配的值。

```java
@Configuration
public class CatFactory {
    //创建Cat1
    @Bean
    @Primary
    public Cat creatCat(){
        return new Cat("1");
    }

    //创建Cat2
    @Bean
    public Cat creatCat2(){
        return new Cat("2");
    }
}
```

> 创建两个Cat类型的对象,并加入到IOC容器中,默认注入bean的时候是使用类型注入的,那么spring就会找到两个类型为Cat的Javabean对象,则会报错; 但是如果在其中一个bean中标注@Primary注解,那么spring如果找到了两个类型为Cat的对象,则会使用有@Primary标注的Javabean进行自动注入

##### @Qualifier

标注该注解可以起到微调的作用,即当有同类型且多对象的javabean需要装配时,可以使用该注解将多个同类型的兑现区分开进行自动装配,具体使用参考文档

##### @Resource

该注解可以指定Javabean的名称(即id)

```java
@Resource(name = "cat") //指定要根据Javabean的id进行注入
Cat cat;
```

##### @PropertySource和@Value

该注解用于引入外部的配置文件,引入后可以直接使用@Value注解从配置文件中取值注入

创建`application.properties`配置文件

```properties
catalog.name=MovieCatalog
```

创建`AppConfig`配置类

```java
@Component
@PropertySource("classpath:annotation/app.properties") //从外部加载配置文件
public class AppConfig {
    @Value("${catalog.name}") //从配置文件中获取值
    String name;
    @Value("1") //直接指定值
    int age;

    public static void main(String[] args) {
        ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("annotation/spring.xml");
        AppConfig appconfig = (AppConfig) context.getBean("appConfig");
        System.out.println(appconfig.name);
        System.out.println(appconfig.age);
    }
}
```

##### @PostConstruct和@PreDestroy

被`@PostConstruct`标注的方法会在bean实例创建后调用

被`@PreDestroy`标注的方法会在bean销毁后调用

```java
@Component
public class AppConfig {
    //在bean创建后调用
    @PostConstruct
    public void create(){
        System.out.println("创建");
    }

    //在bean销毁前调用
    @PreDestroy
    public void destroy(){
        System.out.println("销毁");
    }

    public static void main(String[] args) {
        ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("annotation/spring.xml");
        AppConfig appconfig = (AppConfig) context.getBean("appConfig");
        context.close();//结束
    }
}
```

##### @Component,@Repository,@Service,@Controller

被上面这些标注的注解表明该类是一个Javabean,需要被扫描进IOC容器中

`@Component`是通用的标注注解,而@Repository,@Service,@Controller这三个是针对更特定用例的专业化（分别在持久性，服务和表示层中使用）

自动命名:

- 在被上述注解标注的类扫描进IOC容器后,IOC容器会为他们自动命令(即JavaBean的id),默认是类名小写,但是

```java
@Component
public void Dog(){
}

@Controller
public void UserController(){
}
```

##### @Configuration和@ComponentScan

被还注解标注的类表明是一个配置类,该注解是一个组合注解,它由`@Component`和其他注解组合而成,所以默认的IOC容器会把标注`@Configuration`的类也扫描进IOC容器

在配置类中,可以使用@Bean注解来在IOC容器中创建Javabean

```java
@Configuration //标注是一个配置
@ComponentScan("annotation") //开启注解扫描,并指定扫描指定的包路径
public class ConfigurationTest {

    @Autowired //使用自动注入的方式注入对象
    Cat cat;

    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(ConfigurationTest.class);
        Cat cat = (Cat) context.getBean("cat");
        System.out.println(cat);
    }
}
```

还可以这样使用

```java
public static void main(String[] args) {
    AnnotationConfigApplicationContext ctx = new AnnotationConfigApplicationContext();
    ctx.scan("com.acme");//手动设置要扫描哪些包下的注解
    ctx.refresh();//再刷新容器
    MyService myService = ctx.getBean(MyService.class);
}
```

##### @Bean

该注解可以显示的将一个有返回值的方法的返回值作为一个Javabean装配到IOC容器

> 注意: 在使用`@Bean`的类必须是要被IOC容器所管理的,如有标注`@@Configuration`,`@Component`等注解的类才可以生效

```java
@Component
public class BeanTest {
    @Bean(name = "cat2")
    public Cat creatCat(){
        return new Cat("2");
    }
}
```

我们还可以通过@Bean注解指定bean初始化时和销毁时调用方法

```java
@Configuration
public class AppConfig {
    //指定该bean初始化
    @Bean(initMethod = "init")
    public BeanOne beanOne() {
        return new BeanOne();
    }
    @Bean(destroyMethod = "cleanup")
    public BeanTwo beanTwo() {
        return new BeanTwo();
    }
}

```

##### @Scope

使用`@Scope("prototype")`注解可以使得JavaBean不是单例,每次请求都会重新产生一个JavaBean

##### @Import

直接简单的导入某些少量的类到IOC容器中

```java
@Component //标记为可以被IOC容器管理的类
@Import(Cat.class) //将Cat类加入到IOC容器中
public class ImportTest {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(ImportTest.class);
        Cat cat = context.getBean(Cat.class);//获取通过@Import注解导入到IOC容器的类
        System.out.println(cat);
    }
}
```

##### 基于注解的Demo

1. 创建一个maven工程,导入`spring-context`的pom依赖

   它会将springFramework所用到的jar包引入,如下图所示

   ![1570684755986](.img/.SpringFramework/1570684755986.png)

   ```xml
   <dependency>
       <groupId>org.springframework</groupId>
       <artifactId>spring-context</artifactId>
       <version>5.2.0.RELEASE</version>
   </dependency>
   ```

2. 在src中创建一个Cat类,并标注@Component注解,默认的bean id为类名小写(cat)

   ```java
   @Component //使用注解标注该类是一个java bean
   public class Cat {
       @Value("cat") //设置要注入的值
       String name;
   
       @Override
       public String toString() {
           return "Cat{" +
                   "name='" + name + '\'' +
                   '}';
       }
   }
   ```

3. 在src中创建一个Dog类,并标注@Component注解,默认的bean id为类名小写(dog)

   ```java
   @Component //使用注解标注该类是一个java bean
   public class Dog {
       
       @Value("1") //通过@Value注解进行注入值,而不需要get和set方法
       int age;
       @Value("jack")
       String name;
       
       @Autowired //使用@Autowired注入Javabean对象,默认找的bean id为cat(即成员变量名称)
       Cat cat;
   
       @Override
       public String toString() {
           return "Dog{" +
                   "age=" + age +
                   ", name='" + name + '\'' +
                   ", cat=" + cat +
                   '}';
       }
   }
   ```

3. 创建spring.xml配置文件,在xml中开启注解扫描

   ```xml
   <?xml version="1.0" encoding="UTF-8" ?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:context="http://www.springframework.org/schema/context"
          xsi:schemaLocation="http://www.springframework.org/schema/beans
           https://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context https://www.springframework.org/schema/context/spring-context.xsd">
   
       <!-- 开启注解扫描,并指定要扫描的包 -->
       <context:component-scan base-package="annotation"/>
   
   </beans>
   ```

4. 创建Test类

   ```java
   public class Test {
       public static void main(String[] args) {
           ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("annotation/spring.xml");
           Dog dog = (Dog) context.getBean("dog");
           System.out.println(dog);
       }
   }
   ```

   > 结果: Dog{age=1, name='jack', cat=Cat{name='cat'}}

#### 关于ApplicationContextEvent的自定义事件

1. ContextRefreshedEvent

   在`ApplicationContext`初始化或刷新时触发该事件

2. ContextStartedEvent

   在`ApplicationContext`调用`start()`方法时触发该事件

3. ContextStoppedEvent

   在`ApplicationContext`调用`stop()`方法时触发该事件

4. ContextClosedEvent

   在`ApplicationContext`调用`close()`方法时触发该事件

5. RequestHandledEvent

   一个特定于Web的事件,在所有Bean HTTP的请求完成后,触发该事件; 此事件仅适用于使用Spring的Web应用程序`DispatcherServlet`

6. ServletRequestHandledEvent

   该类的子类`RequestHandledEvent`添加了特定于Servlet的上下文信息

继承对应的事件父类

ContextClosedEventTest:

```java
@Component
public class ContextClosedEventTest extends ContextClosedEvent {
    public ContextClosedEventTest(ApplicationContext source) throws InterruptedException {
        super(source);
        System.out.println("Closed");
        Thread.sleep(1000);
    }
}
```

ContextRefreshedEventTest:

```java
@Component
public class ContextRefreshedEventTest extends ContextRefreshedEvent {
    public ContextRefreshedEventTest(ApplicationContext source) throws InterruptedException {
        super(source);
        System.out.println("Refreshed");
        Thread.sleep(1000);
    }
}
```

ContextStartedEventTest:

```java
@Component
public class ContextStartedEventTest extends ContextStartedEvent {

    public ContextStartedEventTest(ApplicationContext source) throws InterruptedException {
        super(source);
        System.out.println("Started");
        Thread.sleep(1000);
    }
}
```

ContextStoppedEventTest:

```java
@Component
public class ContextStoppedEventTest extends ContextStoppedEvent {
    public ContextStoppedEventTest(ApplicationContext source) throws InterruptedException {
        super(source);
        System.out.println("Stopped");
        Thread.sleep(1000);
    }
}
```

EventTest:

```java
@Component
@ComponentScan("annotation.event")
public class EventTest{
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(EventTest.class);
    }
}
```

> 运行结果:
>
> Closed
> Refreshed
> Started
> Stopped

### Java Bean

#### bean的作用域

默认将每个IOC容器中的bean设置为单例,使用scope注解可以改变其为多例

#### bean的生命周期

生命周期流程图:

![](.img/.SpringFramework/20160802083636909)

具体流程:

1. 实例化`BeanFactoryPostProcessor`
2. 执行`BeanFactoryPostProcessor`的`postProcessBeanFactory()`方法
3. 实例化`BeanPostProcessor`实现类
4. 实例化`InstantiationAwareBeanPostProcessor`实现类
5. 执行`InstantiationAwareBeanPostProcessor`的`postProcessBeforInstantiation()`方法
6. 执行Bean的构造方法
7. 执行`InstantiationAwareBeanPostProcessor`的`postProcessPropertyValues()`方法
8. 为Bean注入属性
9. 调用`BeanNameAware`的`setBeanName()`方法
10. 调用`BeanFactoryAware`的`setBeanFactory()`方法
11. 执行`BeanPostProcess`的`postProcessBeforeInitialization()`方法
12. 执行`InitializingBean`的`afterPropertiesSet()`方法
13. 调用Bean的init-method属性执行的初始化方法
14. 执行`BeanPostProcessor`的`postProcessAfterInitialization()`方法
15. 执行`InstantiationAwareBeanPostProcessor`的`postProcessAfterInitialization()`方法
16. 容器初始化成功,执行业务代码后,下面开始销毁容器
17. 调用`DiposibleBean`的`Destory()`方法
18. 调用Bean的destory-method属性指定的初始化方法

#### bean的生命周期中的回调函数Demo

```java
@Component
public class BeanEvent implements BeanPostProcessor, InstantiationAwareBeanPostProcessor {
    
    //在bean的构造函数之前调用
    public Object postProcessBeforeInstantiation(Class<?> beanClass, String beanName) throws BeansException {
        System.out.println("postProcessBeforeInstantiation:"+beanName);
        return null;
    }

    //在bean的构造函数之后调用
    public boolean postProcessAfterInstantiation(Object bean, String beanName) throws BeansException {
        System.out.println("postProcessAfterInstantiation:"+beanName);
        return false;
    }

    //在给bean设置属性的时候调用
    public PropertyValues postProcessProperties(PropertyValues pvs, Object bean, String beanName) throws BeansException {
        System.out.println("postProcessProperties:"+beanName);
        return null;
    }

    //在bean初始化之前调用
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("postProcessBeforeInitialization:"+beanName);
        return null;
    }

    //在bean初始化之后调用
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("postProcessAfterInitialization:"+beanName);
        return null;
    }
}
```

测试类:

```java
@Component
@ComponentScan("annotation.beanTest")
public class BeanTest {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(BeanTest.class);
    }
}
```

> 运行结果:
>
> postProcessBeforeInstantiation:beanTest
> postProcessAfterInstantiation:beanTest
> postProcessBeforeInitialization:beanTest
> postProcessAfterInitialization:beanTest

## AOP(重要)

AOP即面向切面编程

使用AOP需要引入对应的maven依赖(AspectJ)

> 其实只需要AspectJ的aspectjweaver.jar(可以使用注解方式),Spring AOP的实现是使用JDK自带的aop实现的

```xml
<dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjweaver</artifactId>
    <version>1.9.4</version>
</dependency>
```

spring中的注解基本上都可以通过AOP来实现,如`@Value`,`@Component`,`@ComponentScan`,`@Bean`,`@Aspect`,`@Pointcut`等,像web应用中的`@Controller`,`@RequestMapping`等,都可以利用AOP来实现

### 定义概念

- Aspect

  切面,是公共抽取出来的模块的集中点; 使用`@Aspect`注解来定义一个切面类

- Join point

  连接点,在程序执行过程中的一个点,例如方法的执行或异常的处理等; 在Spring AOP中,连接点始终代表方法的执行

- Advice

  通知,切面在特定的连接点处所采取的操作,如前置通知,后置通知等

- Pointcut

  切入点,和连接点匹配的谓词,建议与切入点表达式配合使用; 切入点表达式匹配的连接点的概念是AOP的核心

- Target object

  一个或多个切面通知的对象,也称通知对象; 由于Spring AOP是使用运行时代理实现的,因此该对象始终是代理对象

- AOP proxy

  AOP代理对象,由AOP框架创建的一个对象,用于实现切面编程; 在Spring Framework中,AOP代理是JDK动态代理或CGLIB代理

- Weaving

  编织,将切面与其他对象链接以创建通知的对象; 这可以在编译时（例如使用AspectJ编译器）,加载时或在运行时完成,像其他纯Java AOP框架一样,Spring AOP时在运行时执行编织的;

### AOP的5种通知机制

- Before advice

  前置通知,在方法运行前调用

- After returning advice

  返回通知,在方法的返回时调用

- After throwing advice

  异常通知,在方法抛出异常时调用

- After (finally) advice

  后置通知,在方法结束后调用

- Around advice

  环绕通知,在方法的调用前后都会被调用

### 切点表达式(excution)

表达式的语法:

```java
"excution( 权限限定词 返回值 包名.类名.方法名 ( 参数名 ) )"
```

> 在同一包中时包名和类名可以省略,可以直接写方法名
>
> 如果要指定包名下的所有方法,则可以将类名和方法名省略,直接`包名..(..)`即可
>
> 权限限定词可以省略不写,如果不写代表包括所有的权限限定词(private,public等)
>
> 当权限限定词或返回值或方法名为`*`时代表任意内容
>
> 参数名为`..`时代表任意多参数,即进行不匹配参数名,就是同一方法的全部重载都包括

#### 常用切入点表达式

切入点的理解:

- 切入点可以理解成是一个上下两层的刀,在指定的方法中切开,方法就会存在于两把刀的中间,而两把刀的中间内容就可以看作是一个点,是连接上面部分和下面部分的点,所以叫做切入点,也叫连接点; 之后我们可以在切入点之前或之后做一些与业务无关的事情,如日志,事务等,这样就可以很好的解耦;

切入点表达式总共分为以下几类:

- 方法描述匹配

  1. `execution()`: 用于匹配方法执行的连接点

- 方法参数匹配

  1. `args()`: 用于匹配当前执行的方法传入的参数为指定类型的执行方法
  2. `@args()`: 用于匹配当前执行的方法传入的参数持有指定注解的执行方法

- 目标类匹配

  1. `target()`: 用于匹配当前目标对象类型的指定方法;

     > 注意是目标对象的类型匹配,这样就不包括引入接口的类型匹配

  2. `@target()`: 用于匹配当前目标对象类型的指定方法,其中目标对象持有指定的注解

  3. `within()`: 用于匹配指定对象类型内的方法

  4. `@within()`: 用于匹配所有指定注解类型的方法

- 标有指定注解的方法匹配

  1. `@annotation()`: 用于匹配当前执行方法标注指定注解的方法

- 匹配指定名称的bean对象的方法

  1. `bean()`: SpringAOP扩展的表达式,AspectJ没有对应的表达式, 其用于匹配指定名称的bean对象的方法

参考文档:

- [官方文档](https://docs.spring.io/spring/docs/5.2.0.RELEASE/spring-framework-reference/core.html#aop-pointcuts-designators)
- [其他博客](https://www.cnblogs.com/duanxz/p/5217689.html)

##### execution表达式

1. 任何公共方法

   ```java
   @Pointcut("execution(public * * (..))")
   ```

2. 任何名称以set开头的方法

   ```java
   @Pointcut("execution(* set* (..))")
   ```

   > 可以使用正则表达式来进行方法名的匹配

3. 某个类的所有方法

   ```java
   @Pointcut("execution(* annotation.AOP.Person.* (..))")
   ```

4. `AOP`包中所有类的所有方法

   ```java
   @Pointcut("execution(* annotation.AOP.*.* (..))")
   ```

5. `AOP`包或其子包中定义的任何方法

   ```java
   @Pointcut("execution(* annotation.AOP..* (..))")
   ```

##### within表达式

用来指定包中或类中的所有方法,指定的粒度比execution要大

1. 指定Person类中的所有方法

   ```java
   @Pointcut("within(annotation.AOP.Person)")
   ```

2. 指定`AOP`包中的所有类

   ```java
   @Pointcut("within(annotation.AOP.*)")
   ```

3. 指定`AOP`包或其子包中的所有方法

   ```java
   @Pointcut("within(annotation.AOP..*)") 
   ```

##### args表达式

这个属于动态切入点,开销会比较大,最好减少使用

查询接收了哪些参数的方法,该表达式一般可用在接收到前端传过来的form表单的切面

1. 指定接收了一个参数为String类型的所有方法

   ```java
   @Pointcut("args(java.lang.String)")
   ```

##### @annotation表达式

##### bean表达式

指定IOC容器中的bean的名称,那么该bean的所有方法都会被匹配,我们可以使用组合切点表达式使得切点的粒度更小

##### 如果是面向接口去切面

定义一个接口类

```java
public interface StudyInterfacee {
    public void study();
}
```

实现该接口

```java
@Component
public class Person implements StudyInterfacee {
     public void study() {
        System.out.println("study");
    }
}
```

测试

```java
@Configuration
@EnableAspectJAutoProxy //使用注解开启AOP(该类需要被IOC管理才能生效,所以需要加上@Configuration或者@Component)
@ComponentScan("annotation.AOP")
public class AOPTest {
    public static void main(String[] args) throws Exception {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AOPTest.class);
        ((StudyInterfacee)context.getBean("person")).study();//获取对象并调用实现的接口中的方法
        //或者这样使用
        //context.getBean(StudyInterfacee.class)).study();
    }
}
```

> 注意: 在获取使用了AOP并且实现了接口的Javabean时,不能再去用原类型获取Javabean,因为使用了代理,所有类型已经发生了变化,我们可以使用Javabean的id(获取后需要转成接口类型)或者是接口类型去获取对应的Javabean
>
> 即我们可以使用的方法会被限定在接口中定义的方法

#### 组合切点表达式

可以将切入点进行组合,也可以将切点表达式继续组合

示例:

```java
//定义一个切点
@Pointcut("execution(* hello(..))")
public void log(){}

//切点和切点表达式组合
@Before(value = "log() && execution(* study(..))")
public void beforeLog()  {
    System.out.println("before log");
}

//切点表达式和切点表达式组合
@After("execution(* hello(..)) && @annotation(annotation.AOP.LYJ)")
public void afterLog(){
    System.out.println("after log");
}
```

### xml配置-AOP使用Demo

1. 定义一个业务类

   ```java
   //它将在xml中注入到IOC容器中
   public class Person {
       public String hello(String str) throws Exception {
           System.out.println("打招呼:"+str);
           int i=0;//是否抛出异常的开关,用于测试异常通知
           if(i==1){
               throw new Exception("java");
           }
           return str;
       }
   }
   ```

2. 定义一个切面的处理类

   > 发生通知后会调用该处理类的对应的方法

   ```java
   public class AspectClass {
       
       //前置通知
       public void beforeLog(){
           System.out.println("before log");
       }
       
       //后置通知
       public void afterLog(){
           System.out.println("after log");
       }
       
       //环绕通知
       public void aroundLog(ProceedingJoinPoint pjp) throws Throwable {
           //============在业务方法执行之前
           System.out.println("aroundBeforeLog");
           //============在业务方法执行之前
           pjp.proceed();//执行业务方法
           //============在业务方法执行之后
           System.out.println("aroundAfterLog");
           //============在业务方法执行之后
       }
       
       //返回通知
       //不获取返回值
   //    public void afterReturningLog(){
   //        System.out.println("afterReturning log");
   //    }
       //需要获取返回值
       public void afterReturningLog(Object retVal){
           System.out.println("afterReturning log:"+retVal);
       }
       
       //异常通知
       //不获取异常信息
   //    public void afterThrowingLog(){
   //        System.out.println("afterThrowing log");
   //    }
       //需要获取异常信息
       public void afterThrowingLog(Exception ex){
           System.out.println("afterThrowing log:"+ex.getMessage());
       }
   }
   ```

3. 配置xml文件

   ```xml
   <?xml version="1.0" encoding="UTF-8" ?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:aop="http://www.springframework.org/schema/aop"
          xsi:schemaLocation="http://www.springframework.org/schema/beans
           https://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/aop https://www.springframework.org/schema/aop/spring-aop.xsd">
   
       <!-- 将业务类注入IOC容器 -->
       <bean id="person" class="xml.AOP.Person"></bean>
   
       <!-- 将切面类注入IOC容器 -->
       <bean id="aspectClass" class="xml.AOP.AspectClass"></bean>
       
       <!-- 开启AOP功能 -->
       <aop:aspectj-autoproxy/>
   
       <!-- AOP的配置 -->
       <aop:config>
           <!-- 声明一个切面,并指定切面处理类 -->
           <aop:aspect id="aspectClass" ref="aspectClass">
               <!-- 声明一个可重用的切点 -->
               <aop:pointcut id="log" expression="execution(* hello(..))"></aop:pointcut>
   
               <!-- 指定前置通知要调用的方法 -->
               <aop:before method="beforeLog" pointcut-ref="log"></aop:before>
               <!-- 指定后置通知要调用的方法 -->
               <aop:after method="afterLog" pointcut="execution(* hello(..))"></aop:after>
   
               <!-- 指定环绕通知要调用的方法 -->
               <!-- 发现一个问题:如果使用环绕通知后,则返回通知将无法获取到返回值(所以推荐使用前置通知和后置通知) -->
               <!--<aop:around method="aroundLog" pointcut-ref="log" arg-names="pjp"></aop:around>-->
   
               <!-- 指定返回通知要调用的方法 -->
               <!-- 不获取返回值 -->
               <!--<aop:after-returning method="afterReturningLog" pointcut-ref="log"></aop:after-returning>-->
               <!-- 需要获取返回值 -->
               <aop:after-returning method="afterReturningLog" returning="retVal" pointcut-ref="log"></aop:after-returning>
   
               <!-- 指定异常通知要调用的方法 -->
               <!-- 不获取异常信息 -->
               <!--<aop:after-throwing method="afterThrowingLog" pointcut-ref="log"></aop:after-throwing>-->
               <!-- 需要获取异常信息 -->
               <aop:after-throwing method="afterThrowingLog" throwing="ex" pointcut-ref="log"></aop:after-throwing>
           </aop:aspect>
       </aop:config>
   </beans>
   ```

4. 测试类

   > 加载配置文件,获取业务类并调用其方法

   ```java
   public class AOPTest {
       public static void main(String[] args) throws Exception {
           ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("xml/springAOP.xml");
           context.getBean(Person.class).hello("hello");//获取对象并调用对应的方法
       }
   }
   ```

   > 运行结果:
   >
   > before log
   > 打招呼:hello
   > after log
   > afterReturning log:hello

### 注解配置-AOP使用Demo

1. 定义一个业务类

   ```java
   @Component //该业务类必须要被IOC容器管理
   public class Person {
       public String hello(String str) throws Exception {
           System.out.println("打招呼:"+str);
           int i=0;//是否抛出异常的开关,用于测试异常通知
           if(i==1){
               throw new Exception("java");
           }
           return str;
       }
   }
   ```

2. 定义一个切面类

   ```java
   @Component
   @Aspect //标记该类为一个切面类,该注解不能被IOC容器扫描到,所以需要加上@Component才能够被处理
   public class AspectClass {
       //定义一个可重复使用的切点
       @Pointcut("execution(* hello(..))") //使用切点表达式来选择需要切入(织入)的方法
       public void log(){}
   
       //前置通知
       @Before(value = "log()")
       public void beforeLog(){
           System.out.println("before log");
       }
   
       //后置通知
       @After("execution(* hello(..))")
       public void afterLog(){
           System.out.println("after log");
       }
   
       //环绕通知
   //    @Around("log()")
   //    public void aroundLog(ProceedingJoinPoint pjp) throws Throwable {
   //        //============在业务方法执行之前
   //        System.out.println("aroundBeforeLog");
   //        //============在业务方法执行之前
   //        pjp.proceed();//执行业务方法
   //        //============在业务方法执行之后
   //        System.out.println("aroundAfterLog");
   //        //============在业务方法执行之后
   //    }
   
       //返回通知
       //不获取返回值
   //    @AfterReturning("log()")
   //    public void afterReturningLog(){
   //        System.out.println("afterReturning log");
   //    }
       //需要获取返回值
       @AfterReturning(pointcut = "log()",returning = "retVal")
       public void afterReturningLog(Object retVal){
           System.out.println("afterReturning log:"+retVal);
       }
   
       //异常通知
       //不获取异常信息
   //    @AfterThrowing("log()")
   //    public void afterThrowingLog(){
   //        System.out.println("afterThrowing log");
   //    }
       //需要获取异常信息
       @AfterThrowing(pointcut = "log()",throwing = "ex")
       public void afterThrowingLog(Exception ex){
           System.out.println("afterThrowing log:"+ex.getMessage());
       }
   }
   ```

3. 开启AOP功能

   ```java
   @Configuration
   @EnableAspectJAutoProxy //使用注解开启AOP(该类需要被IOC管理才能生效,所以需要加上@Configuration或者@Component)
   @ComponentScan("annotation.AOP")
   public class AOPTest {
       public static void main(String[] args) throws Exception {
           AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AOPTest.class);
           context.getBean(Person.class).hello("hello");//获取对象并调用对象被切面的方法(该对象必须是被IOC容器管理的)
       }
   }
   ```

   > 运行结果:
   >
   > before log
   > 打招呼:hello
   > after log
   > afterReturning log:hello

### 自定义注解,并使用AOP进行切面使用,可实现参数校验或事务等

## 静态资源

## 数据校验

## SpEL表达式

# 测试

# 数据存储

# web servlet

# web Reactive

# 集成其他框架



# 参考文档

[springFramework官方文档](https://docs.spring.io/spring/docs/5.2.0.RELEASE/spring-framework-reference/)

[springFramework API](https://docs.spring.io/spring/docs/5.2.0.RELEASE/javadoc-api/)

[aspectj官方API](https://www.eclipse.org/aspectj/doc/released/runtime-api/index.html)