[TOC]

# 数据结构

## 线性表

### ArrayList

```java
public class ArrayListDemo {
    public static void main(String[] args) {
        //本质实现是数组,增删慢,查询快
        List<Integer> list = new ArrayList<>();

        for(int i=0;i<10;i++){
            list.add(i);
        }

        for(int i=0;i<10;i++){
            System.out.println(list.get(i));//index从0开始
        }
    }
}
```

### LinkedList

```java
public class LinkedListDemo {
    public static void main(String[] args) {
        //本质实现是链表,增删快,查询慢
        List<Integer> list = new LinkedList<>();
        for(int i=0;i<10;i++){
            list.add(i);
        }

        for(int i=0;i<10;i++){
            System.out.println(list.get(i));//index从0开始
        }
    }
}
```

### LinkedHashSet

按照放入顺序摆放的一个set集合

```java
//按字符串原有的字符顺序，输出字符集合，即重复出现并靠后的字母不输出
//输入: abcqweracb
//输出: abcqwer
public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        LinkedHashSet<Character> hashSet = new LinkedHashSet<>();
        
        String s = scanner.nextLine();
        for(int i=0;i<s.length();i++){
            hashSet.add(s.charAt(i));
        }
        Iterator<Character> iterator = hashSet.iterator();
        while(iterator.hasNext()){
            System.out.print(iterator.next());
        }
    }
}
```

## 树

### TreeSet

TreeSet底层是通过TreeMap实现的,TreeSet是根据元素进行排序的,支持自然排序和自定义排序

如果试图把一个对象添加进TreeSet时,则该对象的类必须实现Comparable接口,因为只有告诉了TreeSet怎么排序,它才会根据规则去将元素排好顺序

#### 原理

TreeSet是通过TreeMap来实现存储,其将元素设置为TreeMap的key,而TreeMap的value则设置为Present

TreeSet怎么保证元素唯一:

- 如果要把元素添加到TreeSet中,那么该元素必须要实现Comparable接口,所以每次在添加元素时,都会使用comparetor()方法去比较元素,如果返回零,则表示两个元素相同;如果返回正数,则表示新来的元素大于已有的元素;返回负数,则表示新来的元素小于已有的元素;

#### Demo

```java
public class TreeSetDemo {
    public static void main(String[] args) {
        //其功能就是一个最大最小堆
        //如果存放的是一个对象,那么该对象需要实现Comparator接口
        TreeSet<Integer> treeSet = new TreeSet<>();

        for(int i=0;i<10;i++){
            treeSet.add((int) Math.round(Math.random()*100));//添加随机数,使其排序
        }
        System.out.println(treeSet.toString());

        Integer first = treeSet.pollFirst();//获取最小值
        Integer last = treeSet.pollLast();//获取最大值
        System.out.println(first);
        System.out.println(last);
    }
}
```

### TreeMap

TreeMap是基于红黑树实现的,它不想HashMap可以进行调优(设置初始容量和加载因子),因为该树总是处于平衡状态(自平衡的二叉树),它的元素都是有序的

#### 原理

TreeMap是基于红黑树的NavigableMap实现的; 该映射根据其键值的自然顺序进行排序,或者根据创建映射时提供的Comparetor进行排序,具体取决于使用的构造方法;

TreeMap为containsKey,get,put和remove操作都提供了log(n)的时间复杂度;

TreeMap是非线程安全的,如果在多线程环境下,可以使用 `Collections.synchronizedSortedMap()`方法来"包装"该映射(而且是在创建时就完成这一操作),例如: ` SortedMap m = Collections.synchronizedSortedMap(new TreeMap(…)); `

#### demo

```java
public class TreeSetDemo {
    public static void main(String[] args) {
        //本质上使用了红黑树的排序二叉树的数据结构
        TreeMap<String,String> treeMap = new TreeMap();
        treeMap.put("1","111111");
        treeMap.put("3","333333");
        treeMap.put("2","222222");

        String s = treeMap.firstKey();
        System.out.println(treeMap.get(s));

        String s1 = treeMap.lastKey();
        System.out.println(treeMap.get(s1));
    }
}
```

