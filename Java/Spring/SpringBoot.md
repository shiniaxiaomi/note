[TOC]

# 介绍



# 快速入门

介绍SpringBoot，系统要求，Servlet容器，安装SpringBoot，开发第一个SpringBoot应用



# 使用SpringBoot

构建系统

结构化代码

配置

SpringBean

依赖注入



# SpringBoot功能

配置文件

日志记录

安全性

缓存

Spring集成

测试



# 辅助功能

监控

指标

审核



# 部署SpringBoot应用程序



# SpringBoot CLI

安装

使用

配置



# 生成工具插件

Maven插件

Gradle插件

Antlib





# 其他相关记录

## 多配置文件

创建多个配置文件：

- application.properties

  主配置文件，可以决定是哪个配置文件生效

  ```properties
  spring.profiles.active=test
  ```

- application-dev.properties

- application-prod.properties

## 使用java -jar命令启动项目

- 指定生效的配置文件

  ```java
  java -jar xxx.jar --spring.profiles.active=prod
  ```

- 指定启动的端口

  ```java
  java -jar xxx.jar --server.port=8181
  ```

- 全都指定

  ```java
  java -jar plantip-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod --server.port=8002
  ```

## 使用java -jar命令后台启动项目

直接在命令后天添加`&`符号即可

项目的日志会输出到当前窗口，退出命令行窗口或使用`Ctrl+C`都不会终止应用

缺点是没有指定项目日志输出到指定目录，之后是无法查看日志的

```shell
java -jar xxx.jar --spring.profiles.active=prod &
```

- 添加日志输出的方法

  ```shell
  java -jar xxx.jar --spring.profiles.active=prod >log &
  ```

## 直接获取项目的pid

```shell
pgrep -f 项目相关名称或信息
```

示例：

```shell
pgrep -f plantip
```









# 参考文档

[SpringBoot官方文档](https://docs.spring.io/spring-boot/docs/2.2.0.RELEASE/reference/html/)

[SpringBoot 官方API](https://docs.spring.io/spring-boot/docs/2.2.0.RELEASE/api/)