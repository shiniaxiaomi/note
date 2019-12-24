# 介绍

Gradle是一个通用的灵活的构建工具

像maven一样的基于约定优于配置的构建框架

# 安装

1. 首先检查你的jdk版本

   ```shell
   $ java -version
   java version "1.8.0_121"
   ```

2. 安装gradle

   ```shell
   brew install gradle
   ```

3. 将gradle的源改为国内的

   创建`~/.gradle/init.gradle`文件

   ```shell
   vim ~/.gradle/init.gradle
   ```

   ```js
   allprojects{
     repositories {
       def ALIYUN_REPOSITORY_URL = 'http://maven.aliyun.com/nexus/content/groups/public'
       def ALIYUN_JCENTER_URL = 'http://maven.aliyun.com/nexus/content/repositories/jcenter'
       all { ArtifactRepository repo ->
         if(repo instanceof MavenArtifactRepository){
           def url = repo.url.toString()
           if (url.startsWith('https://repo1.maven.org/maven2')) {
             project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_REPOSITORY_URL."
             remove repo
           }
           if (url.startsWith('https://jcenter.bintray.com/')) {
             project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_JCENTER_URL."
             remove repo
           }
         }
           }
       maven {
         url ALIYUN_REPOSITORY_URL
         url ALIYUN_JCENTER_URL
       }
     }
   }
   ```

4. 在第一次项目构建的时候，需要下载`https\://services.gradle.org/distributions/gradle-6.0.1-all.zip`文件，但是由于网络问题，不能够下载，导致项目不能够正常的编译，所以，我们需要通过其他途径来解决改问题
   - 先通过各种途径下载到`gradle-6.0.1-all.zip`文件（方法就不多解释了），然后将下载文件放在`~/.gradle`目录下
   - 将本地的该文件的地址即`file:///Users/yingjie.lu/.gradle/gradle-6.0.1-all.zip`复制到`gradle-wrapper.properties`文件中的`distributionUrl`属性值下
   - 在重新构建即可

# 构建基础

projects和tasks是Gradle中最重要的两个概念

任何一个Gradle构建都是有一个或多个projects组成。每个project包括许多可构建组成部分。这完全取决与我们想要构建些什么。

每个project都有多个tasks组成。每个task都代表了构建执行过程中的一个原子性操作。如编译，打包，生成javadoc，发布到某个仓库等操作。

build.gradle文件是构建脚本，当执行gradle命令时，会从默认的从当前目录下寻找build.gradle文件来执行构建。

## Hello World

### 第一个构建脚本

创建一个build.gradle文件

```js
task hello {
    println 'Hello world!'
}
```

然后在该文件目录中命`gradle -q hello`

> -q参数用来控制gradle的日志级别，可以保证只输出我们需要的内容

运行结果：

```shell
$ gradle -q hello
Hello world!
```

---

上面的脚本定义了一个叫做hello的task，并且给他添加了一个动作。当执行`gradle hello`时，Gradle便会去调用hello这个任务来执行

### 在任务脚本中编写代码

```js
task upper {
  String someString = 'mY_nAmE'
  println "Original: " + someString
  println "Upper case: " + someString.toUpperCase()
}
```

> 定义变量，输出变量，输出变量转大写

### 任务依赖

一个任务如果依赖另一个任务，则会自动的先执行另一个依赖的任务

```js
task hello {
    println 'Hello world!'
}
task intro(dependsOn: hello) {
    println "I'm Gradle"
}
```

> `intro`任务依赖`hello`任务

执行命令：`gradle intro`

执行结果：

```shell
$ gradle intro
Hello world!
I'm Gradle
```

## 延迟依赖

延迟依赖的意思是，当执行到X任务，而X任务依赖Y任务，但是此时Y任务还为定义（即Y任务的定义在X任务下方），那么此时的任务依赖的名称应该使用单引号`''`来标注

```js
task taskX(dependsOn: 'taskY') {
    println 'taskX'
}
task taskY {
    println 'taskY'
}
```

执行命令：`gradle taskX`

执行结果：

