[TOC]

# 事务的基本原理

Spring事务的本质其实就是数据库对事务的支持,使用[JDBC](D:\note\Java\数据库\JDBC.md)的事务管理机制,就是利用java.sql.Connection对象完成对事务的提交

在没有Spring帮我们管理事务之前,我们要手动的管理事务:

```java
Connection conn = DriverManager.getConnection();
try {  
    conn.setAutoCommit(false);  //将自动提交设置为false                         
    //执行CRUD操作... 
    conn.commit();      //当两个操作成功后手动提交  
} catch (Exception e) {  
    conn.rollback();    //一旦其中一个操作出错都将回滚，所有操作都不成功
    e.printStackTrace();  
} finally {
    conn.colse();
}
```

# 与事务相关的理论知识

## 事务的四大特性(ACID)

1. 原子性(Atomicity)

   事务是一个原子操作,事务的原子性确保在事务中的动作要么全部完成,要么完全失败(回滚)

2. 一致性(Comsistency)

   事务在完成时,必须是所有的数据都保持一致状态

3. 隔离性(Isolation)

   并发事务执行之间无影响,在一个事务内部的操作对其他事务是不产生影响,这需要事务隔离级别来执行隔离性

4. 持久性(Durability)

   一旦事务完成,数据库的改变必须是持久化的

## 事务并发存在的问题

在企业级应用中,多用户访问数据库是常见的场景,这就是所谓的事务的并发,事务并发所可能存在的问题有:

1. 脏读: 一个事务读到另一个事务未提交的更新数据
2. 不可重复读: 一个事务两次读同一行数据,可是这两次读到的数据不一样
3. 幻读: 一个事务执行两次查询,但第二次查询比第一层次查询多出了一些数据行
4. 丢失修改: 撤销一个事务时,把其他事务已提交的更新的数据覆盖了

> **不可重复度和幻读区别：**
>
> 不可重复读的重点是修改，幻读的重点在于新增或者删除



我们可以在`java.sql.Connection`中看到JDBC定义了5中事务隔离级别来解决这些并发导致的问题:

 ```java
int TRANSACTION_NONE         	 = 0;//驱动不支持事务
int TRANSACTION_READ_UNCOMMITTED = 1;//允许脏读、不可重复读和幻读
int TRANSACTION_READ_COMMITTED   = 2;//禁止脏读，但允许不可重复读和幻读
int TRANSACTION_REPEATABLE_READ  = 4;//禁止脏读和不可重复读，单运行幻读
int TRANSACTION_SERIALIZABLE     = 8;//禁止脏读、不可重复读和幻读
 ```

隔离级别越高,意味着数据库事务并发执行性能越差,能处理的操作就越少; 你可以通过 `conn.setTransactionLevel `去设置你需要的隔离级别;

JDBC规范虽然定义了事务的以上支持行为,但是各个JDBC驱动的数据库厂商对事务的支持程度可能各不相同

处于性能的考虑,我们一般设置`TRANSACTION_READ_COMMITTED`就差不多了,剩下的通过使用数据库的锁来帮助我们处理

# Spring的事务管理

了解了基本的JDBC的事务,那有了Spring,在事务管理上会有什么新的改变呢?

> 有了Spring,我们无需再去处理获取连接,关闭连接,事务提交和回滚等操作,使得我们把更多的精力放在处理业务上; 事实上,Spring并不直接管理事务,而是提供了多种事务管理器,他们将事务管理的责任委托给Hibernate或JTA等持久化机制所提供的相关平台框架的事务来实现



Spring事务管理的核心接口:

- PlatformTransactionManager: 事务管理器
- TransactionDefinition: 事务定义信息
- TransactionStatus: 事务运行状态

> 所谓事务管理,其实就是"按照给定的事务规则来执行提交或回滚操作"



接口之间的联系如下图所示:

![在这里插入图片描述](D:\note\.img\2019041016324335.png)

> 这张关系图非常的重要

## 事务管理器

Spring并不直接管理事务,而是提供了多种事务管理器,他们将事务管理的职责委托给其他持久层框架锁提供的响应平台框架的事务来实现

Spring事务管理器的接口是` PlatformTransactionManager `,通过这个接口,Spring为各个平台提供了对应的事务管理器,但是具体的实现就是各个平台自己的事情了,该接口规定了一下内容:

```java
Public interface PlatformTransactionManager()...{  
    // 由TransactionDefinition得到TransactionStatus对象
    TransactionStatus getTransaction(TransactionDefinition definition) throws TransactionException; 
    // 提交
    Void commit(TransactionStatus status) throws TransactionException;  
    // 回滚
    Void rollback(TransactionStatus status) throws TransactionException;  
} 
```

> 从接口可知,具体的事务管理机制对Spring来说是透明的,它并不关心,那些都是对应各个平台需要关心的,所以Spring事务管理的一个优点就是为不同事务API提供一致的编程墨西哥,如JTA,JDBC,Hibernate,JPA等

下面是各个平台实现的事务管理机制类:

- JDBC事务

  ```xml
  <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
      <property name="dataSource" ref="dataSource" />
  </bean>
  ```

  > 实际上,` DataSourceTransactionManager `是通过调用` java.sql.Connection `来管理事务的,其通过调用commit()方法来提交事务,通过调用rollback()方法来回滚

