每个blog都是有多个item组成的，可以在一个blog中随机的修改一个item，或者是删除和新增一个item

> 解决了快速定位的问题：一个要查看时的快速定位，一个是编辑新增时的快速定位，编辑和新增最好就是以弹窗的形式弹出，方便编辑

最终的toc目录可以由前端浏览器生成（根据dom生成即可），并且可以创建好滚动监听





重新构建博客的创建模式，搜索

想法：

- 只需要创建对应的单个内容点，标明大致是哪块内容的，有一个总体的admin管理可以进行目录的拖动和生成，但是刚创建的内容点只是被持久化了保存在数据库，后期还需要人为的处理才能发布成一个blog

- admin后台管理可以控制哪个blog的是否公布

- 每个内容点都是存在一张表中，被称为元数据，然后可以通过后台管理来组装内容点，之后可以通过层级结构的方式展示，或者是可以以瀑布流的方式展示

  > 这样就满足了便捷创建内容，记录灵感，后续又可以方便归纳整理

  在组装之后，访问过一次后，就可以使用redis进行存储

- 在搜索的时候，会搜索每个内容点，显示匹配的内容点的概要和匹配度，然后点击查看的时候可以直接跳转到对应的内容点显示

- 为每个已经发布的blog添加评论功能（支持无用户登入评论，如果希望得到回复，则填写邮箱即可）

- 自动保存（自动生成blogID），名字给默认，后续可以更改

  本地定时自动备份，在关闭时判断是否上传，如果没有，还是进行自动备份，并且自动备份有历史版本，可以恢复和回退

- blog也可以有目录结构，也可以平面的展示（按照发布日期）

  内容点也可以平面的展示（按照生成日期）

- 

---

tag也是有层级的（tag就是blog的层级路径）

---

表结构设计

User表

- id
- userName
- password
- visitCount

blog表

- id
- name
- desc
- md
- mdHtml
- tocHtml
- createTime
- updateTime
- pid

tag表

- id
- name
- count







spring注解的具体细节

spring事务传播

springcloud alibaba源码



jdk源码

mybatis源码

mysql

redis

消息队列rabbitmq



算法+源码



springbatch



CAP概念





k8s

docker

Arthas





> 通过xxlJob定时任务，定时的去mongo中分批的拉取数据，然后数据的格式进行转换并统计数据的数量，然后再将转换后的数据保存到mongo中



重点：

- mybatis（源码，缓存，xml）
- 事务
- redis相关（重要）





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

























