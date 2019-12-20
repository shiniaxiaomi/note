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
  this(); //注释1，主要功能为创建注解的BeanDefinition
  register(componentClasses);//注释2，主要功能为注册指定的组件配置类，这些类是在Application主启动类中传入的入口类，可以传入多个
  refresh();//注释3，主要功能为
}
```

1. 注释1中`AnnotatedBeanDefinitionReader()`的主要代码

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

2. 注释2中`register()`的主要代码

  > 在`AnnotatedBeanDefinitionReader`类中

  ```java
  //注册一个或多个组件
  public void register(Class<?>... componentClasses) {
    for (Class<?> componentClass : componentClasses) {
      registerBean(componentClass);//注释4，主要功能为获取对应类上的注解，并进行组件的创建
    }
  }
  ```

  1. 注释4中`doRegisterBean()`的主要代码

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
    
      //注释5，主要功能是处理该类上标注的通用的注解
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

  2. 注释5中`processCommonDefinitionAnnotations()`的主要代码

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

3. 注释3中`refresh()`的主要代码

  > 在`AbstractApplicationContext`类中

  ```java
  @Override
  public void refresh() throws BeansException, IllegalStateException {
    synchronized (this.startupShutdownMonitor) {
      // 准备上下文的刷新，记录启动日期，活动标志和初始化配置属性
      prepareRefresh();
  
      // 告诉子类刷新内部bean工厂
      ConfigurableListableBeanFactory beanFactory = obtainFreshBeanFactory();
  
      // 注释6，主要功能为准备bean工厂以供在此上下文中使用,添加相关的BeanPostProcessor用于回调
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
  
        // 注释7，主要功能为实例化剩余所有的(非懒加载)单例bean
        finishBeanFactoryInitialization(beanFactory);
  
        // Last step: publish corresponding event.
        finishRefresh();
      }
  
      catch (BeansException ex) {
        if (logger.isWarnEnabled()) {
          logger.warn("Exception encountered during context initialization - " +
                      "cancelling refresh attempt: " + ex);
        }
  
        // Destroy already created singletons to avoid dangling resources.
        destroyBeans();
  
        // Reset 'active' flag.
        cancelRefresh(ex);
  
        // Propagate exception to caller.
        throw ex;
      }
  
      finally {
        // Reset common introspection caches in Spring's core, since we
        // might not ever need metadata for singleton beans anymore...
        resetCommonCaches();
      }
    }
  }
  ```

  1. 注解6中`prepareBeanFactory()`的主要代码

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

  2. 注释7中`finishBeanFactoryInitialization()`的主要代码

    > 在`AbstractApplicationContext`类中

    ```java
    protected void finishBeanFactoryInitialization(ConfigurableListableBeanFactory beanFactory) {
      //...
      // 缓存所有bean的metadata定义
      beanFactory.freezeConfiguration();
    
      // 注释8，主要功能为实例化剩余所有的(非懒加载)单例bean。
      beanFactory.preInstantiateSingletons();
    }
    ```

    1. 注释8中`preInstantiateSingletons()`的主要代码

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
              //注释8，主要功能为创建bean实例（在创建时并且解决了bean的依赖问题）
              //如果不是FactoryBean，则获取bean
              getBean(beanName);
            }
          }
        }
        //===========遍历beanName的集合并创建所有的非懒加载的单例的bean实例===========
      
        //todo。。。。
        // Trigger post-initialization callback for all applicable beans...
        for (String beanName : beanNames) {
          Object singletonInstance = getSingleton(beanName);
          if (singletonInstance instanceof SmartInitializingSingleton) {
            final SmartInitializingSingleton smartSingleton = (SmartInitializingSingleton) singletonInstance;
            if (System.getSecurityManager() != null) {
              AccessController.doPrivileged((PrivilegedAction<Object>) () -> {
                smartSingleton.afterSingletonsInstantiated();
                return null;
              }, getAccessControlContext());
            }
            else {
              smartSingleton.afterSingletonsInstantiated();
            }
          }
        }
      }
      ```
      
      1. 注释8`getBean()`中的主要代码
      
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
                 //重点：先执行匿名代码块中的内容，结果作为参数传入到getSingleton()方法
                 //将创建单例对象加入到单例缓存中
                 sharedInstance = getSingleton(beanName, () -> {
                   try {
                     //注释9，主要作用为创建对应的bean实例
                     return createBean(beanName, mbd, args);
                   }
                   catch (BeansException ex) {
                     destroySingleton(beanName);
                     throw ex;
                   }
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
      
         1. 注释9`createBean()`中的主要代码
      
            > 在`AbstractAutowireCapableBeanFactory`类中
      
            ```java
            /**
             * 该类的核心方法：创建bean实例，调用PostProcessor后置处理器
             */
            @Override
            protected Object createBean(String beanName, RootBeanDefinition mbd, @Nullable Object[] args)
              throws BeanCreationException {
              //...
              
              // 注释10，主要功能为在bean实例化前，拿到所有实现了postProcessBeforeInstantiation方法的类，并遍历回调该方法
              Object bean = resolveBeforeInstantiation(beanName, mbdToUse);
              //如果返回的bean实例不为null，则直接将bean返回
              if (bean != null) {
                return bean;
              }
            
              //注释11，主要功能为真正的实例化bean
              //如果返回的bean实例为null，调用doCreateBean方法继续按照流程正常的创建bean实例
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
      
            1. 注释10`resolveBeforeInstantiation()`中的主要代码
      
               ```java
               protected Object resolveBeforeInstantiation(String beanName, RootBeanDefinition mbd) {
                 Object bean = null;
                 if (!Boolean.FALSE.equals(mbd.beforeInstantiationResolved)) {
                   //如果实现了InstantiationAwareBeanPostProcessors接口
                   if (!mbd.isSynthetic() && hasInstantiationAwareBeanPostProcessors()) {
                     Class<?> targetType = determineTargetType(beanName, mbd);
                     if (targetType != null) {
                       //回调BeanPostProcessorsBeforeInstantiation方法（在bean实例化前调用）
                       bean = applyBeanPostProcessorsBeforeInstantiation(targetType, beanName);
                       //如果bean不为null，说明bean已经在BeanPostProcessorsBeforeInstantiation回调中被创建并返回，返回在这里应该直接调用BeanPostProcessorsAfterInitialization方法（在bean实例化后调用）
                       //如果为null，则继续进行正常的bean实例化，那么对应的BeanPostProcessorsAfterInitialization方法也会被延后，直到bean正常的被实例化后才回调该方法
                       if (bean != null) {
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
      
            2. 注释11中`doCreateBean()`的主要代码
      
               //todo。。。
      
               ```java
               protected Object doCreateBean(final String beanName, final RootBeanDefinition mbd, final @Nullable Object[] args) throws BeanCreationException {
                 // Instantiate the bean.
                 BeanWrapper instanceWrapper = null;
                 if (mbd.isSingleton()) {
                   instanceWrapper = this.factoryBeanInstanceCache.remove(beanName);
                 }
                 if (instanceWrapper == null) {
                   instanceWrapper = createBeanInstance(beanName, mbd, args);
                 }
                 final Object bean = instanceWrapper.getWrappedInstance();
                 Class<?> beanType = instanceWrapper.getWrappedClass();
                 if (beanType != NullBean.class) {
                   mbd.resolvedTargetType = beanType;
                 }
               
                 // Allow post-processors to modify the merged bean definition.
                 synchronized (mbd.postProcessingLock) {
                   if (!mbd.postProcessed) {
                     try {
                       applyMergedBeanDefinitionPostProcessors(mbd, beanType, beanName);
                     }
                     catch (Throwable ex) {
                       throw new BeanCreationException(mbd.getResourceDescription(), beanName,
                                                       "Post-processing of merged bean definition failed", ex);
                     }
                     mbd.postProcessed = true;
                   }
                 }
               
                 // Eagerly cache singletons to be able to resolve circular references
                 // even when triggered by lifecycle interfaces like BeanFactoryAware.
                 boolean earlySingletonExposure = (mbd.isSingleton() && this.allowCircularReferences &&
                                                   isSingletonCurrentlyInCreation(beanName));
                 if (earlySingletonExposure) {
                   if (logger.isTraceEnabled()) {
                     logger.trace("Eagerly caching bean '" + beanName +
                                  "' to allow for resolving potential circular references");
                   }
                   addSingletonFactory(beanName, () -> getEarlyBeanReference(beanName, mbd, bean));
                 }
               
                 // Initialize the bean instance.
                 Object exposedObject = bean;
                 try {
                   populateBean(beanName, mbd, instanceWrapper);
                   exposedObject = initializeBean(beanName, exposedObject, mbd);
                 }
                 catch (Throwable ex) {
                   if (ex instanceof BeanCreationException && beanName.equals(((BeanCreationException) ex).getBeanName())) {
                     throw (BeanCreationException) ex;
                   }
                   else {
                     throw new BeanCreationException(
                       mbd.getResourceDescription(), beanName, "Initialization of bean failed", ex);
                   }
                 }
               
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
                         throw new BeanCurrentlyInCreationException(beanName,
                                                                    "Bean with name '" + beanName + "' has been injected into other beans [" +
                                                                    StringUtils.collectionToCommaDelimitedString(actualDependentBeans) +
                                                                    "] in its raw version as part of a circular reference, but has eventually been " +
                                                                    "wrapped. This means that said other beans do not use the final version of the " +
                                                                    "bean. This is often the result of over-eager type matching - consider using " +
                                                                    "'getBeanNamesOfType' with the 'allowEagerInit' flag turned off, for example.");
                       }
                     }
                   }
                 }
               
                 // Register bean as disposable.
                 try {
                   registerDisposableBeanIfNecessary(beanName, bean, mbd);
                 }
                 catch (BeanDefinitionValidationException ex) {
                   throw new BeanCreationException(
                     mbd.getResourceDescription(), beanName, "Invalid destruction signature", ex);
                 }
               
                 return exposedObject;
               }
               ```
      
               

