[TOC]

# 简介

Mybatis-Spring会帮助你将Mybatis代码无缝的整合到Spring中; 

作用:

1. 它将允许Mybatis参与到Spring的事务管理之中
2. 创建映射器mapper和SqlSession并注入到bean中
3. 以及将Mybatis的异常转换为Spring的DataAccessException; 

最终,可以做到应用代码不依赖于Mybaits,Spring和Mybatis-Spring;

# 快速入门

## 使用xml配置

要和Spring一起使用Mybaits,需要在Spring上下文定义至少两个东西: 

1. SqlSessionFactory
2. 至少一个数据映射器类(mapper)

步骤:

1. 添加pom依赖

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>
   
       <groupId>com.lyj</groupId>
       <artifactId>Mybatis-Spring-Test</artifactId>
       <version>1.0-SNAPSHOT</version>
   
       <dependencies>
           <!--spring相关依赖-->
           <dependency>
               <groupId>org.springframework</groupId>
               <artifactId>spring-context</artifactId>
               <version>5.2.0.RELEASE</version>
           </dependency>
   
           <dependency>
               <groupId>org.mybatis</groupId>
               <artifactId>mybatis</artifactId>
               <version>3.5.1</version>
           </dependency>
   
           <dependency>
               <groupId>org.mybatis</groupId>
               <artifactId>mybatis-spring</artifactId>
               <version>2.0.1</version>
           </dependency>
   
           <dependency>
               <groupId>mysql</groupId>
               <artifactId>mysql-connector-java</artifactId>
               <version>5.1.32</version>
           </dependency>
   
           <dependency>
               <groupId>org.springframework</groupId>
               <artifactId>spring-jdbc</artifactId>
               <version>5.1.8.RELEASE</version>
           </dependency>
   
       </dependencies>
   </project>
   ```

2. 创建实体类User

   ```java
   public class User {
       int id;
       String name;
       int age;
   }
   ```

3. 创建映射器接口

   ```java
   public interface UserMapper {
       @Update("update user set name=#{name} where id = #{id}")
       int updateUser(@Param("name") String name, @Param("id") int id);
   }
   ```

4. 创建UserService

   ```java
   public class UserService {
   
       private UserMapper userMapper;
   
       public void updateUser(String name,int id) throws Exception {
           int i = userMapper.updateUser(name, id);
           if(i==1){
               throw new Exception("111");
           }
       }
   
       public void setUserMapper(UserMapper userMapper) {
           this.userMapper = userMapper;
       }
   }
   ```

5. 创建spring.xml

   1. 在Mybaits-Spring中,可使用`SqlSessionFactoryBean`来创建`SqlSessionFactory`; 要配置这个`SqlSessionFactoryBean`,需要在Spring的xml配置文件中配置以下代码:

      ```xml
      <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <property name="dataSource" ref="dataSource" />
      </bean>
      ```

   2. 通过 `MapperFactoryBean` 将接口加入到 Spring 中

      ```xml
      <bean id="userMapper" class="org.mybatis.spring.mapper.MapperFactoryBean">
          <property name="mapperInterface" value="org.mybatis.spring.sample.mapper.UserMapper" />
          <property name="sqlSessionFactory" ref="sqlSessionFactory" />
      </bean>
      ```

      > 注意:  所指定的映射器类**必须**是一个接口，而不是具体的实现类 
      >
      > 在这个示例中，通过注解来指定 SQL 语句，但是也可以使用 MyBatis 映射器的 XML 配置文件。 
      >
      > 配置好之后，你就可以像 Spring 中普通的 bean 注入方法那样，将映射器注入到你的业务或服务对象中。`MapperFactoryBean` 将会负责 `SqlSession` 的创建和关闭。如果使用了 Spring 的事务功能，那么当事务完成时，session 将会被提交或回滚。最终任何异常都会被转换成 Spring 的 `DataAccessException` 异常 

   ---

   完成spring.xml代码如下:

   ```xml
   <?xml version="1.0" encoding="utf-8" ?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:context="http://www.springframework.org/schema/context"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tx="http://www.springframework.org/schema/tx"
          xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-4.0.xsd
   http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx.xsd">
   
   
       <!--注入sqlSessionFactory-->
       <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
           <property name="dataSource" ref="dataSource" />
       </bean>
   
       <!--配置数据源-->
       <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
           <property name="driverClassName" value="com.mysql.jdbc.Driver"></property>
           <property name="url" value="jdbc:mysql://127.0.0.1:3306/test"></property>
           <property name="username" value="root"></property>
           <property name="password" value="123456"></property>
       </bean>
   
       <!--注入mapper-->
       <bean id="userMapper" class="org.mybatis.spring.mapper.MapperFactoryBean">
           <property name="mapperInterface" value="UserMapper" />
           <property name="sqlSessionFactory" ref="sqlSessionFactory" />
       </bean>
   
       <!--注入service-->
       <bean name="userService" class="UserService">
           <property name="userMapper" ref="userMapper"></property>
       </bean>
   
   </beans>
   ```

6. 测试类

   ```java
   public class Test {
       public static void main(String[] args) throws Exception {
           ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
           UserService userService = context.getBean(UserService.class);
           userService.updateUser("111",1);
       }
   }
   ```

## 使用注解配置

要和Spring一起使用Mybaits,需要在Spring上下文定义至少两个东西: 

1. SqlSessionFactory
2. 至少一个数据映射器类(mapper)

步骤:

1. 添加pom依赖

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>
   
       <groupId>com.lyj</groupId>
       <artifactId>Mybatis-Spring-Test</artifactId>
       <version>1.0-SNAPSHOT</version>
   
       <dependencies>
           <!--spring相关依赖-->
           <dependency>
               <groupId>org.springframework</groupId>
               <artifactId>spring-context</artifactId>
               <version>5.2.0.RELEASE</version>
           </dependency>
   
           <dependency>
               <groupId>org.mybatis</groupId>
               <artifactId>mybatis</artifactId>
               <version>3.5.1</version>
           </dependency>
   
           <dependency>
               <groupId>org.mybatis</groupId>
               <artifactId>mybatis-spring</artifactId>
               <version>2.0.1</version>
           </dependency>
   
           <dependency>
               <groupId>mysql</groupId>
               <artifactId>mysql-connector-java</artifactId>
               <version>5.1.32</version>
           </dependency>
   
           <dependency>
               <groupId>org.springframework</groupId>
               <artifactId>spring-jdbc</artifactId>
               <version>5.1.8.RELEASE</version>
           </dependency>
   
       </dependencies>
   </project>
   ```

