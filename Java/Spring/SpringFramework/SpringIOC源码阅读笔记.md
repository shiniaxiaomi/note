# 介绍

记录在阅读SpringIOC源码时笔记

# 容器初始化过程

1. 调用构造方法

   ```java
   public AnnotationConfigApplicationContext(Class<?>... componentClasses) {
     this();//调用自身的构造方法
     register(componentClasses);//实例化并注册传入的指定类(componentClasses)
     refresh();//实例化bean,自动注入属性,解决bean依赖问题(几乎所有操作都是在该方法中实现了)
   }
   ```

2. `refresh()`方法概览

   ```java
   public void refresh(){
     //准备上下文的环境
     prepareRefresh();
     
     //获取beanFactory
     ConfigurableListableBeanFactory beanFactory = obtainFreshBeanFactory();
     
     //给beanFactory进行设置一些基本的东西(如默认存在的post-processors)
     prepareBeanFactory(beanFactory);
     
     //空方法,子类可以覆盖该方法,可以在该方法中操作beanFactory
     postProcessBeanFactory(beanFactory);
     
     //实例化并注册自定义的BeanDefinitionRegistryPostProcessor,并执行对应的回调===============重要
     //在这里通过执行Configxxx了对类的所有扫描并解析生成beanDefinition放到map中
     invokeBeanFactoryPostProcessors(beanFactory);
     
     //实例化并注册自定义的BeanPostProcessors,并执行对应的回调===============重要
     registerBeanPostProcessors(beanFactory);
     
     //为上下文初始化信息源(目前还不知道是干什么的)
     initMessageSource();
     
     //为上下文初始化广播事件(初始化SimpleApplicationEventMulticaster)
     initApplicationEventMulticaster();
     
     //空方法,子类可以覆盖该方法,用来初始化一些特殊的bean
     onRefresh();
    
     //注册所有的事件监听器(包括早期的事件监听器和实现了ApplicationListener接口的事件监听器)
     registerListeners();
     
     //实例化所有剩下的非懒加载的单例bean(该方法),并解决了bean的循环依赖问题===============重要
     finishBeanFactoryInitialization(beanFactory);
    
     //最后一步,发送应用启动完成的消息事件
     finishRefresh();
   }
   ```

## id:1---invokeBeanFactoryPostProcessors(beanFactory)

实例化并注册所有的`BeanDefinitionRegistryPostProcessor`,包括我们自定义的,然后根据优先级调用对应的回调方法

以下是部分源码:

```java
public static void invokeBeanFactoryPostProcessors(ConfigurableListableBeanFactory beanFactory, List<BeanFactoryPostProcessor> beanFactoryPostProcessors){

  Set<String> processedBeans = new HashSet<>();

  //+++++++++++++++先执行类型为BeanDefinitionRegistry的回调(进行对所有类的扫描和解析,并生成beanDefinition放到map中)+++++++++++++++
		//如果beanFactory属于BeanDefinitionRegistry类型
  if (beanFactory instanceof BeanDefinitionRegistry) {
    BeanDefinitionRegistry registry = (BeanDefinitionRegistry) beanFactory;
    List<BeanFactoryPostProcessor> regularPostProcessors = new ArrayList<>();
    List<BeanDefinitionRegistryPostProcessor> registryProcessors = new ArrayList<>();

    //如果默认存在(默认没有,所以直接跳过),则先调用对应的postProcessBeanDefinitionRegistry
    for (BeanFactoryPostProcessor postProcessor : beanFactoryPostProcessors) {
      if (postProcessor instanceof BeanDefinitionRegistryPostProcessor) {
        BeanDefinitionRegistryPostProcessor registryProcessor =
          (BeanDefinitionRegistryPostProcessor) postProcessor;
        registryProcessor.postProcessBeanDefinitionRegistry(registry);
        registryProcessors.add(registryProcessor);
      }
      else {
        regularPostProcessors.add(postProcessor);
      }
    }

    //接下来会执行所有的beanPostProcessor相关的回调,用于在bean实例化进行人为的干预
    List<BeanDefinitionRegistryPostProcessor> currentRegistryProcessors = new ArrayList<>();

    //===========先回调实现了PriorityOrdered接口的BeanDefinitionRegistryPostProcessor=========
    //拿到所有的BeanDefinitionRegistryPostProcessor类型的beanName
    String[] postProcessorNames =
      beanFactory.getBeanNamesForType(BeanDefinitionRegistryPostProcessor.class, true, false);
    //遍历所有beanName,并将实现了PriorityOrdered接口的BeanDefinitionRegistryPostProcessor先加到RegistryProcessors中
    for (String ppName : postProcessorNames) {
      if (beanFactory.isTypeMatch(ppName, PriorityOrdered.class)) {
        //通过bean的名称和类型注册并实例化相关的BeanDefinitionRegistry后置处理器
        currentRegistryProcessors.add(beanFactory.getBean(ppName, BeanDefinitionRegistryPostProcessor.class));
        //并将已经添加的名称保存,用于接下来不重复执行回调
        processedBeans.add(ppName);
      }
    }
    //将实现PriorityOrdered接口的postProcessBeanDefinitionRegistry进行排序
    sortPostProcessors(currentRegistryProcessors, beanFactory);
    //将所有的排好序并且优先级较高的先全部添加到registryProcessors中
    registryProcessors.addAll(currentRegistryProcessors);
    //执行优先级较高的postProcessBeanDefinitionRegistry回调
    //=========主要执行ConfigureClassPostProcessor,用于处理@Configure注解的配置类==============
    invokeBeanDefinitionRegistryPostProcessors(currentRegistryProcessors, registry);
    //执行完之后,将已经执行的postProcessor全部清空
    currentRegistryProcessors.clear();

    //=========再回调实现了Ordered接口的BeanDefinitionRegistryPostProcessor========
    //拿到实现了Ordered接口的所有beanName,进行遍历回调
    postProcessorNames = beanFactory.getBeanNamesForType(BeanDefinitionRegistryPostProcessor.class, true, false);
    for (String ppName : postProcessorNames) {
      if (!processedBeans.contains(ppName) && beanFactory.isTypeMatch(ppName, Ordered.class)) {
        currentRegistryProcessors.add(beanFactory.getBean(ppName, BeanDefinitionRegistryPostProcessor.class));
        //并将已经添加的名称保存,用于接下来不重复执行回调
        processedBeans.add(ppName);
      }
    }
    //这里和之前上面的逻辑是一样的,就是先排序,再回调,最后清空
    sortPostProcessors(currentRegistryProcessors, beanFactory);
    registryProcessors.addAll(currentRegistryProcessors);
    invokeBeanDefinitionRegistryPostProcessors(currentRegistryProcessors, registry);
    currentRegistryProcessors.clear();

    //===========最后,回调剩下的BeanDefinitionRegistryPostProcessor===========
    boolean reiterate = true;
    while (reiterate) {
      reiterate = false;
      postProcessorNames = beanFactory.getBeanNamesForType(BeanDefinitionRegistryPostProcessor.class, true, false);
      for (String ppName : postProcessorNames) {
        //如果之前都没有执行过该对应的回调,那么就添加
        if (!processedBeans.contains(ppName)) {
          //通过bean的名称和类型注册并实例化相关的BeanDefinitionRegistry后置处理器
          currentRegistryProcessors.add(beanFactory.getBean(ppName, BeanDefinitionRegistryPostProcessor.class));
          processedBeans.add(ppName);
          reiterate = true;
        }
      }
      //这里和之前上面的逻辑是一样的,就是先排序,再回调,最后清空
      sortPostProcessors(currentRegistryProcessors, beanFactory);
      registryProcessors.addAll(currentRegistryProcessors);
      invokeBeanDefinitionRegistryPostProcessors(currentRegistryProcessors, registry);
      currentRegistryProcessors.clear();
    }

    //执行所有的BeanFactoryPostProcessors的postProcessBeanFactory方法
    invokeBeanFactoryPostProcessors(regularPostProcessors, beanFactory);
    invokeBeanFactoryPostProcessors(registryProcessors, beanFactory);
  }
  //如果不属于BeanDefinitionRegistry类型
  else {
    //执行所有默认的BeanFactoryPostProcessors的postProcessBeanFactory方法
    invokeBeanFactoryPostProcessors(beanFactoryPostProcessors, beanFactory);
  }

  //...
}
```

