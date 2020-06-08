## 概念

### Mongo

MongoDB由C++编写，是一个基于分布式文件存储的开源数据库

在高负载的情况下，添加更多的节点，可以保证服务器性能。

MongoDB 旨在为WEB应用提供可扩展的高性能数据存储解决方案 。

---

MongoDB是不支持事务的，但是它支持分布式存储。

### noSql对比

下面是Sql与mongodb的术语对比

| SQL术语/概念 | MongoDB术语/概念 | 解释/说明                           |
| :----------- | :--------------- | :---------------------------------- |
| database     | database         | 数据库                              |
| table        | collection       | 数据库表/集合                       |
| row          | document         | 数据记录行/文档                     |
| column       | field            | 数据字段/域                         |
| index        | index            | 索引                                |
| table joins  |                  | 表连接,MongoDB不支持                |
| primary key  | primary key      | 主键,MongoDB自动将_id字段设置为主键 |

## 安装

安装MongoDB：https://www.mongodb.com/try/download/community

> 一路next即可

### 客户端

- Robo 3T：https://robomongo.org/
- MongoDB Compass Community：官方默认指定，安装Mongo时会进行安装（不太好用）

### 启动

在 MongoDB 安装目录的 bin 目录下执行 **mongodb** 即可 

### 连接

Mongo的URI连接语法：

```properties
mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]
```

例如：

`mongodb://localhost:20871`

`mongodb://admin:123456@localhost:20871/test`

`mongodb://localhost,localhost:27018,localhost:27019`

## 使用

### 基础命令

```sql
show dbs; //查询所有数据库
show tables; //查询数据库中的表
use test; //指向test数据库
```

### 数据库

#### 创建数据库

不用创建，在插入文档时会自动创建数据库和集合

```sql
use test;
db.test1.insert({"name":"111"});
```

> 选择使用test数据库（test没有没关系，会自动创建）
>
> 在test1集合中插入一个JSON文档（test1没有没关系，会自动创建）

#### 删除数据库

```sql
use test;
db.dropDatabase();
```

### 集合

#### 创建集合

```sql
db.createCollection("aaa")
```

> 创建名为aaa的集合

#### 删除集合

```sql
db.collection.drop()
```

### 查询

#### 条件查询

等于

```sql
db.test.find(
    {"name":"111"}
)
```

> 查询test集合中name字段等于111的文档

小于

```sql
db.test.find(
    {
    	"age":{$lt:112}
    }
)
```

> 查询test集合中age字段小于112的文档
>
> less than

小于等于

```sql
db.test.find(
    {
    	"age":{$lte:112}
    }
)
```

> less than equels

大于

```sql
db.test.find(
    {
    	"age":{$gt:112}
    }
)
```

> greater than

大于等于

```sql
db.test.find(
    {
    	"age":{$gte:112}
    }
)
```

> greater than equels

不等于

```sql
db.test.find(
    {
    	"age":{$ne:112}
    }
)
```

> not equels

#### and

```sql
db.test.find(
    {
    	name:"12",
    	age:{$lt:200}
    }
)
```

> 查询test集合中name等于12并且age字段小于200的文档

#### or

```sql
db.test.find(
    {
    	$or:[
            {name:"12"},
            {age:{$lt:200}}
        ]
    }
)
```

> 查询test集合中name等于12或者age字段小于200的文档

#### and和or联用

```sql
db.test.find(
    {
        name:"111",
        age:{$lt:200},
    	$or:[
            {name:"122"},
            {age:{$gt:400}}
        ]
    }
)
```

> 查询test集合中
>
> name=111 && age<200 && ( name=122 || age>400 )

#### 根据字段类型查找

```sql
db.test.find(
    {
    	"name" : {$type : 'string'}
    }
)
```

> 在test集合中查找name字段类型为String的文档

更多字段类型参考文档：https://www.runoob.com/mongodb/mongodb-operators-type.html

#### 分页查询

```sql
db.test.find().limit(1);
```

> 查询所有，并只取第一条

#### 排序查询

```sql
db.test.find().sort({age:-1})
```

> 在test集合中，根据age字段进行降序排列

```sql
db.test.find().sort({age:1})
```

> 在test集合中，根据age字段进行升序排列

#### 模糊查询

只对String类型才有效

```sql
db.test.find(
    { 
        "name" : /^.*要查询数据.*$/i
    }
);
```

> 在test集合中，通过正则表达式对name字段进行模糊查询

### 文档

#### 插入文档

```sql
db.aaa.insert({"name":"1"});
```

> 在aaa集合中插入一个JSON文档

#### 更新文档

追加式更新

```sql
db.test.update(
    {
        name:"111"
    },
    {      
        $set: {
            age:1,
            sex:"男"
        }
    }
)
```

> 将test集合中的name=111的文档的age字段更新为1，sex字段更新为男（如果没有则创建）

覆盖式更新

```sql
db.test.update(
    {
        name:"111"
    },
    {      
        age:1,
        sex:"男"
    }
)
```

其他参数：

https://www.runoob.com/mongodb/mongodb-update.html

#### 删除文档

```sql
db.test.remove(
    {
        name:"111"
    }
)
```

其他参数:

https://www.runoob.com/mongodb/mongodb-remove.html

## 索引

```sql
db.test.createIndex({age:1})
```

> 在test集合中创建以age字段升序排列的索引

```sql
db.test.createIndex({age:-1})
```

> 在test集合中创建以age字段降序排列的索引

多字段索引

```sql
db.test.createIndex(
    {
    	age:-1,
    	name:1
    }
)
```

> 在test集合中创建以age字段降序排列,name字段升序排列的索引

## 聚合

```sql
db.test.aggregate(
    [
        {
        	$group : {
        		_id : "$name", 
        		num_tutorial : {$sum : 1}
        	}
        }
    ]
)
```

> 在test集合中，以name字段进行聚合并计算总数，总数的基数是1

更多表达式和参数参考文档：https://www.runoob.com/mongodb/mongodb-aggregate.html

## Demo

https://www.runoob.com/mongodb/mongodb-java.html

## 高级内容

### 全文检索

https://www.runoob.com/mongodb/mongodb-text-search.html

### 正则表达式

https://www.runoob.com/mongodb/mongodb-regular-expression.html