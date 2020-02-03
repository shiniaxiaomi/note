# spring缓存注解

## 使用场景

spring将缓存框架的逻辑抽取出来,适合所有的第三方的缓存

如果你没有指定使用哪个第三方的缓存,那么spring就会自动的为你配置好,使用concurrentHashMap来作为存储

## 注解使用

### @Cacheable

该注解需要指定缓存的名称和key,如:

```java
 /**
     * 保存到user的concurrentHashMap中,key为传入的id(如果传入的参数是一个对象,那么也可以获取到对象的成员变量)
     * key可以使用单个值,也是通过字符串相加的形式拼接,如: @Cacheable(value = "user",key = "#id+','+#name")
     *
     * 先从缓存中获取,如果没有,则执行该方法获取,并保存到缓存中
     * @param id
     * @param name
     * @return
     */
@Cacheable(value = "user",key = "#id+','+#name")
public User getById(int id,String name){
  //查询
  System.out.println("查询");
  return new User(id,name);
}
```

> `user`就是要缓存的map的名称
>
> `key`就是map中的key(key中指定的`#id`取的就是传入变量的值,也可以使用''字符串进行拼接)
>
> 而map中所保存的对象,就是方法的返回值

该注解的作用是:在调用标注有该注解的方法时,会根据指定的key,去缓存中查询,如果缓存中存在,则从缓存中取;如果不存在,再调用该方法来返回user对象

> 简单的理解: 该注解就是在调用方法之前,看一下有没有缓存,没有则去数据库查之后在缓存,如果有则直接返回缓存的内容
>
> 可以吧该注解理解成添加和查询缓存的结合体

所以该注解一般使用在查询操作时使用

### @CacheEvict

该注解需要指定缓存的名称和key,如:

```java
/**
     * 从concurrentHashMap中删除user,key为传入的id
     * 原则: 直接执行删除user的操作,删除成功之后,才会清除掉缓存中的user,按照传入的id作为key进行清除
     *      清除之后,缓存中就不存在key为传入为id的user对象,那么在再次执行获取user的方法时,
     *      会直接查询数据库,然后再将数据保存到缓存中
     * @param id
     */
@CacheEvict(value = "user",key = "#id")
public void delete(int id) {
    System.out.println("删除userid:"+id);
}
```

> `user`就是要缓存的map的名称
>
> `key`就是map中的key

该注解的作用: 在调用标注有该注解的方法时,会先执行方法,如果方法执行成功,则再将缓存中的数据删除(根据指定key去删除),如果执行失败,则不删除缓存

> 一般在方法中,执行的是将数据库删除的操作,删除成功之后,再删除掉缓存的数据
>
> 该注解会按照指定的key去指定的map中删除对应的缓存
>
> 简单理解就是删除数据库后,顺便把缓存数据也删除掉

所以该注解一般使用在删除操作时使用

### @CachePut

该注解的功能和`@Cacheable`不同,他不会检查缓存中是否存在,而是直接的将数据缓存起来,如果数据已存在,那么也会被覆盖掉

> 简单理解就是当需要某些数据永远是最新时,可以使用该注解将保存的数据直接放入(覆盖)掉原来缓存中的数据,以便保证数据库和缓存中的数据是最新的

例如:

```java
/**
     * 先执行save方法,如果成功,那么将返回的user缓存
     * 如果失败,则不缓存
     * 如果执行成功,该注解不会查询缓存中是否存在,而是会直接覆盖掉缓存中的数据
     * @param id
     * @param name
     * @return
     */
@CachePut(value="goods", key="goods.goodsId", condition="goods.goodsId == 123456")
public Goods update(Goods goods) {
  return null;
}
```

> `condition`是进行条件判断,如果条件成立,才使得该注解生效
>
> 上述中,当`goods.goodsId == 123456`时,就直接将goods对象直接保存到缓存中,以保证数据是最新的

所以该注解一般是使用在添加和修改操作时使用

### @Caching

该注解可以让我们在一个方法或者类上同时指定多个Spring Cache相关的注解;其拥有三个属性：cacheable、put和evict，分别用于指定@Cacheable、@CachePut和@CacheEvict。

> 该注解一般用来定义复杂的缓冲规则

例如:

```java
/**
     * 复杂的缓存规则:
     * 先从user缓存中根据id查找,或从user1缓存中根据name查找,如果找到了,则直接返回
     * 如果没找到,则执行该方法
     * 如有该方法执行成功,则将返回值的id当做key缓存到user缓存中和将返回值的name当做key缓存到user1缓存中
     * @param id
     * @param name
     * @return
     */
@Caching(
  cacheable = {
    @Cacheable(value = "user",key = "#id"),
    @Cacheable(value = "user1",key = "#name")
  },
  put = {
    @CachePut(value = "user",key = "#result.id"),
    @CachePut(value = "user1",key = "#result.name")
  }
)
public User test2(int id,String name){
  System.out.println("复杂的缓存规则");
  User user = new User(id, name);
  return user;
}
```

## 参考文档

https://blog.csdn.net/wuzhiwei549/article/details/79914427