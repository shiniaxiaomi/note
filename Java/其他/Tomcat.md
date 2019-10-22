[TOC]

# 介绍

Tomcat服务器是一个开源的轻量级Web应用服务器,在中小型系统和并发量肖的场合下被普遍使用; 它是一个Servlet容器; 

Tomcat和Servlet的关系如图所示:

![img](D:\note\.img\1251492-20180507132038095-966635725.jpg)

# 快速入门

## 下载安装

1. [Tomcat9下载链接](https://tomcat.apache.org/download-90.cgi)

2. 下载安装后解压即可

3. 配置Java环境变量

4. 启动Tomcat

   在window系统中直接双击在bin目录下的startup.bat即可启动

5. 访问服务

   http://localhost:8080/

   看到一只三只脚的猫即成功

   ![1571623061231](D:\note\.img\1571623061231.png)

## 快速配置

配置Tomcat的启动端口

1. 找到Tomcat安装目录下的conf/server.xml文件

2. 找到8080端口,修改port的值,将port端口的值修改为80端口

   ![1571624164175](D:\note\.img\1571624164175.png)

3. 重启Tomcat

4. 访问服务

   http://127.0.0.1/

## 快速部署

共有以下几种方式:

1. 修改Tomcat目录下的conf/server.xml配置文件

   找到Host标签

   ![1571624585757](D:\note\.img\1571624585757.png)

   在Host标签内添加一下内容

   ```xml
   <Context  path="/lyj"  docBase="D:\lyj"/>
   ```

   > path:  浏览器要访问的目录---虚拟目录 
   >
   > docBase:  网站所在磁盘目录 

   重启Tomcat即可

   > 如果要实验的话,可以在D盘创建lyj文件夹,并将Tomcat安装目录下的`webapps`文件夹下的任意项目拷贝一份当到`lyj`文件夹下即可
   >
   > 如:
   >
   > ![1571624918230](D:\note\.img\1571624918230.png)
   >
   > 重启项目访问: http://localhost:8080/lyj/examples/即可

   缺点(Tomcat7.0之后): 如果配置错误,Tomcat会启动失败(如果Tomcat中还有其他的项目,会导致其他项目也无法被启动) 

2. 将网站目录复制到Tomcat安装目录下的`webapps`目录下

   一个文件夹就对应一个网站项目

   文件夹的名字就是访问的url,相当于之前使用`Context`标签配置的`path`参数是一样的

3. 把网站目录压缩成war包部署到Tomcat中

   war包: 就是一个压缩文件

   把我们的项目进行压缩成zip,然后修改后缀为`.war`,再把war文件拷贝到Tomcat安装目录下的`webapps`目录下即可,在Tomcat启动时,会自动将该war包进行解压之后部署

# Tomcat原理

## 概述

Tomcat结构图:

![img](D:\note\.img\20180308114704839.png)

Tomcat主要组件：服务器Server，服务Service，连接器Connector、容器Container。连接器Connector和容器Container是Tomcat的核心。 

**一个Container容器和一个或多个Connector组合在一起，加上其他一些支持的组件共同组成一个Service服务**，有了Service服务便可以对外提供能力了，但是Service服务的生存需要一个环境，这个环境便是Server，Server组件为Service服务的正常使用提供了生存环境，Server组件可以同时管理一个或多个Service服务。

## Tomcat组件

### Connector

一个Connector将在某个指定的端口上监听客户端的请求,接收浏览器发过来的tcp连接请求,创建一个Request和Response对象分别用于和请求端交换数据吗,然后开一个线程来处理这个请求并把创建的Request和Response对象传给处理引擎Engine(Container中的一部分),从Engine处理后,获取响应并返回给客户端

Tomcat中由两个经典的Connector,一个直接监听来自Browser的Http请求,另外一个监听来自其他的WebServer的请求; Http/1.1 Connector在端口8080处监听来自Browser的Http请求,AJP/1.3 Connector在端口8009监听其他WebServer的Servlet/JSP请求

**Connector最重要的功能就是接收连接请求,然后分配线程让Container来处理这个请求**,所以这必然是多线程的,多线程的处理时Connector设计的核心

### Container

![img](D:\note\.img\2018030817251496.png)

Container是容器的父接口,该容器的设计用的是典型的责任链的设计模式,它由四个子容器组件构成,分别是Engine,Host,Context和Wrapper; 这四个组件存在包含关系,通常一个Servlet类对应一个Wrapper,如果由多个Servlet定义多个Wrapper,如果由多个Wrapper就要定义一个更高的Container,如Context

Context 还可以定义在父容器 Host 中，Host 不是必须的，但是要运行 war 程序，就必须要 Host，因为 war 中必有 web.xml 文件，这个文件的解析就需要 Host 了，如果要有多个 Host 就要定义一个 top 容器 Engine 了。而 Engine 没有父容器了，一个 Engine 代表一个完整的 Servlet 引擎

- Engine 容器 
  Engine 容器比较简单，它只定义了一些基本的关联关系
- Host 容器 
  Host 是 Engine 的子容器，一个 Host 在 Engine 中代表一个虚拟主机，这个虚拟主机的作用就是运行多个应用，它负责安装和展开这些应用，并且标识这个应用以便能够区分它们。它的子容器通常是 Context，它除了关联子容器外，还有就是保存一个主机应该有的信息。
- Context 容器 
  Context 代表 Servlet 的 Context，它具备了 Servlet 运行的基本环境，理论上只要有 Context 就能运行 Servlet 了。简单的 Tomcat 可以没有 Engine 和 Host。Context 最重要的功能就是管理它里面的 Servlet 实例，Servlet 实例在 Context 中是以 Wrapper 出现的，还有一点就是 Context 如何才能找到正确的 Servlet 来执行它呢？ Tomcat5 以前是通过一个 Mapper 类来管理的，Tomcat5 以后这个功能被移到了 request 中，在前面的时序图中就可以发现获取子容器都是通过 request 来分配的。
- Wrapper 容器 
  Wrapper 代表一个 Servlet，它负责管理一个 Servlet，包括的 Servlet 的装载、初始化、执行以及资源回收。Wrapper 是最底层的容器，它没有子容器了，所以调用它的 addChild 将会报错。 
  Wrapper 的实现类是 StandardWrapper，StandardWrapper 还实现了拥有一个 Servlet 初始化信息的 ServletConfig，由此看出 StandardWrapper 将直接和 Servlet 的各种信息打交道。

### 其他组件

Tomcat 还有其它重要的组件，如安全组件 security、logger 日志组件、session、mbeans、naming 等其它组件。这些组件共同为 Connector 和 Container 提供必要的服务 

###  HTTP请求过程 

![img](D:\note\.img\20180308173032224.png)

Tomcat Server处理一个HTTP请求的过程:

1. 用户点击网页内容，请求被发送到本机端口8080，被在那里监听的Coyote HTTP/1.1 Connector获得。 

2. Connector把该请求交给它所在的Service的Engine来处理，并等待Engine的回应。 

3. Engine获得请求localhost/test/index.jsp，匹配所有的虚拟主机Host。 

4. Engine匹配到名为localhost的Host（即使匹配不到也把请求交给该Host处理，因为该Host被定义为该Engine的默认主机），名为localhost的Host获得请求/test/index.jsp，匹配它所拥有的所有的Context。Host匹配到路径为/test的Context（如果匹配不到就把该请求交给路径名为“ ”的Context去处理）。 

   > 这里的匹配到路径为/test的Context的意识是在Tomcat的webapps文件夹下会存在多个项目文件,而其中的一个项目文件就是一个Context
   >
   > 而/test对应的就是webapps文件夹下的test文件夹对应的项目(Context)

5. path=“/test”的Context获得请求/index.jsp，在它的mapping table中寻找出对应的Servlet。Context匹配到URL PATTERN为*.jsp的Servlet,对应于JspServlet类。 

6. 构造HttpServletRequest对象和HttpServletResponse对象，作为参数调用JspServlet的`doGet()`或`doPost()`来执行业务逻辑、数据存储等程序。 

7. Context把执行完之后的HttpServletResponse对象返回给Host。 

8. Host把HttpServletResponse对象返回给Engine。 

9. Engine把HttpServletResponse对象返回Connector。 

10. Connector把HttpServletResponse对象返回给客户Browser。

## server.xml配置

### 配置文件的详细参数

Tomcat各组件的关系图

![img](D:\note\.img\2018031313095610.png)

1. Server

   server.xml的最外层元素标签

   常用属性:

   - port: Tomcat监听shutdown命令的端口
   - shutdown：通过指定的端口（port）关闭Tomcat所需的字符串 

2. Listener

   监听器,负责监听特定的事件,当特定事件触发时,监听器会捕捉到该事件,并做出响应的处理

   Listener通常用在Tomcat的启动和关闭过程;

   Listener可嵌在Server、Engine、Host、Context内 

   常用属性:

   - className：指定实现`org.apache.catalina.LifecycleListener`接口的类 

3. GlobalNamingResources

    用于配置JNDI 

4. Service

   Service包装Executor、Connector、Engine，以组成一个完整的服务 

   常用属性:

   - className：指定实现`org.apache.catalina. Service`接口的类，默认值为`org.apache.catalina.core.StandardService`
   - name：Service的名字

   > Server可以包含多个Service组件 

5. Executor

   Service提供的线程池，供Service内各组件使用 

   常用属性:

   |         属性名          |                             解释                             |
   | :---------------------: | :----------------------------------------------------------: |
   |        className        | 指定实现`org.apache.catalina. Executor`接口的类，默认值为`org.apache.catalina.core. StandardThreadExecutor` |
   |          name           |                         线程池的名字                         |
   |         daemon          |                 是否为守护线程，默认值为true                 |
   |       maxIdleTime       | 总线程数高于minSpareThreads时，空闲线程的存活时间（单位：ms），默认值为60000ms，即1min |
   |      maxQueueSize       | 任务队列上限，默认值为Integer.MAX_VALUE(（2147483647），超过此值，将拒绝 |
   |     **maxThreads**      |               线程池内线程数上限，默认值为200                |
   |   **minSpareThreads**   |                线程池内线程数下限，默认值为25                |
   |       namePrefix        |    线程名字的前缀。线程名字通常为namePrefix+ threadNumber    |
   | prestartminSpareThreads | 是否在Executor启动时，就生成minSpareThreads个线程。默认为false |
   |     threadPriority      |  Executor内线程的优先级，默认值为5（Thread.NORM_PRIORITY）   |
   |   threadRenewalDelay    | 重建线程的时间间隔。重建线程池内的线程时，为了避免线程同时重建，每隔threadRenewalDelay（单位：ms）重建一个线程。默认值为1000ms，设置为负则不重建 |

6. Connector

   Connector是Tomcat接收请求的入口，每个Connector有自己专属的监听端口

   Connector有两种：HTTP Connector和AJP Connector

   常用端口:

   |        属性名         |                             解释                             |
   | :-------------------: | :----------------------------------------------------------: |
   |       **port**        |                   Connector接收请求的端口                    |
   |     **protocol**      |           Connector使用的协议（HTTP/1.1或AJP/1.3）           |
   | **connectionTimeout** |              每个请求的最长连接时间（单位：ms）              |
   |     redirectPort      | 处理http请求时，收到一个SSL传输请求，该SSL传输请求将转移到此端口处理 |
   |       executor        | 指定线程池，如果没设置executor，可在Connector标签内设置maxThreads（默认200）、minSpareThreads（默认10） |
   |      acceptCount      | Connector请求队列的上限。默认为100。当该Connector的请求队列超过acceptCount时，将拒绝接收请求 |

7. Engine

   Engine负责处理Service内的所有请求。它接收来自Connector的请求，并决定传给哪个Host来处理，Host处理完请求后，将结果返回给Engine，Engine再将结果返回给Connector 

   常用属性:

   |           属性           |                             解释                             |
   | :----------------------: | :----------------------------------------------------------: |
   |           name           |                         Engine的名字                         |
   |     **defaultHost**      | 指定默认Host。Engine接收来自Connector的请求，然后将请求传递给defaultHost，defaultHost 负责处理请求 |
   |        className         | 指定实现`org.apache.catalina. Engine`接口的类，默认值为`org.apache.catalina.core. StandardEngine` |
   | backgroundProcessorDelay | Engine及其部分子组件（Host、Context）调用backgroundProcessor方法的时间间隔。backgroundProcessorDelay为负，将不调用backgroundProcessor。backgroundProcessorDelay的默认值为10<br />注：Tomcat启动后，Engine、Host、Context会启动一个后台线程，定期调用backgroundProcessor方法。backgroundProcessor方法主要用于重新加载Web应用程序的类文件和资源、扫描Session过期 |
   |         jvmRoute         |      Tomcat集群节点的id。部署Tomcat集群时会用到该属性，      |

8. Host 

   Host负责管理一个或多个Web项目 

   |       属性       |                             解释                             |
   | :--------------: | :----------------------------------------------------------: |
   |     **name**     |                          Host的名字                          |
   |   **appBase**    |         存放Web项目的目录（绝对路径、相对路径均可）          |
   |    unpackWARs    | 当appBase下有WAR格式的项目时，是否将其解压（解成目录结构的Web项目）。设成false，则直接从WAR文件运行Web项目 |
   |  **autoDeploy**  | 是否开启自动部署。设为true，Tomcat检测到appBase有新添加的Web项目时，会自动将其部署 |
   | startStopThreads | 线程池内的线程数量。Tomcat启动时，Host提供一个线程池，用于部署Web项目，startStopThreads为0，并行线程数=系统CPU核数；startStopThreads为负数，并行线程数=系统CPU核数+startStopThreads，如果（系统CPU核数+startStopThreads）小于1，并行线程数设为1；startStopThreads为正数，并行线程数= startStopThreads，startStopThreads默认值为1<br />startStopThreads为默认值时，Host只提供一个线程，用于部署Host下的所有Web项目。如果Host下的Web项目较多，由于只有一个线程负责部署这些项目，因此这些项目将依次部署，最终导致Tomcat的启动时间较长。此时，修改startStopThreads值，增加Host部署Web项目的并行线程数，可降低Tomcat的启动时间 |

9. Context

   Context代表一个运行在Host上的Web项目。一个Host上可以有多个Context。将一个Web项目（D:\MyApp）添加到Tomcat下的webapps文件夹下，在Host标签内，添加Context标签 

   ```xml
   <Context path="/myApp" docBase="D:\MyApp"  reloadable="true" crossContext="true">
   ```

   常用属性:

   |     属性名     |                             解释                             |
   | :------------: | :----------------------------------------------------------: |
   |    **path**    | 该Web项目的URL入口。path设置为””，输入http://localhost:8080即可访问MyApp；path设置为”/myApp”，输入http://localhost:8080/myApp才能访问MyApp |
   |  **docBase**   | Web项目的路径，绝对路径、相对路径均可（相对路径是相对于Tomcat下的webapps文件夹） |
   | **reloadable** | 设置为true，Tomcat会自动监控Web项目的/WEB-INF/classes/和/WEB-INF/lib变化，当检测到变化时，会重新部署Web项目。reloadable默认值为false。通常项目开发过程中设为true，项目发布的则设为false |
   |  crossContext  | 设置为true，该Web项目的Session信息可以共享给同一host下的其他Web项目。默认为false |

10. Cluster

    Tomcat集群配置。(见[Tomcat 8（三）Apache2.2.25+Tomcat8.0.3集群配置](http://blog.csdn.net/flyliuweisky547/article/details/21293071)和[Tomcat 8（四）server.xml的Cluster标签详解](http://blog.csdn.net/flyliuweisky547/article/details/21980825)) 

11. Realm

    Realm可以理解为包含用户、密码、角色的”数据库”。Tomcat定义了多种Realm实现：JDBC Database Realm、DataSource Database Realm、JNDI Directory Realm、UserDatabase Realm等 

12. Valve

    Valve可以理解为Tomcat的拦截器，而我们常用filter为项目内的拦截器。Valve可以用于Tomcat的日志、权限等。Valve可嵌在Engine、Host、Context内 

### 配置文件示例

需要配置的文件信息(在conf/server.xml文件中配置):

> 网站网页目录：/web/www      域名：www.test1.com 
> 论坛网页目录：/web/bbs     URL：bbs.test1.com/bbs 
> 网站管理程序：$CATALINA_HOME/wabapps   URL：manager.test.com    允许访问地址：172.23.136.* 

```xml
<Server port="8005" shutdown="SHUTDOWN">
    <Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="on"/>
    <Listener className="org.apache.catalina.core.JasperListener"/>
    <Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener"/>
    <Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener"/>
    <Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener"/>

    <!-- 定义的一个名叫“UserDatabase”的认证资源，将conf/tomcat-users.xml加载至内存中，在需要认证的时候到内存中进行认证 -->
    <GlobalNamingResources>
        <!-- 全局命名资源，来定义一些外部访问资源，其作用是为所有引擎应用程序所引用的外部资源的定义 -->
        <Resource name="UserDatabase" auth="Container"
                  type="org.apache.catalina.UserDatabase"
                  description="User database that can be updated and saved"
                  factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
                  pathname="conf/tomcat-users.xml"/>
    </GlobalNamingResources>

    <!-- 定义Service组件，用来关联Connector和Engine，一个Engine可以对应多个Connector，每个Service中只能一个Engine -->
    <Service name="Catalina">
        <!-- 修改HTTP/1.1的Connector监听端口为80.客户端通过浏览器访问的请求，只能通过HTTP传递给tomcat。  -->
        <Connector port="80" protocol="HTTP/1.1" connectionTimeout="20000" redirectPort="8443"/>
        <Connector port="8009" protocol="AJP/1.3" redirectPort="8443"/>

        <!-- 修改当前Engine，默认主机是，www.test.com  -->
        <Engine name="Catalina" defaultHost="test.com">
            <!-- Realm组件，定义对当前容器内的应用程序访问的认证，通过外部资源UserDatabase进行认证 -->
            <Realm className="org.apache.catalina.realm.LockOutRealm">
                <Realm className="org.apache.catalina.realm.UserDatabaseRealm"
                       resourceName="UserDatabase"/>
            </Realm>
            <!--  定义一个主机，域名为：test.com，应用程序的目录是/web，设置自动部署，自动解压    -->
            <Host name="test.com" appBase="/web" unpackWARs="true" autoDeploy="true">
                <!--    定义一个别名www.test.com，类似apache的ServerAlias -->
                <Alias>www.test.com</Alias>
                <!--    定义该应用程序，访问路径""，即访问www.test.com即可访问，网页存放的目录为：相对于appBase下的/web/www,
                并且当该应用程序下web.xml或者类等有相关变化时，自动重载当前配置，即不用重启tomcat使部署的新应用程序生效  -->
                <Context path="" docBase="www/" reloadable="true"/>
                <!--  定义另外一个独立的应用程序，访问路径为：www.test.com/bbs，该应用程序网页存放的目录为/web/bbs   -->
                <Context path="/bbs" docBase="/web/bbs" reloadable="true"/>
                <!--   定义一个Valve组件，用来记录tomcat的访问日志，日志存放目录为：/web/www/logs;
                如果定义为相对路径则是相当于$CATALINA_HOME，并非相对于appBase，这个要注意。
                定义日志文件前缀为www_access.并以.log结尾，pattern定义日志内容格式，具体字段表示可以查看tomcat官方文档   -->
                <Valve className="org.apache.catalina.valves.AccessLogValve" directory="/web/www/logs"
                       prefix="www_access." suffix=".log"
                       pattern="%h %l %u %t %r %s %b"/>
            </Host>
            <!--   定义一个主机名为manager.test.com，应用程序目录是Tomcat安装目录下的webapps目录,自动解压，自动部署   -->
            <Host name="manager.test.com" appBase="webapps" unpackWARs="true" autoDeploy="true">
                <!--   定义远程地址访问策略，仅允许172.23.136.*网段访问该主机，其他的将被拒绝访问  -->
                <Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="172.23.136.*"/>
                <!--   定义该主机的访问日志      -->
                <Valve className="org.apache.catalina.valves.AccessLogValve" directory="/web/bbs/logs"
                       prefix="bbs_access." suffix=".log"
                       pattern="%h %l %u %t %r %s %b"/>
            </Host>
        </Engine>
    </Service>
</Server>
```

# Tomcat日志

## 日志概述

日志分为两种,系统日志和控制台日志

- 系统日志

  主要包含运行中日志和访问日志,分为5类:  catalina、localhost、manager、localhost_access、host-manager。在logging.properties文件中进行配置。 

- 控制台日志

   包含了catalina日志，另外包含了程序输出的日志（System打印，Console），可以将其日志配置输出到文件catalina.out中。 

## 日志级别

日志的级别分为如下 7 种：

SEVERE (highestvalue) > WARNING > INFO > CONFIG > FINE > FINER > FINEST (lowest value)

##  系统日志 

1. catalina日志

   Catalina引擎的日志文件，文件名catalina.日期.log 

2. localhost日志

   Tomcat下内部代码抛出异常的日志，文件名localhost.日期.log 

3. localhost_access

   默认 tomcat 不记录访问日志，server.xml文件中配置**Valve**可以使 tomcat 记录访问日志 

4. manager,host-manager

   Tomcat下默认manager应用日志 

##  控制台日志 

在Linux系统中，Tomcat 启动后默认将很多信息都写入到 catalina.out 文件中，我们可以通过tail -f catalina.out 来跟踪Tomcat 和相关应用运行的情况 

在windows下，我们使用startup.bat启动Tomcat以后，会发现catalina日志与Linux记录的内容有很大区别，大多信息只输出到屏幕而没有记录到catalina.out里面 

下面将要实现在Windows下,将相关的控制台输出记录到后台的catalina.out文件中以便将来查看:

1. 打开bin下面的 startup.bat文件，把最下面一行的`call "%EXECUTABLE%" start %CMD_LINE_ARGS% `改为 `call "%EXECUTABLE%" run %CMD_LINE_ARGS%`

   > 注：上面这样设置之后，运行tomcat后，日志就不会实时显示到tomcat运行窗口了。 

2. 打开bin下面的 catalina.bat文件，会发现文件里共有4处  `%ACTION%` ，在后面分别加上 `\>> %CATALINA_HOME%\logs\catalina.out` 

   > 注：windows中反斜杠和 linux是反的 

   重启tomcat，就会发现在logs文件夹下出现了catalina.out文件，把原来控制台的信息全写进去了。

   但输出的这个catalina.out文件，是一直增长的，也就是文件会越来越大。

3. 按照上面的修改，tomcat所有的日志都会写入到logs/catalina.out文件内，如果想要按天来生成日志文件，可以在 `%ACTION%` 后添加  `>> %CATALINA_HOME%/logs/catalina.%date:~0,4%-%date:~5,2%-%date:~8,2%.out`

   生成的格式为 catalina.yyyy-mm-dd.out（yyyy代表4位年份，mm代表为2位月份，dd代表两位日期） 

# 发布和优化

## 发布的几种方式

1. 在server.xml文件中找到`<Host>`标签元素，在其下使用`<Context>`标签配置，一个`<Context>`标签就代表一个web应用

   - path属性：虚拟目录的名称，也就是对外访问路径。

   - docBase属性：web应用所在硬盘中目录地址

   - reloadable属性：是否自动重新部署Web项目（项目内容修改后），建议false 

   示例:

   ```xml
   <Host appBase="webapps" autoDeploy="true" name="localhost" unpackWARs="true">
       <Context path="/myWebApp" docBase="D:\myWebApp"  reloadable="false"/>
   </Host>
   ```

   > 每次配置server.xml文件后，必须重启Tomcat服务器。

2. 自动映射webapps目录 

   tomcat服务器会自动管理webapps目录下的所有web应用，并把它映射成虚似目录。

   所以我们只需要将我们要部署的项目文件复制到webapps目录下,重启tomcat即可完成部署

##  JVM的配置

1. windows环境

   在tomcat 的bin下catalina.bat 里 ,在 `set CURRENT_DIR=%cd%`后面添加JVM参数 :

   ```shell
   set JAVA_OPTS=-Xms512m -Xmx512m -XX:ParallelGCThreads=8 -XX:PermSize=128m -XX:MaxPermSize=256m 
   ```

2. linux环境 

   bin/catalina.sh 里，在`# OS specific support. $var _must_ be set to either true or false.`后，在`cygwin=false`位置前，其实就shell代码开头，添加参数 

   ```shell
   set JAVA_OPTS=-Xms512m -Xmx512m -XX:ParallelGCThreads=8 -XX:PermSize=128m -XX:MaxPermSize=256m 
   ```

   然后运行startup.sh即可启动

# 参考文档

[Tomcat9官方文档](http://tomcat.apache.org/tomcat-9.0-doc/index.html)

[csdn-博客1](https://blog.csdn.net/weixin_40396459/article/details/81706543)

csdn-博客2

- [简介](https://blog.csdn.net/u014231646/article/details/79482195)
- [server.xml配置](https://blog.csdn.net/u014231646/article/details/79535925)
- [日志](https://blog.csdn.net/u014231646/article/details/79525071)
- [发布和优化](https://blog.csdn.net/u014231646/article/details/79539709)