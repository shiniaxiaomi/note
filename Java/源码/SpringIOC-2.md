# 介绍

记录解读的SpringIOC的源码

# 结构关系

常用的两个加载配置文件的类`ClassPathXmlApplicationContext`和`AnnotationConfigApplicationContext`的继承关系图：

![image-20191220142326074](/Users/yingjie.lu/Documents/note/.img/image-20191220142326074.png)

这两个类都是`AbstractApplicationContext`抽象类的子类，所以他们两个在构建bean容器时，都会调用其抽象父类`AbstractApplicationContext`的`refresh()`方法，而这个`refresh()`方法就把bean容器创建完成了

# 搭建项目

- 创建一个maven项目，在pom文件中添加spring context依赖
  
  ```xml
  <dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>5.2.1.RELEASE</version>
  </dependency>
  ```

- 编写一个Application运行主类
  
  ```java
  @ComponentScan("test") //标记需要扫描的包
  public class Application {
    public static void main(String[] args) {
      //创建一个注解配置的Context，把自身传入（因为在该类中通过注解指明了需要扫描哪个包）
      AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(Application.class);
      //从容器中获取bean
      TestBean testBean = (TestBean) context.getBean("testBean");
      System.out.println(testBean);
    }
  }
  ```

- 创建测试bean

  ```java
  @Component //标记需要添加到ioc容器中
  public class TestBean {
      public TestBean() {
          System.out.println("初始化bean");
      }
  }
  ```

- 创建AwareBean类，实现`InstantiationAwareBeanPostProcessor`接口

  > 用于调试bean的生命周期，也方便debug源码
  
  ```java
  @Component
  public class AwareBean implements InstantiationAwareBeanPostProcessor {
      /**
       * 顺序1，在bean实例化前被调用
       * @param beanClass 对应bean的类型
       * @param beanName 对应bean的名称
       * @return 如果返回null则继续进行实例化bean；如果返回对应bean，则不继续实例化bean，而直接将返回的bean放入到容器中
       * @throws BeansException
       */
      public Object postProcessBeforeInstantiation(Class<?> beanClass, String beanName) throws BeansException {
        return null;
      }
  
      /**
       * 顺序2，在bean实例化后被调用，判断bean是否需要被自动注入属性
       * @param bean 对应的bean
       * @param beanName 对应的bean的名称
       * @return 如果返回true则允许自动注入属性到该bean中；如果返回false，则跳过该bean的属性注入
       * @throws BeansException
       */
      public boolean postProcessAfterInstantiation(Object bean, String beanName) throws BeansException {
        return true;
      }
  
      /**
       * 顺序3，给对应的bean初始化（设置属性），将PropertyValues中的值设置到bean中
       * @param pvs 需要设置的参数
       * @param bean 要初始化的bean
       * @param beanName bean的名称
       * @return 返回给bean初始化用的参数配置；如果返回null，则使用已经存在的参数
       * @throws BeansException
       */
      public PropertyValues postProcessProperties(PropertyValues pvs, Object bean, String beanName) throws BeansException {
        return null;
      }
  
      /**
       * 顺序4，在bean初始化（设置属性）完成后的before回调
       * @param bean 设置完属性后的bean
       * @param beanName bean的名称
       * @return 返回对应bean实例；如果返回null，则不会执行后续的BeanPostProcessors
       * @throws BeansException
       */
      public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        return bean;
      }
  
      /**
       * 顺序5，在bean初始化（设置属性）完成后的after回调
       * @param bean 设置完属性后的bean
       * @param beanName bean的名称
       * @return 返回对应的bean实例；如果返回null，则不会执行后续的BeanPostProcessors
       * @throws BeansException
       */
      public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
          return bean;
      }
  }
  ```

# 源码过程Debugger方法

在`AwareBean`类中添加一处断点，运行Application主类，当断点进来时，如图所示：

![image-20191220150530860](/Users/yingjie.lu/Documents/note/.img/image-20191220150530860.png)

查看控制台的Debugger窗口

![image-20191220150601670](/Users/yingjie.lu/Documents/note/.img/image-20191220150601670.png)

> 该窗口中记录了堆栈中的所有记录，可以通过查看堆栈信息来快速的定位关键的源码位置

点击Debugger窗口中的init堆栈信息，如图所示：

![image-20191220150803540](/Users/yingjie.lu/Documents/note/.img/image-20191220150803540.png)

对应的代码就会跳转到对应的入栈位置，如图所示：

![image-20191220150916359](/Users/yingjie.lu/Documents/note/.img/image-20191220150916359.png)

根据这种方式，我们就可以方便快速的跟踪完一遍源码

# 源码解析

接下来以`AnnotationConfigApplicationContext`实现类为例进行解析

`AnnotationConfigApplicationContext`的构造函数

```java
public AnnotationConfigApplicationContext(Class<?>... componentClasses) {
  this(); //标记1，主要功能为创建注解的BeanDefinition
  register(componentClasses);//标记2，主要功能为注册指定的组件配置类，这些类是在Application主启动类中传入的入口类，可以传入多个
  refresh();//标记3，主要功能为
}
```

## 标记1-this()

> 在`AnnotatedBeanDefinitionReader`类中

```java
//根据指定的环境创建注解的BeanDefinition
public AnnotatedBeanDefinitionReader(BeanDefinitionRegistry registry, Environment environment) {
  //...
  this.registry = registry;
  this.conditionEvaluator = new ConditionEvaluator(registry, environment, null);//创建条件执行器，之后用来判断是否已存在对应的bean，若存在则不再创建对应的bean
  AnnotationConfigUtils.registerAnnotationConfigProcessors(this.registry);//注册给定的（默认的）注解配置处理器，保存在beanDefs中
}
```