> 上述代码中:`beanFactory.getBean(ppName, BeanDefinitionRegistryPostProcessor.class)`,即先从缓存中获取,如果获取到了,则直接返回,如果没获取到,则实例化对应的BeanDefinitionRegistryPostProcessor,所以在这里会调用其构造方法进行实例化

> 由源码可知:
>
> 如果我们存在多个自定义的后置处理器时,可以通过一些接口或者注解来实现优先级问题
>
> 优先级大小: 实现了PriorityOrdered接口的>实现Ordered接口的>默认的

1. 在`invokeBeanDefinitionRegistryPostProcessors(currentRegistryProcessors, registry);`方法回调中,存在之前创建的`ConfigureClassPostProcessor`回调其`postProcessBeanDefinitionRegistry`方法,该方法是解析我们的配置类(即标注有@Configure注解的类)

   以下是该类重写的方法:

   ```java
   @Override
   public void postProcessBeanDefinitionRegistry(BeanDefinitionRegistry registry) {
     //...
     processConfigBeanDefinitions(registry);//真正的执行类的扫描和解析
   }
   ```

   在`processConfigBeanDefinitions`方法中:

   ```java
   public void processConfigBeanDefinitions(BeanDefinitionRegistry registry) {
     List<BeanDefinitionHolder> configCandidates = new ArrayList<>();
     String[] candidateNames = registry.getBeanDefinitionNames();
   
     //...
   
     //如果没有找到@Configuration注解，则立即返回
     if (configCandidates.isEmpty()) {
       return;
     }
   
     //将标注有@Configure注解的类进行排序
     configCandidates.sort((bd1, bd2) -> {
       int i1 = ConfigurationClassUtils.getOrder(bd1.getBeanDefinition());
       int i2 = ConfigurationClassUtils.getOrder(bd2.getBeanDefinition());
       return Integer.compare(i1, i2);
     });
   
     //生成配置类的beanName
     SingletonBeanRegistry sbr = null;
     if (registry instanceof SingletonBeanRegistry) {
       sbr = (SingletonBeanRegistry) registry;
       if (!this.localBeanNameGeneratorSet) {
         BeanNameGenerator generator = (BeanNameGenerator) sbr.getSingleton(
           AnnotationConfigUtils.CONFIGURATION_BEAN_NAME_GENERATOR);
         if (generator != null) {
           this.componentScanBeanNameGenerator = generator;
           this.importBeanNameGenerator = generator;
         }
       }
     }
   
     //...
   
     //生成@Configuration注解的解析类
     ConfigurationClassParser parser = new ConfigurationClassParser(
       this.metadataReaderFactory, this.problemReporter, this.environment,
       this.resourceLoader, this.componentScanBeanNameGenerator, registry);
   
     //保存还未解析的配置类
     Set<BeanDefinitionHolder> candidates = new LinkedHashSet<>(configCandidates);
     //保存已经解析过的配置类
     Set<ConfigurationClass> alreadyParsed = new HashSet<>(configCandidates.size());
   
     //进行循环并递归解析,直到candidates集合为空
     do {
       //包扫描并解析,然后将beanDefinition放到map中
       parser.parse(candidates);
       //校验
       parser.validate();
   
       Set<ConfigurationClass> configClasses = new LinkedHashSet<>(parser.getConfigurationClasses());
       configClasses.removeAll(alreadyParsed);
   
       //注册配置类,并解析配置类,将配置类中需要扫描,导入等一些的bean都进行递归的解析
       if (this.reader == null) {
         this.reader = new ConfigurationClassBeanDefinitionReader(
           registry, this.sourceExtractor, this.resourceLoader, this.environment,
           this.importBeanNameGenerator, parser.getImportRegistry());
       }
       //读取配置类，并向注册中心注册beanDefinition
       this.reader.loadBeanDefinitions(configClasses);
       //标记已经添加的配置类
       alreadyParsed.addAll(configClasses);
   
       candidates.clear();
       //如果目前的beanDefinition个数大于原始的beanName个数
       if (registry.getBeanDefinitionCount() > candidateNames.length) {
         //获取目前的beanDefinition
         String[] newCandidateNames = registry.getBeanDefinitionNames();
         //获取以前的beanName
         Set<String> oldCandidateNames = new HashSet<>(Arrays.asList(candidateNames));
         //创建一个存放已经解析过的类的集合
         Set<String> alreadyParsedClasses = new HashSet<>();
         for (ConfigurationClass configurationClass : alreadyParsed) {
           //将已经解析过的类存放到alreadyParsedClasses集合中
           alreadyParsedClasses.add(configurationClass.getMetadata().getClassName());
         }
         //遍历目前的所有beanDefinition
         for (String candidateName : newCandidateNames) {
           //如果还未解析过
           if (!oldCandidateNames.contains(candidateName)) {
             //获取当前bean的beanDefinition
             BeanDefinition bd = registry.getBeanDefinition(candidateName);
             //如果当前bean是配置类 并且 还未被解析
             if (ConfigurationClassUtils.checkConfigurationClassCandidate(bd, this.metadataReaderFactory) &&
                 !alreadyParsedClasses.contains(bd.getBeanClassName())) {
               //将bean的beanDefinition添加到candidates集合中,等待下一轮循环时再次解析
               candidates.add(new BeanDefinitionHolder(bd, candidateName));
             }
           }
         }
         candidateNames = newCandidateNames;
       }
     }
     while (!candidates.isEmpty());
   
     //将ImportRegistry注册为bean，用来实现@Configuration类的@Import注解
     if (sbr != null && !sbr.containsSingleton(IMPORT_REGISTRY_BEAN_NAME)) {
       sbr.registerSingleton(IMPORT_REGISTRY_BEAN_NAME, parser.getImportRegistry());
     }
   
     if (this.metadataReaderFactory instanceof CachingMetadataReaderFactory) {
       //清除缓存
       ((CachingMetadataReaderFactory) this.metadataReaderFactory).clearCache();
     }
   }
   ```

2. 自定义的`BeanDefinitionRegistryPostProcessor`

   在`org.springframework.context.support.PostProcessorRegistrationDelegate#invokeBeanDefinitionRegistryPostProcessors`中就会回调我们自定义的`BeanDefinitionRegistryPostProcessor`的具体方法:

   ```java
   @Component
   public class MyBeanDefinitionRegistryPostProcessor implements BeanDefinitionRegistryPostProcessor {
   
     /**
   	 * 执行顺序:1
   	 * 可以添加或修改BeanDefinition
   	 * 在执行该方法时,所有常规的bean都已经加载并添加到BeanDefinitionMap中,但是此时的bean还未被实例化,
   	 * 所以,在该方法中,允许修改已经添加到BeanDefinitionMap中的bean的定义,或者是添加我们自己的bean的定义,
   	 * 然后在bean的实例化时,添加或修改的bean都会生效,并被spring所管理
   	 * @param registry 上下文的beanDefinitionMap(bean定义的注册表)
   	 */
     @Override
     public void postProcessBeanDefinitionRegistry(BeanDefinitionRegistry registry) throws BeansException {
       System.out.println("postProcessBeanDefinitionRegistry");
     }
   
     /**
   	 * 执行顺序:2
   	 * 功能同上述方法
   	 * 在执行该方法时,所有bean定义都已加载，但还没有实例化bean;
   	 * @param beanFactory 上下文的beanFactory
   	 */
     @Override
     public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException {
       System.out.println("postProcessBeanFactory");
     }
   }
   ```