2. 创建实体类User

   ```java
   public class User {
       int id;
       String name;
       int age;
   }
   ```

3. 创建映射器接口

   ```java
   public interface UserMapper {
       @Update("update user set name=#{name} where id = #{id}")
       int updateUser(@Param("name") String name, @Param("id") int id);
   }
   ```

4. 创建UserService

   ```java
   @Service
   public class UserService {
   
       @Autowired
       private UserMapper userMapper;
   
       public void updateUser(String name,int id) throws Exception {
           int i = userMapper.updateUser(name, id);
           if(i==1){
               throw new Exception("111");
           }
       }
   }
   ```

5. 创建AppConfig配置类

   ```java
   @Configuration
   @ComponentScan
   public class AppConfig {
       // 数据源
       @Bean
       public DataSource dataSource(){
           DriverManagerDataSource dataSource = new DriverManagerDataSource();
           dataSource.setDriverClassName("com.mysql.jdbc.Driver");
           dataSource.setUrl("jdbc:mysql://127.0.0.1:3306/test");
           dataSource.setUsername("root");
           dataSource.setPassword("123456");
           return dataSource;
       }
   
       //配置SqlSessionFactory
       @Bean
       public SqlSessionFactory sqlSessionFactory() throws Exception {
           SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
           factoryBean.setDataSource(dataSource());
           return factoryBean.getObject();
       }
   
       //mapper
       @Bean
       public MapperFactoryBean<UserMapper> userMapper() throws Exception {
           MapperFactoryBean<UserMapper> factoryBean = new MapperFactoryBean<UserMapper>(UserMapper.class);
           factoryBean.setSqlSessionFactory(sqlSessionFactory());
           return factoryBean;
       }
   }
   ```

