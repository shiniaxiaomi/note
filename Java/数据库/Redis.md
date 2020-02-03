# redis笔记

## 安装相关

### mac安装

安装redis

`brew install redis`

启动redis

`redis-server /usr/local/etc/redis.conf`

登入客户端

`redis-cli`

### Ubuntu安装

安装

`sudo apt-get install redis-server`

> 安装成功后,redis会自动启动
>
> 对应的配置文件为`/etc/redis/redis.conf`

重启redis

`sudo /etc/init.d/redis-server restart` or
`sudo service redis-server restart` or
`sudo redis-server /etc/redis/redis.conf`

启动客户端

`redis-cli`

## 简单的使用

- 存一个key

  `set a`

- 取一个key

  `get a`

- 删除一个key

  `del a`

- 获取所有key

  `keys *`

## 五种数据类型

- 字符串string
- 哈希hash
- 列表list
- 集合set
- 有序集合zset

数据操作的全部命令，可以查看[中文网站](http://redis.cn/commands.html)

---

各个数据类型应用场景：

| 类型                 | 简介                                                   | 特性                                                         | 场景                                                         |
| -------------------- | ------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| String(字符串)       | 二进制安全                                             | 可以包含任何数据,比如jpg图片或者序列化的对象,一个键最大能存储512M | —                                                            |
| Hash(字典)           | 键值对集合,即编程语言中的Map类型                       | 适合存储对象,并且可以像数据库中update一个属性一样只修改某一项属性值(Memcached中需要取出整个字符串反序列化成对象修改完再序列化存回去) | 存储、读取、修改用户属性                                     |
| List(列表)           | 链表(双向链表)                                         | 增删快,提供了操作某一段元素的API                             | 1,最新消息排行等功能(比如朋友圈的时间线) 2,消息队列          |
| Set(集合)            | 哈希表实现,元素不重复                                  | 1、添加、删除,查找的复杂度都是O(1) 2、为集合提供了求交集、并集、差集等操作 | 1、共同好友 2、利用唯一性,统计访问网站的所有独立ip 3、好友推荐时,根据tag求交集,大于某个阈值就可以推荐 |
| Sorted Set(有序集合) | 将Set中的元素增加一个权重参数score,元素按score有序排列 | 数据插入集合时,已经进行天然排序                              | 1、排行榜 2、带权重的消息队列                                |

## SpringBoot整合Redis

### 引入maven依赖

```xml
<!--redis-starter-->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

### 配置redis的序列化器

1. 如果使用redisTemplate

   ```java
   //配置自己的redisTemplate(设置好序列化器)
   @Bean(name = "redisTemplate")
   public RedisTemplate<String,Object> redisTemplate(RedisConnectionFactory redisConnectionFactory){
   
     RedisTemplate<String,Object> redisTemplate = new RedisTemplate<>();
   
     GenericJackson2JsonRedisSerializer genericJackson2JsonRedisSerializer = new GenericJackson2JsonRedisSerializer();
   
     redisTemplate.setConnectionFactory(redisConnectionFactory);
     redisTemplate.setKeySerializer(genericJackson2JsonRedisSerializer);
     redisTemplate.setValueSerializer(genericJackson2JsonRedisSerializer);
     redisTemplate.setHashKeySerializer(genericJackson2JsonRedisSerializer);
     redisTemplate.setHashValueSerializer(genericJackson2JsonRedisSerializer);
     return redisTemplate;
   }
   ```

2. 如果使用Cache注解

   ```java
   /**
        * 配置缓存管理器(设置好对应的序列化器)
        * @param redisConnectionFactory
        * @return
        */
   @Bean
   public CacheManager cacheManager(RedisConnectionFactory redisConnectionFactory) {
     //初始化一个RedisCacheWriter
     RedisCacheWriter redisCacheWriter = RedisCacheWriter.nonLockingRedisCacheWriter(redisConnectionFactory);
     //设置CacheManager的值序列化方式为json序列化
     RedisSerializer<Object> jsonSerializer = new GenericJackson2JsonRedisSerializer();
     RedisSerializationContext.SerializationPair<Object> pair = RedisSerializationContext.SerializationPair
       .fromSerializer(jsonSerializer);
     RedisCacheConfiguration defaultCacheConfig=RedisCacheConfiguration.defaultCacheConfig()
       .serializeValuesWith(pair);
     //初始化RedisCacheManager
     return new RedisCacheManager(redisCacheWriter, defaultCacheConfig);
   }
   ```

上述的配置CacheManager中,并没有配置key的过期时间,所以如果有需要将key设置过期时间需求的,可以参考下面这种方式,可以灵活的配置每个map的key的过期时间

```java
//返回cacheManager,并配置好key的过期时间
@Bean
public CacheManager cacheManager(RedisConnectionFactory redisConnectionFactory) {
  return new RedisCacheManager(
    RedisCacheWriter.nonLockingRedisCacheWriter(redisConnectionFactory),
    this.getRedisCacheConfigurationWithTtl(600), // 设置默认过期时间(-1表示永不过期),如果没有在map中配置过期时间,则使用该过期时间
    this.getRedisCacheConfigurationMap() //将所有配置好过期时间的map传入
  );
}

//获取所有的map
private Map<String, RedisCacheConfiguration> getRedisCacheConfigurationMap() {
  Map<String, RedisCacheConfiguration> redisCacheConfigurationMap = new HashMap<>();
  //配置好每个map的key的过期时间(如果没有配置,则会使用默认的过期时间
  redisCacheConfigurationMap.put("UserInfoList", this.getRedisCacheConfigurationWithTtl(3000));
  redisCacheConfigurationMap.put("UserInfoListAnother", this.getRedisCacheConfigurationWithTtl(18000));

  return redisCacheConfigurationMap;
}

//创建设置好过期时间的RedisCacheConfiguration
private RedisCacheConfiguration getRedisCacheConfigurationWithTtl(Integer seconds) {
  Jackson2JsonRedisSerializer<Object> jackson2JsonRedisSerializer = new Jackson2JsonRedisSerializer<>(Object.class);
  ObjectMapper om = new ObjectMapper();
  om.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
  om.enableDefaultTyping(ObjectMapper.DefaultTyping.NON_FINAL);
  jackson2JsonRedisSerializer.setObjectMapper(om);

  RedisCacheConfiguration redisCacheConfiguration = RedisCacheConfiguration.defaultCacheConfig();
  redisCacheConfiguration = redisCacheConfiguration.serializeValuesWith(
    RedisSerializationContext
    .SerializationPair
    .fromSerializer(jackson2JsonRedisSerializer)//设置序列化器
  ).entryTtl(Duration.ofSeconds(seconds));//设置过期时间

  return redisCacheConfiguration;
}
```





## 安装redis的图形客户端

[mac下载地址](http://www.pc6.com/mac/486661.html)

## 参考文档

[csdn-redis](https://blog.csdn.net/hzlarm/article/details/99432240)