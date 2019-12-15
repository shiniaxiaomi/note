# 介绍

freemarker是一款使用java代码编写的模板引擎，[官网](http://freemarker.org/)

# 原理

数据模型+模板=输出(html)

![image-20191204125401964](/Users/yingjie.lu/Documents/note/.img/image-20191204125401964.png)

# pom依赖

在pom文件中引入依赖即可

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-freemarker</artifactId>
</dependency>
```

# 配置

在springboot中配置

```properties
# 配置freemarker
spring.freemarker.cache=true //开启缓存
spring.freemarker.charset=utf-8 //设置编码格式
spring.freemarker.content-type=text/html //设置类型
spring.freemarker.suffix=.html //设置后缀
spring.freemarker.template-loader-path=classpath:templates //指定模版的路径
```

# 使用

## 基本使用

在ModelAndView对象中添加键值对

```java
@RequestMapping(value = {"/"})
public ModelAndView dirSearch(){
  ModelAndView modelAndView = new ModelAndView("index");
  modelAndView.addObject("value", "a");//设置键为‘value’，值为‘a’
  return modelAndView;
}
```

在模版中使用`${value}`即可将`a`渲染到模版中

## 设置默认值

`${value!'默认值'}`

> 如果不添加默认值，则可以直接使用`${value!}`，防止当value为null时报错







# 参考文档