## 堆栈

### Stack

```java
public class StackDemo {
    public static void main(String[] args) {
        Stack<Integer> stack = new Stack<>();
        for(int i=0;i<10;i++){
            stack.push(i);//入栈
        }
        while(!stack.empty()){
            Integer pop = stack.pop();//出栈
            System.out.println(pop);
        }
    }
}
```

## 队列

### ArrayDeque

双向队列

```java
public class JDKQueueDemo {
    public static void main(String[] args) {
        //双端队列
        ArrayDeque<Object> arrayDeque = new ArrayDeque<>();
        arrayDeque.addLast(1);//指定加载末尾
        arrayDeque.addLast(2);
        arrayDeque.addLast(3);
        arrayDeque.add(4);//add默认加载尾部
        Object poll1 = arrayDeque.poll();//poll默认弹出头部
        System.out.println(poll1);
        Object last = arrayDeque.getLast();
        System.out.println(last);
        Object first = arrayDeque.getFirst();
        System.out.println(first);
    }
}
```

### PriorityQueue

优先队列(最大最小堆的实现)

```java
public class JDKQueueDemo {
    public static void main(String[] args) {
        //定义比较的规则(按照降序,即最大堆)
        Comparator<Integer> comparator=new Comparator<Integer>() {
            @Override
            public int compare(Integer o1, Integer o2) {
                return o2-o1;
            }
        };
        PriorityQueue<Integer> priorityQueue = new PriorityQueue<>(comparator);//创建优先队列
        priorityQueue.add(1);
        priorityQueue.add(5);
        priorityQueue.add(2);
        priorityQueue.add(4);
        priorityQueue.add(3);
        while (!priorityQueue.isEmpty()){
            Object poll = priorityQueue.poll();
            System.out.println(poll);
        }
    }
}
```

## 哈希表

### HashMap

HashMap是基于hash表的Map接口的实现,它提供key-value形式的键值存储,并允许使用null值和null键(处理非同步和允许使用null之外,HashMap和Hashtable基本相同),它所存储的key是无序的

#### 原理

HashMap使用hash函数将元素适当的分布在数组中,可为基本操作(get和put)提供稳定的性能; 

HashMap的有两个参数影响其性能: `初始容量`和`加载因子`;  容量是hash表中数组的大小,`初始容量`是hash表在创建时的容量; `加载因子`是hash表在其容量自动增加之前可以达到多满的一种尺度; 当hash表中的个数超出了加载因子和当前容量大小的乘积时,则要对hash表进行rehash操作(即重建内部数据结构),从而hash表将具有大约两倍的数组大小

通常,默认加载因子为0.75,它在时间和空间成本上寻求了一种折中; 加载因子过高虽然减少了空间开销,但同时也增加了查询成本(在大多数HashMap操作中) ;在设置初始容量时应该考虑到映射中所需的总数量即其加载因子,以变最大限度的减少rehash操作次数; 如果初始容量大于最大条目数除以加载因子,则不会发生rehash操作

如果有很多映射关系要存储在HashMap中,则我们需要将HashMap的初始容量设置得更大,以减少rehash操作的次数

HashMap是非线程安全的,如果在多线程环境下,则应该使用 ConcurrentHashMap(其原理是CAS)

#### demo

```java
public class JDKHashTableDemo {
    public static void main(String[] args) {
        //和HashMap一样,他是线程安全的,而HashMap不是
        //他们内部都是用链表来解决hash冲突
        Hashtable<String, Integer> hashtable = new Hashtable<>();

        hashtable.put("you",10);
        Integer you = hashtable.get("you");
        System.out.println(you);
        int size = hashtable.size();
        System.out.println(size);
    }
}
```

### LinkedHashMap

