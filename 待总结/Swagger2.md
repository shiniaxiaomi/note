## 核心jar

springfox-swagger-ui

![image-20200603145201117](D:\note\.img\image-20200603145201117.png)

springfox-swagger-common

![image-20200603145220746](D:\note\.img\image-20200603145220746.png)

springfox-swagger2

![image-20200603145257687](D:\note\.img\image-20200603145257687.png)

## 核心流程

通过`@EnableSwagger2`注解开启swagger

在`@EnableSwagger2`注解中，导入了`Swagger2DocumentationConfiguration`自动配置类,然后扫描了指定的包：

```java
springfox.documentation.swagger2.readers.parameter springfox.documentation.swagger2.mappers
```

之后还会将`DocumentationPluginsBootstrapper`类也加入到springIOC中，该类实现了`SmartLifecycle`接口，在成功加载该类后会回调该接口的`start`方法，从而启动swagger



在`start`方法中：

```java
@Override
public void start() {
    if (initialized.compareAndSet(false, true)) {
        log.info("Context refreshed");
        List<DocumentationPlugin> plugins = pluginOrdering()
            .sortedCopy(documentationPluginsManager.documentationPlugins());
        log.info("Found {} custom documentation plugin(s)", plugins.size());
        for (DocumentationPlugin each : plugins) {
            DocumentationType documentationType = each.getDocumentationType();
            if (each.isEnabled()) {
                scanDocumentation(buildContext(each));
            } else {
                log.info("Skipping initializing disabled plugin bean {} v{}",
                         documentationType.getName(), documentationType.getVersion());
            }
        }
    }
}
```



