# SpringAOP源码

spring采用了JDK动态代理和Cglib动态代理两者结合的方式来创建动态代理



在spring中,默认是使用JDK动态代理

- 当使用`@Aspect`注解和`execution`表达式时,则使用Cglib动态代理

- 当使用`@Transactional`注解时,则使用Cglib动态代理
- 如果使用`ProxyFactory`来创建动态代理,则会使用JDK动态代理



Spring默认使用DefaultAopProxyFactory来产生代理(有两种方式):

- 使用JDK动态代理产生代理类
- 使用Cglib动态代理产生代理类



接下来就通过使用`@Aspect`注解是如何创建出代理类的方式来大致记录一下源码

## 创建Demo

1. 为了简单期间,直接创建一个springboot项目,选择web项目

2. 导入aop的依赖

   ```xml
   <dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-aop</artifactId>
     <version>2.2.2.RELEASE</version>
   </dependency>
   <dependency>
     <groupId>org.springframework</groupId>
     <artifactId>spring-tx</artifactId>
     <version>5.2.2.RELEASE</version>
   </dependency>
   ```

3. 创建普通的业务类

   ```java
   @Component
   public class A{
     public void test(){
       System.out.println("test");
     }
     public A() {
       System.out.println("构造方法:A");
     }
   }
   ```

4. 通过`@Aspect`注解来创建切面类

   ```java
   @Component
   @Aspect
   public class Test {
     @Pointcut("execution(* com.lyj.test1.test.A.* (..))")//创建切点
     private void pointcut(){}
   
     @Before("pointcut()")
     public void before(){
       System.out.println("before");
     }
   }
   ```

> 可以看到,在A类中,我创建了A的构造方法,这样的好处是能够让我们更快的找到AOP的源码所在位置和调用链
>
> 我们只需要在A的构造方法中打一个断点即可,在springboot项目启动时,就会进入到该断点
>
> 为什么要在构造方法中添加断点?
>
> - 因为在springboot启动时,要创建代理类的时候,如果通过`@Aspect`注解则是通过Cglib创建的动态代理,而Cglib就是通过asm修改字节码实现的动态代理,而对应的构造方法则不会改变,那么在创建代理类时就必定会调用其构造方法

## spring中的aop的使用情况

spring默认使用JDK动态代理

- 当使用`@Aspect`注解和`execution`表达式时,则使用Cglib动态代理

- 当使用`@Transactional`注解时,则使用Cglib动态代理
- 如果使用`ProxyFactory`来创建动态代理,则会使用JDK动态代理

## 大致的流程

> 为了简单起见,直接来都是以纯注解(去xml)的配置方式来作为例子记录

首先,spring先去扫描所有标注有`@Component`注解的类,扫描并解析所有的beanDefinition,然后发现Test类中标注有`@Aspect`注解,并且使用了`@EnableAspectJAutoProxy`注解开启了代理,那么,spring就会去解析Test类中的`@Pointcut`和对应的`Advice`(如`@Before`,`@After`等),因为在`@Pointcut`中表达式为`execution(* com.lyj.test1.test.A.* (..)`,则表示将A类中的所有方法都做代理,那么,spring在创建A类时,在bean的生命周期的`postProcessAfterInitialization`回调中,返回A类的代理类,而这个代理类则是由Cglib动态产生的

## 具体步骤

通过`getBean(beanName)`获取A类实例,在`doCreateBean`=>`initializeBean`=>`applyBeanPostProcessorsAfterInitialization`中调用`AnnotationAwareAspectJAutoProxyCreator`的后置处理器的`postProcessAfterInitialization`回调创建代理类

具体的方法如下:

```java
@Override
public Object postProcessAfterInitialization(@Nullable Object bean, String beanName) {
  if (bean != null) {
    Object cacheKey = getCacheKey(bean.getClass(), beanName);
    if (this.earlyProxyReferences.remove(cacheKey) != bean) {
      return wrapIfNecessary(bean, beanName, cacheKey);//创建动态代理
    }
  }
  return bean;
}
```

#### 在`wrapIfNecessary`方法中:

```java
protected Object wrapIfNecessary(Object bean, String beanName, Object cacheKey) {
  if (StringUtils.hasLength(beanName) && this.targetSourcedBeans.contains(beanName)) {
    return bean;
  }
  if (Boolean.FALSE.equals(this.advisedBeans.get(cacheKey))) {
    return bean;
  }
  if (isInfrastructureClass(bean.getClass()) || shouldSkip(bean.getClass(), beanName)) {
    this.advisedBeans.put(cacheKey, Boolean.FALSE);
    return bean;
  }

  //如果有Advice,则创建代理类
  Object[] specificInterceptors = getAdvicesAndAdvisorsForBean(bean.getClass(), beanName, null);
  if (specificInterceptors != DO_NOT_PROXY) {
    this.advisedBeans.put(cacheKey, Boolean.TRUE);
    //创建代理类
    Object proxy = createProxy(
      bean.getClass(), beanName, specificInterceptors, new SingletonTargetSource(bean));
    //将代理的类型缓存
    this.proxyTypes.put(cacheKey, proxy.getClass());
    //返回代理类
    return proxy;
  }

  this.advisedBeans.put(cacheKey, Boolean.FALSE);
  return bean;
}
```

> 该后置处理器的`postProcessAfterInitialization`方法是每个bean都会回调的,在`wrapIfNecessary`方法中,判断bean中是否有`Advice`,如果有,则需要创建代理类并返回,如果没有,则执行返回原始的bean实例
>
> 注意此时的bean已经实例化了

#### 在`createProxy`方法中:

```java
protected Object createProxy(Class<?> beanClass, @Nullable String beanName,
                             @Nullable Object[] specificInterceptors, TargetSource targetSource) {
  //...
	//获取bean中的所有的Advisor
  Advisor[] advisors = buildAdvisors(beanName, specificInterceptors);
  proxyFactory.addAdvisors(advisors);
  proxyFactory.setTargetSource(targetSource);
  customizeProxyFactory(proxyFactory);

  proxyFactory.setFrozen(this.freezeProxy);
  if (advisorsPreFiltered()) {
    proxyFactory.setPreFiltered(true);
  }

  //创建并返回代理类
  return proxyFactory.getProxy(getProxyClassLoader());
}
```

#### 在`getProxy`方法中:

```java
public AopProxy createAopProxy(AdvisedSupport config) throws AopConfigException {
  //如果代理类需要被性能优化 或者 直接代理目标对象 或者 如果没有接口
  if (config.isOptimize() || config.isProxyTargetClass() || hasNoUserSuppliedProxyInterfaces(config)) {
    Class<?> targetClass = config.getTargetClass();
    //如果是接口或者是代理类,则使用JDK动态代理
    if (targetClass.isInterface() || Proxy.isProxyClass(targetClass)) {
      return new JdkDynamicAopProxy(config);
    }
    //否则,使用Cglib动态代理
    return new ObjenesisCglibAopProxy(config);
  }
  else {
    //如果不符合上述条件,则直接使用jdk动态代理
    return new JdkDynamicAopProxy(config);
  }
}
```

> 在创建代理类对象后,一路将代理对象并保存到IOC容器中
>
> 之后在属性注入时,则注入的将是代理类对象

