LinkedHashMap继承于HashMap,其底层实现使用的是HashMap,但是它有通过了链表将所有的元素串联起来,实现了可以顺序的遍历他们

LinkedHashMap使用与实现图:

![img](D:\note\.img\4843132-7abca1abd714341d.webp)

HashMap的元素是无序的,当我们希望有顺序的去存储元素时,就需要使用LinkedHashMap了

示例代码:

```java
Map<String, String> linkedHashMap = new LinkedHashMap<>();
linkedHashMap.put("name1", "josan1");
linkedHashMap.put("name2", "josan2");
linkedHashMap.put("name3", "josan3");
Set<Entry<String, String>> set = linkedHashMap.entrySet();
Iterator<Entry<String, String>> iterator = set.iterator();
while(iterator.hasNext()) {
    Entry entry = iterator.next();
    String key = (String) entry.getKey();
    String value = (String) entry.getValue();
    System.out.println(key + "," + value);
}
```

> 运行结果:
>
> name1,josan1
>
> name2,josan2
>
> name3,josan3

所以.LinkedHashMap是有序的,且默认按照元素插入的顺序排序

---

当我们需要通过key来获取到value时,LinkedHashMap也可以做到,这就是它区别于ArrayList和LinkedList的重大原因

```java
LinkedHashMap<String, String> linkedHashMap = new LinkedHashMap<>();
linkedHashMap.put("name", "josan");
String name = linkedHashMap.get("name");
```

### HashSet

HashSet的底层是通过HashMap来实现的,其值保存在HashMap的key中,而HashMap的value则存储为Present

HashSet的元素是无序的

HashSet如何保证元素唯一:

- HashSet在添加元素时,先通过计算元素的hashcode值,通过hashcode找到对应元素存放的位置,如果该位置没有元素,那么直接保存该元素; 如果位置上已经存在元素,则会再次调用equals()方法用来判断两个元素是否相等(判断引用是否相等),如果true,则不做任何操作,如果false,那么执行添加操作

# 面试题

## HashMap和TreeMap的区别

1. 底层实现

   HashMap的底层实现是Hash表和链表/红黑树

   TreeMap的底层实现是红黑树

2. 性能

   HashMap比TreeMap的性能要好

3. 排序

   HashMap的元素是无序的

   TreeMap的元素是有序的

## HashMap和LinkedHashMap区别

放两张图,秒懂:

HashMap:

![img](D:\note\.img\4843132-2e04e0f72a751a47.webp)

LinkedHashMap:

![img](D:\note\.img\4843132-23488d46581b87ea.webp)

总结:

1. LinkedHashMap是继承于HashMap,是基于HashMap和双向链表来实现的
2. HashMap是无序的,而LinkedHashMap是有序的,可分为插入顺序和访问顺序两种; 如果是访问顺序,那put和get操作已存在的Entry时,都会把Entry移动到双向链表的尾部(其实就是先删除再插入)
3. LinkedHashMap存取数据,还是跟HashMap一样,使用Entry[]的方式,双向链表只是为了保证顺序
4. 他们都是线程不安全的

## LinkedHashMap和TreeMap的区别

1. 底层实现不同

   LinkedHashMap是基于HashMap和双向链表实现的

   TreeMap是基于红黑树实现的

2. 排序不同

   LinkedHashMap是按照插入循序排序的

   TreeMap是按照元素自然排序或者自定义排序的

3. 时间复杂度不同

   LinkedHashMap从宏观上看是O(1)的时间复杂度

   TreeMap则是log(n)的时间复杂度

## HashSet和TreeSet的区别

1. 底层实现不同

   HashSet底层是通过HashMap实现的,其将元素设置为HashMap的key,而HashMap的value则设置为Present

   TreeSet底层是通过TreeMap实现的,其将元素设置为TreeMap的key,而TreeMap的value则设置为Present

2. 排序不同

   HashSet的元素是无序的

   TreeSet的元素支持自然排序和自定义排序

