http://mybatis.org/spring/zh/index.html

## 历史原因

在发布mybatis3.0之前，spring3.0就已经发布了，所以spring并没有整合mybatis3.0，所以是大家合力完成的mybatis-spring整合

## 如何与Spring整合

添加jar包

```xml
<dependency>
  <groupId>org.mybatis</groupId>
  <artifactId>mybatis-spring</artifactId>
  <version>2.0.5</version>
</dependency>
```

与spring整合就必须要在spring中存在两个类： `SqlSessionFactory`  和数据映射器类(即通过xml生成的mapper)

### 配置SqlSessionFactory

我们可以通过 SqlSessionFactoryBean 类来创建 SqlSessionFactory，通过以下方式配置即可

```java
@Bean
public SqlSessionFactory sqlSessionFactory() throws Exception {
  SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
  factoryBean.setDataSource(dataSource());
  return factoryBean.getObject();
}
```

### 配置mapper

首先定义一个接口

```java
public interface UserMapper {
  @Select("SELECT * FROM users WHERE id = #{userId}")
  User getUser(@Param("userId") String userId);
} 
```

我们可以通过 `MapperFactoryBean`  类来生成对应的mapper，总共有两种方式：

1. xml的方式

   ```xml
   <bean id="userMapper" class="org.mybatis.spring.mapper.MapperFactoryBean">
       <property name="mapperInterface" value="org.mybatis.spring.sample.mapper.UserMapper" />
       <property name="sqlSessionFactory" ref="sqlSessionFactory" />
   </bean>
   ```

   指定对应的接口 和 sqlSessionFactory 即可

2. 注解的方式

   ```java
   @Bean
   public UserMapper userMapper() throws Exception {
       SqlSessionTemplate sqlSessionTemplate = new SqlSessionTemplate(sqlSessionFactory());
       return sqlSessionTemplate.getMapper(UserMapper.class);
   }
   ```

   通过SqlSessionTemplate来获取对应的mapper

---

### 使用

```java
@Service
public class FooServiceImpl implements FooService {

  @Autowired
  private final UserMapper userMapper;

  public User doSomeBusinessStuff(String userId) {
    return userMapper.getUser(userId);
  }
}
```

## SqlSessionFactoryBean

在基础的Mybatis中，是通过SqlSessionFactoryBuilder根据xml配置文件来创建 `SqlSessionFactory`  的

而在mybatis-spring中，则使用SqlSessionFactoryBean来创建

---

SqlSessionFactoryBean实现了 `FactoryBean`  接口，那么在spring中创建的bean就并不是

SqlSessionFactoryBean本身，而是实现了`FactoryBean`  接口中的getObject()方法的返回值， 这种情况下，Spring 将会在应用启动时为你创建 `SqlSessionFactory`，并使用 `sqlSessionFactory` 这个名字存储起来。 

> 参考spring官网：https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#beans-factory-extension-factorybean

所以，