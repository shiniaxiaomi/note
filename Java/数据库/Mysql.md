# 介绍

数据库

# 安装

- Mac安装

  ```shell
  brew install mysql
  ```

  安装成功后，可以使用`brew info mysql`来查看mysql启动的相关命令

  如：

  ```shell
  $ brew info mysql
  
  mysql_secure_installation #设置数据库登入密码
  mysql -u root -p #登入mysql
  brew services start mysql #设置开机启动
  mysql.server start #手动启动
  mysql.server stop #手动停止
  ```

- Ubuntu安装

  最新的Ubuntu版本是安装好mysql的，但是mysql是无密码的，需要修改

  1. 修改密码

  2. 开启远程连接

     ```shell
     sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
     ```

     将`bind-address = 127.0.0.1`改为`bind-address = 0.0.0.0`即可

  3. 修改mysql数据库

     登入mysql数据库：`mysql -u root -p`

     ```mysql
     use mysql; #使用mysql数据库
     select User,authentication_string,Host from user; #查询用户表，可以看到权限都是只针对localhost的
     
     # 创建一个自己的mysql账号，最好不要使用root账号
     GRANT ALL PRIVILEGES ON *.* TO '账号'@'%' IDENTIFIED BY '密码'; #只需要修改当中的账号和密码即可
     
     # 账号创建成功后，刷新权限
     flush privileges;
     ```

     当上述步骤都成功后，退出mysql，并重启mysql服务

     ```shell
     service mysql restart
     ```

     重启成功后，这时你就可以使用你刚创建的账号登入了

     ```shell
     mysql -u lyj -p
     # 输入你的密码即可
     ```

# 登入

```shell
mysql -u root -p
# 再输入密码即可登入
```

# 操作

查看数据库

```mysql
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.00 sec)
```

创建数据库

```mysql
mysql> create database test;
Query OK, 1 row affected (0.01 sec
```

删除数据库

```mysql
mysql> drop database test;
Query OK, 0 rows affected (0.00 sec)
```

使用数据库

```mysql
mysql> use test;
Database changed
```

创建数据库表

```mysql
create table user (
	`id` int unsigned auto_increment,
  `name` varchar(20),
  `age` int,
  primary key (`id`)
) engine=innodb default charset=utf8;
```

查看数据表结构

```mysql
desc user;
```

删除数据库表

```mysql
mysql> drop table user;
Query OK, 0 rows affected (0.01 sec)
```

查看数据库表

```shell
mysql> show tables;
+----------------+
| Tables_in_test |
+----------------+
| user           |
+----------------+
1 row in set (0.00 sec)
```

插入数据

```mysql
mysql> insert into user (name,age) values ('jack',1);
Query OK, 1 row affected (0.00 sec)
```

查询数据

```mysql
mysql> select * from user;
+----+------+------+
| id | name | age  |
+----+------+------+
|  1 | jack |    1 |
+----+------+------+
1 row in set (0.00 sec)
```

使用where查询数据

```mysql
mysql> select * from user where id=1;
+----+------+------+
| id | name | age  |
+----+------+------+
|  1 | jack |    1 |
+----+------+------+
1 row in set (0.00 sec)
```

更新数据

```mysql
mysql> update user set name='jack3',age=3 where id=1;
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0
```

删除数据

```mysql
mysql> delete from user where id=1;
Query OK, 1 row affected (0.00 sec)
```

模糊查询

```mysql
mysql> select * from user where name like '%ja%';
+----+------+------+
| id | name | age  |
+----+------+------+
|  2 | jack |    1 |
+----+------+------+
1 row in set (0.00 sec)
```

union操作

```mysql
mysql> select * from user where id=2
union 
select * from user where id=2;
+----+------+------+
| id | name | age  |
+----+------+------+
|  2 | jack |    1 |
+----+------+------+
1 row in set (0.00 sec)
```

> 连接两个以上的 SELECT 语句的结果组合到一个结果集合中; 多个 SELECT 语句会删除重复的数据。
>
> 参数：
>
> - **expression1, expression2, ... expression_n**: 要检索的列。
> - **tables:** 要检索的数据表。
> - **WHERE conditions:** 可选， 检索条件。
> - **DISTINCT:** 可选，删除结果集中重复的数据。默认情况下 UNION 操作符已经删除了重复数据，所以 DISTINCT 修饰符对结果没啥影响。
> - **ALL:** 可选，返回所有结果集，包含重复数据。

排序

