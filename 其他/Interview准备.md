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

守护线程,是个服务线程,准确的说就是服务其他线程

### 创建线程有哪几种方式

1. 继承Thread类创建线程类
   1. 定义Thread类的子类,并重写该类的run方法
   2. 创建Thread子类的实例,即创建了线程对象
   3. 调用线程对象的start()方法来启动该线程
2. 通过Runnable接口创建线程类
   1. 定义Runnable接口的实现类,并重写该接口的run()方法
   2. 创建Runnable实现类的实例,再创建Thread类并将实现了Runnable接口的实现类传入
   3. 条用线程对象的start()方法来启动该线程
3. 通过Callable和Futre创建线程
   1. 创建Callable接口的实现类,并实现call()方法,该call()方法将作为线程执行体,并且有返回值
   2. 创建Callable实现类的实例.使用FutrueTask类来包装Callable对象,该FutrueTask对象封装了该Callable对象的call()方法的返回值
   3. 使用FutrueTask对象作为构造参数传入Thread的构造函数中
   4. 调用FutrueTask对象的get()方法来获得子线程执行结束后的返回值

### 说一下runnable和callable的区别

这个问题有点深,也可以看出一个java程序员学习知识的广度

- Runnable接口中的run()方法的返回值是void,它做的事情知识纯粹的去执行run()方法中的代码而已
- Callable接口中的call()方法是有返回值的,是一个泛型,和Futrue,FutrueTask配合可以用来获取异步执行的结果

### 线程有哪些状态

线程通常都有五种状态: 创建,就绪,运行,阻塞和死亡

- 创建状态: 在创建线程对象后,并没有调用该对象的start()方法,该线程就处于创建状态
- 就绪状态: 当调用了线程对象的start()方法之后,该线程就进入了就绪状态,但是此时线程调用程序还没有把该线程设置为当前线程,此时处于就绪状态,在线程运行之后,从等待或者睡眠中回来之后,也会处于就绪准状态
- 运行状态: 线程调用程序将处理就绪状态的线程设置为当前线程,此时线程就进入了运行状态,开始运行run()方法
- 阻塞状态: 线程正在运行的时候被暂停,通常时为了等待某个事件的发生(比如谁某项资源就绪等)之后再继续运行; sleep,suspend,wait等方法都可以导致线程阻塞
- 死亡状态:  如果一个线程的run方法执行结束或者调用stop方法后,该线程就会死亡; 对于已经死亡的线程,无法再使用start方法令再进入就绪状态

### sleep()和wait()有什么区别

sleep()方法是线程类Thread的静态方法,让调用线程进入睡眠状态,让出执行机会给其他线程,等到休眠时间结束后,线程进入就绪状态和其他线程一起竞争cpu的执行时间; 因为sleep()是static静态的方法,它不能改变对象的机锁,当一个synchronized块中掉哟过了sleep()方法,线程虽然进入休眠,但是对象的机锁没有被释放,其他线程依然无法访问这个对象

wait()方式是Object类的一个方法,当以线程执行到wait()方法时,它就进入到一个和该对象相关的等待池,同时释放对象的机锁,使得其他线程能够访问,可以通过notify,notifyAll方法来唤醒等待的线程

### notify()和notifyAll()有什么区别

- 如果线程调用了对象的wait()方法,那么线程便会处于该**对象的等待池中**,等待池中的线程不会去竞争该对象的锁
- 当有线程调用了对象的notifyAll()方法(唤醒所有wait线程)或notify()方法(只随机唤醒一个wait线程),被唤醒的线程便会进入该对象的锁池中,锁池中的线程便会去竞争该对象锁; 也就是说,调用了notify后只有一个线程会由等待池进入锁池,而notifyAll会将该对象等待池内的所有线程移动到所持中,等待锁竞争
- 优先级高的线程竞争到对象锁的概率大,假若某线程没有竞争到该对象锁,它还会留在锁池中,唯有线程再次调用wait()方法,它才会重新回到等待池中; 而竞争到对象锁的线程则继续往下执行,知道执行完了synchronized代码块,它会释放掉该对象锁,这时锁池中的线程会继续竞争该对象锁

### 线程的run()和start()有什么区别

每个线程都是通过某个特定Thread对象所对应的run方法来完成器操作的,run()方法称为线程体; 通过调用Thread类的start()方法来启动一个线程

start()方法来启动一个线程,真正实现了多线程运行; 这是无需等待run方法代码执行完毕,可以直接继续执行下面的代码; 这时此线程是处于就绪状态,并没有运行; 然后通过系统调度,并由此Thread类调用其run方法来运行; run()方法运行结束,此线程终止,然后cpu再调度其他线程

run()方法是在本线程里的,只是线程里的一个函数,而不是多线程的; 如果直接调用run()方法,其实就是相当于是调用了一个普通函数而已,直接调用run()方法就导致必须要等待run()方法执行完毕后才能再执行下面的代码,所以执行路径还是只有一条,根本就没有线程的特征,所以在多线成执行时要使用start()方法而不是run()方法

### 创建线程池有哪几种方式

1. newFixedThreadPool(int nThreads)

   创建一个固定长度的线程池,每当提交一个任务就创建一个线程,直到达到线程池的最大数量,这是线程规模将不再变化,当线程发生未预期的错误而结束时,线程池会补充一个新的线程

2. newCachedThreadPool()

   创建一个可缓存的线程池,如果线程池的规模超过了处理需求,将自动回收空闲线程,而当需求增加时,则可以自动添加新线程,线程池的规模不存在任何限制

3. newSingleThreadExecutor()

   这是一个单线程的Executor,它创建单个工作线程来执行任务,如果这个线程异常结束,会创建一个新的来代替它; 它的特点是能确保依照任务在队列中的顺序来串行执行