## id:2---registerBeanPostProcessors(beanFactory)

注册默认和自定义的BeanPostProcessors

部分源码如下:

```java
public static void registerBeanPostProcessors(
  ConfigurableListableBeanFactory beanFactory, AbstractApplicationContext applicationContext) {

  //获取所有类型为BeanPostProcessor的后置处理器的名称
  String[] postProcessorNames = beanFactory.getBeanNamesForType(BeanPostProcessor.class, true, false);

  //...

  List<BeanPostProcessor> priorityOrderedPostProcessors = new ArrayList<>();
  List<BeanPostProcessor> internalPostProcessors = new ArrayList<>();
  List<String> orderedPostProcessorNames = new ArrayList<>();
  List<String> nonOrderedPostProcessorNames = new ArrayList<>();
  //将实现了不同接口的类进行分发,分发到不同的集合中,然后再按照每个集合中每个类的优先级去执行回调
  for (String ppName : postProcessorNames) {
    if (beanFactory.isTypeMatch(ppName, PriorityOrdered.class)) {//如果实现了PriorityOrdered接口
      //如果属于BeanPostProcessor类型
      BeanPostProcessor pp = beanFactory.getBean(ppName, BeanPostProcessor.class);
      //将该PostProcessor添加到priorityOrderedPostProcessors集合中
      priorityOrderedPostProcessors.add(pp);
      if (pp instanceof MergedBeanDefinitionPostProcessor) {
        //如果该PostProcessor又属于MergedBeanDefinitionPostProcessor类型,则再添加到internalPostProcessors集合中
        internalPostProcessors.add(pp);
      }
    }
    else if (beanFactory.isTypeMatch(ppName, Ordered.class)) {//如果实现了Ordered接口
      //则添加到orderedPostProcessorNames集合中
      orderedPostProcessorNames.add(ppName);
    }
    else {
      //将剩下的全部添加到nonOrderedPostProcessorNames集合中
      nonOrderedPostProcessorNames.add(ppName);
    }
  }

  //========先排序并注册实现了PriorityOrdered接口的BeanPostProcessors===========
  sortPostProcessors(priorityOrderedPostProcessors, beanFactory);//排序
  registerBeanPostProcessors(beanFactory, priorityOrderedPostProcessors);//注册

  //======再排序并注册实现了Ordered接口的BeanPostProcessors,套路和上面的相同,先排序,然后再全部注册到beanFactory中===========
  List<BeanPostProcessor> orderedPostProcessors = new ArrayList<>(orderedPostProcessorNames.size());
  for (String ppName : orderedPostProcessorNames) {
    BeanPostProcessor pp = beanFactory.getBean(ppName, BeanPostProcessor.class);
    orderedPostProcessors.add(pp);
    if (pp instanceof MergedBeanDefinitionPostProcessor) {
      internalPostProcessors.add(pp);//添加
    }
  }
  sortPostProcessors(orderedPostProcessors, beanFactory);//排序
  registerBeanPostProcessors(beanFactory, orderedPostProcessors);//注册

  //======再注册剩下的普通BeanPostProcessors,套路和上面略微不同,直接全部注册,因为没有顺序要求=====
  List<BeanPostProcessor> nonOrderedPostProcessors = new ArrayList<>(nonOrderedPostProcessorNames.size());
  for (String ppName : nonOrderedPostProcessorNames) {
    BeanPostProcessor pp = beanFactory.getBean(ppName, BeanPostProcessor.class);
    nonOrderedPostProcessors.add(pp);
    if (pp instanceof MergedBeanDefinitionPostProcessor) {
      internalPostProcessors.add(pp);
    }
  }
  registerBeanPostProcessors(beanFactory, nonOrderedPostProcessors);//注册

  //internalPostProcessors集合中保存着用于合并bean定义的后处理器回调接口
  //BeanPostProcessor实现可以实现这个子接口,用于在创建bean实例时的合并beanDefinition的回调(原始bean定义的已处理副本)
  //最后,重新注册所有的属于MergedBeanDefinitionPostProcessor类型的后置处理器
  sortPostProcessors(internalPostProcessors, beanFactory);//排序
  registerBeanPostProcessors(beanFactory, internalPostProcessors);//注册

  //将ApplicationListenerDetector注册到最后面
  beanFactory.addBeanPostProcessor(new ApplicationListenerDetector(applicationContext));
}
```

> 上述源代码中也存在`beanFactory.getBean(ppName, BeanPostProcessor.class);` , 即先去缓存中获取,如果没有则先创建,所以一般默认是还没有的,所以对应的构造函数会在这里被调用

> 根据实现的接口会先筛选出大的优先级,总的顺序是按照PriorityOrdered>Ordered>其余的
>
> 在每个对应的优先级层级中,还会存在优先级,那么源码中的排序排的就是这个优先级
>
> 根据上述的优先级规则,就可以将所有的后置处理器按照优先级顺序注册到集合中,方便之后的正确回调

> 实现了InstantiationAwareBeanPostProcessor的接口的bean,在后置处理器注册的时候就会被创建,那么他们自己本身在创建的过程中是不会回调后置处理器的

自定义的后置处理器

```java
@Component
public class AwareBean implements InstantiationAwareBeanPostProcessor {

  /**
	 * 在bean实例化之前回调
	 */
  @Override
  public Object postProcessBeforeInstantiation(Class<?> beanClass, String beanName) throws BeansException {
    System.out.println("postProcessBeforeInstantiation:"+beanName);
    return null;
  }

  /**
	 * 在bean实例化之后回调
	 */
  @Override
  public boolean postProcessAfterInstantiation(Object bean, String beanName) throws BeansException {
    System.out.println("postProcessAfterInstantiation:"+beanName);
    return true;
  }

  /**
	 * 在bean初始化之前回调,比postProcessBeforeInitialization早
	 */
  @Override
  public PropertyValues postProcessProperties(PropertyValues pvs, Object bean, String beanName) throws BeansException {
    System.out.println("postProcessProperties:"+beanName);
    return null;
  }

  /**
	 * 在bean执行初始化方法之前回调
	 */
  @Override
  public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
    System.out.println("postProcessBeforeInitialization:"+beanName);
    return bean;
  }

  /**
	 * 在bean执行初始化方法之后回调
	 */
  @Override
  public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
    System.out.println("postProcessAfterInitialization:"+beanName);
    return bean;
  }

  public AwareBean() {
    System.out.println("构造方法:AwareBean");
  }
}
```

## id:3---finishBeanFactoryInitialization(beanFactory)

实例化并初始化剩下的单实例bean,并在此期间进行后置处理器的回调

部分源码:

```java
public void preInstantiateSingletons() throws BeansException {
  
  //获取所有的beanName
  List<String> beanNames = new ArrayList<>(this.beanDefinitionNames);

  //迭代beanName,将符合条件的单实例bean进行实例化和初始化
  for (String beanName : beanNames) {
    //获取到对应的beanName的合并后的beanDefinition
    RootBeanDefinition bd = getMergedLocalBeanDefinition(beanName);
    //========如果bean不是抽象的,并且是单例的,并且不是懒加载的========
    if (!bd.isAbstract() && bd.isSingleton() && !bd.isLazyInit()) {
      //---------------如果是FactoryBean---------------
      if (isFactoryBean(beanName)) {
        //则通过Factory创建bean实例
        //...
      }
      else {
        //------------如果不是FactoryBean--------------
        //直接创建并获取对应的bean(默认一般都会进入这里)
        getBean(beanName);
      }
    }
  }

  //...
}
```

