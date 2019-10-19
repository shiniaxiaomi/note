[TOC]

# 简介

Mybatis是一款优秀的持久层框架,它支持定制化sql,存储过程以及高级映射; Mybatis避免了几乎所有的JDBC代码和手动设置参数已经获取结果集; Mybatis可以使用简单的XML或注解来配置和映射原生类型,接口和Java中的POJO(Plain Old Java Object,普通老式Java对象)为数据库中的记录

# 传统的JDBC

## Demo

1. 创建一个maven项目

2. 引入mysql的maven依赖

   ```xml
   <dependency>
       <groupId>mysql</groupId>
       <artifactId>mysql-connector-java</artifactId>
       <version>5.1.32</version>
   </dependency>
   ```

3. 新建数据库表`mybatisTest`,并插入一条数据

   ```sql
   //创建user表
   CREATE TABLE `user` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `name` varchar(20) DEFAULT NULL,
      `age` int(11) DEFAULT NULL,
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8
    
   //插入数据
   INSERT INTO `user` (NAME, age) VALUES ('A', 1);
   INSERT INTO `user` (NAME, age) VALUES ('B', 2);
   INSERT INTO `user` (NAME, age) VALUES ('C', 3);
   ```

4. 使用JDBC查询数据

   ```java
   public class MybatisTest {
       public static void main(String[] args) throws Exception {
   
           Class.forName("com.mysql.jdbc.Driver");//加载mysql驱动
   
           String url="jdbc:mysql://127.0.0.1:3306/test";//数据库地址
           String userName="root";//用户名
           String password="123456";//密码
   
           Connection connection=null;
           PreparedStatement preparedStatement=null;
           ResultSet resultSet=null;
           try {
               connection = DriverManager.getConnection(url, userName, password);
               String sql="select * from user where id=?";//要执行的sql语句
               preparedStatement = connection.prepareStatement(sql);
               preparedStatement.setInt(1,2);//设置参数(id=2)
   
               resultSet = preparedStatement.executeQuery();
               while (resultSet.next()){
                   System.out.println(resultSet.getString("name"));//获取字段名name的值
                   System.out.println(resultSet.getString("age"));//获取字段名age的值
               }
           }finally {
               //在finally中关闭之前打开的资源
               if(resultSet!=null){
                   resultSet.close();
               }
               if(preparedStatement!=null){
                   preparedStatement.close();
               }
               if(connection!=null){
                   connection.close();
               }
           }
       }
   }
   ```

## 使用JDBC查询数据库的步骤

1. 加载JDBC驱动
2. 建立并获取数据库连接
3. 创建JDBC Statements对象
4. 设置sql语句的传入参数
5. 执行sql语句并获得查询结果
6. 对查询结果进行转换处理并将处理结果返回
7. 释放相关资源(关闭Connection,关闭Statement,关闭ResultSet)

## 缺点分析

1. 驱动名称进行了硬编码
2. 每次都要通过url,userName,password来获取到数据库的链接
3. sql语句和Java代码强耦合,无法分离
4. sql语句的参数类型需要手动判断,设值时需要判断下标,需要手动的设置参数
5. 结果集中的数据类型需要手动的判断,获取值时需要手动的指定列名或下标
6. 每次对数据库操作都要打开或关闭链接,浪费资源

## JDBC演变到Mybatis的过程

JDBC与数据库交互有7个步骤,哪些步骤是可以进一步封装的?这就Mybatis框架帮我们做的事情

### 优化与数据库连接的获取和释放

- 问题描述:

  数据库连接频繁的开启和关闭本身就造成了资源的浪费,影响系统的性能

- 解决方案:

  数据库连接的获取和关闭我们可以使用数据库连接池来解决频繁的开启或关闭连接导致资源浪费的问题; 通过连接池可以反复利用已经建立的连接去访问数据库,减少连接的开启和关闭的时间;

### 优化sql统一存取

- 问题描述

  我们使用JDBC操作数据库时,sql语句基本上都散落在各个Java类中,有三点不足:

  1. 可读性差,不利于维护以及做性能调优
  2. 改动Sql需要重新编译,打包部署
  3. 不利于去除sql在数据库客户端执行(需要在自己去重新组装sql)

- 解决方案

  我么可以把sql统一存放在一个地方,以key-value的形式存放,通过key就可以找到对应的sql,然后再对应的去执行

### 传入参数映射和动态sql

- 问题描述

  很多时候,我们使用占位符来传入参数,这种方法有一定的局限,就是需要按照一定顺序传入参数,而且要与占位符一一对应; 但是如果我们传入的参数个数不确定,那么按照传统的JDBC只能将判断逻辑写在Java代码中,使得sql和Java代码更加的耦合

- 解决方案

  对应参数的判断逻辑可以写在sql当中,我们自定义例如`<if test=''></if>`和`<else test=''><else/>`标签判断,再用一个专门的sql解析器解析这样的sql语句就能够解决; 那么`<if>`标签中的变量来自哪里呢? 我们可以使用`#变量名#`或`$变量名$`来获取到对应传入的变量

### 结果映射和结果缓存

- 问题描述

  执行sql语句,获取到执行结果,对执行就欸过进行转换处理并释放相关资源是必不可少的一套动作; 如果是执行查询语句,那么执行完sql语句后,返回的是一个ResultSet结果集,这时我们就需要将ResultSet对象的数据取出来,不然等到释放资源后就取不到结果集了; 如果能够完成获取结果集的封装,直接调用一个封装的方法即可以返回一个数据结构(结果集),那么就完美了

- 解决方案

  我们可以再获取ResultSet结果集后,将所有的数据取出并复制到我们指定的JavaBean中(可以是一个普通对象,一个Map,一个List等等),我们只需要做两点:

  1. 告诉mybatis我们需要返回什么类型的对象
  2. 我们需要返回的对象的数据结构和ResultSet中的结果集的字段怎么一一对应

  这样,mybatis就可以让帮我们将具体的结果赋值到对应的对象中,并返回给我们

  ---

  接下来考虑对sql执行结果的缓存来提升性能; 缓存数据都是key-value形式的,那么这个key怎么确定唯一?我们可以将sql和传入的参数两部分结合起来作为数据缓存的key值

### 解决重复sql语句问题

- 问题描述

  由于我们将所有sql语句都放到配置文件中,这时会遇到一个sql重复的问题; 或者是几个sql语句的功能都差不多,但是可能因为查询的字段不同或者where条件不同而重复写多个sql

- 解决方案

  我们可以将重复的代码抽离成一个独立的片段,可以在各个需要的地方进行引用, 这样需要修改时只需要修改一处即可

### 对比与总结

总结一下对JDBC的优化和封装:

1. 使用数据库连接池对连接进行管理
2. sql语句统一存放到配置文件中,便于管理
3. sql语句中的变量和传入的参数之间的一个映射关系
4. 动态sql语句的处理
5. 对数据库操作结果和返回对象结构的一个映射关系和结果缓存
6. sql语句片段,能够重复引用

### Mybatis待改进之处

- 问题描述

  Mybatis所有的数据库操作都是基于sql语句,对于不同的数据库对应的sql可能会略微不同,无法做到快速的切换数据源

# Mybatis工作原理

## 原理图

![img](D:\note\.img\20180624002302854.png)

![img](D:\note\.img\20141028140852531.png)

## 工作原理解析

详细流程如下:

1. 加载mybatis全局配置文件(mybatis-config.xml),解析配置文件,Mybatis基于xml配置文件生成Configuration(配置类对象,包含了所有配置),和一个个MappedStatement(包括了参数映射配置,动态sql语句,结果映射配置),其对应着一个个xxxMapper.xml中的`<select|update|delete|insert>`标签

   > mybatis-config.xml会包含数据源的配置,事务配置,mappers配置等

2. SqlSessionFactoryBuilder通过Configuration(配置类对象)生成SqlSessionFactory,用来开启SqlSession

3. SqlSession对象完成和数据库的交互

   1. 用户程序调用mybatis接口层api(集Mapper接口中的方法)
   2. SqlSession通过调用api并传入StatementID找到对应的MappedStatement对象
   3. 通过Executor(负责动态sql的生成和查询缓存的维护)将MappedStatement对象进行解析,sql参数转化,动态sql拼接,生成JDBC Statement对象
   4. JDBC执行sql
   5. 借助MappedStatement中的结果映射关系,将返回结果转化为HashMap,Javabean等存储对象并返回

以下是Mybatis的层次图:

![这里写图片描述](D:\note\.img\20171202184841388.png)

# 快速入门

## XML方式

### 引入依赖

```xml
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
    <version>3.2.8</version>
</dependency>
```