4. newScheduleThreadPool(int corePoolSize)

   创建了一个固定长度的线程池,而且以延迟或定时的方式来执行任务,类似于Timer

### 线程池都有哪些状态

线程池有5种状态: Running,ShutDown,Stop,Tidying,Terminated

线程池各个状态切换框架图:

![img](.img/.Interview%E5%87%86%E5%A4%87/640-1569898172062.webp)



### 线程池中的submit()和execute()方法有什么区别

- 接受的参数不一样
- submit有返回值,而execute没有
- submit方便处理Exception

### 在java程序中怎么保证多线程的运行安全

线程安全在三个方面体现:

1. 原子性

   提供互斥访问,同一时刻只能有一个线程对数据进行操作(atomic,synchronized)

2. 可见性

   一个线程对主内存的修改可以及时的被其他线程看到(synchronized,volatile)

3. 有序性

   一个线程观察其他线程种的指令执行顺序,由于指令重排序,该观察结果一般杂乱无序(happens-before原则)

### 多线程锁的升级原理是什么

在java种,锁共有4种状态,级别从低到高依此为: 无状态锁,偏向锁,轻量级锁和重量级锁, 这几个状态会随着竞争情况逐渐升级; 锁可以升级但不能降级;

锁升级的图示过程:

![img](.img/.Interview%E5%87%86%E5%A4%87/640-1569898822157.webp)

### 什么是死锁

死锁是指两个或两个以上的进程在执行过程中,由于竞争资源或者有意彼此通信而造成的一种阻塞的现象,若无外力作用,他们都将无法推进下去, 此时称系统处理死锁状态或系统产生了死锁,这是永远在相互等待的进程称为死锁进程,这是操作系统层面的一个错误,是进程死锁的简称; 它是计算机系统乃至整个并发程序设计领域最难处理的问题之一

### 怎么防止死锁

死锁的四个必要条件:

1. 互斥条件

   进程对所分配到的资源不允许其他进程进行访问,若其他进程访问该资源,只能等待,直至占有该资源的进程使用完成后释放该资源

2. 请求和保持条件

   进程获得一定的资源之后,又对其他资源发出请求,但是该资源可能被其他进程占有,此事件请求阻塞,但又对自己获得的资源保持不放

3. 不可剥夺条件

   是指进程已获得的资源,在未完成使用之前,不可被剥夺,只能在使用完成后自己释放

4. 环路等待条件

   是指进程发生死锁后,若干进程之间形成一种头尾相接的循环等待资源关系

这四个条件是死锁的必要条件,只要系统发生死锁,这些条件必然程里,而只要上述条件之一不满足,就不会发生死锁

理解了死锁的原因,尤其是产生死锁的四个必要条件,就可以最大可能的避免,预防和理解死锁

所以,在系统设计,进程调度等方面注意如何不让这四个必要条件成立,如何确定资源的合理分配算法,避免进程永久占据系统资源

此外,也要防止进程在处于等待状态的情况下占用资源; 因此,对资源的分配要给予合理的规划

### ThreadLocal是什么?有哪些使用场景

线程局部变量是局限线程内部的变量,属于线程自身所有,不在多个线程间共享; java提供ThreadLocal类来支持线程局部变量,是一种实现线程安全的方式,但是在管理环境下(如web服务器)使用线程局部变量的时候要特别小心,在这种情况下,工作线程的声明周期比任何应用变量的声明周期都要长; 任何线程局部变量一旦在工作完成后没有释放,java应用就存在内存泄漏的风险

### 说一下synchronized底层实现原理

synchronized可以保证方法或者代码块在运行时,同一时刻只有一个方法可以进入到临界区,同时它还可以保证共享变量的内存可见性

java中每个对象都可以作为锁,这是synchronized实现同步的基础:

- 普通同步方法,锁是当前实例对象
- 静态同步方法,锁是当前类的class对象
- 同步方法块,锁是括号里的对象

### synchronized和volatile的区别是什么

- volatile本质就是告诉jvm当前变量在寄存器(工作内存)中的值是不确定的,需要从主存中读取; synchronized则是锁定当前变量,只有当前线程可以访问该变量,其他线程被阻塞住
- volatile仅能使用在变量级别; synchronized则可以使用在变量,方法和类级别
- volatile仅能实现便来那个的修改可见性,不能保证原子性; 而synchronized则可以保证变量的修改可见性和原子性
- volatile不会造成线程的阻塞; synchronized可能会造成线程的阻塞
- volatile标记的变量不会被编译器优化; synchronized标记的变量可以被编译器优化

### synchronized和Lock区别是什么

- 首选synchronized是java内置关键字,在jvm层面,Lock是一个java类
- synchronized无法判断是否获取锁的状态,Lock可以判断是否获取到锁
- synchronized会自动释放锁(a线程执行完同步代码会释放锁,b线程执行过程中发生异常会释放锁),Lock需要在finally中手动释放锁(unlock()方法释放锁),否则容易造成线程死锁;
- 用synchronized关键字的两个线程1和线程2,如果当前线程1获得锁,线程2等待; 如果线程1阻塞,线程2则会一直等待下去,而Lock锁不一定会等待下去,如果尝试获取不到锁,线程可以不用一直等待就结束了
- synchronized的锁可重入,不可判断,非公平,而Lock锁可重入,可判断,可公平
- Lock锁适合大量同步的代码的同步问题,synchronized锁适合代码少量的同步问题

### synchronized和ReentrantLock区别是什么

synchronized关键字,ReentrantLock是类,这是二者本质的区别

ReentrantLock提供了比synchronized更多更灵活的特性,可以被继承,可以有方法,可以有各种各样的类变量,ReentrantLock比synchronized的扩展性体现在几点上:

- ReentrantLock可以对获取锁的等待时间进行设置,这样就避免了死锁
- ReentrantLock可以获取各种锁的信息
- ReentrantLock可以灵活的实现多路通知

