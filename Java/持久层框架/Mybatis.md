[TOC]

# 简介

Mybatis是一款优秀的持久层框架,它支持定制化sql,存储过程以及高级映射; Mybatis避免了几乎所有的JDBC代码和手动设置参数已经获取结果集; Mybatis可以使用简单的XML或注解来配置和映射原生类型,接口和Java中的POJO(Plain Old Java Object,普通老式Java对象)为数据库中的记录

# 传统的JDBC

## Demo

1. 创建一个maven项目

2. 引入mysql的maven依赖

   ```maven
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

![img](.img/.Mybatis/20180624002302854.png)

![img](.img/.Mybatis/20141028140852531.png)

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

![这里写图片描述](.img/.Mybatis/20171202184841388.png)

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
- `sql` – 可被其他语句引用的可重用语句块
- `cache` – 对给定命名空间的缓存配置。
- `cache-ref` – 对其他命名空间缓存配置的引用。
- `resultMap` – 是最复杂也是最强大的元素，用来描述如何从数据库结果集中来加载对象
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

## select

## insert, update 和 delete

## sql(sql片段)

 这个元素可以被用来定义可重用的 SQL 代码段 

## association(关联sql片段) 

## 参数

### resultType

### parameterType

### 字符串替换

## resultMap(结果映射)

 `resultMap` 元素是 MyBatis 中最重要最强大的元素 

### id & result

### 支持的 JDBC 类型

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

### 自动映射

## cache(缓存)

## cache-ref

# 动态sql

# sql语句构建起

# 缓存

# 日志

# Mybatis使用Demo

## 基于 XML Demo

## 基于 注解 Demo

# Spring集成Mybatis

# Mybatis插件

## Mybatis Generator的使用

## Mybatis整合分页插件pageHelper



# 参考文档

[Mybatis实战教程](https://blog.csdn.net/hellozpc/article/details/80878563)

[Mybatis中文官网](https://mybatis.org/mybatis-3/zh/getting-started.html)