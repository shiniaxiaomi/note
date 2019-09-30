[TOC]

# java

## java基础

https://link.zhihu.com/?target=https%3A//mp.weixin.qq.com/s/IBbD3CmVWsTL9ymHg6gGGA

### JDK和JRE的区别

- JDK: java Develpment Kit的简称,java开发工具包,提供了java的开发环境和运行环境
- JRE: Java Runtime Environment的简称,java运行环境,为java的运行提供了所需环境

具体来说JDK其实包含了JRE.同时还包含了编译java源码的编译器javac,还包含了很多java程序调试和分析的工具; 简单来说: 如果你需要运行Java程序,只需要安扎u那个JRE就可以了,如果你需要编写java程序,需要安扎u那个JDK(因为你需要javac进行编译)

### ==和equals的区别

#### ==的理解

对于基本类型和引用类型,==的作用效果是不同的,如下所示

- 基本类型: 比较的是值是否相同
- 引用类型: 比较的是引用是否相同

代码示例

```java
String x = "string";
String y = "string";
String z = new String("string");
System.out.println(x==y); // true
System.out.println(x==z); // false
System.out.println(x.equals(y)); // true
System.out.println(x.equals(z)); // true
```

> 因为x和y指向的时同一个引用,所以`==`也是true,而new String()方法则重新开辟了内存空间,所以`==`结果为false,而equals比较的一直是值,所以结果都为true

#### equals解读

equals本质上就是==,只不过Sring和Integer等类重写了equals方法,把它变成了值比囧啊; 看如下代码:

首先看默认情况下equals比较一个有相同值的对象

```java
class Cat {
    public Cat(String name) {
        this.name = name;
    }
    private String name;
}

Cat c1 = new Cat("王磊");
Cat c2 = new Cat("王磊");
System.out.println(c1.equals(c2)); // false
```

> 结果为false,接下来去看一下equals源码就知道了

equals源码如下:

```java
public boolean equals(Object obj) {
    return (this == obj);
}
```

> 所以equals本质上就是==

那么问题来了,两个相同值的String的equals方法为什么返回的是true呢,接下来看一下String类中对equals方法的重写

```java
public boolean equals(Object anObject) {
    if (this == anObject) {//如果引用相等,则肯定相等
        return true;
    }
    if (anObject instanceof String) {//如果是字符串,则继续比较
        String anotherString = (String)anObject;//获取要比较字符串
        int n = value.length;
        if (n == anotherString.value.length) {//如果长度相等,则继续比较
            char v1[] = value;
            char v2[] = anotherString.value;
            int i = 0;
            while (n-- != 0) {//比较每个字符是否相等
                if (v1[i] != v2[i])
                    return false;
                i++;
            }
            return true;
        }
    }
    return false;
}
```

> 因为String类重写了Object的equals方法,所以把引用比较改成了值比较

#### 总结

==对于基本类型来说是值比较,对于引用类型来说比较的是引用; 而equals默认情况下是引用比较,只是很多类重写了equals方法,比如String,Integer等,把从引用比较改成了值比较,所以一般情况下equals比较的是值是否相等

### 两个对象的hashCode()相同,则equals()也一定为true,对吗

不对,两个对象的hashCode()相同,equals()不一定为true

代码示例: 

```java
String str1 = "通话";
String str2 = "重地";
System.out.println(String.format("str1：%d | str2：%d", 
                     str1.hashCode(),str2.hashCode()));
System.out.println(str1.equals(str2));
```

> 执行结果:
>
> str1：1179395 | str2：1179395
>
> false

代码解读: 很显然"通话"和"重地"的hashCode()相同,然而equals()则为false,因为在散列表中,hashCode相等即为两个键值对的哈希值想到等,然而哈希值相等,并不一定能得出键值对相等

### final在java中有什么作用

- final修饰的类叫最终类,该类不能被继承
- final修饰的方法不能被重写
- final修饰的变量叫常量,常量必须初始化,初始化之后值就不能被修改