- 降序

  ```mysql
  mysql> select * from user order by age desc;
  +----+-------+------+
  | id | name  | age  |
  +----+-------+------+
  |  3 | jack2 |    2 |
  |  2 | jack  |    1 |
  +----+-------+------+
  2 rows in set (0.00 sec)
  ```

- 升序

  ```mysql
  mysql> select * from user order by age asc;
  +----+-------+------+
  | id | name  | age  |
  +----+-------+------+
  |  2 | jack  |    1 |
  |  3 | jack2 |    2 |
  +----+-------+------+
  2 rows in set (0.00 sec)
  ```

分组

在分组的列上我们必须使用count，sum，avg，group_concat()等其中一个或多个函数

示例：

先查询数据：

```mysql
mysql> select * from user;
+----+-------+------+
| id | name  | age  |
+----+-------+------+
|  2 | jack  |    1 |
|  3 | jack2 |    2 |
|  4 | jack3 |    2 |
+----+-------+------+
3 rows in set (0.00 sec)
```

根据年龄进行分组

```mysql
mysql> select age,group_concat(name) from user group by age;
+------+--------------------+
| age  | group_concat(name) |
+------+--------------------+
|    1 | jack               |
|    2 | jack2,jack3        |
+------+--------------------+
2 rows in set (0.00 sec)
```

表连接

创建一个teacher表

```mysql
create table teacher (
	`id` int auto_increment,
  `name` varchar(20),
  `student_id` int,
  primary key(`id`)
) engine=innodb default charset=utf8;
```

插入数据

```mysql
insert into teacher (name,student_id) values ('teacher1',2);
insert into teacher (name,student_id) values ('teacher1',3);
```

关联查询

- 内连接（等值连接）

  只筛选出两边都对应值的数据

  ```mysql
  mysql> select * from user inner join teacher on teacher.student_id=user.id;
  +----+-------+------+----+----------+------------+
  | id | name  | age  | id | name     | student_id |
  +----+-------+------+----+----------+------------+
  |  2 | jack  |    1 |  1 | teacher1 |          2 |
  |  3 | jack2 |    2 |  2 | teacher1 |          3 |
  +----+-------+------+----+----------+------------+
  2 rows in set (0.00 sec)
  ```

- 左连接

  ```mysql
  mysql> select user.*,teacher.name from user left join teacher on teacher.student_id=user.id;
  +----+-------+------+----------+
  | id | name  | age  | name     |
  +----+-------+------+----------+
  |  2 | jack  |    1 | teacher1 |
  |  3 | jack2 |    2 | teacher1 |
  |  4 | jack3 |    2 | NULL     |
  +----+-------+------+----------+
  3 rows in set (0.00 sec)
  ```

- 右连接

  右连接和左连接相似

- 单纯的join（笛卡尔乘积）

  ```mysql
  mysql> select * from user join teacher ;
  +----+-------+------+----+----------+------------+
  | id | name  | age  | id | name     | student_id |
  +----+-------+------+----+----------+------------+
  |  2 | jack  |    1 |  1 | teacher1 |          2 |
  |  2 | jack  |    1 |  2 | teacher1 |          3 |
  |  3 | jack2 |    2 |  1 | teacher1 |          2 |
  |  3 | jack2 |    2 |  2 | teacher1 |          3 |
  |  4 | jack3 |    2 |  1 | teacher1 |          2 |
  |  4 | jack3 |    2 |  2 | teacher1 |          3 |
  +----+-------+------+----+----------+------------+
  6 rows in set (0.00 sec)
  ```

Null值的处理

- `is null`: 当列的值是null的时候，返回true
- `is not null`: 当列的值不为null的时候，返回true

正则表达式

示例：

查询数据：

```mysql
mysql> select * from user;
+----+-------+------+
| id | name  | age  |
+----+-------+------+
|  2 | jack  |    1 |
|  3 | jack2 |    2 |
|  4 | jack3 |    2 |
+----+-------+------+
3 rows in set (0.00 sec)
```

使用正则查询

```mysql
mysql> select * from user where name regexp 'jack[23]';
+----+-------+------+
| id | name  | age  |
+----+-------+------+
|  3 | jack2 |    2 |
|  4 | jack3 |    2 |
+----+-------+------+
2 rows in set (0.00 sec)
```

# 事务

1、用 BEGIN, ROLLBACK, COMMIT来实现

- **BEGIN** 开始一个事务
- **ROLLBACK** 事务回滚
- **COMMIT** 事务确认

2、直接用 SET 来改变 MySQL 的自动提交模式:

- **SET AUTOCOMMIT=0** 禁止自动提交
- **SET AUTOCOMMIT=1** 开启自动提交

