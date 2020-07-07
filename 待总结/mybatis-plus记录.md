## 依赖

添加pom依赖

```xml
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus</artifactId>
    <version>3.3.2</version>
</dependency>
```

如果mybatis-plus与Springboot整合的话，只需要导入以下依赖即可：

```xml
<!--不需要再导入mybatis-starter-->
<dependency>
  <groupId>com.baomidou</groupId>
  <artifactId>mybatis-plus-boot-starter</artifactId>
  <version>3.3.2</version>
</dependency>
```

## 特性

- 无侵入：只做增强，不做修改
- 损耗小：启动时只注入CRUD，直接面向对象操作
- 强大的CRUD操作：内置通用Mapper，通用Service，通过少量配置即可实现大部分的CRUD
- 支持主键自动生成
- 内置代码生成器：采用代码或maven插件可以生成mapper，model，service，controller的代码，支持模版引擎
- 支持分页
- 内置性能分析插件
- 内置全局拦截插件

## 框架结构

![mybatis-plus-framework](https://mp.baomidou.com/img/mybatis-plus-framework.jpg)

## 快速开始

[https://mp.baomidou.com/guide/quick-start.html#%E6%B7%BB%E5%8A%A0%E4%BE%9D%E8%B5%96](https://mp.baomidou.com/guide/quick-start.html#添加依赖)

1. 在pom文件中导入依赖

   ```xml
   <dependency>
     <groupId>com.baomidou</groupId>
     <artifactId>mybatis-plus-boot-starter</artifactId>
     <version>3.3.2</version>
   </dependency>
   ```

2. 创建跟数据库表对应的实体类

   ```java
   @Accessors(chain = true)
   @Data
   public class User {
       private Long id;
       private String name;
       private Integer age;
       private String email;
   }
   ```

3. 创建一个mapper接口，继承Mybatis-plus提供的通用mapper

   ```java
   public interface UserMapper extends BaseMapper<User> {
   }
   ```

4. 在启动类上标注mapper的扫描包路径

   ```java
   @SpringBootApplication
   @MapperScan("com.example.mybatisplusdemo.mapper")
   public class MybatisPlusDemoApplication {
     public static void main(String[] args) {
       SpringApplication.run(MybatisPlusDemoApplication.class, args);
     }
   
   }
   ```

5. 运行测试类

   ```java
   @RunWith(SpringRunner.class)
   @SpringBootTest
   class MybatisPlusDemoApplicationTests {
   
       @Autowired
       private UserMapper userMapper;
   
       @Test
       void contextLoads() {
           System.out.println(("----- selectAll method test ------"));
           List<User> userList = userMapper.selectList(null);
           Assert.assertEquals(5, userList.size());
           userList.forEach(System.out::println);
   
       }
   
   }
   ```

## 注解

https://mp.baomidou.com/guide/annotation.html#tablename

@TableName：表名注解（如果没有，则使用类名）

@TableId：主键注解

@TableField：字段注解（非主键）

@KeySequence：序列主键策略（oracle）

## 核心功能

### 代码生成器

https://mp.baomidou.com/guide/generator.html

更详细内容参考：https://mp.baomidou.com/config/generator-config.html

添加依赖

代码生成器依赖：

```xml
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-generator</artifactId>
    <version>3.3.2</version>
</dependency>
```

模版引擎依赖：

```xml
<dependency>
    <groupId>org.freemarker</groupId>
    <artifactId>freemarker</artifactId>
    <version>2.3.30</version>
</dependency>
```

整体Demo：

> 需要注意的是：需要导入mybatis-plus-springboot-starter的依赖包

```java
package com.example.mybatisplusdemo.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.generator.AutoGenerator;
import com.baomidou.mybatisplus.generator.InjectionConfig;
import com.baomidou.mybatisplus.generator.config.DataSourceConfig;
import com.baomidou.mybatisplus.generator.config.FileOutConfig;
import com.baomidou.mybatisplus.generator.config.GlobalConfig;
import com.baomidou.mybatisplus.generator.config.PackageConfig;
import com.baomidou.mybatisplus.generator.config.StrategyConfig;
import com.baomidou.mybatisplus.generator.config.TemplateConfig;
import com.baomidou.mybatisplus.generator.config.converts.MySqlTypeConvert;
import com.baomidou.mybatisplus.generator.config.po.TableInfo;
import com.baomidou.mybatisplus.generator.config.rules.DbColumnType;
import com.baomidou.mybatisplus.generator.config.rules.IColumnType;
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;

/**
 * <p>
 * 代码生成器演示
 * </p>
 */
public class MpGenerator {

  /**
     * <p>
     * MySQL 生成演示
     * </p>
     */
  public static void main(String[] args) {
    AutoGenerator mpg = new AutoGenerator();
    // 选择 freemarker 引擎，默认 Veloctiy
    mpg.setTemplateEngine(new FreemarkerTemplateEngine());

    // 全局配置
    GlobalConfig gc = new GlobalConfig();
    gc.setAuthor("yingjie.lu");
    gc.setOutputDir("/Users/luyingjie/code/mybatis-plus-demo/src/main/java");
    gc.setFileOverride(false);// 是否覆盖同名文件，默认是false
    gc.setActiveRecord(true);// 不需要ActiveRecord特性的请改为false
    gc.setEnableCache(false);// XML 二级缓存
    gc.setBaseResultMap(true);// XML ResultMap
    gc.setBaseColumnList(false);// XML columList
    /* 自定义文件命名，注意 %s 会自动填充表实体属性！ */
    // gc.setMapperName("%sDao");
    // gc.setXmlName("%sDao");
    // gc.setServiceName("MP%sService");
    // gc.setServiceImplName("%sServiceDiy");
    // gc.setControllerName("%sAction");
    mpg.setGlobalConfig(gc);

    // 数据源配置
    DataSourceConfig dsc = new DataSourceConfig();
    dsc.setDbType(DbType.MYSQL);
    dsc.setTypeConvert(new MySqlTypeConvert() {
      @Override
      public IColumnType processTypeConvert(GlobalConfig globalConfig, String fieldType) {
        System.out.println("转换类型：" + fieldType);
        // 注意！！processTypeConvert 存在默认类型转换，如果不是你要的效果请自定义返回、非如下直接返回。
        return super.processTypeConvert(globalConfig, fieldType);
      }
    });
    dsc.setDriverName("com.mysql.cj.jdbc.Driver");
    dsc.setUsername("root");
    dsc.setPassword("12345678");
    dsc.setUrl("jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8");
    mpg.setDataSource(dsc);

    // 策略配置
    StrategyConfig strategy = new StrategyConfig();
    // strategy.setCapitalMode(true);// 全局大写命名 ORACLE 注意
    //        strategy.setTablePrefix(new String[] { "user_" });// 此处可以修改为您的表前缀
    strategy.setNaming(NamingStrategy.no_change);// 表名生成策略
    strategy.setInclude(new String[] { "user" }); // 需要生成的表
    // strategy.setExclude(new String[]{"test"}); // 排除生成的表
    // 自定义实体父类
    // strategy.setSuperEntityClass("com.baomidou.demo.TestEntity");
    // 自定义实体，公共字段
    // strategy.setSuperEntityColumns(new String[] { "test_id", "age" });
    // 自定义 mapper 父类
    // strategy.setSuperMapperClass("com.baomidou.demo.TestMapper");
    // 自定义 service 父类
    // strategy.setSuperServiceClass("com.baomidou.demo.TestService");
    // 自定义 service 实现类父类
    // strategy.setSuperServiceImplClass("com.baomidou.demo.TestServiceImpl");
    // 自定义 controller 父类
    // strategy.setSuperControllerClass("com.baomidou.demo.TestController");
    // 【实体】是否生成字段常量（默认 false）
    // public static final String ID = "test_id";
    // strategy.setEntityColumnConstant(true);
    // 【实体】是否为构建者模型（默认 false）
    // public User setName(String name) {this.name = name; return this;}
    // strategy.setEntityBuilderModel(true);
    mpg.setStrategy(strategy);

    // 包配置
    PackageConfig pc = new PackageConfig();
    pc.setParent("com.example.mybatisplusdemo");
    //        pc.setModuleName("test");
    mpg.setPackageInfo(pc);

    // 注入自定义配置，可以在 VM 中使用 cfg.abc 【可无】
    //        InjectionConfig cfg = new InjectionConfig() {
    //            @Override
    //            public void initMap() {
    //                Map<String, Object> map = new HashMap<String, Object>();
    //                map.put("abc", this.getConfig().getGlobalConfig().getAuthor() + "-mp");
    //                this.setMap(map);
    //            }
    //        };
    //
    //        // 自定义 xxList.jsp 生成
    //        List<FileOutConfig> focList = new ArrayList<>();
    //        focList.add(new FileOutConfig("/template/list.jsp.vm") {
    //            @Override
    //            public String outputFile(TableInfo tableInfo) {
    //                // 自定义输入文件名称
    //                return "D://my_" + tableInfo.getEntityName() + ".jsp";
    //            }
    //        });
    //        cfg.setFileOutConfigList(focList);
    //        mpg.setCfg(cfg);
    //
    //        // 调整 xml 生成目录演示
    //        focList.add(new FileOutConfig("/templates/mapper.xml.vm") {
    //            @Override
    //            public String outputFile(TableInfo tableInfo) {
    //                return "/develop/code/xml/" + tableInfo.getEntityName() + ".xml";
    //            }
    //        });
    //        cfg.setFileOutConfigList(focList);
    //        mpg.setCfg(cfg);
    //
    //        // 关闭默认 xml 生成，调整生成 至 根目录
    //        TemplateConfig tc = new TemplateConfig();
    //        tc.setXml(null);
    //        mpg.setTemplate(tc);

    // 自定义模板配置，可以 copy 源码 mybatis-plus/src/main/resources/templates 下面内容修改，
    // 放置自己项目的 src/main/resources/templates 目录下, 默认名称一下可以不配置，也可以自定义模板名称
    // TemplateConfig tc = new TemplateConfig();
    // tc.setController("...");
    // tc.setEntity("...");
    // tc.setMapper("...");
    // tc.setXml("...");
    // tc.setService("...");
    // tc.setServiceImpl("...");
    // 如上任何一个模块如果设置 空 OR Null 将不生成该模块。
    // mpg.setTemplate(tc);

    // 执行生成
    mpg.execute();

    // 打印注入设置【可无】
    //        System.err.println(mpg.getCfg().getMap().get("abc"));
    }
 
}
```



### CRUD接口

底层service的crud接口：[https://mybatis.plus/guide/crud-interface.html#service-crud-%E6%8E%A5%E5%8F%A3](https://mybatis.plus/guide/crud-interface.html#service-crud-接口)

BaseMapper的接口：

#### Insert

```java
// 插入一条记录
int insert(T entity);
```

如果需要返回自动生成的主键id，需要在实体类中的id添加上指定注解，例如：

```java
@Data
public class Blog {
    @TableId(type = IdType.AUTO) //id策略设置为自动生成
    Integer id;
  	...
}
```



#### Delete

```java
// 根据 entity 条件，删除记录
int delete(@Param(Constants.WRAPPER) Wrapper<T> wrapper);
// 删除（根据ID 批量删除）
int deleteBatchIds(@Param(Constants.COLLECTION) Collection<? extends Serializable> idList);
// 根据 ID 删除
int deleteById(Serializable id);
// 根据 columnMap 条件，删除记录
int deleteByMap(@Param(Constants.COLUMN_MAP) Map<String, Object> columnMap);
```

####  Update

```java
// 根据 whereEntity 条件，更新记录
int update(@Param(Constants.ENTITY) T entity, @Param(Constants.WRAPPER) Wrapper<T> updateWrapper);
// 根据 ID 修改
int updateById(@Param(Constants.ENTITY) T entity);
```

#### Select

```java
// 根据 ID 查询
T selectById(Serializable id);
// 根据 entity 条件，查询一条记录
T selectOne(@Param(Constants.WRAPPER) Wrapper<T> queryWrapper);

// 查询（根据ID 批量查询）
List<T> selectBatchIds(@Param(Constants.COLLECTION) Collection<? extends Serializable> idList);
// 根据 entity 条件，查询全部记录
List<T> selectList(@Param(Constants.WRAPPER) Wrapper<T> queryWrapper);
// 查询（根据 columnMap 条件）
List<T> selectByMap(@Param(Constants.COLUMN_MAP) Map<String, Object> columnMap);
// 根据 Wrapper 条件，查询全部记录
List<Map<String, Object>> selectMaps(@Param(Constants.WRAPPER) Wrapper<T> queryWrapper);
// 根据 Wrapper 条件，查询全部记录。注意： 只返回第一个字段的值
List<Object> selectObjs(@Param(Constants.WRAPPER) Wrapper<T> queryWrapper);

// 根据 entity 条件，查询全部记录（并翻页）
IPage<T> selectPage(IPage<T> page, @Param(Constants.WRAPPER) Wrapper<T> queryWrapper);
// 根据 Wrapper 条件，查询全部记录（并翻页）
IPage<Map<String, Object>> selectMapsPage(IPage<T> page, @Param(Constants.WRAPPER) Wrapper<T> queryWrapper);
// 根据 Wrapper 条件，查询总记录数
Integer selectCount(@Param(Constants.WRAPPER) Wrapper<T> queryWrapper);
```

### 条件构造器

https://mybatis.plus/guide/wrapper.html#abstractwrapper

：全部相等
[eq](https://mybatis.plus/guide/wrapper.html#eq)：相等
[ne](https://mybatis.plus/guide/wrapper.html#ne)：不等于
[gt](https://mybatis.plus/guide/wrapper.html#gt)：大于
[ge](https://mybatis.plus/guide/wrapper.html#ge)：大于等于
[lt](https://mybatis.plus/guide/wrapper.html#lt)：小于
[le](https://mybatis.plus/guide/wrapper.html#le)：小于等于
[between](https://mybatis.plus/guide/wrapper.html#between)：两者之间
[notBetween](https://mybatis.plus/guide/wrapper.html#notbetween)：两者之外
[like](https://mybatis.plus/guide/wrapper.html#like)：%XXX%
[notLike](https://mybatis.plus/guide/wrapper.html#notlike)
[likeLeft](https://mybatis.plus/guide/wrapper.html#likeleft)：%XXX
[likeRight](https://mybatis.plus/guide/wrapper.html#likeright)：XXX%
[isNull](https://mybatis.plus/guide/wrapper.html#isnull)：为空
[isNotNull](https://mybatis.plus/guide/wrapper.html#isnotnull)：不为空
[in](https://mybatis.plus/guide/wrapper.html#in)：包含在集合中
[notIn](https://mybatis.plus/guide/wrapper.html#notin)：不包含在集合中
[inSql](https://mybatis.plus/guide/wrapper.html#insql)：字段 IN ( sql语句 )

> `inSql("age", "1,2,3,4,5,6") `  --->  `age in (1,2,3,4,5,6)`
>
> `inSql("id", "select id from table where id < 3")` ---> `id in (select id from table where id < 3)`

：与inSql相反
[groupBy](https://mybatis.plus/guide/wrapper.html#groupby)：根据字段分组

> 例: `groupBy("id", "name")`--->`group by id,name`

[orderByAsc](https://mybatis.plus/guide/wrapper.html#orderbyasc)：升序

> 例: `orderByAsc("id", "name")`--->`order by id ASC,name ASC`

：降序
[orderBy](https://mybatis.plus/guide/wrapper.html#orderby)

> 例: `orderBy(true, true, "id", "name")`--->`order by id ASC,name AS`

[having](https://mybatis.plus/guide/wrapper.html#having)

> 例: `having("sum(age) > 10")`--->`having sum(age) > 10`
>
> 例: `having("sum(age) > {0}", 11)`--->`having sum(age) > 11`

[or](https://mybatis.plus/guide/wrapper.html#or)

> 默认方法的连续调用都是and连接
>
> 例: `eq("id",1).or().eq("name","老王")`--->`id = 1 or name = '老王'`

：用于and嵌套
[nested](https://mybatis.plus/guide/wrapper.html#nested)：正常嵌套 不带 AND 或者 OR
[apply](https://mybatis.plus/guide/wrapper.html#apply)：拼接sql

> 例: `apply("id = 1")`--->`id = 1`

[last](https://mybatis.plus/guide/wrapper.html#last):无视优化规则直接拼接到 sql 的最后
[exists](https://mybatis.plus/guide/wrapper.html#exists)：拼接 EXISTS ( sql语句 )
[notExists](https://mybatis.plus/guide/wrapper.html#notexists)：与exists相反

#### QueryWrapper

select：设置查询字段

```java
select(String... sqlSelect)
select(Predicate<TableFieldInfo> predicate)
select(Class<T> entityClass, Predicate<TableFieldInfo> predicate)
```

例: `select("id", "name", "age")`

例: `select(i -> i.getProperty().startsWith("test`

#### UpdateWrapper

set：设置字段值

```java
set(String column, Object val)
set(boolean condition, String column, Object val)
```

例: `set("name", "老李头")`

例: `set("name", "")`--->数据库字段值变为**空字符串**

例: `set("name", null)`--->数据库字段值变为`null`

### 自动义sql

#### 注解方式

```java
public interface UserMapper extends BaseMapper<User> {
    @Select("select * from user where name = #{name}")
    public List<User> selectByUserName(String name);

}
```

使用：

```java
List<User> users = userMapper.selectByUserName("Jack");
```

#### xml方式

创建xml文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.example.mybatisplusdemo.mapper.UserMapper">
    <select id="selectByAge" resultType="com.example.mybatisplusdemo.model.User">
        select * from user where age = #{age}
    </select>
</mapper>
```

在配置文件中添加xml的路径：

```yaml
mybatis-plus:
  mapper-locations: classpath:mapper/*.xml
```

在mapper接口中添加指定的方法：

```java
public interface UserMapper extends BaseMapper<User> {
    List<User> selectByAge(int age);
}
```

调用：

```java
List<User> list = userMapper.selectByAge(24);
for (User user1 : list) {
  System.out.println(user1);
}
```

### 分页插件

> 必须要开启分页插件后，才能使用分页功能

**开启分页功能**，只需要在Spring中配置一个分页拦截器即可，代码如下：

```java
@Bean
public PaginationInterceptor paginationInterceptor() {
  PaginationInterceptor paginationInterceptor = new PaginationInterceptor();
  // 设置请求的页面大于最大页后操作， true调回到首页，false 继续请求  默认false
  // paginationInterceptor.setOverflow(false);
  // 设置最大单页限制数量，默认 500 条，-1 不受限制
  // paginationInterceptor.setLimit(500);
  // 开启 count 的 join 优化,只针对部分 left join
  paginationInterceptor.setCountSqlParser(new JsqlParserCountOptimize(true));
  return paginationInterceptor;
}
```

---

使用默认提供的接口分页：

```java
Page<User> userPage = userMapper.selectPage(new Page<>(2, 2), new QueryWrapper<>());//分页从1开始
List<User> records = userPage.getRecords();
for (User record : records) {
  System.out.println(record);
}
```

---

如果需要在自定义的接口中进行分页操作，只需要在mapper接口中添加一个Page参数即可，就能够帮你自动分页

```xml
public interface UserMapper extends BaseMapper<User> {
    List<User> selectByAge(Page page, int age);
}
```

使用：

```java
List<User> list = userMapper.selectByAge(new Page<>(2, 2),24);
for (User user1 : list) {
  System.out.println(user1);
}
```

> 如果想要在通过注解的方式自动义分页，原理也是一样的，直接在方法中添加Page参数即可

## 插件扩展

### sql分析打印

https://mp.baomidou.com/guide/p6spy.html

```properties
# 自定义日志打印
logMessageFormat=com.baomidou.mybatisplus.extension.p6spy.P6SpyLogger
#日志输出到控制台
appender=com.baomidou.mybatisplus.extension.p6spy.StdoutLogger
# 使用日志系统记录 sql
#appender=com.p6spy.engine.spy.appender.Slf4JLogger
# 是否开启慢SQL记录
outagedetection=true
# 慢SQL记录标准 2 秒
outagedetectioninterval=2
```

### 性能分析插件

https://mp.baomidou.com/guide/performance-analysis-plugin.html

## 简单搭建Demo记录

首先，导入与Springboot整合的依赖：

```xml
<dependency>
  <groupId>com.baomidou</groupId>
  <artifactId>mybatis-plus-boot-starter</artifactId>
  <version>3.3.2</version>
</dependency>
<!--mysql驱动-->
<dependency>
  <groupId>mysql</groupId>
  <artifactId>mysql-connector-java</artifactId>
  <version>8.0.15</version>
</dependency>
```

创建实体类User：

```java
@Accessors(chain = true)
@Data
public class User {
  	@TableId(type = IdType.AUTO) //id策略设置为自动生成
    private int id;
    private String name;
    private Integer age;
    private String email;
}
```

创建Mapper：

```java
public interface UserMapper extends BaseMapper<User> {

    @Select("select * from user where name = #{name}")
    List<User> selectByUserName(String name);

    List<User> selectByAge(Page page, int age);

}
```

开启分页功能：

```java
@SpringBootApplication
@MapperScan("com.example.mybatisplusdemo.mapper") //开启mapper扫描
public class MybatisPlusDemoApplication {

  public static void main(String[] args) {
    SpringApplication.run(MybatisPlusDemoApplication.class, args);
  }

  //开启分页功能
  @Bean
  public PaginationInterceptor paginationInterceptor() {
    PaginationInterceptor paginationInterceptor = new PaginationInterceptor();
    // 设置请求的页面大于最大页后操作， true调回到首页，false 继续请求  默认false
    // paginationInterceptor.setOverflow(false);
    // 设置最大单页限制数量，默认 500 条，-1 不受限制
    // paginationInterceptor.setLimit(500);
    // 开启 count 的 join 优化,只针对部分 left join
    paginationInterceptor.setCountSqlParser(new JsqlParserCountOptimize(true));
    return paginationInterceptor;
  }
}
```

创建UserMapper.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.example.mybatisplusdemo.mapper.UserMapper">
  <select id="selectByAge" resultType="com.example.mybatisplusdemo.model.User">
    select * from user where age != #{age}
  </select>
</mapper>
```

创建配置文件：

```yaml
# DataSource Config
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/test
    username: root
    password: 12345678

mybatis-plus:
  mapper-locations: classpath:mapper/*.xml
```

创建测试类：

```java
@RunWith(SpringRunner.class)
@SpringBootTest
class MybatisPlusDemoApplicationTests {

    @Autowired
    private UserMapper userMapper;

    @Test
    void contextLoads() {
        System.out.println(("----- selectAll method test ------"));
        List<User> userList = userMapper.selectList(null);
//        Assert.assertEquals(5, userList.size());
        userList.forEach(System.out::println);

        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("id",1);
        User user = userMapper.selectOne(queryWrapper);
        System.out.println(user);

//        userMapper.insert(new User());

        List<User> users = userMapper.selectByUserName("Jack");
        for (User user1 : users) {
            System.out.println(user1);
        }


        List<User> list = userMapper.selectByAge(new Page<>(2, 2),-1);
        for (User user1 : list) {
            System.out.println(user1);
        }

        Page<User> userPage = userMapper.selectPage(new Page<>(2, 2), new QueryWrapper<>());//分页从1开始
        List<User> records = userPage.getRecords();
        for (User record : records) {
            System.out.println(record);
        }

    }

}
```











