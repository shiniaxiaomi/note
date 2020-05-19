springcloud配置文件覆盖规则：

- 按照优先级进行加载配置文件
- 后加载的配置文件的内容会覆盖前面的内容





 properties 比yml加载的优先级更高



如果有bootstrap配置文件，先加载

然后默认加载application.properties配置文件，再加载application.yml配置文件









配置文件的加载顺序：

> 在`ConfigFileApplicationListener`类中定义了配置文件的加载顺序
>
> ```java
> private static final String DEFAULT_SEARCH_LOCATIONS = "classpath:/,classpath:/config/,file:./,file:./config/";
> ```

- 先加载classpath（Resource）下的配置文件
- 再加载classpath（Resource）下的config文件夹下的配置文件
- 再加载项目路径下的配置文件
- 再加载项目路径下的config文件夹下的配置文件
- 在加载与jar包同一路径下的配置文件
- 再加载与jar包同一路径下的config文件夹下的配置文件

> 再寻找对应配置文件的时候，也会根据上述顺序进行查找，并依次进行覆盖