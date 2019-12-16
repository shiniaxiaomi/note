# 介绍

Elasticsearch是一个分布式文档存储，将数据存储在内存中，通过反向索引等，可以快速检索相关内容

# 原理

## Elasticsearch的结构与传统数据库对比

| Elasticsearch | 传统数据库 |
| :-----------: | :--------: |
|     index     |   数据库   |
|     type      |   数据库   |
|   document    |     行     |
|     field     |     列     |

## 数据输入（索引和文档）

一个索引为一个数据库，一个文档代表数据库中的一条行记录，表的概念被弱化，行数据的数据格式不是固定的，每次插入一行数据时，Elasticsearch都会进行重新建立索引，这个建立索引的时间很快（1s之内）

Elasticsearch使用反向索引来提供全文检索的功能。反向索引即将所有文档中出现的词都单独建立一个索引，并标记这些单词在哪些文档中出现过。

Elasticsearch可以对文档内容自动索引，无需显式的指定索引结构。Elasticsearch会检测和映射布尔值、浮点、整数、日期和字符串类型的数据

> 不过官方建议最好是我们能够自己定义好索引（效率更高），为相同字段建立不同索引可以起到不同的效果
>
> 1. 可以区分文本字符串和数值字符串
> 2. 使用自定义日期格式
> 3. 使用无法自动检测的数据类型

## 数据输出（查询和分析）

Elasticsearch提供了REST API来方便查询和分析数据

除了使用REST API（JSON方式）查询外，还可以通过SQL方式进行查询，功能更加强大

Elasticsearch的聚合功能使得分析数据变得简单。

## 高扩展和高可用（集群、节点和碎片）

Elasticsearch的数据都保存在主碎片中。

当建立集群时，Elasticsearch会将主碎片复制到每个节点，用来备份数据（备份碎片）及增加查询能力。它可以从每个节点搜索数据并汇总。

> 备份的碎片是只读的，只有主碎片的更改才能导致备份碎片的更改

当集群节点增加或减少时，Elasticsearch可以自动的调整集群和数据的备份及查询。

> 性能权衡：
>
> 碎片大小，主碎片的数量都会影响Elasticsearch重新调整集群。
>
> 碎片体积越大，调整集群耗时越大。主碎片越多，需要维护索引的开销越大

在查询时，大量查询小碎片比少量查询大碎片要慢。

当主集群宕机时，那么其他集群将取而代之。

