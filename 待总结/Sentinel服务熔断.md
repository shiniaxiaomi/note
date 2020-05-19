## 依赖

添加Sentinel依赖：

```xml
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-sentinel</artifactId>
</dependency>
```



## 概述

所有微服务都引入Sentinel依赖，然后通过`@SentinelResource`注解用于标识资源是否受速率限制或降级，如果当该服务的调用超过设置值时，服务将会被熔断



所有的微服务都可以连接到Sentinel的dataBoard仪表盘来进行数据统计，进行可视化的展示

## 仪表盘

> 可选项，它是独立与整个微服务的，所有微服务将数据上传仪表盘进行数据统计并可视化

通过运行Sentinel的dataBoard对所有微服务进行可视化

## 使用



