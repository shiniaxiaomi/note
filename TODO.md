报销流程

吉旅报销





https://cloud.spring.io/spring-cloud-static/spring-cloud-gateway/2.2.2.RELEASE/reference/html/

- Gateway

https://cloud.spring.io/spring-cloud-static/spring-cloud-netflix/2.2.2.RELEASE/reference/html/

- zuul
- hystrix断路器
- ribbon负载均衡

http://dubbo.apache.org/zh-cn/docs/user/quick-start.html

- dubbo

https://docs.spring.io/spring/docs/current/spring-framework-reference/web-reactive.html

- webflux

基础内容











自己搭建Jenkins，然后将blog项目进行自动化部署

看一下swagger







A依赖B，B依赖A

1. 先创建A实例，第一次调用getSingleton方法时，标记A正在创建，然后调用A的无参构造方法创建A实例，然后正常的初始化A，在自动装配的时候发现需要B，此时发现B还没有被创建，则去创建B
2. 创建B实例，第一次调用getSingletion方法时，标记B正在创建，然后调用B的无参构造方法创建B实例，然后正常的初始化B，在自动装配的时候发现需要A，发现A已经被创建（因为之前已经标记A正在创建，所以不会再继续创建A，而是可以直接获取到A实例），然后就把A装配到B中，那么B就创建好了
3. 当B创建好之后，A继续自动装配，将B装配到A中，那么A就创建好了

























