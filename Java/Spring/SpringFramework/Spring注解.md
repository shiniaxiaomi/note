# 介绍

Spring中的相关注解

# 普通注解

# 元注解

### @Target

指定注解能够标注在哪些对象上（类，对象。。。）

### @Retention

指定注解能够保留到什么时候（编译前，运行时。。。）

### @Inherited

标注了该元注解的注解会被继承

# 常用注解

























# 问题

## @Autowired,@Resource,@Qualifier的区别

@Autowired是spring的定义注解,而@Resource是JSR-250规范定义的注解

- @Resource

  默认按照名称匹配; 有两种注入方式可以使用:一种是按名称注入,一种是按类型注入

  1. 如果同时指定了名称和类型,那么就会去找两个都匹配的唯一bean注入,如果找不到,则报错
  2. 只指定了按名称注入,则去找名称匹配的唯一bean注入,如果找不到,则报错
  3. 只指定了按类型注入,则去找类型匹配的唯一bean注入,如果找不到,则报错
  4. 如果即没指定名称也没指定类型,则自动按照名称(变量名称)去匹配,如果没有匹配,则按照原始类型去匹配,如果还是没有匹配,则报错

- @Autowired

  按照类型匹配; 并且默认类型必须存在,如果不存在,则报错

  如果需要匹配不到允许为null,可以设置为`@Autowired(required=false)`

- @Qualifier

  如果使用@Autowired会按照类型注入,但是当spring上下文中存在多个同类型的bean时,就需要使用@Qualifier指定在多个同类型的bean中再通过名称匹配注入

  示例:

  ```java
  @Autowired   
  @Qualifier("userServiceImpl")   
  public IUserService userService;   
  ```

  或

  ```java
  @Autowired   
  public void setUserDao(@Qualifier("userDao") UserDao userDao) {   
      this.userDao = userDao;   
  }  
  ```

# 总结

## 定义bean的注解

- @Controller

  定义控制层Bean

  通过`@Controller("Bean的名称")`可以定义控制层bean的名称

- @Service 

  定义业务层Bean

  通过`@Service("Bean的名称")`可以定义业务层bean的名称

- @Repository 

  定义DAO层Bean

  通过`@Repository("Bean的名称")`可以定义DAO层Bean的名称

- @Component  

  定义Bean, 不好归类时使用

  通过`@Component("Bean的名称")`可以定义Bean的名称

## 自动装配bean的注解

- @Autowired

  默认按类型注入,如果没匹配,则报错

- @Qualifier

  一般作为@Autowired注解的修饰(@Autowired和@Qualifier一起使用),在存在多个同类型bean时通过@Qualifier指定的名称去注入

- @Resource

  默认按照名称注入,如果没匹配,则报错

  可以通过名称和类型属性进行选择性的注入

## 定义Bean的作用域和生命过程注解

- @Scope("prototype")

  值有:singleton,prototype,session,request,session,globalSession

  设置bean的作用域为原型

  如果不标注,则默认为单例

- @PostConstruct 

  标注在方法上,在bean初始化之前执行

- @PreDestroy 

  标注在方法上,在bean销毁之前执行

## 声明式事务注解

- @Transactional

  标注该注解的方法在抛出异常时能够进行回滚操作

  默认捕获的是运行时异常

  如果只需要指定异常类型,则可以使用如`@Transactional(Exception.class)`

























