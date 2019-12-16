# 介绍

RabbitMq是一个高级消息队列协议（AMQP）的实现

# 安装

## mac安装

### 安装

```shell
brew install rabbitmq
```

安装成功后，可以使用`brew info rabbitmq`来查看相关命令

rabbitmq安装成功，命令位于`/usr/local/sbin`,但是path环境中并没有将该目录配置进入，需要进行以下配置：

- 使用`sudo vim /etc/paths`修改环境变量的配置文件

- 然后另起一行，将`/usr/local/sbin`复制进去（它指向了rabbitmq的命令所在的路径）

- 使用`source /etc/paths`来是环境变量立即生效

### 启动

`rabbitmq-server`

### 停止

`rabbitmqctl stop_app`

### 重置

`rabbitmqctl reset`

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
                String s = reader.readLine();//获取输入的消息

                channel.queueDeclare(TASK_QUEUE_NAME, true, false, false, null);//声明

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

当Consumer还没有消费完消息并返回应答时，RabbitMQ不会继续分发给该Consumer，因为可能上一个消息的任务比较繁重，因此需要处理的时间较多，而其他Consumer的任务简单，很快就会处理完，如果按照均匀的分发消息，就会造成分配不均，有些Consumer的任务会更加的繁重，所以，当我们在Consumer中使用`basicQos()`方法并设置设置`prefetchCount = 1`时，就可以避免这种情况，即RabbitMQ会根据Consumer的应答来进行分配消息，即Consumer消费完了才会继续分发;

代码示例：

```java
int prefetchCount = 1;
channel.basicQos(prefetchCount);
```

> 注意：
>
> 当所有的Consumer的任务都很繁忙，我们必须要监听一下RabbitMQ，防止被塞满

