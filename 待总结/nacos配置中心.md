从cacos配置中心加载的配置只能直接覆盖掉原始配置，但是不能够再去执行一些其他操作，比如指定`spring.profiles.active=dev`在cacos中配置是无效的

但是配置`test=111`变量就可以直接覆盖掉原始的配置，而且优先级是最高的（一定会覆盖），因为它是最后才加载，里面的内容会在之前的进行覆盖



其他的配置文件的加载顺序和springboot一样，在其他配置加载时也可以使用`spring.profiles.active=dev`



---



cacos的注册地址必须要写在`bootstrap`配置文件中，如果写在`application`配置文件中是无效的，无法识别



其他配置文件的规则和springboot中使用的是一样的



---



在cacos配置中心中配置的信息需要时经常改动



---

当通过nacos加载配置时，它默认会加载nacos中 DataId为`${spring.application.name}.文件后缀` 的配置文件和`${spring.application.name}-${profile}.文件后缀`的配置文件

- 如果我们在配置文件中配置了以下内容：

  ```properties
  spring.cloud.nacos.config.name=NacosDemo
  spring.profiles.active=dev
  ```

  则nacos会默认加载这两个配置文件：

  - `NacosDemo`
  - `NacosDemo-dev`

> 需要注意的是，如果没有配置`spring.cloud.nacos.config.name`，则会使用`spring.application.name`的值进行加载（首先使用前缀，然后使用名称，最后使用spring.application.name ）





使用` @RefreshScope `注解用于开启自动刷新从配置中心加载的数据

> 开启自动刷新配置（标注在类上生效该类中的所有注入字段）

代码如下：

```java
@RestController
@RefreshScope //开启自动刷新配置（标注在类上生效该类中的所有注入字段）
public class EchoController {
    @Value("${user.age}")
    int age;
   
}
```



