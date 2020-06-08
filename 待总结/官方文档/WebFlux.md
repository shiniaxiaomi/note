## 文档

官方文档：https://docs.spring.io/spring/docs/current/spring-framework-reference/web-reactive.html

Mono API：https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Mono.html

Flux API：https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html



其他文档：

- 详细的WebFlux响应式编程参考博客：https://blog.csdn.net/get_set/article/details/79466657

- SpringMVC和WebFlux的性能对比：https://blog.csdn.net/get_set/article/details/79492439

## 概述

WebFlux是一个非阻塞（可实现异步，但对于客户端来说都是同步）的web框架，使用少量线程和更少的硬件资源（内存）就能够处理大量的请求。

使用WebFlux框架需要使用实现了NIO的web服务器，比如Netty，Tomcat，Jetty，Undertow和Servlet3.1+容器。

它不是用来代替springmvc的。它和springmvc相比，因为它的不能加快处理速度（反而会更慢一些，因为使用Stream写法的缘故），但是通过非阻塞的方式可以使用比较少的固定数量的线程和较少的内存进行处理大量的请求，两者相比，使用WebFlux能够提高系统的吞吐量（如果延迟越大，提升的效果越明显）。

> 减少了线程阻塞，减少了线程的上下文切换









