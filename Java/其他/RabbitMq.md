[TOC]

# 介绍

消息队列主要使为了避免程序需要立刻处理集中的资源任务或等待资源任务完成，而是在此之后开启定时任务进行处理

# 安装

## 使用mac安装

### 安装

```shell
brew install rabbitmq
```

安装成功后，可以使用`brew info rabbitmq`来查看相关命令

rabbitmq安装成功，命令位于`/usr/local/sbin`,但是path环境中并没有将该目录配置进入，所以，需要修改path环境变量：

```shell
sudo vim /etc/paths
```

然后将`/usr/local/sbin`另起一行复制进去

> 修改后的内容：
>
> ```shell
> /usr/local/sbin
> /usr/local/bin
> /usr/bin
> /bin
> /usr/sbin
> /sbin
> ```

```shell
source /etc/paths
```

使环境变量立即生效,接下来就可以使用rabbitmq的命令了，其命令都位于`/usr/local/sbin`路径下

### 启动

```shell
rabbitmq-server
```

### 停止

```shell
rabbitmqctl stop_app
```

### 重置

```shell
rabbitmqctl reset
```

# 快速入门

大体实现如图功能：

![image-20191124171342984](/Users/yingjie.lu/Documents/note/.img/image-20191124171342984.png)

引入maven依赖

```xml
<dependencies>
  <dependency>
    <groupId>com.rabbitmq</groupId>
    <artifactId>amqp-client</artifactId>
    <version>5.7.3</version>
  </dependency>

  <dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-core</artifactId>
    <version>1.2.3</version>
  </dependency>
</dependencies>
```

创建Provider

```java
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;

public class Send {

    private final static String QUEUE_NAME = "hello";

    public static void main(String[] argv) throws Exception {
        ConnectionFactory factory = new ConnectionFactory();
        factory.setHost("localhost");
        try (Connection connection = factory.newConnection();
             Channel channel = connection.createChannel()) {

            channel.queueDeclare(QUEUE_NAME, false, false, false, null);
            String message = "Hello World!";
            channel.basicPublish("", QUEUE_NAME, null, message.getBytes());
            System.out.println(" [x] Sent '" + message + "'");

        }
    }
}
```

创建consumer

```java
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.DeliverCallback;

public class Recv {

    private final static String QUEUE_NAME = "hello";

    public static void main(String[] argv) throws Exception {
        ConnectionFactory factory = new ConnectionFactory();
        factory.setHost("localhost");
        Connection connection = factory.newConnection();
        Channel channel = connection.createChannel();

        channel.queueDeclare(QUEUE_NAME, false, false, false, null);
        System.out.println(" [*] Waiting for messages. To exit press CTRL+C");


        DeliverCallback deliverCallback = (consumerTag, delivery) -> {
            String message = new String(delivery.getBody(), "UTF-8");
            System.out.println(" [x] Received '" + message + "'");
        };
        channel.basicConsume(QUEUE_NAME, true, deliverCallback, consumerTag -> { });

    }
}
```

先启动Provider，因为Consumer必须要先有队列才能够监听，先启动Provider后就能创建简单的hello队列，并发送一条数据到rabbitmq中，图解如下：

![image-20191124171453714](/Users/yingjie.lu/Documents/note/.img/image-20191124171453714.png)

在启动Consumer，这样，Consumer就可以将rabbitmq中的hello队列中的数据消费掉，图解如下：

![image-20191124171544038](/Users/yingjie.lu/Documents/note/.img/image-20191124171544038.png)

# 多个消费者

## 循环分发消息给多个Consumer

一个生产者，两个消费者，并且两个消费者轮询的消费消息

创建Provider

```java
package two.DistributeMessages;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.MessageProperties;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

//发送多条消息
public class NewTask {

    private final static String TASK_QUEUE_NAME = "task_queue";

    public static void main(String[] args) throws Exception {
        ConnectionFactory factory = new ConnectionFactory();
        factory.setHost("localhost");
        try (Connection connection = factory.newConnection();
             Channel channel = connection.createChannel()) {

            while (true) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
                String s = reader.readLine();

                channel.queueDeclare(TASK_QUEUE_NAME, true, false, false, null);

                String message = String.join(" ", s);

                channel.basicPublish("", TASK_QUEUE_NAME,
                        MessageProperties.PERSISTENT_TEXT_PLAIN,
                        message.getBytes("UTF-8"));
                System.out.println(" [x] Sent '" + message + "'");
            }
        }
    }
}
```

创建Consumer