### java中的Math.round(-1.5)等于多少

等于-1,因为在数轴上取值时,中间值(0.5)向右取整,所以正0.5是往上取整

代码示例

```java
public static void main(String[] args) {
        long round1 = Math.round(-1.5);
        long round2 = Math.round(-0.5);
        long round3 = Math.round(0.5);
        long round4 = Math.round(1.5);
        System.out.println(round1); // -1
        System.out.println(round2); // 0
        System.out.println(round3); // 1
        System.out.println(round4); // 2
}
```

### String属于基础的数据类型吗

String不属于基础类型

基础类型有8中: byte,boolean,char,short,int,float,long,double

而String属于对象

### java中操作字符串都有哪些类?他们之间的区别?

操作字符串的类有: String,StringBuffer,StringBuilder

String,StringBuffer和StringBuilder的区别在于:

- String声名的是不可变的对象,每次操作都会生成新的String对象,然后将指针指向新的String对象
- StringBuffer和StringBuilder可以在原有对象的基础上进行操作,所以在经常改变字符串内容的情况下最好不要使用String
- `StringBuffer`和`StringBuilder`最大的区别在于: `StringBuffer`是线程安全的,而`StringBuilder`是非线程安全的,但`StringBuilder`的性能却高于`StringBuffer`,但在单线程环境下推荐使用`StringBuilder`,多线程环境下推荐使用`StringBuffer`

### String str="i"与String str=new String("i")一样吗?

不一样,因为内存的非配方式一样; `String str="i"`的方式,java虚拟机会将其分配到常量池中; 而`String str=new String("i")`则会被分到堆内存中

### 如何将字符串反转

使用`StringBuilder`或者`StringBuffer`的`reverse()`方法

示例代码

```java
// StringBuffer reverse
StringBuffer stringBuffer = new StringBuffer();
stringBuffer.append("abcdefg");
System.out.println(stringBuffer.reverse()); // gfedcba
// StringBuilder reverse
StringBuilder stringBuilder = new StringBuilder();
stringBuilder.append("abcdefg");
System.out.println(stringBuilder.reverse()); // gfedcba
```

### String类的常用方法都有哪些

- indexOf(): 返回指定字符的索引
- charAt(): 返回指定索引处的字符
- replace(): 字符串替换
- split(): 分割字符串,返回一个分割后的字符串数组
- getBytes(): 返回字符串的byte类型数组
- length(): 返回字符串长度
- toLowerCase(): 将字符串转化成小写字母
- substring(): 截取字符串
- equals(): 字符串比较

### 抽象类必须要有抽象方法吗

不需要,抽象类不一定要有抽象方法

示例代码

```java
abstract class Cat {
    public static void sayHi() {
        System.out.println("hi~");
    }
}
```

> 上述代码,抽象类并没有抽象方法但完全可以正常运行

### 普通类和抽象类有哪些区别

- 普通类不能包含抽象方法,抽象类可以包含抽象方法
- 抽象类怒能直接实例化,普通类可以直接实例化

### 抽象类能使用final修饰吗

不能,定义抽象类就是让其他类继承的,如果定义为final,该类就不能被继承,这样彼此就会产生矛盾,所以final不能修饰抽象类

### 接口和抽象类有什么区别

- 实现: 子类使用extends来继承父类; 接口必须使用implements来实现接口

- 构造函数: 抽象类可以有构造函数; 接口不能有;

  > 抽象类虽然不能实例化,但是他是可以拥有构造函数的;
  >
  > 其一般用来初始化抽象类的一些字段,而这一切都在抽象类的子类类实例化之前发生的;
  >
  > 所以抽象类的构造函数还有一种巧妙的应用,就是实现该抽象类的子类实例化前必须要先执行抽象类的构造函数,所以我们可以在抽象类的构造函数中执行一些必须执行的一些代码
  >
  > 如果我们没有为抽象类编写构造函数,编译器还会为我们生成一个默认的保护级别的构造函数

- main方法: 抽象类可以有main方法,并且我们能运行他; 接口不能有main方法;