> spring总共默认注册了5中注解配置处理器，分别为：
>
> 1. `org.springframework.context.annotation.internalConfigurationAnnotationProcessor`：@Configuration注解处理器
> 2. `org.springframework.context.annotation.internalAutowiredAnnotationProcessor`：@Autowired注解处理器
> 3. `org.springframework.context.annotation.internalCommonAnnotationProcessor`
> 4. `org.springframework.context.event.internalEventListenerProcessor`：事件监听处理器
> 5. `org.springframework.context.event.internalEventListenerFactory`：事件监听工厂

## 标记2-register()

> 在`AnnotatedBeanDefinitionReader`类中

```java
//注册一个或多个组件
public void register(Class<?>... componentClasses) {
  for (Class<?> componentClass : componentClasses) {
    registerBean(componentClass);//标记4，主要功能为获取对应类上的注解，并进行组件的创建
  }
}
```

### 标记4-registerBean()

> 在`AnnotatedBeanDefinitionReader`类中

```java
private <T> void doRegisterBean(Class<T> beanClass, @Nullable String name,
                                @Nullable Class<? extends Annotation>[] qualifiers, @Nullable Supplier<T> supplier,
                                @Nullable BeanDefinitionCustomizer[] customizers) {
  //创建未注册注解的BeanDefinition，生成指定类的标注的注解信息
  AnnotatedGenericBeanDefinition abd = new AnnotatedGenericBeanDefinition(beanClass);
  //获取类的注解，判断是否有标注condition相关的注解，来判断是否需要跳过该bean的注册
  if (this.conditionEvaluator.shouldSkip(abd.getMetadata())) {
    return;
  }

  abd.setInstanceSupplier(supplier);
  //获取该bean的作用域（单例或多例）
  ScopeMetadata scopeMetadata = this.scopeMetadataResolver.resolveScopeMetadata(abd);
  abd.setScope(scopeMetadata.getScopeName());
  //生成bean的名称（规则为类名首字母小写），如果name有指定，则返回指定的name
  String beanName = (name != null ? name : this.beanNameGenerator.generateBeanName(abd, this.registry));

  //标记5，主要功能是处理该类上标注的通用的注解
  AnnotationConfigUtils.processCommonDefinitionAnnotations(abd);
  if (qualifiers != null) {
    for (Class<? extends Annotation> qualifier : qualifiers) {
      if (Primary.class == qualifier) {
        abd.setPrimary(true);
      }
      else if (Lazy.class == qualifier) {
        abd.setLazyInit(true);
      }
      else {
        abd.addQualifier(new AutowireCandidateQualifier(qualifier));
      }
    }
  }
  if (customizers != null) {
    for (BeanDefinitionCustomizer customizer : customizers) {
      customizer.customize(abd);
    }
  }

  //创建对应bean的一个包装类
  BeanDefinitionHolder definitionHolder = new BeanDefinitionHolder(abd, beanName);
  //判断该bean是否需要被代理，如果不需要，则直接返回bean，如果需要，则创建代理类返回
  definitionHolder = AnnotationConfigUtils.applyScopedProxyMode(scopeMetadata, definitionHolder, this.registry);
  //真正注册Bean，将bean的名称和定义注册到ioc容器中
  BeanDefinitionReaderUtils.registerBeanDefinition(definitionHolder, this.registry);
}
```

#### 标记5-processCommonDefinitionAnnotations()

> 在`AnnotationConfigUtils`类中

```java
static void processCommonDefinitionAnnotations(AnnotatedBeanDefinition abd, AnnotatedTypeMetadata metadata) {
	//尝试获取标注@Lazy注解
  AnnotationAttributes lazy = attributesFor(metadata, Lazy.class);
  //如果lazy不为null，则设置该bean为懒加载
  if (lazy != null) {
    abd.setLazyInit(lazy.getBoolean("value"));
  }
  //第一次进来该条件是必定不成立的，但是之后可能还会调用，所以不要怀疑代码有问题
  else if (abd.getMetadata() != metadata) {
    lazy = attributesFor(abd.getMetadata(), Lazy.class);
    if (lazy != null) {
      abd.setLazyInit(lazy.getBoolean("value"));
    }
  }

  //判断该类是否标注@Primary注解，如果是，则获取并设置值
  if (metadata.isAnnotated(Primary.class.getName())) {
    abd.setPrimary(true);
  }
  //尝试获取标注@DependsOn注解
  AnnotationAttributes dependsOn = attributesFor(metadata, DependsOn.class);
  //如果dependsOn不为null，则获取并设置值
  if (dependsOn != null) {
    abd.setDependsOn(dependsOn.getStringArray("value"));
  }

  //尝试获取标注@Role注解
  AnnotationAttributes role = attributesFor(metadata, Role.class);
  //如果role不为null，则获取并设置值
  if (role != null) {
    abd.setRole(role.getNumber("value").intValue());
  }
  //尝试获取标注@Description注解
  AnnotationAttributes description = attributesFor(metadata, Description.class);
  //如果description不为null，则获取并设置值
  if (description != null) {
    abd.setDescription(description.getString("value"));
  }
}
```

## 标记3-refresh()

> 在`AbstractApplicationContext`类中