6. 测试类

   ```java
   public class Test {
       public static void main(String[] args) throws Exception {
           AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
           UserService userService = (UserService) context.getBean("userService");
           userService.updateUser("3333",1);
       }
   }
   ```

# 原理

## SqlSessionFactoryBean

我们使用`SqlSessionFactoryBean`来创建`sqlSessionFactory`注入到IOC容器中

`SqlSessionFactoryBean`的属性:

1. `DataSource` 

   必须传入

   在`sqlSessionFactory`中需要使用到该属性,配置如下:

   ```xml
   <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
       <property name="dataSource" ref="dataSource" />
   </bean>
   ```

2. `configLocation `

   不是必须传入

   该属性用来执行Mybatis的xml配置文件路径,它在需要修改Mybatis的基础配置时非常的有用,你可以执行你自定义的Mybatis配置文件来覆盖默认的配置,示例如下

   ```xml
   <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
       <property name="configLocation" value="classpath:mybatis-config.xml"/>
   </bean>
   ```

3.  `mapperLocations`  

   不是必须传入

   该属性可以指定映射器XML文件的位置,指定后加载指定目录的所有mapper.xml文件

   Mybatis首先会在映射器接口类对应的路径下找映射器XML文件,如果没找到,则需要进行配置,有两种方式:

   1. 手动在Mybatis的xml配置文件中的`<mappers>`中执行xml文件的路径

   2. 使用该属性指定映射器xml文件的目录,它会加载指定目录下的所有mapper.xml文件,具体可以这样配置:

      ```xml
      <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <property name="mapperLocations" value="classpath*:sample/config/mappers/**/*.xml" />
      </bean>
      ```

      > 这会从类路径下加载所有在` sample.config.mappers ` 包和它的子包中的 MyBatis 映射器 XML 配置文件。 

4. `transactionFactoryClass`

   不是必须传入

   当你需要事务时,可以对该属性进行设置,具体参考事务章节的内容

## 事务

Mybatis-Spring借助了Spring中的 `DataSourceTransactionManager`来实现事务管理

一旦配置好了Spring的事务管理器,你就可以使用 @Transactional 注解或 AOP来实现事务 

在事务期间,一个单独的`SqlSession`对象将会被创建和使用

当事务完成时,这个`SqlSession`会以合适的方法提交或回滚

### 配置

1. 要开启Spring的事务,需要在Spring的配置文件中创建一个 `DataSourceTransactionManager`  对象:

   ```xml
   <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
     <constructor-arg ref="dataSource" />
   </bean>
   ```

   > 这里传入的datasource必须和用来创建`SqlSessionFactoryBean`的是同一个数据源,否则事务管理器就无法生效

2. 在Spring中指定一个 `JtaTransactionManager`对象或由容器指定的一个子类作为事务管理器

   可以参考以下几种方式:

   1. 使用Spring的事务命名空间(简单)

   2. 使用  `JtaTransactionManagerFactoryBean`

      ```xml
      <tx:jta-transaction-manager />
      ```

   > 在这个配置中,Spring会自动使用任何一个存在的容器事务管理器,并注入一个SqlSession

### 编程式事务管理

 https://mybatis.org/spring/zh/transactions.html#programmatic 

## SqlSession

在Mybatis中,可以通过 `SqlSessionFactory` 来创建 `SqlSession` ,然后你可以通过`SqlSession` 来执行映射了的sql语句,提交或回滚,在关闭`SqlSession` 

在使用 MyBatis-Spring 之后 ,我们不再需要直接使用`SqlSessionFactory` ,因为我们的JavaBean中可以被MyBatis-Spring注入一个线程安全的SqlSession,它能基于Spring的事务配置来自动提交,回滚和关闭SqlSession











# SqlSessionFactoryBean

在基础的Mybaits用法中,是通过SqlSessionFactoryBuidler来创建SqlSessionFactory的,而在Mybatis-Spring中,则使用SqlSessionFactoryBean来创建

## 设置

要创建sqlSessionFactory,将下面的代码放到Spring的xml配置文件中:

```xml
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
    <property name="dataSource" ref="dataSource" />
</bean>
```

