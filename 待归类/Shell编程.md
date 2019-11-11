[TOC]

# 介绍

Shell是一个用C语言编写的程序，他是用户使用Linux的桥梁。Shell即是一种命令语言，又是一种程序设计语言

Shell是指一种应用程序，这个应用程序提供了一个界面，用户通过这个界面访问操作系统内核的服务



Shell脚本（Shell Script），是一种为shell编写的脚本程序

业界所说的shell通常都指的是shell脚本，shell编程指的是shell脚本变成



shell变成跟JavaScript、python编程一样，都是解释性语言

Linux的shell种类众多，常见的有：

- Bourne Shell（/usr/bin/sh或/bin/sh）
- Bourne Again Shell（/bin/bash）
- 。。。

本文针对于Bash进行编写，也就是Bourne Again Shell，由于易用和免费，Bash在日常工作中被广泛使用，同时，Bash也是大多数Linux系统默认的Shell

> 一般情况下，人们不能并不区分Bourne Shell和Bourne Again Shell

# Shell变量

## 定义变量

```shell
a=1
str=“hello world”
```

## 使用变量

```shell
echo $a
echo $str
echo ${str}Java #花括号加不加都行，只是为了区分变量的界限
```

## 只读变量

```shell
a=1
readonly a
```

## 删除变量

```shell
unset a #变量被删除后不能再次使用，unset命令不能删除只读变量
```

## 变量类型

1. 局部变量

   局部变量在脚本或命令中定义，仅在当前shell实例中有效，其他shell启动的程序不能访问局部变量

2. 环境变量

   所有的程序，包括shell启动的程序，都能访问换将变量，有些程序需要环境变量来保证其正常运行。必要的时候shell脚本也可以定义环境变量

3. shell变量

   shell变量是由shell程序设置的特殊变量。shell变量中有一部分是环境变量，有一部分是局部变量，这些变量保证了shell的正常运行

## shell字符串

字符串是shell编程中最常用最有用的数据类型，字符串可以用单引号也可以用双引号，也可以不用引号

### 单引号

单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的

单引号字符串中不能出现单独一个的单引号（对单引号使用转义符后也不行），但可成对出现，作为字符串拼接使用

### 双引号

优点：

- 双引号里可以使用变量
- 双引号里可以出现转义字符

### 拼接字符串

```shell
your_name="runoob"
# 使用双引号拼接
greeting="hello, "$your_name" !"
greeting_1="hello, ${your_name} !"
echo $greeting  
echo $greeting_1
```

> 结果（变量替换成功）：
>
> hello, runoob ! 
>
> hello, runoob !

### 获取字符串长度

```shell
string="abcd"
echo ${#string} #输出 4
```

### 提取子字符串

以下实例从字符串第 **2** 个字符开始截取 **4** 个字符：

```shell
string="runoob is a great site"
echo ${string:1:4} # 输出 unoo
```

### 查找子字符串

查找字符 **i** 或 **o** 的位置(哪个字母先出现就计算哪个)：

```shell
string="runoob is a great site"
echo `expr index "${string}" io`  # 输出 4
```

