[TOC]

# 简介

Maven是一个跨平台的项目的项目管理工具。隶属于Apache下的一个开源项目，主要服务于Java平台的项目构建、依赖管理、项目信息管理等

在开发Java项目的时候，项目编译、测试、运行、打包等都有着极高的成本，maven就是为了解决这些问题，使用Apache的项目统一骨架和标准化的构建过程，包含了包版本管理、库依赖、集成测试、编译、安装、运行等

下面将分别从setting.xml、仓库、生命周期、插件等模块进行讲解

# 安装

[下载地址](http://maven.apache.org/download.cgi)

- mac、linux：需要下载Binary tar.gz archive
- windows：需要下载Binary zip archive

---

使用包管理工具安装：

- Mac下使用brew进行快速的安装

  ```shell
  brew search maven
  brew install maven
  ```

  

# 配置文件

setting.xml是maven的管理配置文件，包含了系统级别的配置和当前用户级别的配置，用户级别的路径是`~/.m2`。系统级别是`$M2_HOME/conf`（$M2_HOME是maven的安装路径），一般我们使用的是用户级别的配置文件

该文件可以配置仓库、代理、profile、镜像、插件等，更多更详细的配置[setting.xml](http://maven.apache.org/settings.html)

```xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                          https://maven.apache.org/xsd/settings-1.0.0.xsd">
      <localRepository/>
      <interactiveMode/>
      <usePluginRegistry/>
      <offline/>
      <pluginGroups/>
      <servers/>
      <mirrors/>
      <proxies/>
      <profiles/>
      <activeProfiles/>
</settings>
```

## localRepository

本地仓库地址，默认情况下，下载到本地的代码库存放在`${user.home}/.m2/repository`文件夹中，用户如果想存放在其他地方，配置该属性即可

## interactiveMode

用户交互模式，默认为true

## usePluginRegistry

是否使用插件仓库，默认为false，如果需要使用，则需要在当前目录下创建`plugin-registry.xml`文件并将该属性设置为true

## offline

是否在离线状态下运行，如果系统需要在离线状态下运行，则设置为true，默认为false

## pluginGroups

插件组，当插件的groupId没有显示提供时，供搜寻插件（groupId）的列表使用

```xml
<pluginGroups>
 <pluginGroup>org.mortbay.jetty</pluginGroup>
</pluginGroups>
```

如上述代码，包含了org.mortbay.jetty 的插件，例如，当我们需要执行该插件的run目标时，可以执行`org.mortbay.jetty:jetty-maven-plugin:run`，又或者可以简化成`mvn jetty:run`，关于为何会简化成如此，到插件的部分细说。

## servers

服务配置，主要是针对需要鉴权的仓库的配置，有些仓库默认匿名用户可以访问，但是可能存砸一些私服需要对用户鉴权，有相关权限的用户才可以继续访问或者操作

```xml
  <servers>
    <server>
      <id>server001</id>      <!-- 服务ID，和仓库ID关联 -->
      <username>my_login</username>   <!-- 用户名 -->
      <password>my_password</password>   <!-- 密码 -->  
      <privateKey>${user.home}/.ssh/id_dsa</privateKey>    <!-- 私钥路径 -->
      <passphrase>some_passphrase</passphrase>    <!-- 私钥密码 -->
      <filePermissions>664</filePermissions>  <!-- 文件被创建权限-->
      <directoryPermissions>775</directoryPermissions>  <!-- 文件夹被创建权限 -->
      <configuration></configuration>
    </server>
  </servers>
```

## mirrors

镜像地址，对仓库地址的一种映射关系，国外的仓库地址可能不是很稳定，然后alibaba和OSchina就搭建了镜像地址，我们可以配置镜像地址，是的下载镜像速度更快

```xml
  <mirrors>
    <mirror>
      <id>planetmirror.com</id>   <!-- 镜像ID，唯一性即可-->
      <name>PlanetMirror Australia</name>   <!-- 镜像名字 -->
      <url>http://downloads.planetmirror.com/pub/maven2</url>  <!-- 镜像地址 -->
      <mirrorOf>central</mirrorOf>  <!-- 映射的具体仓库ID以及其操作-->
    </mirror>
  </mirrors>
```

没有镜像的时候，需要直连A仓库，如果A仓库在国外可能速度会很慢

> **mirrorOf**，这个参数有多种配置，而且是针对仓库ID过滤的。更多细节可看官方文档[Guide to Mirror Settings](https://link.jianshu.com/?t=http://maven.apache.org/guides/mini/guide-mirror-settings.html)

国内镜像配置：

```shell
<!-- 阿里云仓库 -->
<mirror>
<id>alimaven</id>
<mirrorOf>central</mirrorOf>
<name>aliyun maven</name>
<url>https://maven.aliyun.com/repository/public</url>
</mirror>
```



## proxies

代理，主要是为了便于在各自网络环境下使用

```xml
<proxies>
    <proxy>
      <id>myproxy</id>   <!-- 代理ID，唯一性即可-->
      <active>true</active> <!-- 是否激活，激活了就可以使用该代理-->
      <protocol>http</protocol>
      <host>proxy.somewhere.com</host>
      <port>8080</port> <!-- 协议、主机、端口-->
      <username>proxyuser</username>
      <password>somepassword</password>
      <nonProxyHosts>*.google.com|ibiblio.org</nonProxyHosts>  <!-- 不代理的主机，中间用竖划线区分-->
    </proxy>
</proxies>
```

## profiles和activeProfiles

> profiles可以拥有多套环境，可以根据参数人意切换，如果使用需要在activeProfiles中加入该profile的ID即可

## Repositories

仓库的配置

```xml
<repositories>
  <repository>
    <id>codehausSnapshots</id> <!-- 仓库ID 需唯一 -->
    <name>Codehaus Snapshots</name>  <!-- 仓库名称 -->
    <releases>   <!-- 正式版本一-->
      <enabled>false</enabled>    <!-- 是否可正常使用 -->
      <updatePolicy>always</updatePolicy> <!-- 更新策略 -->
      <checksumPolicy>warn</checksumPolicy> <!-- 校验策略,分为ignore、fail、warn -->
    </releases>
    <snapshots>
      <enabled>true</enabled>
      <updatePolicy>never</updatePolicy>
      <checksumPolicy>fail</checksumPolicy>
    </snapshots>
    <url>http://snapshots.maven.codehaus.org/maven2</url> 
    <!-- 仓库地址，按protocol://hostname/path形式 -->
    <layout>default</layout> <!-- -->
  </repository>
</repositories>
```

> **updatePolicy** 更新策略，主要是如下几种值：
>
> `always` 总是更新
> `daily` 每天更新一次（默认值）
> `interval:X` X分钟更新一次
> `never` 永远都不更新

# 仓库

什么叫仓库呢？顾名思义就是存放物品的地方。在Java项目会使用到各种各样的jar包，为了避免每开发一个项目就导入jar包，就把所有的jar包统一都放在仓库中，使用的时候只需要在pom中生命所需要的jar包的GroupId和artifactId，那么maven就会帮我们自动引入jar包了

## 坐标和依赖

maven的坐标预定了世界上任何一个构建的位置，只需约定好正确的坐标，就可以正确的找到所需的构建，坐标元素包括groupId，artifactId，version等

### 坐标详解

- groupId（必选）：定义当前maven项目隶属的实际项目
- artifactId（必选）：实际项目中的一个maven模块
- version（必选）：版本号
- packaging（可选）：打包方式，常用的分为jar和war包，插件则是maven-plugin，默认为jar包
- classifier（不可直接定义）：帮助定义构建出一些附属构建，例如source和对应的doc

### 依赖配置

依赖配置是在pom文件中的配置的元素，在dependencies中，可以包含一个或者多个dependency元素，每个依赖包含如下元素

- groupId、artifactId、version依赖的基础坐标，最为重要

- type依赖的类型，对应到坐标的packaging，默认情况下不必声明，其值为jar

- scope依赖的范围，不同的依赖会使用不同的classpath

  > 1. compile 编译依赖的范围，没有指定则默认使用该范围
  > 2. test 测试，只对测试的classpath有效
  > 3. provided 已提供依赖范围，在编译和测试时有效，但是在运行时无效
  > 4. runtime 运行时的依赖范围
  > 5. system 系统依赖范围，和本机系统绑定
  > 6. import 导入依赖范围

- optional：依赖是否为可选，确认依赖是否被继承
- exclusions：排除传递性依赖

## 依赖调解

传递性依赖机制能够大大的简化依赖声明，而且大部分情况下我们只需要关心项目的直接依赖是什么，而不用考虑这些直接依赖会引入什么传递性依赖。但是当出现依赖冲突时，则需要清楚传递性依赖是是从什么依赖路径引入的

例如A项目有这样的依赖关系：A->B->C->X(1.0)，A->B->X(2.0)，那么哪个X版本会被引用？

第一原则：最短路径有限，上述例子中会使用X(2.0)版本，但是这并不能解决所有的问题，例如又有如下依赖关系：A->B->D(1.0), A->B->D(2.0)，使用最短路径就不能确定了

第二原则：第一声明者优先，这个例子中，如果D(1.0)版本在pom中更加靠前，则会使用D(1.0)版本

## 可选依赖

确认依赖是否被继承。现又如下依赖关系：A->B->X。如果B中有optional元素，那么，当其他引入A依赖时，此时就不会引入B依赖和X依赖

## 依赖查看

依赖可以通过dependency插件查看更多信息，例如`mvn dependency:tree`查看最后的依赖结果

- `dependency:list`：展示所有的依赖情况
- `dependency:tree`：树形结构展示依赖情况
- `dependency:analyze`：分析依赖树

# 生命周期和插件

软件开发的整个过程也是有生命周期的，开发、编译、测试以及部署，而maven的生命周期就是为所有对象构建过程进行的抽象和统一。maven的生命周期包含了项目的清理、初始化、编译、测试、打包以及集成测试，和最后的验证和部署操作。maven的生命周期本身是抽象的，不参与任何具体的工作，只是调用各种插件完成所需的任务，常见的插件有：

- maven-compiler-plugin 编译使用的插件
- maven-surefire-plugin 测试使用的插件
- maven-deploy-plugin 部署使用的插件

## 生命周期

mavne包含三大类相互独立的生命周期，具体的一个生命周期包含了多个阶段，在使用如下操作的时候，后台都会映射到各个插件上

包含的三大类生命周期是：

### clean生命周期

> pre-clean 清理项目前的准备工作
> clean 清理之前构建所生成的文件
> post-clean 执行一些清理完之后的事情

### default生命周期

> validate
> initialize
> generate-sources
> process-sources
> generate-resources
> process-resources
> compile 编译项目的代码输出到clasapath文件夹
> process-classes
> generate-test-sources
> process-test-sources
> generate-test-resources
> process-test-resources
> test-compile 编译项目的测试代码，输出到测试的classpath文件夹
> process-test-classes
> test 使用测试单元框架运行测试代码
> prepare-package
> package
> pre-integration-test
> integration-test
> post-integration-test
> verify
> install 安装到本地仓库
> deploy 部署到远程仓库

### site生命周期

> pre-site 执行生成项目站点文件前处理一些事情
> site 生成项目站点文件
> post-site 执行生成项目站点文件后处理一些事情
> site-deploy 部署站点文件到服务器



再次强调，生命周期本身是抽象的，具体的功能执行是由插件完成的，那么自然而然，插件肯定需要和生命周期以及生命周期的阶段进行绑定操作

常用的命令行操作

> mvn clean 真正执行的是clean的pre和clean阶段
>
> mvn test 真正执行的是default中直到test阶段的全过程
>
> mvn clean install 真正执行的是clean直到clean阶段以及default的到install阶段的全过程
>
> mvn clean deploy 真正执行的是clean直到clean阶段以及default的deploy阶段全过程

在进行操作的时候，如果出现了版本冲突等情况，可以加上参数 "-U" 或者 "--update-snapshots",其意思是`Forces a check for missing releases and updated snapshots on remote repositories`

## 插件配置

插件配置主要是给插件传递运行参数和修改插件映射到生命周期的阶段，主要有如下操作：

- 命令行配置

  > 例如在编译、安装的时候需要跳过测试，则可以使用 `mvn install -Dmaven.test.skil=true` 其中-D参数是java自带的，此功能是通过命令行设置一个java属性

- POM全局配置

  配置在项目的pom文件中的，整个项目都是通用的插件，例如下面的配置，就是给整个项目配置编译时使用的java版本，以及跳过执行测试功能等

  ```xml
  
  <plugins>
    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.1</version>
        <configuration>
            <source>${java_source_version}</source>
            <target>${java_target_version}</target>
            <encoding>${file_encoding}</encoding>
        </configuration>
    </plugin>
    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-surefire-plugin</artifactId>
        <configuration>
            <skipTests>true</skipTests>
        </configuration>
    </plugin>
  </plugins>
  ```

- POM任务配置

  > 和全局配置相对应，是对某个具体插件的参数设置，可以设置参数，也可以重新绑定生命周期的阶段phase

# 聚合和继承

该小节主要是涉及到多模块下的各个pom文件的关系。一个项目中如果存在多个模块，就会使得一个父POM挂着多个子POM

如果实际开发中，只是单独开发子模块，并不关心副模块，但是在子模块中引用父模块的时候需要指定父POM的路径，需要使用`relativePath`关键字。因为存在父模块，所以子模块只需要继承父POM引入的各种jar包，无需再次引入，类似于SpringBoot、junit等模块，存在父POM中即可

不过，同时又有另一种情况的存在，例如新加入的子模块，无需引入上述模块或所需的版本号不同，应该如何处理呢？

POM中的dependencyManagement元素即可以让子模块继承父模块的配置，也可以保证子模块的灵活性

接下来展示一个示例：

父模块

```xml
<properties>
  <spring.version>4.3.9.RELEASE</spring.version>
</properties>

<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-core</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-beans</artifactId>
      <version>${spring.version}</version>
    </dependency>
  </dependencies>
</dependencyManagement>
```

子模块

```xml
<parent>  
  <artifactId>itoo-base-parent</artifactId>  
  <groupId>com.tgb</groupId>  

  <version>0.0.1-SNAPSHOT</version>  
  <relativePath>../itoo-base-parent/pom.xml</relativePath>  
</parent>
<dependencies>
  <dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-core</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-beans</artifactId>
  </dependency>
</dependencies>
```

# 插件编写

- 引入API插件包

  ```xml
  <dependency>
    <groupId>org.apache.maven</groupId>
    <artifactId>maven-plugin-api</artifactId>
    <version>3.3.9</version>
  </dependency>
  ```

- 项目package

  ```xml
  <packaging>maven-plugin</packaging>
  ```

- Mojo文件

  ```java
  public class HelloMojo extends AbstractMojo {
    public void execute() throws MojoExecutionException, MojoFailureException {
  		//...
    }
  }
  ```

略

# 参考文档

[setting.xml](http://maven.apache.org/settings.html)

[Maven权威指南](https://book.huihoo.com/maven-the-definitive-guide/index.html)

[maven详解 - csdn](https://blog.csdn.net/qq_16605855/article/details/79726278)



