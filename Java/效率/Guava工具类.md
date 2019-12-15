# 介绍

# Files

## 创建文件

### 简单的创建文件

```java
Files.write("abc".getBytes(),new File("/Users/yingjie.lu/abc"));
```

### 使用writer创建文件

```java
BufferedWriter writer = Files.newWriter(new File("/Users/yingjie.lu/abc"),Charsets.UTF_8);
writer.write("hfsdfdhsjfsd\n");
writer.write("23423423\n");
writer.close();
```

### 创建嵌套目录的文件

```java
File file = new File("/Users/yingjie.lu/Desktop/test/dsfds/xcjds/dsfs");
file.getParentFile().mkdirs();
file.createNewFile();
```

## 读取文件

### 简单的读取文件所有内容

```java
List<String> context = Files.readLines(new File("/Users/yingjie.lu/abc"), Charsets.UTF_8);
Iterator<String> iterator = context.iterator();
while(iterator.hasNext()){
  System.out.println(iterator.next());
}
```

### 使用reader一行一行的读取文件

```java
BufferedReader reader = Files.newReader(new File("/Users/yingjie.lu/abc"), Charsets.UTF_8);
String str=null;
while((str=reader.readLine())!=null){
  System.out.println(str);
}
reader.close();
```

## 复制文件

```java
Files.copy(new File("/Users/yingjie.lu/abc"),new File("/Users/yingjie.lu/Desktop/abc"));
```

## 移动文件

```java
Files.move(new File("/Users/yingjie.lu/abc"),new File("/Users/yingjie.lu/Desktop/abcd"));
```

## 创建文件夹(嵌套也适用)

> 这个不是使用的guava中的工具，而是jdk自带的

```java
File file=new File("/Users/yingjie.lu/Desktop/test2");
file.mkdirs();
```

## 移动文件夹

```java
File file=new File("/Users/yingjie.lu/Desktop/test");//文件夹路径
Files.move(file,new File("/Users/yingjie.lu/Desktop/test2"));
```

> 默认情况下是将指定文件夹内的所有内容移动到指定目录下，如果需要保留原指定文件夹，则需要在移动到的指定目录下添加文件夹的名称

## 复制文件夹

不支持复制文件夹，只支持复制一个文件，如果要复制文件夹，可以使用jdk自带的自己写一个递归，或者是使用apache的common-io工具类代理









# EventBus

使用了观察者模式,或者叫发布/订阅模式，即某事情被发布，订阅该事件的角色将收到通知

## 原理模型

我们使用guava的eventBus可以使得发布者与生产者之间的耦合性就降低了；发布者只要想evnetBus发送消息，而不需要关心有多少订阅者订阅了次消息，模型如下：

![image-20191128135731483](/Users/yingjie.lu/Documents/note/.img/image-20191128135731483.png)

## eventbus是单架构的利器

首先单架构就是在一个进程内，虽然在同一个进程内，我们还是希望模块与模块之间时hi松耦合的，而降低耦合使代码更加有结构，就可以使用guava的eventBus将进程内的通讯建立起桥梁

## 如何实现

### 简单的实现消息的发布/订阅

首先引入maven依赖

```xml
<dependency>
  <groupId>com.google.guava</groupId>
  <artifactId>guava</artifactId>
  <version>28.0-jre</version>
</dependency>
```

创建测试类

```java
import com.google.common.eventbus.EventBus;
import com.google.common.eventbus.Subscribe;
public class Test {
  //标注该注解后就可以让该函数订阅消息
  @Subscribe
  void listenHandler(Object o){
    System.out.println("接收到的消息："+o);
  }

  public static void main(String[] args) {
    EventBus eventBus = new EventBus();//创建消息总线
    eventBus.register(new Test());//注册监听器
    eventBus.post("hello");//发送消息
  }
}
```

### 创建多订阅的代码结构

如果使用springboot项目可以参考一下代码



定义消息监听接口

```java
import org.springframework.stereotype.Component;
import com.google.common.eventbus.Subscribe;
//消息监听接口
@Component
public interface BusListener {
    @Subscribe
    void listenHandler(Object o);//监听到消息后的处理函数
}
```

> 之后所有的消息监听类都应该实现该接口

定义消息监听实现类

```java
import org.springframework.stereotype.Component;
@Component
public class TodoListener implements BusListener {
    public void listenHandler(Object o) {
        System.out.println("todo："+o);
    }
}
```

> 将定义的消息监听器加入到Spring容器中

定义消息总线

```java
import com.google.common.eventbus.EventBus;
import com.lyj.demo.listener.impl.TodoListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import javax.annotation.PostConstruct;

//消息总线
@Component
public class Bus {
    public static EventBus todoBus = new EventBus();//todo消息总线

    @Autowired
    TodoListener todoListener;//自动注入todo消息监听

    @PostConstruct
    public void init() {
        todoBus.register(this.todoListener);//注册todo消息监听
    }
}
```

> 使用spring的自动注入将消息监听器注入并注册

如何使用：

```java
public void test(){
  Bus.todoBus.post("test");//指定向todoBus发送消息
}
```

## 同步和异步

使用EventBus构造出来的消息总线是同步的

如果需要使用异步的EventBus，则参考以下代码：

```java
public static EventBus todoBus = new AsyncEventBus(Executors.newFixedThreadPool(1));//异步todo消息总线
```

> 其他用法和同步的基本一致

## 类比RabbitMQ

对于基本功能来说，EventBus和RabbitMQ的理念是基本相似的，在分布式的架构中，我们通常会使用像RabbitMQ，kafaka等消息中间件，而对于在本地的单架构模式来说，进行解耦使用EventBus就适合不过了









# 参考文档

[Guava EventBus - 简书](https://www.jianshu.com/p/703fa6cf6e44)