**注意：** 以上脚本中 **`** 是反引号，而不是单引号 **'**，不要看错了。

## shell数组

bash支持一维数组（不支持多维数组），并且没有限定数组的大小

类似于C语言，数组元素的下标由0开始编号。获取数组中的元素要利用下标，下标可以是整数或算术表达式，其实应大于或等于0

### 定义数组

在shell中，用括号来表示数组，数组元素用`空格`分隔

```shell
数组名=(值1 值2 ... 值n)
strs=(1 2 3 4 5 ... n)
```

单独定义数组中的变量

```shell
strs[0]=1
strs[1]=2
```

### 读取数组

```shell
echo ${strs[0]}
```

使用`@`符号可以获取数组中的所有元素

```shell
strs=(1 2 3 4 5)
echo ${strs[@]}
```

> 结果：1 2 3 4 5

### 获取数组的长度

获取数组长度的方法与获取字符串长度的方法相同

```shell
# 取得数组元素的个数
length=${#strs[@]}
# 取得数组单个元素的长度
lengthn=${#strs[1]}
```

## shell注释

### 单行注释

以 **#** 开头的行就是注释，会被解释器忽略

### 多行注释

```shell
:<<EOF
注释内容...
注释内容...
注释内容...
EOF
```

# shell传递参数

我们可以在执行shell脚本时，向脚本传递参数，脚本内获取参数的格式为：$n。n代表一个数字，1为执行脚本的第一个参数，2位执行脚本的第二个参数，以此类推



示例：

新建shell脚本名为a.sh，内容如下：

```shell
echo $1 $2 $3
```

执行脚本：`bash a.sh 1 2 3`

执行结果：1 2 3



另外，还有几个特殊字符用来处理参数：

| 参数处理 |                             说明                             |
| :------: | :----------------------------------------------------------: |
|   `$#`   |                     传递到脚本的参数个数                     |
|   `$*`   |            以一个单字符串显示所有向脚本传递的参数            |
|   `$$`   |                    脚本运行的当前进程ID号                    |
|   `$!`   |                 后台运行的最后一个进程的ID号                 |
|   `$@`   |                          与`$*`相同                          |
|   `$-`   | 显示Shell使用的当前选项，与[set命令](https://www.runoob.com/linux/linux-comm-set.html)功能相同。 |
|   `$?`   | 显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误。 |

`$*` 与 `$@`区别：

示例：

```shell
for i in "$*"; do
    echo $i
done

for i in "$@"; do
    echo $i
done
```

都执行以下脚本命令：`bash test.sh 1 2 3`

运行结果：

1. $*（相当于传递了一个参数）

   ```shell
   1 2 3
   ```

2. $@（相当于传递了三个参数）

   ```shell
   1
   2
   3
   ```

# shell基本运算符

## 算术运算符

shell脚本不支持简单的数学运算，但是可以通过其他命令来实现，如`expr`

```shell
a=`expr 2 + 2`
echo $a
```

> 结果为4

注意：

- 表达式和运算符之间要有`空格`
- 完整的表达式要被**``**包含



其他算法：

- 减法：`expr $a + $b`

- 乘法：`expr $a \* $b`，`*`需要转义
- 除法：`expr $b / $a`
- 取余：`expr $b % $a``
- 赋值：`a=$b`
- 判断相等：`[ $a == $b ]`
- 判断不等：`[ $a != $b ]`

> **注意：`[]`中间的所有内容都需要以空格分隔**

## 关系运算符

关系运算符只支持数字，不支持字符串，除非字符串的值是数字

下表列出了常用的关系运算符，假定变量 a 为 10，变量 b 为 20：

| 运算符 | 说明                                                  | 举例                         |
| :----: | :---------------------------------------------------- | :--------------------------- |
| `-eq`  | 检测两个数是否相等，相等返回 true。                   | `[ $a -eq $b ] `返回 false。 |
| `-ne`  | 检测两个数是否不相等，不相等返回 true。               | `[ $a -ne $b ] `返回 true。  |
| `-gt`  | 检测左边的数是否大于右边的，如果是，则返回 true。     | `[ $a -gt $b ] `返回 false。 |
| `-lt`  | 检测左边的数是否小于右边的，如果是，则返回 true。     | `[ $a -lt $b ] `返回 true。  |
| `-ge`  | 检测左边的数是否大于等于右边的，如果是，则返回 true。 | `[ $a -ge $b ] `返回 false。 |
| `-le`  | 检测左边的数是否小于等于右边的，如果是，则返回 true。 | `[ $a -le $b ] `返回 true。  |

## 布尔运算符

下表列出了常用的布尔运算符，假定变量 a 为 10，变量 b 为 20：

| 运算符 | 说明                                                | 举例                                       |
| :----: | :-------------------------------------------------- | :----------------------------------------- |
|  `!`   | 非运算，表达式为 true 则返回 false，否则返回 true。 | `[ ! false ] `返回 true。                  |
|  `-o`  | 或运算，有一个表达式为 true 则返回 true。           | `[ $a -lt 20 -o $b -gt 100 ]` 返回 true。  |
|  `-a`  | 与运算，两个表达式都为 true 才返回 true。           | `[ $a -lt 20 -a $b -gt 100 ] `返回 false。 |

## 逻辑运算符

以下介绍 Shell 的逻辑运算符，假定变量 a 为 10，变量 b 为 20:

| 运算符 | 说明       | 举例                                        |
| :----: | :--------- | :------------------------------------------ |
|  `&&`  | 逻辑的 AND | `[[ $a -lt 100 && $b -gt 100 ]]` 返回 false |
|  `||`  | 逻辑的 OR  | `[[ $a -lt 100 || $b -gt 100 ]] `返回 true  |

## 字符串运行符

下表列出了常用的字符串运算符，假定变量 a 为 "abc"，变量 b 为 "efg"：

| 运算符 | 说明                                      | 举例                       |
| :----: | :---------------------------------------- | :------------------------- |
|  `=`   | 检测两个字符串是否相等，相等返回 true。   | `[ $a = $b ] `返回 false。 |
|  `!=`  | 检测两个字符串是否相等，不相等返回 true。 | `[ $a != $b ] `返回 true。 |
|  `-z`  | 检测字符串长度是否为0，为0返回 true。     | `[ -z $a ]` 返回 false。   |
|  `-n`  | 检测字符串长度是否为0，不为0返回 true。   | `[ -n "$a" ]` 返回 true。  |
|  `$`   | 检测字符串是否为空，不为空返回 true。     | `[ $a ] `返回 true。       |

## 文件测试运算符

[参考文档](https://www.runoob.com/linux/linux-shell-basic-operators.html)

# echo命令

shell中的echo命令的最主要最用是打印输出，命令格式为：`echo ...`

1. 显示普通字符串

   ```shell
   echo "aaa"
   ```

   这里的双引号完全可以省略，以下命令与上面实例效果一致：

   ```shell
   echo aaa
   ```

2. 显示转义字符串

   ```shell
   echo "\"It is a test\""
   ```

   结果为：

   ```shell
   "It is a test"
   ```

3. 显示变量

   read命令从标准输入中读取一行，并把输入行的每个字段的值指定给shell变量

   ```shell
   read name 
   echo "$name It is a test"
   ```

   结果：

   ```shell
   $ sh test.sh
   OK                     #标准输入
   OK It is a test        #输出
   ```

4. 显示换行

   ```shell
   echo -e "OK! \n" # -e 开启转义
   echo "It is a test"
   ```

5. 显示不换行

   ```shell
   echo -e "OK! \c" # -e 开启转义 \c 不换行
   echo "It is a test"
   ```

   结果：`OK! It is a test`

6. 显示结果定向至文件

   ```shell
   echo "It is a test" > myfile
   ```

7. 原样输出字符串，不进行转义或取变量（用单引号）

   ```shell
   echo '$name\"'
   ```

8. 显示命令执行结果

   ```shell
   echo `date`
   ```

   > 注意：这里使用的是**``**符号，符号里面可以包含shell命令

# test命令

简单的条件判断则可以使用test命令就可以替换if判断中的`[]`

示例：

```shell
if test 1 == 1
then
    echo '两个数相等！'
else
    echo '两个数不相等！'
fi
```

> 使用test命令后，等号两边可以把`空格`省略掉

# (( ... ))表达式

使用(( ... ))表达式可以进行复杂的条件判断

例如：

```shell
if (( $int <= 1 ))
then 
	echo 1111
fi
```

```shell
while (($int <=5 && $int<4))
do
    echo $int
    let "int++"
done
```

# shell流程控制

## if判断

```shell
if test 1 == 1
then
    command1 
    command2
    ...
    commandN 
fi
```

## if else判断

```shell
if test 1 == 1
then
    command1 
    command2
    ...
    commandN
else
    command
fi
```

## if elseif  else判断

```shell
if test 1 == 1
then
    command1
elif test 1 == 2
then 
    command2
else
    commandN
fi
```

# 循环

## for循环

for循环格式：

```shell
for var in item1 item2 ... itemN
do
    command1
    ...
done
```

> 使用变量名var获取列表中的当前取值
>
> 命令command1可为任何有效的shell命令和语句
>
> in列表可以包含字符串和文件名等

in列表是可选的，如果不用in，则使用以下for循环格式：

```shell
for loop in 1 2 3 4 5
do
    echo "The value is: $loop"
done
```

## while循环

格式：

```shell
while test 1==1
do
    command
    ...
done
```

示例：

```shell
int=1
while (( $int<=5 ))
do
    echo $int
    let "int++"
done
```

## 无限循环

```shell
while:
do
	command
	...
done
```

或者

```shell
while true
do
	command
	...
done
```

或者

```shell
for (( ; ; ))
```

## until循环

until循环执行一系列命令直至条件为true时停止

语法：

```shell
until condition
do
    command
done
```

## case

shell的case语句为多选择语句，可以用case语句匹配一个值与一个模式，如果匹配成功，则执行相对应的命令

示例：

```shell
read aNum
case $aNum in
    1)  echo '你选择了 1'
    ;;
    2)  echo '你选择了 2'
    ;;
    3)  echo '你选择了 3'
    ;;
    4)  echo '你选择了 4'
    ;;
    *)  echo '你没有输入 1 到 4 之间的数字'
    ;;