另外,二者的锁机制其实也是不一样的:

- ReentrantLock底层调用的Unsage的patk方法加锁
- synchronized操作的是对象头中的mark word

### 说一下atomic原理

Atomic包中的类基本的特性就是在多线程环境下,当有多个线程同时对单个(包括基本类型及引用类型)变量进行操作时,具有排他性,即当多个线程同时对该变量的值进行更新时,仅有一个线程能成功,而未成功的线程可以向自旋锁一样,继续尝试,一直等待执行成功

Atomic系列的类中的核心方法都会调用unsafe类中的几个本地方法; 我们需要先直到Unsafe类,全名为sun.misc.Unsafe,这个类包含了大量的对C代码的操作,包括很多直接内存分配以及原子操作的调用,而它之所以标记未非安全,是告诉你这个里面大量的方法调用都会存在安全隐患,需要小心调用,否则会导致严重的后果,例如在通过unsafe分配内存的时候,如果自己指定某些区域可能会导致一些类似C++一样的指针越界到其他进程的问题

## 反射

https://mp.weixin.qq.com/s/QzwyYexI6v6sDb9h5tQxKA

### 什么是反射

反射主要是指程序可以访问,检测和修改它本身状态或行为的一种能力

java反射:

在Java运行时环境中,对于任意一个类,能够知道这个类有哪些属性和方法?对于任意一个对象,能否调用它的任意一个能够

Java反射机制主要提供了以下功能:

- 在运行时判断任意一个对象所属的类
- 在运行时构造任意一个类的对象
- 在运行时判断任意一个类所具有的成员变量和方法
- 在运行时调用任意一个对象的方法

### 什么是java序列化?什么情况下需要序列化?

简单说就是为了保存在内存中的各种对象的状态(也就是实例变量,不是方法),并且可以把保存的对象状态再次读出来; 虽然你看可以用你自己的各种各样的方法来保存都对象的状态,但是java给你提供一种应该比你实现更好的保存对象状态的机制,那就是序列化

什么情况下需要序列化:

1. 当你想把内存中的对象状态保存到一个文件中或者数据库中时
2. 当你想用套接字在网络上传送对象的时候
3. 当你想通过RMI传输对象的时候

### 动态代理是什么?有哪些应用?

动态代理:

当想要给实现了某个接口的类中的方法,加一些额外的处理,比如说加日志,加事务等,可以给这个类创建一个代理,顾名思义就是创建一个新的类,这个类不仅包含原来类方法的功能,而且还在原来的基础上添加了额外处理的方法; 这个代理类并不是定义好的,是动态生成的; 其具有解耦意义,灵活,扩展性强

动态代理的应用:

- spring的AOP
- 加事务
- 加权限
- 加日志

### 怎么实现动态代理?

首先必须定义一个接口,还要有一个InvocationHandler(将实现接口的类的对象传递给它)处理类; 在有一个工具类Proxy(习惯性的将其称为代理类,因为调用它的newInstance()可以代理对象,其实它只是一个生产代理对象的工具类), 利用InvocationHandler接口,拼接代理类源码,将其编译生成代理类的二进制码,利用类加载器加载,并将其实例化生成代理对象,最后返回

## 对象拷贝

https://mp.weixin.qq.com/s/w1s1PbsHrZEU7e04pUkDOg

### 为什么要使用克隆

想对一个对象进行处理,又想保留原有的数据进行接下来的操作,就需要克隆了,java语言中克隆针对的是类的实例

### 如何实现对象克隆

有两种方式:

1. 实现Cloneable接口并重写Object类中的clone()方法

2. 实现Serializable接口,通过对象的序列化和反序列化实现克隆,可以实现正真的深度克隆,代码如下

   ```java
   import java.io.ByteArrayInputStream;
   import java.io.ByteArrayOutputStream;
   import java.io.ObjectInputStream;
   import java.io.ObjectOutputStream;
   import java.io.Serializable;
   
   public class MyUtil {
       private MyUtil() {
           throw new AssertionError();
       }
       @SuppressWarnings("unchecked")
       public static <T extends Serializable> T clone(T obj) 
                                     throws Exception {
           ByteArrayOutputStream bout = new ByteArrayOutputStream();
           ObjectOutputStream oos = new ObjectOutputStream(bout);
           oos.writeObject(obj);
   
           ByteArrayInputStream bin = 
                       new ByteArrayInputStream(bout.toByteArray());
           ObjectInputStream ois = new ObjectInputStream(bin);
           return (T) ois.readObject();
   
           // 说明：调用ByteArrayInputStream
           //或ByteArrayOutputStream对象的close方法没有任何意义
           // 这两个基于内存的流只要垃圾回收器清理对象就能够释放资源，
           //这一点不同于对外部资源（如文件流）的释放
       }
   }
   ```

注意: 基于序列化和反序列化实现的克隆不仅仅是深度克隆,更重要的是通过泛型限定,可以检查出要克隆的对象是否支持序列化,这项检查是编译器完成的,不是在运行时抛出异常,这种方案明显优于使用Object的clone方法克隆对象; 让问题在编译的时候暴露出来总是好过在问题留到运行时;

### 深拷贝和浅拷贝区别是什么?

- 浅考雷只是复制了对象的引用地址,两个对象指向同一个内存地址,所以修改其中任意的值,另一个值都会随之变化,这就是浅拷贝(例如:assign())
- 深拷贝是将对象及值复制过来,两个对象修改其中任意的值,另一个值不会给i阿扁,这就是深拷贝(例如: JSON.parse()和JSON.stringify(),但是此方法无法复制函数类型)

## java web

https://mp.weixin.qq.com/s/3C3LimAv7Zt7V2ZxCT-MsQ

### jsp和servlet有什么区别

