## 操作步骤

1. 引入依赖：

   ```xml
   <dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-test</artifactId>
     <scope>test</scope>
     <exclusions>
       <exclusion>
         <groupId>org.junit.vintage</groupId>
         <artifactId>junit-vintage-engine</artifactId>
       </exclusion>
     </exclusions>
   </dependency>
   ```

2. 通过idea的自动生成来生成测试类,然后再测试类上加上`@SpringBootTest`注解和`@RunWith(SpringRunner.class)`即可

   ```java
   @RunWith(SpringRunner.class)
   @SpringBootTest(classes = GbopPortalApplication.class) //指定Springboot的主启动类
   public class ClusterServiceImplTest {
     @Autowired
     ClusterService clusterService; //可以正常的注入程序中的JavaBean
     
     @Transactional //如果测试通过后，修改的数据会回滚
     @Test
     public void addCluster() {
       	...
     }
   
     @Test // 标注了@Test的方法就是测试方法
     public void getClusters() {
       	...
     }
   }
   ```

## junit相关的内容

junit相关的测试注解还有很多：

- `@BeforeEach`:在每个方法执行前执行

- `@BeforeClass`:针对所有测试，只执行一次，且必须为`static void`
- `@Before`:初始化方法，执行当前测试类的每个测试方法后执行
- `@Test`:测试方法，在这里可以测试期望异常和超时时间
- `@After`:释放资源，执行当前测试类的每个测试方法后执行
- `@AfterClass`:针对所有测试，只执行一次，且必须为`static void`
- `Ignore` :忽略的测试方法
- `@Runwith`:可以更改测试运行器，缺省值`org.junit.runner.Runner`

**一个单元测试类执行顺序为：**
 `@BeforeClass` -> `@Before` -> `@Test` -> `@After`  -> `@AfterClass`

**每一个测试方法的调用顺序为：**
 `@Before` -> `@Test` -> `@After`

**超时测试**

`@Test(timeout = 1000)`

**异常测试**

`@Test(expected = NullPointerException.class)`

---

**参数化测试（重要）**

。。。

## Assert相关

assert常用方法

- `assertEquals("message",A,B)`:判断对象A和B是否相等，这个判断比较时调用了equals()方法。
- `assertSame("message",A,B)`:判断对象A和B是否相同，使用的是==操作符。
- `assertTure("message",A)`:判断A条件是否为真。
- `assertFalse("message",A)`:判断A条件是否不为真。
- `assertNotNull("message",A)`:判断A对象是否不为null
- `assertArrayEquals("message",A,B)`: 判断A数组与B数组是否相等。

## SpringbootTest基本内容

SpringbootTest主要包括两个核心：

- spring-boot-test： 支持测试的核心内容。
- spring-boot-test-autoconfigure：支持测试的自动化配置。

引入上面的依赖后会对应的引入以下内容：

- Junit: Java应用程序单元测试标准类库。
- Spring Test & Spring Boot Test: Spring Boot 应用程序功能集成化测试支持。
- AssertJ: 一个轻量级断言类库。
- Hamcrest: 一个对象匹配器类库。
- Mockito: 一个java Mock测试框架。
- JSONassert: 一个用于JSON的断言库。
- JsonPath: 一个Json操作类库。

### Mockito（模拟数据）

使用Mockito一般分为三个步骤：

- 1.模拟测试类所需的外部依赖
- 2.执行测试代码
- 3.判断执行结果是否达到预期

---

demo：

```java
@Test
public void detail() throws Exception {
  ServiceDetailReq serviceDetailReq = new ServiceDetailReq();
  mvc.perform(
    MockMvcRequestBuilders.get("/api/v1/service/detail")
    /*设置返回类型为utf-8,否则默认为ISO-8859-1*/
    .accept(MediaType.APPLICATION_JSON_UTF8_VALUE)
    .param("serviceId","24")
    .param("status", "1")
  )
    .andExpect(MockMvcResultMatchers.status().isOk())
    .andExpect(MockMvcResultMatchers.content().string("hello"))
    .andDo(MockMvcResultHandlers.print());
}
```







## 参考链接

https://www.jianshu.com/p/81fc2c98774f