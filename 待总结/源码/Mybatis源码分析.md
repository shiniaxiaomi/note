https://mybatis.org/mybatis-3/zh/project-info.html

## 最简单的demo

```java
public class Test {
    public static void main(String[] args) {
        //创建数据源
        HikariDataSource hikariDataSource = new HikariDataSource();
        hikariDataSource.setJdbcUrl("jdbc:mysql://localhost:3306/test");
        hikariDataSource.setUsername("root");
        hikariDataSource.setPassword("123456");

        //添加配置和mapper
        TransactionFactory transactionFactory = new JdbcTransactionFactory();
        Environment environment = new Environment("development", transactionFactory, hikariDataSource);
        Configuration configuration = new Configuration(environment);
        configuration.addMapper(UserMapper.class);

        //通过配置类创建sqlSessionFactory
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(configuration);

        //开启一个session(session会自动关闭)
        try (SqlSession session = sqlSessionFactory.openSession()) {
            UserMapper mapper = session.getMapper(UserMapper.class);
            User user = mapper.getUser(1);
            System.out.println(user);
        }
    }
}
```

> 先创建数据源，然后创建配置类，通过配置类生成sqlSessionFactory，通过sqlSessionFactory就可以拿到一个sqlSession，可以从sqlSession中拿到对应的mapper的实现类（就可以进行增删改查）

## 源码调试技巧

因为mybatis最终会把结果集封装到实体类中，所以我们在实体类的set方法中打一个断点，然后再查看调用栈就会更清晰



## 源码解析

注册mapper接口

org.apache.ibatis.binding.MapperRegistry#addMapper

```java
public <T> void addMapper(Class<T> type) {
	//如果传入的是一个接口
    if (type.isInterface()) {
        //如果已经注册过，则抛出异常
        if (this.hasMapper(type)) {
            throw new BindingException("Type " + type + " is already known to the MapperRegistry.");
        }

        boolean loadCompleted = false;

        try {
            this.knownMappers.put(type, new MapperProxyFactory(type));
            MapperAnnotationBuilder parser = new MapperAnnotationBuilder(this.config, type);
            parser.parse();
            loadCompleted = true;
        } finally {
            if (!loadCompleted) {
                this.knownMappers.remove(type);
            }

        }
    }

}
```



mybatis通过jdk的动态代理生成的代理类:

- MapperProxy类实现了InvocationHandler接口





org.apache.ibatis.binding.MapperMethod#execute

```java

```

## 流程

1. 在配置类中添加mapper接口，创建sqlSessionFactory
2. 通过sqlSessionFactory第一次拿对应接口（getMapper）的时候，会去生成接口的代理类
3. 拿到代理类后，调用对应的方法会执行invoke方法，在invoke方法中可以拿到调用方法的名称，参数和返回值，之后会调用org.apache.ibatis.session.defaults.DefaultSqlSession#selectOne(java.lang.String, java.lang.Object)方法，先看一下缓存中是否有，如果没有，再在org.apache.ibatis.executor.BaseExecutor#queryFromDatabase方法中，会去真正的查询数据库，并将查询结构进行缓存
4. 在org.apache.ibatis.executor.SimpleExecutor#doQuery方法中，处理好了PreparedStatement对象
5. 在org.apache.ibatis.executor.statement.PreparedStatementHandler#query方法中，执行PreparedStatement.execute()的方法，然后org.apache.ibatis.executor.resultset.DefaultResultSetHandler#applyAutomaticMappings方法中做数据绑定，最终是通过反射调用的实体类的set方法将值设置进去
6. 最后返回实体类

## 参考

https://www.cnblogs.com/wuzhenzhao/p/11103017.html

整个源码的过程所涉及的核心类： 

![img](D:\note\.img\1383365-20190702152319339-1998015172.png)



---

一般我们都使用以下这种方式创建sqlSessionFactory：

```java
SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(configuration);
```

使用这种方式创建的时候，如果我们在Configuration对象中添加的对应的mapper接口，那么在org.apache.ibatis.builder.annotation.MapperAnnotationBuilder#parse方法中，会先去加载同路径下的xml文件，然后再加载接口信息，





org.apache.ibatis.builder.annotation.MapperAnnotationBuilder#parseStatement：解析sql，预处理