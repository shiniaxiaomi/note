在SpringBoot项目中，只要我们实现了`ApplicationRunner`接口，然后把实现类交给spring管理，那么，在SpringBoot启动成功后会进行该接口的回调



示例：

```java
@Component
public class ToMarkdown implements ApplicationRunner {
    //服务启动完成后，回调该方法
    @Override
    public void run(ApplicationArguments args) throws Exception {
        ...
    }
}
```