```java
@Override
public void refresh() throws BeansException, IllegalStateException {
  synchronized (this.startupShutdownMonitor) {
    // 准备上下文的刷新，记录启动日期，活动标志和初始化配置属性
    prepareRefresh();

    // 告诉子类刷新内部bean工厂
    ConfigurableListableBeanFactory beanFactory = obtainFreshBeanFactory();

    // 标记6，主要功能为准备bean工厂以供在此上下文中使用,添加相关的BeanPostProcessor用于回调
    prepareBeanFactory(beanFactory);

    try {
      // 目前还不知道有什么用
      postProcessBeanFactory(beanFactory);

      // 执行BeanFactory后置处理器（在注释1代码中创建的5个PostProcessor）
      invokeBeanFactoryPostProcessors(beanFactory);

      // 注册拦截bean的创建的bean处理器（只要被扫描的bean属于BeanPostProcessor类型，就会被注册，在此期间会将PostProcessor进行排序等处理操作）
      registerBeanPostProcessors(beanFactory);

      // 目前还不知道有什么用
      initMessageSource();

      // 初始化ApplicationEventMulticaster。如果没有定义，则使用SimpleApplicationEventMulticaster，主要是用于bean的事件监听（如创建，销毁等）
      initApplicationEventMulticaster();

      // 初始化特定上下文子类中的其他特殊bean（方法中默认是没有实现）
      onRefresh();

      // 注册实现了ApplicationListener接口的监听器
      registerListeners();

      // 标记7，主要功能为实例化剩余所有的(非懒加载)单例bean
      finishBeanFactoryInitialization(beanFactory);

      // 标记11，主要功能为推送相应的事件
      finishRefresh();
    }
    catch (BeansException ex) {
			//如果发生异常
      //销毁已经创建的单例bean
      destroyBeans();

      //取消刷新
      cancelRefresh(ex);

      throw ex;
    }
    finally {
      //清空公共缓存
      resetCommonCaches();
    }
  }
}
```

### 标记6-prepareBeanFactory()

> 在`AbstractApplicationContext`类中

```java
protected void prepareBeanFactory(ConfigurableListableBeanFactory beanFactory) {
  //...
  // 注册ApplicationContextAwareProcessor用于回调
  beanFactory.addBeanPostProcessor(new ApplicationContextAwareProcessor(this));
  //...
  // 注册ApplicationListenerDetector用于回调
  beanFactory.addBeanPostProcessor(new ApplicationListenerDetector(this));

  // 判断是否还需要注册LoadTimeWeaverAwareProcessor用于回调，如果有配置的话
  if (beanFactory.containsBean(LOAD_TIME_WEAVER_BEAN_NAME)) {
    beanFactory.addBeanPostProcessor(new LoadTimeWeaverAwareProcessor(beanFactory));
  }
  //...
}
```

### 标记7-finishBeanFactoryInitialization()

> 在`AbstractApplicationContext`类中

```java
protected void finishBeanFactoryInitialization(ConfigurableListableBeanFactory beanFactory) {
  //...
  // 缓存所有bean的metadata定义
  beanFactory.freezeConfiguration();

  // 标记8，主要功能为实例化剩余所有的(非懒加载)单例bean。
  beanFactory.preInstantiateSingletons();
}
```

#### 标记8-preInstantiateSingletons()

> 在`DefaultListableBeanFactory`类中

```java
public void preInstantiateSingletons() throws BeansException {
  //...
	// 创建一个拥有所有的beanDefinitionName的List集合
  List<String> beanNames = new ArrayList<>(this.beanDefinitionNames);

  //===========遍历beanName的集合并创建所有的非懒加载的单例的bean实例===========
  for (String beanName : beanNames) {
    //获取合并后的对应的BeanDefinition
    RootBeanDefinition bd = getMergedLocalBeanDefinition(beanName);
    //如果不是抽象类，且是单例的，且不是懒加载的bean
    if (!bd.isAbstract() && bd.isSingleton() && !bd.isLazyInit()) {
      //如果是FactoryBean
      if (isFactoryBean(beanName)) {
        //...
      }else {
        //标记9，主要功能为创建bean实例（在创建时并且解决了bean的依赖问题）
        //如果不是FactoryBean，则获取bean
        getBean(beanName);
      }
    }
  }
  //===========遍历beanName的集合并创建所有的非懒加载的单例的bean实例===========

  //...
}
```

##### 标记9-getBean()

> 在`AbstractBeanFactory`类中

