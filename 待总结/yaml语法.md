## 基本语法

- 大小写敏感
- 使用缩进表示层级关系
- 相同层级的元素左对齐
- 使用#注释

## 支持的数据类型

- 对象
- 数组
- 基本数据类型

### 对象

```yaml
key: 
    child-key: value
    child-key2: value2
```

### 数组

 以 **-** 开头的行表示构成一个数组： 

```yaml
keys:
    - A
    - B
    - C
```

复杂数组：

```yaml
companies:
    -
        id: 1
        name: company1
        price: 200W
    -
        id: 2
        name: company2
        price: 500W
```

>  意思是 companies 属性是一个数组，每一个数组元素又是由 id、name、price 三个属性构成。 

 数组也可以使用流式(flow)的方式表示： 

```yaml
companies: [{id: 1,name: company1,price: 200W},{id: 2,name: company2,price: 500W}]
```

### 基本类型

```yaml
boolean: 
    - TRUE  #true,True都可以
    - FALSE  #false，False都可以
float:
    - 3.14
    - 6.8523015e+5  #可以使用科学计数法
int:
    - 123
    - 0b1010_0111_0100_1010_1110    #二进制表示
null:
    nodeName: 'node'
    parent: ~  #使用~表示null
string:
    - 哈哈
    - 'Hello world'  #可以使用双引号或者单引号包裹特殊字符
    - newline
      newline2    #字符串可以拆成多行，每一行会被转化成一个空格
date:
    - 2018-02-17    #日期必须使用ISO 8601格式，即yyyy-MM-dd
datetime: 
    -  2018-02-17T15:02:31+08:00    #时间使用ISO 8601格式，时间和日期之间使用T连接，最后使用+代表时区
```