- 实现数量: 类可以实现很多个接口; 但是只能继承一个抽象类

- 访问修饰符: 接口中的方法默认使用public修饰; 抽象类中的方法可以是任意访问修饰符;

### java中IO流分为几种

按功能来分: 输入流`input`,输出流`output`

按类型来分: 字节流和字符流

> 字节流和字符流的区别是: 字节流按8为传输,以字节为单位输入输出数据; 字符流按16为传输,以字符为单位输入输出数据

### BIO,NIO,AIO有什么区别

- BIO: Block IO,同步阻塞式IO,就是我们平常使用的传统IO,他的特点式模式简单,使用方便,并发处理能力低
- NIO: New IO,同步非阻塞IO,是传统IO的升级,客户端和服务器端通过Channel(通道)通讯,实现了多路复用
- AIO: Asynchronous IO,是NIO的升级,也叫NIO2,实现了异步非阻塞IO,异步IO的操作基于事件和回调机制

### Files的常用方法都有哪些

- Files.exist(): 检查文件路径是否存在
- Files.createFile(): 创建文件
- Files.createDirectory(): 创建文件夹
- Files.delete(): 删除一个文件或目录
- Files.copy(): 复制文件
- Files.move(): 移动文件
- Files.size(): 查看文件个数
- Files.read(): 读取文件
- Files.write(): 写入文件

## 容器

https://mp.weixin.qq.com/s/Yl9pTaQYKwf0rZ6InG9OZg

### java容器都有哪些

常用容器:

![img](.img/.Interview准备/640.webp)

### Collection和Collections有什么区别

- java.util.Collection是要给集合接口(集合类的一个顶级接口); 他提供了对集合对象进行基本操作的通用接口方法; Collection接口在java类库中有很多具体的实现; Collection接口的意义是为各种具体的集合提供了最大化的统一操作方法,其直接继承的接口有List和Set
- Collections则是集合类的一个工具类,其中提供了一些列静态方法,用于对集合中元素进行排序,搜索以及线程安全等各种操作

### List,Set,Map之间的区别是什么

![img](.img/.Interview准备/640-1569827836419.webp)

### HashMap和Hashtable有什么区别

- hashMao去掉了HashTable的contains()方法,但是加上了containsValue()和containsKey()方法

- hashTable是线程同步的,而HashMap是非同步的,效率上比hashTable要高

- hashMap允许空键值,而hashTable不可以

  > HashTable不能接受null的键和值的原因时equals()方法需要对象,而HashMap是后出的API经过处理才可以的

### 如何决定使用HashMap还是TreeMap

对于在Map中插入,删除和定位元素这类操作,HashMap是最好的选择; 然而,假如你需要对一个有序的key集合进行遍历,TreeMap是更好的选择; 基于你的collection的大小,也许向HashMap中添加元素会更快,将map转换为TreeMap进行有序key的遍历

```java
TreeMap treeMap=new TreeMap();
treeMap.put("a",1);
treeMap.put("c",1);
treeMap.put("b",1);
treeMap.put("r",1);
Set set = treeMap.keySet();
Iterator iterator = set.iterator();
while (iterator.hasNext()){
    System.out.print(iterator.next()+" ");
}
System.out.println();
//结果: a b c r(有序)

HashMap hashMap=new HashMap();
hashMap.put("a",1);
hashMap.put("c",1);
hashMap.put("b",1);
hashMap.put("r",1);
Set set1 = hashMap.keySet();
Iterator iterator1 = set1.iterator();
while (iterator1.hasNext()){
    System.out.print(iterator1.next()+" ");
}
//结果: a b r c(无序)
```

### 说一下HashMap的实现原理

- HashMap概述:

  HashMap是基于哈希表的Map接口的非同步实现; 此实现提供所有可选的映射操作,并允许使用null值和null键; 此类不保证映射的顺序,特别是他不保证顺序永久不变