### 创建MyMapper.xml映射文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<!-- 1.mapper:根标签; 2.namespace：命名空间,保证命名空间唯一即可 -->
<mapper namespace="MyMapper">
    <!-- id：唯一标识,保证同一个命名空间下唯一即可
       resultType：sql语句查询结果集的封装类型,tb_user即为数据库中的表
     -->
    <select id="selectUser" resultType="test2.User">
        select * from user where id = #{id}
    </select>

    <!-- parameterType指定传入的参数类型 -->
    <insert id="insertUser" parameterType="test2.User">
        insert into user (name,age) VALUES (#{name},#{age});
    </insert>

    <update id="updateUser" parameterType="test2.User">
        update user set age=#{age} where id=#{id};
    </update>

    <delete id="deleteUser" parameterType="Integer">
        delete FROM user where id = #{id}
    </delete>
</mapper>
```

### 创建mybatis-config.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<!-- 根标签 -->
<configuration>
    <!--设置一些变量,可以提供改xml中使用-->
    <properties>
        <property name="driver" value="com.mysql.jdbc.Driver"/>
        <property name="url" value="jdbc:mysql://127.0.0.1:3306/test"/>
        <property name="username" value="root"/>
        <property name="password" value="123456"/>
    </properties>

    <!-- 环境，可以配置多个，default：指定采用哪个环境 -->
    <environments default="test">
        <!-- id：唯一标识 -->
        <environment id="test">
            <!-- 事务管理器，JDBC类型的事务管理器 -->
            <transactionManager type="JDBC" />
            <!-- 数据源，池类型的数据源 -->
            <dataSource type="POOLED">
                <property name="driver" value="${driver}" />
                <property name="url" value="${url}" />
                <property name="username" value="${username}" />
                <property name="password" value="${password}" />
            </dataSource>
        </environment>
    </environments>

    <!--指定要扫描的映射文件-->
    <mappers>
        <mapper resource="MyMapper.xml"></mapper>
    </mappers>
</configuration>
```

### 创建测试类

具体步骤:

1. 使用流读取配置文件后,传入`SqlSessionFactoryBuilder`中以创建`sqlSessionFactory`
2. 使用`sqlSessionFactory`打开一个`sqlSession`(开启一个会话)
3. 通过`sqlSession`与数据库交互(增,删,改,查)
4. 提交通过`sqlSession`提交事务才能使得修改的数据生效
5. 最后需要关闭`sqlSession`会话

```java
public class MybatisTest {
    public static void main(String[] args) throws Exception {
        // 指定全局配置文件
        String resource = "mybatis-config.xml";
        // 读取配置文件
        InputStream inputStream = Resources.getResourceAsStream(resource);
        // 构建sqlSessionFactory
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        // 获取sqlSession
        SqlSession sqlSession = sqlSessionFactory.openSession();
        try {
            //查询
            User user = sqlSession.selectOne("MyMapper.selectUser", 1);//(命令空间+id,传入的参数)
            System.out.println(user);
            //新增
            int insert = sqlSession.insert("MyMapper.insertUser", new User("zhangsan", 1));
            System.out.println(insert);
            //修改
            int update = sqlSession.update("MyMapper.updateUser", new User(1, null, 2));
            System.out.println(update);
            //删除
            int delete = sqlSession.delete("MyMapper.deleteUser", 1);
            System.out.println(delete);
            //提交事务
            sqlSession.commit();
        } finally {
            //关闭sqlSession
            sqlSession.close();
        }
    }
}
```

## 注解方式

### 引入依赖

```xml
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
    <version>3.2.8</version>
</dependency>
```

### 创建mybatis-config.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<!-- 根标签 -->
<configuration>
    <!--设置一些变量,可以提供改xml中使用-->
    <properties>
        <property name="driver" value="com.mysql.jdbc.Driver"/>
        <property name="url" value="jdbc:mysql://127.0.0.1:3306/test"/>
        <property name="username" value="root"/>
        <property name="password" value="123456"/>
    </properties>

    <!-- 环境，可以配置多个，default：指定采用哪个环境 -->
    <environments default="test">
        <!-- id：唯一标识 -->
        <environment id="test">
            <!-- 事务管理器，JDBC类型的事务管理器 -->
            <transactionManager type="JDBC" />
            <!-- 数据源，池类型的数据源 -->
            <dataSource type="POOLED">
                <property name="driver" value="${driver}" />
                <property name="url" value="${url}" />
                <property name="username" value="${username}" />
                <property name="password" value="${password}" />
            </dataSource>
        </environment>
    </environments>

    <!--指定要扫描的映射文件-->
    <mappers>
        <!-- 使用注解时不需要再这里指定映射文件,而是通过sqlSessionFactory.getConfiguration().addMapper()方法来动态的添加映射文件 -->
    </mappers>
</configuration>
```

### 创建注解接口(相当于xml中的映射文件)

```java
public interface UserMapper {
    @Select("select * from user where id=#{id}")
    User selectUser(int id);

    @Delete("delete from user where id=#{id}")
    int deleteUser(int id);

    @Update("update user set age=#{age} where id=#{id}")
    int updateUser(User user);

    @Insert("insert into user (name,age) values (#{name},#{age})")
    int addUser(User user);
}
```

### 测试类

```java
public class MybatisTest {
    public static void main(String[] args) throws Exception {
        // 指定全局配置文件
        String resource = "test3/mybatis-config.xml";
        // 读取配置文件
        InputStream inputStream = Resources.getResourceAsStream(resource);
        // 构建sqlSessionFactory
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        // 由于使用注解,所以再主配置文件中没有mapper,需要再代码中显示注册该mapper接口
        sqlSessionFactory.getConfiguration().addMapper(UserMapper.class);//注册注解类Mapper
        //开启一个会话
        SqlSession sqlSession = sqlSessionFactory.openSession();
        try{
            //通过接口类获取到对应的注解Mapper
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            //查询
            User user = mapper.selectUser(2);
            System.out.println(user);
            //删除
            int delete = mapper.deleteUser(3);
            System.out.println(delete);
            //更改
            int update = mapper.updateUser(new User(4, "zhangsan", 4));
            System.out.println(update);
            //新增
            int insert = mapper.addUser(new User("232", 534));
            System.out.println(insert);
            //提交事务
            sqlSession.commit();
        }finally {
            //关闭会话
            sqlSession.close();
        }
    }
}
```

# XML配置(mybatis-config.xml)

Mybatis的配置文件会影响Mybatis行为的设置和属性信息; 

配置文档的顶层结构如下： 

- properties（属性）
- settings（设置）
- typeAliases（类型别名）
- typeHandlers（类型处理器）
- objectFactory（对象工厂）
- plugins（插件）
- environments（环境配置）
  - environment（环境变量）
    - transactionManager（事务管理器）
    - dataSource（数据源）
- databaseIdProvider（数据库厂商标识）
- mappers（映射器）

## properties(属性)

 这些属性都是可外部配置且可动态替换的，既可以在典型的 Java 属性文件中配置，亦可通过 properties 元素的子元素来传递

例如

在xml中定义一个properties标签

```xml
<properties>
        <property name="driver" value="com.mysql.jdbc.Driver"/>
        <property name="url" value="jdbc:mysql://127.0.0.1:3306/test"/>
        <property name="username" value="root"/>
        <property name="password" value="123456"/>
</properties>
```

或者引用外部的properties配置文件

```xml
<properties resource="org/mybatis/example/config.properties">
  <property name="username" value="dev_user"/>
  <property name="password" value="F2Fa3!33TYyg"/>
</properties>
```

那么就可以在xml中引用这些定义的变量了

```xml
<dataSource type="POOLED">
  <property name="driver" value="${driver}"/>
  <property name="url" value="${url}"/>
  <property name="username" value="${username}"/>
  <property name="password" value="${password}"/>
</dataSource>
```

>  例子中的 username 和 password 将会由 properties 元素中设置的相应值来替换 

---

你还可以通过`:`来指定为属性指定默认值

```xml
<dataSource type="POOLED">
  <property name="username" value="${username:ut_user}"/> <!-- 如果属性 'username' 没有被配置，'username' 属性的值将为 ut_user变量的值 -->
</dataSource>
```

你还可以通过`三元运行算符`来判断和设值

```xml
<dataSource type="POOLED">
  <property name="username" value="${db!=null?'111':ut_user}"/><!--ut_user为变量-->
</dataSource>
```

## settings(设置)

- cacheEnabled

  > 可以开启或关闭配置文件中的所有映射器已经配置的任何缓存

  默认值: true

  可选值: true,false

- lazyLoadingEnabled

  > 延迟加载的开关; 当开启时,所有关联对象都会延迟加载; 特定关联关系中可通过设置` fetchType `属性来覆盖该现象的开关状态

  默认值: false

  可选值: true,false

- multipleResultSetsEnabled

  > 是否允许单一语句返回多个结果集(去要驱动支持)

  默认值: true

  可选值: true,false

- useColumnLabel

  > 使用列标签代替列名,不同的驱动会有不同的表现,具体需要参考相关的驱动文档;

  默认值: true

  可选值: true,false

- useGeneratedKeys

  > 允许JDBC支持自动生成主键,去要对应的数据库支持; 

  默认值: false

  可选值: true,false

- autoMappingBehavior

  > 指定Mybatis应该如何自动映射数据库的列名到对象中的属性;

  默认值:  PARTIAL 

  可选值:

  1. `NONE`: 表示取消自动映射；
  2. `PARTIAL`: 只会自动映射没有定义嵌套结果集映射的结果集。
  3. `FULL`: 会自动映射任意复杂的结果集（无论是否嵌套） 

- autoMappingUnknownColumnBehavior

  > 指定发现自动映射目标未知列(或者位置属性类型)的行为

  默认值:  NONE 

  可选值:

  1. `NONE`: 不做任何反应
  2. `WARNING`: 输出提醒日志 (`'org.apache.ibatis.session.AutoMappingUnknownColumnBehavior'`的日志等级必须设置为 `WARN`)
  3. `FAILING`: 映射失败 (抛出 `SqlSessionException`)

- defaultExecutorType

  >  配置默认的执行器 

  默认值:  SIMPLE 

  可选值:

  1. `SIMPLE`: 就是普通的执行器；
  2. `REUSE`: 执行器会重用预处理语句（prepared statements）； 
  3. `BATCH`: 执行器将重用语句并执行批量更新 

- defaultStatementTimeout

  >  设置超时时间，它设置等待数据库响应的秒数 

  默认值: 未设置(null)

  可选值: 任意正整数

- defaultFetchSize

  > 设置一个默认的查询个数,此参数可以在查询设置中被覆盖

  默认值: 未设置(null)

  可选值: 任意正整数

- safeRowBoundsEnabled

  >  允许在嵌套语句中使用分页 , 如果允许使用则设置为 false 

  默认值: false

  可选值: true,false

- mapUnderscoreToCamelCase

  >  是否开启自动驼峰命名规则（camel case）映射，即从经典数据库列名 A_COLUMN 到经典 Java 属性名 aColumn 的类似映射。 

  默认值: false

  可选值: true,false

- localCacheScope

  >  MyBatis 利用本地缓存机制（Local Cache）防止循环引用（circular references）和加速重复嵌套查询。 

  默认值: `SESSION`，这种情况下会缓存一个会话中执行的所有查询 

  若设置值为 `STATEMENT`，本地会话仅用在语句执行上，对相同 SqlSession 的不同调用将不会共享数据 

- jdbcTypeForNull

  > 当没有为参数提供特定的 JDBC 类型时，为空值指定 JDBC 类型。 有些数据库驱动需要指定列名的 JDBC 类型，多数情况直接用一般类型即可，比如 NULL、VARCHAR 或 OTHER。 

  默认值:  OTHER 

  可选值:  JdbcType 常量，常用值：NULL, VARCHAR 或 OTHER 

- lazyLoadTriggerMethods

  > 指定哪个对象的方法触发一次延迟加载

  默认值:  equals,clone,hashCode,toString 

  可选值:  用逗号分隔的方法列表

---

一个完整的settings元素的配置示例如下:

```xml
<settings>
  <setting name="cacheEnabled" value="true"/>
  <setting name="lazyLoadingEnabled" value="true"/>
  <setting name="multipleResultSetsEnabled" value="true"/>
  <setting name="useColumnLabel" value="true"/>
  <setting name="useGeneratedKeys" value="false"/>
  <setting name="autoMappingBehavior" value="PARTIAL"/>
  <setting name="autoMappingUnknownColumnBehavior" value="WARNING"/>
  <setting name="defaultExecutorType" value="SIMPLE"/>
  <setting name="defaultStatementTimeout" value="25"/>
  <setting name="defaultFetchSize" value="100"/>
  <setting name="safeRowBoundsEnabled" value="false"/>
  <setting name="mapUnderscoreToCamelCase" value="false"/>
  <setting name="localCacheScope" value="SESSION"/>
  <setting name="jdbcTypeForNull" value="OTHER"/>
  <setting name="lazyLoadTriggerMethods" value="equals,clone,hashCode,toString"/>
</settings>
```

## typeAliases(类型别名)

类型别名是为 Java 类型设置一个短的名字。 它只和 XML 配置有关，存在的意义仅在于用来减少类完全限定名的冗余。 

例如:

```xml
<typeAliases>
  <typeAlias alias="Author" type="domain.blog.Author"/>
  <typeAlias alias="Blog" type="domain.blog.Blog"/>
  <typeAlias alias="Comment" type="domain.blog.Comment"/>
  <typeAlias alias="Post" type="domain.blog.Post"/>
  <typeAlias alias="Section" type="domain.blog.Section"/>
  <typeAlias alias="Tag" type="domain.blog.Tag"/>
</typeAliases>
```

当像上述这样配置后，`Blog` 可以用在任何使用 `domain.blog.Blog` 的地方。 

---

也可以指定一个包名，MyBatis 会在包名下面搜索需要的 Java Bean

例如:

```xml
<typeAliases>
  <package name="domain.blog"/>
</typeAliases>
```

像上述这样配置后,在该包下的类型在没有注解的情况下,默认使用类名的首字母小写来作为它的别名;  比如 `domain.blog.Author` 的别名为 `author` ;  若有注解，则别名为其注解值。见下面的例子 :

```java
@Alias("author")
public class Author {
    ...
}
```

---

以下是一些较为常见的Java类型内建的相应的类型别名; 他们都是不区分大小写的

| 别名       | 映射的类型 |
| :--------- | :--------- |
| _byte      | byte       |
| _long      | long       |
| _short     | short      |
| _int       | int        |
| _integer   | int        |
| _double    | double     |
| _float     | float      |
| _boolean   | boolean    |
| string     | String     |
| byte       | Byte       |
| long       | Long       |
| short      | Short      |
| int        | Integer    |
| integer    | Integer    |
| double     | Double     |
| float      | Float      |
| boolean    | Boolean    |
| date       | Date       |
| decimal    | BigDecimal |
| bigdecimal | BigDecimal |
| object     | Object     |
| map        | Map        |
| hashmap    | HashMap    |
| list       | List       |
| arraylist  | ArrayList  |
| collection | Collection |
| iterator   | Iterator   |

## typeHandlers(类型处理器)

**无论是 MyBatis 在预处理语句（PreparedStatement）中设置一个参数时，还是从结果集中取出一个值时， 都会用类型处理器将获取的值以合适的方式转换成 Java 类型。** 

 下表描述了一些默认的并常见的类型处理器 :

| 类型处理器           | Java 类型                      | JDBC 类型                            |
| :------------------- | :----------------------------- | :----------------------------------- |
| `BooleanTypeHandler` | `java.lang.Boolean`, `boolean` | 数据库兼容的 `BOOLEAN`               |
| `ByteTypeHandler`    | `java.lang.Byte`, `byte`       | 数据库兼容的 `NUMERIC` 或 `BYTE`     |
| `ShortTypeHandler`   | `java.lang.Short`, `short`     | 数据库兼容的 `NUMERIC` 或 `SMALLINT` |
| `IntegerTypeHandler` | `java.lang.Integer`, `int`     | 数据库兼容的 `NUMERIC` 或 `INTEGER`  |
| `LongTypeHandler`    | `java.lang.Long`, `long`       | 数据库兼容的 `NUMERIC` 或 `BIGINT`   |
| `FloatTypeHandler`   | `java.lang.Float`, `float`     | 数据库兼容的 `NUMERIC` 或 `FLOAT`    |
| `DoubleTypeHandler`  | `java.lang.Double`, `double`   | 数据库兼容的 `NUMERIC` 或 `DOUBLE`   |

> 其他类处理器可以见参考文档: https://mybatis.org/mybatis-3/zh/configuration.html#typeHandlers

---

我们可以重写类型处理器或创建你自己的类型处理器来处理不支持的或非标准的类型

做法如下:  实现 `org.apache.ibatis.type.TypeHandler` 接口， 或继承一个很便利的类 `org.apache.ibatis.type.BaseTypeHandler`， 然后可以选择性地将它映射到一个 JDBC 类型 

示例:

```java
// ExampleTypeHandler.java
@MappedJdbcTypes(JdbcType.VARCHAR)
public class ExampleTypeHandler extends BaseTypeHandler<String> {

  @Override
  public void setNonNullParameter(PreparedStatement ps, int i, String parameter, JdbcType jdbcType) throws SQLException {
    ps.setString(i, parameter);
  }

  @Override
  public String getNullableResult(ResultSet rs, String columnName) throws SQLException {
    return rs.getString(columnName);
  }

  @Override
  public String getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
    return rs.getString(columnIndex);
  }

  @Override
  public String getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
    return cs.getString(columnIndex);
  }
}
```

在`mybatis-config.xml`配置文件中配置指定的类型处理器即可

```xml
<!-- mybatis-config.xml -->
<typeHandlers>
  <typeHandler handler="org.mybatis.example.ExampleTypeHandler"/>