```java
protected <T> T doGetBean(final String name, @Nullable final Class<T> requiredType,
                          @Nullable final Object[] args, boolean typeCheckOnly) throws BeansException {

  //将传入的beanName转化为标准的beanName
  final String beanName = transformedBeanName(name);
  Object bean;

  //==================获取指定bean定义（如果没找到，则往父工厂找）=======================
  // 尝试从单例缓存中获取对应的bean定义
  Object sharedInstance = getSingleton(beanName);
  //如果获取到了，则返回对应的bean定义
  if (sharedInstance != null && args == null) {
    bean = getObjectForBeanInstance(sharedInstance, name, beanName, null);
  }
  // 如果没获取到，则认为存在循环引用
  else {
    //...
    BeanFactory parentBeanFactory = getParentBeanFactory();
    // 如果该工厂不为null，并且不存在该bean定义
    if (parentBeanFactory != null && !containsBeanDefinition(beanName)) {
      String nameToLookup = originalBeanName(name);
      // 如果属于AbstractBeanFactory类型，转换类型后获取bean定义
      if (parentBeanFactory instanceof AbstractBeanFactory) {
        return ((AbstractBeanFactory) parentBeanFactory).doGetBean(
          nameToLookup, requiredType, args, typeCheckOnly);
      }
      //如果参数不为null，则通过指定参数在该工厂中获取bean定义
      else if (args != null) {
        return (T) parentBeanFactory.getBean(nameToLookup, args);
      }
      //如果requiredType不为null，则委托给标准的getBean方法去获取bean定义
      else if (requiredType != null) {
        return parentBeanFactory.getBean(nameToLookup, requiredType);
      }
      else {
        //如果都不是，则再往父工厂中继续查找bean定义
        return (T) parentBeanFactory.getBean(nameToLookup);
      }
    }
    
    //如果未标记，则标记该bean被创建
    if (!typeCheckOnly) {
      markBeanAsCreated(beanName);
    }

    try {
      //合并指定beanName的bean定义
      final RootBeanDefinition mbd = getMergedLocalBeanDefinition(beanName);
      //检查合并后的bean定义
      checkMergedBeanDefinition(mbd, beanName, args);

      //==============保证当前bean所依赖的bean的全部已经初始化==============
      //获取当前bean的bean依赖
      String[] dependsOn = mbd.getDependsOn();
      if (dependsOn != null) {
        //遍历bean依赖
        for (String dep : dependsOn) {
      		//...
          //注册依赖的bean
          registerDependentBean(dep, beanName);
          //获取并创建依赖的bean
          getBean(dep);
        }
      }
      //==============保证当前bean所依赖的bean的全部已经初始化==============

      //===================接下就是真正的创建bean实例了====================
      // 如果bean是单例
      if (mbd.isSingleton()) {
        //获取指定beanName单实例bean，如果没有，则创建bean，且添加到 单例缓存 中并返回创建的bean
        sharedInstance = getSingleton(beanName, () -> {
          //标记10，主要作用为如果单例缓存中没有指定的bean，则创建对应的bean实例
          return createBean(beanName, mbd, args);
        });
        //获取给定bean实例的对象，如果bean实例是FactoryBean，则通过FactoryBean创建bean后返回
        bean = getObjectForBeanInstance(sharedInstance, name, beanName, mbd);
      }
			// 如果bean是多例
      else if (mbd.isPrototype()) {
        Object prototypeInstance = null;
        try {
          beforePrototypeCreation(beanName);
          //创建原型实例
          prototypeInstance = createBean(beanName, mbd, args);
        }
        finally {
          afterPrototypeCreation(beanName);
        }
        //获取给定原型实例的对象
        bean = getObjectForBeanInstance(prototypeInstance, name, beanName, mbd);
      }
      else {
        //根据bean的Scope来创建对应的bean示例
        //...
      }
    }
    catch (BeansException ex) {
      cleanupAfterBeanCreationFailure(beanName);
      throw ex;
    }
  }
  //==================获取指定bean定义（如果没找到，则往父工厂找）=======================

  // 检查所需的类型是否与实际bean实例的类型匹配
  // 如果不匹配，则转化后返回bean实例
  if (requiredType != null && !requiredType.isInstance(bean)) {
    T convertedBean = getTypeConverter().convertIfNecessary(bean, requiredType);
    return convertedBean;
  }
  //如果匹配，则直接返回bean实例
  return (T) bean;
}
```

###### 标记10-createBean()

> 在`AbstractAutowireCapableBeanFactory`类中

```java
/**
 * 该类的核心方法：创建bean实例，调用PostProcessor后置处理器
 */
@Override
protected Object createBean(String beanName, RootBeanDefinition mbd, @Nullable Object[] args)
  throws BeanCreationException {
  //...
  
  //确定bean的类型
  Class<?> resolvedClass = resolveBeanClass(mbd, beanName);
  if (resolvedClass != null && !mbd.hasBeanClass() && mbd.getBeanClassName() != null) {
    //保存bean的定义
    mbdToUse = new RootBeanDefinition(mbd);
    mbdToUse.setBeanClass(resolvedClass);
  }
  
  // 标记10.1，主要功能为在bean实例化前，拿到所有实现了postProcessBeforeInstantiation方法的类，并遍历回调该方法
  Object bean = resolveBeforeInstantiation(beanName, mbdToUse);
  //如果返回的bean实例不为null，则直接将已经实例化的bean直接返回
  if (bean != null) {
    return bean;
  }

  //标记10.2，主要功能为正常的实例化bean
  //如果返回的bean实例为null，调用doCreateBean方法继续按照流程正常的实例化bean
  Object beanInstance = doCreateBean(beanName, mbdToUse, args);//真正的实例化bean的方法
  return beanInstance;
  
}
```

> 重要：
>
> 在`postProcessBeforeInstantiation()`方法中
>
> - 若返回null，则继续执行bean的实例化
> - 若返回bean实例，则直接返回bean实例，而不继续实例化
>
> 所以，如果需要在bean实例化前替换对应的bean，则可以在`postProcessBeforeInstantiation()`方法中直接返回所需要的bean实例即可

###### ----标记10.1-resolveBeforeInstantiation()

> 在`AbstractAutowireCapableBeanFactory`类中

