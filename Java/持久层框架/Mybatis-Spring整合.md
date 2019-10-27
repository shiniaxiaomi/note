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
   import org.apache.ibatis.annotations.Param;
   import org.apache.ibatis.annotations.Update;
   
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

   或者通过Java代码进行配置:

   ```java
   @Bean
   public SqlSessionFactory sqlSessionFactory() {
     SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
     factoryBean.setDataSource(dataSource());
     return factoryBean.getObject();
   }
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

### 标准事务配置

1. 要开启Spring的事务,需要在Spring的配置文件中创建一个 `DataSourceTransactionManager`  对象:

   ```xml
   <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
     <constructor-arg ref="dataSource" />
   </bean>
   ```

   > 这里传入的datasource必须和用来创建`SqlSessionFactoryBean`的是同一个数据源,否则事务管理器就无法生效

2. 在Spring中指定一个 `JtaTransactionManager`对象或由容器指定的一个子类作为事务管理器

   可以参考以下几种方式:

   1. 声名式事务管理

      这种方法不需要对原有的业务做任何修改，通过在XML文件中定义需要拦截方法的匹配即可完成配置,但是对于方法的命名需要有一定的规范,配置如下:

      ```xml
      <!--配置事务管理器-->
      <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
       <property name="dataSource" ref="dataSource"></property>
      </bean>
      
      <!-- 定义事务通知 -->
      <tx:advice id="txAdvice" transaction-manager="transactionManager">
          <!-- 定义方法的过滤规则 -->
          <tx:attributes>
              <!-- 所有方法都使用事务 -->
              <tx:method name="*" propagation="REQUIRED"/>
              <!-- 定义所有get开头的方法都是只读的 -->
              <tx:method name="get*" read-only="true"/>
          </tx:attributes>
      </tx:advice>
      
      <!-- 定义AOP配置 -->
      <aop:config>
          <!-- 定义一个切入点 -->
          <aop:pointcut expression="execution (* com.test.services.impl.*.*(..))" id="services"/>
          <!-- 对切入点和事务的通知，进行适配 -->
          <aop:advisor advice-ref="txAdvice" pointcut-ref="services"/>
      </aop:config>
      ```
   
   2. 注解式事务管理
   
      这种方法，只需要在Spring配置文件中定义一个事务管理对象（如DataSourceTransactionManager），然后加入`<tx:annotation-driven/>`节点，引用该事务管理对象，然后即可在需要进行事务处理的类和方法使用@Transactional进行标注。示例如下：
   
      ```xml
      <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
          <property name="dataSource" ref="dataSource"></property>
      </bean>
      <!-- 声明使用注解式事务 -->
      <tx:annotation-driven transaction-manager="transactionManager"/>
      ```
   
      > 注意点: 
      >
      > 1. `@Transactional`注解 **默认只对RuntimeException异常回滚**； 
      > 2. 如果在接口、实现类或方法上都指定了@Transactional 注解，则优先级顺序为方法>实现类>接口;  建议只在实现类或实现类的方法上使用@Transactional，而不要在接口上使用 
   
   > 在这个配置中,Spring会自动使用任何一个存在的容器事务管理器,并注入一个SqlSession

### 编程式事务管理

 https://mybatis.org/spring/zh/transactions.html#programmatic 

## SqlSession

在Mybatis中,可以通过 `SqlSessionFactory` 来创建 `SqlSession` ,然后你可以通过`SqlSession` 来执行映射了的sql语句,提交或回滚,在关闭`SqlSession` 

在使用 MyBatis-Spring 之后 ,我们不再需要直接使用`SqlSessionFactory` ,因为我们的JavaBean中可以被MyBatis-Spring注入一个线程安全的SqlSession,它能基于Spring的事务配置来自动提交,回滚和关闭SqlSession

### SqlSessionTemplate

`SqlSessionTemplate` 是 MyBatis-Spring 的核心。作为 `SqlSession`接口的一个实现, 它可以代替你代码中已经在使用的 `SqlSession`

`SqlSessionTemplate` 是线程安全的,可以被多个DAO或映射器所共享使用

当调用SQL时, `SqlSessionTemplate` 将会保证使用的 `SqlSession` 与当前 Spring 的事务相关, 并且它还会管理SqlSession的生命周期,包含关闭,提交和回滚等操作; 另外,它还负责将Mybatis的异常翻译成Spring的 `DataAccessExceptions` 

由于`SqlSessionTemplate` 会参与到Spring的事务管理中,并且它是线程安全的,可以被多个映射器类使用,你可以使用`SqlSessionTemplate` 来替换掉Mybatis默认的 `DefaultSqlSession` 实现 

我们可以传入 `SqlSessionFactory`  来 创建 `SqlSessionTemplate`  对象:

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

我们可以在JavaBean中这样使用:

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

### SqlSessionDaoSupport

`SqlSessionDaoSupport` 是一个抽象类,但也是用来提供 `SqlSession`的; 继承`SqlSessionDaoSupport` 类,就可以直接调用  `getSqlSession()` 方法你会得到一个 `SqlSessionTemplate` ,代码如下:

```java
public class UserDaoImpl extends SqlSessionDaoSupport implements UserDao {
  public User getUser(String userId) {
    return getSqlSession().selectOne("org.mybatis.spring.sample.mapper.UserMapper.getUser", userId);
  }
}
```

# 映射器(Mapper)

## 手动注入映射器

### XML配置

在Spring.xml中加入 `MapperFactoryBean`  便可注册映射器:

```xml
<bean id="userMapper" class="org.mybatis.spring.mapper.MapperFactoryBean">
	<!--指定映射器接口-->
    <property name="mapperInterface" value="org.mybatis.spring.sample.mapper.UserMapper" />
    <!--指定sqlSessionFactory-->
    <property name="sqlSessionFactory" ref="sqlSessionFactory" />
