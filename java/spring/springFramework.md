[TOC]

# 概述

spring framework的核心是配置模型(AOP)和依赖注入(IOC),除此之外,spring framework还提供了基础服务,包括消息传递,事务处理和基于servlet的web服务框架(包含了springmvc和响应式的webFlux框架)

## spring和J2EE的关系

spring为了简化J2EE的开发而诞生的,spring遵循了J2EE的部分规范

- Servlet API 
- WebSocket API
- Concurrency Utilities (并发工具包)
- JSON Binding API 
- Bean Validation (校验)
- JPA 
- JMS (消息服务)

spring framework还遵循了IOC和AOP规范,我们可以根据我们的需要进行替换具体的实例

## servlet container 

springboot内嵌了tomcat容器,使得创建项目更加的快捷和便利,而且我们也可以根据我们的需要进行替换servlet容器,甚至于可以不是一个servlet容器(如netty)

## 设计理念

- 在每一个层级上都给用户提供回调的函数

  spring允许我们推迟决策,例如通过配置文件来修改属性,从而不会变动代码; 在其他基础设施上和第三方api的集成上也如此

- 容纳不同的观点

  spring非常的灵活,可以支持不同的应用场景

- 具有强大的向后兼容性

  spring的每个版本都会给我们选好对应的jdk版本和第三方库的版本

- 关心api接口的设计

- 为代码质量设置高标准,具有有意义的,最新和准确的javadoc



# Core

# Testing

# Data Access

# Web Servlet

# Web Reactive

# Integration