```java
protected Object resolveBeforeInstantiation(String beanName, RootBeanDefinition mbd) {
  Object bean = null;
  if (!Boolean.FALSE.equals(mbd.beforeInstantiationResolved)) {
    //如果实现了InstantiationAwareBeanPostProcessors接口
    if (!mbd.isSynthetic() && hasInstantiationAwareBeanPostProcessors()) {
      Class<?> targetType = determineTargetType(beanName, mbd);
      if (targetType != null) {
        //标记10.1.1，主要功能为回调所有的BeanPostProcessorsBeforeInstantiation方法（在bean实例化前调用）
        bean = applyBeanPostProcessorsBeforeInstantiation(targetType, beanName);
        //如果返回的bean为null，不符合下面的条件判断，则会在方法结束时返回null，在方法外部继续进行正常的bean实例化，那么对应的BeanPostProcessorsAfterInitialization方法也会被延后，直到bean正常的被实例化后才回调该方法
        if (bean != null) {
          //如果返回的bean不为null，说明bean已经在BeanPostProcessorsBeforeInstantiation回调中被创建并返回，因为bean已经被创建了，所以在这里应该直接调用BeanPostProcessorsAfterInitialization方法（在bean实例化后调用）
          //applyBeanPostProcessorsAfterInitialization()方法回调所有的BeanPostProcessorsAfterInitialization方法
          bean = applyBeanPostProcessorsAfterInitialization(bean, beanName);
        }
      }
    }
    mbd.beforeInstantiationResolved = (bean != null);
  }
  return bean;
}
```

> 因此，`BeanPostProcessorsBeforeInstantiation()`是在bean实例化前被调用的，而`BeanPostProcessorsAfterInitialization()`是在bean实例化后被调用的

###### --------标记10.1.1-applyBeanPostProcessorsBeforeInstantiation()

```java
@Nullable
protected Object applyBeanPostProcessorsBeforeInstantiation(Class<?> beanClass, String beanName) {
  //先从getBeanPostProcessors()中获取到所有实现了postProcessBeforeInstantiation()方法的类
  //在通过for循环挨个回调postProcessBeforeInstantiation()方法
  for (BeanPostProcessor bp : getBeanPostProcessors()) {
    //如果bp属于InstantiationAwareBeanPostProcessor类型
    if (bp instanceof InstantiationAwareBeanPostProcessor) {
      InstantiationAwareBeanPostProcessor ibp = (InstantiationAwareBeanPostProcessor) bp;
      //回调postProcessBeforeInstantiation()方法
      Object result = ibp.postProcessBeforeInstantiation(beanClass, beanName);
      //如果回调结果不为空，则说明在回调中已经创建并返回了bean，那么直接返回已创建的bean
      if (result != null) {
        return result;
      }
    }
  }
  //如果全部回调完，则返回null，继续正常的实例化bean
  return null;
}
```

> Spring很粗暴的拿到了所有的有实现回调类，然后每次都遍历并通过类型判断是否需要进行回调

> `getBeanPostProcessors()`方法获取到的回调链为（有顺序要求）：
>
> 1. `ApplicationContextAwareProcessor`：是`InstantiationAwareBeanPostProcessor`类型
> 2. `ConfigurationClassPostProcessor`：不是`InstantiationAwareBeanPostProcessor`类型
> 3. `PostProcessorRegistrationDelegate`：不是`InstantiationAwareBeanPostProcessor`类型
> 4. `AwareBean`：自己创建的bean，实现了`InstantiationAwareBeanPostProcessor`接口
> 5. `CommonAnnotationBeanPostProcessor`：是`InstantiationAwareBeanPostProcessor`类型
> 6. `AutowiredAnnotationBeanPostProcessor`：不是`InstantiationAwareBeanPostProcessor`类型
> 7. `ApplicationListenerDetector`：不是`InstantiationAwareBeanPostProcessor`类型
>
> 所以，被回调的就只有下这些：
>
> - `ApplicationContextAwareProcessor`
> - `AwareBean`
> - `CommonAnnotationBeanPostProcessor`

###### ----标记10.2-doCreateBean()

```java
protected Object doCreateBean(final String beanName, final RootBeanDefinition mbd, final @Nullable Object[] args) throws BeanCreationException {

  //定义实例包装器的引用
  BeanWrapper instanceWrapper = null;
  //如果是单例
  if (mbd.isSingleton()) {
    //从工厂bean实例缓存中删除对应的bean实例
    instanceWrapper = this.factoryBeanInstanceCache.remove(beanName);
  }
  //如果实例包装器的引用为null
  if (instanceWrapper == null) {
    //标记10.2.1，主要作用为创建bean实例，并返回bean实例的包装器
    instanceWrapper = createBeanInstance(beanName, mbd, args);
  }
  //获取真实的bean实例
  final Object bean = instanceWrapper.getWrappedInstance();
  //获取bean的类型
  Class<?> beanType = instanceWrapper.getWrappedClass();
  if (beanType != NullBean.class) {
    mbd.resolvedTargetType = beanType;
  }

  //Spring允许在这里通过后置处理器去修改bean的定义，修改以后的用于beanFactory的bean
  applyMergedBeanDefinitionPostProcessors(mbd, beanType, beanName);

  // 通过以下代码可以解决bean的循环引用问题
  boolean earlySingletonExposure = (mbd.isSingleton() && this.allowCircularReferences &&
                                    isSingletonCurrentlyInCreation(beanName));
  if (earlySingletonExposure) {
    addSingletonFactory(beanName, () -> getEarlyBeanReference(beanName, mbd, bean));
  }

  //以下为初始化bean的代码
  Object exposedObject = bean;
  //标记10.2.2，主要功能为回调所有的postProcessAfterInstantiation()方法，并设置bean的属性
  populateBean(beanName, mbd, instanceWrapper);
  //标记10.2.3，主要功能为回调所有的postProcessBeforeInitialization()方法，并初始化bean
  exposedObject = initializeBean(beanName, exposedObject, mbd);

  // 通过以下代码可以解决bean的循环引用问题
  if (earlySingletonExposure) {
    Object earlySingletonReference = getSingleton(beanName, false);
    if (earlySingletonReference != null) {
      if (exposedObject == bean) {
        exposedObject = earlySingletonReference;
      }
      else if (!this.allowRawInjectionDespiteWrapping && hasDependentBean(beanName)) {
        String[] dependentBeans = getDependentBeans(beanName);
        Set<String> actualDependentBeans = new LinkedHashSet<>(dependentBeans.length);
        for (String dependentBean : dependentBeans) {
          if (!removeSingletonIfCreatedForTypeCheckOnly(dependentBean)) {
            actualDependentBeans.add(dependentBean);
          }
        }
        if (!actualDependentBeans.isEmpty()) {
          throw new BeanCurrentlyInCreationException(beanName,"Bean with name '" + beanName + "' has been injected into other beans");
        }
      }
    }
  }

  //...
  //返回创建的bean实例
  return exposedObject;
}
```