</bean>
```

> 如果我们的映射器接口使用的是注解,那么该映射器注册之后便可直接使用; 但是如果我们还有对应的mapper.xml文件,那么我们需要在注入 `SqlSessionFactoryBean` 对象的时候指定它的 `configLocation` 属性(详细可以参考上文的`SqlSessionFactoryBean` )

### Java代码配置

```java
@Bean
public MapperFactoryBean<UserMapper> userMapper() throws Exception {
  MapperFactoryBean<UserMapper> factoryBean = new MapperFactoryBean<>(UserMapper.class);
  factoryBean.setSqlSessionFactory(sqlSessionFactory());
  return factoryBean;
}
```

> 同样的,如果我们由对应的xml文件,需要在`SqlSessionFactoryBean` 对象中进行指定

## 自动扫描映射器

上面的手动注册映射器需要我们一个个的指定所有的映射器; 

我们可以使用 `MyBatis-Spring`对类路径进行扫描来发现映射器接口,有以下几种方法:

1. 在Spring.xml中使用` <mybatis:scan/> `元素
2. 使用 `@MapperScan` 注解 ( 适用于Spring 3.1+ )
3. 在Spring.xml中注册一个 `MapperScannerConfigurer`对象

### mybatis:scan标签

` <mybatis:scan/> `会发现映射器,它和Spring中的` <context:component-scan/> ` 发现 bean 的方法非常类似 

 下面是一个 XML 配置样例： 

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:mybatis="http://mybatis.org/schema/mybatis-spring"
  xsi:schemaLocation="
  http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
  http://mybatis.org/schema/mybatis-spring http://mybatis.org/schema/mybatis-spring.xsd">

  <mybatis:scan base-package="org.mybatis.spring.sample.mapper" />
    
</beans>
```

>  不需要为 ` <mybatis:scan/> ` 指定 `SqlSessionFactory` 或 `SqlSessionTemplate`，这是因为它将使用能够被自动注入的 `MapperFactoryBean` 

### @MapperScan

 `@MapperScan` 注解的使用方法如下： 

```java
@Configuration
@MapperScan("org.mybatis.spring.sample.mapper")
public class AppConfig {
  // ...
}
```

> 该注解和` <mybatis:scan/> `元素的工作方式一样;我们只需要通过(@Mapper注解进行标记即可)