</typeHandlers>
```

> 使用上述的类型处理器将会覆盖已经存在的处理 Java 的 String 类型属性和 VARCHAR 参数及结果的类型处理器;  要注意 MyBatis 不会通过窥探数据库元信息来决定使用哪种类型，所以你必须在参数和结果映射中指明那是 VARCHAR 类型的字段， 以使其能够绑定到正确的类型处理器上。这是因为 MyBatis 直到语句被执行时才清楚数据类型。

## objectFactory(对象工厂)

MyBatis 每次创建结果对象的新实例时，它都会使用一个对象工厂（ObjectFactory）实例来完成 ; 

默认的对象工厂需要做的仅仅是实例化目标类，要么通过默认构造方法，要么在参数映射存在的时候通过参数构造方法来实例化。 

如果想覆盖对象工厂的默认行为，则可以通过创建自己的对象工厂来实现 ;

例如:

继承默认的对象工厂,重写方法

```java
// ExampleObjectFactory.java
public class ExampleObjectFactory extends DefaultObjectFactory {
  public Object create(Class type) {
    return super.create(type);
  }
  public Object create(Class type, List<Class> constructorArgTypes, List<Object> constructorArgs) {
    return super.create(type, constructorArgTypes, constructorArgs);
  }
  public void setProperties(Properties properties) {
    super.setProperties(properties);
  }
  public <T> boolean isCollection(Class<T> type) {
    return Collection.class.isAssignableFrom(type);
  }
}
```

在`mybatis-config.xml`配置文件中添加配置

```xml
<!-- mybatis-config.xml -->
<objectFactory type="org.mybatis.example.ExampleObjectFactory">
  <property name="someProperty" value="100"/>
</objectFactory>
```

> ObjectFactory 接口很简单，它包含两个创建用的方法，一个是处理默认构造方法的，另外一个是处理带参数的构造方法的。 最后，setProperties 方法可以被用来配置 ObjectFactory，在初始化你的 ObjectFactory 实例后， objectFactory 元素体中定义的属性会被传递给 setProperties 方法。 

## plugins(插件)

MyBatis 允许你在已映射语句执行过程中的某一点进行拦截调用。默认情况下，MyBatis 允许使用插件来拦截的方法调用包括：

- Executor (update, query, flushStatements, commit, rollback, getTransaction, close, isClosed)
- ParameterHandler (getParameterObject, setParameters)
- ResultSetHandler (handleResultSets, handleOutputParameters)
- StatementHandler (prepare, parameterize, batch, update, query)

> 在Executor中会有(...)中的那些方法可以被拦截

>  这些类中方法的细节可以通过查看每个方法的签名来发现，或者直接查看 MyBatis 发行包中的源代码。 如果你想做的不仅仅是监控方法的调用，那么你最好相当了解要重写的方法的行为。 因为如果在试图修改或重写已有方法的行为的时候，你很可能在破坏 MyBatis 的核心模块。 这些都是更底层的类和方法，所以使用插件的时候要特别当心。 

现在一些MyBatis 插件比如PageHelper都是基于这个原理，有时为了监控sql执行效率，也可以使用插件机制
原理： 

![这里写图片描述](D:\note\.img\20180701222734152.png)

通过 MyBatis 提供的强大机制，使用插件是非常简单的，只需实现 Interceptor 接口，并指定想要拦截的方法签名即可 

```java
// ExamplePlugin.java
@Intercepts({@Signature(
  type= Executor.class, //指定拦截哪个类
  method = "update",	//指定拦截哪个方法
  args = {MappedStatement.class,Object.class})})
public class ExamplePlugin implements Interceptor {
  private Properties properties = new Properties();
  public Object intercept(Invocation invocation) throws Throwable {
    // implement pre processing if need
    Object returnObject = invocation.proceed();
    // implement post processing if need
    return returnObject;
  }
  public void setProperties(Properties properties) {
    this.properties = properties;
  }
}
```

在`mybatis-config.xml`配置文件中进行配置

```xml
<!-- mybatis-config.xml -->
<plugins>
  <plugin interceptor="org.mybatis.example.ExamplePlugin">
    <property name="someProperty" value="100"/>
  </plugin>
</plugins>
```

## environments(环境配置)

 MyBatis 可以配置成适应多种环境，这种机制有助于将 SQL 映射应用于多种数据库之中 

 例如，开发、测试和生产环境需要有不同的配置；或者想在具有相同 Schema 的多个生产数据库中 使用相同的 SQL 映射。有许多类似的使用场景 

> 注意: 尽管可以配置多个环境，但每个 SqlSessionFactory 实例只能选择一种环境 

 所以，如果你想连接两个数据库，就需要创建两个 SqlSessionFactory 实例，每个数据库对应一个。而如果是三个数据库，就需要三个实例，依此类推 ; 即 **每个数据库对应一个SqlSessionFactory实例**

 为了指定创建哪种环境，只要将它作为可选的参数传递给 SqlSessionFactoryBuilder 即可 

```java
SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(reader, environment);
SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(reader, environment, properties);
```

在环境元素中定义了如何配置环境

```xml
<environments default="development">
  <environment id="development">
    <transactionManager type="JDBC">
      <property name="..." value="..."/>
    </transactionManager>
    <dataSource type="POOLED">
      <property name="driver" value="${driver}"/>
      <property name="url" value="${url}"/>
      <property name="username" value="${username}"/>
      <property name="password" value="${password}"/>
    </dataSource>
  </environment>