- HashMap的数据结构:

  在java中,最基本的结构就是两种,一个是数组,另一个是链表(引用),所有的数据结构都可以用这两个基本结构来构造,HashMap也不例外; HashMap实际上是一个"链表散列"的数据结构,即数据和链表的结合体

当我们往HashMap中put元素时,首先更具key的hashcode重新计算hash值,根据hash值得到这个元素在数据中的位置(下标),如果该数组在该位置上已经存放了其他元素,那么在这个位置上的元素将以链表的形式存放,新加入的放在链头,最后加入的放在链尾; 如果数组中该位置没有元素,就直接将该元素放到数组的该位置上

需要注意jdk1.8中对HashMap的实现做了优化,当链表中的节点数据超过8个之后,该链表会展位红黑树来提高查询效率,从原来的O(n)到O(logn)

### 说一下HashSet的实现原理

- HashSet底层有HashMap实现
- HashSet的值存放于HashMap的key上(即HashSet仅仅使用了HashMap的key的散列数组)
- HashSet使用的HashMap对象的value统一设置为`present`

存储原理

往HashSet添加元素时,HashSet会先调用元素的hashCode()方法得到元素的哈希值,然后通过元素的哈希值经过位移等运算,就可以算出该元素在哈希表中的存储位置

- 情况1

  如果算出元素存储的位置目前没有任何元素存储,那么该元素可以直接存储到该位置上

- 情况2

  如果算出该元素的存储目前已经存在有其他的元素了,那么会调用该元素的equals方法与该位置的元素再比较一次,如果equals方法返回的是false,那么该元素运行添加,如果返回true,则不做任何操作

### HashMap和HashSet的区别

- HashMap实现了Map接口,而HashSet实现类了Set接口
- HashMap存储键值对,而HashSet仅仅存储对象
- HashMap使用put()方法将元素放入map中,而HashSet使用add()方法将元素放入set中
- HashMap中使用键来计算hashcode值,而HashSet使用成员对象来计算hashcode值,对于两个对象来说,hashcode可能相同,所以equals()方法用来判断对象的相等性,如果两个对象不同,则返回false,那么执行添加操作,如果相等,则不做任何操作
- HashMap比较块,因为是使用唯一键来获取对象,而HashSet较HashMao来说比较慢,因为他再添加时还做了一次hashcode运算和比较

### ArrayList和LinkedList的区别是什么

最明显的区别时ArrayList底层的数据结构是数组,支持随机访问,而LinkedList的底层数据结构是双向循环链表,不支持随机访问; 使用下标访问一个元素,ArrayList的时间复杂度是O(1),而LinkedList是O(n)

### 如何实现数组和List之间的转化

- List转换成为数组: 调用ArrayList的toArray方法
- 数组转换成为List: 调用Arrays的asList方法

### ArrayList和Vector的区别是什么

- Vector是同步的,而ArrayList不是; 而然,如果你寻求再迭代的时候对列表进行改变,你应该使用CopyOnWriteArrayList
- ArrayList比Vector快,Vector因为有同步,不会过载
- ArrayList更加通用,因为我们可以使用Collections工具类轻易的获取同步列表和只读列表

### Array数组和ArrayList有何区别

- Array可以容纳基本类型和对象,而ArrayList只能容纳对象
- Array数组是指定大小的,而ArryaList大小是可变的
- Array数组没有提供ArrayList那么多功能,比如addAll(),removeAll()和iterator()等

### 在Queue中poll()和remove()有什么区别

poll()和remove()都是从队列中取出一个元素,poll()在获取元素在失败的时候会返回空,但是是remove()失败的时候会抛出异常

### 哪些集合类是线程安全的

- Vector: 就比ArrayList多了一个同步化机制(线程安全),因为效率较低,现在已经不太建议使用; 在web应用中,特别是前台页面,往往效率(页面响应速度)是优先考虑的
- stack: 堆栈类,先进后出
- HashTable: 就比HashMap多了一个线程安全
- enumeration: 枚举,相当于迭代器

### 迭代器Iterator是什么