1. jsp经编译后就变成了Servlet(jsp的本质就是servlet,jvm只能识别java类,不能识别jsp的代码,web容器将jsp的代码编译成jvm能够识别的java类)
2. jsp更擅长表现于页面显示,servlet更擅长于逻辑控制
3. servlet中没有内置对象,jsp中的内置对象都是必须通过HttpServletRequest对象,HttpServletReesponse对象以及HttpServlet对象得到
4. jsp是servlet的一种简化,使用jsp只需要完成程序员需要输出到客户端的内容,jsp中的java脚本如何镶嵌到一个类中,由jsp编译的时候自动完成; 而servlet则是个完整的java类,这个类的service方法用于生成对客户端的响应

### jsp有哪些内置对象?作用分别是什么?

JSP有9个内置对象:

- request: 封装客户端的请求,其中包含来自get和post的请求的参数
- response: 封装服务器对客户端的响应
- pageContext: 通过该对象可以获取其他对象
- session: 封装用户会话的对象
- out: 输出服务器响应的输出流对象
- config: web应用的配置对象
- page: jsp页面本身(相当于java程序中的this)
- exception: 封装页面抛出异常的对象

### 说一下jsp的4中作用域

jsp中的四种作用域: 

- page

  代表与一个页面相关的对象和属性

- request

  代表与web客户端发出的一个请求相关的对象和属性; 一个请求可能跨越多个页面,涉及多个web组件, 需要在页面显示的临时数据可以置于此用作域中

- session

  代表某个用户与整个web应用程序相关的对象和属性,它是指上是跨越整个web应用程序,包括多个页面,请求和会话的一个全局作用域

### session和cookied有什么区别

- 由于Http协议是无状态的协议,所以服务端需要记录用户的状态时,就需要用某种机制来识别具体的用户,这个机制就是Session; 典型的场景比如购物车,当你点击下单按钮时,由于http协议无状态,所以并不知道是哪个用户操作的,所以服务端要为特定的用户创建特定的session,用于标识这个用户,并且耿总用户,这样才知道购物车里面有几本书; 这个session是保存在服务器端的,有一个唯一标识; 在服务端保存session的方法很多,如内存,数据库,文件都有; 集群的时候也要考虑session转移,在大型的网站,一般会有专门的session服务器集群,用于保存用户会话,则个时候session信息都是放在在内存中,使用一些缓存服务比如Memcahed之类的来存放session
- 思考一下服务端如何识别特定的客户?这个时候cookies就登场了,每次http请求的时候,客户端都会发送相应的cookie信息到服务端; 实际上大多数的应用都是用Cookie来显示session耿总的,第一次创建session的时候,服务端会在http协议中告诉客户端,需要在cookie里记录一个session ID,以后每次请求把这个会话ID发送到服务器,我就知道你是谁了; 有人问,如果客户端的浏览器禁用cookie怎么办?一般这种情况下,会使用一种叫做URL重写的技术来进行会话跟踪,及每次http交互,url后面都会被附加上一个注入sid=xxxx这样的参数,服务器根据此来识别用户
- cookie其实还可以用在一些方便用户的场景下,设想你某次登入过一个网站,下次登入的时候不想再次输入账号了,怎么办?这个信息可以写到cookie中,访问网站的时候,网站页面的脚本可以读取这个信息,就自动帮你把用户名给填写了,能够方便用户,这也是cookie名称的由来,给用户的一点甜头; 所以,总结一下,session是再服务端保存的一个数据结构,用来跟踪用户的状态,这个数据可以保存在集群,数据库或文件中; cookie是客户端保存用户信息的一种机制,用来记录用户的一些信息,也是实现session的一种方式

### 说一下session的工作原理

其实session是一个存在服务器上的类似于一个散列表格的文件; 里面存有我们需要的信息,在我们需要用的时候从里面取出来,类似于一个大号的map,里面的减存储的是用户的sessionID,用户向服务器发送请求的时候会带上这个sessionID,这时就可以从中取出对应的值了

### 如何客户端禁止cookie能实现session还能使用吗?

cookie与session,一般认为是两个独立的东西,session采用的是在服务端保持状态的方案,而cookie采用的是在客户端保持状态的方案,但为什么禁用cookie就不能得到session呢?因为session是用sessionID来确定当前所对应的服务器session,而sessionID是通过cookie来传递的,禁用cookie相当于失去sessionID,也就得不到session了

假定用户关闭cookie的情况下使用session,可以手动通过url传值的方式传递sessionID

### springmvc和struts的区别是什么?

1. 拦截机制的不同

   struts2是类级别的拦截,每次请求就会创建一个action,和spring整合时struts2的ActionBean注入作用域时原型模式prototype,然后通过setter,getter把request数据注入到属性中; struts2中,一个Action对应一个request,response上下文,在接收参数时,可以通过属性接收,这说明属性参数是让多个方法共享的; struts2中Action的一个方法可以对应一个url,而其类属性却被所有方法共享,这也就无法用注解或其他方式标识其所属方法了,只能设计为多例

   springmvc是方法级别的拦截,一个方法对应一个request上下文,所有方法基本上是独立的,独享request,response数据; 而每个方法同时又有一个url对应,参数的传递时直接注入到方法中的,是方法所独有的; 处理结果通过ModeMap返回给框架; 在spring整合时,springmvc的ControllerBean默认单例模式,所以默认对所有请求只会创建一个Controller,所以时线程安全的,如果要改变默认的作用域,需要添加@Scope注解修改

   Struts2有自己的拦截Interceptor机制,springmvc使用的是AOP方式,这样导致Struts2的配置文件量比springmvc大

2. 底层框架的不同

   struts2采用Filter实现,而springmvc则采用servle(DispatchServlet)实现; Filter在容器启动之后即初始化, 服务器停止以后销毁,晚于servlet; servlet则是在调用时初始化,咸鱼Filter调用,服务停止后销毁