```shell
$ gradle taskX
taskY
taskX
```

> 不同于上面的任务依赖的是，`dependsOn: 'taskY'`中的taskY是用单引号包裹的

## 在任务中采用groovy进行编程

```js
task count {
    4.times { print "$it " }
}
```

> `4.time{}`表示`{}`中的内容要执行4次，`$it`是获取到每次遍历的值

运行命令：`gradle count`

运行结果：

```shell
$ gradle count
0 1 2 3 
```

## 动态任务

```js
4.times { counter ->
    task "task$counter" {
        println "I'm task number $counter"
    }
}
```

执行命令：`gradle`

执行结果：

```shell
$ gradle -q
I'm task number 0
I'm task number 1
I'm task number 2
I'm task number 3
```

## 定义默认任务

```js
defaultTasks 'clean', 'run'
task clean {
    println 'Default Cleaning!'
}
task run {
    println 'Default Running!'
}
task other {
    println "I'm not a default task!"
}
```

> 定义clean和run是默认任务

执行命令：`grable`

执行结果：

```shell

```

# Java构建入门

Gradle是一个通用的工具，通过他可以构建任何想要实现的东西

大部分java项目的构建的流程基本是相似的：编译源文件，进行单元测试，创建jar包等，在使用gradle构建时，没必要为每个工程写一个构建脚本，因此，gradle已经提供了完美的插件来直接解决java项目的构建问题

## 添加java构建插件

创建build.gradle文件，在文件中添加一下代码

```js
apply plugin: 'java'
```

> 该代码添加java插件及其一些内置任务

## Gradle中标准的目录结构

```js
project  
    +build  
    +src/main/java  
    +src/main/resources  
    +src/test/java  
    +src/test/resources  
```

> gradle默认会从 `src/main/java` 搜寻打包源码，在 `src/test/java` 下搜寻测试源码。并且 `src/main/resources` 下的所有文件按都会被打包，所有 `src/test/resources` 下的文件 都会被添加到类路径用以执行测试。所有文件都输出到 build 下，打包的文件输出到 build/libs 下。

### 通过gradle命令初始化项目

创建目录：`mkdir basic-demo`

初始化项目：`gradle init`（选项全部选择默认即可）

创建后的项目目录结构：

```js
├── build.gradle  
├── gradle
│   └── wrapper
│       ├── gradle-wrapper.jar  
│       └── gradle-wrapper.properties  
├── gradlew  
├── gradlew.bat  
└── settings.gradle
```

> build.gradle：Gradle的构建脚本
>
> gradle-wrapper.jar：分级包装器可执行JAR
>
> gradle-wrapper.properties：分级包装配置属性
>
> gradlew：unix系统的gradle包装器脚本
>
> gradlew.bat：windows系统的gradle包装器脚本
>
> settings.gradle：配置gradle的构建脚本

## 构建项目

执行命令`gradle build`即可

## 其他构建的常用命令

- `gradle clean`

  > 删除build目录已经所有构建完成的文件

- `gradle assemble`

  > 编译并打包jar文件，当不会执行单元测试

- `gradle check`

  > 编译并测试代码

## 外部依赖

通常Java项目会有很多外部的依赖，我们需要告诉Gradle如何找到并引用这些外部文件的依赖

在Grable中，jar包通常都存在于仓库中，仓库可以用来搜寻依赖或发布项目产物。

#### 添加Maven仓库

在`build.gradle`中添加以下代码

```js
repositories {
    mavenCentral()
}
```

#### 添加依赖

在`build.gradle`中添加以下代码

```js
dependencies {
  compile group: 'commons-collections', name: 'commons-collections', version: '3.2'
  testCompile group: 'junit', name: 'junit', version: '4.+'
}
```

> 声明了编译期所需 commons-collections 依赖和测试期所需 junit依赖。

#### 发布jar包

在`build.gradle`中添加以下代码

```js
uploadArchives {
    repositories {
       flatDir {
           dirs 'repos'
       }
    }
}
```

