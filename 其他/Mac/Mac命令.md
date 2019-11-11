[TOC]

# 介绍

记录Mac系统相关的一些命令设置

# 命令

## 设置命令

- mac打开任意来源安装软件

  只需在终端输入命令：`sudo spctl --master-disable`

- 查看Mac电脑的硬盘信息

  `diskutil list`

- 挂在指定的硬盘

  `sudo diskutil mountDisk disk0`

  > disk0指的是硬盘中具体的编号

## 查找命令

### find

find是最常见和最强大的命令,你可以用它找到任何你想找的文件

find的格式如下：

`find <指定目录> <指定条件> <指定动作>`

- <指定目录>：所要搜索的目录及其所有子目录，默认是当前目录
- <指定条件>：所有搜索的文件的特征
- <指定动作>：对搜索结果进行特定的处理

如果什么参数也不加，find默认搜索当前目录及其子目录，并且不过滤任何

find的使用示例：

1. `find . -name 'java*'`

   搜索当前目录（包子目录）中，所有文件名以java开头的文件

   > 单引号可省略

2. `find . -name java* -ls` 

   搜索当前目录中，所有文件名以java开头的文件，并显示他们的详细信息

3. `find . -type f -mmin -10 `

   搜索当前目录中，所有过去10分钟中更新过的普通文件。如果不加-type f参数，则搜索普通文件+特殊文件+目录

### whereis

whereis命令只能用于程序名的搜索，而且只搜索二进制文件（参数-b）、man说明文件（参数-m）和源代码文件（参数-s）。如果省略参数，则返回所有信息。

示例：

`whereis grep`

### which

which命令的作用是，在PATH变量指定的路径中，搜索某个系统命令的位置，并且返回第一个搜索结果。也就是说，使用which命令，就可以看到某个系统命令是否存在，已经执行的到底是哪个位置的命令

`which pyhton`

## 常用命令

### man

```shell
man mkdir
man java
```

作用：查阅某个命令的手册页，q退出

### sudo

作用：提成命令的权限

### cd

```shell
cd /
```

作用：用于改变工作目录

### mkdir

```shell
mkdir note
```

作用：新建目录

### pwd

作用：输出当前工作目录的绝对路径

### ls

作用：列出文件

### nano

作用：把终端作为一个简单的文本编辑器

### curl

作用：利用 URL 语法在命令行下工作的文件传输工具

```shell
curl www.baidu.com
curl -o baidu.html www.baidu.com #下载文件并保存为baidu.html文件
```

### cat

快速读取文件

```shell
#显示文件全部内容
cat foo.txt

#显示行号
cat -n foo.txt

#创建文件并进入编辑模式
cat > filename

#对文件追加内容
cat >> filename

#合并文件内容
cat foo.txt bar.txt > foobar.txt
```

### more

功能：类似于cat命令，但是可以以一页一页的方式读取

使用：下一页按`空格`，上一个按`b`，退出按`q`，vi编辑器模式按`v`

### less

功能：类似于more命令

使用：退出按`q`

### which

作用：在环境变量 `$PATH` 设置的目录里查找符合条件的文件

```bash
which bash
```

### file

作用：辨识该文件的类型

```bash
file foo.txt
```

### cp

作用：复制文件或目录

参数：`-r` 若源文件是一个目录文件，此时将复制该目录下所有的子目录和文件

使用：

```bash
cp –r foo/ newfoo
```

### mv

作用：为文件或目录改名、或将文件或目录移入其它位置

```bash
mv foo bar  #将文件foo更名为bar
mv foo/ bar  #将foo目录放入bar目录中
```

### rm

作用：删除一个文件或者目录，且无法恢复

参数：`-r` 删除目录时必需参数；`-i` 删除前逐一询问确认

```bash
rm  foo.txt  #删除一般文件  
rm  -r  foofolder  #删除目录
```

### open

作用：使用 Finder 打开文件目录或程序

```bash
open /Applications/Safari.app/  #打开应用
open .  #打开当前目录
```

### history

作用：显示指定数目的历史命令

```bash
history 10 #列出最近的10条历史命令
```

### touch

作用：修改文件或者目录的时间属性，若文件不存在，新建文件

```bash
touch testfile 
```

### say

作用：朗读一段文字，即文本转语音（TTS）

妙用：等程序运行完毕语音提醒

```shell
sleep 10 && say "hello" #延时10秒
sleep 0.5 && say "hello" #延时0.5秒
```

