[TOC]

# 安装java

1. 下载jdk并安装,选择Window64位系统

   [下载地址](http://www.oracle.com/technetwork/java/javase/downloads/index.html)

2. 配置环境变量

   在环境变量下添加以下内容

   - 变量名: JAVA_HOME

     变量值: `C:\Program Files (x86)\Java\jdk1.8.0_91`

   - 变量名: CLASSPATH

     变量值: `.;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar;`

   - 变量名: Path

     变量值: `%JAVA_HOME%\bin;%JAVA_HOME%\jre\bin;`

     > 追加此值

3. 验证是否安装成功

   1. 打开cmd
   2. 输入`java-version`,`java`,`javac`,如果都没问题,说明环境变量配置成功

# 基础语法

## 基本数据类型

Java总共提供了8种基本数据类型: 

- 6种数字类型(4个整数型,2个浮点型)
  - 整数型
    - byte
    - short
    - int
    - long
  - 浮点型
    - float
    - double
- 1种字符类型
  - char
- 1种布尔类型
  - boolean

### byte

空间占用8个bit,有符号的,以二进制补码表示整数

最小值是-128(-2^7)

最大值是127(2^7-1)

默认值是0

byte类型用在大型数组中节约空间,主要代替整数,因为byte变量占用的空间只有int类型的四分之一

例子: byte a=100;

### short

空间占用16个bit,有符号的以二进制补码表示的整数

最小值是-32768(-2^15)

最大值是32767(2^15-1)

默认值是0

short类型也可以像byte一样节省空间,一个short变量占用的空间是int的二分之一

例子: short a=1000;

### int

空间占用32个bit,有符号的以二进制补码表示的整数

最小值是-2147483648(-2^31)

最大值是2147483647(2^31-1)

默认值是0

一般的整型变量默认是int类型

例子: int a=1000000;

### long

空间占用64个bit,有符号的以二进制补码表示的整数

最小值是-9223372036854775808(-2^63)

最大值是9223372036854775807(2^63-1)

默认值是0

例子: long a=1000000000000000L;

### float

空间占用32个bit,单精度浮点数

在存储大型浮点数组的时候可以节省内存空间

默认值是0.0f

float类型不能用来表示精确的值

例子: float a=234.5f;(f指明其为float,而不是double类型)

### double

空间占用64个bit,双精度浮点数

浮点数的默认类型为double类型

double类型不能用来表示精确的值

默认值是0.0d

例子: double a=123.4;(d可以省略不写)

### char

空间占用16个bit,是一个单一的16位Unicode字符

最小值是'\u0000'(即为0)

最大值是'\uffff'(即为65535)

char数据类型可以存储任何字符

例子: char a='A';

### boolean

空间占用1个bit,表示一位的信息

只有两个取值: true/false

默认值是false(即为bit那一位是0)

例子: boolean a=true;

## 包装类数据类型

### Number(数字类型)

所有的包装类（Integer、Long、Byte、Double、Float、Short）都是抽象类Number的子类。

![img](../jdk/.img/.java%E5%9F%BA%E7%A1%80/1459506097805010.jpg)

- 整数型
  - Byte
  - Short
  - Integer
  - Long
- 浮点型
  - Float
  - Double

### Character(字符类型)

是char基本数据类型的包装类

### Boolean(布尔类型)

是boolean基本数据类型的包装类

### String(特殊的String类型)

#### String

##### String的基本内容

在java中,String数据类型属于对象,java提供了String类来创建和操作字符串

String类的源码

```java
public final class String
    implements java.io.Serializable, Comparable<String>, CharSequence
{
    /** The value is used for character storage. */
    private final char value[];

    /** The offset is the first index of the storage that is used. */
    private final int offset;

    /** The count is the number of characters in the String. */
    private final int count;

    /** Cache the hash code for the string */
    private int hash; // Default to 0

    /** use serialVersionUID from JDK 1.0.2 for interoperability */
    private static final long serialVersionUID = -6849794470754667710L;

    ........
}
```

从上面可以看出:

1. String类是final类,也就意味着String类不能被继承,并且它的成员方法都默认为final方法(即不能被重写);
2. String类其实是通过char数组来保存字符串的



接下来在看String类的一些方法实现:

```java
public String substring(int beginIndex, int endIndex) {
    if (beginIndex < 0) {
        throw new StringIndexOutOfBoundsException(beginIndex);
    }
    if (endIndex > count) {
        throw new StringIndexOutOfBoundsException(endIndex);
    }
    if (beginIndex > endIndex) {
        throw new StringIndexOutOfBoundsException(endIndex - beginIndex);
    }
    return ((beginIndex == 0) && (endIndex == count)) ? this :
        new String(offset + beginIndex, endIndex - beginIndex, value);
}

public String concat(String str) {
    int otherLen = str.length();
    if (otherLen == 0) {
        return this;
    }
    char buf[] = new char[count + otherLen];
    getChars(0, count, buf, 0);
    str.getChars(0, otherLen, buf, count);
    return new String(0, count + otherLen, buf);
}
```

从上面的两个方法可以看出,无论是substring还是concat操作都不是在原有的字符串上进行的,而实重新生成了一个新的字符串对象,也就是说进行这些操作后,最原始的字符串并没有被改变;

重要的一点: String对象一旦被创建就是固定不变的了,对String对象的任何改变都不会影响到原对象,相关的任何修改操作都会生成新的对象

##### 字符串常量池

我们知道字符串的分配和其他对象分配一样,是需要消耗时间和空间的,而且字符串我们使用的非常多,所以JVM为了提高性能和减少内存的开销,在实例化字符串的时候进行了一些优化: 使用字符串常量池

每当我们创建字符串常量时,JVM会首先检查字符串常量池,如果该字符串已经存在常量池中,那么就直接返回常量池中的实例引用; 如果字符串不存在常量池中,就会实例化该字符串并且将其放到常量池中; 由于String字符串的不可变性,我们可以十分肯定常量池中一定不存在两个相同的字符串

java中的常量池,实例上分为两种型态: 静态常量池和运行时常量池

- 静态常量池: 即*.class文件中的常量池,class文件中的常量池不仅仅包含字符串等字面量,还包含类,方法等静态信息,占用class文件绝大部分空间
- 运行时常量池: 是jvm虚拟机在完成类装载操作后,将class文件中的常量池载入到内存中,并保存在方法区中

> 我们常说的常量池就是指方法区中的运行时常量池

下面来看代码

```java
String a = "chenssy";
String b = "chenssy";
```

> a、b和字面上的chenssy都是指向JVM字符串常量池中的"chenssy"对象，他们指向同一个对象

```java
String c = new String("chenssy");
```

> new关键字一定会产生一个对象chenssy(注意这个chenssy和上面的chenssy不同),同时这个对象是存储在堆中的,所以上面应该产生了两个对象: 保存在栈中的c和保存在堆中的chenssy,但是在java根本就不存在两个完全一摸一样的字符串对象,故堆中的chenssy应该是引用字符串常量池中的chenssy; 

具体的关系图如下:

![img](../jdk/.img/.java%E5%9F%BA%E7%A1%80/249993-20161107151613077-1171623003.png)

总结:

- a,b,c,chenssy是不同的对象
- String c = new String("chenssy"); 虽然c的内容是创建在堆中,但是它的内部value还是指向JVM常量池的chenssy的value,它构造chenssy时所用的参数依然时chenssy字符串常量

#### StringBuilder和StringBuffer

和String类不同的时,StringBuilder和StringBuffer类的对象能够被多次修改,并且不产生新的对象

StringBuffer是线程安全的,StringBuilder是非线程安全的,而StringBuilder性能较好

## 修饰符

### 访问控制修饰符

在java中,可以使用访问控制符来保护对类,变量,方法和构造方法的访问,java支持4中不同的访问权限:

- default
- private
- public
- protected

> 接口里的变量都隐式声明都public static final的,而接口里的方法默认情况下访问权限为public

#### default

默认访问修饰符,该关键字为默认控制修饰符,可省略

使用默认访问修饰符声明的变量和方法,对同一个包内的类是可见的

#### private

私有访问修饰符,这个最严格的访问级别,被private声明的方法,变量和构造方法只能被所属类访问(接口里内容不能声明为private)

声明为private的变量只能通过类中公共的getter和setter方法被外部类所访问

#### public

公有访问修饰符,被声明为public的类,方法,构造函数能够被任何其他类访问

如果几个相互访问的public类分布在不同的包中,则需要导入相应的public类所在的包; 由于类的继承性,类所有的公有方法和变量都能被子类继承

java程序中的main()方法必须设置成公有的,否则,hava解释器将不能运行该类

#### protected

受保护的访问修饰符,被声明protected的变量,方法和构造器能被同一个包中的任何其他类访问,也能够被不同包中的子类访问

protected不能修饰类和接口,可以修饰类中的方法和成员变量,但是不能修饰接口中的成员变量和方法

子类能访问protected修饰的方法和变量,这样就能保护不相关的类使用这些方法和变量

#### 注意事项

- 父类中声明为public的方法在子类中也必须为public
- 父类中声明为protected的方法在子类中要么声明为protected,要么声明为public,不能声明为private
- 父类中声明为private的方法,不能够被继承

> 即子类继承父类后,如果要重写方法,那么方法的访问控制范围必须要大于或等于父类方法的控制访问方位

### 非访问控制修饰符

为了实现一些其他的功能,java也提供了许多非访问修饰符,如:

- static
- final
- abstract
- synchronized和volatile

#### static

- 静态变量

  static关键字声明的变量称为静态变量,无论一个类实例化多少变量,它的静态变量只有一份; 静态变量也被称为类变量,局部变量不能被声明为static

- 静态方法

  static关键字声明的方法被称为静态方法,静态方法不能使用类的非静态变量

#### final

- final变量

  被final修饰的基本变量类型必须要初始化,初始化后的值就不能被修改了(但是被final声明的对象,对象里面的值是可以修改的)

  final修饰符通常和static修饰符一起使用来创建类常量

  被final修饰的变量可以被子类继承,但是不能被修改

- final方法

  被final修饰的方法可以被子类继承,但是不能被子类重写

  声明final方法的主要目的就是防止该方法的内容被修改

- final类

  被final修饰的类不能被继承

#### abstract

- 抽象类

  被abstract修饰的类被称为抽象类,抽象类不能被实例化,声明为抽象类的唯一目的就是为了将来对该类进行扩充

  一个类不能同时被abstract和final修饰,如果一个类包含抽象方法,那么该类一定要被声明为抽象类

  抽象类可以包含抽象方法和非抽象方法

- 抽象方法

  被abstract修饰的方法被称为抽象方法,抽象方法是一种没有任何实现的方法,该方法的具体实现由子类提供,抽象方法不能被声明为final和static

  任何继承抽象类的子类必须实现父类的所有抽象方法,除非该子类也是抽象类

#### synchronized

被synchronized修饰的方法同一时间只能被一个线程访问

#### volatile

被volatile修饰的成员变量在每次被线程访问时,都强制从共享内存中重读该成员变量的值,并且,当成员变量发生变化时,强制线程将变化值会写到共享内存,这样在任何时刻,两个不同的线程读取到这个变量的值都是一样的(即可以这样理解:被volatile修饰的变量,相当于是不同线程的全局变量)

## 数组

数组对于每一门编程语言来说都是重要的数据结构之一

java语言中提供的数组是用来存储固定大小的同类型元素

你可以声明一个数组变量,如`int[] arr=new int[100];`,声明数组必须要指定数组的大小,只有指定了大小,虚拟机在知道要分配多大的内存空间

> 因为数组所占用的内存空间是连续的,如果是int数组,大小为100,则虚拟机就会找到一个连续的内存空间,大小为32*100bit(即400byte,400个字节,0.4KB大小的空间),如果不存在这样的连续内存空间,那么数组则会创建失败,所以在声明数组必须要指定大小

java提供了java.util.Arrays类能方便地操作数组，它提供的所有方法都是静态的,它可以对数据进行排序,二分查找等

## 异常

### Exception类的层次

所有的异常类是从java.lang.Exception类继承的子类。

Exception类是Throwable类的子类。除了Exception类外，Throwable还有一个子类Error 。

Java程序通常不捕获错误。错误一般发生在严重故障时，它们在Java程序处理的范畴之外。

Error用来指示运行时环境发生的错误。

异常类有两个主要的子类：IOException类和RuntimeException类。

![img](../jdk/.img/.java%E5%9F%BA%E7%A1%80/1459506445622784.jpg)

### 捕获异常

使用try和catch关键字可以捕获异常

catch语句包含要捕获异常类型的声明,当保护代码块中发生一个异常时.try后面的catch就会被检查,如果发生的异常包含在catch块中,一号仓会被传递到该catch块,进行对应的处理

### throws/throw关键字

如果一个方法没有捕获一个检查性异常,那么该方法必须要使用throws关键字来声明,throws关键字放在方法签名的尾部

也可以使用throw关键字抛出一个异常,无论它是新实例化的还是刚捕获到的

一个方法可以声明排除多个异常,多个异常之间用逗号隔开

### finally关键字

finally关键字用来创建在try代码块后面执行的代码

无论是否发生异常,finally代码块中的代码总会被执行

在finally代码块中,可以运行清理类型等等收尾善后性质的代码

如果有return,finally的代码也会在return之前被执行

注意事项:

- catch布恩那个独立于try存在
- 在try/catch后面添加finally并不是强制的
- try代码后面不能既没有catch块也没有finally块

### 声明自定义异常

在java中你可以自定义字长,编写自己的异常类时需要记住下面几点

- 所有异常都必须时Throwable的子类
- 如果希望写一个检查性异常类,则需要继承Exception类
- 如果想写一个运行时异常类,则需要继承RuntimeException类

## 类和对象

### 类

- class关键字: 定义一个类
- import关键字: 导入相关的包; 包主要用来对类和接口进行分类;

- 成员变量: 定义在方法体之外,类中的变量,成员变量可以被类中的方法,构造方法访问

- 类变量: 使用static进行声明,可以类名.变量名即可访问,多个类实例共享一个类变量

- 成员方法: 函数

- 构造方法: 每个类都有构造方法,在实例化类时必须要调用类的构造方法才能进行实例化; 如果没有显示的为类定义构造方法,java编译器将会为该类提供一个默认的构造方法,用于该类的实例化;

  在创建一个对象的时候,至少要调用一个构造方法;

  构造方法的名称必须与类名相同,一个类可以有多个不同参数的构造方法(即允许重载)

定义一个类

```java
import java.util.*; //import关键字
//class关键字
//public关键字
public class Dog{
    public static int a=1;//类变量
    String breed;//成员变量
    void barking(){//成员方法
    }
    //构造方法
	Dog(){
    }
}
```

### 对象

- 创建对象

  ```java
  Dog dog=new Dog();
  ```

# 面向对象

## 继承

继承是java面向对象编程技术的一块基石,因为它允许创建分等级层次的类; 继承可以理解为一个对象从另一个对象获取属性的过程

如果类A是类B的父类,而类B是类C的父类,我们也成类A是类C的父类,类C是从类A继承而来; 在java中,类只能单一继承,一个子类只能拥有一个父类

继承中最常使用的两个关键字是`extends`和`implements`

这两个关键字的使用决定了一个对象和另一个对象的归属(IS-A,即是一个)关系

通过使用这两个关键字,我们能实现一个对喜爱那个获取另一个对象的属性

所有java的类均由java.lang.Object类继承而来的,所有Object是所有类的祖先类,而除了Object外,所有类必须只有一个父类

### IS-A关系

IS-A关系就是说: 一个对象是另一个对象的一个分类

#### extends关键字

示例

```java
public class Animal{}
public class Mammal extends Animal{}
public class Reptile extends Animal{}
public class Dog extends Mammal{}
```

基于上面的例子,则

- Animal类是Mammal类的父类。
- Animal类是Reptile类的父类。
- Mammal类和Reptile类是Animal类的子类。
- Dog类既是Mammal类的子类又是Animal类的子类。

分析以上示例中的IS-A关系，如下：

- Mammal IS-A Animal
- Reptile IS-A Animal
- Dog IS-A Mammal

因此 : Dog IS-A Animal

通过使用关键字**extends**，子类可以继承父类的除private属性外所有的属性

我们通过使用instanceof 操作符，能够确定Mammal IS-A Animal

#### implements关键字

implements关键字使用在类继承接口的情况下

```java
public interface Animal {}
public class Mammal implements Animal{}
public class Dog extends Mammal{}
```

> 其状态和上述`extends`的情况是一样的

## 重写和重载

### 重写(Override)

重写是子类对父类的允许访问的方法的实现过程进行重新编写,返回值和形参都不能改变,但是其内部的实现可以做对应的修改

重写的好处在于子类可以根据需要,定义特定于自己的行为,也就是说子类能够根据需要实现父类的方法

```java
class Animal{
   public void move(){
      System.out.println("动物可以移动");
   }
}
class Dog extends Animal{
    //重写父类的move方法
    @Override
   public void move(){
      System.out.println("狗可以跑和走");
   }
}
```

```java
public class TestDog{
   public static void main(String args[]){
      Animal a = new Animal(); // Animal 对象
      Animal b = new Dog(); // Dog 对象
      a.move();// 执行 Animal 类的方法
      b.move();//执行 Dog 类的方法
   }
}
```

> 运行结果:
>
> 动物可以移动
> 狗可以跑和走

在上面的例子中可以看到,尽管b属于Animal类型,但是它运行的是Dog类的move方法

这时由于在编译阶段,只是检查参数的引用类型,然而在运行时,由java虚拟机指定对象的类型并运行该对象的方法

因此在上面的例子中,之所以能够编译成功,是因为Animal类中存在move方法,然而运行时,运行的是特定对象的方法,这就是所谓的多态,之后会讲到

---

方法重写的规则

- 参数列表,返回类型必须完全与被重写方法相同
- 子类重写方法的访问权限必须大于或等于父类方法的访问权限
- 父类的成员方法只能被它的子类重写
- 父类中声明为final的方法不能被重写
- 声明为static的方法不能被重写,但是能够被再次声明(再次声明后就属于子类的静态方法,和父类的已经区分开了)
- 重写的方法不能抛出新的强制性异常,或比被重写方法声明的更广泛的强制性异常
- 构造方法不能被重写

---

super关键字的使用

当需要在子类中调用父类的未被重新写方法时,要使用super关键字

### 重载(Overload)

重载(overload)是在一个类里面,方法名相同,而参数不同的方法,但其返回类型可以相同也可以不相同

每一个重载的方法(或者构造函数)都必须有一个独一无二的参数类型列表

重载规则:

- 被重载的方法必须改变参数列表
- 被重载的方法可以改变返回类型
- 被重载的方法可以改变访问修饰符
- 被重载的方法可以声明新的或更广的异常
- 方法能够在同一个类中或者在一个子类中被重载

### 重写和重载的区别

| 区别点   | 重载方法 | 重写方法                                       |
| :------- | :------- | :--------------------------------------------- |
| 参数列表 | 必须修改 | 一定不能修改                                   |
| 返回类型 | 可以修改 | 一定不能修改                                   |
| 异常     | 可以修改 | 可以减少或删除，一定不能抛出新的或者更广的异常 |
| 访问     | 可以修改 | 一定不能做更严格的限制（可以降低访问限制）     |

## 多态

多态是同一个行为具有多个不同表现形式或者形态的能力

多态性是对象多种表现形式的体现

比如我们说"宠物"这个对象,他就有很多不同的表达或实现,比如由小猫,小狗等等,那么到了宠物店说"请给我一只宠物",服务员给我小猫或者小狗都可以,那么我们就说"宠物"这个对象就具备多态性

```java
public interface Vegetarian{}
public class Animal{}
public class Deer extends Animal implements Vegetarian{}
```

因为Deer类具有多重继承,所以它具有多态性:

- 一个 Deer IS-A（是一个） Animal
- 一个 Deer IS-A（是一个） Vegetarian
- 一个 Deer IS-A（是一个）Object

在java中,所有的对象都具有多态性,因为任何对象都能通过IS-A测试的类型和Object类

---

多态的三个条件

1. 有继承或者实现接口
2. 有重写父类的方法
3. 父类引用指向子类对象

---

```java
class Animal{
   public void move(){
      System.out.println("动物可以移动");
   }
}
class Dog extends Animal{
    //重写父类的move方法
    @Override
   public void move(){
      System.out.println("狗可以跑和走");
   }
}
```

```java
public class TestDog{
   public static void main(String args[]){
      Animal a = new Animal(); // Animal 对象
      Animal b = new Dog(); // Dog 对象
      a.move();// 执行 Animal 类的方法
      b.move();//执行 Dog 类的方法
   }
}
```

> 运行结果:
>
> 动物可以移动
> 狗可以跑和走

在上面的例子中可以看到,尽管b属于Animal类型,但是它运行的是Dog类的move方法

这时由于在编译阶段,只是检查参数的引用类型,然而在运行时,由java虚拟机指定对象的类型并运行该对象的方法(即b引用其实指向的是Dog对象,即父类的引用指向了子类的对象),那么在调用b.move()时,虚拟机会先找到b对象,然后通过引用找到了真正的Dog对象,然后调用Dog对象中的move()方法

因此在上面的例子中,之所以能够编译成功,是因为Animal类中存在move方法,然而运行时,运行的是特定对象的方法

## 封装

在面向对象程序设计中,封装是指一种将抽象性函数接口的实现细节包装隐藏起来的方法

封装的好处:

1. 使得代码可以重用
2. 对于使用者来说不必关系具体的实现
3. 具有安全性,可以我们控制外部对其的访问
4. 适当的封装,可以让程序更容易理解和维护

## 接口

接口(Interface),在java中是一个抽象类型,是抽象方法的集合,一个类通过继承接口的方法,从而来继承接口的抽象方法

接口包含了类要实现的方法,除非实现接口的类是抽象类,否则该类要哦实现接口中的所有方法

接口无法被实例化,但可以被实现

接口与类相似点:

1. 一个接口可以有多个方法
2. 接口文件保存在.java结尾的文件中,文件名使用接口名
3. 接口的字节码文件保存在.class结尾的文件中
4. 接口相应的字节码文件必须在与包名相匹配的目录结构中

接口与类的区别:

1. 接口不能用于实例化对象
2. 接口没有构造方法
3. 接口中所有的方法都是抽象方法,并且默认都是public的
4. 接口中定义的变量默认都是static final的
5. 接口支持多重继承
6. 接口中可以不存在任何内容,仅仅当作一个标记接口来使用

---

当一个类中实现了两个接口,并且这两个接口中都有共同的变量和方法时:

```java
//接口1
public interface C {
    int a=1;
    G g=new G(1);
    void eee();
}
//接口2
public interface D {
    int a=2;
    G g=new G(2);
    void eee();
}
```

> 上面两个接口都定义相同的变量名和方法

让F类实现接口C和接口D

```java
public class F implements C,D {
    //实现接口中的eee()方法
    @Override
    public void eee() {
        System.out.println("实现接口的eee方法");
    }
    public static void main(String[] args) {
        new F().eee();
        System.out.println("接口C中的a变量:"+C.a);
        System.out.println("接口D中的a变量:"+D.a);
//        System.out.println(F.a);//报错,如果当两个接口中都存在同一变量时,则该变量就不会继承到该类中,而是独立的归属于每个接口类中
//        F.g.test();//报错,原理和F.a是一样的
        C.g.test();//获取C接口中的g对象,并调用test()方法(如果没有获取g对象并调用test()方法,则该对象并不会被示例化,只有在调用时才会被实例化)
        
    }
}
//这个是G类的实现
public class G {
    G(int a){
        System.out.println("构造:"+a);
    }
    public void test(){
        System.out.println("对象G中的test()方法调用");
    }
}
```

> 运行结果:
>
> 实现接口的eee方法
> 接口C中的a变量:1
> 接口D中的a变量:2
> 构造:1
> 对象G中的test()方法调用

## 组合关系

组合关系代表类和它的成员之间的从属关系,这有助于代码的重用和减少代码的错误

```java
public class Vehicle{}
public class Speed{}
public class Van extends Vehicle{
	private Speed sp;
} 
```

Van类和Speed类是HAS-A关系(Van有一个Speed)，这样就不用将Speed类的全部代码粘贴到Van类中了，并且Speed类也可以重复利用于多个应用程序

在面向对象特性中，用户不必担心类的内部怎样实现

Van类将实现的细节对用户隐藏起来，因此，用户只需要知道怎样调用Van类来完成某一功能，而不必知道Van类是自己来做还是调用其他类来做这些工作

使用组合的这种方式可以很好的进行类之间的解耦



# 高级知识

## 枚举

普通使用:

```java
public enum Color {
    RED,            //红色
    BLUE,           //蓝色
    GREEN           //绿色
}
```

```java
public class G {
    public static void main(String[] args) {
        System.out.println(Color.RED);
    }
}
```

> 运行结果: RED

高级使用:

```java
public enum Color {
    //定义枚举
    RED("红色", 1),
    GREEN("绿色", 2),
    BLANK("白色", 3),
    YELLO("黄色", 4);
    // 成员变量  
    private String name;
    private int index;
    // 构造方法  
    Color(String name, int index) {
        this.name = name;
        this.index = index;  
    }
    //重写toString()方法
    @Override
    public String toString() {
        return String.valueOf(this.getIndex());
    }
	//生成getter和setter方法
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public int getIndex() {
        return index;
    }
    public void setIndex(int index) {
        this.index = index;
    }
}
```

```java
public class G {
    public static void main(String[] args) {
        System.out.println(Color.RED);
    }
}
```

> 运行结果: 1 (如果没有重写toString方法,则结果为RED)

## 泛型

泛型的本质是为了参数化类型(在不创建新的类型的情况下,通过泛型指定的不同类型来控制新参具体限制的类型),也就是说在泛型的使用过程中,操作的数据类型被指定为一个参数,这个参数类型可以用在类,接口和方法中,分别被称为泛型类,泛型接口,泛型方法

举个例子

```java
List arrayList = new ArrayList();
arrayList.add("aaaa");
arrayList.add(100);

for(int i = 0; i< arrayList.size();i++){
    String item = (String)arrayList.get(i);
    Log.d("泛型测试","item = " + item);
}
```

> 毫无疑问,程序的运行结果会以报错结束:
>
> java.lang.ClassCastException: java.lang.Integer cannot be cast to java.lang.String

ArrayList可以存放任意类型,例子中添加了一个String类型,添加了一个Integer类型,在使用的时候都以String的方式使用,所以会出错,为了解决类似这样的问题(在编译阶段就可以解决的问题),泛型应运而生

我们将第一行声明初始化为list的代码更改一下,编译器会在编译阶段就能帮我们发现类似这样的问题

```java
List<String> arrayList = new ArrayList<String>();
...
//arrayList.add(100); 在编译阶段，编译器就会报错
```

### 泛型的特性

泛型只在编译阶段有效

在编译之后程序会采用去泛型化的措施,也就是说java中的泛型,只在编译阶段有效,在编译过程中,正确检验泛型结果后,会将泛型的相关信息擦除,并且在对象进入和离开的边界处添加类型检查和类型转换的方法; 即泛型信息不会进入到运行时阶段

总结: 泛型类型在逻辑上可以看成多个不同的类型,实际上都是相同的基本类型

### 泛型的使用

#### 泛型类

泛型类用于类的定义中,通过泛型可以完成对一组类的操作对外开放相同的接口,最典型的就是各种容器类,如:List,Set,Map

泛型类的最基本的写法

```java
class 类名称 <泛型标识>{
    private 泛型标识 var; 
}
```

举个例子:

```java
//此处T可以随便写为任意标识，常见的如T、E、K、V等形式的参数常用于表示泛型
//在实例化泛型类时，必须指定T的具体类型
public class Generic<T>{ 
    //key这个成员变量的类型为T,T的类型由外部指定  
    private T key;

    public Generic(T key) { //泛型构造方法形参key的类型也为T，T的类型由外部指定
        this.key = key;
    }

    public T getKey(){ //泛型方法getKey的返回值类型为T，T的类型由外部指定
        return key;
    }
}
```

使用:

```java
//泛型的类型参数只能是类类型（包括自定义类），不能是简单类型
//传入的实参类型需与泛型的类型参数类型相同，即为Integer.
Generic<Integer> genericInteger = new Generic<Integer>(123456);

//传入的实参类型需与泛型的类型参数类型相同，即为String.
Generic<String> genericString = new Generic<String>("key_vlaue");
Log.d("泛型测试","key is " + genericInteger.getKey());
Log.d("泛型测试","key is " + genericString.getKey());

//不用必须传入泛型进行指定
Generic generic = new Generic("111111");
Log.d("泛型测试","key is " + generic.getKey());
```

> 定义了泛型了,在使用的使用不用必须传入泛型类型实参

#### 泛型接口

泛型接口与泛型类的定义及使用基本相同; 泛型接口常被用在各种类的生产容器中

举个例子:

```java
//定义一个泛型接口
public interface Generator<T> {
    public T next();
}
```

当实现泛型接口的类,未传入泛型实参时:

```java
//未传入泛型实参时，与泛型类的定义相同，在声明类的时候，需将泛型的声明也一起加到类中
class FruitGenerator<T> implements Generator<T>{
    @Override
    public T next() {
        return null;
    }
}
```

当实现泛型接口的类,传入泛型实参时:

```java
public class FruitGenerator implements Generator<String> {
    private String[] fruits = new String[]{"Apple", "Banana", "Pear"};
    @Override
    public String next() {
        Random rand = new Random();
        return fruits[rand.nextInt(3)];
    }
}
```

#### 泛型方法

泛型方法比较复杂,泛型方法是在调用方法的时候知名泛型的具体类型

举个例子:

```java
public <T> T genericMethod(Class<T> tClass)throws InstantiationException ,
  IllegalAccessException{
        T instance = tClass.newInstance();
        return instance;
}
```

> 说明:
>
> 1. public与返回值中间<T>非常重要,可以理解未声明此方法未泛型方法
> 2. 只有声明了<T>的方法才是泛型方法,泛型类中的使用了泛型成员的方法并不是泛型方法
> 3. <T>表明该方法将使用泛型类型T,此才可以在方法中使用泛型类型T
> 4. 与泛型类的定义一样,此处T可以随便写为任意标识

##### 基本用法

```java
public class GenericFruit {
    class Fruit{
        @Override
        public String toString() {
            return "fruit";
        }
    }

    class Apple extends Fruit{
        @Override
        public String toString() {
            return "apple";
        }
    }

    class Person{
        @Override
        public String toString() {
            return "Person";
        }
    }

    class GenerateTest<T>{
        public void show_1(T t){
            System.out.println(t.toString());
        }

        //在泛型类中声明了一个泛型方法，使用泛型E，这种泛型E可以为任意类型。可以类型与T相同，也可以不同。
        //由于泛型方法在声明的时候会声明泛型<E>，因此即使在泛型类中并未声明泛型，编译器也能够正确识别泛型方法中识别的泛型。
        public <E> void show_3(E t){
            System.out.println(t.toString());
        }

        //在泛型类中声明了一个泛型方法，使用泛型T，注意这个T是一种全新的类型，可以与泛型类中声明的T不是同一种类型。
        public <T> void show_2(T t){
            System.out.println(t.toString());
        }
    }

    public static void main(String[] args) {
        Apple apple = new Apple();
        Person person = new Person();

        GenerateTest<Fruit> generateTest = new GenerateTest<Fruit>();
        //apple是Fruit的子类，所以这里可以
        generateTest.show_1(apple);
        //编译器会报错，因为泛型类型实参指定的是Fruit，而传入的实参类是Person
        //generateTest.show_1(person);

        //使用这两个方法都可以成功
        generateTest.show_2(apple);
        generateTest.show_2(person);

        //使用这两个方法也都可以成功
        generateTest.show_3(apple);
        generateTest.show_3(person);
    }
}
```

## java8新特性

### Lambda表达式

带有参数变量的表达式,是一段可以传递的代码,可以被一次或多次执行

是一种精简的字面写法,其实就是把匿名内部类中的工作省略掉,然后由JVM通过推导把简化的表达式还原

其格式为: (参数1,参数2...) -> { 方法体 }

- 参数1,参数2... 

  类似方法中的形参列表,这里的参数是函数式接口里的参数

  如果形参列表为空，只需保留()

  如果形参只有1个，()可以省略，只需要参数的名称即可

- -> : 可理解为"被用于"的意思

- 方法体

  如果执行语句只有1句，且无返回值，{}可以省略，若有返回值，则若想省去{}，则必须同时省略return，且执行语句也保证只有1句

> 形参列表的数据类型会自动推断
>
> lambda不会生成一个单独的内部类文件

举个例子:

数组排序

```java
public class Demo01 {
	public static void main(String[] args) {
		// 定义字符串数组
		String[] strArr = { "abc", "cd", "abce", "a" };
        
		// 传统方法
		Arrays.sort(strArr, new Comparator<String>() {
			@Override
			public int compare(String s1, String s2) {
				return Integer.compare(s2.length(), s1.length());
			}
		});
        
		// Lambda表达式
		Arrays.sort(strArr, (s1, s2) -> Integer.compare(s2.length(), s1.length()));
    }
}
```

多线程

```java
public class Demo01 {
	public static void main(String[] args) {
		// Lambda表达式
		new Thread(() -> System.out.println(1 + "hello world")).start();
 
		// 方法体
		new Thread(() -> {
			for (int i = 0; i < 10; i++) {
				System.out.println(2 + "hello world");
			}
		}).start();
	}
}
```

#### 何时使用

需要显示创建函数式接口对象的地方,都可以使用,主要用于替换以前广泛使用的内部匿名类,各种回调,比如事件响应器,传入Thread类的Runnable等

#### 优点

加大的减少代码冗余,同时可读性也好过冗长的匿名内部类

### 接口的默认方法

在接口中新增了default方法和static方法,这两种方法可以有方法体

举个例子:

定义接口

```java
public interface H {
    default void aaa(){
        System.out.println("aaaaaaa");
    }

    static void bbb(){
        System.out.println("bbbbbbb");
    }
}
```

实现接口

```java
public class I implements H {
    //重写default方法
    @Override
    public void aaa() {
        System.out.println("11111");
    }

    public static void main(String[] args) {
        I i = new I();
        i.aaa();//接口中的default方法
//        i.bbb();//报错,不能被调用
        H.bbb();//接口中的static方法只能被接口自身调用
    }
}
```

> 总结:
>
> 1. 接口中的default方法可以被子类继承,可以被子类重写
> 2. 接口中的static方法不能被继承,也不能被子类调用,只能被接口自身调用

### Stream

#### 创建Stream

##### 通过of方法

```java
Stream<Integer> integerStream = Stream.of(1, 2, 3, 5);
Stream<String> stringStream = Stream.of("taobao");
```

##### 通过Collection子类获取Stream

#### Stream的其他应用

##### count()、max()、min()方法

```java
List<Integer> collection = new ArrayList<Integer>();
//list长度
System.out.println(collection.parallelStream().count());
//求最大值,返回Option,通过Option.get()获取值
System.out.println(collection.parallelStream().max((a,b)->{return a-b;}).get());
//求最小值,返回Option,通过Option.get()获取值
System.out.println(collection.parallelStream().min((a,b)->{return a-b;}).get());
```

##### Filter 过滤方法

过滤通过一个predicate接口来过滤并只保留符合条件的元素，该操作属于中间操作。

```java
List<Integer> collection = new ArrayList<Integer>();
Long count =collection.stream().filter(num -> num!=null).
    filter(num -> num.intValue()>50).count();
```

##### distinct方法

去除重复

```java
List<Integer> collection = new ArrayList<Integer>();
collection.stream().distinct().forEach(System.out.println());
```

##### Sort 排序

排序是一个中间操作，返回的是排序好后的Stream。如果你不指定一个自定义的Comparator则会使用默认排序

```java
stringCollection
    .stream()
    .sorted()
    .filter((s) -> s.startsWith("a"))
    .forEach(System.out.println());
// "aaa1", "aaa2"
```

### Date Time API

Clock 时钟

Clock类提供了访问当前日期和时间的方法，Clock是时区敏感的，可以用来取代System.currentTimeMillis() 来获取当前的微秒数; 某一个特定的时间点也可以使用Instant类来表示，Instant类也可以用来创建老的java.util.Date对象。

```java
Clock clock = Clock.systemDefaultZone();
long millis = clock.millis();
Instant instant = clock.instant();
Date legacyDate = Date.from(instant);   // legacy java.util.Date
```

## 反射

### 概述

java反射机制是在运行状态中,对于任意一个类,都能够知道这个类的所有属性和方法; 对于任意一个对象,都能够调用它的任意一个方法和属性; 这种动态获取的信息以及动态调用对象的方法的功能被成为java语言的反射机制

总结:

- 反射就是把java类中的各种成分映射成一个个的java对象

  例如: 一个类有:成员变量,方法,构造函数,包等信息,利用反射技术一个类进行解析,把一个个组成部分映射成一个个对象; 

一个类的正常加载过程:

1. 当我们使用new一个对象的时候,jvm会取加载我们对应的.class文件
2. jvm会取磁盘上找到对应的.class文件,并加载到jvm内存中
3. 将.class文件读入内存,并创建一个对应的对象

反射就是在得到class对象后,反向获取对象的各种信息

### 为什么需要反射

Java中编译类型有两种:

1. 静态编译: 在编译时确定类型,绑定对象即可
2. 动态编译: 运行时确定类型,绑定对象; 动态编译最大限度的发挥了java的灵活性,体现了多态的应用,可以降低类之间的耦合度

java反射是java被视为动态语言的一个关键:

- 这个机制允许程序在运行时透过Reflection APIs取得任何一个已知名称的class的内部信息，包括其modifiers（诸如public、static等）、superclass（例如Object）、实现之interfaces（例如Cloneable），也包括fields和methods的所有信息，并可于运行时改变fields内容或唤起methods。
- Reflection可以在运行时加载、探知、使用编译期间完全未知的classes。即Java程序可以加载一个运行时才得知名称的class，获取其完整构造，并生成其对象实体、或对其fields设值、或唤起其methods。
- 反射（reflection）允许静态语言在运行时（runtime）检查、修改程序的结构与行为。在静态语言中，使用一个变量时，必须知道它的类型。在Java中，变量的类型信息在编译时都保存到了class文件中，这样在运行时才能保证准确无误；换句话说，程序在运行时的行为都是固定的。如果想在运行时改变，就需要反射这东西了。

实现Java反射机制的类都位于java.lang.reflect包中：

1. Class类：代表一个类
2. Field类：代表类的成员变量（类的属性）
3. Method类：代表类的方法
4. Constructor类：代表类的构造方法
5. Array类：提供了动态创建数组，以及访问数组的元素的静态方法

**一句话概括就是使用反射可以赋予jvm动态编译的能力，否则类的元数据信息只能用静态编译的方式实现，例如热加载，Tomcat的classloader等等都没法支持。**

### 使用

获取Class对象的三种方式:

1. 对象.getClass();
2. 任何数据类型(包括基本数据类型)都有一个"静态"的class属性
3. 通过Class类的静态方法: forName来获取

当获取Class对象之后,就可以获取该对象的所有方法和变量,而且可以变量赋值或者调用其方法,或者创建该对象实例

#### Student对象

```java
public class Student {
    public int age;
    public String name;
    public Student() {
    }
    public Student(int age, String name) {
        this.age = age;
        this.name = name;
    }
    public void hello(String msg){
        System.out.println(this.name+":"+msg);
    }

    public int getAge() {
        return age;
    }
    public void setAge(int age) {
        this.age = age;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
}
```

#### 对象.getClass()

```java
public class Test {
    public static void main(String[] args) throws Exception {
        Student student = new Student();//创建一个student对象
        Class<? extends Student> aClass = student.getClass();//通过对象.getClass()获取到Class对象
        Method hello = aClass.getMethod("hello", String.class);//获取对象的方法
        hello.invoke(student, "nihao");//方法的调用
    }
}
```

#### 类名.class

```java
public class Test1 {
    public static void main(String[] args) throws Exception {
        Student student = Student.class.newInstance();//通过类名.class获取到Class对象
        student.setName("jack");
        student.hello("nihao");
    }
}
```

#### Class.forName()

```java
public class Test2 {
    public static void main(String[] args) throws Exception {
        Class<?> aClass = Class.forName("reflect.Student");//指定对象所在的位置
        Student student = (Student)aClass.newInstance();
        student.setName("jack");
        student.hello("nihao");
        
        //通过反射调用方法
        Method hello = aClass.getMethod("hello", String.class);
        hello.invoke(student,"I love you!");

        //获取所有公共字段
        Field[] fields = aClass.getFields();
        for (Field field : fields) {
            System.out.println(field.toString());
        }
        //获取所有私有字段
        Field[] declaredFields = aClass.getDeclaredFields();
        for (Field declaredField : declaredFields) {
            System.out.println(declaredField.toString());
        }

        //获取所有公共方法
        Method[] methods = aClass.getMethods();
        for (Method method : methods) {
            System.out.println(method.toString());
        }
        //获取所有私有方法
        Method[] declaredMethods = aClass.getDeclaredMethods();
        for (Method declaredMethod : declaredMethods) {
            System.out.println(declaredMethod.toString());
        }
    }
}
```

## 网络编程

略

## [集合框架-链接](集合.md)

## [多线程-链接](多线程.md)

## [JVM-链接](jvm.md)

# 其他内容

## 打包

打包命令jar的参数

- `-c`: 创建新的jar包
- `-f`: 指定jar的名称
- `-v`: 在控制台输出打包的过程

使用命令进行打包

- 进入当前要打包的目录下,打包所有class文件

  `jar -cvf demo.jar *.class`  

  > jar -cvf jar包名称 要打包的class文件

- 直接打包整个目录

  `jar -cvf demo.jar com`

  > jar -cvf jar包名称 要打包的目录 

# 参考文档

[java入门教程-w3cschool](https://www.w3cschool.cn/java/java-tutorial.html)

JDK1.8手册

https://blog.csdn.net/u014252871/article/details/53434530