3. 时间复杂度不同

   HashSet从宏观上看是O(1)的时间复杂度

   TreeSet则是log(n)的时间复杂度

## HashMap和HashSet的区别

1. 保存的类型不同

   HashMap保存的是一种映射关系

   HashSet保存的仅仅是值

2. 底层实现

   HashSet就是通过HashMap来实现的

3. 排序

   他们的元素都是无序的

# 工具

## 在牛客网上代码提交报错的一些注意事项

### 需要标准的输入输出格式

```java
import java.util.Scanner;
//不能包含包名
//类名必须是Main
public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);//创建一个输入
        //你的代码必须要有一层while (scanner.hasNext())包裹,不然会提示你的输出为空
        while (scanner.hasNext()) {
			//...你的代码实现
            //使用scanner.nextInt()读取int
            //使用scanner.next()读取string
        }
    }
}
```

### 注意事项

- 如果出现代码运算和本地不一致的情况,看一下是否是输出的时候没有回车换行,导致牛客网不能识别你输出的结果

- 牛客网的判题规则是:

  1. 如果你输出了正确的值,牛客网会默认接着测试其他测试用例,所以一定要输出的结果一定要记得回车换行

  2. 如果你输出的结果是多个的,那么如果你输出的第一值就错了,那么牛客网就直接报错,不会再让你继续输出,所以非常的不好调试(非常不友好)

     > 解决办法: 就是将要输出的结果打印一行输出,然后再回车换行,可以查看自己程序运行的所有结果,只能这样进行调试

### 快速获取牛客网的测试用例

```java
import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        while (scanner.hasNext()) {
			int nextInt = scanner.nextInt();
            System.out.println(nextInt);
        }
    }
}
```

### 直接跳出递归的方法

在递归返回值上返回true

每次递归调用完后接收到true,则继续return true

### 递归思想

把这个解空间看成一个多叉树,首先有一个root节点,由root节点衍生出的节点就是第一个节点的几种可能性,如果有9中可能,则root节点则会有9个孩子节点,那么这个9个孩子节点又在各自的有9个节点...,这样就形成了一个棵多叉树,在利用剪枝缩小范围,最终得到解的过程

递归代码的模板

- 首先先把模板写成一个多叉树的深度优先遍历的代码

  在一开始的时候就是将第一个节点抓住,让其衍生出孩子节点,再在其孩子节点中衍生出其他节点

  每次都是从一个节点出发,遍历该节点下的节点

  如二叉树的遍历

  ```java
  //先序遍历
  public void preOrder(Node node){
      //每次遍历一进来之后就可以处理该当前访问的节点
      //或者做一些范围的控制(如剪枝等)
      System.out.print(node.value+" ");
      //这个代码就是一个剪枝的过程,即不符合条件的直接return,不会再去访问该节点下的子节点
      if(node.value<0){
      	return;
      }
      
      //由一个节点衍生出两个节点(左子树和右子树)
      preOrder(node.leftChildren);//访问左节点
      preOrder(node.rightChildren);//访问右节点
  }
  ```

  再如多叉树的遍历

  ```java
  //先序遍历
  public void preOrder(Node node){
      System.out.print(node.value+" ");//访问当前节点
      
      //由一个节点衍生出九个节点
      for(int i=0;i<9;i++){
          //或者是在for循环时剪枝,如果不符合条件,则不会去访问其对应的子节点
           if(node[i].value<0){
           	continue;
           }
           preOrder(node的各个孩子节点);//访问该节点的九个孩子节点
      }
  }
  ```

## java输入输出

```java
public class demo1 {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        //读取下一个整数,以回车结束
        int i = scanner.nextInt();
        System.out.println(i);
        //读取下一个字符串,以空格结束
        String next = scanner.next();
        System.out.println(next);
        //读取下一行,以回车结束
        String s = scanner.nextLine();
        System.out.println(s);
    }
}
```

## 排序

`Arrays.sort();`

### 普通排序