需要注意的是`SqlSessionFactoryBean`实现了Spring的 `FactoryBean` 接口,这意味着由Spring最终创建的bean并不是 `SqlSessionFactoryBean`  本身,而是工厂类 `SqlSessionFactoryBean`的 `getObject()` 方法的返回结果  ; 这种情况下,Spring将会在应用启动时为你创建 `SqlSessionFactory`,并使用`SqlSessionFactory`这个名字存储起来

等效的Java代码如下:

```java
@Bean
public SqlSessionFactory sqlSessionFactory() {
  SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
  factoryBean.setDataSource(dataSource());
  return factoryBean.getObject();
}
```

通常,在Mybatis-Spring中,你不需要直接使用`SqlSessionFactoryBean`或对应的`SqlSessionFactory`; 相反,session的工厂bean将会被注入到`MapperFactoryBean`或其他继承于`SqlSessionDaoSupport`的DAO(Data Access Object,数据访问对象)中

## 属性

`SqlSessionFactory` 有一个唯一的必要属性：用于 JDBC 的 `DataSource`。这可以是任意的 `DataSource` 对象，它的配置方法和其它 Spring 数据库连接是一样的 

一个常用的属性是`configLocation`,它用来指定Mybatis的xml配置文件路径; 它在需要修改Mybatis的基础配置非常有用; 通常,基础配置指的是`<setings>`或 ` <typeAliases> ` 元素 

需要注意的是,这个配置文件并不需要是一个完整的Mybatis配置; 确切的说,任何环境配置(`<environments>`),数据源(`<DataSource>`)和Mybatis的事务管理器(`<transactionManager>`)都会被忽略;  `SqlSessionFactoryBean`  会创建它自耦的Mybatis环境配置(` Environment `),并按照要求设置自定义环境的值

如果Mybatis在映射器类对应的路径下找不到与之相应的映射器xml文件,那么也需要配置文件; 这是有两种解决方法:

1. 手动在Mybatis的xml配置文件中`<mapper>`部分中指定xml文件的类路径
2. 设置工厂bean的`mapperLocations`属性

 `mapperLocations`  属性接受多个资源位置,这个属性可以用来指定Mybatis的映射器xml配置文件的位置; 属性的值是一个Ant风格的字符串,可以指定加载一个目录中的所有文件,或者从一个目录开始递归搜索所有目录,比如:

```xml
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
    <property name="dataSource" ref="dataSource" />
    <property name="mapperLocations" value="classpath*:sample/config/mappers/**/*.xml" />
</bean>
```

这会从类路径下加载所有在 sample.config.mappers 包和它的子包中的Mybatis映射器xml配置文件

在容器管理事务的时候,你可能需要的一个属性是 `transactionFactoryClass `;这个可以参考事务的那一章节

## 多数据库

如果你使用了多个数据库,那么需要设置 `databaseIdProvider` 属性： 

```xml
<bean id="databaseIdProvider" class="org.apache.ibatis.mapping.VendorDatabaseIdProvider">
    <property name="properties">
        <props>
            <prop key="SQL Server">sqlserver</prop>
            <prop key="DB2">db2</prop>
            <prop key="Oracle">oracle</prop>
            <prop key="MySQL">mysql</prop>
        </props>
    </property>
</bean>

<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
    <property name="dataSource" ref="dataSource" />
    <property name="mapperLocations" value="classpath*:sample/config/mappers/**/*.xml" />
    <property name="databaseIdProvider" ref="databaseIdProvider"/>
</bean>
```

> 自 1.3.0 版本开始，新增的 `configuration` 属性能够在没有对应的 MyBatis XML 配置文件的情况下，直接设置 `Configuration` 实例 ,  例如： 
>
> ```xml
> <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
>     <property name="dataSource" ref="dataSource" />
>     <property name="configuration">
>         <bean class="org.apache.ibatis.session.Configuration">
>             <property name="mapUnderscoreToCamelCase" value="true"/>
>         </bean>
>     </property>
> </bean>
> ```

# 事务