# alter命令

删除字段

```mysql
alter table user drop `age`; #删除age字段
```

添加字段

```mysql
alter table user add `age` int; #增加age字段
```

修改表字段

```mysql
alter table user modify name varchar(30); #将name字段的长度修改为30
```

修改表字段是否允许为空和默认值

```mysql
alter table user modify name varchar(30) not null default '100';
# 设置name字段长度为30，并且不能为空，默认值为“100”
```

# 索引

前提：

现创建一张没有索引的student表

```mysql
create table student (
	`id` int,
  `name` varchar(20)
) engine=innodb default charset=utf8;
```

创建普通索引

```mysql
create index name on student(name(20)); #创建name字段索引
create index id on student(id); #创建id字段索引 
```

> 字段（长度）只是在创建字段类型为字符时需要指定的，索引字段长度不能超过字段本身的长度

创建唯一索引

```mysql
create unique index id on student(id); #创建id字段唯一索引
```

创建主键索引

```mysql
alter table student add primary key(id);
alter table student 
```

删除主键索引

```mysql
alter table student drop primary key;
```

查看索引

```mysql
show index from student;
```

删除索引

```mysql
mysql> drop index name on student;
Query OK, 0 rows affected (0.01 sec)
Records: 0  Duplicates: 0  Warnings: 0
```

# 临时表

Mysql临时表只在当前连接可见，当关闭连接时，Mysql会自动删除表并释放所有空间

# 过滤重复数据

```mysql
select distinct * from user;
```

# SQL注入

如果将从网页中获取到用户输入的数据并将其插入一个mysql数据库中，那么就有可能发生sql注入安全的问题

示例：

以下是通过名称查询用户的sql

```mysql
select * from user where name=${name}
```

如果你通过替换的方式把`${name}`替换成用户输入的用户名，用来进行查询，那么就会出现sql注入问题

例如：

用户输入的用户名为

`jack;delete from user;`

那么我们替换后的sql语句将会是：

```mysql
select * from user where name=jack;delete from user;
```

那么，这一次查询操作就会将我们数据库中的user表给删除掉了

因此，我们在进行数据操作时，不能进行简单的参数替换，我们需要注意以下几点：

- 永远不要相信用户的输入，必须要对用户的输入进行校验
- 永远不要动态的拼接sql，可以使用参数话的sql等
- 应用的异常信息应该给出尽可能少的提示，最好会用自定义的错误信息进行包装

# Mysql函数

https://www.runoob.com/mysql/mysql-functions.html

# Mysql运算符

https://www.runoob.com/mysql/mysql-operator.html



# 其他问题

## mysql时区差8小时问题

1. 修改my.cof文件

   在`[mysqld]`后面添加`default-time_zone = '+8:00'`

2. 修改数据库连接的url

   在url后面添加`?serverTimezone=GMT%2B8`

## mysql中文乱码问题

[参考文档](https://www.cnblogs.com/jasonzeng/p/8341445.html)

从根本上解决问题，我们就需要修改mysql的`my.cnf`配置文件中编码格式，然后重启mysql即可，那么之后创建的表默认都会以utf8格式创建

1. 修改`my.cnf`配置文件

   该文件一般位于`/etc/mysql/my.cnf`路径

   ```shell
   sudo vim /etc/mysql/my.cnf
   ```

   然后将下述代码复制到配置文件中

   ```shell
   [mysqld]
   character-set-server=utf8 
   [client]
   default-character-set=utf8 
   [mysql]
   default-character-set=utf8
   ```

   然后重启mysql

   ```shell
   service mysql restart
   ```

2. 经过上述步骤，乱码问题已经解决，接下来只是验证一下

   登入mysql，输入一下命令查看编码格式

   ```shell
   mysql> show variables like '%char%';
   +--------------------------+----------------------------+
   | Variable_name            | Value                      |
   +--------------------------+----------------------------+
   | character_set_client     | utf8                       |
   | character_set_connection | utf8                       |
   | character_set_database   | utf8                       |
   | character_set_filesystem | binary                     |
   | character_set_results    | utf8                       |
   | character_set_server     | utf8                       |
   | character_set_system     | utf8                       |
   | character_sets_dir       | /usr/share/mysql/charsets/ |
   +--------------------------+----------------------------+
   8 rows in set (0.00 sec)
   ```

   如果都是utf8那就说明已经将中文乱码问题解决，接下来只要将原来的表删除，在重新创建即可（如果有数据，记得先备份）















# 参考文档

https://www.runoob.com/mysql/mysql-create-database.html