esac
```

## 跳出循环

shell提供了break和continue两个命令来跳出循环

### break

示例：

```shell
while :
do
		if test 1==1
		then 
				break
		fi
done
```

### continue

示例：

```shell
while :
do
		if test 1==1
		then 
				continue
		fi
done
```

# shell函数

shell允许用户定义函数，然后在shell脚本中可以调用

## 简单函数

函数定义示例如下：

```shell
demoFun(){
    echo "这是我的第一个 shell 函数!"
}
```

函数调用：

```shell
demoFun
```

## 有返回值的函数

```shell
# 函数定义
funWithReturn(){
    aNum=1
    anotherNum=2
    return $(($aNum+$anotherNum))
}
# 函数调用
funWithReturn 
# 打印返回值
echo “返回值为：$?”
```

> 运行结果：`返回值为：3`

**函数返回值在调用该函数后通过 $? 来获得。**

> 注意：所有函数在使用前必须定义。这意味着必须将函数放在脚本开始部分，直至shell解释器首次发现它时，才可以使用。调用函数仅使用其函数名即可。

## 函数参数

在shell中，调用函数时可以向函数中传递参数，在函数体内部，通过 `$n` 的形式来获取参数的值，例如，`$1`表示第一个参数，`$2`表示第二个参数...

示例:

```shell
funWithParam(){
    echo "第一个参数为 $1 !"
    echo "第二个参数为 $2 !"
    echo "参数总数有 $# 个!"
    echo "作为一个字符串输出所有参数 $* !"
}
funWithParam 1 2 3
```

> 运行结果：
>
> ```shell
> 第一个参数为 1 !
> 第二个参数为 2 !
> 参数总数有 3 个!
> 作为一个字符串输出所有参数 1 2 3
> ```

# shell的输入/输出重定向

|       命令        | 说明                                               |
| :---------------: | :------------------------------------------------- |
| `command > file`  | 将输出重定向到 file。                              |
| `command < file`  | 将输入重定向到 file。                              |
| `command >> file` | 将输出以追加的方式重定向到 file。                  |
|    `n > file`     | 将文件描述符为 n 的文件重定向到 file。             |
|    `n >> file`    | 将文件描述符为 n 的文件以追加的方式重定向到 file。 |
|     `n >& m`      | 将输出文件 m 和 n 合并。                           |
|     `n <& m`      | 将输入文件 m 和 n 合并。                           |
|     `<< tag`      | 将开始标记 tag 和结束标记 tag 之间的内容作为输入。 |

## 输出重定向

示例：

```shell
ls > a.txt
```

> 上述方式的重定向会覆盖a.txt文件中的所有内容

```shell
ls >> a.txt
```

> 上述方式的重定向会将内容追加到a.txt文件中

如果希望将stdout和stderr合并后重定向到file，可以这样写：

```shell
command > file 2>&1
或者
command >> file 2>&1
```

## 输入重定向

示例：

```shell
wc -l a.txt
```

## /dev/null文件

如果希望执行某个命令，但又不希望在屏幕上显示输出结果，那么可以将输出重定向到`/dev/null`中

```shell
ls > /dev/null
```

> `/dev/null `是一个特殊的文件，写入到它的内容都会被丢弃；如果尝试从该文件读取内容，那么什么也读不到。但是` /dev/null` 文件非常有用，将命令的输出重定向到它，会起到"禁止输出"的效果。

如果希望屏蔽 stdout 和 stderr，可以这样写：

```shell
command > /dev/null 2>&1
```

> 注意：*0 是标准输入（STDIN），1 是标准输出（STDOUT），2 是标准错误输出（STDERR）。*

# shell文件引入

和其他语言一样，shell可以从外部引入其他shell脚本，这样可以很方便的封装一些公共的代码作为一个独立的文件

格式示例：

```shell
. test.sh
或者
source test.sh
```

代码示例：

test1.sh文件内容如下：

```shell
a=1
```

test2.sh文件内容如下：

```shell
# 引入test1.sh文件
. test1.sh
echo $a
```

> 运行结果：1

# 其他

## 获取用户输入

### 提示用户并获取输入：

```shell
read -p "提示: " number 
echo number
```

> 提示用户输入数字

### 不提示直接获取用户输入：

```shell
read number 
echo number
```