一个使用Mybatis-Spring的其中一个主要原因是它幽魂需Mybatis参与到Spring的事务管理中,而不是给Mybatis创建一个新的专用事务管理器,Mybatis-Spring借助了Spring中的` DataSourceTransactionManager  `来实现事务管理

一旦配置好Spring的事务管理器,你就可以在Spring中按照你平时的方式来配置事务,并且支持`@Transactional`注解和AOP风格的配置; **在事务处理期间,一个单独的 `SqlSession` 对象将会被创建和使用。当事务完成时，这个 session 会以合适的方式提交或回滚。** 

事务配置好后,Mybatis-Spring将会透明的管理事务,这样在你的DAO类中就不需要额外的代码了;

## 标准配置

要开启Spring的事务处理功能,在Spring的配置文件中创建一个 `DataSourceTransactionManager`  对象:

```xml
<bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
    <constructor-arg ref="dataSource" />
</bean>
```

或者使用Java代码配置:

```java
@Bean
public DataSourceTransactionManager transactionManager() {
  return new DataSourceTransactionManager(dataSource());
}
```

传入的DataSource可以是任何能够与Spring兼容的JDBC的 `DataSource` ; 

> 注意：为事务管理器指定的 `DataSource` **必须**和用来创建 `SqlSessionFactoryBean` 的是同一个数据源，否则事务管理器就无法工作了。 

## 交由容器管理事务

如果你正使用一个  JEE 容器而且想让 Spring 参与到容器管理事务的过程中，那么 Spring 应该被设置为使用 JtaTransactionManager 或由容器指定的一个子类作为事务管理器。最简单的方式是使用 Spring 的事务命名空间或使用 `JtaTransactionManagerFactoryBean`： 

```xml
<tx:jta-transaction-manager />
```

或者使用Java代码配置:

```java
@Bean
public JtaTransactionManager transactionManager() {
  return new JtaTransactionManagerFactoryBean().getObject();
}
```

在这个配置中，MyBatis 将会和其它由容器管理事务配置的 Spring 事务资源一样。Spring 会自动使用任何一个存在的容器事务管理器，并注入一个 `SqlSession`。如果没有正在进行的事务，而基于事务配置需要一个新的事务的时候，Spring 会开启一个新的由容器管理的事务。 

> 注意，如果你想使用由容器管理的事务，而**不想**使用 Spring 的事务管理，你就**不能**配置任何的 Spring 事务管理器。并**必须配置** `SqlSessionFactoryBean` 以使用基本的 MyBatis 的 `ManagedTransactionFactory`： 
>
> ```xml
> <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
>     <property name="dataSource" ref="dataSource" />
>     <property name="transactionFactory">
>         <bean class="org.apache.ibatis.transaction.managed.ManagedTransactionFactory" />
>     </property>  
> </bean>
> ```
>
> 或者使用Java代码配置:
>
> ```java
> @Bean
> public SqlSessionFactory sqlSessionFactory() {
>   SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
>   factoryBean.setDataSource(dataSource());
>   factoryBean.setTransactionFactory(new ManagedTransactionFactory());
>   return factoryBean.getObject();
> }
> ```

## 编程事务管理

MyBatis 的 `SqlSession` 提供几个方法来在代码中处理事务。但是当使用 MyBatis-Spring 时，你的 bean 将会注入由 Spring 管理的 `SqlSession` 或映射器。也就是说，Spring 总是为你处理了事务 

你不能在 Spring 管理的 `SqlSession` 上调用 `SqlSession.commit()`，`SqlSession.rollback()` 或 `SqlSession.close()` 方法。如果这样做了，就会抛出 `UnsupportedOperationException` 异常。在使用注入的映射器时，这些方法也不会暴露出来。 

无论 JDBC 连接是否设置为自动提交，调用 `SqlSession` 数据方法或在 Spring 事务之外调用任何在映射器中方法，事务都将会自动被提交 

下面的代码展示了如何使用 `PlatformTransactionManager` 手工管理事务:

```java
TransactionStatus txStatus =
    transactionManager.getTransaction(new DefaultTransactionDefinition());
try {
  userMapper.insertUser(user);
} catch (Exception e) {
  transactionManager.rollback(txStatus);
  throw e;
}
transactionManager.commit(txStatus);
```

