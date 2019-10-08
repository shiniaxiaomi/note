[TOC]

# JVM概述

## JVM原理

下图就展示了java的一次编译,到处运行

![img](.img/.jvm/352511-20170810232429980-107444580.png)

Java程序经过一次编译之后,将java代码编译为字节码也就是class文件,然后在不同的操作系统上依靠不同的java虚拟机进行解释,最后在转换为不同平台的机器码,最终得到执行;

## 一个普通的java代码的执行过程

一个HelloWorld类

```java
public class HelloWorld{
    public static void main(String[] args){
        System.out.print("Hello world");
    }
}
```

下面是JVM将HelloWorld类加载并执行的过程,如图所示:

![img](.img/.jvm/352511-20170810232431105-2080375000.png)

java代码通过编译之后生成字节码文件(class文件),通过:`java HelloWorld`命令执行后,此时java根据系统版本找到jvm.cfg

> 该文件一般位于`C:\Program Files\Java\jdk1.8.0_101\jre\lib\amd64\jvm.cfg`路径下
>
> ![img](.img/.jvm/352511-20170810232432183-490667295.png)

其中-server KNOWN就标识名称为server的jvm可用; 如果这时你搜索你电脑上的jvm.dll,你就会发现它一定在你的某个server目录下,比如我的`C:\Program Files\Java\jdk1.8.0_101\jre\bin\server\jvm.dll`; 简而言之就是通过jvm.cfg文件找到对应的jvm.dll(jvm.dll是java虚拟机的主要实现),然后进行初始化JVM,并获取JNI接口

> JNI接口就是java本地接口,它可以从硬盘中找到对应的class文件并将其装载到jvm中(它还常用于java与操作系统和硬件交互)

通过JNI接口找到class文件并装载进JVM,然后找到mian方法,最后执行

## JVM的生命周期

### JVM实例

一个运行时的java虚拟机负责运行一个java程序

当启动一个java程序时,一个虚拟机实例诞生, 当程序关闭退出,这个虚拟机实例也随之消亡

如果在同一台计算机上同时运行多个java程序,将得到多个java虚拟机实例,每个java程序都运行于它自己的虚拟机实例中

### 生命周期

1. JVM创建

   当启动一个java程序时,一个JVM实例就产生了,任何一个拥有main函数的class都可以作为JVM实例运行的起点

2. JVM运行

   main()作为程序初始线程的起点,任何其他线程均由该主线程启动; JVM内部有两种线程: 守护线程和非守护线程; 主线程属于非守护线程,守护线程通常由JVM自己使用

3. JVM消亡

   当程序中的所有非守护线程都终止时,JVM才退出; 若安全管理器允许,程序也可以使用java.lang.Runtime类或者java.lang.System.exit()来退出

## JVM各区域潜在的异常

- PC寄存器

  此区域是JVM规范中唯一一个不存在OutOfMemory的区域。

- java栈

  1. StackOverflowError ：栈深度大于虚拟机所允许的深度。

  2. OutOfMemory：如果虚拟机栈可以动态扩展（当前大部分Java虚拟机都可以动态扩展，只不过Java虚拟机规范中也允许固定长度的虚拟机栈），如果扩展是无法申请到足够的内存

- 本地方法栈
  1. StackOverflowError ：栈深度大于虚拟机所允许的深度。
  2. OutOfMemory

- java堆
  
1. OutOfMemory: 堆无法扩展时
  
- 方法区
  
  1. OutOfMemory: 超出内存容量

# JVM基本结构

## 结构图

![img](.img/.jvm/352511-20170810232433277-922435213.png)

主要分为三大类:

1. 类装载器(ClassLoader)
2. 执行引擎
3. 内存空间(方法区,java堆,java栈,本地方法栈,PC寄存器)

## 类装载器ClassLoader

### 类加载机制

JVM把字节码.class文件加载到内存,并对数据进行校验,转换解析和初始化,最终形成可以被虚拟机直接使用的java对象,这就是虚拟机的类加载机制

### 类加载器

类从被加载到虚拟机内存中开始,到卸载出内存为止,它的生命周期包括了:加载(Loading),验证(Verification),准备(Preparation),解析(Resolution),初始化(Initialization),使用(Useing),卸载(Unloading)七个阶段,其中验证,准备,解析三个部分统称为链接

![img](.img/.jvm/20180517171259199.png)

1. 加载(重点)

   加载阶段通常也被称为"装载",主要完成:

   1. 通过"全类名"来获取定义此类的二进制字节流
   2. 将字节流所代表的静态存储结构转换为方法区的运行时数据结构
   3. 在java堆中生成一个代表这个类的java.lang.Class对象,作为方法区这些数据的访问入口

   相对于类加载过程的其他阶段,加载阶段(准确的说是加载阶段中获取类的二进制字节流的动作)是开发期可控性最强的阶段,因为加载阶段可以使用系统提供的类加载器(ClassLoader)来完成,也可以有用户自定义的类加载器完成,开发人员可以通过定义自己的类加载器区控制字节流的获取方法

   加载阶段完成后,虚拟机外部的二进制字节流就按照虚拟机所需的格式存储在方法

2. 验证(了解)

3. 准备(了解)

4. 解析(了解)

5. 初始化(了解)

6. 使用

7. 卸载

### 双亲委派模型

## 执行引擎

## 内存空间

### 方法区

### java堆

### java栈

### 本地方法栈

### PC寄存器

# JVM内存模型

# 垃圾收集器(GC)

## JVM垃圾回收机制

## 常见的垃圾回收器

## Minor GC,Full GC触发条件

## 降低GC的调优策略

# 参考文档

[深入详细讲解JVM原理](https://blog.csdn.net/know9163/article/details/80574488)

https://www.cnblogs.com/yuechuan/p/8984262.html

http://blog.itpub.net/29609890/viewspace-2219916/