> 执行`gradle uploadArchives`可以发布jar包
>
> 指定将jar包发布到指定的目录（即本地仓库或者是远程仓库）

## 构建脚本Demo

```js
apply plugin: 'java' //添加java插件
sourceCompatibility = 1.5 //指定jdk的版本
version = '1.0' //指定项目的版本

repositories { //指定仓库
    mavenCentral()
}

dependencies { //执行项目所需要的依赖
    compile group: 'commons-collections', name: 'commons-collections', version: '3.2'
    testCompile group: 'junit', name: 'junit', version: '4.+'
}

uploadArchives { //指定jar生成后发布到的仓库地址
    repositories {
       flatDir {
           dirs 'repos'
       }
    }
}
```

## 多项目构建

详细参考[链接](https://www.w3cschool.cn/gradle/9b5m1htc.html)中的`多项目构建`

## 在idea中构建项目并运行

首次创建项目后，idea可能会提示你需要安装插件，本质上就是下载`gradle-5.2.1-all.zip`压缩包，然后这个下载地址时定义在项目的`gradle/wrapper/gradle-wrapper.properties`文件中的`distributionUrl`属性值中，如果我们通过其他途径将该压缩包下载好，然后放在我们本地，将本地的压缩包路径复制到`distributionUrl`属性值中即可，那么在直接运行java代码时，gradle就会直接通过build.gradle构建脚本构建，然后在运行对应的java文件

> 在属性中执行本地路径时只要在路径前加上`file://`前缀
>
> 示例：`file:///Users/yingjie.lu/.gradle/gradle-5.2.1-all.zip`



项目中的build.gradle的示例：

```js
apply plugin: 'java'

group 'com.lyj'
version '1.0-SNAPSHOT'

sourceCompatibility = 1.8

repositories {
    mavenCentral()
}

dependencies {
    testCompile group: 'junit', name: 'junit', version: '4.12'
    compile group: 'com.alibaba', name: 'fastjson', version: '1.2.58'
}
```

## 添加依赖时的搜索地址

就是平常的中央maven地址：`https://mvnrepository.com/`

找到对应的依赖后，选择第二个选项即可，如图所示：

![image-20191225000522570](/Users/yingjie.lu/Documents/note/.img/image-20191225000522570.png)

# 依赖管理

## 依赖声明

```js
dependencies {
  compile group: 'org.hibernate', name: 'hibernate-core', version: '3.6.7.Final'
  testCompile group: 'junit', name: 'junit', version: '4.+'
}
```

> `compile group`声明的是编译期必须依赖，并且相关的依赖一并加载进来
>
> `testCompile group`声明的是测试阶段的依赖，发布时不会将依赖加入
>
> `runtime group`声明的是运行阶段和测试阶段需要的，但是编译时不需要
>
> `testRuntime group`声明的是测试运行阶段需要的，

## 简洁声明依赖

```js
dependencies {
    compile 'org.hibernate:hibernate-core:3.6.7.Final'
}
```

## 仓库

### 使用Maven中央仓库

在build.gradle中添加Maven中央仓库即可

```js
repositories {
    mavenCentral()
}
```

或是通过url来指定对应的maven仓库

```js
repositories {
    maven {
        url "http://repo.mycompany.com/maven2"
    }
}
```

## 打包发布

通常不需要做额外的配置，即可进行打包发布

在build.gradle文件中添加指定要发布的本地地址或远程地址，然后执行`gradle uploadArchives`命令即可打包发布

### 发布到本地

```js
apply plugin: 'maven'
uploadArchives {
    repositories {
        mavenDeployer {
            repository(url: "file://localhost/tmp/myRepo/")
        }
    }
}
```





```js
plugins {
    id 'java'
}

group 'com.lyj'
version '1.0-SNAPSHOT'

sourceCompatibility = 1.8

repositories {
    mavenCentral()
}

dependencies {
    testCompile group: 'junit', name: 'junit', version: '4.12'
}



rootProject.name = 'gradle_startdemo'
```







# 参考文档

[gradle-w3cschool](https://www.w3cschool.cn/gradle/sh8k1htf.html)









