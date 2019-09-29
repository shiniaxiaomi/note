[TOC]

# java

## java基础

https://link.zhihu.com/?target=https%3A//mp.weixin.qq.com/s/IBbD3CmVWsTL9ymHg6gGGA

### JDK和JRE的区别

- JDK: java Develpment Kit的简称,java开发工具包,提供了java的开发环境和运行环境
- JRE: Java Runtime Environment的简称,java运行环境,为java的运行提供了所需环境

具体来说JDK其实包含了JRE.同时还包含了编译java源码的编译器javac,还包含了很多java程序调试和分析的工具; 简单来说: 如果你需要运行Java程序,只需要安扎u那个JRE就可以了,如果你需要编写java程序,需要安扎u那个JDK(因为你需要javac进行编译)

### ==和equals的区别

#### ==的理解

对于基本类型和引用类型,==的作用效果是不同的,如下所示

- 基本类型: 比较的是值是否相同
- 引用类型: 比较的是引用是否相同

代码示例

```java
String x = "string";
String y = "string";
String z = new String("string");
System.out.println(x==y); // true
System.out.println(x==z); // false
System.out.println(x.equals(y)); // true
System.out.println(x.equals(z)); // true
```

> 因为x和y指向的时同一个引用,所以`==`也是true,而new String()方法则重新开辟了内存空间,所以`==`结果为false,而equals比较的一直是值,所以结果都为true

#### equals解读

equals本质上就是==,只不过Sring和Integer等类重写了equals方法,把它变成了值比囧啊; 看如下代码:

首先看默认情况下equals比较一个有相同值的对象

```java
class Cat {
    public Cat(String name) {
        this.name = name;
    }
    private String name;
}

Cat c1 = new Cat("王磊");
Cat c2 = new Cat("王磊");
System.out.println(c1.equals(c2)); // false
```

> 结果为false,接下来去看一下equals源码就知道了

equals源码如下:

```java
public boolean equals(Object obj) {
    return (this == obj);
}
```

> 所以equals本质上就是==

那么问题来了,两个相同值的String的equals方法为什么返回的是true呢,接下来看一下String类中对equals方法的重写

```java
public boolean equals(Object anObject) {
    if (this == anObject) {//如果引用相等,则肯定相等
        return true;
    }
    if (anObject instanceof String) {//如果是字符串,则继续比较
        String anotherString = (String)anObject;//获取要比较字符串
        int n = value.length;
        if (n == anotherString.value.length) {//如果长度相等,则继续比较
            char v1[] = value;
            char v2[] = anotherString.value;
            int i = 0;
            while (n-- != 0) {//比较每个字符是否相等
                if (v1[i] != v2[i])
                    return false;
                i++;
            }
            return true;
        }
    }
    return false;
}
```

> 因为String类重写了Object的equals方法,所以把引用比较改成了值比较

#### 总结

==对于基本类型来说是值比较,对于引用类型来说比较的是引用; 而equals默认情况下是引用比较,只是很多类重写了equals方法,比如String,Integer等,把从引用比较改成了值比较,所以一般情况下equals比较的是值是否相等

### 两个对象的hashCode()相同,则equals()也一定为true,对吗

不对,两个对象的hashCode()相同,equals()不一定为true

代码示例: 

```java
String str1 = "通话";
String str2 = "重地";
System.out.println(String.format("str1：%d | str2：%d", 
                     str1.hashCode(),str2.hashCode()));
System.out.println(str1.equals(str2));
```

> 执行结果:
>
> str1：1179395 | str2：1179395
>
> false

代码解读: 很显然"通话"和"重地"的hashCode()相同,然而equals()则为false,因为在散列表中,hashCode相等即为两个键值对的哈希值想到等,然而哈希值相等,并





### final在java中有什么作用

### java中的Math.round(-1.5)等于多少

### String属于基础的数据类型吗

### java中操作字符串都有哪些类?他们之间的区别?

### String str="i"与String str=new String("i")一样吗?

### 如何将字符串反转

### String类的常用方法都有哪些

### 抽象类必须要有抽象方法吗

### 普通类和抽象类有哪些区别

### 抽象类能使用final修饰吗

### 接口和抽象类有什么区别

### java中IO流分为几种

### BIO,NIO,AIO有什么区别

### Files的常用方法都有哪些

## 容器

https://mp.weixin.qq.com/s/Yl9pTaQYKwf0rZ6InG9OZg

### java容器都有哪些

### Collection和Collections有什么区别

### List,Set,Map之间的区别是什么

### HashMap和Hashtable有什么区别

### 如何决定使用HashMap还是TreeMap

### 说一下HashMap的实现原理

### 说一下HashSet的实现原理