3. 性能方面

   struts2是类级别的拦截,每次请求对应实例一个新的Action,需要加载所有的属性值注入,springmvc实现了零配置,由于springmvc基于方法的拦截,有加载一次单例模式bean注入,所以,springmvc开发效率和性能高于struts2

4. 配置方面

   springmvc和spring是无缝的,从整个项目的管理和安全上也比struts2高

### 如何避免sql注入?

- PreparedStatement(简单又有效的方法)
- 使用正则表达式过滤传入的参数
- 字符串过滤
- JSP中调用该函数检查是否包含非法字符
- JSP页面判断代码

### 什么是XSS攻击,如何避免?

XSS攻击又称CSS,全称Cross Site Scrip(跨站脚本攻击),其原理式攻击者向有XSS漏洞的网站中输入恶意的html代码,当用户浏览该网站时,这段html代码会自动执行,从而达到攻击的目的; XSS攻击类似于sql注入攻击,sql注入攻击中以sql语句作为用户输入,从而达到查询/修改/删除数据的目的,而在XSS攻击中,通过插入恶意脚本,实现对用户浏览器的控制,获取用户的一些信息; XSS时web程序中常见的漏洞,XSS属于被动式且用于客户端的攻击方式

XSS防范的总体思路是: 对输入(和URL参数)进行过滤,对输出进行编码

### 什么是CSRF攻击,如何比避免?

CSRF(Cross-site request forgery)也称为one-click attack或者session riding,中文名叫跨站请求伪造; 一般来说,攻击者通过伪造用户的浏览器的请求,向访问一个用户自己曾经认证访问过的网站发出请求,是目标网站接收并误以为是用户的真实操作而去执行命令; 常用于盗取账号,转账,发送虚假消息等; 攻击者利用网站对请求的验证漏洞而实现这样的攻击行为,网站能够确认请求来源于用户的浏览器,却不能验证请求是否源于用户的真实意愿下的操作行为

如何避免:

1. 验证http referer字段

   http头中的referer字段记录了该http请求的来源地址了在通常情况下,访问一个安全受限页面的请求来自于用一个网站,而如果黑客要对其实施CSRF攻击,它一般只能在他自己的网站构造请求,因此,可以通过验证referer值来预防CSRF攻击

2. 使用验证码

   关键操作页面上加上验证码,后台收到请求后通过判断验证码可以防御CSFR; 但这种方式对用户不太友好

3. 在请求地址中添加token并验证

   CSRF攻击之所以能成功,是因为黑客可以完成伪造用户的请求,该请求i中所有的用户验证信息都是存在于cookie中,因此黑客可以在不知道这些验证信息的情况个下直接利用用户自己的cookie来通过安全验证; 要抵御CSRF,关键在于在请求中放入黑客不能伪造的信息,并且该信息不存在于cookie之中; 可以在http请求中以参数的形式加入一个随机产生的token,并在服务器端建立一个拦截器来验证这个token,如果请求中没有token或者token内容不正确,则认为可能是CSRF攻击而拒绝该请求; 这种方式要比检查referer要安全一些,token可以在用户登入后产生并存放在session中,然后每次请求时吧token从session中取出,与请求中的token进行比对,但这种方法的难点在于如何把token以参数的形式加入到请求中;

4. 在http头中自定义属性并验证

   这种方法也时使用token并进行验证,和商议中方法不同的是,这里并不是把token以参数的形式至于http请求之中,而是把它 放到http头中自定义的属性里,通过XMLHttpRequest这个类,可以一次性给所有该类请求加上csrftoken这个http头属性,并把toke值放入其中,这样解决了上中方式在请求中加入token的不便,同时,通过XMLHttpRequest请求的地址不会被记录到浏览器的地址栏,也不用担心token会透过referer泄露到其他网站中去

## 异常

https://mp.weixin.qq.com/s/CHq5BcH9AtdV0emCQ5naLw

### throw和throws的区别

throws是用来声明一个方法可能抛出的所有异常信息,throws是将异常声明但是不处理,而实将异常往上抛,谁调用我就交给谁处理

throw则是排除的一个具体的异常类型

```java
public void a() throws Exception {  
    throw new Exception("aaa");
}
```

### final,finally,finalize有什么区别

- final

  final可以修饰类,变量和方法,修饰类表示该类不能被继承,修饰方法表示该方法不能被重写,修饰变量表示该变量是一个常量不能被重新赋值

- finally

  finally一般作用在try-catch代码块中,在处理异常的时候,通常我们将一定要执行的代码放在finally代码块中,表示不管是否出现异常,该代码块都会执行,一般用来存放一些关闭资源的代码

- finalize

  finalize是一个属于Object类的方法,该方法一般由垃圾回收器来调用,当我们调用System的gc()方法的时候,由垃圾回收期调用finalize()方法,回收垃圾

### try-catch-finally中哪个部分可以省略

catch可以省略

更为严格的说法其实是: try只适合处理运行时异常,try+catch适合处理运行时异常+普通异常; 也就是说,如果你只用try去处理普通异常却不加以catch处理,编译是通不过的,因为编译器硬性规定,普通异常如果选择捕获,则必须用catch显示声明以便进一步处理,而运行时异常在编译时没有如此规定,所以catch可以省略,你加上catch编译器也觉得无可厚非

理论上,编译器看任何代码都不顺眼,都觉得可能有潜在的问题,所以你即使对所有代码加上try,代码在运行时期也只不过是在正常运行的基础上加一层皮,但是你一旦对一段代码加上try,就等于显示的承诺编译器,对这段代码可以能抛出的异常进行捕获而非向上抛出处理; 如果是普通异常,编译器要求必须用catch捕获以便进一步处理; 如果运行时异常,捕获然后丢弃并且加上finally扫尾处理,或加上catch捕获以便进一步处理