###### --------标记10.2.1-createBeanInstance()

> 在`AbstractAutowireCapableBeanFactory`类中

```java
/**
 * 使用适当的实例化策略为指定的bean创建一个新实例:工厂方法、构造函数或使用无参构造函数实例化。
 */
protected BeanWrapper createBeanInstance(String beanName, RootBeanDefinition mbd, @Nullable Object[] args) {
  //获取指定beanName的类型
  Class<?> beanClass = resolveBeanClass(mbd, beanName);

  Supplier<?> instanceSupplier = mbd.getInstanceSupplier();
  if (instanceSupplier != null) {
    return obtainFromSupplier(instanceSupplier, beanName);
  }

  //如果获取到bean工厂的名称，则使用工厂方法实例化bean
  if (mbd.getFactoryMethodName() != null) {
    return instantiateUsingFactoryMethod(beanName, mbd, args);
  }

  //...
  //如果bean已经实例化
  if (resolved) {
    //如果必须自动装配
    if (autowireNecessary) {
      //通过有参的构造函数实例化bean（通过参数的类型匹配）
      return autowireConstructor(beanName, mbd, null, null);
    }
    else {
      //使用默认无参的构造方法实例化bean
      return instantiateBean(beanName, mbd);
    }
  }

  //如果bean未实例化
  //获取构造函数
  Constructor<?>[] ctors = determineConstructorsFromBeanPostProcessors(beanClass, beanName);
  //如果构造函数不为空或者指定了通过构造函数实例化或者有传入参数
  if (ctors != null || mbd.getResolvedAutowireMode() == AUTOWIRE_CONSTRUCTOR ||
      mbd.hasConstructorArgumentValues() || !ObjectUtils.isEmpty(args)) {
    //通过有参的构造函数实例化
    return autowireConstructor(beanName, mbd, ctors, args);
  }

  //获取推荐的构造函数
  ctors = mbd.getPreferredConstructors();
 	//如果不为空，则使用构造函数创建
  if (ctors != null) {
    return autowireConstructor(beanName, mbd, ctors, null);
  }

  //没有特别的指定，则使用无参的构造函数实例化bean
  return instantiateBean(beanName, mbd);
}
```

###### --------标记10.2.2-populateBean()

> 在`AbstractAutowireCapableBeanFactory`中

```java
protected void populateBean(String beanName, RootBeanDefinition mbd, @Nullable BeanWrapper bw) {
  //...

  //通过回调所有符合条件的postProcessAfterInstantiation()方法，这可以在bean的属性设置之前去修改bean的属性，如字段注入等
  if (!mbd.isSynthetic() && hasInstantiationAwareBeanPostProcessors()) {
    for (BeanPostProcessor bp : getBeanPostProcessors()) {
      //遍历所有的BeanPostProcessors，如果类型为InstantiationAwareBeanPostProcessor
      if (bp instanceof InstantiationAwareBeanPostProcessor) {
        InstantiationAwareBeanPostProcessor ibp = (InstantiationAwareBeanPostProcessor) bp;
        //回调对应的postProcessAfterInstantiation()方法
        //如果回调返回为false，则跳过bean属性的自动注入；如果为true，则继续自动注入属性到该bean中
        //重要：所以，如果我们需要修改bean的属性，则可以在postProcessAfterInstantiation()回调中修改对应的bean属性，然后返回false，则跳过了该bean属性的自动注入，实现了可以自定义bean的属性
        if (!ibp.postProcessAfterInstantiation(bw.getWrappedInstance(), beanName)) {
          continueWithPropertyPopulation = false;
          break;
        }
      }
    }
  }

  //如果在回调中返回false，那么直接结束该方法，不继续之后的bean的属性注入
  if (!continueWithPropertyPopulation) {
    return;
  }

  //如果在回调中返回true，则进行下面的属性注入
  //获取属性值
  PropertyValues pvs = (mbd.hasPropertyValues() ? mbd.getPropertyValues() : null);

  //获取自动注入的类型
  int resolvedAutowireMode = mbd.getResolvedAutowireMode();
  //按名称自动注入或者按类型自动注入
  if (resolvedAutowireMode == AUTOWIRE_BY_NAME || resolvedAutowireMode == AUTOWIRE_BY_TYPE) {
    MutablePropertyValues newPvs = new MutablePropertyValues(pvs);
    // 根据名称注入属性
    if (resolvedAutowireMode == AUTOWIRE_BY_NAME) {
      autowireByName(beanName, mbd, bw, newPvs);
    }
    // 根据类型注入属性
    if (resolvedAutowireMode == AUTOWIRE_BY_TYPE) {
      autowireByType(beanName, mbd, bw, newPvs);
    }
    pvs = newPvs;
  }

  //判断有无实现了InstantiationAwareBeanPostProcessor接口
  boolean hasInstAwareBpps = hasInstantiationAwareBeanPostProcessors();
  //如果实现了
  if (hasInstAwareBpps) {
    for (BeanPostProcessor bp : getBeanPostProcessors()) {
      //遍历BeanPostProcessor链，并判断是否属于InstantiationAwareBeanPostProcessor类型
      //如果属于该类型，则回调所有的postProcessProperties()方法，可以在该方法中修改需要设置的属性值
      if (bp instanceof InstantiationAwareBeanPostProcessor) {
        InstantiationAwareBeanPostProcessor ibp = (InstantiationAwareBeanPostProcessor) bp;
        //回调postProcessProperties()方法
        PropertyValues pvsToUse = ibp.postProcessProperties(pvs, bw.getWrappedInstance(), beanName);
        //如果回调结果为null，则使用默认的属性进行属性注入
        if (pvsToUse == null) {
          //获取默认的属性值
          pvsToUse = ibp.postProcessPropertyValues(pvs, filteredPds, bw.getWrappedInstance(), beanName);
          //默认的属性值为null，则无需注入，直接返回
          if (pvsToUse == null) {
            return;
          }
        }
        //如果回调结果不为null，则将回调返回的修改后的属性赋值给pvs变量，用于之后的属性注入
        pvs = pvsToUse;
      }
    }
  }
  //...
	//如果属性值不为null，则进行属性注入
  if (pvs != null) {
    applyPropertyValues(beanName, mbd, bw, pvs);
  }
}
```