### MapperScannerConfigurer

`MapperScannerConfigurer` 是一个 `BeanDefinitionRegistryPostProcessor`

下面是配置代码:

```xml 
<bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
    <property name="basePackage" value="org.mybatis.spring.sample.mapper" />
    <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory" />
</bean>
```

# Mybatis和Spring整合Demo

## 项目结构图

![image-20191025104243466](D:\note\.img\image-20191025104243466.png)

总共分为以下几层:

- dao: 存放映射类接口(在接口中可以使用sql注解,可以和xml一起使用)
- model: 存放业务模型
- service: 存放服务层代码

resources文件夹(项目根路径):

- mappers: 存放映射类xml文件(xxxMapper.xml)
- spring.xml: spring的配置文件

## src/main

### java

#### dao

UserMapper类

```java
package dao;

import model.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

@Mapper //标记是一个接口映射类
public interface UserMapper {
    @Update("update user set name=#{name} where id = #{id}")
    int updateUser(@Param("name") String name, @Param("id") int id);

    User selectUser(int id);//sql在xml中
}
```

#### model

User类:

```java
package model;

public class User {
    int id;
    String name;
    int age;

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", age=" + age +
                '}';
    }
}
```

#### service

UserService类:

```java
package service;

import dao.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    @Transactional(rollbackFor = Exception.class)
    public void updateUser(String name,int id) throws Exception {
        int i = userMapper.updateUser(name, id);
        if(i==1){
            throw new Exception("111");
        }
    }

}
```

#### Test类

```java
import model.User;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import service.UserService;

public class Test {
    public static void main(String[] args) throws Exception {
        ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
        UserService userService = context.getBean(UserService.class);
//        User user = userService.selectUser(1);
//        System.out.println(user);
        userService.updateUser("1111",1);
    }   
}
```

### resources

#### mappers

UserMapper.xml文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<!-- 1.mapper:根标签; 2.namespace：命名空间,保证命名空间唯一即可 -->
<mapper namespace="dao.UserMapper">

    <select id="selectUser" resultType="model.User">
        SELECT * from user where id=#{id}
    </select>

</mapper>
```

#### spring.xml

```xml
<?xml version="1.0" encoding="utf-8" ?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tx="http://www.springframework.org/schema/tx"
       xmlns:mybatis="http://mybatis.org/schema/mybatis-spring"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-4.0.xsd
http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx.xsd http://mybatis.org/schema/mybatis-spring http://mybatis.org/schema/mybatis-spring.xsd">

    <!--开启spring的注解扫描,扫描service层-->
    <context:component-scan base-package="service"/>

    <!--配置数据源-->
    <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
        <property name="driverClassName" value="com.mysql.jdbc.Driver"></property>
        <property name="url" value="jdbc:mysql://127.0.0.1:3306/test"></property>
        <property name="username" value="root"></property>
        <property name="password" value="123456"></property>
    </bean>

    <!--注入sqlSessionFactory(Mybatis-Spring整合的核心,
    通过sqlSessionFactory来产生线程安全的sqlSession,即SqlSessionTemplate)-->
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <!--指定数据源-->
        <property name="dataSource" ref="dataSource" />
        <!--可以指定mybatis的配置文件,用来覆盖一些默认的配置-->
        <!--<property name="configLocation" value="classpath:mybatis-config.xml"></property>-->
        <!--指定mapper.xml映射文件路径-->
        <property name="mapperLocations" value="classpath:mappers/**/*.xml" />
    </bean>

    <!--扫描标注有@Mapper的接口映射文件
    生成的Mapper对象里面会包含sqlSession(SqlSessionTemplate),mapperInterface(映射文件接口类)-->
    <mybatis:scan base-package="dao.**" />

    <!--创建事务管理器-->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <constructor-arg ref="dataSource" />
    </bean>
    <!--开启spring事务,并指定事务管理器-->
    <tx:annotation-driven transaction-manager="transactionManager"/>
</beans>
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

# 参考文档

[Mybatis-Spring整合官方文档](https://mybatis.org/spring/zh/)



