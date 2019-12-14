# 整体概述

> 注意事项：
>
> 确保参考的官方文档和你当前的使用版本是同一个版本，不然会报一些错误

介绍：将需要检索的内容保存在内存中，并通过合理的索引，快速的检索内容

## 数据输入：文档和索引

Elasticsearch是一个分布式文档存储，替换传统的关系型数据库，Elasticsearch可以存储复杂的数据结构例如序列化后的json数据。当部署了Elasticsearch集群时，文档将被存在多个节点中，并且当查询数据时可以很快的从多个节点中查询并汇总结果



当文档被存储时，Elacticsearch会自动的文档建立索引，并且能够在1s之内就可以查询到建立索引后的数据。



Elasticsearch使用了反向索引来提供快速的全文检索。反向索引记录了出现在任何文档中的唯一单词和标识每个单词出现在哪些文档中



一个索引可以被看作是多个文档的一个优化过的集合，每个文档是字段的集合，字段是包含数据的key-value的键值对。Elasticsearch默认在每个字段中索引所有数据，并且每个索引字段都有一个专用的、优化的数据结构。例如，文本字段将被存储在反向索引中，数字和地理字段将被存储在BKD树中。组装不同类型的索引并返回查询结果的能力才使得Elasticsearch这么快。



Elasticsearch可以对文档进行自动索引，而无需显式的指定如何处理文档中可能出现的每个不同的字段。当动态映射开启是，Elasticsearch会自动检查和添加新字段到索引中。这项默认的行为使得索引和查询数据更加的简单。只要开始索引文档，Elasticsearch就会检测和映射字段类型：如布尔值、浮点、整数、日期和字符串

> 官方建议最好是我们自己定义好索引规则

自定映射能够有以下好处：

- 区分文本字符串和数值字符串
- 执行特定语法的文本分析
- 为部分匹配优化字段
- 使用自定义日期格式
- 使用无法自动检测的数据类型

为不同的目的为相同的字段建立不同的索引通常是有用的。

## 信息输出：查询和分析

我们之所以能够使用Elasticsearch很方便的存储和检索文档时，这得益于Elasticsearch使用了Apache的Lucene查询引擎库



Elasticsearch提供了简单，清晰的REST API来管理集群、索引和查询数据

### 查询数据

Elasticsearch的REST API支持结构化查询、全文查询和复杂的查询。

- 结构化查询就像使用sql一样。举个例子，你可以查询`gender`字段和`age`字段在`emplyee`索引中，并且可以将匹配到的数据按照`hire_date`字段排序。
- 全文查询可以根据查询关键字查询全部文档，并按照匹配度排序返回结果

除了搜索单独的关键字，还可以进行短语搜索、相似度搜索和前缀搜索

Elasticsearch还为非文本数据如数字提供了优化的数据结构将其索引，提供高性能的检索



Elasticsearch提供了全面的json风格的查询语言（DSL）来搜索数据。或者使用SQL风格查询，以便在搜索和聚合数据

### 分析数据

Elasticsearch聚合能够让我们根据数据构建复杂的总结和深入了解关键的指标、模式和趋势。聚合后的数据能够回答以下问题：

- 总共有多少数据？
- 数据的平均长度是多少？
- 按制造商分类后的数据的长度中间值是多少？
- 在过去的6个月中，每个月总共有多少数据被添加？

聚合使用了搜索的数据结构，这是的我们使用聚合来分析数据时基本上是实时的。Elasticsearch允许我们可以在一个请求中同时进行搜索文档、过滤结果和进行聚合分析。

## 可伸缩性和弹性：集群、节点和碎片

Elasticsearch自动的分发数据到每个节点，并且可以从每个节点搜索数据并汇总结果返回，Elasticsearch知道如何平衡多节点集群以提供可伸缩性和高可用性



它是如何工作的？Elasticsearch只是合理的组织一个或多个物理碎片，每个碎片实际上是一个独立的索引。将文档分布在多个碎片中，多个碎片分布在多个节点中，Elasticsearch可以确保没有冗余，并且可以防止硬件损坏和增加查询能力当节点添加到集群后。当集群增大或缩小，Elasticsearch可以自动的移动节点来重新调整集群。



这里有两种类型的碎片：主碎片和碎片副本。索引中的每个文档都属于主碎片。一个碎片副本是从主碎片拷贝的。碎片副本是为了预防硬件损坏导致数据丢失和增加服务器读请求（如搜索或检索文档）的能力



索引中的主碎片数量在索引被创建的时候是固定的，但是碎片副本的数量可以在任何时候被改变，并且不会中断索引或查询操作

### 视情况而定

有一些性能考虑和权衡：考虑碎片大小，为索引配置的主碎片的数量。碎片个数越多，维护索引的开销越大。碎片体积越大，Elasticsearch移动碎片来重新调整集群所消耗的时间越久



