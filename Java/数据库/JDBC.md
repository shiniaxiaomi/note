# 介绍

JDBC(Java DataBase Connection) 是Java和数据库之间的一个桥梁,是一个规范而不是一个具体实现; 它是规定了与数据库操作的接口,每个不同类型的数据库都由其对应的实现,如下图所示:

![img](/Users/yingjie.lu/Documents/note/.img/20180729201036257-1571496804890.png)

接下来使用mysql数据库的对JDBC接口的实现(`mysql-connector-java`)来进行演示JDBC编程

# JDBC编程

JDBC是规定了于数据库操作的接口,而`mysql-connector-java`是实现了JDBC接口的并可以与mysql数据库完成数据库操作的实现类

1. 引入mysql驱动的依赖

   ```xml
   <dependency>
       <groupId>mysql</groupId>
       <artifactId>mysql-connector-java</artifactId>
       <version>5.1.32</version>
   </dependency>
   ```

2. 使用JDBC查询数据

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

   





