## id:4,pid:3---getBean(beanName)

先尝试从单例缓存池中获取,如果没有获取到,则进行创建bean

```java
protected <T> T doGetBean(final String name, @Nullable final Class<T> requiredType,
			@Nullable final Object[] args, boolean typeCheckOnly) throws BeansException {
  
  //规范beanName
  final String beanName = transformedBeanName(name);
  Object bean;
  
  //先从单例缓存中获取对应的单实例bean
  Object sharedInstance = getSingleton(beanName);
  //++++++++++++++如果缓存中有+++++++++++++++
  //如果从缓存中获取到了bean,并且args为null
  if (sharedInstance != null && args == null) {
    //获取了对应的bean实例的对象(如果是FactoryBean,返回的则是FactoryBean创建的对象,如果不是,那么返回的就是该bean实例本身)
    bean = getObjectForBeanInstance(sharedInstance, name, beanName, null);
  }
  //++++++++++++++如果缓存中没有++++++++++++++
  else {
    //=======如果没有拿到,那么spring就假定现在处于一个循环引用中(一般我们自己的bean基本上都会进入到这个条件中)==========
    
    //*******以下的主要工作就是要获取到对应的bean实例**********
    //========先尝试通过BeanFactory创建bean实例=========
   	//如果创建成功,则直接返回bean(也经过了bean的生命周期)...
    //========先尝试通过BeanFactory创建bean实例=========

    //==========如果没有创建成功,再正常的创建对应的bean实例============
    if (!typeCheckOnly) {
      //将指定的bean标记为已经创建(或即将创建),并将其缓存,以便之后重复创建时判断使用
      markBeanAsCreated(beanName);
    }

    try {
      //获取合并后的beanDefinition
      final RootBeanDefinition mbd = getMergedLocalBeanDefinition(beanName);
      //检查合并后的beanDefinition是否合法
      checkMergedBeanDefinition(mbd, beanName, args);

      //---------保证在创建当前bean之前将所依赖的bean都初始化完成----------
      //获取到当前bean所依赖的所有beanName
      String[] dependsOn = mbd.getDependsOn();
      //如果有依赖其他bean
      if (dependsOn != null) {
        //迭代需要依赖bean的集合,把他们都注册和创建好
        for (String dep : dependsOn) {
          //注册依赖的bean
          registerDependentBean(dep, beanName);
          //创建并获取依赖的bean实例
          getBean(dep);
        }
      }


      //如果没有依赖的bean,则创建当前的bean实例 或者是 有依赖bean,但是在上一个步骤中已经将依赖bean都创建好了
      //如果是单例
      if (mbd.isSingleton()) {
        //先从单例缓存中获取对应的bean实例,如果没有则注册并创建一个新的单例对象,并缓存到单实例缓存中
        sharedInstance = getSingleton(beanName, () -> {
          try {
            //如果没有从单例缓存中获取到bean实例,则执行该方法创建bean实例
            //在createBean中会实例化bean,并且在实例化前后执行对应的postProcessAfterInitialization的回调
            return createBean(beanName, mbd, args);
          }
          catch (BeansException ex) {
            //如果异常,则销毁bean
            destroySingleton(beanName);
            throw ex;
          }
        });
        //获取对应的对应的bean实例的对象(如果是FactoryBean,返回的则是FactoryBean创建的对象,如果不是,那么返回的就是该bean实例本身)
        bean = getObjectForBeanInstance(sharedInstance, name, beanName, mbd);
      }
      //如果是原型
      else if (mbd.isPrototype()) {
        // It's a prototype -> create a new instance.
        Object prototypeInstance = null;
        try {
          //原型创建之前的回调,默认实现是将原型注册为当前正在创建的状态
          beforePrototypeCreation(beanName);
          //创建对应的bean实例
          prototypeInstance = createBean(beanName, mbd, args);
        }
        finally {
          //原型创建后的回调,默认实现是将原型标记为不在创建中
          afterPrototypeCreation(beanName);
        }
        //获取对应的对应的bean实例的对象(如果是FactoryBean,返回的则是FactoryBean创建的对象,如果不是,那么返回的就是该bean实例本身)
        bean = getObjectForBeanInstance(prototypeInstance, name, beanName, mbd);
      }
      //如果是其他作用域
      else {
        //获取到bean的作用域名称
        String scopeName = mbd.getScope();
        //从map中获取到对应的作用域
        final Scope scope = this.scopes.get(scopeName);
        //如果为空则报错
        if (scope == null) {
          throw new IllegalStateException("No Scope registered for scope name '" + scopeName + "'");
        }
        try {
          //如果获取到的作用域不为空,根据不同作用域来创建bean实例并返回
          Object scopedInstance = scope.get(beanName, () -> {
            //原型创建之前的回调,默认实现将原型注册为当前正在创建的状态。
            beforePrototypeCreation(beanName);
            try {
              //创建对应的bean实例
              return createBean(beanName, mbd, args);
            }
            finally {
              //原型创建后的回调,默认实现将原型标记为不在创建中。
              afterPrototypeCreation(beanName);
            }
          });
          //获取对应的对应的bean实例的对象(如果是FactoryBean,返回的则是FactoryBean创建的对象,如果不是,那么返回的就是该bean实例本身)
          bean = getObjectForBeanInstance(scopedInstance, name, beanName, mbd);
        }
        catch (IllegalStateException ex) {
          throw new BeanCreationException("Scope '" + scopeName + "' is not active for the current thread; consider ");
        }
      }
    }
    catch (BeansException ex) {
      cleanupAfterBeanCreationFailure(beanName);
      throw ex;
    }
  }
  
  //...
  return (T) bean;//返回从单例缓存获取或者新创建的bean
  
}
```

### id:5,pid:4---createBean(beanName, mbd, args)

实例化并初始化bean,并回调后置处理器

部分源码如下:

```java
protected Object createBean(String beanName, RootBeanDefinition mbd, @Nullable Object[] args)
  throws BeanCreationException {

  RootBeanDefinition mbdToUse = mbd;

  //解析并获取bean的类信息
  Class<?> resolvedClass = resolveBeanClass(mbd, beanName);
  
  //...

  try {
    //调用postProcessBeforeInstantiation回调,提供了机会在这里直接返回bean的代理类实例
    //回调后返回bean实例,默认为null;如果返回不为null,则不会继续直接下面的方法了,直接返回,并且在回调中会还会把postProcessAfterInitialization回调也执行了
    Object bean = resolveBeforeInstantiation(beanName, mbdToUse);
    if (bean != null) {
      //如果不为null,则直接返回bean实例
      return bean;
    }
  }
  catch (Throwable ex) {
    //抛出异常
  }

  try {
    //如果在实例化前的回调中未返回bean,则在这里创建bean实例
    Object beanInstance = doCreateBean(beanName, mbdToUse, args);
    return beanInstance;//返回实例化并初始化后的bean实例
  }
  catch (BeanCreationException) {
    //抛出异常
  }
  
}
```

### id:6,pid:5---resolveBeforeInstantiation(beanName, mbdToUse)

回调`postProcessBeforeInstantiation`(实例化前回调),如果在回调中返回bean实例,则还会调用`postProcessAfterInitialization`(实例化后回调)

部分源码如下:

```java
protected Object resolveBeforeInstantiation(String beanName, RootBeanDefinition mbd) {
  Object bean = null;
  //如果未创建,则进行实例化
  if (!Boolean.FALSE.equals(mbd.beforeInstantiationResolved)) {
    //如果bean不是合成的,并且有InstantiationAware的后置处理器
    if (!mbd.isSynthetic() && hasInstantiationAwareBeanPostProcessors()) {
      Class<?> targetType = determineTargetType(beanName, mbd);
      if (targetType != null) {
        //回调postProcessBeforeInstantiation(实例化前回调)
        bean = applyBeanPostProcessorsBeforeInstantiation(targetType, beanName);
        //如果回调返回的bean不为null,说明在回调中已创建,那么就直接调用
        //如果返回为null,则继续正常的初始化
        if (bean != null) {
          //回调postProcessAfterInitialization(实例化后回调)
          bean = applyBeanPostProcessorsAfterInitialization(bean, beanName);
        }
      }
    }
    //标记bean实例化状态,是否已经回调中创建
    mbd.beforeInstantiationResolved = (bean != null);
  }
  //否则,直接返回null
  return bean;
}
```

### id:7,pid:5---doCreateBean(beanName, mbdToUse, args)

正真的实例化bean:调用bean的构造方法,回调postProcessMergedBeanDefinition,

部分源码如下:

```java
protected Object doCreateBean(final String beanName, final RootBeanDefinition mbd, final @Nullable Object[] args)
  throws BeanCreationException {

  //===============实例化bean=================
  BeanWrapper instanceWrapper = null;
  //如果bean是单例
  if (mbd.isSingleton()) {
    //将beanName从未完成的bean的缓存中删除并返回删除的对应,在该方法后继续之前未完成的bean的实例化操作
    instanceWrapper = this.factoryBeanInstanceCache.remove(beanName);
  }
  //如果该bean不存在未完成的bean的缓存中
  if (instanceWrapper == null) {
    //-------------创建bean实例的包装类(在这里调用bean的构造方法来创建bean),在这里会选择使用哪个构造方法来创建bean实例------------
    instanceWrapper = createBeanInstance(beanName, mbd, args);
  }
  //获取包装类中的bean实例
  final Object bean = instanceWrapper.getWrappedInstance();
  //获取bean实例的类型
  Class<?> beanType = instanceWrapper.getWrappedClass();
  //如果bean的类型不为NullBean
  if (beanType != NullBean.class) {
    //则将bean的类型设置到beanDefinition中保存
    mbd.resolvedTargetType = beanType;
  }

  //========执行所有合并后的BeanDefinition的后置处理器========
  synchronized (mbd.postProcessingLock) {
    //如果未执行该回调
    if (!mbd.postProcessed) {
      try {
        //执行回调
        applyMergedBeanDefinitionPostProcessors(mbd, beanType, beanName);
      }
      catch (Throwable ex) {
        //抛出异常
      }
      //标记已经执行了回调
      mbd.postProcessed = true;
    }
  }

  //=============急切的缓存单例以便解决循环引用的问题===========
  //如果当前的bean是单例,并且允许循环引用,并且正在被创建
  //判断是否需要提前创建并缓存单例
  boolean earlySingletonExposure = (mbd.isSingleton() && this.allowCircularReferences &&
                                    isSingletonCurrentlyInCreation(beanName));
  if (earlySingletonExposure) {
    //将当前的bean先添加到单例工厂中
    addSingletonFactory(beanName, () -> getEarlyBeanReference(beanName, mbd, bean));
  }

  //=============初始化bean(设置属性并调用初始化方法)=============
  Object exposedObject = bean;
  try {
    //设置bean的属性
    populateBean(beanName, mbd, instanceWrapper);
    //执行bean的初始化方法和后置处理器的回调方法
    exposedObject = initializeBean(beanName, exposedObject, mbd);
  }
  catch (Throwable ex) {
    //抛出异常
  }

  //=================以下是解决循环引用的问题=================
  //如果提前创建并缓存单例了
  if (earlySingletonExposure) {
    //从单例缓存中获取bean
    Object earlySingletonReference = getSingleton(beanName, false);
    //如果获取到了
    if (earlySingletonReference != null) {
      //如果包装类中bean对象和从缓存中获取的bean的引用相等
      if (exposedObject == bean) {
        //则把当前缓存中的bean的引用赋值给初始化完成后的bean实例对象
        exposedObject = earlySingletonReference;
      }
      //在循环引用中不注入原始bean实例,并且当前bean依赖其他bean
      else if (!this.allowRawInjectionDespiteWrapping && hasDependentBean(beanName)) {
        //获取当前bean的所有依赖的名称
        String[] dependentBeans = getDependentBeans(beanName);
        Set<String> actualDependentBeans = new LinkedHashSet<>(dependentBeans.length);
        //遍历当前bean所依赖的名称
        for (String dependentBean : dependentBeans) {
          //从保存已创建bean的集合列表中删除当前bean所依赖的beanName,如果本来就没有缓存
          if (!removeSingletonIfCreatedForTypeCheckOnly(dependentBean)) {
            //将当前bean依赖的beanName添加到真实依赖的bean的集合中
            actualDependentBeans.add(dependentBean);
          }
        }
        if (!actualDependentBeans.isEmpty()) {
          //抛出异常
        }
      }
    }
  }

  // 将当前bean注册为一次性的,在bean关闭时执行销毁
  try {
    registerDisposableBeanIfNecessary(beanName, bean, mbd);
  }
  catch (BeanDefinitionValidationException ex) {
    //抛出异常
  }

  //返回执行初始化方法后返回的bean实例
  return exposedObject;
}
```

#### id:8,pid:7---createBeanInstance(beanName, mbd, args)

真正的实例化bean,在该方法中决定调用对应的bean的哪个构造方法

部分源码如下:

```java
protected BeanWrapper createBeanInstance(String beanName, RootBeanDefinition mbd, @Nullable Object[] args) {
  //获取当前bean的class
  Class<?> beanClass = resolveBeanClass(mbd, beanName);

  Supplier<?> instanceSupplier = mbd.getInstanceSupplier();
  //instanceSupplier不为null,则从原始的供应商中获取bean
  if (instanceSupplier != null) {
    return obtainFromSupplier(instanceSupplier, beanName);
  }
	//如果FactoryMethodName不为null,则从工厂中获取bean
  if (mbd.getFactoryMethodName() != null) {
    return instantiateUsingFactoryMethod(beanName, mbd, args);
  }

  // Shortcut when re-creating the same bean...
  boolean resolved = false;
  boolean autowireNecessary = false;
  if (args == null) {
    synchronized (mbd.constructorArgumentLock) {
      if (mbd.resolvedConstructorOrFactoryMethod != null) {
        resolved = true;
        autowireNecessary = mbd.constructorArgumentsResolved;
      }
    }
  }
  if (resolved) {
    if (autowireNecessary) {
      return autowireConstructor(beanName, mbd, null, null);
    }
    else {
      return instantiateBean(beanName, mbd);
    }
  }

  //=======选择类中的哪一个构造方法来实例化对应的bean======
  Constructor<?>[] ctors = determineConstructorsFromBeanPostProcessors(beanClass, beanName);
  //如果符合以下条件,则使用使用最符合的构造函数进行实例化bean
  if (ctors != null || mbd.getResolvedAutowireMode() == AUTOWIRE_CONSTRUCTOR ||
      mbd.hasConstructorArgumentValues() || !ObjectUtils.isEmpty(args)) {
    return autowireConstructor(beanName, mbd, ctors, args);
  }

  // Preferred constructors for default construction?
  ctors = mbd.getPreferredConstructors();
  if (ctors != null) {
    return autowireConstructor(beanName, mbd, ctors, null);
  }

  //如果都不符合,则使用默认无惨的构造方法进行实例化bean
  return instantiateBean(beanName, mbd);
}
```

> 在该方法中,会调用对应的bean的构造方法