### ArrayList和LinkedList的区别是什么

### 如何实现数组和List之间的转化

### ArrayList和Vector的区别是什么

### Array和ArrayList有何区别

### 在Queue中poll()和remove()有什么区别

### 哪些集合类是线程安全的

### 迭代器Iterator是什么

### Iterator怎么使用?有什么特点

### Iterator和ListIterator有什么区别

## 多线程

https://mp.weixin.qq.com/s/ywOwdXuMG5rhEXMH_OXKEQ

### 并行和并发有什么区别

### 线程和进程的区别

### 守护线程是什么

### 创建线程有哪几种方式

### 说一下runnable和callable的区别

### 线程有哪些状态

### sleep()和wait()有什么区别

### notify()和notifyAll()有什么区别

### 线程的run()和start()有什么区别

### 创建线程池有哪几种方式

### 线程池都有哪些状态

### 线程池中的submit()和execute()方法有什么区别

### 在java程序中怎么保证多线程的运行安全

### 多线程锁的升级原理是什么

### 什么是死锁

### 怎么防止死锁

### ThreadLocal是什么?有哪些使用场景

### 说一下synchronized底层实现原理

### synchronized和volatile的区别是什么

### synchronized和ReentrantLock区别是什么

### 说一下啊atomic原理

## 反射

https://mp.weixin.qq.com/s/QzwyYexI6v6sDb9h5tQxKA

### 什么是反射

### 什么是java序列化?什么情况下需要序列化?

### 动态代理是什么?有哪些应用?

### 怎么实现动态代理?

## 对象拷贝

https://mp.weixin.qq.com/s/w1s1PbsHrZEU7e04pUkDOg

### 为什么要使用克隆

### 如何实现对象克隆

### 深拷贝和浅拷贝区别是什么?

## java web

https://mp.weixin.qq.com/s/3C3LimAv7Zt7V2ZxCT-MsQ

### jsp和servlet有什么区别

### jsp有哪些内置对象?作用分别是什么?

### 说一下jsp的4中作用域

### session和cookied有什么区别

### 说一下session的工作原理

### 如何客户端禁止cookie能实现session还能使用吗?

### springmvc和struts的区别是什么?

### 如何避免sql注入?

### 什么是XSS攻击,如何避免?

### 什么是CSRF攻击,如何比避免?

## 异常

https://mp.weixin.qq.com/s/CHq5BcH9AtdV0emCQ5naLw

### throw和throws的区别

### final,finally,finalize有什么区别

### try-catch-finally中哪个部分可以省略

### try-catch-finally中,如果 catch中return了,finally还hi执行吗?

### 常见的异常类有哪些?

## 网络

https://mp.weixin.qq.com/s/F201iO7TQNkZz8yAh3PILg

### http响应码301和302代表的是什么?有什么区别

### forward和redirect的区别

### 简述tcp和udp的区别

### tcp为什么要三次握手,两次不行吗?为什么?

### 说一下tcp粘包是怎么产生的?

### OSI的七层模型都有哪些?

### get和post请求有哪些区别

### 如何实现跨域?

### 说一下JSONP实现原理

## 设计模式

https://mp.weixin.qq.com/s/Wahq4TnCm4Pzb6VshWma1Q

### 单例模式

### 观察者模式

### 装饰者模式

### 适配器模式

### 工厂模式

### 代理模式

### 简单工厂和抽象工厂有什么区别

# 框架

## spring

### 为什么要使用spring?

### 解释一下什么是AOP

### 解释一下什么是IOC

### spring有哪些主要模块

### spring常用的注入方式有哪些?

### spring中的bean是线程安全的吗

### spring支持几种bean的作用域?

### spring自动装配bean有哪些方式?

### spring事务实现方式有哪些?

### 说一下spring的事务隔离?

## springmvc

https://mp.weixin.qq.com/s/eHK5wqAv5UgYoYUnpFCxzA

### 说一下springmvc运行流程

### springmvc有哪些组件

### @RequestMapping的作用是什么?

### @Autowired的作用是什么?

## springboot

https://mp.weixin.qq.com/s/UscOEtOBq5qjy1-SJLYtaw

### 什么是springboot

### 为什么要用springboot

### springboot核心配置文件是什么

### springboot配置文件有哪几种类型?它们有什么区别?

### springboot有哪些方式可以实现热部署?

### jpa和hibernate有什么区别?

## springcloud

https://mp.weixin.qq.com/s/UscOEtOBq5qjy1-SJLYtaw

### 什么是springcloud

### springcloud断路器的作用是什么

### springcloud的核心组件有哪些?

## mybatis

https://mp.weixin.qq.com/s/teI5po4wHfIScppMXiU-Bg