至于加上finally,则是在不管有没有捕获异常,都要进行的扫尾处理

### try-catch-finally中,如果 catch中return了,finally还会执行吗?

会执行,在return前执行

### 常见的异常类有哪些?

- NullPointerException: 空指针异常
- SQLEXception: 数据库异常
- IndexOutOfBoundException: 数组越界异常
- NumberFormatException: 将字符串格式化转为数字时发生的异常
- FileNotFoundException: 打开指定路径名但是文件找不到时抛出的异常
- IOException: IO异常,此类是失败或中断的IO操作生成的异常的通用类
- ClassCastException: 将对象强转为不是实例的子类时抛出的异常
- ArrayStoreException: 试图将错误类型的对象存储到一个对象数据时抛出的异常
- IllegalArgumentException: 向方法传递了一个不合法或不正确的参数抛出的异常
- ArithmeticException: 运算异常,若除以0
- NegativeArraySizeException: 如果应用程序试图大小为负的数组时抛出该异常
- NoSuchMethodException: 无法找到某一特定方法时,抛出该异常
- UnsupportedOperationException: 当不支持请求的操作时,抛出该异常
- RuntimeException: 那些可能在java虚拟机正常运行期间抛出的异常的超类

## 网络

https://mp.weixin.qq.com/s/F201iO7TQNkZz8yAh3PILg

### http响应码301和302代表的是什么?有什么区别

301和302都是http状态的编码,都代表者某个url发生了转移

区别

- 301: 表示永久性转移
- 302: 表示暂时性转移

### forward和redirect的区别

Forward:

直接转发,客户端和浏览器只发出一次请求,Servlet,html,jsp或其他信息资源,由第二个信息资源相应请求,在请求对象request中,保存的对象对于每个信息资源是共享

Redirct:

间接转发,实际是两次http请求,服务器端在响应第一次请求的时候,让浏览器再向另外一个url发出请求,从而达到转发的目的

### 简述tcp和udp的区别

- tcp面向连接(如打电话要先拨号建立连接); udp是无连接的,即发送数据之前不需要建立连接
- tcp提供可靠的服务,也就是说,通过tcp连接传送的数据,无差错,不丢失,不重复,且按需到达; udp尽最大努力交付,即不保证可靠交付
- tcp通过校验和,重传控制,序号标识,滑动窗口,确认应答实现可靠传输,如丢包时的重发控制,还可以对次序乱掉的分包进行顺序控制
- udp具有较好的实时性,工作效率比tcp高,适用于对高速传输和实时性有较高的通信或广播通信
- 每一条tcp连接只能时点到点; udp支持一对一,一对多,多对一和多对多的交互通信
- tcp对系统资源要求较多, udp对系统资源要求较少

### tcp为什么要三次握手,两次不行吗?为什么?

为了实现可靠数据传输,tcp协议的通信双发,都必须维护一个序列号,以标识发送出去的数据包中国,那些时已经被对方收到的; 三次握手的过程即使通信双方相互告知序列号起始值,并确认对方已经收到了序列号起始值的必经步骤

如果只是两次握手,至多只有连接发起方的起始序列号能被确认,另一方选择的序列号则得不到确认

### 说一下tcp粘包是怎么产生的?

1. 发送法产生粘包

   采用tcp协议传输数据的客户端与服务器经常时保持一个长连接的状态(一次连接发生一次数据不存在粘包),双方在连接不断开的情况下,可以一直传输数据,但当发生的数据包过于的小时,那么tcp协议默认的会启动Nagle算法,将这些较小的数据包继续合并发送(缓冲区数据发送是一个堆压的过程); 这个合并过程就是在发送缓冲区中进行的,也就是说数据发送出来它已经是粘包的状态了

   ![img](.img/.Interview%E5%87%86%E5%A4%87/640-1569930885829.webp)

2. 接收方产生粘包

   接收方采用tcp协议接收数据时的过程是这样的: 数据到达接收方,从网络模型的下方传递至传输层,传输层的tcp协议处理时将其放置接收缓冲区,然后由应用层来主动获取,这时会痴线一个问题,就是我们在程序中调用的读取数据函数不能及时的把缓冲区中的数据拿出来,而下一个数据又到来并有一部分放入到缓冲区末尾,等我们读取数据时就是一个粘包(放数据的速度>应用层拿数据的速度)

   ![img](.img/.Interview%E5%87%86%E5%A4%87/640-1569931090151.webp)

### OSI的七层模型都有哪些?

1. 应用层: 网络服务与最终用户的一个接口
2. 表示层: 数据的表示,安全,压缩
3. 会话层: 建立,管理,终止会话
4. 传输层: 定义传输数据的协议端口号,以及流控和差错校验
5. 网络层: 进行逻辑地址寻址,实现不同网络之间的路径选择
6. 数据链路层: 建立逻辑连接,进行硬件地址寻址,差错校验等功能
7. 物理层: 建立,维护,断开物理连接

### get和post请求有哪些区别

- get在浏览器回退时是无害的,而post会再次提交请求
- get产生的url地址可以被bookmark,而post不可以
- get请求会被浏览器主动cache,而post不会
- get请求只能进行url编码,而post支持多种编码方式
- get请求参数会显示在url连接上,而post不会
- get请求在url中传送的参数是有长度限制的,而post没有
- 对参数的数据类型,get只接收ASCII字符,而没有限制
- get参数通过url传递,而post放在Request body中

### 如何实现跨域?