> 重要：
>
> 在`postProcessAfterInstantiation()`回调中，可以修改对应的bean的属性，然后返回false，那么就可以跳过该bean的属性自动注入，从而达到修改对应bean的属性的目的

###### --------标记10.2.3-initializeBean()

> 在`AbstractAutowireCapableBeanFactory`中

```java
protected Object initializeBean(final String beanName, final Object bean, @Nullable RootBeanDefinition mbd) {
  //...
  Object wrappedBean = bean;
  if (mbd == null || !mbd.isSynthetic()) {
    //标记10.2.3.1，主要功能为回调所有的postProcessBeforeInitialization()方法（在属性设值之后，初始化之前回调）
    wrappedBean = applyBeanPostProcessorsBeforeInitialization(wrappedBean, beanName);
  }

  //标记10.2.3.2，主要功能为调用bean的init方法进行初始化
  invokeInitMethods(beanName, wrappedBean, mbd);
  
  if (mbd == null || !mbd.isSynthetic()) {
    //标记10.2.3.3，主要功能为调用所有的postProcessAfterInitialization()方法（初始化之后回调）
    wrappedBean = applyBeanPostProcessorsAfterInitialization(wrappedBean, beanName);
  }

  //返回bean的包装类
  return wrappedBean;
}
```

###### ----------------10.2.3.1-applyBeanPostProcessorsBeforeInitialization()

> 在`AbstractAutowireCapableBeanFactory`中

```java
public Object applyBeanPostProcessorsBeforeInitialization(Object existingBean, String beanName)
  throws BeansException {

  Object result = existingBean;
  for (BeanPostProcessor processor : getBeanPostProcessors()) {
    //遍历BeanPostProcessor链，回调postProcessBeforeInitialization()方法
    Object current = processor.postProcessBeforeInitialization(result, beanName);
    //如果回调返回null，则直接结束方法，不继续遍历BeanPostProcessor链
    if (current == null) {
      return result;
    }
    //如果回调返回结果不为null，则将返回的bean保存到result中，用于最后bean的返回
    result = current;
  }
  //遍历结束后，返回bean
  return result;
}
```

> 在通过调用`getBeanPostProcessors()`获取到的BeanPostProcessor链，有几个比较特殊的BeanPostProcessor：
>
> 1. `test.AwareBean`：第一个就是我们自己写的`AwareBean`类，因为会调用该类实现的`postProcessBeforeInitialization()`方法
> 2. `org.springframework.context.annotation.CommonAnnotationBeanPostProcessor`：第二个是这个类，在该类的`postProcessBeforeInitialization()`方法中会循环调用所有的标注有`@PostConstruct`，`@PreDestroy`和`@Resource`注解的方法

###### ----------------10.2.3.2-invokeInitMethods()

> 在`AbstractAutowireCapableBeanFactory`中

```java
//执行实现了InitializingBean接口的bean的初始化方法
protected void invokeInitMethods(String beanName, final Object bean, @Nullable RootBeanDefinition mbd)
  throws Throwable {

  //判断bean是否实现了InitializingBean接口
  boolean isInitializingBean = (bean instanceof InitializingBean);
  if (isInitializingBean && (mbd == null || !mbd.isExternallyManagedInitMethod("afterPropertiesSet"))) {
    //则回调bean的afterPropertiesSet()方法（用于bean的初始化）
    if (System.getSecurityManager() != null) {
      AccessController.doPrivileged((PrivilegedExceptionAction<Object>) () -> {
						((InitializingBean) bean).afterPropertiesSet();
						return null;
					}, getAccessControlContext());
    }
    else {
      ((InitializingBean) bean).afterPropertiesSet();
    }
  }
	
  //...
}
```