# 使用SqlSession

在 MyBatis 中，你可以使用 `SqlSessionFactory` 来创建 `SqlSession`。一旦你获得一个 session 之后，你可以使用它来执行映射了的语句，提交或回滚连接，最后，当不再需要它的时候，你可以关闭 session。 

使用 MyBatis-Spring 之后，你不再需要直接使用 `SqlSessionFactory` 了，因为你的 bean 可以被注入一个线程安全的 `SqlSession`，它能基于 Spring 的事务配置来自动提交、回滚、关闭 session。 

## SqlSessionTemplate

`SqlSessionTemplate` 是 MyBatis-Spring 的核心。作为 `SqlSession` 的一个实现  ，这意味着可以使用它无缝代替你代码中已经在使用的 `SqlSession`。 

`SqlSessionTemplate` 是线程安全的，可以被多个 DAO 或映射器所共享使用。 

当调用 SQL 方法时（包括由 `getMapper()` 方法返回的映射器中的方法），`SqlSessionTemplate` 将会保证使用的 `SqlSession` 与当前 Spring 的事务相关  。此外，它管理 session 的生命周期，包含必要的关闭、提交或回滚操作。另外，它也负责将 MyBatis 的异常翻译成 Spring 中的 `DataAccessExceptions`。 

由于`SqlSessionTemplate` 可以参与到Spring的事务管理中,并且由于它是线程安全的,可以供多个映射器类使用,你应该全部使用`SqlSessionTemplate` 来替换Mybatis默认的 `DefaultSqlSession`  实现; 如果在同一个应用中同时使用这两者可能会引起数据不一致的问题

可以使用  `SqlSessionFactory` 作为构造方法的参数来创建 `SqlSessionTemplate` 对象:

```xml
<bean id="sqlSession" class="org.mybatis.spring.SqlSessionTemplate">
  <constructor-arg index="0" ref="sqlSessionFactory" />
</bean>
```

或使用Java代码配置:

```java
@Bean
public SqlSessionTemplate sqlSession() throws Exception {
  return new SqlSessionTemplate(sqlSessionFactory());
}
```

现在,这个bean就可以直接注入到你的DAO中; 你需要在你的bean中添加一个SqlSession属性,就像下面这样:

```java
public class UserDaoImpl implements UserDao {

    private SqlSession sqlSession;

    public void setSqlSession(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }

    public User getUser(String userId) {
        return sqlSession.selectOne("org.mybatis.spring.sample.mapper.UserMapper.getUser", userId);
    }
}
```

## SqlSessionDaoSupport

`SqlSessionDaoSupport` 是一个抽象的支持类，用来为你提供 `SqlSession`。调用 `getSqlSession()` 方法你会得到一个 `SqlSessionTemplate`，之后可以用于执行 SQL 方法，就像下面这样: 

```java
public class UserDaoImpl extends SqlSessionDaoSupport implements UserDao {
    public User getUser(String userId) {
        return getSqlSession().selectOne("org.mybatis.spring.sample.mapper.UserMapper.getUser", userId);
    }
}
```

在这个类里面，通常更倾向于使用 `MapperFactoryBean`，因为它不需要额外的代码。但是，如果你需要在 DAO 中做其它非 MyBatis 的工作或需要一个非抽象的实现类，那么这个类就很有用了。 

`SqlSessionDaoSupport` 需要通过属性设置一个 `sqlSessionFactory` 或 `SqlSessionTemplate`。如果两个属性都被设置了，那么 `SqlSessionFactory` 将被忽略。

假设类 `UserMapperImpl` 是 `SqlSessionDaoSupport` 的子类，可以编写如下的 Spring 配置来执行设置：

```xml
<bean id="userDao" class="org.mybatis.spring.sample.dao.UserDaoImpl">
  <property name="sqlSessionFactory" ref="sqlSessionFactory" />
</bean>
```

# 注入映射器

与其在数据访问对象(DAO)中手工编写  `SqlSessionDaoSupport` 或 `SqlSessionTemplate` 的代码，还不如让 Mybatis-Spring 为你创建一个线程安全的映射器，这样你就可以直接注入到其它的 bean 中了： 

