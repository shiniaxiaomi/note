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

## 树

### TreeSet

TreeSet本质上是使用TreeMap来存储数据的

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

本质上使用了红黑树的排序二叉树的数据结构,它会根据key来进行排序

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

# 工具

## 排序

`Arrays.sort();`

### 普通排序

```java

```



### 自定义排序

```java

```



## 二分搜索

`Arrays.binarySearch();`

```java

```



## 数组复制

`Arrays.copyOf();`

```java

```