</environments>
```

> 注意:
>
> - 需要配置默认的环境（比如：default="development"）
> - 每个环境都需要指定一个id（比如：id="development"）
> - 事务管理器的配置（比如：type="JDBC"）
> - 数据源的配置（比如：type="POOLED"）

### 事务管理器配置

 在 MyBatis 中有两种类型的事务管理器: 

- `JDBC` 

  这个配置就是直接使用了 JDBC 的提交和回滚设置，它依赖于从数据源得到的连接来管理事务作用域。

-  `MANAGED` 

   这个配置几乎没做什么。它从来不提交或回滚一个连接，而是让容器来管理事务的整个生命周期（比如 JEE 应用服务器的上下文）。 默认情况下它会关闭连接，然而一些容器并不希望这样，因此需要将 closeConnection 属性设置为 false 来阻止它默认的关闭行为,例如:

   ```xml
   <transactionManager type="MANAGED">
     <property name="closeConnection" value="false"/>
   </transactionManager>
   ```

> 提示: 如果你正在使用 Spring + MyBatis，则没有必要配置事务管理器， 因为 Spring 模块会使用自带的管理器来覆盖前面的配置。 

### 数据源配置

 dataSource 元素使用标准的 JDBC 数据源接口来配置 JDBC 连接对象的资源。 

总共有三种数据源类型:

1.  UNPOOLED

   这个数据源的实现只是每次被请求时打开和关闭连接 

   该数据源具有以下属性:

   - `driver` – 这是 JDBC 驱动的 Java 类的完全限定名（并不是 JDBC 驱动中可能包含的数据源类）。
   - `url` – 这是数据库的 JDBC URL 地址。
   - `username` – 登录数据库的用户名。
   - `password` – 登录数据库的密码。
   - `defaultTransactionIsolationLevel` – 默认的连接事务隔离级别。
   - `defaultNetworkTimeout` – 默认的连接超时时间
   - `driver.encoding=UTF8` -  这将通过 DriverManager.getConnection(url,driverProperties) 方法传递值为 `UTF8` 的 `encoding` 属性给数据库驱动。 

2. POOLED

    这种数据源的实现利用“池”的概念将 JDBC 连接对象组织起来，避免了创建新的连接实例时所必需的初始化和认证时间; web项目大多使用的是这种数据源类型;

   除了上述提到 UNPOOLED 下的属性外，还有更多属性用来配置 POOLED 的数据源: 

   - `poolMaximumActiveConnections` – 在任意时间可以存在的活动（也就是正在使用）连接数量，默认值：10
   - `poolMaximumIdleConnections` – 任意时间可能存在的空闲连接数。
   - `poolMaximumCheckoutTime` – 在被强制返回之前，池中连接被检出（checked out）时间，默认值：20000 毫秒（即 20 秒）
   - `poolTimeToWait` – 这是一个底层设置，如果获取连接花费了相当长的时间，连接池会打印状态日志并重新尝试获取一个连接（避免在误配置的情况下一直安静的失败），默认值：20000 毫秒（即 20 秒）。
   - `poolMaximumLocalBadConnectionTolerance` – 这是一个关于坏连接容忍度的底层设置， 作用于每一个尝试从缓存池获取连接的线程。 如果这个线程获取到的是一个坏的连接，那么这个数据源允许这个线程尝试重新获取一个新的连接，但是这个重新尝试的次数不应该超过 `poolMaximumIdleConnections` 与 `poolMaximumLocalBadConnectionTolerance` 之和。 默认值：3 （新增于 3.4.5）
   - `poolPingQuery` – 发送到数据库的侦测查询，用来检验连接是否正常工作并准备接受请求。默认是“NO PING QUERY SET”，这会导致多数数据库驱动失败时带有一个恰当的错误消息。
   - `poolPingEnabled` – 是否启用侦测查询。若开启，需要设置 `poolPingQuery` 属性为一个可执行的 SQL 语句（最好是一个速度非常快的 SQL 语句），默认值：false。
   - `poolPingConnectionsNotUsedFor` – 配置 poolPingQuery 的频率。可以被设置为和数据库连接超时时间一样，来避免不必要的侦测，默认值：0（即所有连接每一时刻都被侦测 — 当然仅当 poolPingEnabled 为 true 时适用）。

3. JNDI 

    这个数据源的实现是为了能在如 EJB 或应用服务器这类容器中使用，容器可以集中或在外部配置数据源，然后放置一个 JNDI 上下文的引用 ,  这种数据源配置只需要两个属性： 

   - `initial_context` – 这个属性用来在 InitialContext 中寻找上下文（即，initialContext.lookup(initial_context)）。这是个可选属性，如果忽略，那么将会直接从 InitialContext 中寻找 data_source 属性。
   - `data_source` – 这是引用数据源实例位置的上下文的路径。提供了 initial_context 配置时会在其返回的上下文中进行查找，没有提供时则直接在 InitialContext 中查找。

   - `env.encoding=UTF8` - 这就会在初始上下文（InitialContext）实例化时往它的构造方法传递值为 `UTF8` 的 `encoding` 属性。

   ---

   你可以使用以下方法进行数据源的替换:

   你可以通过实现接口 `org.apache.ibatis.datasource.DataSourceFactory` 来使用第三方数据源：

   ```java
   public interface DataSourceFactory {
     void setProperties(Properties props);
     DataSource getDataSource();
   }
   ```

   `org.apache.ibatis.datasource.unpooled.UnpooledDataSourceFactory` 可被用作父类来构建新的数据源适配器，比如下面这段插入 C3P0 数据源所必需的代码：

   ```java
   import org.apache.ibatis.datasource.unpooled.UnpooledDataSourceFactory;
   import com.mchange.v2.c3p0.ComboPooledDataSource;
   
   public class C3P0DataSourceFactory extends UnpooledDataSourceFactory {
   
     public C3P0DataSourceFactory() {
       this.dataSource = new ComboPooledDataSource();
     }
   }
   ```

   为了令其工作，记得为每个希望 MyBatis 调用的 setter 方法在配置文件中增加对应的属性。 下面是一个可以连接至 PostgreSQL 数据库的例子：

   ```xml
   <dataSource type="org.myproject.C3P0DataSourceFactory">
     <property name="driver" value="org.postgresql.Driver"/>
     <property name="url" value="jdbc:postgresql:mydb"/>
     <property name="username" value="postgres"/>
     <property name="password" value="root"/>
   </dataSource>
   ```

## databaseIdProvider(数据库提供商)

MyBatis 可以根据不同的数据库厂商执行不同的语句，这种多厂商的支持是基于映射语句中的 `databaseId` 属性 

MyBatis 会加载不带 `databaseId` 属性和带有匹配当前数据库 `databaseId` 属性的所有语句。 如果同时找到带有 `databaseId` 和不带 `databaseId` 的相同语句，则后者会被舍弃 

为支持多厂商特性只要像下面这样在 mybatis-config.xml 文件中加入 `databaseIdProvider` 即可： 

```xml
<databaseIdProvider type="DB_VENDOR">
  <property name="SQL Server" value="sqlserver"/>
  <property name="DB2" value="db2"/>
  <property name="Oracle" value="oracle" />
</databaseIdProvider>
```

## mappers(映射器)

这个mappers是告诉 MyBatis 到哪里去找到这些 定义 SQL 映射语句 

 Java 在自动查找这方面没有提供一个很好的方法，所以最佳的方式是告诉 MyBatis 到哪里去找映射文件。 你可以使用相对于类路径的资源引用， 或完全限定资源定位符（包括 `file:///` 的 URL），或类名和包名等。例如： 

```xml
<!-- 使用相对于类路径的资源引用 -->
<mappers>
  <mapper resource="org/mybatis/builder/AuthorMapper.xml"/>
  <mapper resource="org/mybatis/builder/BlogMapper.xml"/>
  <mapper resource="org/mybatis/builder/PostMapper.xml"/>
</mappers>
<!-- 使用完全限定资源定位符（URL） -->
<mappers>
  <mapper url="file:///var/mappers/AuthorMapper.xml"/>
  <mapper url="file:///var/mappers/BlogMapper.xml"/>
  <mapper url="file:///var/mappers/PostMapper.xml"/>
</mappers>
<!-- 使用映射器接口实现类的完全限定类名 -->
<mappers>
  <mapper class="org.mybatis.builder.AuthorMapper"/>
  <mapper class="org.mybatis.builder.BlogMapper"/>
  <mapper class="org.mybatis.builder.PostMapper"/>
</mappers>
<!-- 将包内的映射器接口实现全部注册为映射器 -->
<mappers>
  <package name="org.mybatis.builder"/>
</mappers>
```

 这些配置都会告诉了 MyBatis 去哪里找映射文件，剩下的细节就应该是每个 SQL 映射文件了，也就是接下来我们要讨论的 

# XML映射文件

Mybatis的真正强大之处在于它的映射文件,它为聚焦于sql而构建,尽可能的较少麻烦

SQL映射文件只有很少的几个顶级元素:

- `insert` – 映射插入语句
- `update` – 映射更新语句
- `delete` – 映射删除语句
- `select` – 映射查询语句
- `resultMap` – 是最复杂也是最强大的元素，用来描述如何从数据库结果集中来加载对象
- `sql` – 可被其他语句引用的可重用语句块
- `cache` – 对给定命名空间的缓存配置。
- `cache-ref` – 对其他命名空间缓存配置的引用。

## select

查询语句是Mybatis中最常用的元素之一, 光能把数据存到数据库中价值并不大，只有还能重新取出来才有用，多数应用也都是查询比修改要频繁 

对每个插入、更新或删除操作，通常间隔多个查询操作。这是 MyBatis 的基本原则之一，也是将焦点和努力放在查询和结果映射的原因 

 简单查询的 select 元素是非常简单的。比如： 

```sql
<select id="selectPerson" parameterType="int" resultType="hashmap">
  SELECT * FROM PERSON WHERE ID = #{id}
</select>
```

>  这个语句被称作 selectPerson，接受一个 int（或 Integer）类型的参数，并返回一个 HashMap 类型的对象，其中的键是列名，值便是结果行中的对应值 

注意参数符号: `#{id}`

这就是告诉Mybatis创建一个预处理语句(PreparedStatement)参数,其底层就是使用的JDBC, 如下代码就是使用JDBC的PreparedStatement设置参数,只是Mybatis将其封装了而已:

```java
String selectPerson = "SELECT * FROM PERSON WHERE ID=?";
PreparedStatement ps = conn.prepareStatement(selectPerson);
ps.setInt(1,id);
```

当然,使用JDBC意味着需要更多的代码取提取结果并将他们映射到对象实例中,而这就是Mybatis节省你时间和代码的地方; 

`select`标签允许你配置很多属性来配置每条语句的作用细节:

```xml
<select
  id="selectPerson"
  parameterType="int"
  parameterMap="deprecated"
  resultType="hashmap"
  resultMap="personResultMap"
  flushCache="false"
  useCache="true"
  timeout="10"
  fetchSize="256"
  statementType="PREPARED"
  resultSetType="FORWARD_ONLY">
</select>
```

### select标签的属性

| 属性                   | 描述                                                         |
| :--------------------- | :----------------------------------------------------------- |
| `id`                   | 在命名空间中唯一的标识符，可以使用`命名空间.id`来确定唯一的sql语句 |
| `parameterType`        | 将会传入这条语句的参数类的完全限定名或别名。这个属性是可选的，因为 MyBatis 可以通过类型处理器（TypeHandler） 推断出具体传入语句的参数，默认值为未设置（unset）。 |
| `resultType`           | 设置返回类型的类的完全限定名或别名。 注意如果返回的是集合，那应该设置为集合包含的类型，而不是集合本身。可以使用 resultType 或 resultMap，但不能同时使用。 |
| `resultMap`            | 外部 resultMap 的命名引用。**结果集的映射是 MyBatis 最强大的特性**，如果你对其理解透彻，许多复杂映射的情形都能迎刃而解。可以使用 resultMap 或 resultType，但不能同时使用。 |
| `flushCache`           | 将其设置为 true 后，只要语句被调用，都会导致本地缓存和二级缓存被清空，默认值：false。 |
| `useCache`             | 将其设置为 true 后，将会导致本条语句的结果被二级缓存缓存起来，默认值：**对 select 元素为 true** |
| `timeout`              | 这个设置是在抛出异常之前，驱动程序等待数据库返回请求结果的秒数。默认值为未设置（unset）（依赖驱动）。 |
| `fetchSize`            | 这是一个给驱动的提示，尝试让驱动程序每次批量返回的结果行数和这个设置值相等。 默认值为未设置（unset）（依赖驱动） |
| `statementType`        | `STATEMENT`，`PREPARED` 或 `CALLABLE` 中的一个。这会让 MyBatis 分别使用 `Statement`，`PreparedStatement` 或 `CallableStatement`，默认值：`PREPARED` |
| `resultSetType`-不常用 | `FORWARD_ONLY`，`SCROLL_SENSITIVE`, `SCROLL_INSENSITIVE` 或 `DEFAULT`(等价于 unset)中的一个，默认值为 unset （依赖驱动）。 |
| `databaseId`-不常用    | 如果配置了数据库厂商标识（databaseIdProvider），MyBatis 会加载所有的不带 databaseId 或匹配当前 databaseId 的语句；如果带或者不带的语句都有，则不带的会被忽略。 |
| `resultOrdered`        | 这个设置仅针对嵌套结果 select 语句适用：如果为 true，就是假设包含了嵌套结果集或是分组，这样的话当返回一个主结果行的时候，就不会发生有对前面结果集的引用的情况。 这就使得在获取嵌套的结果集的时候不至于导致内存不够用。默认值：`false`。 |
| `resultSets`           | 这个设置仅对多结果集的情况适用。它将列出语句执行后返回的结果集并给每个结果集一个名称，名称是逗号分隔的。 |