```java
package two.DistributeMessages;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.DeliverCallback;

//启动多个worker来消费消息
public class Worker {

    private final static String TASK_QUEUE_NAME = "task_queue";

    public static void main(String[] argv) throws Exception {
        ConnectionFactory factory = new ConnectionFactory();
        factory.setHost("localhost");
        Connection connection = factory.newConnection();
        Channel channel = connection.createChannel();

        channel.queueDeclare(TASK_QUEUE_NAME, true, false, false, null);
        System.out.println(" [*] Waiting for messages. To exit press CTRL+C");

        channel.basicQos(1);//设置一次只能接受一个消息，因为如果消息消费成功后，将成功的信息返回RabbitMQ必须使用同一个Channel，不然会抛出异常

        DeliverCallback deliverCallback = (consumerTag, delivery) -> {
            String message = new String(delivery.getBody(), "UTF-8");
            System.out.println(" [x] Received '" + message + "'");
        };
        boolean autoAck = true; // 设置如果消费消息成功将会返回信息给RabbitMQ，这样做的目的是防止数据丢失，RabbitMQ接收到返回的信息才会将消息删除掉
        channel.basicConsume(TASK_QUEUE_NAME, autoAck, deliverCallback, consumerTag -> { });

    }

}
```

启动一个Provider，启动两个Consumer

Provider发送消息如下：

![image-20191124182715216](/Users/yingjie.lu/Documents/note/.img/image-20191124182715216.png)

两个Consumer接受消息如下：

- Worker：

  ![image-20191124182753965](/Users/yingjie.lu/Documents/note/.img/image-20191124182753965.png)

- Worker2:

  ![image-20191124182808358](/Users/yingjie.lu/Documents/note/.img/image-20191124182808358.png)



循环平均的分发消息给多个消费者，当消息量很大时（或者说任务量很大时），可以启动多个消费者即可快速的处理完rabbitmq中消息（或任务）



## 消息确认

保证在其中一个Consumer宕机后消息不会被丢失



当我们在Consumer中设置了`autoAck=true`之后，那么RabbitMQ只有在Consumer成功消费消息之后才会将消息删除（消费成功后Consumer会发送一条消息给RabbitMQ，如果没有发送，则表示消息未消费成功，则不会在RabbitMQ中将其删除），如果是这样，就可以保证当多个Consumer中的其中一个宕机后，将不会丢失消息，而是将应该发送给挂机的消息发送给其他还存在的Consumer



注意：

在使用上述功能时，需要对Channel进行设置，代码如下：

```java
channel.basicQos(1);//设置一次只能接受一个消息，因为如果消息消费成功后，将成功的信息返回RabbitMQ必须使用同一个Channel，不然会抛出异常
```

## 消息持久化

消息确认能够保证在RabbitMQ正常运行时不会丢失消息，但是当RabbitMQ宕机时，就无法保证了，所以需要将特定的消息进行持久化来保证消息的安全性



代码如下：

```java
boolean durable = true;//是否开启队列的持久化
channel.queueDeclare("hello", durable, false, false, null);
```

> 注意：一个已存在的消息队列，如果它在创建时未设置持久化，那么通过上述代码设置该消息队列会报错（同一个消息队列连接时只有参数一直才可以）

**该代码的改变同时应用到Provider和Consumer中**

设置有持久化的消息队列在RabbitMQ宕机或重启之后都会存在



设置持久化时，我们需要将发送的消息标记为`MessageProperties.PERSISTENT_TEXT_PLAIN`，它实现了`BasicProperties`接口，代码如下：

```java
channel.basicPublish("", "task_queue",
            MessageProperties.PERSISTENT_TEXT_PLAIN,
            message.getBytes());
```

> 注意：
>
> 将消息标记为`PERSISTENT_TEXT_PLAIN`并不能一定保证消息不会丢失，尽管RabbitMQ会将消息保存到硬盘，但是RabbitMQ每`fsync(2)`写入一次，但是不能保证在此间隔中RabbitMQ宕机导致数据丢失，但是这对于普通的消息来说已经足够使用了；如果需要更高的消息持久化保证，可以参考[publisher confirms](https://www.rabbitmq.com/confirms.html)

## 公平的分发







# 其他命令

## 管理界面

启动成功后，可以通过http://localhost:15672/访问rabbitmq的管理界面

默认的用户名和密码都是：guest

## 通过命令查看当前的队列

```shell
$ rabbitmqctl list_queues
Timeout: 60.0 seconds ...
Listing queues for vhost / ...
name	messages
hello	0
```



# 参考文档

https://www.rabbitmq.com/tutorials/tutorial-one-java.html