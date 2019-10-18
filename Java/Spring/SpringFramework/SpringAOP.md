[TOC]

# 介绍

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

# 定义概念

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

# AOP的5种通知机制

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

# 切点表达式(excution)

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

## 常用切入点表达式

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

### execution表达式

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

### within表达式

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

### args表达式

这个属于动态切入点,开销会比较大,最好减少使用

查询接收了哪些参数的方法,该表达式一般可用在接收到前端传过来的form表单的切面

1. 指定接收了一个参数为String类型的所有方法

   ```java
   @Pointcut("args(java.lang.String)")
   ```

### @annotation表达式

### bean表达式

指定IOC容器中的bean的名称,那么该bean的所有方法都会被匹配,我们可以使用组合切点表达式使得切点的粒度更小

### 如果是面向接口去切面

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

## 组合切点表达式

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

# xml配置-AOP使用Demo

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

# 注解配置-AOP使用Demo

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

# 自定义注解,并使用AOP进行切面使用,可实现参数校验或事务等