#### id:9,pid:7---applyMergedBeanDefinitionPostProcessors(mbd, beanType, beanName)

回调postProcessMergedBeanDefinition(实例化之后),目前还不知道这个回调有什么作用

#### id:10,pid:7---populateBean(beanName, mbd, instanceWrapper)

在该方法中,先回调postProcessAfterInstantiation(实例化后回调),在进行属性的自动注入,在回调postProcessProperties:

1. 先回调postProcessAfterInstantiation(实例化后回调)
2. 再进行属性的自动注入
3. 最后回调postProcessProperties(自动注入属性之后,可修改属性)

部分源码:

```java
protected void populateBean(String beanName, RootBeanDefinition mbd, @Nullable BeanWrapper bw) {
  //...
  
  //============回调postProcessAfterInstantiation=========
  //在自动装配之前,通过postProcessAfterInstantiation回调可以修改当前bean的马上要设置的属性值
  //如果不是合成的,并且有InstantiationAware后置处理器
  if (!mbd.isSynthetic() && hasInstantiationAwareBeanPostProcessors()) {
    for (BeanPostProcessor bp : getBeanPostProcessors()) {
      if (bp instanceof InstantiationAwareBeanPostProcessor) {
        InstantiationAwareBeanPostProcessor ibp = (InstantiationAwareBeanPostProcessor) bp;
        //回调后置处理器,默认返回true,如果返回false,则不接下来的自动装配,而是直接返回;如果返回true,则继续接下来的自动装配
        if (!ibp.postProcessAfterInstantiation(bw.getWrappedInstance(), beanName)) {
          return;
        }
      }
    }
  }

  //获取需要进行装配的参数
  PropertyValues pvs = (mbd.hasPropertyValues() ? mbd.getPropertyValues() : null);

  /**
		 * 获取自动装配的类型,总共有5种类型:
		 * 		1.AUTOWIRE_NO:值为0;
		 * 			- 没有明确的指定注入类型
		 * 		2.AUTOWIRE_BY_NAME:值为1
		 * 			- 指定通过名称进行注入
		 * 		3.AUTOWIRE_BY_TYPE:值为2
		 * 			- 指定通过类型进行注入
		 * 		4.AUTOWIRE_CONSTRUCTOR:值为3
		 * 			- 指定通过构造函数进行注入
		 * 		5.AUTOWIRE_AUTODETECT:值为4
		 * 			- 自动选择适当的方式进行注入
		 */
  //+++++++++++++++++先进行默认的自动装配+++++++++++++++++++++
  //获取自动装配的类型
  int resolvedAutowireMode = mbd.getResolvedAutowireMode();
  //如果注入的类型是按名称注入或者是按类型注入
  if (resolvedAutowireMode == AUTOWIRE_BY_NAME || resolvedAutowireMode == AUTOWIRE_BY_TYPE) {
    MutablePropertyValues newPvs = new MutablePropertyValues(pvs);
    //如果按名称注入
    if (resolvedAutowireMode == AUTOWIRE_BY_NAME) {
      //执行按名称的自动注入(只是将默认需要注入的属性添加到MutablePropertyValues中,在之后postProcessPropertyValues回调中可以修改自动注入的值)
      autowireByName(beanName, mbd, bw, newPvs);
    }
    //如果按类型注入
    if (resolvedAutowireMode == AUTOWIRE_BY_TYPE) {
      //执行按类型的自动注入(只是将默认需要注入的属性添加到MutablePropertyValues中,在之后postProcessPropertyValues回调中可以修改自动注入的值)
      autowireByType(beanName, mbd, bw, newPvs);
    }
    //保存通过默认的自动注入方式需要注入的属性值(在后面可能会被后置处理器回调中修改)
    pvs = newPvs;
  }
  //=============回调postProcessPropertyValues来修改bean已经被自动注入的属性=================
  //判断是否有InstantiationAware的后置处理器
  boolean hasInstAwareBpps = hasInstantiationAwareBeanPostProcessors();
  //判断是否需要依赖检查
  boolean needsDepCheck = (mbd.getDependencyCheck() != AbstractBeanDefinition.DEPENDENCY_CHECK_NONE);

  PropertyDescriptor[] filteredPds = null;
  //如果有InstantiationAware的后置处理器
  if (hasInstAwareBpps) {
    if (pvs == null) {
      pvs = mbd.getPropertyValues();
    }
    //============执行postProcessPropertyValues回调===============
    for (BeanPostProcessor bp : getBeanPostProcessors()) {
      if (bp instanceof InstantiationAwareBeanPostProcessor) {
        InstantiationAwareBeanPostProcessor ibp = (InstantiationAwareBeanPostProcessor) bp;
        //主要回调:执行postProcessProperties回调,并返回修改后的参数集合类
        PropertyValues pvsToUse = ibp.postProcessProperties(pvs, bw.getWrappedInstance(), beanName);
        if (pvsToUse == null) {
          if (filteredPds == null) {
            filteredPds = filterPropertyDescriptorsForDependencyCheck(bw, mbd.allowCaching);
          }
          pvsToUse = ibp.postProcessPropertyValues(pvs, filteredPds, bw.getWrappedInstance(), beanName);
          //如果为null,则返回,不进行接下来的自动装配
          if (pvsToUse == null) {
            return;
          }
        }
        pvs = pvsToUse;//保存需要注入的属性值
      }
    }
  }
  
  //...

  //如果需要注入的属性值不为null
  if (pvs != null) {
    //将属性集合中的属性注入到bean实例中
    applyPropertyValues(beanName, mbd, bw, pvs);
  }

}
```

##### id:11,pid:10---applyPropertyValues(beanName, mbd, bw, pvs)

实现了bean属性的自动注入(将PropertyValues的值通过反射注入到已经实例化bean的属性中)

#### id:12,pid:7---initializeBean(beanName, exposedObject, mbd)

执行bean的初始化方法和后置处理器的回调:

1. 先回调postProcessBeforeInitialization(初始化方法之前回调)
2. 再执行初始化方法方法(即实现了InitialBean接口)
3. 最后回调postProcessAfterInitialization(初始化方法之后回调)

部分源码如下:

```java
protected Object initializeBean(final String beanName, final Object bean, @Nullable RootBeanDefinition mbd) {
  //...
  
  //执行实现了Aware接口的方法,如实现了BeanFactoryAware,BeanNameAware等接口的方法
  invokeAwareMethods(beanName, bean);
  
  //保存bean实例的引用
  Object wrappedBean = bean;
  //如果beanDefinition为null或者bean不是合成的
  if (mbd == null || !mbd.isSynthetic()) {
    //回调postProcessBeforeInitialization(初始化方法之前回调)
    wrappedBean = applyBeanPostProcessorsBeforeInitialization(wrappedBean, beanName);
  }

  try {
    //执行初始化方法方法(如果存在的话,即实现了InitialBean接口)
    invokeInitMethods(beanName, wrappedBean, mbd);
  }
  catch (Throwable ex) {
    //抛出异常
  }
  //如果rootBeanDefinition为空 或者 beanDefinition不是合成的
  if (mbd == null || !mbd.isSynthetic()) {
    //回调postProcessAfterInitialization(初始化方法之后回调)
    wrappedBean = applyBeanPostProcessorsAfterInitialization(wrappedBean, beanName);
  }

  //返回对应的bean包装类
  return wrappedBean;
}
```

##### id:13,pid:12---applyBeanPostProcessorsBeforeInitialization(wrappedBean, beanName)

回调postProcessBeforeInitialization(初始化方法之前回调):

1. 回调自定义的后置处理器
2. 回调处理@PostStructure注解的后置处理器(InitDestroyAnnotationBeanPostProcessor的postProcessBeforeInitialization方法)等
3. 回调实现了`ApplicationContextAware`等接口的方法