## insert, update 和 delete

数据变更语句insert,update和delete的实现非常接近:

```xml
<insert
  id="insertAuthor"
  parameterType="domain.blog.Author"
  flushCache="true"
  statementType="PREPARED"
  keyProperty=""
  keyColumn=""
  useGeneratedKeys=""
  timeout="20">

<update
  id="updateAuthor"
  parameterType="domain.blog.Author"
  flushCache="true"
  statementType="PREPARED"
  timeout="20">

<delete
  id="deleteAuthor"
  parameterType="domain.blog.Author"
  flushCache="true"
  statementType="PREPARED"
  timeout="20">
```

### Insert,Update,Delete标签的属性

| 属性                | 描述                                                         |
| :------------------ | :----------------------------------------------------------- |
| `id`                | 在命名空间中唯一的标识符，可以使用`命名空间.id`来确定唯一的sql语句 |
| `parameterType`     | 将要传入语句的参数的完全限定类名或别名。这个属性是可选的，因为 MyBatis 可以通过类型处理器推断出具体传入语句的参数，默认值为未设置（unset）。 |
| `flushCache`        | 将其设置为 true 后，只要语句被调用，都会导致本地缓存和二级缓存被清空，**默认值：true (对于 insert、update 和 delete 语句)**。 |
| `timeout`           | 这个设置是在抛出异常之前，驱动程序等待数据库返回请求结果的秒数。默认值为未设置（unset）（依赖驱动）。 |
| `statementType`     | `STATEMENT`，`PREPARED` 或 `CALLABLE` 的一个。这会让 MyBatis 分别使用 `Statement`，`PreparedStatement` 或 `CallableStatement`，默认值：`PREPARED`。 |
| `useGeneratedKeys`  | **(仅对 insert 和 update 有用)** 这会令 MyBatis 使用 JDBC 的 `getGeneratedKeys` 方法来取出由数据库内部生成的主键（比如：像 MySQL(自增主键) 和 SQL Server 这样的关系数据库管理系统的自动递增字段），默认值：false。 |
| `keyProperty`       | **(仅对 insert 和 update 有用)** 唯一标记一个属性，MyBatis 会通过 getGeneratedKeys 的返回值或者通过 insert 语句的 selectKey 子元素设置它的键值，默认值：未设置（`unset`）。如果希望得到多个生成的列，也可以是逗号分隔的属性名称列表。 |
| `keyColumn`         | **(仅对 insert 和 update 有用)**通过生成的键值设置表中的列名，这个设置仅在某些数据库（像 PostgreSQL）是必须的，当主键列不是表中的第一列的时候需要设置。如果希望使用多个生成的列，也可以设置为逗号分隔的属性名称列表。 |
| `databaseId`-不常用 | 如果配置了数据库厂商标识（databaseIdProvider），MyBatis 会加载所有的不带 databaseId 或匹配当前 databaseId 的语句；如果带或者不带的语句都有，则不带的会被忽略。 |

示例:

```xml
<insert id="insertAuthor">
  insert into Author (id,username,password,email,bio)
  values (#{id},#{username},#{password},#{email},#{bio})
</insert>

<update id="updateAuthor">
  update Author set
    username = #{username},
    password = #{password},
    email = #{email},
    bio = #{bio}
  where id = #{id}
</update>

<delete id="deleteAuthor">
  delete from Author where id = #{id}
</delete>
```

### Insert后返回自动生成的主键

如上所述,插入语句的配置规则更加丰富,在插入语句里面有一些额外的属性和子元素用来处理主键的生成,而且有多种生成方式

- 如果你的数据库支持自动生成主键(比如MySQL和SQL Server),那么你可以设置 `useGeneratedKeys=”true”`，然后再把 `keyProperty` 设置到目标属性上就可以了; 例如: 

  ```xml
  <insert id="insertAuthor" useGeneratedKeys="true"
      keyProperty="id">
    insert into Author (username,password,email,bio)
    values (#{username},#{password},#{email},#{bio})
  </insert>
  ```

- 如果你的数据库还支持多行插入,你也可以传入一个Author数组或集合,并返回自动生成的主键

  ```xml
  <insert id="insertAuthor" useGeneratedKeys="true"
      keyProperty="id">
    insert into Author (username, password, email, bio) values
    <foreach item="item" collection="list" separator=",">
      (#{item.username}, #{item.password}, #{item.email}, #{item.bio})
    </foreach>
  </insert>
  ```

- 如果你的数据库不支持自动生成主键,Mybatis有另外一种方法来生成主键

  这里有一个简单的示例,它可以生成一个随机ID(这里只是用来展示,但你最好不要这样做)

  ```xml
  <insert id="insertAuthor">
    <selectKey keyProperty="id" resultType="int" order="BEFORE">
      select CAST(RANDOM()*1000000 as INTEGER) a from SYSIBM.SYSDUMMY1
    </selectKey>
    insert into Author
      (id, username, password, email,bio, favourite_section)
    values
      (#{id}, #{username}, #{password}, #{email}, #{bio}, #{favouriteSection,jdbcType=VARCHAR})
  </insert>
  ```

  在上面的示例中,` selectKey`标签中的语句将会首先运行,将运行的结果返回后设置到Author的id(由`keyProperty`指定)中,然后插入语句会被调用; 这可以提供给你一个于数据库中自动生成主键类似的行为,同时保持了Java代码的简介

  selectKey 元素描述如下：

  ```xml
  <selectKey
    keyProperty="id"
    resultType="int"
    order="BEFORE"
    statementType="PREPARED">
  ```

   selectKey 元素的属性如下:

  | 属性            | 描述                                                         |
  | :-------------- | :----------------------------------------------------------- |
  | `keyProperty`   | 可以指定selectKey语句的查询结果设置到参数对象的哪个属性当中; 如果希望将多个多列的查询结果设置到多个属性中，也可以使用逗号分隔的属性名称列表。 |
  | `keyColumn`     | 匹配属性的返回结果集中的列名称。如果希望得到多个生成的列，也可以是逗号分隔的属性名称列表。 |
  | `resultType`    | 结果的类型。MyBatis 通常可以推断出来，但是为了更加精确，写上也不会有什么问题。MyBatis 允许将任何简单类型用作主键的类型，包括字符串。如果希望作用于多个生成的列，则可以使用一个包含期望属性的 Object 或一个 Map。 |
  | `order`         | 这可以被设置为 `BEFORE` 或 `AFTER`。如果设置为 `BEFORE`，那么它会首先生成主键，设置 `keyProperty` 然后执行插入语句。如果设置为 `AFTER`，那么先执行插入语句，然后是 `selectKey` 中的语句 - 这和 Oracle 数据库的行为相似，在插入语句内部可能有嵌入索引调用。 |
  | `statementType` | 与前面相同，MyBatis 支持 `STATEMENT`，`PREPARED` 和 `CALLABLE` 语句的映射类型，分别代表 `PreparedStatement` 和 `CallableStatement` 类型。 |

## sql(sql片段)

 这个元素可以被用来定义可重用的 SQL 代码段,  这些 SQL 代码可以被包含在其他语句中;

它可以（在加载的时候）被静态地设置参数。 在不同的包含语句中可以设置不同的值到参数占位符上。比如：

```sql
<sql id="userColumns"> ${alias}.id,${alias}.username,${alias}.password </sql>
```

这个 SQL 片段可以被包含在其他语句中，例如： 

```sql
<select id="selectUsers" resultType="map">
  select
    <include refid="userColumns">
    	<property name="alias" value="t1"/>
    </include>,
    <include refid="userColumns">
    	<property name="alias" value="t2"/>
    </include>
  from some_table t1
    cross join some_table t2
</select>
```

属性值也可以被用在 include 元素的 refid 属性里或 include 元素的内部语句中，例如： 

```sql
<sql id="sometable">
  ${prefix}Table
</sql>

<sql id="someinclude">
  from
    <include refid="${include_target}"/>
</sql>

<select id="select" resultType="map">
  select
    field1, field2, field3
  <include refid="someinclude">
    <property name="prefix" value="Some"/>
    <property name="include_target" value="sometable"/>
  </include>
</select>
```

> `someinclude`中把`sometable`的sql片段和`prefix`当作为属性
>
> 使用`<include>`标签可以关联sql片段

## 参数(#{}和${})

一般我们可以通过`parameterType`来指定参数的类型

在此之前见到的所有语句中使用的都是简单参数,实际上参数是Mybatis非常强大的元素,对于简单的使用场景,大约90%的情况下都不需要使用复杂的参数,例如:

```xml
<select id="selectUsers" resultType="User">
  select id, username, password
  from users
  where id = #{id}
</select>
```

上面的这个示例说明了一个非常简单的命名参数映射; 

> 如果sql语句中只使用到了一个参数,那么你传入的任何类型都会被设置到#{id}中,即在select标签中不需要设置`parameterType`属性或者不需要将传入的参数名和#{id}的名字相对应;

但是如果在sql中用到了多个参数,那么规则就会严格起来

例如:

```xml
<insert id="insertUser" parameterType="User">
  insert into users (id, username, password)
  values (#{id}, #{username}, #{password})
</insert>
```

如果User类型的参数对象传递到语句中,id,username和password属性将会根据属性值名称被查找,然后将他们的值传入预处理语句的参数中; 

在这些参数中还可以指定一个特殊的数据类型,例如:

```xml
#{property,javaType=int,jdbcType=NUMERIC}
```

在Mybatis中,`javaType`几乎总是可以根据传入对象的类型直接确定下来,除非该传入的对象是一个HashMap,这个时候,需要显示指定`javaType`来确保正确的类型处理器(TypeHandler)被使用

但是在大多数时候你只需简单地指定属性名,其他的事情Mybatis会自己去推断,我们最多要为可能为空的列指定一下`jdbcType`,例如:

```xml
#{middleInitial,jdbcType=VARCHAR}
```

### 字符串替换

默认情况下, 使用 `#{}` 格式的语法会导致 MyBatis 创建 `PreparedStatement` 参数占位符并安全地设置参数(即这样做后字符串会被转义);   这样做更安全，更迅速，通常也是首选做法;

不过有时你就是想直接在 SQL 语句中插入一个不转义的字符串。 比如，像 ORDER BY，你可以这样来使用： 

