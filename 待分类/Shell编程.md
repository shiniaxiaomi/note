# 介绍

shell由C语言编写，它是用户使用linux的桥梁，用户可以通过它来访问操作系统内核的服务。

shell脚本是指一种以shell语言编写的脚本程序。

shell是一种解释性语言。

linux中有多种shell，常见的有：

- Bourne Shell（`/usr/bin/sh`或`/bin/sh`）

- Bourne Again Shell（`/bin/bash`）

  > 大多数linux系统默认的shell

之后基于`/bin/bash`进行记录

# 变量

## 定义且初始化变量

```shell
str="hello world"
```

> 定义一个str变量，值为"hello world"
>
> 注意：定义变量时，等号两边不能有空格

## 使用变量

```shell
echo $str
echo ${str}Java
```

> 使用`$`符来获取变量的值
>
> 通过`{}`来区分变量的界限，因为如果不加`{}`，则会去获取`strJava`变量的值，而然我们是没有定义该变量的

## 变量赋值

```shell
str="hello world"
str=$(ls |grep jar$)
str=$(curl http://baidu.com)
```

> 注意：**变量赋值时，等号两边不能有空格**
>
> 可以使用`$()`来包裹命令，并将命令的返回值赋值给变量

## 删除变量

`unset str`

> str变量被删除后不能再次使用

## 只读变量

`readonly str`

> 将str变量设置为只读

# 字符串

## 单引号

单引号里的任何字符都会原样的输出，单引号字符串中的变量是无效的

## 双引号

在双引号中，可以使用变量，也可以使用转义字符

示例：

`"hello world $str"`

`"hello world \n`

## 拼接字符串

直接拼接即可

```shell
var="java"
str="hello" "world" $var
```

## 获取字符串长度

```shell
str="abcd"
echo ${#str}
```

> 通过`${#变量名}`来获取

## 截取字符串

```shell
str="hello"
echo ${str:1:3}
```

> 从第1个字符开始，截取3个字符
>
> 结果：ell

## 判断字符串为空

- 使用`test`判断

  ```shell
  if test !${a}
  then 
  	echo "字符串为空"
  fi
  ```

- 使用`[]`判断

  ```shell
  if [ !$str ]
  then
  	echo "字符串为空"
  fi
  ```

## 判断字符串相等

- 使用`test`判断

  ```shell
  if test $a = "java"
  then 
  	echo "字符串相等"
  fi
  ```

- 使用`[]`判断

  ```shell
  if [ $a = "java" ]
  then 
  	echo "字符串相等"
  fi
  ```


注意：判断字符串时，字符串需要使用双引号`""`

## 判断字符串不相等

- 使用`test`判断

  ```shell
  if test $a != $b
  then 
  	echo "字符串不相等"
  fi
  ```

- 使用`[]`判断

  ```shell
  if [ $a != "java" ]
  then 
  	echo "字符串不相等"
  fi
  ```


注意：判断字符串时，字符串需要使用双引号`""`

# 获取用户输入

## 无提示

```shell
read str
echo ${str}
```

> 将用户输入赋值到`str`变量中

## 有提示

```shell
read -p "tip: " str 
echo str
```

# 数组

## 定义数组

`strs=(1 2 3)`

`str[0]=1`

> 注意：等号两边不能有空格

## 使用数组

`echo ${strs[0]}`

## 获取数组的长度

`length=${#strs[@]}`

> `strs`是数组变量名

## 获取数组元素的长度

`length=${#strs[0]}`

> `strs`是数组变量名

## 遍历数组

- 使用`for ... in`方式遍历

  ```shell
  arr=(1 2 3 4 5)
  for i in ${arr[@]}
  do
      echo $i
  done
  ```

- 使用下标遍历

  ```shell
  arr=(1 2 3 4 5)
  for(( i=0; i<${#arr[@]}; i++ )) 
  do
  	echo ${arr[i]};
  done
  ```