迭代器是一种设计模式,他是要给对象,他可以遍历并选择序列中的对象,而开发人员不需要了解该序列的底层结构; 迭代器通常被成为"轻量级"对象,因为创建他的代价小

### Iterator怎么使用?有什么特点

java中的Iterator功能比较简单,并且只能单向移动:

1. 使用方法iterator()要求容器返回一个Iterator对象; 第一次调用Iterator的next()方法时,他返回序列的第一个元素; 注意: iterator()方法是java.lang.Iterable接口提供的,被Collecion继承
2. 使用next()虎丘序列中的下一个元素
3. 使用hasNext()检查序列中是否还有元素
4. 使用remove()将迭代器新返回的元素删除

Iterator是java迭代器最简单的实现,为List设计的ListIterator具有更多的功能,他可以从两个方向遍历List,也可以从List中插入和删除元素

### Iterator和ListIterator有什么区别

- Iterator可用来遍历Set和List集合,但是ListIterator只能用来遍历List
- Iterator对集合只能是向后遍历,ListIterator既可以向前也可以向后
- ListIterator实现了Iterator接口,并包含其他的功能,比如: 增加元素,替换元素,获取前一个和后一个元素的索引等

## 多线程

https://mp.weixin.qq.com/s/ywOwdXuMG5rhEXMH_OXKEQ

### 并行和并发有什么区别

- 并行是指两个或者多个事件在同一时刻发生; 而并发是指两个或多个事件在同意时间间隔发生
- 并行是在不同实体上的多个事件,而并发是在同一实体上的多个事件
- 在一台处理器上"同时"处理多个任务,在多台处理器上同时处理多个任务; 如hadoop分布式集群

所以并发编程的目标是充分的利用处理器的每个核,以达到最高的处理性能

---

更易于理解的解释:

**并行**: 指在同一时刻,有多条执行在多个处理器上同时执行, 所以无论从微观还是从宏观来看,二者都是一起执行的

![img](.img/.Interview准备/7557373-72912ea8e89c4007.webp)

**并发**: 指在同一时刻只能有一条执行执行,但多个进程指令被快速的轮换执行,使得在宏观上具有多个进程同时执行的效果,但在微观上并不是同时执行的,只是把事件分成若干段,使得多个进程快速交替的执行

![img](.img/.Interview准备/7557373-da64ffd6d1effaac.webp)