## 注册映射器

注册映射器的方法根据你的配置方法,即进店的xml配置或新的3.0以上版本的jaav配置( 也就是常说的 @Configuration ) ，而有所不同。 

### XML配置

在你的xml中加入 `MapperFactoryBean`  以便将映射器注册到Spring中,就像下面一样:

```xml
<bean id="userMapper" class="org.mybatis.spring.mapper.MapperFactoryBean">
    <property name="mapperInterface" value="org.mybatis.spring.sample.mapper.UserMapper" />
    <property name="sqlSessionFactory" ref="sqlSessionFactory" />
</bean>
```

如果映射器接口UserMapper在相同的类路径下有对应的Mybatis xml映射器配置文件,将会被 `MapperFactoryBean`  自动解析;不需要在Mybatis配置文件中显示配置映射器,除非映射器配置文件与接口类不在同一个类路径下;

> 注意 `MapperFactoryBean` 需要配置一个 `SqlSessionFactory` 或 `SqlSessionTemplate`。它们可以分别通过 `sqlSessionFactory` 和 `sqlSessionTemplate` 属性来进行设置。如果两者都被设置，`SqlSessionFactory` 将被忽略。由于 `SqlSessionTemplate` 已经设置了一个 session 工厂，`MapperFactoryBean` 将使用那个工厂。 

### Java配置

```java
@Bean
public MapperFactoryBean<UserMapper> userMapper() throws Exception {
    MapperFactoryBean<UserMapper> factoryBean = new MapperFactoryBean<>(UserMapper.class);
    factoryBean.setSqlSessionFactory(sqlSessionFactory());
    return factoryBean;
}
```

## 发现映射器

 不需要一个个地注册你的所有映射器。你可以让 MyBatis-Spring 对类路径进行扫描来发现它们。  有几种办法来发现映射器： 

1. 使用 ` <mybatis:scan/> ` 元素
2. 使用 `@MapperScan` 注解
3. 在经典 Spring XML 配置文件中注册一个 `MapperScannerConfigurer`

>  ` <mybatis:scan/> ` 和 `@MapperScan` 都在 MyBatis-Spring 1.2.0 中被引入。`@MapperScan` 需要你使用 Spring 3.1+。 

### mybatis:scan标签

` <mybatis:scan/> ` 元素会发现映射器，它发现映射器的方法与 Spring 内建的  ` <context:component-scan/> ` 发现 bean 的方法非常类似。 

xml配置如下:

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:mybatis="http://mybatis.org/schema/mybatis-spring"
       xsi:schemaLocation="
                           http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
                           http://mybatis.org/schema/mybatis-spring http://mybatis.org/schema/mybatis-spring.xsd">

    <mybatis:scan base-package="org.mybatis.spring.sample.mapper" />

    <!-- ... -->

</beans>
```

`base-package` 属性允许你设置映射器接口文件的基础包。通过使用逗号或分号分隔，你可以设置多个包。并且会在你所指定的包中递归搜索映射器。 我们需要在指定的类中标注`@Mapper`注解

注意，不需要为 ` <mybatis:scan/> ` 指定 `SqlSessionFactory` 或 `SqlSessionTemplate`，这是因为它将使用能够被自动注入的 `MapperFactoryBean`。但如果你正在使用多个数据源（`DataSource`），自动注入可能不适合你。在这种情况下，你可以使用 `factory-ref` 或 `template-ref` 属性指定你想使用的 bean 名称。

如果没有使用注解显式指定名称，将会使用映射器的首字母小写非全限定类名作为名称 

>  注意:` <context:component-scan/> ` 无法发现并注册映射器。映射器的本质是接口，为了将它们注册到 Spring 中，发现器必须知道如何为找到的每个接口创建一个 `MapperFactoryBean`。 

### @MapperScan

当你正在使用 Spring 的基于 Java 的配置时（也就是 @Configuration），相比于使用 ` <mybatis:scan/> `，你会更喜欢用 `@MapperScan`。 

`@MapperScan` 注解的使用方法如下： 

```java
@Configuration
@MapperScan("org.mybatis.spring.sample.mapper")
public class AppConfig {
    // ...
}
```

这个注解具有与之前见过的 ` <mybatis:scan/> ` 元素一样的工作方式。它也可以通过 `markerInterface` 和 `annotationClass` 属性设置标记接口或注解类。通过配置 `sqlSessionFactory` 和 `sqlSessionTemplate` 属性，你还能指定一个 `SqlSessionFactory` 或 `SqlSessionTemplate`。 

### MapperScannerConfigurer

`MapperScannerConfigurer` 是一个 `BeanDefinitionRegistryPostProcessor`，这样就可以作为一个 bean，包含在经典的 XML 应用上下文中。为了配置 `MapperScannerConfigurer`，使用下面的 Spring 配置： 

```xml
<bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
  <property name="basePackage" value="org.mybatis.spring.sample.mapper" />