##### id:14,pid:12---invokeInitMethods(beanName, wrappedBean, mbd)

执行bean的初始化方法(即实现了InitialBean接口的方法:afterPropertiesSet)

##### id:15,pid:12---applyBeanPostProcessorsAfterInitialization(wrappedBean, beanName)

回调postProcessAfterInitialization(初始化方法之后回调)

## id:16---finishRefresh()

当容器初始化成功后,回调监听事件

部分源码如下:

```java
protected void finishRefresh() {
  //清除上下文级的资源缓存(比如扫描的ASM元数据)。
  clearResourceCaches();

  //为此上下文初始化生命周期处理器。
  initLifecycleProcessor();

  //获取默认创建的生命周期处理器,并调用onRefresh方法(上下文刷新通知，例如用于自动启动组件。)
  getLifecycleProcessor().onRefresh();

  //发送最终的应用启动(刷新)事件(ContextRefreshedEvent)
  publishEvent(new ContextRefreshedEvent(this));

  //不知道干什么用
  LiveBeansView.registerApplicationContext(this);
}
```

### id:17,pid:16---publishEvent(new ContextRefreshedEvent(this))

回调`ApplicationListener`的`onApplicationEvent`方法

## 当调用容器的close()方法时

`close()`==>`doClose()`==>`destroyBeans()`==>`getBeanFactory().destroySingletons()`==>`super.destroySingletons()`==>`destroySingleton(disposableBeanNames[i])`==>`super.destroySingleton(beanName)`==>`destroyBean(beanName, disposableBean)`==>`bean.destroy()`

在`bean.destroy()`的方法中:

```java
public void destroy() {
  //在这里面调用了@preDestroy注解标注的方法
  for (DestructionAwareBeanPostProcessor processor : this.beanPostProcessors) {
    processor.postProcessBeforeDestruction(this.bean, this.beanName);
  }
  
  //...
  
  //在这里调用了实现了DisposableBean接口的destroy()方法
  ((DisposableBean) this.bean).destroy();

  //...
}
```

# 精简的初始化过程

- 先调用`AnnotationConfigApplicationContext`的`this()`的构造方法,创建容器实例

- 调用`register(componentClasses)`将传入的指定类先解析并注册到容器中

  > 注意,此时还未实例化,一般是等到实例化单实例bean的时候和其他单实例bean一起一同实例化

再调用`refresh()`方法刷新容器

> 实例化并初始化单实例bean

- 调用`invokeBeanFactoryPostProcessors(beanFactory)`方法实例化并注册BeanFactoryPostProcessors,并回调`postProcessBeanDefinitionRegistry`方法

  > 先调用实现了BeanFactoryPostProcessors接口的实现类的构造方法,然后再回调`postProcessBeanDefinitionRegistry`方法

- 调用`registerBeanPostProcessors(beanFactory)`方法,实例化并注册所有的后置处理器

  > 先按照实现接口的不同进行分类,分出大的优先级,然后通过sortPostProcessors方法再进行小排序,然后将他们按照顺序注册到集合中,以便之后实例化单实例bean时可以正确的回调

- 调用`finishBeanFactoryInitialization(beanFactory)`方法中的`beanFactory.preInstantiateSingletons()`,来实例化剩下的所有的单实例bean

  - 在`preInstantiateSingletons`方法中,先获取到所有的bean的名称,然后遍历名称,通过`getBean(beanName)`中的`getSingleton(beanName,()->{return createBean(beanName, mbd, args)})`来尝试从单例缓存中获取bean实例,如果获取不到,则进行创建单实例bean(即调用`createBean`方法)

  - 在`createBean`方法中,调用`resolveBeforeInstantiation(beanName, mbdToUse)`方法,用来回调`postProcessBeforeInstantiation`

  - 再调用`doCreateBean(beanName, mbdToUse, args)`方法来创建bean实例

    - 调用`createBeanInstance(beanName, mbd, args)`方法来创建bean实例

      > 在此方法中会调用bean的构造方法

    - 调用`applyMergedBeanDefinitionPostProcessors(mbd, beanType, beanName)`方法来回调`postProcessMergedBeanDefinition`

    - 调用`populateBean(beanName, mbd, instanceWrapper)`方法来完成属性注入

      - 先回调`postProcessAfterInstantiation`
      - 在进行默认的自动属性注入
      - 再回调`postProcessProperties`方法,用来修改自动注入的属性

    - 调用`initializeBean(beanName, exposedObject, mbd)`方法来执行bean的初始化方法和一些回调

      - 调用invokeAwareMethods方法,执行Aware接口的一些方法,如`BeanFactoryAware`,`BeanNameAware`等

        > 如果bean实现了这些接口,那么在这个方法中,接口中实现的方法将会被调用

      - 调用`applyBeanPostProcessorsBeforeInitialization(wrappedBean, beanName)`方法来回调`postProcessBeforeInitialization`

        > 注意:
        >
        > 在这里会先调用我们自定义的后置处理器
        >
        > 然后会调用处理@PostStructure注解的后置处理器(InitDestroyAnnotationBeanPostProcessor),默认存在的后置处理器

        > 如果当前的bean实现了`ApplicationContextAware`接口,那么在循环到`ApplicationContextAwareProcessor`后置处理器时,会调用`invokeAwareInterfaces(bean)`,在该方法中会回调实现了接口的方法(setApplicationContext),该方法可以将ApplicationContext引用保存起来,以便之后使用

      - 执行`invokeInitMethods(beanName, wrappedBean, mbd)`方法,来执行实现了InitialBean接口的方法:afterPropertiesSet

      - 调用`applyBeanPostProcessorsAfterInitialization(wrappedBean, beanName)`方法来回调`postProcessAfterInitialization`

  - 回调所有`SmartInitializingSingleton`类型的`afterSingletonsInstantiated`方法

- 调用`publishEvent(new ContextRefreshedEvent(this));`方法来发送容器初始化成功事件,会回调实现了`ApplicationListener`接口的`onApplicationEvent`方法
- 在容器调用close方法时,会执行beanFactory的`destroySingletons`方法,会调用`destroySingleton(disposableBeanNames[i])`把所有的单实例bean都进行销毁,然后会调用`InitDestroyAnnotationBeanPostProcessor`,执行`postProcessBeforeDestruction`方法,然后会调用了使用`@PreDestroy`注解标注的方法,然后调用实现了`DisposableBean`接口的`destroy()`方法,然后单实例bean就会被销毁了

# 后置处理器的回调

1. `postProcessBeanDefinitionRegistry`

2. `postProcessBeforeInstantiation`

> 调用bean的构造方法

3. `postProcessMergedBeanDefinition`

4. `postProcessAfterInstantiation`

5. `postProcessProperties`

> 调用BeanFactoryAware接口的setBeanFactory方法

> 调用ApplicationContextAware接口的setApplicationContext方法

6. `postProcessBeforeInitialization`

> 执行@PostConstruct注解标注的方法

> 调用InitializingBean接口的afterPropertiesSet方法(bean的初始化方法)

7. `postProcessAfterInitialization`

> 调用ApplicationListener接口的onApplicationEvent方法

> 执行@PreDestroy注解标注的方法

> 调用DisposableBean接口的Destroy方法

# springIOC初始化流程图

![springIOC的初始化过程](/Users/yingjie.lu/Documents/note/.img/springIOC的初始化过程-8314350.svg)

# bean的循环引用问题

spring是通过一级缓存和二级缓存来解决bean的循环引用问题,即一级缓存则为狭义的IOC容器,而二级缓存则为保存当前正在创建的bean(即存在缓存引用的bean)