- Hibernate事务

  ```xml
  <bean id="transactionManager" class="org.springframework.orm.hibernate3.HibernateTransactionManager">
      <property name="sessionFactory" ref="sessionFactory" />
  </bean>
  ```

  > `sessionFactory`属性需要装配一个Hibernate的session工厂,` HibernateTransactionManager `的实现细节是它将事务管理的职责委托给` org.hibernate.Transaction `对象,而该对象是从` Hibernate Session `中获取到的; 当事务成功是, `HibernateTransactionManager`将会调用`Transaction`对象的commit()方法，反之，将会调用rollback()方法。 

- JPA事务

  ```xml
  <bean id="transactionManager" class="org.springframework.orm.jpa.JpaTransactionManager">
      <property name="sessionFactory" ref="sessionFactory" />
  </bean>
  ```

  > ` JpaTransactionManager `只需要装配一个JPA实体管理工厂( `javax.persistence.EntityManagerFactory`接口的任意实现 ), `JpaTransactionManager`将与由工厂所产生的`JPA EntityManager`合作来构建事务。 

## 事务定义信息

事务管理器接口通过 `getTransaction(TransactionDefinition definition) `方法根据指定的传播行为返回当前活动的事务或创建一个新的事务,这个方法里面的参数就是` TransactionDefinition `类,这个类就定义了一下基本的事务属性

---

事务属性包含了以下5个方面:

- 传播行为
- 隔离规则
- 回滚规则
- 事务超时
- 是否只读

---

`TransactionDefinition`接口内容如下： 

```java
public interface TransactionDefinition {
    int getPropagationBehavior(); // 返回事务的传播行为
    int getIsolationLevel(); // 返回事务的隔离级别，事务管理器根据它来控制另外一个事务可以看到本事务内的哪些数据
    int getTimeout();  // 返回事务必须在多少秒内完成
    boolean isReadOnly(); // 事务是否只读，事务管理器能够根据这个返回值进行优化，确保事务是只读的
} 
```

### 传播行为

当事务方法被另一个事务方法调用时,必须执行事务应该如何传播;例如: 方法可能继续再现有事务中运行,也可能开启一个新事务,并在自己的事务中运行; Spring定义了以下7种传播行为:

|           名称            |  值  |                             解释                             |
| :-----------------------: | :--: | :----------------------------------------------------------: |
|   PROPAGATION_REQUIRED    |  0   | 表示当前方法必须运行在事务中。如果当前事务存在，方法将会在该事务中运行。否则，会启动一个新的事务; 这是最常见的选择，也是Spring默认的事务的传播。 |
|   PROPAGATION_SUPPORTS    |  1   | 表示当前方法不需要事务上下文，但是如果存在当前事务的话，那么该方法会在这个事务中运行 |
|   PROPAGATION_MANDATORY   |  2   | 表示该方法必须在事务中运行，如果当前事务不存在，则会抛出一个异常 |
| PROPAGATION_REQUIRES_NEW  |  3   | 表示当前方法必须运行在它自己的事务中。一个新的事务将被启动。如果存在当前事务，在该方法执行期间，当前事务会被挂起 |
| PROPAGATION_NOT_SUPPORTED |  4   | 表示该方法不应该运行在事务中。如果存在当前事务，在该方法运行期间，当前事务将被挂起 |
|     PROPAGATION_NEVER     |  5   | 表示当前方法不应该运行在事务上下文中。如果当前正有一个事务在运行，则会抛出异常 |
|    PROPAGATION_NESTED     |  6   | 表示如果当前已经存在一个事务，那么该方法将会在嵌套事务中运行。嵌套的事务可以独立于当前事务进行单独地提交或回滚。如果当前事务不存在，那么其行为与PROPAGATION_REQUIRED一样; 注意各厂商对这种传播行为的支持是有所差异的。可以参考资源管理器的文档来确认它们是否支持嵌套事务 |

以下具体讲解传播行为的内容:

**PROPAGATION_REQUIRED** (默认事务)

如果存在一个事务,则支持当前事务; 如果没有事务,则开启一个新的事务





**PROPAGATION_SUPPORTS**  

**PROPAGATION_MANDATORY**  

**PROPAGATION_REQUIRES_NEW**  

**PROPAGATION_NOT_SUPPORTED**  

**PROPAGATION_NEVER**  

**PROPAGATION_NESTED** 





### 隔离级别

### 是否只读

### 事务超时

### 回滚规则

## 事务运行状态

`TransactionStatus`接口:



# 编程式事务

## 编程式事务和声明式事务的区别

## 如何实现编程式事务

### 使用PlatformTransactionManager

### 使用TransactionTemplate



# 声明式事务

## 配置方式

## Demo











# 参考文档

[官方文档](https://docs.spring.io/spring/docs/5.2.0.RELEASE/spring-framework-reference/data-access.html#transaction)

[博客参考1](https://blog.csdn.net/trigl/article/details/50968079)

[博客参考2](https://blog.csdn.net/donggua3694857/article/details/69858827)