### mybatis中#{}和${}的区别是什么

### mybatis有几种分页方式?

### mybatis逻辑分页和物理分页的区别是什么

### mybatis是否支持延迟加载?延迟加载的原理是什么?

### 说一下mybatis的一级缓存和二级缓存?

### mybatis和hibernate的区别有哪些?

### mybatis有哪些执行器(Executor)

### mybatis分页插件的实现原理是什么?

### mybatis如何编写一个自定义插件

## rabbitmq

https://mp.weixin.qq.com/s/P2orZB_aS4bQit8ACrmHAw

### rabbitmq的使用场景有哪些

### rabbitmq有哪些重要的角色?

### rabbitmq有哪些重要的组件?

### rabbitmq中vhost的作用是什么?

### rabbitmq的消息是怎么发送的?

### rabbitmq怎么保证消息的稳定性

### rabbitmq怎么避免消息丢失?

### 要保证消息持久化成功的条件有哪些?

### rabbitmq持久化有什么缺点?

### rabbitmq有集中广播类型

### rabbitmq怎么实现延迟消息队列

### rabbitmq集群有什么用

### rabbitmq节点的类型有哪些

### rabbitmq集群搭建需要主要哪些问题

### rabbitmq每个节点是其他节点的完整拷贝吗?为什么?

### rabbitmq集群中唯一一个磁盘节点崩毁了会发生什么情况?

### rabbitmq对集群节点停止顺序有要求吗

## kafka

https://mp.weixin.qq.com/s/vW_NtOsh5Sv8n3WVmR08eA

### kafka可以脱离zookeeper单独使用吗?为什么

### kafka有几种数据保留的策略

### kafka同时设置了7天和10G清除数据,到第5天的时候消息达到了10G,这个时候kafka将如何处理?

### 什么情况会导致kafka运行变慢

### 使用kafka集群需要注意什么?

## zookeeper

https://mp.weixin.qq.com/s/ZI86U4r3ZppYE3KkmKLNWw

### zookeeper是什么

### zookeeper都有哪些功能

### zookeeper有几种部署模式?

### zookeeper怎么保证主从节点的状态同步?

### 集群中为什么要有主节点?

### 集群中有3台服务器,其中一个节点宕机,这个时候zookeeper还可以使用吗?

### 说一下zookeeper的通知机制?

## mysql

https://mp.weixin.qq.com/s/BXSfeO1B_uaPy2tSdEvp-A

### 数据库的三范式是什么?

### 一张自增表里面总共有17条数据,删除了最后2条数,重启mysql数据库,有插入了一条数据,此时id是几?

### 如何获取当前数据库版本?

### 说一下ACID是什么

### char和varchar的区别是什么

### float和double的区别是什么

### mysql的内连接,左连接,右连接有什么区别

### mysql索引是怎么实现的

### 怎么验证mysqk的索引是否满足需求?

### 说一下数据库的事务隔离?

### 说一下mysql常用的引擎?

### 说一下mysql的行锁和表锁

### 说一下乐观锁和悲观锁?

### mysql问题排查都有哪些手段?

### 如何做mysql的性能优化?

## redis

https://mp.weixin.qq.com/s/5I1Y77GN76h_OkVH1TisvA

### redis是什么?都有哪些使用场景?

### redis有哪些功能?

### redis和memecache有什么区别

### redis为什么是单线程的?

### 什么是缓存穿透?怎么解决?

### redis支持的数据类型有哪些?

### redis支持的java客户端都有哪些?

### jedis和redisson有哪些区别?

### 怎么保证缓存和数据库的一致性?

### redis持久化有几种方式?

### redis怎么实现分布式锁?

### redis如何做内存优化?

### redis淘汰策略有哪些?

### redis常见的性能问题有哪些?该如何解决?

## Oracle

...

# JVM

https://mp.weixin.qq.com/s/OcJvAuRG_mG9S3EYPcItCg

### 说一下jvm的主要组成部分?及其作用?

### 说一下jvm运行时数据区?

### 说一下堆栈的区别?

### 队列和栈是什么?有什么区别?

### 什么是双亲委派模型?

### 说一下类加载的执行过程?

### 怎么判断对象是否可以被回收?

### java中都有哪些引用类型?

### 说一下jvm有哪些垃圾回收算法?

### 说一下jvm有哪些垃圾回收器?

### 详细介绍一下CMS垃圾回收器

### 新生代垃圾回收器和老生代垃圾回收器都有哪些?有什么区别?

### 简述分代垃圾回收器是怎么工作的?

### 说一下jvm调优的工具

### 常见的jvm调优的参数都有哪些?

# 参考文档

- https://www.zhihu.com/question/27858692/answer/787505434

  > 第一个回答