# 注释

单行注释：以`#`开头

多行注释：

```shell
:<<EOF
注释内容...
EOF
```

# 传入参数

执行shell脚本时传入参数，参数以空格分隔；

`bash test.sh 1 2 3`

## 获取传入的参数

`echo $1 $2 $3`

> 结果：1 2 3
>
> 传入第n个变量就可以通过`$n`来获取

## 获取传入参数的个数

`echo $#`

## 获取所有传入参数并转化为一个单引号字符串

`echo $*`

测试：

`bash test.sh 1 2 3`

结果：1 2 3

## 获取所有传入参数到一个变量

```shell
for i in "$@"
do
    echo $i
done
```

测试：

`bash test.sh 1 2 3`

结果：

```shell
1
2
3
```

> 和`$*`的区别是：`$*`是直接将所有传入参数变为一个单引号字符串，而`$@`则是将所有传入参数保存在一个变量中，可以通过for循环获取每个传入的变量

# 基本运算

## 算数运算

### 加

```shell
a=`expr 2 + 2`
```

> 注意：运算符的两边需要保留空格

### 减

```shell
a=`expr 4 - 2`
```

> 注意：运算符的两边需要保留空格

### 乘

```shell
a=`expr 4 \* 2`
```

> `*`需要转义

### 除

```shell
a=`expr 4 / 2`
```

### 变量自增

```shell
a=10
let "a++"
echo $a
```

### 变量自减

```shell
a=10
let "a--"
echo $a
```

## 逻辑运算

### 判断相等

```shell
if (( $a == $b ))
then
	echo "相等"
fi
```

> 注意：`[]`中间的所有内容都需要以空格分隔

### 判断不相等

```shell
if (( $a != $b ))
then
	echo "不相等"
fi
```

> 注意：`[]`中间的所有内容都需要以空格分隔

### 与运算

```shell
if (( $a != $b && $c != $d ))
then
	...
fi
```

### 或运算

```shell
if (( $a != $b || $c != $d ))
then
	...
fi
```

# 打印输出

- 打印普通字符串

  `echo "hello world"`

  > 可以参略掉双引号

- 打印有转义的字符串

  `echo "\"test\""`

  结果："test"

- 打印变量

  `echo $str`

- 将结果打印到文件

  `echo "test" > testFile`

- 打印命令的执行结果

  `echo $(curl http://baidu.com)`

  `echo $(ls | grep java)`

# test命令

简单的条件判断可以使用`test`命令来代替`[]`判断

```shell
if test $a == "1"
then 
	echo "变量等于1"
fi
```

# (( ... ))表达式

使用`(( ... ))`表达式可以进行复杂的条件判断，表达式用法和java一样

```shell
if (( $a <= 1 && $b < 4))
then 
	echo 1111
fi
```

> 当使用`(())`表达式时，中间内容的表达式不需要关注有无空格，就和java中的表达式一样编写即可，非常方便

```shell
if (( $a == 1 && $a != 2))
then 
	echo 1111
fi
```

> 注意：当使用`(())`表达式时，它的中间内容的表达式语法就和java一样，相等判断需要使用`==`

**注意：**

> 这种表达式符合C语言的运算符
>
> 这种表达式是整数型的计算,不支持浮点型和字符串
>
> 若是逻辑判断,表达式exp为真则为1,假则为0

# 流程控制

## if判断

```shell
if (( $a == $b ))
then 
	...
fi
```

## if else判断

```shell
if (( $a == $b ))
then 
	...
else
	...
fi
```

## if else if判断

```shell
if (( $a == $b ))
then 
	...
elif (( $c == $d ))
	...
else
	...
fi
```

## case判断

```shell
$num=3
case $num in
    1)  echo '你选择了 1'
    ;;
    2)  echo '你选择了 2'
    ;;
    *)  echo '你没有输入 1 到 2 之间的数字'
    ;;
esac
```

# 循环

## for循环