###### ----------------10.2.3.3-applyBeanPostProcessorsAfterInitialization()

> 在`AbstractAutowireCapableBeanFactory`中

```java
public Object applyBeanPostProcessorsAfterInitialization(Object existingBean, String beanName)
  throws BeansException {

  Object result = existingBean;
  for (BeanPostProcessor processor : getBeanPostProcessors()) {
    //遍历BeanPostProcessor链，回调postProcessAfterInitialization()方法
    Object current = processor.postProcessAfterInitialization(result, beanName);
    //如果回调返回null，则直接结束方法，不继续遍历BeanPostProcessor链
    if (current == null) {
      return result;
    }
    //如果回调返回结果不为null，则将返回的bean保存到result中，用于最后bean的返回
    result = current;
  }
  //遍历结束后，返回bean
  return result;
}
```

### 标记11-finishRefresh()

> 在`AbstractApplicationContext`类中

```java
//调用LifecycleProcessor来完成此上下文的刷新方法并发布
protected void finishRefresh() {
  //清除上下文的资源缓存
  this.clearResourceCaches();
  //初始化生命周期的处理器
  //如果有实现LifecycleProcessor接口的类，则实例化处理器，如果没有实现，则实例化默认的处理器
  this.initLifecycleProcessor();
  //获取生命周期的处理器并刷新
  this.getLifecycleProcessor().onRefresh();
  //推送最终的刷新事件
  this.publishEvent((ApplicationEvent)(new ContextRefreshedEvent(this)));
  
  LiveBeansView.registerApplicationContext(this);
}
```

# Spring的调用栈

1. org.springframework.context.support.AbstractApplicationContext#refresh

  2. org.springframework.context.support.AbstractApplicationContext#finishBeanFactoryInitialization

    3. org.springframework.beans.factory.config.ConfigurableListableBeanFactory#preInstantiateSingletons

      4. org.springframework.beans.factory.support.AbstractBeanFactory#getBean(java.lang.String)	

        5. org.springframework.beans.factory.support.AbstractBeanFactory#createBean

          6. org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory#resolveBeforeInstantiation

            7. org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory#applyBeanPostProcessorsBeforeInstantiation

              8. org.springframework.beans.factory.config.InstantiationAwareBeanPostProcessor#postProcessBeforeInstantiation

                > 回调所有的`postProcessBeforeInstantiation`方法

        6. org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory#doCreateBean

          7. org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory#createBeanInstance

            8. org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory#instantiateBean

              > 在方法中，Spring会决定使用哪个构造方法去实例化bean
              >
              > 在这个方法中，会调用bean的构造方法

          8. org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory#applyMergedBeanDefinitionPostProcessors

             1. org.springframework.beans.factory.support.MergedBeanDefinitionPostProcessor#postProcessMergedBeanDefinition

                > 回调所有的`postProcessMergedBeanDefinition`方法

          9. org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory#populateBean

            9. org.springframework.beans.factory.config.InstantiationAwareBeanPostProcessor#postProcessAfterInstantiation

              > 回调所有的`postProcessAfterInstantiation`方法

            10. org.springframework.beans.factory.config.InstantiationAwareBeanPostProcessor#postProcessProperties

              > 回调所有的`postProcessProperties`方法

          10. org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory#initializeBean(String, Object,RootBeanDefinition)

            10. org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory#applyBeanPostProcessorsBeforeInitialization
          
    11. org.springframework.beans.factory.config.BeanPostProcessor#postProcessBeforeInitialization
          
      > 回调所有的`postProcessBeforeInitialization`方法:
              >
      > 1. 首先回调实现了InstantiationAwareBeanPostProcessor接口的`postProcessBeforeInitialization`方法
                > 2. 在回调InitDestroyAnnotationBeanPostProcessor类的`postProcessBeforeInitialization`方法（即有标注@PostConstruct注解的方法）

            11. org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory#invokeInitMethods

              12. org.springframework.beans.factory.InitializingBean#afterPropertiesSet

                > 回调实现了InitializingBean接口的`afterPropertiesSet`方法

            12. org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory#applyBeanPostProcessorsAfterInitialization

              13. org.springframework.beans.factory.config.BeanPostProcessor#postProcessAfterInitialization
  
                > 回调所有的`postProcessAfterInitialization`方法
          
        
  
2. org.springframework.context.support.AbstractApplicationContext#close

   1. org.springframework.context.support.AbstractApplicationContext#destroyBeans

      1. org.springframework.beans.factory.config.ConfigurableBeanFactory#destroySingletons

         1. org.springframework.beans.factory.support.DefaultSingletonBeanRegistry#destroySingletons

            1. org.springframework.beans.factory.support.DisposableBeanAdapter#destroy

               1. org.springframework.beans.factory.config.DestructionAwareBeanPostProcessor#postProcessBeforeDestruction

                  > 回调所有的`postProcessBeforeDestruction`方法（即有标注@PreDestroy注解的方法）

# 9个BeanPostProcessor的执行顺序

1. 回调所有的`postProcessBeforeInstantiation`

   > 在此期间执行bean的构造方法

2. 回调所有的`postProcessMergedBeanDefinition`

3. 回调所有的`postProcessAfterInstantiation`

4. 回调所有的`postProcessProperties`

5. 回调所有的`postProcessBeforeInitialization`

   

6. 回调所有的`afterPropertiesSet`

7. 回调所有的`postProcessAfterInitialization`

8. 当调用close方法时，回调所有的`postProcessBeforeDestruction`





