```xml
ORDER BY ${columnName}
```

这里Mybatis不会修改或转义被传入的字符串

当SQL语句中的元数据(如表名或列名)是动态生成的时候,字符串替换将会非常有用,举个例子:

如果你想根据某个字段来查询表中的数据,你可能会这样实现:

```java
@Select("select * from user where id = #{id}")
User findById(@Param("id") long id);//根据id查询

@Select("select * from user where name = #{name}")
User findByName(@Param("name") String name);//根据name查询

@Select("select * from user where email = #{email}")
User findByEmail(@Param("email") String email);//根据email查询
```

> 这样就会造成代码很冗余

这时你可以使用`$`来替换这种写法:

```java
@Select("select * from user where ${column} = #{value}")
User findByColumn(@Param("column") String column, @Param("value") String value);//根据传入的字段名查询即可
```

> 因为其中 `${column}` 会被直接替换，而 `#{value}` 会被使用 `?` 预处理 
>
> 这个想法也同样适用于用来替换表明的情况
>
> 注意: 用这种方式接收用户的输入,并将用于语句中的参数是不安全的,会导致潜在的SQL注入攻击,因此要么不允许用户输入这些字段,要么自行转义并检验

## resultMap(结果映射)

`resultMap` 元素是 MyBatis 中最重要最强大的元素; 它可以让你从 90% 的 JDBC的 `ResultSets` 数据提取代码中解放出来

ResultMap 的设计思想是，对于简单的语句根本不需要配置显式的结果映射，而对于复杂一点的语句只需要描述它们的关系就行了。 

### 简单映射(属性名自动映射)

你已经见过简单映射语句的示例了,但是其中并没有指定`resultMap`,比如:

```xml
<select id="selectUsers" resultType="map">
  select id, username, hashedPassword
  from some_table
  where id = #{id}
</select>
```

> 上述语句只是简单地将所有的列映射到 `HashMap` 的键上，这由 `resultType` 属性指定。虽然在大部分情况下都够用，但是 HashMap 不是一个很好的领域模型。你的程序更可能会使用 JavaBean 或 POJO作为领域模型,  MyBatis 对两者都提供了支持 

看看下面这个 JavaBean: 

```java
package com.someapp.model;
public class User {
  private int id;
  private String username;
  private String hashedPassword;

  public int getId() {
    return id;
  }
  public void setId(int id) {
    this.id = id;
  }
  public String getUsername() {
    return username;
  }
  public void setUsername(String username) {
    this.username = username;
  }
  public String getHashedPassword() {
    return hashedPassword;
  }
  public void setHashedPassword(String hashedPassword) {
    this.hashedPassword = hashedPassword;
  }
}
```

基于 JavaBean 的规范，上面这个类有 3 个属性：id，username 和 hashedPassword。这些属性会对应到 select 语句中的列名 

Mybatis可以把查询后的结果集映射到指定的JavaBean中,就像映射到 `HashMap` 一样简单 :

```xml
<select id="selectUsers" resultType="com.someapp.model.User">
  select id, username, hashedPassword
  from some_table
  where id = #{id}
</select>
```

### 指定映射的名称

在这些情况下,Mybatis会自动创建一个 `ResultMap`,再基于属性名来映射列到Javabean属性上; 如果列名和属性名没有精确匹配,可以在select语句中对列使用别名(这时sql的基本特性)来匹配JavaBean的属性名,例如:

```xml
<select id="selectUsers" resultType="User">
  select
    user_id             as "id",
    user_name           as "userName",
    hashed_password     as "hashedPassword"
  from some_table
  where id = #{id}
</select>
```

`ResultMap` 最优秀的地方在于，虽然你已经对它相当了解了，但是根本就不需要显式地用到他们。 上面这些简单的示例根本不需要下面这些繁琐的配置 ,但是出于需要记录完整的缘故,所以再来看最后一个示例来解决列名不匹配的另外一种方法:

```xml
<resultMap id="userResultMap" type="User">
  <id property="id" column="user_id" />
  <result property="username" column="user_name"/>
  <result property="password" column="hashed_password"/>
</resultMap>
```

 而在引用它的语句中使用 `resultMap` 属性就行了（注意我们去掉了 `resultType` 属性）。比如: 

```xml
<select id="selectUsers" resultMap="userResultMap">
  select user_id, user_name, hashed_password
  from some_table
  where id = #{id}
</select>
```

### 使用类型别名(alias)

使用类型别名可以让你不用输入类的完全限定名称,例如:

```xml
<!-- mybatis-config.xml 中 -->
<typeAlias type="com.someapp.model.User" alias="User"/>

<!-- SQL 映射 XML 中 -->
<select id="selectUsers" resultType="User">
  select id, username, hashedPassword
  from some_table
  where id = #{id}
</select>
```

## (resultMap)高级结果映射

MyBatis 创建时的一个思想是：数据库不可能永远是你所想或所需的那个样子。 我们希望每个数据库都具备良好的第三范式或 BCNF 范式，可惜它们不总都是这样。 如果能有一种完美的数据库映射模式，所有应用程序都可以使用它，那就太好了，但可惜也没有。 而 ResultMap 就是 MyBatis 对这个问题的答案。 

 比如，我们如何映射下面这个语句？ 

```sql
<!-- 非常复杂的语句 -->
<select id="selectBlogDetails" resultMap="detailedBlogResultMap">
  select
       B.id as blog_id,
       B.title as blog_title,
       B.author_id as blog_author_id,
       A.id as author_id,
       A.username as author_username,
       A.password as author_password,
       A.email as author_email,
       A.bio as author_bio,
       A.favourite_section as author_favourite_section,
       P.id as post_id,
       P.blog_id as post_blog_id,
       P.author_id as post_author_id,
       P.created_on as post_created_on,
       P.section as post_section,
       P.subject as post_subject,
       P.draft as draft,
       P.body as post_body,
       C.id as comment_id,
       C.post_id as comment_post_id,
       C.name as comment_name,
       C.comment as comment_text,
       T.id as tag_id,
       T.name as tag_name
  from Blog B
       left outer join Author A on B.author_id = A.id
       left outer join Post P on B.id = P.blog_id
       left outer join Comment C on P.id = C.post_id
       left outer join Post_Tag PT on PT.post_id = P.id
       left outer join Tag T on PT.tag_id = T.id
  where B.id = #{id}
</select>
```

如果我们想把它映射成一个智能的对象模型,这个对象表示一篇博客,它由某位作者所写,有很多博文,每篇博文有零或多条评论和标签; 

我们来看看下面这个完成的例子,它是一个非常复杂的结果映射(假设作者,博客,波文,评论和标签都是类型别名):

```xml
<!-- 非常复杂的结果映射 -->
<resultMap id="detailedBlogResultMap" type="Blog">
  <constructor>
    <idArg column="blog_id" javaType="int"/>
  </constructor>
  <result property="title" column="blog_title"/>
  <association property="author" javaType="Author">
    <id property="id" column="author_id"/>
    <result property="username" column="author_username"/>
    <result property="password" column="author_password"/>
    <result property="email" column="author_email"/>
    <result property="bio" column="author_bio"/>
    <result property="favouriteSection" column="author_favourite_section"/>
  </association>
  <collection property="posts" ofType="Post">
    <id property="id" column="post_id"/>
    <result property="subject" column="post_subject"/>
    <association property="author" javaType="Author"/>
    <collection property="comments" ofType="Comment">
      <id property="id" column="comment_id"/>
    </collection>
    <collection property="tags" ofType="Tag" >
      <id property="id" column="tag_id"/>
    </collection>
    <discriminator javaType="int" column="draft">
      <case value="1" resultType="DraftPost"/>
    </discriminator>
  </collection>
</resultMap>
```

 `resultMap` 元素有很多子元素和一个值得深入探讨的结构。 

下面是`resultMap` 元素的概念视图:

### resultMap的子标签

1. `constructor` - 用于在实例化类时，注入结果到构造方法中
   - `idArg` - ID 参数；标记出作为 ID 的结果可以帮助提高整体性能
   - `arg` - 将被注入到构造方法的一个普通结果
2. `id` – 一个 ID 结果；标记出作为 ID 的结果可以帮助提高整体性能
3. `result` – 注入到字段或 JavaBean 属性的普通结果
4. `association` – 一个复杂类型的关联；许多结果将包装成这种类型
   - 嵌套结果映射 – 关联本身可以是一个 `resultMap` 元素，或者从别处引用一个
5. `collection` – 一个复杂类型的集合
   - 嵌套结果映射 – 集合本身可以是一个 `resultMap` 元素，或者从别处引用一个
6. `discriminator` – 使用结果值来决定使用哪个`resultMap`
   - `case` – 基于某些值的结果映射
     - 嵌套结果映射 – `case` 本身可以是一个 `resultMap` 元素，因此可以具有相同的结构和元素，或者从别处引用一个

---

ResultMap 的属性列表 

| 属性          | 描述                                                         |
| :------------ | :----------------------------------------------------------- |
| `id`          | 当前命名空间中的一个唯一标识，用于标识一个结果映射集。       |
| `type`        | 类的完全限定名, 或者一个类型别名。                           |
| `autoMapping` | 如果设置这个属性，MyBatis将会为本结果映射开启或者关闭自动映射。 这个属性会覆盖全局的属性 autoMappingBehavior。默认值：未设置（unset）。 |

### id & result

```xml
<id property="id" column="post_id"/>
<result property="subject" column="post_subject"/>
```

这些是结果映射最基本的内容。

*id* 和 *result* 元素都将**一个列的值映射到一个简单数据类型**（String, int, double, Date 等）的属性或字段。 

两者不同之处是:  *id* 元素的结果将是对象的标识属性，这会在比较对象实例时用到。 这样可以提高整体的性能，尤其是进行缓存和嵌套结果映射（也就是连接映射）的时候 

---

 Id 和 Result 的属性 

| 属性          | 描述                                                         |
| :------------ | :----------------------------------------------------------- |
| `property`    | 映射Javabean中的字段名称                                     |
| `column`      | 映射数据库中的列名                                           |
| `javaType`    | 用来指定要映射的一个JavaBean对象类型; MyBatis 通常可以推断类型。然而，如果你映射到的是 HashMap，那么你应该明确地指定 javaType 来保证行为与期望的相一致。它的值可以是一个 Java 类的完全限定名，或一个类型别名 |
| `jdbcType`    | JDBC 类型，所支持的 JDBC 类型参见这个表格之后的“支持的 JDBC 类型”。 只需要在可能执行插入、更新和删除的且允许空值的列上指定 JDBC 类型。这是 JDBC 的要求而非 MyBatis 的要求。如果你直接面向 JDBC 编程，你需要对可能存在空值的列指定这个类型。 |
| `typeHandler` | 我们在前面讨论过默认的类型处理器。使用这个属性，你可以覆盖默认的类型处理器。 这个属性值是一个类型处理器实现类的完全限定名，或者是类型别名。 |

### 支持的JDBC类型

为了以后可能的使用场景，MyBatis 通过内置的 jdbcType 枚举类型支持下面的 JDBC 类型。