1. 使用JSONP跨域

   JSONP(JSON with Padding)是数据格式JSON的一种"使用模式",可以让网页从别的网域奥数据; 根据XmlHttpRequest对象收到同源策略的影响,而利用`<script>`元素的这个开放策略,网页可以得到从其他来源动态产生的json数据,而这种使用模式就是所谓的JSONP; 用JSONP抓到的数据并不是json,而是任意的JavaScript,用JavaScript解释器运行而不是用json解析器解析; 所以,通过chrome查看所有JSONP发送的get请求都是js类型,而非XHR

   缺点:

   - 只能使用get请求
   - 不能注册success,error等事件监听函数,不能很容易的确定JSONP请求是否失败
   - JSONP是从其他域中加载代码执行,容易收到跨站请求伪造的攻击,其安全性无法保证

2. CORS

   Cross-Origin Resource Sharing,跨域资源共享是一份浏览器技术的规范,提供了web服务从不同域传来沙盒脚本的方法,以避开浏览器的同源策略,确保安全的跨域数据传输; 现在浏览器使用CORS在API容器如XMLHttpRequest来减少Http请求的风险来源; 与JSONP不同,CORS处理get请求还支持其他http请求; 服务器一般需要增加如下响应头的一种或几种:

   ```java
   Access-Control-Allow-Origin: *
   Access-Control-Allow-Methods: POST, GET, OPTIONS
   Access-Control-Allow-Headers: X-PINGOTHER, Content-Type
   Access-Control-Max-Age: 86400
   ```

   跨域请求默认不会携带cookie信息,如需携带,要配置如下参数

   ```js
   "Access-Control-Allow-Credentials": true
   // Ajax设置
   "withCredentials": true
   ```

3. window.name+iframe

   window.name通过在iframe(一般动态创建)中加载跨域html文件来起作用,然后html文件将传递给请求者的字符串内容赋值给window.name,然后请求者可以检索window.name值作为响应

   - iframe标签的跨域能力
   - window.name属性值在文档刷新后依旧存在的能力(且最大允许2M左右)

   每个iframe都有包括它的window,而这个window是top window的子窗口,contentWindow属性返回`<iframe>`元素的window对象,你可以使用这个window对象来访问iframe的文档及其内部dom

4. webSocket

   webSocket protocol是html5一种新的协议,它实现了浏览器与服务器全双工通信,同时允许跨域通信,是server push技术的一种很棒的实现,相关文章,请查看: WebSocket、WebSocket-SockJS

5. 使用代理

   同源策略是针对浏览器端进行的限制,可以通过服务器端来解决该问题

   DomainA客户端(浏览器) ==> DomainA服务器 ==> DomainB服务器 ==> DomainA客户端(浏览器)

### 说一下JSONP实现原理

jsonp即json+padding,动态创建script标签,利用script标签的src属性可以获取任何域下的js脚本,通过这个特性(也可以说是漏洞),服务器端不再返回json格式,而实返回一段调用某个函数的js代码,在src中进行了调用,这样实现的跨域

## 设计模式

https://mp.weixin.qq.com/s/Wahq4TnCm4Pzb6VshWma1Q

### 单例模式

简单点说,就是一个应用程序中,某个类的实例对象只有一个,你没有办法去new,因为构造器是被private修饰的,一般通过getInstance()方法来获取他们的实例

getInstance()的返回值是一个对象的引用,并不是一个新的实例,所以医药错误的理解成多个对象,单例模式实现起来也很容易

线程安全(双重校验锁)-懒汉式

```java
//线程安全(双重校验锁)
public class Singleton2 {
    public static volatile Singleton2 singleton2;
    private Singleton2 (){
    }
    public static Singleton2 getInstance(){
        if(singleton2==null){
            synchronized (Singleton2.class){
                if(singleton2==null){
                    singleton2=new Singleton2();
                }
            }
        }
        return singleton2;
    }
}
```

饿汉式

```java
public class Singleton {  
   private static Singleton instance = new Singleton();  
   private Singleton (){}  
   public static Singleton getInstance() {  
   		return instance;  
   }  
}
```

### 观察者模式

对象间一对多的依赖关系,当一个对象的状态发生变化时,所有依赖于它的对象都得到通知并被自动更新

![img](.img/.Interview%E5%87%86%E5%A4%87/640-1569937412136.webp)

举个例子: 假设有三个人,小美(女,22),小王和小李,小美很漂亮,小王和小李是两个程序员,时刻关注着小美的一举一动; 有一天,小美说了一句:"谁来陪我打游戏啊?",这句话被小王和小李听到了,乐坏了,噌噌噌,没一会儿,小王就冲到小美家门口了,在这里,小美是被观察者,小王和小李是观察者,被观察者发出一条信息,然后观察者们进行相应的处理,接下来是代码:

```java
public interface Person {
   //小王和小李通过这个接口可以接收到小美发过来的消息
   void getMessage(String s);
}
```

这个接口相当于小王和小李的电话号码,小美发送通知的时候就会调用getMessage方法,拨打了小王和小李的电话

下面是小王和小李的代码:

```java
public class LaoWang implements Person {
   private String name = "小王";
   @Override
   public void getMessage(String s) {
       System.out.println(name + "接到了小美打过来的电话，电话内容是：" + s);
   }
}

public class LaoLi implements Person {
   private String name = "小李";
   @Override
   public void getMessage(String s) {
       System.out.println(name + "接到了小美打过来的电话，电话内容是：->" + s);
   }
}
```

小美的代码:

```java
public class XiaoMei {
   	List<Person> list = new ArrayList<Person>();
	
    //小美会先调用addPerson将小王和小李加入到list中
    //即小美会将小王和小李的电话存在通讯录中
    public void addPerson(Person person){
        list.add(person);
    }

    //遍历list，把自己的通知发送给所有暗恋自己的人
    //即小美遍历通讯录,给通讯录中的每个人都打了一个电话
    public void notifyPerson() {
        for(Person person:list){
            person.getMessage("你们过来吧，谁先过来谁就能陪我一起玩儿游戏!");
        }
    }
}
```