并行在多处理器系统中存在,而并发可以在单处理器和多处理器系统中都存在,并发能够在单处理器系统中存在是因为并发是并行的假象,并行要求程序能够同时执行多个操作,而并发只是要求程序假装同时执行多个操作(每个小时间片执行一个操作,多个操作快速切换执行

### 线程和进程的区别

简而言之,进程时程序运行和资源分配的基本单元,一个程序至少有一个线程,一个进程至少有一个线程; 进程在执行过程中拥有独立的内存单元,而多个线程共享内存资源,减少切换次数,从而效率更高; 线程是进程的一个实体,是cpu调度和分派的基本单位,是比程序更小的独立运行的基本单位; 同一进程中的多个线程之间可以并发执行;

### 守护线程是什么

### 创建线程有哪几种方式

### 说一下runnable和callable的区别

### 线程有哪些状态

### sleep()和wait()有什么区别

### notify()和notifyAll()有什么区别

### 线程的run()和start()有什么区别

### 创建线程池有哪几种方式

### 线程池都有哪些状态

### 线程池中的submit()和execute()方法有什么区别

### 在java程序中怎么保证多线程的运行安全

### 多线程锁的升级原理是什么

### 什么是死锁

### 怎么防止死锁

### ThreadLocal是什么?有哪些使用场景

### 说一下synchronized底层实现原理

### synchronized和volatile的区别是什么

### synchronized和ReentrantLock区别是什么

### 说一下啊atomic原理

## 反射

https://mp.weixin.qq.com/s/QzwyYexI6v6sDb9h5tQxKA

### 什么是反射

### 什么是java序列化?什么情况下需要序列化?

### 动态代理是什么?有哪些应用?

### 怎么实现动态代理?

## 对象拷贝

https://mp.weixin.qq.com/s/w1s1PbsHrZEU7e04pUkDOg

### 为什么要使用克隆

### 如何实现对象克隆

### 深拷贝和浅拷贝区别是什么?

## java web

https://mp.weixin.qq.com/s/3C3LimAv7Zt7V2ZxCT-MsQ

### jsp和servlet有什么区别

### jsp有哪些内置对象?作用分别是什么?

### 说一下jsp的4中作用域

### session和cookied有什么区别

### 说一下session的工作原理

### 如何客户端禁止cookie能实现session还能使用吗?

### springmvc和struts的区别是什么?

### 如何避免sql注入?

### 什么是XSS攻击,如何避免?

### 什么是CSRF攻击,如何比避免?

## 异常

https://mp.weixin.qq.com/s/CHq5BcH9AtdV0emCQ5naLw

### throw和throws的区别

### final,finally,finalize有什么区别

### try-catch-finally中哪个部分可以省略

### try-catch-finally中,如果 catch中return了,finally还hi执行吗?

### 常见的异常类有哪些?

## 网络

https://mp.weixin.qq.com/s/F201iO7TQNkZz8yAh3PILg

### http响应码301和302代表的是什么?有什么区别

### forward和redirect的区别

### 简述tcp和udp的区别

### tcp为什么要三次握手,两次不行吗?为什么?

### 说一下tcp粘包是怎么产生的?

### OSI的七层模型都有哪些?

### get和post请求有哪些区别

### 如何实现跨域?

### 说一下JSONP实现原理

## 设计模式

https://mp.weixin.qq.com/s/Wahq4TnCm4Pzb6VshWma1Q

### 单例模式

### 观察者模式

### 装饰者模式

### 适配器模式

### 工厂模式

### 代理模式

### 简单工厂和抽象工厂有什么区别

# 框架

## spring

### 为什么要使用spring?

### 解释一下什么是AOP

### 解释一下什么是IOC

### spring有哪些主要模块

### spring常用的注入方式有哪些?

### spring中的bean是线程安全的吗

### spring支持几种bean的作用域?

### spring自动装配bean有哪些方式?

### spring事务实现方式有哪些?

### 说一下spring的事务隔离?

## springmvc

https://mp.weixin.qq.com/s/eHK5wqAv5UgYoYUnpFCxzA

### 说一下springmvc运行流程

### springmvc有哪些组件

### @RequestMapping的作用是什么?

### @Autowired的作用是什么?

## springboot

https://mp.weixin.qq.com/s/UscOEtOBq5qjy1-SJLYtaw

### 什么是springboot

### 为什么要用springboot

### springboot核心配置文件是什么

### springboot配置文件有哪几种类型?它们有什么区别?

### springboot有哪些方式可以实现热部署?

### jpa和hibernate有什么区别?

## springcloud

https://mp.weixin.qq.com/s/UscOEtOBq5qjy1-SJLYtaw

### 什么是springcloud

### springcloud断路器的作用是什么

### springcloud的核心组件有哪些?

## mybatis

https://mp.weixin.qq.com/s/teI5po4wHfIScppMXiU-Bg

### mybatis中#{}和${}的区别是什么

### mybatis有几种分页方式?

### mybatis逻辑分页和物理分页的区别是什么

### mybatis是否支持延迟加载?延迟加载的原理是什么?

### 说一下mybatis的一级缓存和二级缓存?

### mybatis和hibernate的区别有哪些?

### mybatis有哪些执行器(Executor)

### mybatis分页插件的实现原理是什么?

### mybatis如何编写一个自定义插件

## rabbitmq

https://mp.weixin.qq.com/s/P2orZB_aS4bQit8ACrmHAw

### rabbitmq的使用场景有哪些

### rabbitmq有哪些重要的角色?

### rabbitmq有哪些重要的组件?

### rabbitmq中vhost的作用是什么?

### rabbitmq的消息是怎么发送的?

### rabbitmq怎么保证消息的稳定性

### rabbitmq怎么避免消息丢失?

### 要保证消息持久化成功的条件有哪些?

### rabbitmq持久化有什么缺点?

### rabbitmq有集中广播类型

### rabbitmq怎么实现延迟消息队列

### rabbitmq集群有什么用

### rabbitmq节点的类型有哪些

### rabbitmq集群搭建需要主要哪些问题

### rabbitmq每个节点是其他节点的完整拷贝吗?为什么?

### rabbitmq集群中唯一一个磁盘节点崩毁了会发生什么情况?

### rabbitmq对集群节点停止顺序有要求吗

## kafka

https://mp.weixin.qq.com/s/vW_NtOsh5Sv8n3WVmR08eA

### kafka可以脱离zookeeper单独使用吗?为什么

### kafka有几种数据保留的策略

### kafka同时设置了7天和10G清除数据,到第5天的时候消息达到了10G,这个时候kafka将如何处理?

### 什么情况会导致kafka运行变慢

### 使用kafka集群需要注意什么?

## zookeeper

https://mp.weixin.qq.com/s/ZI86U4r3ZppYE3KkmKLNWw

### zookeeper是什么

### zookeeper都有哪些功能

### zookeeper有几种部署模式?

### zookeeper怎么保证主从节点的状态同步?

### 集群中为什么要有主节点?

### 集群中有3台服务器,其中一个节点宕机,这个时候zookeeper还可以使用吗?

### 说一下zookeeper的通知机制?

## mysql

https://mp.weixin.qq.com/s/BXSfeO1B_uaPy2tSdEvp-A

### 数据库的三范式是什么?

### 一张自增表里面总共有17条数据,删除了最后2条数,重启mysql数据库,有插入了一条数据,此时id是几?

### 如何获取当前数据库版本?

### 说一下ACID是什么

### char和varchar的区别是什么

### float和double的区别是什么

### mysql的内连接,左连接,右连接有什么区别

### mysql索引是怎么实现的

### 怎么验证mysqk的索引是否满足需求?

### 说一下数据库的事务隔离?

### 说一下mysql常用的引擎?

### 说一下mysql的行锁和表锁

### 说一下乐观锁和悲观锁?

### mysql问题排查都有哪些手段?

### 如何做mysql的性能优化?

## redis

https://mp.weixin.qq.com/s/5I1Y77GN76h_OkVH1TisvA

### redis是什么?都有哪些使用场景?

### redis有哪些功能?

### redis和memecache有什么区别

### redis为什么是单线程的?

### 什么是缓存穿透?怎么解决?

### redis支持的数据类型有哪些?

### redis支持的java客户端都有哪些?

### jedis和redisson有哪些区别?

### 怎么保证缓存和数据库的一致性?

### redis持久化有几种方式?

### redis怎么实现分布式锁?

### redis如何做内存优化?

### redis淘汰策略有哪些?

### redis常见的性能问题有哪些?该如何解决?

## Oracle

...

# JVM

https://mp.weixin.qq.com/s/OcJvAuRG_mG9S3EYPcItCg

### 说一下jvm的主要组成部分?及其作用?

### 说一下jvm运行时数据区?

### 说一下堆栈的区别?

### 队列和栈是什么?有什么区别?

### 什么是双亲委派模型?

### 说一下类加载的执行过程?

### 怎么判断对象是否可以被回收?

### java中都有哪些引用类型?

### 说一下jvm有哪些垃圾回收算法?

### 说一下jvm有哪些垃圾回收器?

### 详细介绍一下CMS垃圾回收器

### 新生代垃圾回收器和老生代垃圾回收器都有哪些?有什么区别?

### 简述分代垃圾回收器是怎么工作的?

### 说一下jvm调优的工具

### 常见的jvm调优的参数都有哪些?

# 参考文档

- https://www.zhihu.com/question/27858692/answer/787505434

  > 第一个回答