```java
public class SortDemo {
    Integer[] arr=new Integer[]{1,45,7,5248,15,488,56,49,8465,67,1,2,13,5986,87,6,547,89,7};
    //普通数组排序
    public void sort1(){
        Integer[] buff1=Arrays.copyOf(arr,arr.length);//复制数组
        Arrays.sort(buff1);//升序
        System.out.println(Arrays.toString(buff1));
    }
    //普通数组指定范围排序
    public void sort2(){
        Integer[] buff2=Arrays.copyOf(arr,arr.length);//复制数组
        Arrays.sort(buff2,2,8);
        System.out.println(Arrays.toString(buff2));
    }

    public static void main(String[] args) {
        SortDemo sortDemo = new SortDemo();
        sortDemo.sort1();//普通排序
        sortDemo.sort2();//指定范围排序
    }
}
```

### 自定义排序

待排序的数组或list的类型必须和Comparator接口中的类型一致

```java
public class SortDemo {
    Integer[] arr=new Integer[]{1,45,7,5248,15,488,56,49,8465,67,1,2,13,5986,87,6,547,89,7};
    //自定义排序规则
    //注意,buff3的数组类型必须和Comparator中的类型一致,不然会报错(如buff3为int,而Comparator为Integer就会报错)
    public void sort3(){
        Integer[] buff3=Arrays.copyOf(arr,arr.length);//复制数组
        Arrays.sort(buff3, new Comparator<Integer>() {//降序排列
            @Override
            public int compare(Integer o1, Integer o2) {
                if(o1>o2){
                    return -1;
                }else if(o1<o2){
                    return 1;
                }else {
                    return 0;
                }
            }
        });
        System.out.println(Arrays.toString(buff3));
    }

    //定义一个Student类
    class Student{
        int age;
        String name;
        public Student(int age, String name) {
            this.age = age;
            this.name = name;
        }
        @Override
        public String toString() {
            return "[age:"+age+",name:"+name+"]";
        }
    }
    //自定义对象排序
    public void sort4(){
        ArrayList<Student> students = new ArrayList<>();
        students.add(new Student(5,"555555"));
        students.add(new Student(9,"999999"));
        students.add(new Student(1,"111111"));
        students.add(new Student(7,"777777"));

        students.sort(new Comparator<Student>() {
            @Override
            public int compare(Student o1, Student o2) {
                if(o1.age>o2.age){
                    return -1;
                }else if(o1.age<o2.age){
                    return 1;
                }else {
                    return 0;
                }
            }
        });
        for(int i=0;i<students.size();i++){
            System.out.println(students.get(i));
        }
    }
	//测试
    public static void main(String[] args) {
        SortDemo sortDemo = new SortDemo();
        sortDemo.sort3();//自定义排序规则
        sortDemo.sort4();//自定义排序对象
    }
}
```

## 二分搜索

`Arrays.binarySearch();`

```java
public class BinarySearchDemo {
    public static void main(String[] args) {
        int[] arr=new int[]{1,45,7,5248,15,488,56,49,8465,67,1,2,13,5986,87,6,547,89,7};

        Arrays.sort(arr);//先进行排序
        System.out.println(Arrays.toString(arr));

        int index = Arrays.binarySearch(arr, 15);//如果找到,则返回排好序的数组中元素坐在的索引,否则返回-1
        System.out.println(index);
        System.out.println(arr[index]);
    }
}
```

## 数组复制

`Arrays.copyOf();`

```java
public class CopyArrayDemo {
    public static void main(String[] args) {
        int[] arr=new int[]{1,45,7,5248,15,488,56,49,8465,67,1,2,13,5986,87,6,547,89,7};

        int[] buff1= Arrays.copyOf(arr,arr.length);//复制数组
        Arrays.sort(buff1);//排序复制的数组

        System.out.println(Arrays.toString(arr));//打印原数组
        System.out.println(Arrays.toString(buff1));//打印复制后排好序的数组
    }
}
```