查询大量小碎片，每个小碎片相对于大碎片来说处理速度更快， 但是更多查询意味着更多开销，所以查询总量相同的情况下，少量的查询大碎片相比于更多的查询小碎片的开销更小，当然，这只是相对来说

### 如果发生灾难

高可用架构避免了把鸡蛋都放在同一个篮子里。当主集群出现问题而停止提供服务，那么另外一个备用集群会替代主集群被提供服务，即Cross-cluster replication (CCR)



CCR提供一种方式来自动的将主集群中的索引同步到其他集群中，以供来提供服务以处理更多的请求（热备份）。如果主集群宕机了，那么其他集群将取而代之。其他集群中的索引是只读的，索引只能从主集群中同步过来。

### 维护和保养

在企业级系统中，需要工具去保护、管理、监控Elasticsearch集群，官方推荐使用[Kibana](https://www.elastic.co/guide/en/kibana/7.4/introduction.html)来进行管理集群

# 入门

学会如何使用REST API进行存储，查询和分析数据

## 安装及运行

### 在mac上

#### 安装

```shell
brew install elasticsearch
```

#### 运行

```shell
elasticsearch
```

#### 关闭

如果是在前台运行的话，直接Ctrl+C即可退出

#### 数据、日志和配置文件的存储路径

- Data：`/usr/local/var/lib/elasticsearch/`
- Logs：`/usr/local/var/log/elasticsearch/elasticsearch_yingjie.lu.log`
- Plugins：`/usr/local/var/elasticsearch/plugins/`
- Config：`/usr/local/etc/elasticsearch/`

#### 默认的端口路径

http://127.0.0.1:9200/

#### 查看Elasticsearch健康的API

http://127.0.0.1:9200/_cat/health?v

### 多实例运行

```shell
elasticsearch -Epath.data=data2 -Epath.logs=log2
elasticsearch -Epath.data=data3 -Epath.logs=log3
```

> 为每个elasticsearch指定数据和日志的路径即可

## Elasticsearch的结构与传统数据库结构对比

| Elasticsearch | 传统数据库 |
| :-----------: | :--------: |
|    indices    |   数据库   |
|     type      |   数据库   |
|   document    |     行     |
|     field     |     列     |

## 索引文档

所有的操作都可以通过JSON格式的请求完成



### 添加文档

发送一个简单的put请求

数据格式如下：

```json
PUT /customer/_doc/1
{
  "name": "John Doe"
}
```

终端发送请求的命令如下：

```http
curl -X PUT "localhost:9200/customer/_doc/1?pretty" -H 'Content-Type: application/json' -d '
{
  "name": "John Doe"
}
'
```

> 该请求会自动创建`customer`索引如果不存在的话，添加一个id为1的新文档，并且存储和索引name字段

返回的结果：

```json
{
  "_index" : "customer",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "result" : "created",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 0,
  "_primary_term" : 1
}
```

> `"_version":1` 代表文档是被创建



### 查询文档

发送一个get请求查询文档

```shell
curl -X GET "localhost:9200/customer/_doc/1?pretty"
```

> 加上`?pretty`参数可以返回一个已经格式化好的json数据

返回的json数据如下：

```json
{
  "_index" : "customer",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "_seq_no" : 0,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "name" : "John Doe"
  }
}
```

查询所有文档：

```shell
curl -X GET "localhost:9200/posts/_search?pretty" -H 'Content-Type: application/json' -d '
{
  "query": { "match_all": {} }
}
'
```

### 批量添加文档

批量添加要比一个一个添加的速度要快

批量添加的数量取决于一些因素：

- 文档大小和复杂程度
- 索引和搜索的负载情况
- Elasticsearch集群的可用资源

批量添加的文档数量最好控制在1000-5000，总大小控制在5M-15M。在这两个区间范围内，可以比较好的找到适合你的参数

具体的批量添加API接口参考：[bulk API](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/docs-bulk.html)

1. 下载[accounts.json](https://github.com/elastic/elasticsearch/blob/master/docs/src/test/resources/accounts.json?raw=true) ，该json文件存放了大量随机生成的用户数据，基本的字段如下：

   ```json
   {
       "account_number": 0,
       "balance": 16623,
       "firstname": "Bradshaw",
       "lastname": "Mckenzie",
       "age": 29,
       "gender": "F",
       "address": "244 Columbus Place",
       "employer": "Euron",
       "email": "bradshawmckenzie@euron.com",
       "city": "Hobucken",
       "state": "CO"
   }
   ```

2. 发送批量添加请求添加文档数据

   进入到accounts.json文件保存的路径：如`cd ~/Desktop`

   发送批量添加请求：

   ```shell
   curl -H "Content-Type: application/json" -XPOST "localhost:9200/bank/_doc/_bulk?pretty&refresh" --data-binary "@accounts.json"
   ```

   返回的部分结果如下：

   ```json
   {
     "index" : {
       "_index" : "bank",
       "_type" : "_doc",
       "_id" : "995",
       "_version" : 1,
       "result" : "created",
       "forced_refresh" : true,
       "_shards" : {
         "total" : 2,
         "successful" : 1,
         "failed" : 0
       },
       "_seq_no" : 196,
       "_primary_term" : 1,
       "status" : 201
     }
   }
   ```

   查看Elasticsearch的索引情况：

   ```shell
   curl "localhost:9200/_cat/indices?v"
   ```

   结果如下：

   ```shell
   health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
   yellow open   bank     BEXyh3LYSte9IuRZBwBHcg   5   1       1000            0    482.6kb        482.6kb
   ```

## 开始查询

一旦将一些数据放入到Elasticsearch索引中，就可以向`_search`端点发送请求来进行搜索。



### 查询所有

简单的查询bank索引，并按照账户number排序：

```shell
curl -X GET "localhost:9200/bank/_search?pretty" -H 'Content-Type: application/json' -d '
{
  "query": { "match_all": {} },
  "sort": [
    { "account_number": "asc" }
  ]
}
'
```

返回结果：

```json
{
  "took" : 186,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 1000,
    "max_score" : null,
    "hits" : [
      {
        "_index" : "bank",
        "_type" : "_doc",
        "_id" : "0",
        "sort" : [0],
        "_score" : null,
        "_source" : {"account_number" : 0,"balance" : 16623,"firstname" : "Bradshaw","lastname" : "Mckenzie","age" : 29,"gender" : "F","address" : "244 Columbus Place","employer" : "Euron","email" : "bradshawmckenzie@euron.com","city" : "Hobucken","state" : "CO"
        }
      },
      ...
    ]
  }
}
```

返回结果提供了以下信息：

- took：该查询请求花费了多长时间
- time_out：标识查询请求是否超时
- _shards：显示此次查询请求，查询了多少个碎片和多少个碎片故障（多少个成功、失败或者跳过）
- hits
  - total：总共搜索了多少篇文档
  - max_score：显示最匹配的文档的匹配度
  - hits（具体的搜索结果）
    - _index：索引名称
    - _type：内容的类型
    - _id：id
    - sort：该条结果的在所有返回结果中的文档排序位置
    - _score：文档的匹配程度(在使用match_all时显示为null)
    - _source：显示文档的原数据

### 分页查询

添加`from`和`size`参数即可进行分页查询

```shell
curl -X GET "localhost:9200/bank/_search?pretty" -H 'Content-Type: application/json' -d '
{
  "query": { "match_all": {} },
  "sort": [
    { "account_number": "asc" }
  ],
  "from": 10,
  "size": 10
}
'
```

### 特定参数查询

使用`match`查询查询指定字段

```shell
curl -X GET "localhost:9200/bank/_search?pretty" -H 'Content-Type: application/json' -d
'
{
  "query": { 
    "match": { 
    	"address": "mill lane" 
    } 
  }
}
'
```

> 查询`address`字段包含`mill`或`lane`的文档



使用`match_phrase`查询精准字段

```shell
curl -X GET "localhost:9200/bank/_search?pretty" -H 'Content-Type: application/json' -d '
{
  "query": { 
    "match_phrase": { 
    	"address": "mill lane" 
    } 
  }
}
'
```

> 查询`address`字段包含`mill lane`的文档



构建更复杂的查询

使用`bool`查询来构建多条件查询。你可以指定必须配置哪些字段（must match），应该匹配哪些字段（should match）或者必须不匹配哪些字段（must not match）

例如：

查询bank的accounts索引中，age必须为40，state不为ID的文档

```shell
curl -X GET "localhost:9200/bank/_search?pretty" -H 'Content-Type: application/json' -d '
{
  "query": {
    "bool": {
      "must": [
        { "match": { "age": "40" } }
      ],
      "must_not": [
        { "match": { "state": "ID" } }
      ]
    }
  }
}
'
```

`must`，`should`和`must_not`会影响文档的匹配程度，最终的结果会按照匹配程度的高低从上往下排序



`must_not`子句可以被看作是一个过滤器，他不但影响匹配的文档是否出现在结果中，而且会影响结果文档的匹配层度。所以，我们可以使用`filter`来替代`must_not`来排除不符合条件的数据

例如：

使用`filter`查询账户余额在20000-30000区间的用户

```shell
curl -X GET "localhost:9200/bank/_search?pretty" -H 'Content-Type: application/json' -d '
{
  "query": {
    "bool": {
      "must": { "match_all": {} },
      "filter": {
        "range": {
          "balance": {
            "gte": 20000,
            "lte": 30000
          }
        }
      }
    }
  }
}
'
```

## 分析并聚合结果

### 简单聚合

例如：

对bank索引中的数据按照state字段进行聚合，并按属于state字段的文档数量降序返回结果

```shell
curl -X GET "localhost:9200/bank/_search?pretty" -H 'Content-Type: application/json' -d '
{
  "size": 0,
  "aggs": {
    "group_by_state": {
      "terms": {
        "field": "state.keyword"
      }
    }
  }
}
'
```

> 使用`aggs`进行聚合操作，使用`group_by_字段`来聚合指定字段

结果如下：

```shell
{
  "took": 29,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "skipped" : 0,
    "failed": 0
  },
  "hits" : {
     "total" : 1000,
    "max_score" : 0.0,
    "hits" : [ ]
  },
  "aggregations" : {
    "group_by_state" : {
      "doc_count_error_upper_bound": 20,
      "sum_other_doc_count": 770,
      "buckets" : [ {
        "key" : "ID",
        "doc_count" : 27
      }, {
        "key" : "TX",
        "doc_count" : 27
      }, {
        "key" : "AL",
        "doc_count" : 25
      }, {
        "key" : "MD",
        "doc_count" : 25
      }, {
        "key" : "TN",
        "doc_count" : 23
      }, {
        "key" : "MA",
        "doc_count" : 21
      }, {
        "key" : "NC",
        "doc_count" : 21
      }, {
        "key" : "ND",
        "doc_count" : 21
      }, {
        "key" : "ME",
        "doc_count" : 20
      }, {
        "key" : "MO",
        "doc_count" : 20
      } ]
    }
  }
}
```

返回聚合结果（aggregations）：

aggregations.group_by_state

- buckets
  - key：state字段的值
  - doc_count：对应state下的文章数量

> 因为在请求之前设置了`size=0`，所以返回结果中`hits.hits`中就没有值，为空

### 复杂聚合（嵌套聚合）

例如：

在先前的`group_by_state`聚合中嵌套`avg`聚合，以计算每个状态的平均账户余额

```shell
curl -X GET "localhost:9200/bank/_search?pretty" -H 'Content-Type: application/json' -d '
{
  "size": 0,
  "aggs": {
    "group_by_state": {
      "terms": {
        "field": "state.keyword"
      },
      "aggs": {
        "average_balance": {
          "avg": {
            "field": "balance"
          }
        }
      }
    }
  }
}
'
```

> 使用`aggs`嵌套`aggs`即可
>
> 计算平均值使用`average_字段`来指定字段即可



使用嵌套聚合的结果进行排序：

例如：

将上述的`balance`字段的平均值的聚合结果放入`state`字段的聚合结果中并以平局值排序

```shell
curl -X GET "localhost:9200/bank/_search?pretty" -H 'Content-Type: application/json' -d '
{
  "size": 0,
  "aggs": {
    "group_by_state": {
      "terms": {
        "field": "state.keyword",
        "order": {
          "average_balance": "desc"
        }
      },
      "aggs": {
        "average_balance": {
          "avg": {
            "field": "balance"
          }
        }
      }
    }
  }
}
'
```

## url使用记录

### 查询指定index信息

```shell
curl -X GET "localhost:9200/blog?pretty"
```







## 使用Java REST Client操作数据（***）

[官方文档](https://www.elastic.co/guide/en/elasticsearch/client/java-rest/6.8/java-rest-high.html)

[其他博客](https://my.oschina.net/u/3795437/blog/2253366)

[其他博客](https://zyc88.blog.csdn.net/article/details/87099469)

### Document API

[Index API](https://www.elastic.co/guide/en/elasticsearch/client/java-rest/6.8/java-rest-high-document-index.html)

[Get API](https://www.elastic.co/guide/en/elasticsearch/client/java-rest/6.8/java-rest-high-document-get.html)

[Delete API](https://www.elastic.co/guide/en/elasticsearch/client/java-rest/6.8/java-rest-high-document-delete.html)

[Update API](https://www.elastic.co/guide/en/elasticsearch/client/java-rest/6.8/java-rest-high-document-update.html)

### Search API

[Search API](https://www.elastic.co/guide/en/elasticsearch/client/java-rest/6.8/java-rest-high-search.html)

[Search Scroll API](https://www.elastic.co/guide/en/elasticsearch/client/java-rest/6.8/java-rest-high-search-scroll.html)：分页查询

[Multi-Search API](https://www.elastic.co/guide/en/elasticsearch/client/java-rest/6.8/java-rest-high-multi-search.html)：多重查询

### Indices API

[Create Index API](https://www.elastic.co/guide/en/elasticsearch/client/java-rest/6.8/java-rest-high-create-index.html)

[Delete Index API](https://www.elastic.co/guide/en/elasticsearch/client/java-rest/6.8/java-rest-high-delete-index.html)

[Get Index API](https://www.elastic.co/guide/en/elasticsearch/client/java-rest/6.8/java-rest-high-get-index.html)

### Using Java Builders

参考文档来获取如何创建不同操作请求的Java对象

[Building Queries](https://www.elastic.co/guide/en/elasticsearch/client/java-rest/6.8/java-rest-high-query-builders.html)：创建查询对象

[Building Aggregations](https://www.elastic.co/guide/en/elasticsearch/client/java-rest/6.8/java-rest-high-aggregation-builders.html)：创建聚合对象

### 示例

#### 添加文档并创建索引

 ```java
//创建客户端请求
RestHighLevelClient client = new RestHighLevelClient(
  RestClient.builder(new HttpHost("localhost", 9200, "http")));

//创建index请求
IndexRequest request = new IndexRequest("posts", "doc", "3");//指定对应的index，type和id

//添加数据方式一
//        String jsonString = "{" +
//                "\"user\":\"kimchy\"," +
//                "\"postDate\":\"2013-01-30\"," +
//                "\"message\":\"trying out Elasticsearch\"" +
//                "}";
//        IndexRequest source = request.source(jsonString, XContentType.JSON);
//添加数据方式二
IndexRequest source = request.source("user", "aaa", "postDate", new Date(), "message", "hello");

//通过client创建index并添加一个文档
IndexResponse index = client.index(source, RequestOptions.DEFAULT);
System.out.println(index);

//关闭连接
client.close();
 ```

#### 批量添加文档

```java
//创建客户端请求
RestHighLevelClient client = new RestHighLevelClient(
RestClient.builder(new HttpHost("localhost", 9200, "http")));

//创建index请求
BulkRequest request = new BulkRequest();
//添加数据
request.add(new IndexRequest("posts", "doc", String.valueOf(Randomness.get().nextInt()))
.source(XContentType.JSON,"field", "foo"));
request.add(new IndexRequest("posts", "doc", String.valueOf(Randomness.get().nextInt()))
.source(XContentType.JSON,"field", "bar"));
request.add(new IndexRequest("posts", "doc", String.valueOf(Randomness.get().nextInt()))
.source(XContentType.JSON,"field", "baz"));

//通过client创建批量添加索引
BulkResponse bulkResponse = client.bulk(request, RequestOptions.DEFAULT);
System.out.println(bulkResponse);

//关闭连接
client.close();
```

#### 通过id查询文档

```java
//创建客户端请求
RestHighLevelClient client = new RestHighLevelClient(
  RestClient.builder(new HttpHost("localhost", 9200, "http")));

//创建get请求
GetRequest request = new GetRequest("posts", "doc", "1");

//通过client进行查询
GetResponse getResponse = client.get(request, RequestOptions.DEFAULT);
System.out.println(getResponse);

//关闭连接
client.close();
```

#### 删除对应文档

```java
//创建客户端请求
RestHighLevelClient client = new RestHighLevelClient(
  RestClient.builder(new HttpHost("localhost", 9200, "http")));

//创建delete请求
DeleteRequest request = new DeleteRequest("posts", "doc", "1");

//通过client进行删除
DeleteResponse deleteResponse = client.delete(request, RequestOptions.DEFAULT);
System.out.println(deleteResponse);

//关闭连接
client.close();
```

#### 更新文档

```java
//创建客户端请求
RestHighLevelClient client = new RestHighLevelClient(
  RestClient.builder(new HttpHost("localhost", 9200, "http")));

//创建update请求
UpdateRequest request = new UpdateRequest("posts", "doc", "2");

//在请求中添加要修改的内容
request.doc("updated", new Date(),"reason","i don't know");

//通过client进行更改
UpdateResponse update = client.update(request, RequestOptions.DEFAULT);
System.out.println(update);

//关闭连接
client.close();
```

#### 多条件查询(正则匹配查询)

```java
//创建客户端请求
RestHighLevelClient client = new RestHighLevelClient(
  RestClient.builder(new HttpHost("localhost", 9200, "http")));

//构造查询条件
SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();
sourceBuilder.query(QueryBuilders.regexpQuery("user",".*lu.*"));//使用正则匹配查询
sourceBuilder.from(0);
sourceBuilder.size(5);

//指定查询文档
SearchRequest searchRequest = new SearchRequest().indices("posts").source(sourceBuilder);

//通过client进行查询
SearchResponse search = client.search(searchRequest, RequestOptions.DEFAULT);
System.out.println(search);

//关闭连接
client.close();
```



# 设置Elasticsearch

## 配置Elasticsearch

Elasticsearch设置了比较合适的默认配置和必要的配置，所以我们基本上无需太多的配置即可使用

而且绝大多数配置可以通过[*Cluster Update Settings*](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/cluster-update-settings.html) API来进行配置

配置文件应该包含节点的配置（比如node.name和paths），或者节点能够加入集群所需要的配置（比如cluster.name和cluster.host）



### 配置文件的路径

Elasticsearch共有三个配置文件：

- `elasticsearch.yml`是Elasticsearch的配置文件
- `jvm.options`是JVM的配置文件
- `log4j2.properties`是日志配置文件

如果通过brew安装的Elasticsearch的话，配置文件位于该`/usr/local/etc/elasticsearch`目录下

```shell
$ ls /usr/local/etc/elasticsearch/
elasticsearch.keystore	
jvm.options
elasticsearch.yml	
log4j2.properties
```



对于分布式的配置文件，参考[文档](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/settings.html#config-files-location)

### 配置文件格式

支持yaml和properties两种格式

例如：

YAML格式

```yaml
path:
    data: /var/lib/elasticsearch
    logs: /var/log/elasticsearch
```

properties格式

```properties
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
```



### 环境变量替换

在配置文件中使用`${...}`的方式可以使用环境变量

例如：

```properties
node.name:    ${HOSTNAME}
network.host: ${ES_NETWORK_HOST}
```

### 设置节点提示

```yaml
node:
  name: ${prompt.text}
```



## 设置JVM参数

设置堆大小，参考[文档](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/jvm-options.html)

## 安全设置

有些设置是敏感的，单纯的通过文件系统的限制是不够的，因此Elasticsearch提供keystore和elasticsearch-keystore工具去管理这些设置

具体参考[文档](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/secure-settings.html)

## 日志配置

Elasticsearch使用Log4j 2来记录日志。

具体配置参考[文档](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/logging.html)

## 导入Elasticsearch配置

参考[文档](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/important-settings.html)

## 导入系统配置

Elasticsearch可以单独的运行在服务器上并且拥有使用服务器上所有资源的能力。因为我们有时只想让这台服务器就只为Elasticsearch服务，因此，我们需要配置文件来让操作系统分配更多的资源给Elasticsearch

参考[文档](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/system-config.html)

## 引导检查

引导检查检查各种Elasticsearch的配置和系统设置，并将它们与对Elasticsearch操作安全的值进行比较。如果Elasticsearch处于开发模式，任何失败的引导检查都将作为警告出现在Elasticsearch日志中。如果Elasticsearch处于生产模式，任何失败的引导检查都会导致Elasticsearch拒绝启动。

[参考文档](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/bootstrap-checks.html)

## 添加节点到集群

当启动一个Elasticsearch实例，就相当于启动了一个节点。一个Elasticsearch集群是一个具有相同集群名称（`cluster.name`）Elasticsearch节点的集合。当节点加入或从集群中删除，集群会自动的调整剩余节点用来能够让消息分发到每个节点



如果只运行单个Elasticsearch实例，那么我们就拥有一个节点节点的集群。所有主碎片位于一个单一的节点中。没有备份碎片可以被分配，因此这个集群的状态会显示yellow（黄色预警），表示着数据是不安全的，一旦发生故障就会有数据丢失的风险。集群的结构图如下：

![elas_0202](/Users/yingjie.lu/Documents/note/.img/elas_0202.png)



添加多个节点可以增加集群的容量和可靠性。默认情况下，一个节点又是数据节点，又有资格被选举为控制集群的主节点。

当添加了多个节点后，集群会将注节点中的碎片自动的备份到其他节点。当所有主碎片和备份碎片都被激活，那么集群的状态就会由yellow转为green。集群的结构图如下：

![elas_0204](/Users/yingjie.lu/Documents/note/.img/elas_0204.png)



添加节点到集群的步骤：

1. 设置一个新的Elasticsearch实例

2. 指定集群的名字在它的`cluster.name`属性中

   例如：

   添加一个节点到名字为`logging-prod` 的集群，则需要在`elasticsearch.yml`配置文件中设置以下内容

   ```properties
   cluster.name: "logging-prod"
   ```

3. 启动Elasticsearch。启动的节点将会自动发现和加入指定的集群



更多的发现和碎片分配可以参考文档[Discovery](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/modules-discovery.html) and [Cluster](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/modules-cluster.html)

# 更新Elasticsearch数据

Elasticsearch经常使用滚动更新进程来更新数据，所以在更新数据的时候并不会中断服务。然而，我们需要重建索引在更新数据之后。

更多参考[文档](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/setup-upgrade.html#setup-upgrade)

## 滚动更新

## 所有集群重启更新

## 重建索引前更新

# 聚合

[文档](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/search-aggregations.html)

# Query DSL

[文档](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/query-dsl.html)

共有两类查询子句：

- 叶查询子句

  叶查询子句寻找特定的值在特定的字段中，例如使用`match`，`term`或`range`查询。这些查询可以被他们自生使用。

- 复合查询子句

  复合查询包裹了叶查询或者复合查询，一般用来封装多重查询的逻辑（例如`bool`或者`dis_max`查询），或者用于改变他们的行为（例如`constant_score`查询）

## 查询和过滤上下文

### 匹配程度得分

Elasticsearch根据查询结果的匹配程度得分进行排序



匹配程度得分是一个正浮点数，它在调用[search](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/search-request-body.html) API会在结果中返回。匹配程度越高，说明查询关键字和文档越匹配。虽然每个查询类型都可以以不同的方式计算匹配程度，但分数计算也取决于该查询请求使用的是查询上下文还是过滤上下文（过滤是不计入匹配程度的）

### Query context

在查询上下文中，查询子句除了决定文档是否匹配之外，还会计算匹配的文件的匹配程度，并将其在`_score`字段中返回



查询上下文在查询子句传入一个查询参数的时候生效，查询参数可以参考[search](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/search-request-body.html) API

### Filter context

在过滤上下文中，只是简单的筛选文档是否匹配，而不会去计算匹配程度。过滤上下文适用于过滤结构化的日期等，例如：

- 过滤出时间范围在2015-2016区间的文档
- state字段的值为“published”的文档

经常使用的过滤器将会自动的被Elasticsearch缓存，用来加快查询



过滤上下文在查询子句传入`filter`参数时生效，例如[bool](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/query-dsl-bool-query.html)查询中的`filter`或`must_not`参数，`constant_score`查询中`fitler`参数，或者[filter](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/search-aggregations-bucket-filter-aggregation.html)聚合

### 示例

该查询将匹配以下条件：

- `title`字段包含search关键字
- `content`字段包含elasticsearch关键字
- `status`字段包含确定的published单词
- `publish_date`字段的时间大于2015-01-01

查询语句如下：

```shell
curl -X GET "localhost:9200/_search?pretty" -H 'Content-Type: application/json' -d '
{
  "query": { 
    "bool": { 
      "must": [
        { "match": { "title":   "Search"        }},
        { "match": { "content": "Elasticsearch" }}
      ],
      "filter": [ 
        { "term":  { "status": "published" }},
        { "range": { "publish_date": { "gte": "2015-01-01" }}}
      ]
    }
  }
}
'
```

> `"query"`参数表明了是查询上下文
>
> `bool`和两个`match`子句被用在了查询上下文中，表示他们会被统计到文档的匹配程度得分中
>
> `fitler`参数表明了过滤上下文。`trem`和`range`子句被用在了过滤上下文中。他们会过滤掉不匹配的文档，并且不会讲过滤的参数统计到文档的匹配程度得分中。

## 复合查询

复合查询可以包裹复合查询或者叶查询，要么将他们的结果和分数结合起来，要么改变他们的行为，要么从查询上下文切换到过滤上下文



包括以下查询：

- bool_query

  默认查询，组合多个叶查询或复合查询子句，例如`must`，`should`，`must_not`或`filter`子句。`must`和`should`子句的匹配得分会结合（匹配的越多，分数越高），而`must_not`和`filter`子句只会在filter上下文中执行

- boosting query（主推查询）

  返回匹配了正查询的文档，但是减少负查询的文档得分

- constant_score query（得分不变的查询）

  一个查询包括另一个查询，但是在fitler上下文中执行它。所有匹配的文档将得到同样不变的得分。

- dis_max query

  一个查询接受多个查询，并且返回任何一个查询子句匹配的所有文档。当`bool`查询返回所有匹配的文档的得分，而`dis_max`查询将返回得分最高的一个文档

- function_score query

  使用函数修改主查询返回的分数

### Bool query

事件类型：

- must

  指定必须出现在文档中的关键字，并计入匹配程度得分

- filter

  指定必须出现在文档中的关键字，但是不计入匹配程度得分

- should

  指定应该出现在文档中的关键字，并计入匹配程度得分

- must_not

  指定必须不存在文档中的关键字。子句在filter上下文中执行表示将不计入匹配程度得分且子句结果将用于缓存。



`bool`查询采用越多匹配得分越高的方式，所以得分会从`must`和`should`子句中累加得出。



## 全文本查询











# 跨集群查询

# 类型映射

# 分析

# Modules

具体参考[文档](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/modules.html)

## 集群 模块

设置集群如何控制在哪里、什么时候和怎样将碎片派发到多节点

## 节点发现 模块

节点如何发现彼此以形成集群

## 网关 模块

在恢复并启动之前，控制多少节点可以加入集群

## HTTP 模块

设置HTTP REST API

## 索引 模块

全局索引相关配置

## 网络 模块

设置默认网络设置

## 节点客户端 模块



## 插件 模块

使用插件扩展Elasticsearch

## 快照和恢复 模块

## 线程池 模块

## 数据传输 模块

配置传输网络层，在Elasticsearch内部用于节点之间的通信。

## 远程集群 模块

远程集群用于通过在传输层上跨集群连接而工作的功能。

## 跨集群搜索 模块

跨集群搜索支持跨多个集群执行搜索请求，而无需将它们连接起来，并充当跨集群的联合客户机。

# 索引模块

配置与索引相关的设置

[文档](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/index-modules.html)

# 管理索引的生命周期

我们可以通过碎片的大小和性能需求来控制索引的生命周期，而不是简单的通过时间来控制。



你可以将生命周期策略附加到索引模版来控制如何处理老化的索引。你可以更新策略来修改新索引和现有索引的生命周期。



对于时间序列索引，有以下四个阶段：

1. Hot：索引正在积极的被更新和查询
2. Warm：索引长时间没有被更新，但是任然在被查询
3. Cold：索引长时间没有被更新，并且很少被查询
4. Delete：索引长时间没有被使用并且可以被安全的删除



生命周期策略可以设置，即可以规定当时是什么状态时可以被认定为生命周期的哪种状态



[文档](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/index-lifecycle-management.html)



# 监控集群（X-Pack）

[文档](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/monitor-elasticsearch-cluster.html)



# REST APIs

Elasticsearch暴露的REST API可以直接配置和访问Elasticsearch的功能



具体详细参考[7.5版本的文档](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/rest-apis.html)

## API约定

Elasticsearch的REST API是通过json格式的HTTP请求暴露的。

本章列出的约定可以应用于整个REST API，除非另有指定

### 多重索引

大多数引用索引参数的api都支持跨多个索引执行，使用简单的`test1,test2,test3`符号（或者用`_all`来表示所有索引）。它也支持通配符，如`test*`或`tes*t`，并且可以使用`-`来排除一些选项，如`test*,-test3`（通配符匹配test*的索引，但是排除了test3的索引）



所有的多重索引API支持以下String类型的url查询参数：

- `ignore_unavailable`

  控制是否忽略指定的不可用的索引，不可用包括不存在和已关闭的索引，可以指定true或false

- `allow_no_indices`

  控制是否失败如果通配符表达式没有对应的索引。可以指定true或false。如果为false，当没有找到索引时，则该请求失败

- `expand_wildcards`

  控制通配符索引可以扩展成哪种类型。如果值为`open`，则通配符表达式将扩展为仅还在使用的索引。如果值为`closed`，则通配符表示式将扩展为仅已经关闭的索引。如果值为`open,closed`，则通配符表达式将扩展为所有索引（开启和关闭的所有索引）。如果值为`null`，则关闭通配符表达式。如果值为`all`，则和值为`open,closed`是等价的

上述参数的默认值取决于所使用的API



> 单个索引的API不支持多种索引

### 在索引名中提供日期数学支持

## cat API（***）

[cat count](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/cat-count.html)：查询所有文档总数

[cat indices](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/cat-indices.html)：查询所有index信息

```shell
curl -X GET "localhost:9200/_cat/indices?v&s=index&pretty"
```



## 集群API

## 跨集群复制API

## Document API（***）

[Index](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/docs-index_.html)：创建index，并添加一个文档

[Get](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/docs-get.html)：获取文档

[Delete](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/docs-delete.html)：删除文档

[Update](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/docs-update.html)：更新文档

[Multi get](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/docs-multi-get.html)（批量查询）

[Bulk](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/docs-bulk.html)（批量添加）

[Reindex](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/docs-reindex.html)：重新索引

[`?refresh`](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/docs-refresh.html)：刷新

## Index API（***）

[Create index](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/indices-create-index.html)：创建索引

[Delete index](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/indices-delete-index.html)：删除索引

[Get index](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/indices-get-index.html)：获取索引

## Index lifecycle management API

## Info API

## 迁移API

## 重新加载查询分析 API

## 汇总API

## [Search API（***）](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/search.html)

请求格式：

1. `GET /<index>/_search`

   在指定的索引中查询

   示例：

   - 在终端中查询(精确查询age=36的文档)

     ```shell
     curl -X GET "localhost:9200/posts/_search?pretty&q=age:36"
     ```

   - 使用url查询

     http://localhost:9200/posts/_search?pretty&q=age:36

2. `GET /_search`

   在所有索引中查询（即查询搜索数据）

   示例：

   - 在终端中查询（精确查询age=36的文档）

     ```shell
     curl -X GET "localhost:9200/_search?pretty&q=age:36"
     ```

   - 使用url查询

     http://localhost:9200/_search?pretty&q=age:36

## Security API

## 快照生命周期管理API

## Watcher API









# 常用命令

查看所有index

```shell
curl -X GET "localhost:9200/_cat/indices?v&s=index&pretty"
```

删除index

```shell
curl -X DELETE "localhost:9200/header?pretty"
```

参看对应的index信息

```shell
curl -X GET "localhost:9200/header?pretty"
```





# 参考文档

[官方文档](https://www.elastic.co/guide/en/elasticsearch/reference/current/elasticsearch-intro.html)

[Elasticsearch入门的整体概述](https://blog.csdn.net/achuo/article/details/87865141)

[ElasticSearch的索引原理分析](https://blog.csdn.net/qq_38262266/article/details/90311086)

[Elasticsearch的快速使用](https://www.cnblogs.com/cjsblog/p/9439331.html)

