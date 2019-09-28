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

## 在牛客网上代码提交报错的一些注意事项

需要标准的输入输出格式

```java
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