官方推荐使用[Kibana](https://www.elastic.co/guide/en/kibana/7.4/introduction.html)来进行管理集群

# 安装

## 安装Elasticsearch

### mac

安装命令：`brew install elasticsearch`

运行命令：`elasticsearch`

关闭：如果前台运行直接`Ctrl+C`

### linux

使用docker进行安装

1. 安装docker

   `apt install docker.io`

2. 安装elasticsearch

   `docker pull docker.elastic.co/elasticsearch/elasticsearch:6.8.5`

3. 启动elasticsearch

   `docker run -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:6.8.5`

## 默认设置

### 默认的存储路径

data：`/usr/local/var/lib/elasticsearch/`

logs：`/usr/local/var/log/elasticsearch`

plugins：`/usr/local/var/elasticsearch/plugins/`

config：`/usr/local/etc/elasticsearch/`

### 默认端口和地址

http://127.0.0.1:9200/

### 查询健康API

http://127.0.0.1:9200/_cat/health?v

## 多实例运行

### mac

```shell
elasticsearch -Epath.data=data2 -Epath.logs=log2
elasticsearch -Epath.data=data3 -Epath.logs=log3
```

> 为每个elasticsearch指定数据和日志的路径即可

### linux

启动多个docker运行elasticsearch即可

# RestHighLevelClient操作（***）

Java客户端工具，[参考文档](https://www.elastic.co/guide/en/elasticsearch/client/java-rest/6.8/java-rest-high.html)

## 添加pom文件

```xml
<!-- 添加elasticsearch启动器 -->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-data-elasticsearch</artifactId>
</dependency>
```

## 创建Client客户端

```java
//创建客户端请求
RestHighLevelClient client = new RestHighLevelClient(
  RestClient.builder(new HttpHost("localhost", 9200, "http")));
```

## 文档操作

### 添加文档

```java
//创建index请求
IndexRequest request = new IndexRequest("posts", "doc", "3");//指定对应的index，type和id

//添加数据
IndexRequest source = request.source("user", "aaa", "postDate", new Date(), "message", "hello");

//通过client创建index并添加一个文档
IndexResponse index = client.index(source, RequestOptions.DEFAULT);
```

### 批量添加文档

```java
//创建批量请求
BulkRequest request = new BulkRequest();

//添加数据
request.add(new IndexRequest("header", "doc", String.valueOf(Randomness.get().nextInt())).source(XContentType.JSON, "headerName", "1"));
request.add(new IndexRequest("header", "doc", String.valueOf(Randomness.get().nextInt())).source(XContentType.JSON, "headerName", "2"));

//通过client创建批量添加索引
BulkResponse bulkResponse = client.bulk(request, RequestOptions.DEFAULT);
```

### 查询文档（根据id查询）

```java
//创建get请求
GetRequest request = new GetRequest("posts", "doc", "1");

//通过client进行查询
GetResponse getResponse = client.get(request, RequestOptions.DEFAULT);
```

### 删除文档（根据id删除）

```java
//创建delete请求
DeleteRequest request = new DeleteRequest("posts", "doc", "1");

//通过client进行删除
DeleteResponse deleteResponse = client.delete(request, RequestOptions.DEFAULT);
```

### 更新文档（根据id更新）

```java
//创建update请求
UpdateRequest request = new UpdateRequest("posts", "doc", "2");

//在请求中添加要修改的内容
request.doc("updated", new Date(),"reason","i don't know");

//通过client进行更改
UpdateResponse update = client.update(request, RequestOptions.DEFAULT);
```

## 索引操作

### 删除索引

```java
//创建删除索引请求
DeleteIndexRequest request = new DeleteIndexRequest("header");
//同步删除索引
AcknowledgedResponse deleteIndexResponse = client.indices().delete(request, RequestOptions.DEFAULT);
```

### 查询是否存在索引

```java
//创建查询索引请求
GetIndexRequest request = new GetIndexRequest("header");
//查询是否存在索引
boolean exists = client.indices().exists(request, RequestOptions.DEFAULT);
```

## 复合查询（多条件查询）

```java
//构造查询条件
SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();

BoolQueryBuilder queryBuilder = QueryBuilders.boolQuery()
  .must(QueryBuilders.matchQuery("blogName", keyword).boost(2f)) //在blogName字段中必须匹配keyword关键字，权重为2
  .should(QueryBuilders.matchQuery("headerContent", keyword)) //在headerContent字段中应该匹配keyword关键字，默认权重为1
  .should(QueryBuilders.matchQuery("headerName", keyword).boost(1.5f)); //在headerName字段中应该匹配keyword关键字，默认权重为1.5 

//查询第0条到第20条记录
sourceBuilder.from(0);
sourceBuilder.size(20);

//指定查询的索引
SearchRequest searchRequest = new SearchRequest().indices("header").source(sourceBuilder);

//通过client进行查询
SearchResponse search = client.search(searchRequest, RequestOptions.DEFAULT);

//获取命中结果
System.out.println(search.getHits().getHits());
```

> 使用`QueryBuilders.moreLikeThisQuery()`来做内容推荐
>
> 使用`QueryBuilders.regexpQuery()`来构建正则匹配查询
>
> 使用`QueryBuilders.matchPhraseQuery()`来构建短语查询
>
> 使用`sourceBuilder.fetchSource()`来排除返回的source数据的一些字段

# 匹配得分规则

Elasticsearch是根据匹配得分按降序返回结果的

匹配得分是一个正浮点数，得分越高，则关键字和文档越匹配。

不同查询的匹配得分规则

- Query查询

  在使用Query查询时，查询语句除了决定匹配的文档是否返回，还会根据关键词的匹配程度来决定匹配得分，并通过`_score`字段返回

- Filter查询

  在使用Filter查询时，查询语句只是简单的筛选文档是否匹配，而不会计算关键字和文档的匹配得分

  > 因此，Filter查询多用于按照时间范围过滤出符合条件的文档

## Bool查询

Bool查询可以由Query查询和Filter查询共同组成

- must：指定关键字必须存在文档中（如果存在，则该文档会被过滤），并统计得分
- filter：过滤符合条件的文档，不统计得分
- should：指定关键字应该存在文档中（如果存在，不会过滤文档，当相应的得分会降低），并统计得分
- must_not：指定关键字必须比存在文档中（如果存在，则该文档会被过滤）。子句在filter上下文中执行表示将不计入匹配程度得分且子句结果将用于缓存。

Bool查询的最终得分会由must和should的查询得分累加得出。

## 复合查询

复合查询可以包裹复合查询或者子查询

包括以下查询：

- Bool查询
- Boosting查询（助推查询），返回匹配了正查询的文档，但减少负查询的文档得分
- constant_score查询（得分不变的查询），所有匹配的文档将得到同样不变的得分。
- dis_max查询，返回得分最高的一个文档
- function_score查询，使用函数修改主查询返回的分数

# REST API

## Cat API（***）

查询相关的API，[参考文档](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/cat.html)

### 查询所有索引信息

`curl -X GET "localhost:9200/_cat/indices?v&s=index&pretty"`

### 查询所有文档总数

`curl -X GET "localhost:9200/_cat/count/header?v&pretty"`

## Document API（***）

文档相关的API，[参考文档](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/docs.html)

## Index API（***）

索引相关的API，[参考文档](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/indices.html)

## Search API（***）

搜索相关的API，[参考文档](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/search.html)

# 参考文档

[官方文档](https://www.elastic.co/guide/en/elasticsearch/reference/current/elasticsearch-intro.html)

[Elasticsearch入门的整体概述](https://blog.csdn.net/achuo/article/details/87865141)

[ElasticSearch的索引原理分析](https://blog.csdn.net/qq_38262266/article/details/90311086)

[Elasticsearch的快速使用](https://www.cnblogs.com/cjsblog/p/9439331.html)





