|            |           |               |                 |           |             |
| ---------- | --------- | ------------- | --------------- | --------- | ----------- |
| `BIT`      | `FLOAT`   | `CHAR`        | `TIMESTAMP`     | `OTHER`   | `UNDEFINED` |
| `TINYINT`  | `REAL`    | `VARCHAR`     | `BINARY`        | `BLOB`    | `NVARCHAR`  |
| `SMALLINT` | `DOUBLE`  | `LONGVARCHAR` | `VARBINARY`     | `CLOB`    | `NCHAR`     |
| `INTEGER`  | `NUMERIC` | `DATE`        | `LONGVARBINARY` | `BOOLEAN` | `NCLOB`     |
| `BIGINT`   | `DECIMAL` | `TIME`        | `NULL`          | `CURSOR`  | `ARRAY`     |

### 构造方法





### 关联

### 关联的嵌套 Select 查询

### 关联的嵌套结果映射

### 关联的多结果集（ResultSet）

### 集合

### 集合的嵌套 Select 查询

### 集合的嵌套结果映射

### 集合的多结果集（ResultSet）

### 鉴别器

## 自动映射

 MyBatis 可以为你自动映射查询结果。但如果遇到复杂的场景，你需要构建一个结果映射 ; 但是Mybatis允许你可以混合使用这两种方式;

### 自动映射查询结果

Mybatis会获取结果中返回的列明并在Java类中查找相同名字的属性(忽略大小写); 这意味着如果发现了ID列和id属性,Mybatis就会将列ID的值赋值给对象的id属性

通过数据库列使用大写字母组成的单词命名,单词间用下划线分隔; 而Java属性一般使用驼峰命名法,为了这两种命名方式之间启动自动映射,需要将  `mapUnderscoreToCamelCase` 设置为 true。 

### 混合使用

甚至在提供了结果映射后，自动映射也能工作。在这种情况下，对于每一个结果映射，在 ResultSet 出现的列，如果没有设置手动映射，将被自动映射。在自动映射处理完毕后，再处理手动映射。 

在下面的例子中，*id* 和 *userName* 列将被自动映射，*hashed_password* 列将根据配置进行映射。 

```xml
<select id="selectUsers" resultMap="userResultMap">
  select
    user_id             as "id",
    user_name           as "userName",
    hashed_password
  from some_table
  where id = #{id}
</select>
```

```xml
<resultMap id="userResultMap" type="User">
  <result property="password" column="hashed_password"/>
</resultMap>
```

### 自定映射等级

有三种自动映射等级：

- `NONE` - 禁用自动映射。仅对手动映射的属性进行映射。
- `PARTIAL` - 对除在内部定义了嵌套结果映射（也就是连接的属性）以外的属性进行映射
- `FULL` - 自动映射所有属性。

默认值是 `PARTIAL`，这是有原因的。当对连接查询的结果使用 `FULL` 时，连接查询会在同一行中获取多个不同实体的数据，因此可能导致非预期的映射。 

>  你可以通过在结果映射上设置 `autoMapping` 属性来为指定的结果映射设置启用/禁用自动映射。 

## 缓存(cache)

MyBatis 内置了一个强大的事务性查询缓存机制，它可以非常方便地配置和定制。 

默认情况下，只启用了本地的会话缓存，它仅仅对一个会话中的数据进行缓存。 要启用全局的二级缓存，只需要在你的 SQL 映射文件中添加一行： 

```xml
<cache/>
```

 这个简单语句的效果如下: 

- 映射语句文件中的所有 select 语句的结果将会被缓存。
- 映射语句文件中的所有 insert、update 和 delete 语句会刷新缓存。
- 缓存会使用最近最少使用算法（LRU, Least Recently Used）算法来清除不需要的缓存。
- 缓存不会定时进行刷新（也就是说，没有刷新间隔）。
- 缓存会保存列表或对象（无论查询方法返回哪种）的 1024 个引用。
- 缓存会被视为读/写缓存，这意味着获取到的对象并不是共享的，可以安全地被调用者修改，而不干扰其他调用者或线程所做的潜在修改。

> 注意:  缓存只作用于 cache 标签所在的映射文件中的语句。如果你混合使用 Java API 和 XML 映射文件，在共用接口中的语句将不会被默认缓存。你需要使用 @CacheNamespaceRef 注解指定缓存作用域。 

 上述的效果可以通过 cache 元素的属性来修改。比如： 

```xml
<cache
  eviction="FIFO"
  flushInterval="60000"
  size="512"
  readOnly="true"/>
```

> 这个更高级的配置创建了一个 FIFO 缓存，每隔 60 秒刷新，最多可以存储结果对象或列表的 512 个引用，而且返回的对象被认为是只读的，因此对它们进行修改可能会在不同线程中的调用者产生冲突 

可用的清除策略有：

- `LRU` – 最近最少使用：移除最长时间不被使用的对象。
- `FIFO` – 先进先出：按对象进入缓存的顺序来移除它们。
- `SOFT` – 软引用：基于垃圾回收器状态和软引用规则移除对象。
- `WEAK` – 弱引用：更积极地基于垃圾收集器状态和弱引用规则移除对象。

默认的清除策略是 LRU。

flushInterval（刷新间隔）属性可以被设置为任意的正整数，设置的值应该是一个以毫秒为单位的合理时间量。 默认情况是不设置，也就是没有刷新间隔，缓存仅仅会在调用语句时刷新。

size（引用数目）属性可以被设置为任意正整数，要注意欲缓存对象的大小和运行环境中可用的内存资源。默认值是 1024。

readOnly（只读）属性可以被设置为 true 或 false。只读的缓存会给所有调用者返回缓存对象的相同实例。 因此这些对象不能被修改。这就提供了可观的性能提升。而可读写的缓存会（通过序列化）返回缓存对象的拷贝。 速度上会慢一些，但是更安全，因此默认值是 false。

>  二级缓存是事务性的。这意味着，当 SqlSession 完成并提交时，或是完成并回滚，但没有执行 flushCache=true 的 insert/delete/update 语句时，缓存会获得更新。 

### 使用自定义缓存

 除了上述自定义缓存的方式，你也可以通过实现你自己的缓存，或为其他第三方缓存方案创建适配器，来完全覆盖缓存行为。 

```xml
<cache type="com.domain.something.MyCustomCache"/>
```

 这个示例展示了如何使用一个自定义的缓存实现。type 属性指定的类必须实现 org.mybatis.cache.Cache 接口，且提供一个接受 String 参数作为 id 的构造器。 这个接口是 MyBatis 框架中许多复杂的接口之一，但是行为却非常简单。 

```java
public interface Cache {
  String getId();
  int getSize();
  void putObject(Object key, Object value);
  Object getObject(Object key);
  boolean hasKey(Object key);
  Object removeObject(Object key);
  void clear();
}
```

### cache-ref

略

# 动态sql

 MyBatis 的强大特性之一便是它的动态 SQL ,  如果你有使用 JDBC 或其它类似框架的经验，你就能体会到根据不同条件拼接 SQL 语句的痛苦。例如拼接时要确保不能忘记添加必要的空格，还要注意去掉列表最后一个列名的逗号等。利用动态 SQL 这一特性可以彻底摆脱这种痛苦 

 动态 SQL 元素和 JSTL 或基于类似 XML 的文本处理器相似; MyBatis 3 大大精简了元素种类, 现在只需学习原来一半的元素便可。MyBatis 采用功能强大的基于 OGNL 的表达式来淘汰其它大部分元素。 

现在只需掌握以下几种元素:

- if
- choose (when, otherwise)
- trim (where, set)
- foreach

## if

动态SQL通常要做的事情是根据条件拼接where子句的条件,比如:

```xml
<select id="findActiveBlogWithTitleLike"
     resultType="Blog">
  SELECT * FROM BLOG
  WHERE state = ‘ACTIVE’
  <if test="title != null">
    AND title like #{title}
  </if>
</select>
```

> 这条sql语句提供了一种可选的查询文本功能; 如果没有传入"title"字段,那么所有处于"ACTIVE"状态的BLOG都会返回; 反之若传入"title"字段,那么就会对"title"进行模糊查询并返回BLOG结果

## choose,when,otherwise

有时我们不想应用到所有的条件语句,而只想从中选择一项; 针对这种情况,Mybatis提供了choose元素,它有点像Java中的switch语句

```xml
<select id="findActiveBlogLike"
     resultType="Blog">
  SELECT * FROM BLOG WHERE state = ‘ACTIVE’
  <choose>
    <when test="title != null">
      AND title like #{title}
    </when>
    <when test="author != null and author.name != null">
      AND author_name like #{author.name}
    </when>
    <otherwise>
      AND featured = 1
    </otherwise>
  </choose>
</select>
```

## trim

在我们使用if标签时,我们有时会遇到这样的情况:

```xml
<select id="findActiveBlogLike"
     resultType="Blog">
  SELECT * FROM BLOG
  WHERE
  <if test="state != null">
    state = #{state}
  </if>
  <if test="title != null">
    AND title like #{title}
  </if>
</select>
```

当我们没有传入state和title字段时,最后的sql会变成这样:

```sql
SELECT * FROM BLOG
WHERE
```

这样会导致查询失败; 如果传入第二个title字段,sql则会变成这样:

```sql
SELECT * FROM BLOG
WHERE
AND title like ‘someTitle’
```

这样也会导致查询失败

因此这种问题不能简单的用条件语句来决解,但是我们可以通过Mybatis提供的`trim`标签来解决该问题

我们可以通过自定义 trim 元素来定制 *where* 元素的功能。比如，和 *where* 元素等价的自定义 trim 元素为： 

```xml
<trim prefix="WHERE" prefixOverrides="AND">
  <if test="state != null">
    And state = #{state}
  </if>
  <if test="title != null">
    AND title like #{title}
  </if>
</trim>
```

> `prefix="where"`定义了在trim包裹的代码前面添加"where"
>
> `prefixOverrides="AND"`可以去除掉最前面多余的"AND"
>
> `suffix="where"`可以在trim包裹的代码后面添加"where"
>
> `suffixOverrides=","`可以去除掉最后面多余的","

## where

```xml
<select id="selectTest" resultType="test2.User">
    SELECT * from USER
    <where>
        <if test="id!=null">and id=#{id}</if>
        <if test="age!=null">and age=#{age}</if>
    </where>
</select>
```

> 使用where标签后,Mybatis会把帮我们把多余的and自动去除掉

这个也可以通过trim标签实现

```xml
<select id="selectTest" resultType="test2.User">
    SELECT * from USER
    <!-- prefixOverrides表示去除掉最前面多余的and -->
    <trim prefix="where" prefixOverrides="and">
        <if test="id!=null">and id=#{id}</if>
        <if test="age!=null">and age=#{age}</if>
    </trim>,
</select>
```

## set

```xml
<update id="upateTest" parameterType="test2.User">
     update USER
     <set>
         <if test="age!=null">age=#{age},</if>
         <if test="name!=null">name=#{name},</if>
     </set>
     where id=#{id},
</update>
```

> 使用set标签后,Mybatis会帮我们把多余的`,`自动去除掉

这个也可以通过trim标签实现

```xml
<update id="upateTest" parameterType="test2.User">
     update USER
     <!-- suffixOverrides表示去除最后多余的逗号 -->
     <trim prefix="set" suffixOverrides=",">
         <if test="age!=null">age=#{age},</if>
         <if test="name!=null">name=#{name},</if>
     </trim>
     where id=#{id}
</update>
```