**在bean的生命周期中,在bean进行属性的自动注入的时候,会调用`AutowiredAnnotationBeanPostProcessor`后置处理器的`postProcessProperties`回调方法来进行属性注入,并解决循环依赖的问题**

> org.springframework.beans.factory.config.InstantiationAwareBeanPostProcessor#postProcessProperties

该后置处理器的方法大致如下:

```java
@Override
public PropertyValues postProcessProperties(PropertyValues pvs, Object bean, String beanName) {
  InjectionMetadata metadata = findAutowiringMetadata(beanName, bean.getClass(), pvs);
  metadata.inject(bean, beanName, pvs);//注入属性
  return pvs;
}
```

在`inject()`方法中的核心代码为:

```java
@Override
protected void inject(Object bean, @Nullable String beanName, @Nullable PropertyValues pvs) throws Throwable {
  Field field = (Field) this.member;
  Object value;
  if (this.cached) {
    value = resolvedCachedArgument(beanName, this.cachedFieldValue);
  }
  else {
    //获取需要注入属性值的依赖
    DependencyDescriptor desc = new DependencyDescriptor(field, this.required);
    
    //...
    //=====================重要=================
    //解决属性的依赖问题(获取到了需要注入属性的值,即使是有循环引用)
    value = beanFactory.resolveDependency(desc, beanName, autowiredBeanNames, typeConverter);
    
    //...
  }
  
  //如果拿到了要注入的值,则进行注入(如果是循环引用,因为有了之前的处理,然后就没有继续循环的调用创建循环依赖的bean,而是返回了一个属性值为null的循环依赖bean,先进行设值)
  if (value != null) {
    //开放属性的权限
    ReflectionUtils.makeAccessible(field);
    //将value的值设置的bean的字段中
    field.set(bean, value);
  }
}
```

在`resolveDependency()`方法中会调用`doResolveDependency()`方法,去解决属性的依赖问题

> org.springframework.beans.factory.support.DefaultListableBeanFactory#doResolveDependency

在`doResolveDependency()`方法中的核心内容如下:

```java
public Object doResolveDependency(DependencyDescriptor descriptor, @Nullable String beanName,
                                  @Nullable Set<String> autowiredBeanNames, @Nullable TypeConverter typeConverter) throws BeansException {
  //获取将要注入的属性(注入点，指向方法/构造函数参数或字段)
  InjectionPoint previousInjectionPoint = ConstructorResolver.setCurrentInjectionPoint(descriptor);
  try {
    //...
    
    //获取自动注入属性的候选
    //获取到需要注入的属性
    Map<String, Object> matchingBeans = findAutowireCandidates(beanName, type, descriptor);
    if (matchingBeans.isEmpty()) {
      if (isRequired(descriptor)) {
        raiseNoMatchingBeanFound(type, descriptor.getResolvableType(), descriptor);
      }
      return null;
    }

    String autowiredBeanName;
    Object instanceCandidate;
    //如果有多个,则需要在进行判断
    //====(先按名称进行自动注入,如果没有名称,则按照类型自动注入)=====
    if (matchingBeans.size() > 1) {
      //获取自动注入的指定的名称
      autowiredBeanName = determineAutowireCandidate(matchingBeans, descriptor);
      //如果没有名称,则按照类型进行注入属性
      if (autowiredBeanName == null) {
        if (isRequired(descriptor) || !indicatesMultipleBeans(type)) {
          return descriptor.resolveNotUnique(descriptor.getResolvableType(), matchingBeans);
        }
        else {
          return null;
        }
      }
      //如果有名称,则优先按照名称进行注入
      instanceCandidate = matchingBeans.get(autowiredBeanName);
    }
    else {
      //如果只有一个匹配的
      Map.Entry<String, Object> entry = matchingBeans.entrySet().iterator().next();
      //获取bean的名称
      autowiredBeanName = entry.getKey();
      //获取bean的实体
      instanceCandidate = entry.getValue();
    }

    if (autowiredBeanNames != null) {
      autowiredBeanNames.add(autowiredBeanName);
    }
    if (instanceCandidate instanceof Class) {
      //==============================解决循环引用的问题==============================
      //在resolveCandidate()方法中会调用beanFactory.getBean(beanName)来返回对应的bean
      //大致流程为: 先去单例缓存中获取,如果没有,则进行创建(在创建过程中又会进行属性装配,然后在装配过程中又会调用该方法)
      //主要的核心内容是: 
      //去单例缓存中获取对应bean(getSingleton()方法)
      //在该方法中,先尝试从一级缓存中获取(已经创建好的bean),如果没有
      //再尝试从二级缓存中获取(正在创建的bean,即有循环引用),如果没有获取到,并且允许循环引用
      //则从单例工厂SingletonFactorys中获取对应的bean工厂,然后创建对应的bean,
      //然后将bean保存到二级缓存中,并将其从单例工厂中删除,并返回通过单例工厂创建的bean
      instanceCandidate = descriptor.resolveCandidate(autowiredBeanName, type, this);
    }
    Object result = instanceCandidate;
    if (result instanceof NullBean) {
      if (isRequired(descriptor)) {
        raiseNoMatchingBeanFound(type, descriptor.getResolvableType(), descriptor);
      }
      result = null;
    }
    return result;
  }
  finally {
    //设置当前正在创建的bean(如果已经不是正在创建,则删除集合中保存这正在创建的bean)
    ConstructorResolver.setCurrentInjectionPoint(previousInjectionPoint);
  }
}
```

在`resolveCandidate()`方法中最终会调用最重要的`getSingleton(beanName, true)`方法,大致核心代码如下:

```java
//allowEarlyReference为表示是否允许循环引用,spring是默认支持循环引用的
protected Object getSingleton(String beanName, boolean allowEarlyReference) {
  //从保存单实例bean的ConcurrentHashMap中获取实例
  Object singletonObject = this.singletonObjects.get(beanName);//一级缓存
  //如果没有获取到,并且该bean当前正在创建状态(说明是循环引用)
  if (singletonObject == null && isSingletonCurrentlyInCreation(beanName)) {
    synchronized (this.singletonObjects) {
      //先尝试从二级缓存中获取对应的bean
      singletonObject = this.earlySingletonObjects.get(beanName);//二级缓存
      //如果没有获取到 并且 允许循环引用
      if (singletonObject == null && allowEarlyReference) {
        //从缓存单例工厂的HashMap中获取对应的单例工厂
        ObjectFactory<?> singletonFactory = this.singletonFactories.get(beanName);//单例工厂
        //如果获取到了单例工厂
        if (singletonFactory != null) {
          //从单例工厂获取一个对应的单实例bean
          //在从单例工厂中创建的bean可以返回的是一个代理类,这样,就可以在循环引用中注入代理类
          //(getObject()方法是可以自定义的,因此可以在获取bean是可以返回一个代理类)
          //获取到对应的bean实例之后,需要将其进行缓存到二级缓存中,然后将其从singletonFactory中删除(因为他是单例的,不需要每次都使用工厂创建,因为已经缓存了)
          singletonObject = singletonFactory.getObject();
          //将从单例工厂中创建的bean缓存到二级缓存中,在下一次来获取时,可以在之前就从二级缓存中直接获取,而不用通过单例工厂在创建依次
          this.earlySingletonObjects.put(beanName, singletonObject);
          //将缓存单例工厂的HashMap中的对应的单例工厂删除
          this.singletonFactories.remove(beanName);
        }
      }
    }
  }
  //返回对应的单例对象
  return singletonObject;
}
```

> 正是因为有了二级缓存的存在(保存当前正在创建bean),所以才避免了循环引用bean时会进行循环创建的问题

# 总结

可以继承`InstantiationAwareBeanPostProcessorAdapter`类来替代实现`InstantiationAwareBeanPostProcessor`接口,使用起来会更加的方便



























