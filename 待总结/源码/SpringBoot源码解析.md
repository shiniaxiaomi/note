运行流程:

首先，运行run方法

```java
@SpringBootApplication
public class Demo1Application {
    public static void main(String[] args) {
        SpringApplication.run(Demo1Application.class, args);
    }
}
```

之后会调用SpringApplication的run静态方法，传入主启动类到primarySource变量中

```java
public static ConfigurableApplicationContext run(Class<?> primarySource, String... args) {
    return run(new Class<?>[] { primarySource }, args);
}
```

之后会创建一个SpringApplication对象，把主启动类传进去

```java
public static ConfigurableApplicationContext run(Class<?>[] primarySources, String[] args) {
    return new SpringApplication(primarySources).run(args);
}
```

调用SpringApplication对象的构造方法

```java
public SpringApplication(ResourceLoader resourceLoader, Class<?>... primarySources) {
    this.resourceLoader = resourceLoader;
    Assert.notNull(primarySources, "PrimarySources must not be null");
    this.primarySources = new LinkedHashSet<>(Arrays.asList(primarySources));
    //判断应用的类型（reactive，none，servlet）
    this.webApplicationType = WebApplicationType.deduceFromClasspath();
    //通过getSpringFactoriesInstances（）方法拿到所有的类路径下/META-INF/spring.factories文件下的所有类信息，然后获取属于ApplicationContextInitializer接口的类信息，并将他们设置为初始化类
    setInitializers((Collection) getSpringFactoriesInstances(ApplicationContextInitializer.class));
    //拿到所有属于ApplicationListener接口的类信息，并将他们设置为监听器
    setListeners((Collection) getSpringFactoriesInstances(ApplicationListener.class));
    //实例化启动类（拿到当前堆栈的信息，判断调用的方法是否是main方法，如果是，则创建对应的类，即启动类）
    this.mainApplicationClass = deduceMainApplicationClass();
}
```

最终会调用SpringApplication的普通run方法

```java
public ConfigurableApplicationContext run(String... args) {
    StopWatch stopWatch = new StopWatch();
    stopWatch.start();
    ConfigurableApplicationContext context = null;
    Collection<SpringBootExceptionReporter> exceptionReporters = new ArrayList();
    this.configureHeadlessProperty();
    //拿到监听器
    SpringApplicationRunListeners listeners = this.getRunListeners(args);
    //回调监听器的starting方法（默认会调用EventPublishingRunListener类的starting方法）
    listeners.starting();

    Collection exceptionReporters;
    try {
        //获取命令行参数
        ApplicationArguments applicationArguments = new DefaultApplicationArguments(args);
        //准备程序运行的环境，返回的environment就是可以用的配置了，覆盖优先级从上往下，上面的会覆盖下面
        ConfigurableEnvironment environment = this.prepareEnvironment(listeners, applicationArguments);
        this.configureIgnoreBeanInfo(environment);
        // 打印spring的logo
        Banner printedBanner = this.printBanner(environment);
        // 根据应用类型创建对应的上下文：如果是servlet，则创建org.springframework.boot.web.servlet.context.AnnotationConfigServletWebServerApplicationContext类的上下文环境，如果是reactive，则创建org.springframework.boot.web.reactive.context.AnnotationConfigReactiveWebServerApplicationContext类的上下文环境，如果是none，则创建org.springframework.context.annotation.AnnotationConfigApplicationContext类的上下文环境
        context = this.createApplicationContext();
        // 拿到所有的异常分析类
        exceptionReporters = this.getSpringFactoriesInstances(SpringBootExceptionReporter.class, new Class[]{ConfigurableApplicationContext.class}, context);
        // 将一些参数设置到刚创建的上下文中
        this.prepareContext(context, environment, listeners, applicationArguments, printedBanner);
        this.refreshContext(context);
        this.afterRefresh(context, applicationArguments);
        stopWatch.stop();
        if (this.logStartupInfo) {
            (new StartupInfoLogger(this.mainApplicationClass)).logStarted(this.getApplicationLog(), stopWatch);
        }

        listeners.started(context);
        this.callRunners(context, applicationArguments);
    } catch (Throwable var10) {
        this.handleRunFailure(context, var10, exceptionReporters, listeners);
        throw new IllegalStateException(var10);
    }

    try {
        listeners.running(context);
        return context;
    } catch (Throwable var9) {
        this.handleRunFailure(context, var9, exceptionReporters, (SpringApplicationRunListeners)null);
        throw new IllegalStateException(var9);
    }
}
```

1. prepareEnvironment方法

   ```java
   private ConfigurableEnvironment prepareEnvironment(SpringApplicationRunListeners listeners,ApplicationArguments applicationArguments) {
       // 创建或设置环境（根据导入包的判断出的类型，来创建对应的环境类）
       ConfigurableEnvironment environment = getOrCreateEnvironment();
       // 根据命令行参数和配置文件信息添加到source配置信息中
       configureEnvironment(environment, applicationArguments.getSourceArgs());
       // 合并
       ConfigurationPropertySources.attach(environment);
       // 回调监听器的environmentPrepared（）方法，回调完成后，环境就准备好了
       // 在期间会ConfigFileApplicationListener类的方法，用于加载对应的配置文件
       listeners.environmentPrepared(environment);
       // 做配置的合并和覆盖操作
       bindToSpringApplication(environment);
       if (!this.isCustomEnvironment) {
           // 做配置的合并和覆盖操作
           environment = new EnvironmentConverter(getClassLoader()).convertEnvironmentIfNecessary(environment,
                                                                                                  deduceEnvironmentClass());
       }
       ConfigurationPropertySources.attach(environment);
       return environment;
   }
   ```

2. prepareContext方法

   ```java
   private void prepareContext(ConfigurableApplicationContext context, ConfigurableEnvironment environment,SpringApplicationRunListeners listeners, ApplicationArguments applicationArguments, Banner printedBanner) {
       // 设置环境对象引用
       context.setEnvironment(environment);
       postProcessApplicationContext(context);
       // 回调之前创建的初始化类（ApplicationContextInitializer的initialize方法），做一些初始化操作（添加一些监听器和后置处理器）
       applyInitializers(context);
       // 回调之前创建的监听器（SpringApplicationRunListeners的contextPrepared方法）
       listeners.contextPrepared(context);
       if (this.logStartupInfo) {
           logStartupInfo(context.getParent() == null);
           logStartupProfileInfo(context);
       }
       // Add boot specific singleton beans
       ConfigurableListableBeanFactory beanFactory = context.getBeanFactory();
       beanFactory.registerSingleton("springApplicationArguments", applicationArguments);
       if (printedBanner != null) {
           beanFactory.registerSingleton("springBootBanner", printedBanner);
       }
       if (beanFactory instanceof DefaultListableBeanFactory) {
           ((DefaultListableBeanFactory) beanFactory)
           .setAllowBeanDefinitionOverriding(this.allowBeanDefinitionOverriding);
       }
       if (this.lazyInitialization) {
           context.addBeanFactoryPostProcessor(new LazyInitializationBeanFactoryPostProcessor());
       }
       // Load the sources
       Set<Object> sources = getAllSources();
       Assert.notEmpty(sources, "Sources must not be empty");
       load(context, sources.toArray(new Object[0]));
       listeners.contextLoaded(context);
   }
   ```

   

