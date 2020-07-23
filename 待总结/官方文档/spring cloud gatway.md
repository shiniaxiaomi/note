## 依赖

 `spring-cloud-starter-gateway`

## 三个概念

- **Route** 
  
  包含了id，目标url，和一系列Predicate（判断）和一些列Filter（过滤器），如果Predicate为true，则表示路由匹配

- **Predicate** 
  
  它的输入类型是 [`ServerWebExchange`](https://docs.spring.io/spring/docs/5.0.x/javadoc-api/org/springframework/web/server/ServerWebExchange.html) ，能够匹配任何的http的请求，比如根据请求头信息或请求参数进行匹配

- **Filter**
  
  [`GatewayFilter`](https://docs.spring.io/spring/docs/5.0.x/javadoc-api/org/springframework/web/server/GatewayFilter.html) 是它的实现类，所有的请求都会经过Filter正向过滤和反向过滤，我们可以通过Filter对请求和响应添加一些数据

## 工作流程

![image-20200519140326189](D:\note\.img\image-20200519140326189.png)

客户端访问网关，请求首先交给网关的Handler Mapping处理，根据设定的Predicate判断是否匹配，如果匹配，则将请求交给Web Handler，解析到正真要访问的微服务，接着请求会经过一系列的Filter过滤后，然后请求到微服务，然后再原路返回

## 配置路由的Predicate和Filter

在配置文件中设置路由的Predicat判断规则
