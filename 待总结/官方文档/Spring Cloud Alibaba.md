springcloud dubbo是建立在springcloud之上，涵盖了springcloud的功能，并提供了其他文档和成熟的实现：

| 领域           | Spring Cloud的实现                   | Dubbo Spring Cloud的实现                           |
| -------------- | ------------------------------------ | -------------------------------------------------- |
| 分布式配置     | Git、Zookeeper、Consul、JDBC         | Spring Cloud分布式配置+ Dubbo配置中心[6]           |
| 服务注册和发现 | Eureka、Zookeeper、Consul            | Spring Cloud本地注册中心[7] + Dubbo本地注册中心[8] |
| 负载均衡       | Ribbon（Random, RoundRobin）         | Dubbo内置实现（随机，轮询等+权重等）               |
| 断路器         | Spring Cloud Hystrix                 | Spring Cloud Hystrix +阿里巴巴前哨[9]等。          |
| 服务调用       | Open Feign、RestTemplate             | Spring Cloud服务调用+ Dubbo `@Reference`。         |
| 链路追踪       | Spring Cloud Sleuth[10] + Zipkin[11] | Zipkin，opentracing等                              |

[6]：Dubbo 2.7开始支持配置中心，并且可以自定义[-http://dubbo.apache.org/en-us/docs/user/configuration/config-center.html](http://dubbo.apache.org/en-us/docs/user/configuration/config-center.html)

[7]：除了Eureka，Zookeeper和Consul之外，Spring Cloud本机注册表还包括Nacos在Spring Cloud Alibaba中

[8]：达博本地注册中心- http://dubbo.apache.org/en-us/docs/user/references/registry/introduction.html

[9]：阿里巴巴Sentinel：Sentinel使用流量作为切入点来保护服务稳定性免受流控制，崩溃和系统负载保护等多个方面的影响-https: [//github.com/alibaba/Sentinel/wiki/%E4% BB％8B％E7％BB％8D](https://github.com/alibaba/Sentinel/wiki/介绍)，目前Sentinel已被Spring Cloud项目接受为断路器的候选人-https: [//spring.io/blog/2011/04/8/introducing-spring-cloud-circuit -断路器](https://spring.io/blog/2011/04/8/introducing-spring-cloud-circuit-breaker)

[10]：Spring Cloud Sleuth- [https](https://spring.io/projects/spring-cloud-sleuth) ://spring.io/projects/spring-cloud-sleuth

[11]：Zipkin- [https](https://github.com/apache/incubator-zipkin) : [//github.com/apache/incubator-zipkin](https://github.com/apache/incubator-zipkin)