# Tomcat源码构建

## 介绍

通过构建Tomcat的源码,可以在Tomcat的源代码中添加注释,方便阅读和记录

构建Tomcat源码也可以更加深刻的理解Tomcat

## 步骤

### 克隆代码

可以从github中克隆Tomcat的源代码([网址](https://github.com/apache/tomcat))

> 在克隆时,注意选择Tomcat的版本,建议选择8以上的版本
> 
> 本文将以Tomcat8.5.x版本为例进行构建

### 安装构建工具ant

mac用户直接使用命令`brew install ant`即可快速安装完成

> 其他系统可以自行百度或谷歌

### 导入idea和编译项目

通过idea打开克隆好的Tomcat源码项目

我们可以通过idea中的终端(或者是自带的终端)进行项目的编译

> 通过idea中的终端比较方便,因为打开终端后所在的项目路径就直接是Tomcat项目的根路径

我们在编译项目时,需要进入到项目的根目录下,然后输入命令`ant`即可开始编译,ant编译工具会找到根目录下的`build.xml`文件,按照该文件的要求进行下载和编译,项目编译完成后会在项目的根目录中生成`output`文件夹,文件夹的目录结构如图所示:

![image-20200113191551462](/Users/yingjie.lu/Documents/note/.img/image-20200113191551462.png)

> 其中的`build`目录就是编译构建好的tomcat的目录结构,就如我们平常下载Tomcat后的`/usr/local/Cellar/tomcat/9.0.27/libexec`目录下所看到的目录一样
> 
> 其中的`classes`文件夹可以先忽略,这个文件夹是idea在编译java文件时产生的class文件,我索性就直接指向到`output`目录下了,其实执行到其他地方问题也不大

在`build/lib`目录中,存放下载和编译完成的jar包,是Tomcat运行时必要的jar包,如果不小心删除了或者修改了,可以使用`ant`命令重新编译生成(注意需要在项目跟路径输入命令)

在`build`目录中,其实就展示了Tomcat的整体的目录结构,这个内容我会在另外一篇博客`Tomcat源码分析`中详细阐述

### 导入所需要的jar包

#### 在idea中指定java的源目录

![image-20200113192328372](/Users/yingjie.lu/Documents/note/.img/image-20200113192328372.png)

需要将`java`文件夹指定为`Sources`,这样才能能够将java文件,通过idea编译生成class文件

---

#### 添加jar包

在指定好`Sources`后,idea就会进行依赖解析,那么,在`java`文件夹中还需要一些依赖的jar,我们需要手动的添加到项目中

因为项目是使用`ant`编译构建的,所以,只能通过导入jar包的方式来添加:

1. 在项目的根目录中创建lib文件夹

2. 将以下jar包复制到lib文件夹下
   
   - [ant-1.10.7.jar](https://mvnrepository.com/artifact/org.apache.ant/ant/1.10.7)
   - [javax.xml.rpc-api-1.1.2.jar](https://mvnrepository.com/artifact/javax.xml.rpc/javax.xml.rpc-api/1.1.2)
   - [org.eclipse.jdt.core-3.20.0.jar](https://mvnrepository.com/artifact/org.eclipse.jdt/org.eclipse.jdt.core/3.20.0)
   - [wsdl-1.6.2.jar](https://mvnrepository.com/artifact/javax/wsdl/1.6.2)

3. 然后将他们都添加到Libraries中
   
   ![image-20200113193146443](/Users/yingjie.lu/Documents/note/.img/image-20200113193146443.png)
   
   > 添加好之后,idea就不会报错了

### 在idea中添加启动项

具体的配置如图所示:

![image-20200113201222926](/Users/yingjie.lu/Documents/note/.img/image-20200113201222926.png)

---

下面是记录添加启动项的心路历程:

这个弄了我挺久的,因为我之前直接通过指定`org.apache.catalina.startup.Bootstrap`启动类,项目虽然启动了,但是启动后报错,并且访问`http:localhost:8080`时,页面显示500,并且后台报错

但是,我始终坚信,使用`Bootstrap`当做启动类肯定是没问题的,但是报错的原因可能是在启动时需要指定一些参数

因此,我就先使用`output/build/bin/startup.sh`来启动Tomcat,我发现Tomcat被正常启动,并且能够正常访问,所以,我就打开`startup.sh`脚本进行阅读,发现该脚本最终调用的`catalina.sh`脚本将Tocmat启动的,因此,我又开始阅读`catalina.sh`脚本

最终,发现该脚本使用以下命令启动了Tomcat:

```shell
eval $_NOHUP "\"$_RUNJAVA\"" "\"$LOGGING_CONFIG\"" $LOGGING_MANAGER "$JAVA_OPTS" "$CATALINA_OPTS" \
      -D$ENDORSED_PROP="\"$JAVA_ENDORSED_DIRS\"" \
      -classpath "\"$CLASSPATH\"" \
      -Dcatalina.base="\"$CATALINA_BASE\"" \
      -Dcatalina.home="\"$CATALINA_HOME\"" \
      -Djava.io.tmpdir="\"$CATALINA_TMPDIR\"" \
      org.apache.catalina.startup.Bootstrap "$@" start \
      >> "$CATALINA_OUT" 2>&1 "&"
```

因此,我在该命令上方使用`echo`命令输出了执行的命令:

```shell
echo $_NOHUP "\"$_RUNJAVA\"" "\"$LOGGING_CONFIG\"" $LOGGING_MANAGER "$JAVA_OPTS" "$CATALINA_OPTS" \
      -D$ENDORSED_PROP="\"$JAVA_ENDORSED_DIRS\"" \
      -classpath "\"$CLASSPATH\"" \
      -Dcatalina.base="\"$CATALINA_BASE\"" \
      -Dcatalina.home="\"$CATALINA_HOME\"" \
      -Djava.io.tmpdir="\"$CATALINA_TMPDIR\"" \
      org.apache.catalina.startup.Bootstrap "$@" start
```

然后,在控制台中输出的内容为:

```shell
"/Library/Java/JavaVirtualMachines/jdk1.8.0_201.jdk/Contents/Home/bin/java" 
"
-Djava.util.logging.config.file=/Users/yingjie.lu/Code/tomcatSource/output/build/conf/logging.properties" 
-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager  
-Djdk.tls.ephemeralDHKeySize=2048 
-Djava.protocol.handler.pkgs=org.apache.catalina.webresources 
-Dorg.apache.catalina.security.SecurityListener.UMASK=0027  
-Dignore.endorsed.dirs="" 
-classpath "/Users/yingjie.lu/Code/tomcatSource/output/build/bin/bootstrap.jar:/Users/yingjie.lu/Code/tomcatSource/output/build/bin/tomcat-juli.jar" 
-Dcatalina.base="/Users/yingjie.lu/Code/tomcatSource/output/build" 
-Dcatalina.home="/Users/yingjie.lu/Code/tomcatSource/output/build" 
-Djava.io.tmpdir="/Users/yingjie.lu/Code/tomcatSource/output/build/temp" org.apache.catalina.startup.Bootstrap start
```

最终我发现,我漏掉了最重要的JVM参数:`-Dcatalina.base="/Users/yingjie.lu/Code/tomcatSource/output/build"`

因此,我把这个参数添加上之后,项目就可以正常启动,并且可以正常访问了

## 启动项目

运行项目

![image-20200113201738297](/Users/yingjie.lu/Documents/note/.img/image-20200113201738297.png)

访问查看是否成功

## 解决乱码问题

不管怎么设置,好像都解决不了Tomcat的乱码的问题,所以只能在JVM的运行参数中添加以下参数,将编码修改为美国英文是较为不错的解决办法:

`-Duser.language=en -Duser.region=US`

![image-20200113205835536](/Users/yingjie.lu/Documents/note/.img/image-20200113205835536.png)

## 注意事项

我们在重新启动Tomcat时,idea只会编译修改的java文件,而不会将配置文件也编程生成到`output/build`目录下,所以,如果我们修改了配置文件,那么需要将项目重新编译,则可以使用ant工具方便的执行,如图所示:

![image-20200113203848536](/Users/yingjie.lu/Documents/note/.img/image-20200113203848536.png)