</bean>
```

# 使用SpringBoot

 请查看 [MyBatis Spring-boot-starter](http://www.mybatis.org/spring-boot-starter/mybatis-spring-boot-autoconfigure) 子项目获取更多信息。 

# 使用Mybaits API

使用Myabtis-Spring,你可以继续直接使用Mybatis的API; 只需简单的使用 `SqlSessionFactoryBean` 在 Spring 中创建一个 `SqlSessionFactory`，然后按你的方式在代码中使用工厂即可。 

```java
public class UserDaoImpl implements UserDao {
  // SqlSessionFactory 一般会由 SqlSessionDaoSupport 进行设置
  private final SqlSessionFactory sqlSessionFactory;

  public UserDaoImpl(SqlSessionFactory sqlSessionFactory) {
    this.sqlSessionFactory = sqlSessionFactory;
  }

  public User getUser(String userId) {
    // 注意对标准 MyBatis API 的使用 - 手工打开和关闭 session
    try (SqlSession session = sqlSessionFactory.openSession()) {
      return session.selectOne("org.mybatis.spring.sample.mapper.UserMapper.getUser", userId);
    }
  }
}
```

**小心使用**此选项，错误地使用会产生运行时错误，更糟糕地，会产生数据一致性的问题(线程安全问题)。直接使用 API 时，注意以下弊端：

- 它不会参与到 Spring 的事务管理之中。
- 如果 `SqlSession` 使用与 Spring 事务管理器使用的相同 `DataSource`，并且有进行中的事务，代码**将**会抛出异常。
- MyBatis 的 `DefaultSqlSession` 是线程不安全的。如果在 bean 中注入了它，**将**会发生错误。
- 使用 `DefaultSqlSession` 创建的映射器也不是线程安全的。如果你将它们注入到 bean 中，**将**会发生错误。
- 你必须确保总是在 finally 块中来关闭 `SqlSession`。

# 使用Spring Batch

https://mybatis.org/spring/zh/batch.html

# 示例代码

> 提示:  查看 [JPetstore 6 demo](https://github.com/mybatis/jpetstore-6) 了解如何在完整的 Web 应用服务器上使用 Spring 

您可以在 MyBatis-Spring 的[代码仓库](https://github.com/mybatis/spring/tree/master/src/test/java/org/mybatis/spring/sample) 中查看示例代码： 

示例代码演示了事务服务从数据访问层获取域对象的典型设计。 

```java
@Transactional
public class FooService {

  private final UserMapper userMapper;

  public FooService(UserMapper userMapper) {
    this.userMapper = userMapper;
  }

  public User doSomeBusinessStuff(String userId) {
    return this.userMapper.getUser(userId);
  }

}
```

> 它是一个事务 bean，所以当调用它的任何方法时，事务被启动，在方法结束且没有抛出任何未经检查的异常的时候事务将会被提交。注意，事务的行为可以通过 `@Transactional` 的属性进行配置。这不是必需的；你可以使用 Spring 提供的任何其他方式来划分你的事务范围。 
>
> 此服务调用使用 MyBatis 构建的数据访问层.。该层只包含一个接口，`UserMapper.java`，这将被 MyBatis 构建的动态代理使用，在运行时通过 Spring 注入到服务之中。 



# 参考文档

[Mybatis-Spring整合官方文档](https://mybatis.org/spring/zh/)