使用`for ... in`循环

```shell
arr=(1 2 3 4 5)
for i in ${arr[@]}
do
    echo $i
done
```

使用下标循环

```shell
arr=(1 2 3 4 5)
for(( i=0; i<${#arr[@]}; i++ )) 
do
	echo ${arr[i]};
done
```

## while循环

```shell
a=10
while (( $a >=1 ))
do
	echo $a
	let "a--"
done
```

## 死循环

```shell
while true
do
	...
done
```

## 跳出循环（break）

```shell
while true
do
		if (( $a == 1 ))
		then 
				break
		fi
done
```

## 跳过此次循环（continue）

```shell
arr=(1 2 3 4 5)
for(( i=0; i<${#arr[@]}; i++ )) 
do
	if (( $i == 2 ))
	then
  	continue
	fi
	echo ${arr[i]};
done
```

# 函数

函数在使用前必须先定义

> 因为shell是一个解释性语言

## 无入参无返回值函数

定义函数

```shell
domeFun(){
	echo "demo"
}
```

调用函数

`domeFun`

## 无入参有返回值函数

定义函数

```shell
domeFun(){
	return 1
}
```

函数调用

```shell
domeFun
echo $?
```

> 结果：1
>
> 调用有返回值的函数时，通过`$?`来获取函数的返回值

## 有入参有返回值函数

定义函数

```shell
domeFun(){
	echo "第一个参数为 $1 !"
	echo "第二个参数为 $2 !"
  echo "参数总数有 $# 个!"
	return 1
}
```

函数调用

`domeFun 1 2 3`

结果：

```shell
第一个参数为 1 !
第二个参数为 2 !
参数总数有 3 个!
```

> 在函数中获取参数和在调用脚本时外部传入参数的获取方式是一样的

# 输入/输出重定向

## 将命令结果重定向到文件

```shell
ls > testFile
```

> 使用`>>`替换`>`可以将内容追加到文件中

## 屏蔽stdout和stderr并重定向到file

```shell
ls > testFile 2>&1
```

> 可以将控制台的输出输出到指定文件中
>
> 使用`>>`替换`>`可以将内容追加到文件中

## 将文件内容作为参数传入命令

```shell
grep java < testFile
```

## 关闭控制台输出

```shell
ls > /dev/null
```

> `/dev/null `是一个特殊的文件，写入到它的内容都会被丢弃，因此起到"禁止输出"的效果

如果希望屏蔽 stdout 和 stderr且关闭输出：

```shell
ls > /dev/null 2>&1
```

# 引入shell脚本

shell可以从引入外部的shell脚本，这样可以方便封装一些公共的代码

```shell
. test.sh
```

或者

```shell
source test.sh
```

> 引入其他shell脚本后，可以直接使用其他shell脚本的变量和函数

# 其他

## 直接获取项目的pid

`pgrep -f 项目名称`

示例：`pgrep -f blog`

> 项目名称不需要完全匹配，只需要匹配名称的部分内容即可

# 工具脚本

## 关闭应用脚本

```shell
app=$(pgrep -f plantip)
if [ !$app ]
then
	kill -9 $app
fi
```

## 构建java项目脚本

```shell
# 使用maven构建项目
projectPath=/root/code/plantip
cd $projectPath
mvn package -Dmaven.test.skip=true
```

## 启动应用脚本

```shell
# 关闭应用
app=$(pgrep -f plantip)
if [ !$app ]
then
    kill -9 $app
fi

# 启动应用
projectPath=/root/code/plantip
cd $projectPath/target
name=$(ls |grep jar$)
nohup java -jar $projectPath/target/$name --spring.profiles.active=prod >$projectPath/log &
# 因为指定了日志输出到文件之后，那么日志就不会在当前的窗口显示，我们可以在启动后监听日志文件即可查看到日志
tail -f $projectPath/log
```

## 直接退出脚本命令

```shell
exit 0
```


