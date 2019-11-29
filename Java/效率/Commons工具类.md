[TOC]

# 介绍

非常全面的工具类





# commons-exec工具类

[参考文档](http://commons.apache.org/proper/commons-exec/tutorial.html)

maven依赖

```xml
<dependency>
  <groupId>org.apache.commons</groupId>
  <artifactId>commons-exec</artifactId>
  <version>1.3</version>
</dependency>
```

## 同步执行命令

执行简单命令

```java
DefaultExecutor executor = new DefaultExecutor();
int execute = executor.execute(CommandLine.parse("ls"));
```

> 运行结果：
>
> ```java
> pom.xml
> src
> target
> util_test.iml
> ```

## 异步执行命令

```java
DefaultExecutor executor = new DefaultExecutor();
executor.setExitValue(1);
ExecuteWatchdog watchdog = new ExecuteWatchdog(60000);//设置超时时间为60秒
executor.setWatchdog(watchdog);
DefaultExecuteResultHandler resultHandler = new DefaultExecuteResultHandler();//设置异步执行
executor.execute(CommandLine.parse("git clone https://xxx/xxx.git"), resultHandler);
resultHandler.waitFor();//异步等待返回结果
```

## 设置一个监控狗

如果命令的执行时间超过指定时间，则终止命令

> 该命令是同步执行的，所以需要设置超时时间

```java
DefaultExecutor executor = new DefaultExecutor();
executor.setExitValue(1);//设置成功的返回值是1，如果后续执行命令后返回1，则程序正常结束
ExecuteWatchdog watchdog = new ExecuteWatchdog(60000);//指定命令运行的时间为60s，如果超过60s，则命令终止
executor.setWatchdog(watchdog);//设置监控狗
int execute = executor.execute(CommandLine.parse("git clone https://xxx/xxx.git"));
```

# commons-io工具类

单独引用的maven

```xml
<dependency>
  <groupId>commons-io</groupId>
  <artifactId>commons-io</artifactId>
  <version>2.4</version>
</dependency>
```

## 文件

### 创建文件

创建空文件（支持嵌套）

```java
FileUtils.touch(new File("/Users/yingjie.lu/Desktop/d/e/f"));
```

创建有内容的文件

```java
FileUtils.writeStringToFile(new File("/Users/yingjie.lu/Desktop/abc"),"sdfsdkfjsdkfsd");
```

### 读取文件

读取文件到List中

```java
List<String> context = FileUtils.readLines(new File("/Users/yingjie.lu/Desktop/abc"));//读取所有文件到一个List中的，一行内容是一个元素

//遍历读取的内容
Iterator<String> iterator = context.iterator();
while(iterator.hasNext()){
  System.out.println(iterator.next());
}
```

读取文件到String

```java
String s = FileUtils.readFileToString(new File("/Users/yingjie.lu/Desktop/abc"));
```

### 复制文件

```java
FileUtils.copyFile(new File("/Users/yingjie.lu/Desktop/abc"),new File("/Users/yingjie.lu/Desktop/abcd"));
```

### 移动文件

```java
FileUtils.moveFile(new File("/Users/yingjie.lu/Desktop/abc"),new File("/Users/yingjie.lu/Desktop/test/a"));
```

## 文件夹

### 创建文件夹

创建文件夹（支持嵌套文件夹）

```java
FileUtils.forceMkdir(new File("/Users/yingjie.lu/Desktop/a/b/c"));
```

### 复制文件夹

```java
FileUtils.copyDirectoryToDirectory(new File("/Users/yingjie.lu/Desktop/test"),new File("/Users/yingjie.lu/Desktop/test2"));
```

### 移动文件夹

```java
FileUtils.moveDirectoryToDirectory(new File("/Users/yingjie.lu/Desktop/test"),new File("/Users/yingjie.lu/Desktop/test2"),true);
```

> 第三个参数为是否需要保留原来的最外层文件夹，true则为保留

### 遍历文件夹

```java
FileUtils.listFilesAndDirs(new File("/Users/yingjie.lu/Desktop/test2"),new FileFilter(),new DirFilter());
```

> 需要自行创建文件过滤器和目录过滤器

文件过滤器如下：

```java
public class FileFilter extends AbstractFileFilter {
    @Override
    public boolean accept(File file) {
        //去除目录
        if(file.isDirectory()){
            return false;
        }
        //去除隐藏文件
        if(file.getName().startsWith(".")){
            return false;
        }
        System.out.println(file.getName());
        return true;
    }
}
```

目录过滤器如下：

```java
public class DirFilter extends AbstractFileFilter {
    @Override
    public boolean accept(File dir, String name) {
        //去除隐藏文件
        if(name.startsWith(".")){
            return false;
        }
        System.out.println(name);
        return true;
    }
}
```







# 参考文档

http://commons.apache.org/