## foreach

动态 SQL 的另外一个常用的操作需求是对一个集合进行遍历，通常是在构建 IN 条件语句的时候。比如： 

```xml
<select id="selectPostIn" resultType="domain.blog.Post">
  SELECT *
  FROM POST P
  WHERE ID in
  <foreach item="item" index="index" collection="list"
      open="(" separator="," close=")">
        #{item}
  </foreach>
</select>
```

foreach元素的功能非常强大,它允许你指定一个集合,声明可以在元素内使用的集合项(item)和索引(index)变量; 它也允许你指定开头与结尾的字符串以及在迭代结果之间放置分隔符; 这个元素很之恩那个,因此它不会附加多余的分隔符

> `item="item"`指明了在foreach循环中取到的每个变量可以通过#{item}来获取到
>
> `index="index"`指明了指明了在foreach循环中取到的每个变量的索引
>
> `collection="list"`指明了去遍历哪个传入的参数,其变量名称为list
>
> `open="(" separator="," close=")"`表示了在遍历拼接时,最前面和最后面使用`(`和`)`包裹,中间的每个元素使用`,`来进行分隔

## bind

bind元素可以从OGNL表达式中创建一个变量并将其绑定到上下文中,比如:

```xml
<select id="selectBlogsLike" resultType="Blog">
  <!-- 定义一个变量名称为patter,其值可以在bind元素中做一些修改,patter可以在这个select的上下文中使用 -->
  <bind name="pattern" value="'%' + _parameter.getTitle() + '%'" />
  SELECT * FROM BLOG
  WHERE title LIKE #{pattern}
</select>
```

## 多数据库支持(例如没有自增主键的数据库)

 一个配置了“_databaseId”变量的 databaseIdProvider 可用于动态代码中，这样就可以根据不同的数据库厂商构建特定的语句。比如下面的例子： 

```xml
<insert id="insert">
  <!-- 在执行insert之前先查出数据库中id的最大值,然后再将查询出的id做insert操作的id值 -->
  <selectKey keyProperty="id" resultType="int" order="BEFORE">
    <if test="_databaseId == 'oracle'">
      select seq_users.nextval from dual
    </if>
    <if test="_databaseId == 'db2'">
      select nextval for seq_users from sysibm.sysdummy1"
    </if>
  </selectKey>
  insert into users values (#{id}, #{name})
</insert>
```

# Mybatis Java API

https://mybatis.org/mybatis-3/zh/java-api.html

## 目录结构

## SqlSession

```java
<T> T selectOne(String statement, Object parameter)
<E> List<E> selectList(String statement, Object parameter)
<T> Cursor<T> selectCursor(String statement, Object parameter)
<K,V> Map<K,V> selectMap(String statement, Object parameter, String mapKey)
int insert(String statement, Object parameter)
int update(String statement, Object parameter)
int delete(String statement, Object parameter)
```

### 事务控制方法

 控制事务作用域有四个方法。当然，如果你已经设置了自动提交或你正在使用外部事务管理器，这就没有任何效果了。然而，如果你正在使用 JDBC 事务管理器，由Connection 实例来控制，那么这四个方法就会派上用场： 

```java
void commit()
void commit(boolean force)
void rollback()
void rollback(boolean force)
```

默认情况下 MyBatis 不会自动提交事务，除非它侦测到有插入、更新或删除操作改变了数据库。如果你已经做出了一些改变而没有使用这些方法，那么你可以传递 true 值到 commit 和 rollback 方法来保证事务被正常处理（注意，在自动提交模式或者使用了外部事务管理器的情况下设置 force 值对 session 无效）。很多时候你不用调用 rollback()，因为 MyBatis 会在你没有调用 commit 时替你完成回滚操作。然而，如果你需要在支持多提交和回滚的 session 中获得更多细粒度控制，你可以使用回滚操作来达到目的。 

### 本地缓存

Mybatis 使用到了两种缓存：本地缓存（local cache）和二级缓存（second level cache）

每当一个新 session 被创建，MyBatis 就会创建一个与之相关联的本地缓存。任何在 session 执行过的查询语句本身都会被保存在本地缓存中，那么，相同的查询语句和相同的参数所产生的更改就不会再次影响数据库了 ; 本地缓存会被增删改、提交事务、关闭事务以及关闭 session 所清空。 

默认情况下，本地缓存数据可在整个 session 的周期内使用，这一缓存需要被用来解决循环引用错误和加快重复嵌套查询的速度，所以它可以不被禁用掉，但是你可以设置 localCacheScope=STATEMENT 表示缓存仅在语句执行时有效 

注意，如果 localCacheScope 被设置为 SESSION，那么 MyBatis 所返回的引用将传递给保存在本地缓存里的相同对象。对返回的对象（例如 list）做出任何更新将会影响本地缓存的内容，进而影响存活在 session 生命周期中的缓存所返回的值。因此，不要对 MyBatis 所返回的对象作出更改，以防后患。

你可以随时调用以下方法来清空本地缓存：

```java
void clearCache()
```

### 确保 SqlSession 被关闭

```java
void close()
```

### 显示的获取映射器

```java
<T> T getMapper(Class<T> type)
```

### Mybatis注解API和示例

[映射器注解的API](https://mybatis.org/mybatis-3/zh/java-api.html#a.E6.98.A0.E5.B0.84.E5.99.A8.E6.B3.A8.E8.A7.A3)

# sql语句构建器

略

# 缓存

## 一级缓存

Mybatis的一级缓存的作用域是在一个session中,当openSession()后,如果执行相同的SQL(相同语句和参数),Mybaits不会执行sql,而是从缓存中命中并返回结果

原理:

Mybatis执行查询时首先去缓存区查询,如果命中直接返回缓存结果,没有命中才执行sql,从数据库中查询

> 在Mybatis中,一级缓存默认时开启的,并且一直无法关闭

使用一级缓存的条件:

- 同一个session中
- 相同的SQL和参数进行查询

---

示例:

```java
public class MybatisTest {
    public static void main(String[] args) throws Exception {
        // 指定全局配置文件
        String resource = "test2/mybatis-config.xml";
        // 读取配置文件
        InputStream inputStream = Resources.getResourceAsStream(resource);
        // 构建sqlSessionFactory
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        // 获取sqlSession
        SqlSession sqlSession = sqlSessionFactory.openSession();
        try {
            //查询
            User user = sqlSession.selectOne("MyMapper.selectUser", 1);
            User user1 = sqlSession.selectOne("MyMapper.selectUser", 1);
        } finally {
            //关闭sqlSession
            sqlSession.close();
        }
    }
}
```

> 在同一个session中查询同一个sql和参数

日志的打印结果:

> DEBUG [main] - ==>  Preparing: select * from user where id = ? 
> DEBUG [main] - ==> Parameters: 1(Integer)
> DEBUG [main] - <==      Total: 0

从日志来看,对应的查询sql只执行了一次,由此推断,在同一个session中,相同的sql和参数重复查询时会从一级缓存中获取了对应的结果

## 二级缓存

Mybatis的**二级缓存的作用域是一个mapper的namespace**,同一namespace中查询sql可以从缓存中命中

开启二级缓存步骤:

1. 在对应的mapper中开启二级缓存

   ```xml
   <mapper namespace="com.zpc.mybatis.dao.UserMapper">
       <cache/> <!-- 开启二级缓存 -->
       ...
   </mapper>
   ```

2. 开启二级缓存时,使用的JavaBean必须要序列化(实现Serializable接口)

   ```java
   public class User implements Serializable{
       private static final long serialVersionUID = -3330851033429007657L;
   ```

开启二级缓存后,使用同一个mapper查询数据,如果参数相同,则会返回二级缓存中缓存的结果

> 此时,不在同一个session中也会有缓存

---

关闭二级缓存的两种方式:

- 不开启(默认是不开启的)

- 在全局的mybatis-config.xml 中去关闭二级缓存 

  ```xml
  <settings>
      <!--开启二级缓存,全局总开关，这里关闭，mapper中开启了也没用-->
      <setting name="cacheEnabled" value="false"/>
  </settings>
  ```

# 日志

Mybatis 的内置日志工厂提供日志功能，内置日志工厂将日志交给以下其中一种工具作代理： 

- SLF4J
- Apache Commons Logging
- Log4j 2
- Log4j
- JDK logging

MyBatis 内置日志工厂基于运行时自省机制选择合适的日志工具。它会使用第一个查找得到的工具（按上文列举的顺序查找）。如果一个都未找到，日志功能就会被禁用。 

---

以下是开启日志记录的步骤:

1. 我们可以在` mybatis-config.xml `配置文件中开启日志功能:

   ```xml
   <configuration>
       <!-- 开启日志功能 -->
       <settings>
           <setting name="logImpl" value="LOG4J"/>
       </settings>
   </configuration>
   ```

   > 注意: `settings`标签的位置在`configuration`标签中是有要求的,如果位置不正确会报排列顺序错误
   >
   > `settings`标签需要在`properties`标签和`environments`标签中间

2. 在pom文件中引入log4j的依赖

   ```xml
   <dependency>
       <groupId>log4j</groupId>
       <artifactId>log4j</artifactId>
       <version>1.2.17</version>
   </dependency>
   ```

3. 在项目的静态资源根路径创建`log4j.properties`配置文件

   ```properties
   # Global logging configuration
   log4j.rootLogger=ERROR, stdout
   
   # MyBatis logging configuration...
   # 指定需要打印的映射文件的命令空间即可(仅针对于xml的映射文件)
   log4j.logger.MyMapper=TRACE
   # 如果需要指定接口注解的映射则指定该类的全限定类名即可(log4j.logger保持不变)
   # log4j.logger.com.lyj.MyMapper=TRACE
   
   # Console output...
   log4j.appender.stdout=org.apache.log4j.ConsoleAppender
   log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
   log4j.appender.stdout.layout.ConversionPattern=%5p [%t] - %m%n
   ```

---

我们可以通过设定日志级别来记录应该输出的日志:

- trace： 是追踪，就是程序推进以下，你就可以写个trace输出，所以trace应该会特别多，不过没关系，我们可以设置最低日志级别不让他输出。
- debug： 调试么，我一般就只用这个作为最低级别，trace压根不用。是在没办法就用eclipse或者idea的debug功能就好了么。
- info： 输出一下你感兴趣的或者重要的信息，这个用的最多了。
- warn： 有些信息不是错误信息，但是也要给程序员的一些提示，类似于eclipse中代码的验证不是有error 和warn（不算错误但是也请注意，比如以下depressed的方法）。
- error： 错误信息。用的也比较多。
- fatal： 级别比较高了。重大错误，这种级别你可以直接停止程序了，是不应该出现的错误么！不用那么紧张，其实就是一个程度的问题

# Spring集成Mybatis

# Mybatis插件

## Mybatis Generator的使用

略

## Mybatis整合分页插件pageHelper

略

# 参考文档

[Mybatis实战教程](https://blog.csdn.net/hellozpc/article/details/80878563)

[Mybatis中文官网](https://mybatis.org/mybatis-3/zh/getting-started.html)