详细的Channel使用参考：[JavaDocs online](https://rabbitmq.github.io/rabbitmq-java-client/api/current/)

# 推送/订阅模式（publish/subscription）

本质上，该模式就是以广播的形式发送给所有接收者

## 交换机

RabbitMQ消息传递模型的核心思想是：生产者从不直接向消息队列发送任何消息，而是间接的通过交换机进行发送



交换机一边接收生产者的消息，一边把消息推送到队列中；交换机必须知道它应该怎么处理接收到的消息（发送给特定的队列，还是多个队列等等），而这就取决于使用的是哪种类型的交换机

![image-20191125095054183](/Users/yingjie.lu/Documents/note/.img/image-20191125095054183.png)

交换机的类型有：`direct`, `topic`, `headers` 和 `fanout`

接下来就使用 `fanout`类型来举例，该类型就是使用的广播形式来分发给所有该交换机它所知道的队列

> 我们之前的代码在给RabbitMQ发送消息时，我们也是使用的交换机，不过是默认类型的交换机，即空字符串`""`
>
> 代码如下：
>
> ```java
> channel.basicPublish("", "hello", null, message.getBytes());
> ```
>
> 第一个参数就是交换机的名字
>
> 默认的交换机类型就是循环依次分发消息给每个队列

不过，现在我们使用的是`fanout`类型的交换机，代码如下：

```java
//创建一个类型为fanout的交换机，名字为logs
channel.exchangeDeclare("logs", "fanout");

//将消息发送到名字为logs的交换机
channel.basicPublish( "logs", "", null, message.getBytes());
```

## 临时队列

当我们使用空字符串`""`指定队列时，那么就默认使用的是临时队列

1. 首先，RabbitMQ会为临时队列生成一个随机名称
2. 其次，当我们关闭Java客户端时，该临时队列会被自动删除

我们在使用前也可以使用代码来生成一个临时队列，代码如下：

```java
//生成临时队列，并获取名称
String queueName = channel.queueDeclare().getQueue();
channel.basicPublish( "logs", queueName, null, message.getBytes());
```

## 交换机绑定队列

![image-20191125101534727](/Users/yingjie.lu/Documents/note/.img/image-20191125101534727.png)

在我们创建好交换机后，我们需要指定交换机和哪些队列绑定，代码如下：

```java
//将队列名称和交换机名称进行绑定
channel.queueBind(queueName, "logs", "");
```

## 总的代码

创建生产者

```java
package three.publish_subscribe;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class EmitLog {

  private static final String EXCHANGE_NAME = "logs";//交换机名称

  public static void main(String[] argv) throws Exception {
    ConnectionFactory factory = new ConnectionFactory();
    factory.setHost("localhost");
    try (Connection connection = factory.newConnection();
         Channel channel = connection.createChannel()) {
        channel.exchangeDeclare(EXCHANGE_NAME, "fanout");//设置交换机的类型为fanout

        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        while(true){
            String message = reader.readLine();

            channel.basicPublish(EXCHANGE_NAME, "", null, message.getBytes("UTF-8"));
            System.out.println(" [x] Sent '" + message + "'");
        }
    }
  }
}
```

创建消费者

```java
package three.publish_subscribe;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.DeliverCallback;

public class ReceiveLogs {
  private static final String EXCHANGE_NAME = "logs";//交换机名称

  public static void main(String[] argv) throws Exception {
    ConnectionFactory factory = new ConnectionFactory();
    factory.setHost("localhost");
    Connection connection = factory.newConnection();
    Channel channel = connection.createChannel();

    channel.exchangeDeclare(EXCHANGE_NAME, "fanout");//设置交换机的类型为fanout
    String queueName = channel.queueDeclare().getQueue();
    channel.queueBind(queueName, EXCHANGE_NAME, "");//将队列和交换机绑定

    System.out.println(" [*] Waiting for messages. To exit press CTRL+C");

    DeliverCallback deliverCallback = (consumerTag, delivery) -> {
        String message = new String(delivery.getBody(), "UTF-8");
        System.out.println(" [x] Received '" + message + "'");
    };
    channel.basicConsume(queueName, true, deliverCallback, consumerTag -> { });
  }
}
```

运行一个生产者，运行两个消费者

生产者发送消息如下：

![image-20191125103635432](/Users/yingjie.lu/Documents/note/.img/image-20191125103635432.png)

消费者接受消息如下：

- 消费者1:

  ![image-20191125103713785](/Users/yingjie.lu/Documents/note/.img/image-20191125103713785.png)

- 消费者2:

  ![image-20191125103718221](/Users/yingjie.lu/Documents/note/.img/image-20191125103718221.png)

因为该交换机模式是广播模式，所以，生产者发送消息后，两个消费者都会接受到同样的消息

# 路由（route）

有选择性的发送将交换机和队列绑定，可以理解成队列对哪些交换机的信息感兴趣

如果要对消息进行过滤，使用`fanout`类型的交换机就有点力不从心了，所以，我们需要将其类型换成`Direct`类型的交换机

## binding key

在绑定队列和交换机时指定key（“black”）

```java
channel.queueBind(queueName, EXCHANGE_NAME, "black");
```

## 直接类型交换机（Direct exchange）

使用Direct交换机，消息将发送到binding key和routing key完全匹配的队列中

图解如下：

![image-20191125105414475](/Users/yingjie.lu/Documents/note/.img/image-20191125105414475.png)

> 如图所示：
>
> Q1绑定的key是`orange`，Q2绑定的key是`black`和`green`
>
> 当交换机的routing key为orange时，那么消息就会被发送到Q1队列
>
> 当交换机的routing key为black或者green时，那么消息就会被发送到Q2队列

## 多重绑定

![image-20191125105857696](/Users/yingjie.lu/Documents/note/.img/image-20191125105857696.png)

如图所示：

Q1和Q2都绑定了black，当交换机的routing key为black时，那么它的功能就和`fanout`交换机是一样的，即进行了对所有队列进行了广播

由此可见，Direct交换机的功能是比较强大的和灵活的

## 分发日志（error，info等）代码示例

以下代码只是简单的模拟一下，将error的系统日志和info的系统日志分开到两个不同的队列中，并有不同的消费者消费掉对应的消息，做对应的处理（如error信息则保存入库，info信息则打印即可等等）



创建生产者

```java
package four.route;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class EmitLogDirect {

  private static final String EXCHANGE_NAME = "direct_logs";

  public static void main(String[] argv) throws Exception {
    ConnectionFactory factory = new ConnectionFactory();
    factory.setHost("localhost");
    try (Connection connection = factory.newConnection();
         Channel channel = connection.createChannel()) {

        channel.exchangeDeclare(EXCHANGE_NAME, "direct");//设置交换机的类型为direct

        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        while(true){
            String message = reader.readLine();
            String[] arr = message.split(" ");
            if("error".equals(arr[0])){// 如果是error的消息，则将routing key设置为"error"
                channel.basicPublish(EXCHANGE_NAME, "error", null, arr[1].getBytes("UTF-8"));
            }else if("info".equals(arr[0])){// 如果是info的消息，则将routing key设置为"info"
                channel.basicPublish(EXCHANGE_NAME, "info", null, arr[1].getBytes("UTF-8"));
            }

            System.out.println(" [x] Sent '" + arr[0] + "':'" + arr[1] + "'");
        }
    }
  }
}
```

创建error信息消费者

```java
package four.route;

import com.rabbitmq.client.*;

public class ReceiveErrorLogsDirect {

  private static final String EXCHANGE_NAME = "direct_logs";

  public static void main(String[] argv) throws Exception {
    ConnectionFactory factory = new ConnectionFactory();
    factory.setHost("localhost");
    Connection connection = factory.newConnection();
    Channel channel = connection.createChannel();

    channel.exchangeDeclare(EXCHANGE_NAME, "direct");//设置交换机的类型为direct
    String queueName = channel.queueDeclare().getQueue();

    channel.queueBind(queueName, EXCHANGE_NAME, "error");//将队列和交换机绑定，并分别指定key为error

    System.out.println(" [*] Waiting for messages. To exit press CTRL+C");

    DeliverCallback deliverCallback = (consumerTag, delivery) -> {
        String message = new String(delivery.getBody(), "UTF-8");
        System.out.println(" [x] Received '" +
            delivery.getEnvelope().getRoutingKey() + "':'" + message + "'");
    };
    channel.basicConsume(queueName, true, deliverCallback, consumerTag -> { });
  }
}
```

创建info信息消费者

```java
package four.route;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.DeliverCallback;

public class ReceiveInfoLogsDirect {

  private static final String EXCHANGE_NAME = "direct_logs";

  public static void main(String[] argv) throws Exception {
    ConnectionFactory factory = new ConnectionFactory();
    factory.setHost("localhost");
    Connection connection = factory.newConnection();
    Channel channel = connection.createChannel();

    channel.exchangeDeclare(EXCHANGE_NAME, "direct");//设置交换机的类型为direct
    String queueName = channel.queueDeclare().getQueue();

    channel.queueBind(queueName, EXCHANGE_NAME, "info");//将队列和交换机绑定，并分别指定key为error

    System.out.println(" [*] Waiting for messages. To exit press CTRL+C");

    DeliverCallback deliverCallback = (consumerTag, delivery) -> {
        String message = new String(delivery.getBody(), "UTF-8");
        System.out.println(" [x] Received '" +
            delivery.getEnvelope().getRoutingKey() + "':'" + message + "'");
    };
    channel.basicConsume(queueName, true, deliverCallback, consumerTag -> { });
  }
}
```

分别运行生产者，error消费者和info消费者

在生产者中输入要发送的消息如下：

![image-20191125114018423](/Users/yingjie.lu/Documents/note/.img/image-20191125114018423.png)

error消费者消费的消息：

![image-20191125114054283](/Users/yingjie.lu/Documents/note/.img/image-20191125114054283.png)

info消费者消费的消息：

![image-20191125114110456](/Users/yingjie.lu/Documents/note/.img/image-20191125114110456.png)

# 主题（topic）

topic交换机不能随意的指定routing_key，它有一定的组成规则，示例如下：

"`stock.usd.nyse`", "`nyse.vmw`", "`quick.orange.rabbit`"

组成必须要使用`.`分隔的多个单词，最大的长度不能超过255



topic交换机的逻辑和direct交换机很相似：一个消息发送到对应routing_key和binding_key相匹配的队列中，而不同的是topic交换机提供了特殊的正则，可以更方便灵活的使用，特殊的正则如下：

- `*`可以匹配任意的一个单词
- `#`可以匹配0个或多个单词

图解如下：

![image-20191125123502742](/Users/yingjie.lu/Documents/note/.img/image-20191125123502742.png)

> 上述图中：
>
> Q1绑定的key为`.orange.`，Q2绑定的key为`*.*.rabbit`和`lazy.#`
>
> 可以这么理解：
>
> - Q1对所有带有orange的信息感兴趣
> - Q2对所有带有rabbit和lazy的信息感兴趣
>
> 以下是消息匹配的示例：
>
> 1. 当topic交换机收到绑定了`quick.orange.rabbit`或者`lazy.orange.elephant`的key的消息时，那么该消息会被发送到Q1和Q2
>
> 2. 当key为`quick.orange.fox`时，该消息会被发送到Q1
>
> 3. 当key为`lazy.brown.fox`时，该消息会被发送到Q2
>
> 4. 当key为`quick.brown.fox`时，该消息不会发送Q1和Q2，那么该消息就会被丢失
>
> 5. 当key为`lazy.pink.rabbit`时，虽然Q2匹配了两次，但是只会发送一次消息到Q2
>
> 6. 当key为`lazy.orange.male.rabbit`时，该消息只会发送到Q2
>
>    > 因为`*`只能匹配一个单词，而上述key为4个单词，所以只有使用`#`匹配0个或多个单词才会被匹配上



Topic交换机非常的灵活，它通过配置rounting_key可以变为其他类型的交换机：

- 当队列绑定的key为`#`时，它将接受所有的消息，那么就变成了`fanout`交换机
- 当绑定的key不使用`*`和`#`时，而是仅仅一个单词，那么就变成了`direct`交换机

## 代码示例

根据上一个的日志分发记录的代码进行修改，修改为可以根据正则进行匹配分发消息



创建生产者

```java
package five.topic;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.DeliverCallback;

public class ReceiveErrorLogsTopic {

  private static final String EXCHANGE_NAME = "topic_logs";

  public static void main(String[] argv) throws Exception {
    ConnectionFactory factory = new ConnectionFactory();
    factory.setHost("localhost");
    Connection connection = factory.newConnection();
    Channel channel = connection.createChannel();

    channel.exchangeDeclare(EXCHANGE_NAME, "topic");//设置交换机的类型为topic
    String queueName = channel.queueDeclare().getQueue();

    channel.queueBind(queueName, EXCHANGE_NAME, "error.#");//绑定队列和交换机，并指定routing_key为error.#

    System.out.println(" [*] Waiting for messages. To exit press CTRL+C");

    DeliverCallback deliverCallback = (consumerTag, delivery) -> {
        String message = new String(delivery.getBody(), "UTF-8");
        System.out.println(" [x] Received '" +
            delivery.getEnvelope().getRoutingKey() + "':'" + message + "'");
    };
    channel.basicConsume(queueName, true, deliverCallback, consumerTag -> { });
  }
}
```

创建error信息消费者

```java
package five.topic;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.DeliverCallback;

public class ReceiveErrorLogsTopic {

  private static final String EXCHANGE_NAME = "topic_logs";

  public static void main(String[] argv) throws Exception {
    ConnectionFactory factory = new ConnectionFactory();
    factory.setHost("localhost");
    Connection connection = factory.newConnection();
    Channel channel = connection.createChannel();

    channel.exchangeDeclare(EXCHANGE_NAME, "topic");//设置交换机的类型为topic
    String queueName = channel.queueDeclare().getQueue();

    channel.queueBind(queueName, EXCHANGE_NAME, "error.#");//绑定队列和交换机，并指定routing_key为error.#

    System.out.println(" [*] Waiting for messages. To exit press CTRL+C");

    DeliverCallback deliverCallback = (consumerTag, delivery) -> {
        String message = new String(delivery.getBody(), "UTF-8");
        System.out.println(" [x] Received '" +
            delivery.getEnvelope().getRoutingKey() + "':'" + message + "'");
    };
    channel.basicConsume(queueName, true, deliverCallback, consumerTag -> { });
  }
}
```

创建info信息消费者

```java
package five.topic;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.DeliverCallback;

public class ReceiveInfoLogsTopic {

  private static final String EXCHANGE_NAME = "topic_logs";

  public static void main(String[] argv) throws Exception {
    ConnectionFactory factory = new ConnectionFactory();
    factory.setHost("localhost");
    Connection connection = factory.newConnection();
    Channel channel = connection.createChannel();

    channel.exchangeDeclare(EXCHANGE_NAME, "topic");//设置交换机的类型为topic
    String queueName = channel.queueDeclare().getQueue();

    channel.queueBind(queueName, EXCHANGE_NAME, "info.#");//绑定队列和交换机，并指定routing_key为info.#

    System.out.println(" [*] Waiting for messages. To exit press CTRL+C");

    DeliverCallback deliverCallback = (consumerTag, delivery) -> {
        String message = new String(delivery.getBody(), "UTF-8");
        System.out.println(" [x] Received '" +
            delivery.getEnvelope().getRoutingKey() + "':'" + message + "'");
    };
    channel.basicConsume(queueName, true, deliverCallback, consumerTag -> { });
  }
}
```

运行生产者，运行error信息消费者，运行info信息消费者



生产者信息发送如下：

![image-20191125133119822](/Users/yingjie.lu/Documents/note/.img/image-20191125133119822.png)

error消费者信息接受如下：

![image-20191125133140169](/Users/yingjie.lu/Documents/note/.img/image-20191125133140169.png)

info消费者信息接受如下：

![image-20191125133239700](/Users/yingjie.lu/Documents/note/.img/image-20191125133239700.png)

# RPC

RabbitMQ支持搭建远程RPC调用服务



大体流程：

![image-20191125140313802](/Users/yingjie.lu/Documents/note/.img/image-20191125140313802.png)

RPC的工作流程：

- 客户端发送消息并携带两个参数：replayTo和correlationId

  replayTo：指定RPC调用成功后，将结果返回给消息队列

  correlationId：为每个请求设置一个独一无二的值

- 请求发送到了指定的rpc队列

- RPC Server端监听rpc_queue队列并等待请求，当请求出现时，执行具体的请求任务并返回结果给客户端，此时需要使用到请求中的replayTo字段，它指定了将结果发送到指定的消息队列（replay_to）

- 客户端监听replay_to消息队列，当返回结果出现时，它检验消息中的correlationId属性，如果匹配成功（是客户端原始发出请求时的correlationId），那么就将结果返回给客户端



详细文档和代码见[文档](https://www.rabbitmq.com/tutorials/tutorial-six-java.html)

# 推送确认（Publisher Confirms）

推送确认是RabbitMQ的扩展功能，用来保证可靠的消息推送

当开始消息推送确认功能时，客户端发布的消息由代理异步确认，这意味着消息已经在服务器端得到了处理之后才会发送确认通知

## 开启推送确认

```java
Channel channel = connection.createChannel();
channel.confirmSelect();
```

其他内容和代码参考[文档](https://www.rabbitmq.com/tutorials/tutorial-seven-java.html)

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



# SpringBoot整合RabbitMQ

https://blog.csdn.net/kevinmcy/article/details/82221297

# 参考文档

[官方入门教程](https://www.rabbitmq.com/tutorials/tutorial-one-java.html)

[官方文档](https://www.rabbitmq.com/documentation.html)