测试类:

```java
public class Test {
   public static void main(String[] args) {
       XiaoMei xiao_mei = new XiaoMei();
       LaoWang lao_wang = new LaoWang();
       LaoLi lao_li = new LaoLi();

       //小王和小李在小美那里都注册了一下
       //即保存电话号码到通讯录中
       xiao_mei.addPerson(lao_wang);
       xiao_mei.addPerson(lao_li);

       //小美向小王和小李发送通知
       xiao_mei.notifyPerson();
   }
}
```

### 装饰者模式

对已有的业务逻辑进一步的封装,使其增加额外的功能,如java中的io流就是使用了装饰者模式,用户在使用的使用,可以任意组装,达到自己想要的效果; 举个例子,我想吃三明治.首先我需要一根大大的香肠,然后在香肠上加一点奶油,再方一点蔬菜,最后再用两片面包加一下,就做完了一个三明治,接下来使制作三明治的代码:

```java
public class Food {
   private String food_name;
   public Food(String food_name) {
       this.food_name = food_name;
   }
   public String make() {
       return food_name;
   };
}
```

创建子类继承food

```java
//面包类
public class Bread extends Food {
   private Food basic_food;
   public Bread(Food basic_food) {
       this.basic_food = basic_food;
   }
   public String make() {
       return basic_food.make()+"+面包";
   }
}

//奶油类
public class Cream extends Food {
   private Food basic_food;
   public Cream(Food basic_food) {
       this.basic_food = basic_food;
   }
   public String make() {
       return basic_food.make()+"+奶油";
   }
}

//蔬菜类
public class Vegetable extends Food {
   private Food basic_food;
   public Vegetable(Food basic_food) {
       this.basic_food = basic_food;
   }
   public String make() {
       return basic_food.make()+"+蔬菜";
   }
}
```

这几个子类都差不多,构造方法中传入一个Food类型的参数(此处用到了多态),然后在make方法中加入一些自己的逻辑

测试类:

```java
public class Test {
   public static void main(String[] args) {
       //面包夹着蔬菜,蔬菜夹着奶油,奶油夹着香肠
       Food food = new Bread(new Vegetable(new Cream(new Food("香肠"))));
       System.out.println(food.make());
   }
}
```

> 运行结果: 香肠+奶油+蔬菜+面包

### 适配器模式

将两种完全不同的事物联系到一起,就像现实生活中的变压器; 假设一个手机充电器需要的电压是5v,但是正常的电压是220V,这时候就需要一个变压器,将220V的电压转化为5V的电压,这样,变压器就将5V的电压和手机联系在一起了

```java
// 变压器
class VoltageAdapter {
   	Phone phone;
    VoltageAdapter(Phone phone){
        this.phone=phone;
    }
    public void charge(){
    	return this.phone.charge-205;//得到5V电压
    }
}

// 手机类
class Phone {
   public static final int V = 220;// 正常电压220v，是一个常量
   // 充电
   public int charge() {
       return V;
   }
}
```

测试类:

```java
public class Test {
   public static void main(String[] args) {
       Phone phone = new Phone();
       VoltageAdapter adapter = new VoltageAdapter(phone);
       adapter.charge();//返回5V的电压
       //如果是phone.charge()则返回220V电压,做了适配后就能返回5V
   }
}
```

### 工厂模式

#### 简单工厂模式:

一个抽象的接口,多个抽象接口的实现类,一个工厂类,用来实例化抽象类的接口

```java
// 抽象产品类
abstract class Car {
   public void run();
   public void stop();
}
```

```java
// 多个具体的实现类
class Benz implements Car {
   public void run() {
       System.out.println("Benz开始启动了。。。。。");
   }
   public void stop() {
       System.out.println("Benz停车了。。。。。");
   }
}

class Ford implements Car {
   public void run() {
       System.out.println("Ford开始启动了。。。");
   }
   public void stop() {
       System.out.println("Ford停车了。。。。");
   }
}
```

```java
// 工厂类
class Factory {
   public static Car getCarInstance(String type) {
       Car c = null;
       if ("Benz".equals(type)) {
           c = new Benz();
       }
       if ("Ford".equals(type)) {
           c = new Ford();
       }
       return c;
   }
}
```

```java
//测试类
public class Test {
   public static void main(String[] args) {
       Car c = Factory.getCarInstance("Benz");
       if (c != null) {
           c.run();
           c.stop();
       } else {
           System.out.println("造不了这种汽车。。。");
       }
   }
}
```

> 普通工厂的缺陷是: 我们需要在工厂类中手动的判断传入的参数对应的是哪个类,那么当我们在新增加一种汽车类别时,我们就需要去修改工厂类中的代码,添加上对应的判断,这样就不易于维护,耦合度高

#### 工厂方法模式

有四个角色,抽象工厂模式,具体工厂模式,抽象产品模式,具体产品模式

不再是有一个工厂类去实例化具体的产品,而实有抽象工厂的子类去实例化产品

```java
// 抽象产品角色
public interface Moveable {
   void run();
}
```

```java
// 具体产品角色
public class Plane implements Moveable {
   @Override
   public void run() {
       System.out.println("plane....");
   }
}

public class Broom implements Moveable {
   @Override
   public void run() {
       System.out.println("broom.....");
   }
}
```

```java
// 抽象工厂
public abstract class VehicleFactory {
   abstract Moveable create();
}
```

```java
// 具体工厂
public class PlaneFactory extends VehicleFactory {
   public Moveable create() {
       return new Plane();
   }
}

public class BroomFactory extends VehicleFactory {
   public Moveable create() {
       return new Broom();
   }
}
```

```java
// 测试类
public class Test {
   public static void main(String[] args) {
       VehicleFactory factory = new BroomFactory();
       Moveable m = factory.create();
       m.run();
   }
}
```



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