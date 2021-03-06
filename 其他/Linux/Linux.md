# 简介

是一个操作系统,和Windows、UNIX一样属于比较流行的操作系统

## linux和unix的联系

windows和linux都参考了unix,先有unix,才有的liunx

- Unix的历史

  在当时需要一个分时操作系统,然后以肯•汤普森为首的贝尔实验室研究人员就开发了unix系统,Multi 是大的意思，大而且繁；而 Uni 是小的意思，小而且巧。这是 UNIX 开发者的设计初衷，这个理念一直影响至今。

- Linux的历史

  Linux内核最初由李纳斯•托瓦兹（Linus Torvalds）开发的,之后作者公开了代码,使得所有可以一起完善linux,到现在只有 2% 的 Linux 核心代码是由李纳斯•托瓦兹自己编写的,但他保留了选择新代码和需要合并的新方法的最终裁定权

- Unix和Linux的关系
  - UNIX 是 Linux 的父亲;
  - Unix依赖硬件,而且是商业产品,不公开; 

  - Linux不依赖硬件,而且是开源产品;


- Unix/Linux系统结构

  ![山东省](/Users/yingjie.lu/Documents/note/.img/2-1P926160U0153.jpg)

  总共分为3个层次:

  - 底层(系统内核)

    内核层是 UNIX/Linux 系统的核心和基础，`它直接附着在硬件平台之上，控制和管理系统内各种资源`（硬件资源和软件资源），有效地组织进程的运行，从而扩展硬件的功能，提高资源的利用效率，为用户提供方便、高效、安全、可靠的应用环境。

  - 中间层(shell层)

    Shell 层是与用户直接交互的界面。用户可以在提示符下输入命令行，由 Shell 解释执行并输出相应结果或者有关信息,我们可以利用系统提供的丰富命令可以快捷而简便地完成许多工作

  - 高层(应用层)

    应用层提供基于 X Window 协议的图形环境。												

- Linux的优点
  - 有很多好用且免费的软件
  - 有良好的可移植性及灵活性
  - 优良的稳定性和安全性
  - 支持几乎所有的网络协议及开发语言

## linux发行版

所有的linux发行版中,他们的内核都是一样的,是由李纳斯•托瓦兹开发,不同的是他们各自自带了一些不同的软件,系统安装界面和管理工具等

> 内核指的是一个提供设备驱动、文件系统、进程管理、网络通信等功能的系统软件，内核并不是一套完整的操作系统，它只是操作系统的核心。

- 发行版
  - Red Hat Linux

    包括RHEL（Red Hat Enterprise Linux，收费版本）和 `CentOS`（RHEL 的社区克隆版本，免费版本）

  - Ubuntu Linux

    界面友好，容易上手，对硬件的支持非常全面，是目前最适合做桌面系统的 Linux 发行版本,并且免费提供

  - ...

- 发行版选择
  - 如果需要一个服务器系统,需要比较稳定的CentOS或者RHEL
  - 如果需要一个桌面系统,可以选择Ubuntu

## 桌面环境

- KDE 桌面系统
  - 优点：KDE 几乎是最先进最强大的桌面环境，它外观优美、高度可定制、兼容比较旧的硬件设备
  - 缺点：Kmail 等一些组件的配置对新手来说过于复杂。
- GNOME 桌面环境
  - 优点：简单易用，可通过插件来扩展功能。
  - 缺点：对插件的管理能力比较差，也缺少其它桌面环境拥有的许多功能。
- Unity
  - 优点：界面简洁直观，可以通过第三方工具来深度定制，而且使用了平视显示器（HUD）等新技术。
  - 缺点：默认的定制功能比较差劲，通知机制一般。

查看桌面环境

`echo $DESKTOP_SESSION`

# 安装

- 使用VMware虚拟机安装linux

- 选好镜像,一路next

- 在配置网络的时候,选择NAT模式

  网络模式选择

  - 桥接模式

    虚拟机的网卡和本机的物理网卡都连到VMnet0 虚拟交换机上,相当于虚拟机和主机连了一根网线

  - NAT模式

    虚拟机的网卡和本机的虚拟网卡连接到 VMnet8 虚拟交换机上,相当于本机开了一个wifi,然后虚拟机连接wifi进行上网

  - 仅主机模式

    虚拟机和本机都使用虚拟网卡 VMnet1,这种连接造成虚拟机和本机都没有网络,只能两个机子进行通讯

linux的远程管理协议

---

linux使用的是SSH协议（Secure [Shell](http://c.biancheng.net/shell/)）

> SSH协议: 命令行界面远程管理协议，几乎所有操作系统都默认支持此协议。和 Telnet 不同，该协议在数据传输时会对数据进行加密并压缩，因此使用此协议传输数据既安全速度又快。

# 文件和目录

## 文件目录结构

整体结构图

![](/Users/yingjie.lu/Documents/note/.img/2-1Z5061A1003X.gif)

**根目录**

---

与系统的开机、修复、还原密切相关; 根目录必须包含开机软件、核心文件、开机所需程序、函数库、修复系统程序等文件

**一级目录**

---

- `/bin`: 存放系统命令
- `/boot`: 系统启动目录
- `/dev`: 设备文件保存位置
- `/etc`: 配置文件保存位置
- `/home`: 普通用户的主目录(也成为家目录),每个用户在家目录都会有一个和用户名相同的目录
- `/lib`: 系统调用的函数库保存位置
- `/media,/mnt,/misc`:挂载目录 ,挂载媒体设备
- `/opt`: 第三方安装的软件保存位置
- `/root`: root的主目录
- `/sbin`: 保存与系统环境相关的命令
- `/srv`: 服务数据目录; 一些系统服务启动之后，会在这个目录中保存所需要的数据
- `/tmp`: 临时目录; 系统存放临时文件的目录
- `/lost+found`: 当系统意外崩溃或意外关机时，产生的一些文件碎片会存放在这里
- `/proc,/sys`: 虚拟文件系统; 该目录中的数据并不保存在硬盘上，而是保存到内存中。主要保存系统的内核、进程、外部设备状态和网络状态等
- `/usr`: 此目录用于存储系统软件资源。FHS 建议所有开发者，应把软件产品的数据合理的放置在 /usr 目录下的各子目录中，而不是为他们的产品创建单独的目录。
- `/var`: 用于存储动态数据，例如缓存、日志文件、软件运行过程中产生的文件等。



详细介绍两个目录

**/usr目录**

---

Linux 系统中，所有系统默认的软件都存储在 /usr 目录下, /usr 目录类似 Windows 系统中 C:\Windows\ + C:\Program files\ 两个目录的综合体。

- `/usr/bin/`: 存放系统命令
- `/usr/sbin/`: 存放根文件系统不必要的系统管理命令，如多数服务程序，只有 root 可以使用。
- `/usr/lib/`: 应用程序调用的函数库保存位置 
- `/usr/XllR6/`: 图形界面系统保存位置 
- `/usr/local/`: 手工安装的软件保存位置。我们一般建议源码包软件安装在这个位置  
- `/usr/share/`: 应用程序的资源文件保存位置，如帮助文档、说明文档和字体目录  
- `/usr/src/`: 源码包保存位置。我们手工下载的源码包和内核源码包都可以保存到这里

**/var目录**

---

- `/var/lib/`: 程序运行中需要调用或改变的数据保存位置。如 MySQL 的数据库保存在 /var/lib/mysql/ 目录中  
- `/var/log/`: 登陆文件放置的目录，其中所包含比较重要的文件如 /var/log/messages, /var/log/wtmp 等。  
- `/var/run/`: 一些服务和程序运行后，它们的 PID（进程 ID）保存位置  
- `/var/spool/`: 里面主要都是一些临时存放，随时会被用户所调用的数据，例如 /var/spool/mail/ 存放新收到的邮件，/var/spool/cron/ 存放系统定时任务。  
- `/var/www/`: RPM 包安装的 Apache 的网页主目录  
- `/var/nis和/var/yp`  NIS `服务机制所使用的目录`，nis 主要记录所有网络中每一个 client 的连接信息；yp 是 linux 的 nis 服务的日志文件存放的目录  
- `/var/tmp`: 一些应用程序在安装或执行时，需要在重启后使用的某些文件，此目录能将该类文件暂时存放起来，完成后再行删除

# linux基本命令

命令的基本格式

```cmd
[root@localhost ~]# 命令[选项][参数]
```

> - root：显示的是当前的登录用户
> - localhost：当前系统的简写主机名（完整主机名是 localhost.localdomain）。
> - ~：代表用户当前所在的目录，此例中用户当前所在的目录是家目录。
>   - 超级用户的家目录：/root。
>   - 普通用户的家目录：/home/用户名
> - \#：命令提示符，Linux 用这个符号标识登录的用户权限等级。如果是超级用户，提示符就是 #；如果是普通用户，提示符就是 $。

总结一下：

命令的选项用于调整命令功能，而命令的参数是这个命令的操作对象

## cd

用来切换工作目录, 是 Change Directory 的缩写

基本格式

```cmd
[root@localhost ~]# cd [相对路径或绝对路径]
```

选项

- `~`: 代表当前登录用户的主目录  
- `~用户名`: 表示切换至指定用户的主目录  
- `-`: 代表上次所在目录  
- `.`: 代表当前目录  
- `..`: 代表上级目录

| 特殊符号 | 作 用                      |
| -------- | -------------------------- |
| ~        | 代表当前登录用户的主目录   |
| ~用户名  | 表示切换至指定用户的主目录 |
| -        | 代表上次所在目录           |
| .        | 代表当前目录               |
| ..       | 代表上级目录               |

## pwd

显示用户当前所处的工作目录, Print Working Directory （打印工作目录）的缩写

基本格式

```cmd
[root@localhost ~]# pwd
```

## ls

显示当前目录下的内容; list 的缩写

基本命令

```cmd
[root@localhost ~]# ls [选项] 目录名称
```

选项

- `-a`: 显示全部的文件，包括隐藏文件（开头为 . 的文件）
- `-h`: 以易读的方式显示文件或目录大小，如 1KB、234MB、2GB 等。
- `-l`: 使用长格式列出文件和目录信息
- `-R`: 连同子目录内容一起列出来，递归显示目录
- `-t`: 以时间排序，而不是以文件名排序。

示例

```cmd
# 不加参数(默认当前路径)
[root@www ~]# ls -alh 
# 加上参数(路径)
[root@www ~]# ls -alh /
```

## mkdir

用于创建新目录, 是 make directories 的缩写

基本格式

```cmd
[root@localhost ~]# mkdir [-mp] 目录名
```

选项

- `-m`: 选项用于手动配置所创建目录的权限，而不再使用默认权限。
- `-p`: 选项递归创建所有目录，以创建 /home/test/demo 为例，在默认情况下，你需要一层一层的创建各个目录，而使用 -p 选项，则系统会自动帮你创建 /home、/home/test 以及 /home/test/demo。

示例

```cmd
# 使用 -p 选项递归建立目录
[root@localhost ~]# mkdir -p lm/movie/jp/cangls

# 使用 -m 选项自定义目录权限
[root@localhost ~]# mkdir -m 711 test2
```

## rmdir

用于删除空目录, 是remove empty directories 的缩写,

基本格式

```cmd
[root@localhost ~]# rmdir [-p] 目录名
```

选项

- `-p`: 用于递归删除空目录。

## touch

创建文件

基本格式

```cmd
[root@localhost ~]# touch [选项] 文件名
```

选项

- `-a`：只修改文件的访问时间；
- `-c`：仅修改文件的时间参数（3 个时间参数都改变），如果文件不存在，则不建立新文件。
- `-d`：后面可以跟欲修订的日期，而不用当前的日期，即把文件的 atime 和 mtime 时间改为指定的时间。
- `-m`：只修改文件的数据修改时间。
- `-t`：命令后面可以跟欲修订的时间，而不用目前的时间，时间书写格式为 `YYMMDDhhmm`。

## ln

用于给文件创建链接

> - 软链接：类似于 Windows 系统中给文件创建快捷方式
> - 硬链接：指的就是给一个文件的 inode 分配多个文件名，通过任何一个文件名，都可以找到此文件的 inode，从而读取该文件的数据信息。

基本格式

```cmd
[root@localhost ~]# ln [选项] 源文件 目标文件
```

选项

- `-s`：建立软链接文件。如果不加 "-s" 选项，则建立硬链接文件；
- `-f`：强制。如果目标文件已经存在，则删除目标文件后再建立链接文件；

示例

- 创建硬链接

  `ln /root/cangls /tmp`
  
- 创建软连接

  `ln -s /root/bols /tmp`

## cp

复制文件和目录

基本格式

```cmd
[root@localhost ~]# cp [选项] 源文件 目标文件
```

常用命令：

- `cp a.log b.log`：复制文件
- `cp AFolder BFolder`：复制文件夹

选项

- `-a`：相当于 -d、-p、-r 选项的集合
- `-d`：如果源文件为软链接（对硬链接无效），则复制出的目标文件也为软链接；
- `-p`：复制后目标文件保留源文件的属性（包括所有者、所属组、权限和时间）；
- `-r`：递归复制，用于复制目录；
- `-u`：若目标文件比源文件有差异，则使用该选项可以更新目标文件，此选项可用于对文件的升级和备用。

示例

- 把源文件不改名复制到 /tmp/ 目录下

  `cp cangls /tmp/`

- 改名复制

  `cp cangls /tmp/bols`

## rm

删除命令

基本格式

```cmd
[root@localhost ~]# rm[选项] 文件或目录
```

选项

- `-f`：强制删除（force），和 -i 选项相反，使用 -f，系统将不再询问，而是直接删除目标文件或目录。
- `-i`：和 -f 正好相反，在删除文件或目录之前，系统会给出提示信息，使用 -i 可以有效防止不小心删除有用的文件或目录。
- `-r`：递归删除，主要用于删除目录，可删除指定目录及包含的所有内容，包括所有的子目录和文件。

示例

```cmd
#强制删除所有，一了百了
[root@localhost ~]# rm -rf /test
```

## mv

在不同的目录之间移动文件或目录, 也可以对文件和目录进行重命名; move 的缩写

基本格式

```cmd
[root@localhost ~]# mv 【选项】 源文件 目标文件
```

选项

- `-f`：强制覆盖，如果目标文件已经存在，则不询问，直接强制覆盖；
- `-i`：交互移动，如果目标文件已经存在，则询问用户是否覆盖（默认选项）；
- `-n`：如果目标文件已经存在，则不会覆盖移动，而且不询问用户；
- `-v`：显示文件或目录的移动过程；
- `-u`：若目标文件已经存在，但两者相比，源文件更新，则会对目标文件进行升级；

示例

- 移动目录(源文件删除)

  `mv cangls /tmp`

- 移动并强制覆盖目录

  `mv -f cangls /tmp`

- 修改名称(如果都在同一目录,移动就是改名)

  `mv bols lmls`

## 其他命令

- 查看linux的版本
  1.  `cat /etc/issue`，此命令也适用于所有的Linux发行版。 
  2. ` cat /etc/redhat-release `,  这种方法只适合Redhat系的Linux 

# 查找命令

## find

find命令用来在指定目录下查找文件，任何位于参数之前的字符串都将被视为欲查找的目录名，如果不设置参数，则遍历所有的文件

> findn命令会遍历指定目录下的所有文件来查找文件，虽然这样效率很低，但是确保能够找到所有文件

语法：`find path -option`

常用的option参数有：

- `-name`：指定要查找的文件名称，可以使用正则
- `-type`：
  - f 一般文件
  - d 目录
  - c 字符设备文件
  - b 块设备文件
  - l link文件
  - s socket文件
- `-amin n` : 在过去 n 分钟内被读取过
- `-anewer file` : 比文件 file 更晚被读取过的文件
- `-atime n` : 在过去 n 天过读取过的文件
- `-cmin n` : 在过去 n 分钟内被修改过
- `-ctime n` : 在过去 n 天过修改过的文件

创建命令：

```shell
find . -type f #找到当前文件夹下的所有普通文件
```

```shell
find .size +100M #找到当前文件夹下的所有大于100M的文件（所有类型的文件，包括文件夹）
```

## locate

locatei命令用于查找符合条件的文档，他和find命令不同，find是进行指定路径的遍历，而locate查找的不是目录，而是索引数据库，这个数据库中含有本地文件的所有文件信息，linux系统会自动创建这个数据库，并且每天自动更新一次

> 有时后使用locate会查询不到文件，但文件确实存在，这是因为数据库文件没有被更新的缘故。为了避免这种情况，可以在使用locate之前，先使用updatedb命令，手动更新数据库后再进行查询即可

## whereis

whereis命令用于查找特定目录中符合条件的文件。这些文件一般为原始代码、二进制文件或者是帮助文档

> 该指令只能用于查找二进制文件，源代码文件和man手册页，一般文件的定位需使用locate命令

规则：`whereis program`

示例：

```shell
whereis bash
```

## which

which命令会在环境变量$PATH设置的目录里查找符合条件的文件

规则：`which [-as] program`

示例：

```shell
which java
```

# 环境变量

- 编辑配置文件(永久修改)

   `vim /etc/profile`

-  在profile文件最下方中添加所需配置

  ```shell
  #set mysql environment
  export MYSQL_HOME=/usr/local/mysql
  export PATH=$PATH:${MYSQL_HOME}/bin
  ```

  > 需要添加什么就创建什么变量路径,然后添加到PATH中

- 使用配置文件立即生效

  `source /etc/profile`

# 打包和压缩(tar|zip)

打包是指将多个文件打包成一个文件,但是并不进行压缩

压缩是指将一个文件进行压缩,使之所占用的空间变小

## .tar和.tar.gz文件

`.tar`文件是打包非压缩文件,`.tar.gz`文件是打包且压缩文件

- **.tar文件**

  - 打包

    `tar -cvf ./test.tar test`

  - 解压

    `tar -xvf ./anaconda-ks.cfg.tar`

- **.tar.gz文件**

  - 打包并压缩

    `tar -zcvf ./tmp.tar.gz /tmp/`

  - 解压缩

    `tar -zxvf ./tmp.tar.gz`

## .zip文件

- **压缩文件命令**

  基本格式

  ```cmd
  [root@localhost ~]#zip [选项] 压缩包名 源文件或源目录列表
  ```

  选项

  - `-v`: 显示详细的压缩过程信息。  
  - `-r`: 递归压缩目录，及将制定目录下的所有文件以及子目录全部压缩。  

  示例

  - 压缩多个文件

    `zip -v test.zip install.log install.log.syslog`

  - 压缩目录

    `zip -vr dir1.zip dir1`

- **解压缩文件命令**

  基本格式

  ```cmd
  [root@localhost ~]# unzip [选项] 压缩包名
  ```

  选项

  - `-d 目录名`: 将压缩文件解压到指定目录下。
  - `-o`: 解压时覆盖已经存在的文件，并且无需用户确认。

  示例

  - 解压到当前目录

    `unzip -d ./ ana.zip`
  
  在linux中,还可以使用`-O`来指定解压的字符编码,用来解决window下的压缩包在Linux中解压出现中文乱码问题
  
  > `unzip -O gbk -d ./ ana.zip`

# Vim文本编辑器

## 介绍及其安装

Vim 是一个基于文本界面的编辑工具，使用简单且功能强大。

vim的安装

```cmd
yum -y install vim
```

## 三种工作模式

- 命令模式

  默认处于命令模式,可以使用方向键,可以对文件内容及进行复制,复制、粘贴、替换、删除等操作。

- 输入模式

  可以键入文本

- 编辑模式

  可以执行保存,查找或替换等操作

  按`:`即可进入到编辑模式,退出按`ESC`

## 基本操作

### 打开文件

`vim /test/vi.test`

### 插入文本

- 在当前光标所在位置输入文本

  `i`

- 在光标所在行的下面插入新的一行

  `o`

- 在光标所在行的行尾输入文本

  `A`

### 查找文本

- 从光标所在位置向前查找字符串abc

  `:/abc`

- 从光标所在位置向后查找字符串abc

  `:?abc`

- 查找以abc为首的行

  `:/^abc`

### 替换文本

- 替换`当前行`的`第一个` vivian 为 sky 

  `:s/vivian/sky/`

- 替换`当前行`的`所有的` vivian 为 sky 

  `:s/vivian/sky/g`

- 替换`每一行`的`第一个` vivian 为 sky 

  `:%s/vivian/sky/`

- 替换`每一行`的`所有的` vivian 为 sky 

  `:%s/vivian/sky/g`

### 删除文本

删除掉的文本会存放在剪贴板中

- 删除光标所在行

  `dd`

- 删除光标位置到行尾的内容

  `D`

### 复制文本

- 将剪贴板中的内容复制到光标后

  `p`

- 将光标所在行复制到剪贴板

  `yy`

### 撤销操作

`u`

### 保存退出文本

- 保存并退出

  `:wq`

- 保存并强制退出

  `:wq!`

- 不保存退出

  `q`

- 不保存强制退出

  `q!`

### 光标移动

- 移动到文件开头

  `gg`

- 移动到文件末尾

  `G`

- 移动到指定行

  `nG`, n为行数

# 文本处理命令

在 Linux 中，文本处理无非是对文本内容做查看、修改等操作。本章将介绍Linux中常用的文本处理命令，以及被称为Linux三剑客的 `grep`、`sed` 和 `awk` 命令。

## cat

快速查看文本的全部内容(因此cat 命令适合查看不太大的文件),也可以进行合并文件

示例

- 查看文件

  `cat a.txt`

- 合并文件

  `cat a.txt b.txt > c.txt`

## more

可以分页显示文本文件的内容

示例

- 基本操作

  `more anaconda-ks.cfg`

- 从第 n 行开始显示文件内容，n 代表数字

  `more +n anaconda-ks.cfg`

交互命令

- 退出文件查看

  `q`

- 向下移动一行

  `回车键`

- 向下移动一页

  `空格键`

- 向上移动半页

  `d`

- 向上移动一页

  `b`

## less

可以分页显示文本文件的内容,和more命令的功能相似,但是更加强大

示例

- 基本操作

  `less /boot/grub/grub.cfg`

- 显示百分比

  `less -m /boot/grub/grub.cfg`

交互命令

> 要先输入一个`:`

- 向上移动一页

  `【PgUp】键`

- 向下移动一页

  `【PgDn】键`

- 向下移动一行

  `j`

- 向上移动一行

  `k`

- 移动至最后一行

  `G`

- 移动到第一行

  `g`

- 向下搜索“字符串”

  `/字符串`

- 向上搜索“字符串”

  `?字符串`

- 退出 less 命令

  `ZZ`

## head

查看文件前几行的内容

示例

- 查看前20行的内容

  `head -n 20 anaconda-ks.cfg`

## tail

查看文件后几行的内容

示例

- 查看文件后3行的内容

  `tail -n 3 /etc/passwd`

- 监听文件变动,并实时显示

  `tail -f anaconda-ks.cfg`

## grep

从文件中找到包含指定信息的那些行,支持正则表达式

基本格式

```cmd
[root@localhost ~]# grep [选项] 模式 文件名
```

选项

| 选项 | 含义                                                       |
| ---- | ---------------------------------------------------------- |
| `-c` | 仅列出文件中`包含模式的行数`。                             |
| `-i` | 忽略模式中的字母大小写。                                   |
| `-l` | 列出带有匹配行的文件名。                                   |
| `-n` | 在每一行的最前面列出行号。                                 |
| `-v` | 列出没有匹配模式的行。                                     |
| `-w` | 把表达式当做一个完整的单字符来搜寻，忽略那些部分匹配的行。 |

示例

- 例1

  假设有一份 emp.data 员工清单，现在要搜索此文件，找出职位为 CLERK 的所有员工，则执行命令如下：

  ```cmd
  [root@localhost ~]# grep CLERK emp.data
  #忽略输出内容
  ```

  而在此基础上，如果只想知道职位为 CLERK 的员工的人数，可以使用“`-c`”选项，执行命令如下：

  ```cmd
  [root@localhost ~]# grep -c CLERK emp.data
  #忽略输出内容
  ```

- 例2

  搜索 emp.data 文件，使用正则表达式找出以 78 开头的数据行，执行命令如下：

  ```cmd
  [root@localhost ~]# grep ^78 emp.data
  #忽略输出内容
  ```

  > **正则表达式**是描述一组字符串的一个模式，正则表达式的构成模仿了数学表达式，通过使用操作符将较小的表达式组合成一个新的表达式。正则表达式可以是一些纯文本文字，也可以是用来产生模式的一些特殊字符。为了进一步定义一个搜索模式，grep 命令支持如表  所示的这几种正则表达式的元字符（也就是通配符）。
  >
  > | 通配符   | 功能                                                |
  > | -------- | --------------------------------------------------- |
  > | `c*`     | 将匹配 0 个（即空白）或多个字符 c（c 为任一字符）。 |
  > | `.`      | 将匹配任何一个字符，且只能是一个字符。              |
  > | `[xyz]`  | 匹配方括号中的任意一个字符。                        |
  > | `[^xyz]` | 匹配除方括号中字符外的所有字符。                    |
  > | `^`      | 锁定行的开头。                                      |
  > | `$`      | 锁定行的结尾。                                      |
  >
  > > 需要注意的是，在基本正则表达式中，如通配符 *、+、{、|、( 和 )等，已经失去了它们原本的含义，而若要恢复它们原本的含义，则要在之前添加反斜杠 \，如 \*、\+、\{、\|、\( 和 \)。

# rpm和yum

像CenterOS就是用yum当作包管理工具的，而Ubuntu是使用apt当作包管理工具的。



linux的安装包

- 源码包

  源码包就是一大堆源代码程序,还未进行编译,所以安装的时候需要先编译后安装

- 二进制包

  二进制包就是编译好的文件,可以直接进行安装; 这也是linux下默认的软件安装包

  主流的二进制包管理系统：rpm

  > RPM 包管理系统：功能强大，安装、升级、査询和卸载非常简单方便

## rpm包的命令规则

命令的一般格式

```cmd
包名-版本号-发布次数-发行商-Linux平台-适合的硬件平台-包扩展名
```

示例

> RPM 包的名称是`httpd-2.2.15-15.el6.centos.1.i686.rpm`

- httped：软件包名。这里需要注意，httped 是包名，而 httpd-2.2.15-15.el6.centos.1.i686.rpm 通常称为包全名，包名和包全名是不同的，在某些 Linux 命令中，有些命令（如包的安装和升级）使用的是包全名，而有些命令（包的查询和卸载）使用的是包名，一不小心就会弄错。

- 2.2.15：包的版本号，版本号的格式通常为`主版本号.次版本号.修正号`。

- 15：二进制包发布的次数，表示此 RPM 包是第几次编程生成的。

- el*：软件发行商，el6 表示此包是由 Red Hat 公司发布，适合在 RHEL 6.x (Red Hat Enterprise Unux) 和 CentOS 6.x 上使用。

- centos：表示此包适用于 CentOS 系统。

- i686：表示此包使用的硬件平台

- rpm：RPM 包的扩展名，表明这是编译好的二进制包，可以使用 rpm 命令直接安装。此外，还有以 src.rpm 作为扩展名的 RPM 包，这表明是源代码包，需要安装生成源码，然后对其编译并生成 rpm 格式的包，最后才能使用 rpm 命令进行安装。

## rpm包管理软件

### 安装软件

命令格式

```cmd
[root@localhost ~]# rpm -ivh 包全名
```

选项

- -i：安装（install）;
- -v：显示更详细的信息（verbose）;
- -h：打印 #，显示安装进度（hash）;

示例

- 安装apache

  `rpm -ivh /mnt/cdrom/Packages/httpd-2.2.15-15.el6.centos.1.i686.rpm`

- 一次性安装多个安装包

  `rpm -ivh a.rpm b.rpm c.rpm`

默认的安装路径

| 安装路径          | 含 义                      |
| ----------------- | -------------------------- |
| `/etc/`           | 配置文件安装目录           |
| `/usr/bin/`       | 可执行的命令安装目录       |
| `/usr/lib/`       | 程序所使用的函数库保存位置 |
| `/usr/share/doc/` | 基本的软件使用手册保存位置 |
| `/usr/share/man/` | 帮助文件保存位置           |

### 操作软件

命令格式

```cmd
[root@localhost ~]# service 服务名 start|stop|restart|status
```

参数含义

- start：启动服务；
- stop：停止服务；
- restart：重启服务；
- status: 查看服务状态；

示例

- 启动apache

  `service httpd start `

### 升级软件

命令格式

```cmd
[root@localhost ~]# rpm -Uvh 包全名
```

### 卸载软件

命令格式

```cmd
[root@localhost ~]# rpm -e 包名
```

注意事项

- 在卸载软件时,需要先卸载依赖的包,才能卸载该软件

### 查看已经配置好的命令的安装路径

`witch 命令`

### 查询软件信息

- 查询是否安装

  命令格式

  ```cmd
  [root@localhost ~]# rpm -q 包名
  ```

  > 注意这里使用的是包名，而不是包全名。

  示例

  - 查看是否安装 apache

    `rpm -q httpd`

- 查询所有安装的软件

   示例

  - 基本使用

    `rpm -qa`

  - 使用管道符过滤

    `rpm -qa | grep httpd`

- 查询软件的详细信息

  基本格式

  ```cmd
  [root@localhost ~]# rpm -qi 包名
  ```

  示例

  - 查询apache的详细信息

    `rpm -qi httpd`

- 查询未安装软件的信息

  命令格式

  ```cmd
  [root@localhost ~]# rpm -qip 包全名
  ```

### 查询软件的文件路径

查询已安装软件包中包含的所有文件及各自安装路径

- 查看已安装软件的文件路径

  命令格式

  ```cmd
  [root@localhost ~]# rpm -ql 包名
  ```

  示例

  - 查看apache的所有文件安装路径

    `rpm -ql httpd`

- 查看未安装软件的预安装路径

  命令格式

  ```cmd
  [root@localhost ~]# rpm -qlp 包全名
  ```

  示例

  - 查看bing软件包(未安装)

    `rpm -qlp /mnt/cdrom/Packages/bind-9.8.2-0.10.rc1.el6.i686.rpm`

### 查询文件属于哪个软件

rpm 支持反向查询，即查询某系统文件所属哪个 RPM 软件包

命令格式

```cmd
[root@localhost ~]# rpm -qf 系统文件名
```

示例

- 查询ls命令所属的软件包

  `rpm -qf /bin/ls`

## yum源及配置

yum是一种可自动安装软件包（自动解决包之间依赖关系）的安装方式

- 查看yum是否已安装

  `rpm -qa | grep yum`

  [如果没有安装yum,可以使用rpm进行安装yum](https://jingyan.baidu.com/article/e3c78d6483a02a3c4d85f578.html)

设置yum源

> yum 源指的就是软件安装包的来源。

- 网络yum源

  网络 yum 源配置文件位于 /etc/yum.repos.d/ 目录下，文件扩展名为"*.repo"（只要扩展名为 "*.repo" 的文件都是 yum 源的配置文件）。通常情况下 CentOS-Base.repo 文件生效

  打开CentOS-Base.repo文件

  ```cmd
  [root@localhost yum.repos.d]# vim /etc/yum.repos.d/ CentOS-Base.repo
  [base]
  name=CentOS-$releasever - Base
  mirrorlist=http://mirrorlist.centos.org/? release= $releasever&arch=$basearch&repo=os
  baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/
  gpgcheck=1
  gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
  …省略部分输出…
  ```

  参数含义

  - [base]：容器名称，一定要放在[]中。
  - name：容器说明，可以自己随便写。
  - mirrorlist：镜像站点，这个可以注释掉。
  - baseurl：我们的 yum 源服务器的地址。默认是 CentOS 官方的 yum 源服务器，是可以使用的。如果你觉得慢，则可以改成你喜欢的 yum 源地址。
  - enabled：此容器是否生效，如果不写或写成 enabled 则表示此容器生效，写成 enable=0 则表示此容器不生效。
  - gpgcheck：如果为 1 则表示 RPM 的数字证书生效；如果为 0 则表示 RPM 的数字证书不生效。
  - gpgkey：数字证书的公钥文件保存位置。不用修改。

- 本地yum源

  在无法联网的情况下，yum 可以在本地直接安装映像文件

  用到再参考网上教程

## yum基本命令

### 安装软件

`yum -y install 包名`

示例

- 安装gcc

  `yum -y install gcc`

### 升级软件

示例

- 升级所有软件包

  `yum -y update`

- 升级对应软件

  `yum -y update 包名`

### 卸载软件

> 使用yum进行卸载会把卸载软件依赖的所有包都会卸载掉,所以要谨慎使用

` yum remove 包名`

### 其他操作

- 查询所有已安装软件

  `yum list`

- 查询对应软件

  `yum list 包名`

- 从yum源服务器上查询软件包

  `yum search 关键字`

- 查询软件包的详细信息

  `yum info 包名`

### 软件安装常用命令

查询软件

- `yum search 关键字`

安装软件

- `yum install 软件名`

常用软件安装:

- 安装python: `yum install python36`
- 安装gcc: `yum install gcc`
- 安装git: `yum install git`

# 用户和用户组管理

## 原理和文件解释

**用户**

- 每个用户都有唯一的用户名和密码。在登录系统时，只有正确输入用户名和密码，才能进入系统和自己的主目录。

**用户组**

- 用户组是具有相同特征用户的逻辑集合
- 在同一个用户组里的用户都具有该用户组所持有的权限

**两者关系**

1. 一对一：一个用户可以存在一个组中，是组中的唯一成员；
2. 一对多：一个用户可以存在多个用户组中，此用户具有这多个组的共同权限；
3. 多对一：多个用户可以存在一个组中，这些用户具有和组相同的权限；
4. 多对多：多个用户可以存在多个组中，也就是以上 3 种关系的扩展。

**用户ID(UID)和用户组ID(GID)**

- 所有用户的名称与 ID 的对应关系都存储在 /etc/passwd 文件中

  > 说白了，用户名并无实际作用，仅是为了方便用户的记忆而已。

- 在 /etc/passwd 文件中，利用 UID 可以找到对应的用户名；在 /etc/group 文件中，利用 GID 可以找到对应的群组名。

**/etc/passwd内容解释**

- 是系统用户配置文件，存储了系统中所有用户的基本信息

  内容如下

  ```cmd
  [root@localhost ~]# vi /etc/passwd
  #查看一下文件内容
  root:x:0:0:root:/root:/bin/bash
  bin:x:1:1:bin:/bin:/sbin/nologin
  daemon:x:2:2:daemon:/sbin:/sbin/nologin
  adm:x:3:4:adm:/var/adm:/sbin/nologin
  ...省略部分输出...
  ```

  每行用户信息都以 "：" 作为分隔符，划分为 7 个字段，每个字段所表示的含义如下：

  >  用户名：密码：UID（用户ID）：GID（组ID）：描述性信息：主目录：默认Shell

  - 用户名: 一串代表用户身份的字符串,方便用户记忆

  - 密码: "x" 表示此用户设有密码，但不是真正的密码，真正的密码保存在 `/etc/shadow` 文件中

  - UID: 用户 ID

  - GID: 用户初始组的组 ID 

    > 初始组指用户登陆时就拥有这个用户组的相关权限

  - 描述性信息: 不重要

  - 主目录: 用户登录后有操作权限的访问目录

  - 默认shell: 我也不知道

**/etc/shadow内容解析**

- 用于存储 Linux 系统中用户的密码信息

  /etc/shadow 文件只有 root 用户拥有读权限，其他用户没有任何权限，这样就保证了用户密码的安全性。

  文件内容

  ```cmd
  [root@localhost ~]#vim /etc/shadow
  root: $6$9w5Td6lg
  $bgpsy3olsq9WwWvS5Sst2W3ZiJpuCGDY.4w4MRk3ob/i85fl38RH15wzVoom ff9isV1 PzdcXmixzhnMVhMxbvO:15775:0:99999:7:::
  bin:*:15513:0:99999:7:::
  daemon:*:15513:0:99999:7:::
  …省略部分输出…
  ```

  文件中每行代表一个用户，同样使用 ":" 作为分隔符，不同之处在于，每行用户信息被划分为 9 个字段

  `用户名：加密密码：最后一次修改时间：最小修改时间间隔：密码有效期：密码需要变更前的警告天数：密码过期后的宽限时间：账号失效时间：保留字段`

  每个字段含义如下:

  - 用户名: 一串好记忆的字符
  - 加密密码: 这里保存的是真正加密的密码, 采用的是 SHA512 散列加密算法
  - 最后一次修改时间: 计算日期的时间是以  1970 年 1 月 1 日作为 1 不断累加得到的时间
  - 最小修改时间间隔: 如果是 0，则密码可以随时修改；如果是 10，则代表密码修改后 10 天之内不能再次修改密码
  - 密码有效期: 该字段的默认值为 99999，也就是 273 年，可认为是永久生效。如果改为 90，则表示密码被修改 90 天之后必须再次修改，否则该用户即将过期。
  - 密码需要变更前的警告天数: 该字段的默认值是 7
  - 密码过期后的宽限天数: 此字段规定的宽限天数是 10，则代表密码过期 10 天后失效；如果是 0，则代表密码过期后立即失效；如果是 -1，则代表密码永远不会失效。
  - 账号失效时间: ...
  - 保留: ...
  - 忘记密码怎么办: 对于普通账户可以通过 root 账户重置密码; 如果 root 账号的密码遗失，则需要重新启动进入单用户模式，系统会提供 root 权限的 bash 接口，此时可以用 passwd 命令修改账户密码；

**/etc/group文件解析**

- 是用户组配置文件，即用户组的所有信息都存放在此文件中。

  此文件是记录组 ID（GID）和组名相对应的文件

  文件内容

  ```cmd
  [root@localhost ~]#vim /etc/group
  root:x:0:
  bin:x:1:bin,daemon
  daemon:x:2:bin,daemon
  …省略部分输出…
  lamp:x:502:
  ```

  各用户组中，还是以 "：" 作为字段之间的分隔符，分为 4 个字段

  `组名：密码：GID：该用户组中的用户列表`

  每个字段对应的含义为：

  - 组名: 用户组的名称
  - 组密码:  "x" 仅仅是密码标识，真正加密后的组密码默认保存在 /etc/gshadow 文件中
  - 组ID(GID): 群组的 ID 号
  - 组中的用户: 此字段列出每个群组包含的所有用户

**用户和用户组的关系的总结**

- 到此，我们已经学习了/etc/passwd、/etc/shadow、/etc/group，它们之间的关系可以这样理解，即先在 /etc/group 文件中查询用户组的 GID 和组名；然后在 /etc/passwd 文件中查找该 GID 是哪个用户的初始组，同时提取这个用户的用户名和 UID；最后通过 UID 到 /etc/shadow 文件中提取和这个用户相匹配的密码。

**/ect/gshadow文件内容解析**

- 组用户信息存储在 /etc/group 文件中，而`将组用户的密码信息存储在 /etc/gshadow 文件中`。

  文件内容

  ```cmd
  [root@localhost ~]#vim /etc/gshadow
  root:::
  bin:::bin, daemon
  daemon:::bin, daemon
  ...省略部分输出...
  lamp:!::
  ```

  文件中，每行代表一个组用户的密码信息，各行信息用 ":" 作为分隔符分为 4 个字段，每个字段的含义如下：

  `组名：加密密码：组管理员：组附加用户列表`

  字段的具体含义

  - 组名

    同 /etc/group 文件中的组名相对应。

  - 组密码

    对于大多数用户来说，通常不设置组密码，因此该字段常为空，但有时为 "!"，指的是该群组没有组密码，也不设有群组管理员。

  - 组管理员

    从系统管理员的角度来说，该文件最大的功能就是创建群组管理员。

    考虑到 Linux 系统中账号太多，而超级管理员 root 可能比较忙碌，因此当有用户想要加入某群组时，root 或许不能及时作出回应。这种情况下，如果有群组管理员，那么他就能将用户加入自己管理的群组中，也就免去麻烦 root 了。

    不过，由于目前有 sudo 之类的工具，因此群组管理员的这个功能已经很少使用了。

  - 组中的附加用户

    该字段显示这个用户组中有哪些附加用户，和 /etc/group 文件中附加组显示内容相同

**/ect/login.defs(创建用户的默认设置文件)**

- 对用户的一些基本属性做默认设置

## 常用命令

### useradd

添加新的系统用户

- 创建用户的原理

  > 系统首先读取 /etc/login.defs 和 /etc/default/useradd，根据这两个配置文件中定义的规则添加用户，也就是向 /etc/passwd、/etc/group、/etc/shadow、/etc/gshadow 文件中添加用户数据，接着系统会自动在 /etc/default/useradd 文件设定的目录下建立用户主目录，最后复制 /etc/skel 目录中的所有文件到此主目录中，由此，一个新的用户就创建完成了。

- 命令格式

  `useradd [选项] 用户名`

- 示例

  - 创建lamp普通用户

    `useradd lamp`

  - 在建立用户lamp1的同时，指定了UID（550）、初始组（lamp1）、附加组（root）、家目录（/home/lamp1/）、用户说明（test user）和用户登录Shell（/bin/bash）

    `useradd -u 550 -g lamp1 -G root -d /home/lamp1 -c "test user" -s /bin/bash lamp1`

### passwd

修改用户密码

- 命令格式

  ```cmd
  [root@localhost ~]# passwd [选项] 用户名
  ```

- 示例

  - 使用 root 账户修改 lamp 普通用户的密码

    `passwd lamp`

  - 修改当前系统已登入用户的密码

    `passwd`

### usermod

修改用户信息

- 命令格式

  ```
  [root@localhost ~]# usermod [选项] 用户名
  ```

- 示例

  - 锁定用户

    `usermod -L lamp`

  - 解锁用户

    `usermod -U lamp`

  - 把用户加入root组

    `usermod -G root lamp`

  - 修改用户说明

    `usermod -c "test user" lamp `

### userdel

删除用户的相关数据,此命令只有root用户才能使用

原理

- 该命令就是删除存在下列文件中的用户数据
- 用户基本信息: 在 /etc/passwd 文件中
- 用户密码信息: 在 /etc/shadow 文件中；
- 用户群组基本信息：在 /etc/group 文件中；
- 用户群组信息信息：在 /etc/gshadow 文件中；
- 用户个人文件：主目录默认位于 /home/用户名，邮箱位于 /var/spool/mail/用户名。

基本格式

```cmd
[root@localhost ~]# userdel -r 用户名
```

示例

- 删除lamp用户

  `userdel -r lamp`

### id

查看用户的UID,GID和附加组的信息

命令格式

```cmd
[root@localhost ~]# id 用户名
```

示例

- 查看lamp用户的信息

  `id lamp`

### su

用户切换

命令格式

```cmd
[root@localhost ~]# su [选项] 用户名
```

示例

- 切换root用户,并且切换环境变量

  `su -root`

## 用户组命令

### groupadd

添加用户组

命令格式

```cmd
[root@localhost ~]# groupadd [选项] 组名
```

示例

- 创建新群组

  `groupadd group1`

### groupmod

修改用户组

命令格式

```cmd
[root@localhost ~]# groupmod [选现] 组名
```

示例

- 把组名group1修改为testgrp

  `groupmod -n testgrp group1`

### groupdel

删除用户组

命令格式

```cmd
[root@localhost ~]# groupdel 组名
```

示例

- 删除group1

  `groupdel group1`

### gpasswd

把用户添加进组或从组中删除

命令格式

```cmd
[root@localhost ~]# gpasswd 选项 组名
```

示例

- 设置密码

  `gpasswd group1 `

- 加入群组管理员为lamp

  `gpasswd -A lamp group1`

- 将用户lamp1加入到group1群组

  `gpasswd -a lamp1 group1`

### newgrp

切换用户的有效组

有点复杂,用到了再说...

# 权限管理

权限管理，就是指对不同的用户，设置不同的文件访问权限，包括对文件的读、写、删除等

## chagrp

修改文件和目录的所属组

命令格式

```cmd
[root@localhost ~]# chgrp [-R] 所属组 文件名/目录名
```

示例

- 修改install.log文件的所属组为group1

  `chgrp group1 install.log`

  > 要被改变的所属组必须是真实存在的

  查看是否更改生效

  ```cmd
  [root@localhost ~]# ll install.log
  -rw-r--r--. 1 root group1 78495 Nov 17 05:54 install.log
  #修改生效
  ```

## chown

修改文件（或目录）的所有者, 也可以修改文件（或目录）的所属组

修改所有者

- 命令格式

  ```cmd
  [root@localhost ~]# chown [-R] 所有者 文件或目录
  ```

同时修改所有者和所属组

- 命令格式

  ```cmd
  [root@localhost ~]# chown [-R] 所有者:所属组 文件或目录
  ```

示例

- 修改文件的所有者

  `chown 用户名 文件名`

  查看修改情况

  ```cmd
  [root@localhost ~]# ll file
  -rw-r--r--. 1 user root 0 Apr 17 05:12 file
  #所有者变成了user用户，这时user用户对这个文件就拥有了读、写权限
  ```

## 权限位

linux使用r表示对文件有读的权限,w表示对文件有写的权限,x表示对文件有可以执行的权限

示例

```cmd
[root@localhost ~]# ls -al
-rw-r--r--.   1    root   root       24   Jan  6  2007 .bash_logout
```

每行的第一列表示各个文件针对不同用户设定的权限,一共是11位

- 第一位表示文件的具体类型
- 最后一位表示安全规则管理
- 剩下的中间9位就是对应的不同权限

文件权限位如图所示

![文件权限位](/Users/yingjie.lu/Documents/note/.img/2-1Z41G11439421.gif)

linux将访问文件的用户分为3类,分别是文件的所有者,所属组以及其他人

- 每种类别中的权限最多为`rwx`,即读,写和执行的权限都具备

## chmod(*)

修改文件的权限

chmod 命令基本格式

```cmd
[root@localhost ~]# chmod [-R] 权限值 文件名
```

使用数字修改文件权限

- 原理

  权限对应数字

  - 在Linux中,各个权限与数字的对应关系如下

    ```cmd
    r --> 4
    w --> 2
    x --> 1
    ```

  - 以 `rwxrw-r-x` 为例,所有者、所属组和其他人分别对应的权限值为：

    ```cmd
    所有者 = rwx = 4+2+1 = 7
    所属组 = rw- = 4+2 = 6
    其他人 = r-x = 4+1 = 5
    ```

    > 所以，此权限对应的权限值就是 765

- 示例

  - 修改 .bashrc 目录文件的权限(rwxrwxrwx)

    `chmod 777 .bashrc`

使用字母修改文件权限

- 原理

  - chmod 命令中用 `u、g、o` 分别代表 3 种身份(所有者、所属组和其他人),使用`a`表示全部的身份

  - chmod 命令中用 `+、-、=`分别表示加入,删除,设定对应的权限

  - 如图所示

    ![chmod 命令基本格式](/Users/yingjie.lu/Documents/note/.img/2-1Z41G31209649.gif)

- 示例

  - 设定 .bashrc 文件的权限为 rwxr-xr-x

    `chmod u=rwx,go=rx .bashrc`

  - 添加.bashrc 文件对所有用户的写权限

    `chmod a+w .bashrc`

## umask

修改默认新建文件或目录的权限

示例

- 修改权限(暂时有效)

  `umask 002`

  > 这种方式修改的 umask 只是临时有效

- 修改权限(长期有效)

  > 修改对应的环境变量配置文件 /etc/profile

## charttr

专门用来修改文件或目录的隐藏属性，只有 root 用户可以使用。

命令格式

```cmd
[root@localhost ~]# chattr [+-=] [属性] 文件或目录名
```

> 表示给文件或目录添加属性，- 表示移除文件或目录拥有的某些属性，= 表示给文件或目录设定一些属性

示例

- 设置文件不允许被删除

  `chattr +i ftest`

## lsattr

查看文件或目录的隐藏属性

命令格式

```cmd
[root@localhost ~]# lsattr [选项] 文件或目录名
```

示例

`lsattr attrtest`

## sudo

可以让普通用户切换到 root 身份去执行某些特权命令

命令格式

```cmd
[root@localhost ~]# sudo [-b] [-u 新使用者账号] 要执行的命令
```

选项

- -b  ：将后续的命令放到背景中让系统自行运行，不对当前的 shell 环境产生影响。
- -u  ：后面可以接欲切换的用户名，若无此项则代表切换身份为 root 。
- -l：此选项的用法为 sudo -l，用于显示当前用户可以用 sudo 执行那些命令。

# 文件系统管理

linux采用Ext文件系统,属于索引式文件系统

文件系统将文件的实际内容和属性分开存放

- 文件的属性保存在inode(i节点)中,每个inode都有自己的编号; 每个文件各占用一个inode; inode中还记录着文件数据所有block块的编号

- 文件的实际内容保存在block中(数据块),每个block都有自己的编号,当文件太大时,可能会占用多个block块

- 还有一个super block(超级块)用于记录整个文件系统的整体信息,包括inode和block的总量、已使用量和剩余量，以及文件系统的格式和相关信息

- 如图所示

  灰色是inode，蓝色是block（inode相当于是block的索引）

  ![文件系统的数据存取示意图](/Users/yingjie.lu/Documents/note/.img/2-1Z423102309629.gif)

## df

查看系统中各文件系统的硬盘使用情况

与整个文件系统有关的数据，都保存在 Super block（超级块）中，所以 df 命令主要是从各文件系统的 Super block 中读取数据

命令格式

```cmd
[root@localhost ~]# df [选项] [目录或文件名]
```

示例

- 基本使用

  `df`

- 以GB或MB的单位显示

  `df -h`

- 查看某个文件或目录

  `df -h /etc`

## du

统计目录或文件所占磁盘空间大小的命令

命令格式

```cmd
[root@localhost ~]# du [选项] [目录或文件名]
```

示例

- 基本使用

  `du`

- 统计当前目录的总大小(包括所有子文件和子目录)

  `du -a`

- 只统计磁盘占用量

  `du -sh`

## 其他命令

- mount

  查询已挂载的设备信息

  示例

  - 显示系统已挂载的设备信息

    `mount`

- umount

  卸载已挂载的硬件设备

  命令格式

  ```cmd
  [root@localhost ~]# umount 设备文件名或挂载点
  ```

  示例

  - 卸载U盘

    `umount /mnt/usb`

  - 卸载光盘

    `umount /mnt/cdrom`

- fsck

  检查文件系统并尝试修复出现的错误

  命令格式

  ```cmd
  [root@localhost ~]# fsck [选项] 分区设备文件名
  ```

  示例

  - 修复某个分区

    `fsck -r /dev/sdb1`

- fdisk

  给硬盘进行分区

- parted

  对硬盘进行快速的分区

- mkfs

  对硬盘分区进行格式化

  命令格式

  ```cmd
  [root@localhost ~]# mkfs [-t 文件系统格式] 分区设备文件名
  ```

# 启动管理

linux系统的启动过程

- BIOS自检,找到第一个可以启动的设备(一般是硬盘)
- 读取奥启动设备的MBR(主引导记录),启动GRUB(引导程序)
- 加载内核
- 启动系统的第一个进行(/sbin/init)
- 通过/sbin/init的一些配置文件的调用,配置好系统的初始环境
- 如果是字符界面启动,就可以看到登入界面了; 如果是图形界面启动,就调用想用的X Window接口

启动过程总结

- `BIOS自检 -> 启动 GRUB -> 加载内核 -> 执行第一个进程 -> 配置系统初始环境`

完整的启动流程图

![img](/Users/yingjie.lu/Documents/note/.img/2-1Q02310563a22.jpg)

## BIOS

基本输入/输出系统

> BIOS是固化在主板上的一个ROM(只读存储器)芯片上的程序,主要保存计算机的基本输入/输出信息,系统设置信息,开机自检程序和系统自启动程序,用来为计算机提供最底层和最直接的硬件设置和控制

BIOS初始化工作

- 第一次检查计算机硬件和外围设备,例如CPU、内存、风扇等
- 如果自检没问题，BIOS就开始对硬件进行初始化，并规定当前可启动设备的先后顺序，选择有哪个设备来开机
- 选择好设备后，就会从该设备的MBR（主引导目录）中读取Boot Loader（启动引导程序）并执行。启动引导程序用于引导操作系统启动

当MBR被加载到RAM之后，BIOS就会将控制权交给MBR，进入系统引导的第二阶段

## MBR主引导目录

MBR就是主引导记录，位于硬盘的 0 磁道、0 柱面、1 扇区中，主要记录了启动引导程序和磁盘的分区表。

如图是 MBR 的结构

![img](/Users/yingjie.lu/Documents/note/.img/2-1Q0221G321149.jpg)

MBR 中最主要的功能就是存储启动引导程序，启动引导程序最主要的作用就是加载操作系统的内核

启动引导程序的作用

![img](/Users/yingjie.lu/Documents/note/.img/2-1Q0221G60U34.jpg)

## 内核的加载过程

当GRUB加载了内核之后，内核就接管了linux的启动过程

内核完成再次系统自检之后，开始采用动态的方式加载每个硬件的模块

Linux的内核是放在/boot的启动目录中的

Linux 会把不重要的功能编译成内核模块，在需要时再调用，从而保证了内核不会过大

- 会把硬件的驱动程序编译为模块， 这些模块保存在 /lib/modules 目录中
- 一些特殊的文件系统（如 LVM、RAID 等）的驱动，都是以模块的方式来保存的

内核启动流程如图

![img](/Users/yingjie.lu/Documents/note/.img/2-1Q023093PD60.jpg)

## 主要的配置文件

- /sbin/init

  初始化系统环境，包括系统的主机名、网络设定、语言、文件系统格式及其他服务的启动等。

- /etc/inittab

  用来设置系统的默认运行级别

- /etc/rc.d/rc.local

  在每次系统启动时，都会执行一次该配置文件中的内容（可以在该文件中设置开始启动哪些软件等）

# 系统服务管理

## 系统服务

系统服务是运行在后台的应用程序，即守护进程（为了实现服务、功能的进程）

例如apache服务就是用来实现web服务的，我们是通过httpd这个守护进程来启动apache服务的

服务的分类如图所示

![img](/Users/yingjie.lu/Documents/note/.img/2-1Q02413195AP.jpg)

> - 独立服务: 可以自行启动，而不用依赖其他的管理服务,响应请求更快速
> - 基于 xinetd 的服务: 不能独立启动，需要依靠管理服务来调用

查询已经安装的服务和区分服务

命令格式

```cmd
[root@localhost ~]# chkconfig --list [服务名]
```

## 端口

服务与端口的对应文件是 /etc/services

通过端口查询系统中已经启动的服务

- 命令格式

  ```cmd
  [root@localhost ~]# netstat 选项
  ```

- 选项
  - -a：列出系统中所有网络连接，包括已经连接的网络服务、监听的网络服务和 Socket 套接字；
  - -t：列出 TCP 数据；
  - -u：列出 UDF 数据；
  - -l：列出正在监听的网络服务（不包含已经连接的网络服务）；
  - -n：用端口号来显示而不用服务名；
  - -p：列出该服务的进程 ID (PID)；
  
- 示例

  - 查看80端口被谁占用

    `netstat -lnp|grep 80`

## 独立服务的启动管理

使用/etc/init.d/目录中的启动脚本来启动独立的服务

- 命令格式

  ```cmd
  [root@localhost ~]#/etc/init.d独立服务名 start| stop|status|restart|...
  ```

- 示例

  - 启动httpd

    `/etc/init.d/httpd start`

使用service命令来启动独立的服务

- 命令格式

  ```cmd
  [root@localhost ~]# service 独立服务名 start|stop|restart|...
  ```

- 示例

  - 重启httpd

    `service httpd restart`

  - 列出所有独立服务的启动状态

    `service --status -all`

自启动管理

- 修改 /etc/rc.d/rc.local 文件，设置服务自启动

- 示例

  - 修改/etc/rc.d/rc.local文件

    `vi /etc/rc.d/rc.local`

  - 在文件最后加入要apache的启动命令即可

    `/etc/rc.d/init.d/httpd start`

## 系统防火墙

centos6.0

- 默认安装的是iptables

- 操作

  ```cmd
  service iptables start # 启动
  service iptables restart # 重启
  service iptables stop # 禁用
  service iptables status # 查看iptables的状态
  netstat -a # 查看所有服务端口
  vi /etc/sysconfig/iptables # 编辑iptables开放的服务端口
  ```

centos7.0

- 默认安装的是firewalld

- 操作

  ```cmd
  systemctl start firewalld # 启动
  firewall-cmd --reload # 重启
  systemctl stop firewalld # 禁用
  systemctl enable firewalld # 设置开机启动
  sytemctl disable firewalld # 停用并禁止开机启动
  firewall-cmd --state # 查看防火墙状态
  firewall-cmd --version # 查看版本
  firewall-cmd --list-ports # 查看已经开启的端口
  ```

  添加端口

  ```cmd
  firewall-cmd --zone=public --add-port=3306/tcp --permanent
  firewall-cmd --reload # 需要重启防火墙
  ```

  删除端口

  ```cmd
  firewall-cmd --zone=public --remove-port=3306/tcp --permanent
  firewall-cmd --reload # 需要重启防火墙
  ```

# 系统管理

在Linux中使用任务管理器进行进程管理

- 利用应用程序和进程标签来查看系统中运行的所有进程
- 利用性能和用户标签来判断服务器的健康状态
- 在应用程序和进程标签中强制终止任务和进程

## ps

查看系统中所有运行进程的详细信息

命令格式

```cmd
[root@localhost ~]# ps [选项]
#查看系统中所有的进程，使用 Linux 标准命令格式
```

选项

- a：显示一个终端的所有进程，除会话引线外；
- u：显示进程的归属用户及内存的使用情况；
- x：显示没有控制终端的进程；
- -l：长格式显示更加详细的信息；
- -e：显示所有进程；

示例

- 查看所有进程

  `ps aux`

- 查看所有进程,并查看进程的父进程的PID和进程的优先级

  `ps -le`

- 只查看当前shell产生的进程

  `ps -l`

ps命令输入信息的含义

- 示例

  ```cmd
  [root@localhost ~]# ps aux
  #查看系统中所有的进程
  USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND
  root 1 0.0 0.2 2872 1416 ? Ss Jun04 0:02 /sbin/init
  ```

- 含义

  - USER: 该进程是由哪个用户产生的
  - PID: 进程的ID
  - %CPU: 进程占用CPU资源的百分比
  - %MEM: 进程占用物理内存的大小,单位为KB
  - VSZ: 进程占用虚拟内存的大小,单位为KB
  - RSS: 进程占用实际物理内存的大小,单位为KB
  - TTY: 进程是在哪个终端运行的
  - STAT: 进程状态
    - -D：不可被唤醒的睡眠状态，通常用于 I/O 情况。
    - -R：该进程正在运行。
    - -S：该进程处于睡眠状态，可被唤醒。
    - -L：被锁入内存。
    - -s：包含子进程。
    - -l：多线程（小写 L）。
    - -+：位于后台。

  - START: 进程的启动时间
  - TIME: 进程占用CPU的运算时间
  - COMMAND: 产生此进程的命令

## top

持续监听进程运行状态

命令格式

```cmd
[root@localhost ~]#top [选项]
```

选项

- -d 秒数：指定 top 命令每隔几秒更新。默认是 3 秒；
- -b：使用批处理模式输出。一般和"-n"选项合用，用于把 top 命令重定向到文件中；
- -n 次数：指定 top 命令执行的次数。一般和"-"选项合用；
- -p 进程PID：仅查看指定 ID 的进程；
- -s：使 top 命令在安全模式中运行，避免在交互模式中出现错误；
- -u 用户名：只监听某个用户的进程；

交互操作

- ? 或 h：显示交互模式的帮助；
- P：按照 CPU 的使用率排序，默认就是此选项；
- M：按照内存的使用率排序；
- N：按照 PID 排序；
- T：按照 CPU 的累积运算时间排序，也就是按照 TIME+ 项排序；
- k：按照 PID 给予某个进程一个信号。一般用于中止某个进程，信号 9 是强制中止的信号；
- r：按照 PID 给某个进程重设优先级（Nice）值；
- q：退出 top 命令；

top的执行结果含义

- 示例

  ```cmd
  [root@localhost ~]# top
  top - 12:26:46 up 1 day, 13:32, 2 users, load average: 0.00, 0.00, 0.00
  Tasks: 95 total, 1 running, 94 sleeping, 0 stopped, 0 zombie
  Cpu(s): 0.1%us, 0.1%sy, 0.0%ni, 99.7%id, 0.1%wa, 0.0%hi, 0.1%si, 0.0%st
  Mem: 625344k total, 571504k used, 53840k free, 65800k buffers
  Swap: 524280k total, 0k used, 524280k free, 409280k cached
  ```

- 总共有5行数据

  - 第一行 top 任务队列信息

    | 内 容                         | 说 明                                                        |
    | ----------------------------- | ------------------------------------------------------------ |
    | 12:26:46                      | 系统当前时间                                                 |
    | up 1 day, 13:32               | 系统的已运行时间.本机己经运行 1 天 13 小时 32 分钟           |
    | 2 users                       | 当前登录了两个用户                                           |
    | load average: 0.00,0.00，0.00 | 系统在之前 1 分钟、5 分钟、15 分钟的平均负载。如果 CPU 是单核的，则这个数值超过 1 就是高负载：如果 CPU 是四核的，则这个数值超过 4 就是高负载 （这个平均负载完全是依据个人经验来进行判断的，一般认为不应该超过服务器 CPU 的核数） |

  - 第二行 Tasks 进程信息

    | 内 容           | 说 明                                          |
    | --------------- | ---------------------------------------------- |
    | Tasks: 95 total | 系统中的进程总数                               |
    | 1 running       | 正在运行的进程数                               |
    | 94 sleeping     | 睡眠的进程数                                   |
    | 0 stopped       | 正在停止的进程数                               |
    | 0 zombie        | 僵尸进程数。如果不是 0，则需要手工检查僵尸进程 |

  - 第三行 Cpu(s) CPU信息

    | 内 容           | 说 明                                                        |
    | --------------- | ------------------------------------------------------------ |
    | Cpu(s): 0.1 %us | 用户模式占用的 CPU 百分比                                    |
    | 0.1%sy          | 系统模式占用的 CPU 百分比                                    |
    | 0.0%ni          | 改变过优先级的用户进程占用的 CPU 百分比                      |
    | 99.7%id         | 空闲 CPU 占用的 CPU 百分比                                   |
    | 0.1%wa          | 等待输入/输出的进程占用的 CPU 百分比                         |
    | 0.0%hi          | 硬中断请求服务占用的 CPU 百分比                              |
    | 0.1%si          | 软中断请求服务占用的 CPU 百分比                              |
    | 0.0%st          | st（steal time）意为虚拟时间百分比，就是当有虚拟机时，虚拟 CPU 等待实际 CPU 的时间百分比 |

  - 第四行 Mem 物理内存信息

    | 内 容              | 说 明                                                        |
    | ------------------ | ------------------------------------------------------------ |
    | Mem: 625344k total | 物理内存的总量，单位为KB                                     |
    | 571504k used       | 己经使用的物理内存数量                                       |
    | 53840k&ee          | 空闲的物理内存数量。我们使用的是虚拟机，共分配了 628MB内存，所以只有53MB的空闲内存 |
    | 65800k buffers     | 作为缓冲的内存数量                                           |

  - 第五行 Swap 交换分区信息

    | 内 容               | 说 明                        |
    | ------------------- | ---------------------------- |
    | Swap: 524280k total | 交换分区（虚拟内存）的总大小 |
    | Ok used             | 已经使用的交换分区的大小     |
    | 524280k free        | 空闲交换分区的大小           |
    | 409280k cached      | 作为缓存的交换分区的大小     |

我们通过top命令的第一部分就可以判断服务器的健康状态

- 如果 1 分钟、5 分钟、15 分钟的平均负载高于 1，则证明系统压力较大。
- 如果 CPU 的使用率过高或空闲率过低，则证明系统压力较大。
- 如果物理内存的空闲内存过小，则也证明系统压力较大。

缓冲（buffer）和缓存（cache）的区别

- 缓存（cache）是在读取硬盘中的数据时，把最常用的数据保存在内存的缓存区中，再次读取该数据时，就不去硬盘中读取了，而在缓存中读取。
- 缓冲（buffer）是在向硬盘写入数据时，先把数据放入缓冲区,然后再一起向硬盘写入，把分散的写操作集中进行，减少磁盘碎片和硬盘的反复寻道，从而提高系统性能。

top命令的第二部分的输入含义

- PID：进程的 ID。
- USER：该进程所属的用户。
- PR：优先级，数值越小优先级越高。
- NI：优先级，数值越小、优先级越高。
- VIRT：该进程使用的虚拟内存的大小，单位为 KB。
- RES：该进程使用的物理内存的大小，单位为 KB。
- SHR：共享内存大小，单位为 KB。
- S：进程状态。
  - -D：不可被唤醒的睡眠状态，通常用于 I/O 情况。
  - -R：该进程正在运行。
  - -S：该进程处于睡眠状态，可被唤醒。
  - -L：被锁入内存。
  - -s：包含子进程。
  - -l：多线程（小写 L）。
  - -+：位于后台。
- %CPU：该进程占用 CPU 的百分比。
- %MEM：该进程占用内存的百分比。
- TIME+：该进程共占用的 CPU 时间。
- COMMAND：进程的命令名。

## pstree

以树形结构显示程序和进程之间的关系

命令格式

```cmd
[root@localhost ~]# pstree [选项] [PID或用户名]
```

示例

- 基本使用

  `pstree`

- 查询用户都启动了哪些进程,以 mysql 用户为例

  `pstree mysql`

## lsof

查询系统中已经被打开的文件

命令格式

```cmd
[root@localhost ~]# lsof [选项]
```

示例

- 查询系统中所有进程调用的文件

  `lsof | more`

- 查询某个文件被哪个进程调用

  `lsof /sbin/init`

- 查询某个目录下所有的文件是被哪些进程调用的

  `lsof +d /usr/lib`

- 查看以httpd开头的进程调用了哪些文件

  `lsof -c httpd`

- 查询指定PID的进程调用的文件

  `lsof -p 进程id`

- 按照用户名查询用户的进程调用的文件

  `lsof -u 用户名`

## 进程相关内容

进程优先级

- PRI和NI表示进程的优先级,数值越小代表进程越优先被CPU处理
- PRI值是由内核动态调整的，用户不能直接修改,所以我们只能通过修改 NI 值来影响 PRI 值，间接地调整进程优先级。
- PRI 和 NI 的关系如下：
- `PRI (最终值) = PRI (原始值) + NI`
- NI 值越小，进程的 PRI 就会降低，该进程就越优先被 CPU 处理；反之，NI 值越大，进程的 PRI 值就会増加，该进程就越靠后被 CPU 处理。

改变进程优先级

- nice命令

  - 给要启动的进程赋予 NI 值，但是不能修改已运行进程的 NI 值

  - 命令格式

    ```cmd
    [root@localhost ~] # nice [-n NI值] 命令
    ```

    > NI值的范围为-20~19

  - 示例

    - 启动apache服务，同时修改apache服务进程的NI值为-5

      `nice -n -5 service httpd start`

renice命令

- 可以在进程运行时修改其 NI 值，从而调整优先级

- 命令格式

  ```cmd
  [root@localhost ~] # renice [优先级] PID
  ```

- 示例

  - 修改PID为2125的进程的NI值为-10

    `renice -10 2125`

进程间通信

- 常见的**进程信号**

  - `sighup`: 立即关闭,在重新读取配置文件后重启(信号代号为1)

  - sigint: 终止信号,相当于Ctrl+C(信号代号为2)

  - sigfpe: 发生算术运算错误时发出(信号代号为8)

  - `sigkill`: 立即结束程序的运行,用于强制终止进程(信号代号为9)

  - sigalrm: 时钟定时信号(信号代号为14)

  - `sigterm`: 正常结束进程的信号,kill命令的默认信号(信号代号为15)

  - sigcont: 让暂停的进程恢复执行(信号代号为18)

  - sigstop: 暂停前台进程(信号代号为19)

    > 最重要的就是1,9,15这三个信号

## kill

终止进程

kill命令会向操作系统内核发送一个信号(多是终止信号)和目标进程的PID,然后系统内核根据收到的信号类型,对指定进程进程相应的操作

命令格式

```cmd
[root@localhost ~]# kill [信号] PID
```

> 这里的[信号]就是上一节说的进程信号代号

示例

- 基本使用: 杀死PID是2248的httpd进程

  `kill 2248`

- 让进程重启

  `kill -1 2246`

- 让进程暂停

  `kill -19 2246`

- 强制杀死进程

  `kill -9 2246`

## killall

通过程序的进程名来杀死一类进程

命令格式

```cmd
[root@localhost ~]# killall [选项] [信号] 进程名
```

选项

- -i：交互式，询问是否要杀死某个进程；
- -I：忽略进程名的大小写；

示例

- 杀死httpd进程

  `killall httpd`

- 交互式杀死sshd进程

  `killall -i sshd`

## 后台执行命令(跟随命令行)

后台执行命令的两种方式

- 在命令后面加上`空格+&`

  > 此方式会让在**后台的任务会继续的执行**,并且在命令窗口被关闭时,对应的后台命令也会被终止掉

- 在命令执行的过程中按Ctrl+Z,可使命令处于后台运行,此时就可以得到控制台的操作权限了

  > 此方式会让在**后台的任务会被暂停执行**,并且在命令窗口被关闭时,对应的后台命令也会被终止掉

- 示例

  后台执行命令

  `find / -name install.log &`

jobs

- 查看当前终端放入后台的工作

- 命令格式

- ```cmd
  [root@localhost ~]#jobs [选项]
  ```

- 选项

  - -l: 列出进程的PID

  - -n: 只列出上次发出通知后改变了状态的进程
  - -p: 只列出进程的PID
  - -r: 只列出运行中的进程
  - -s: 只列出已停止的进程

- 示例

- - ```cmd
    [root@localhost ~]#jobs -l
    [1]- 2023 Stopped top
    [2]+ 2034 Stopped tar -zcf etc.tar.gz /etc
    ```

    > 后台有两个命令: 一个是top,工作号为1,状态时暂停,标志是"-"一个是tar,工作号为2,状态时暂停,标志是"+"
    >
    > "+"号代表最近一个放入后台的工作，也是工作恢复时默认恢复的工作。"-"号代表倒数第二个放入后台的工作
    >
    > 一旦标志为"+"的命令完成,则标志为"-"的命令就会自动成为新的默认工作
    >
    > 在任何时候,,都会有且只有一个带加号的命令和一个带减号的命令

fg

- 把后台命令恢复在前台执行

- 命令格式

  ```cmd
  [root@localhost ~]#fg %工作号
  ```

  > ％ 可以省略，但若将`%工作号`全部省略，则此命令会将标志为 "+" 的工作恢复到前台

- 示例
  - 先查询后台运行的命令

    ```cmd
    [root@localhost ~]#jobs
    [1]- Stopped top
    [2]+ Stopped tar-zcf etc.tar.gz/etc
    ```

  - 恢复标志为"+"的命令为前台执行

    `fg`

  - 恢复1号命令为前台执行

    `fg %1`

bg

- 把后台暂停的工作会恢复到后台执行

- 命令格式

  ```cmd
  [root@localhost ~]# bg 工作号
  ```

- 示例
  - 让1号命令恢复后台执行

    `bg 1`

## nohup(脱离命令行)

后台命令脱离终端运行,在关闭命令窗口时,后台命令不会被终止掉

命令格式

```cmd
[root@localhost ~]# nohup [命令] &
```

示例

- 将find命令放入后台执行

  `nohup find / -print > /root/file.log &`

## crontab

循环执行定时任务

crontab命令需要crond服务的支持

crond是linux用来周期的执行某种任务或等待处理某些事件的一个守护进程; crond 进程每分钟会定期检查是否有要执行的任务，如果有，则会自动执行该任务。

crond服务

- 启动crond服务

  `service crond restart`

- 设定crond服务为开机自启动

  `chkconfig crond on`

crontab

> 其实crontab定时任务只需要执行`crontab -e`命令,然后输入想要定时执行的任务即可

- 命令格式

  ```cmd
  [root@localhost ~]# crontab [选项] [file]
  ```

  > 这里的file指的是命令文件的路径,如果没有指定文件,则需要输入要定时执行的命令

- 选项

  - `-u demo`: 用来设定某个用户的crontab服务
  - `-e`: 编辑某个用户的crontab文件内容; 如果不指定用户,则编辑当前用户
  - `-l`: 显示某用户的crontab文件内容; 如果不指定用户,则查看当前用户
  - `-r`: 从/var/spool/cron删除某用户的crontab文件; 如果不指定用户,则删除当前用户
  - `-i`: 在删除用户的crontab文件时,给确认提示

- 示例(创建任务)

  - 创建定时任务的操作

    ```cmd
    [root@localhost ！]# crontab -e
    #进入 crontab 编辑界面。会打开Vim,然后编辑你的任务即可
    * * * * * 执行的任务
    ```

    > 这个文件中是通过 5 个“*”来确定命令或任务的执行时间的

- crontab时间表示

  - 基本表示

    | 项目      | 含义                           | 填写范围                |
    | --------- | ------------------------------ | ----------------------- |
    | 第一个"*" | 一小时当中的第几分钟（minute） | 0~59                    |
    | 第二个"*" | 一天当中的第几小时（hour）     | 0~23                    |
    | 第三个"*" | 一个月当中的第几天（day）      | 1~31                    |
    | 第四个"*" | 一年当中的第几个月（month）    | 1~12                    |
    | 第五个"*" | 一周当中的星期几（week）       | 0~7（0和7都代表星期日） |

  - 特殊符号

    | 特殊符号    | 含义                                                         |
    | ----------- | ------------------------------------------------------------ |
    | *（星号）   | 代表任何时间。比如第一个"*"就代表一小时种每分钟都执行一次的意思。 |
    | ,（逗号）   | 代表不连续的时间。比如"0 8,12,16 * * *命令"就代表在每天的 8 点 0 分、12 点 0 分、16 点 0 分都执行一次命令。 |
    | -（中杠）   | 代表连续的时间范围。比如"0 5 * * 1-6命令"，代表在周一到周六的凌晨 5 点 0 分执行命令。 |
    | /（正斜线） | 代表每隔多久执行一次。比如"*/10 * * * *命令"，代表每隔 10 分钟就执行一次命令。 |

  - 示例(时间设定)

    | 时间             | 含义                                                         |
    | ---------------- | ------------------------------------------------------------ |
    | 45 22 * * *命令  | 每天的在 22 点 45 分执行命令                                 |
    | 0 17 * * 1命令   | 在每周一的 17 点 0 分执行命令                                |
    | 0 5 1,15 * *命令 | 在每月 1 号和 15 号的凌晨 5 点 0 分执行命令                  |
    | 40 4 * * 1-5命令 | 在每周一到周五的凌晨 4 点 40 分执行命令                      |
    | */10 4 * * *命令 | 在每天的凌晨 4 点，每隔 10 分钟执行一次命令                  |
    | 0 0 1,15 * 1命令 | 在每月 1 号,15 号，和每周一的 0 点 0 分都会执行命令，注意：星期几和几日最好不要同时出现，因为它们定义的都是天，非常容易让管理员混淆 |

- 当`crontab -e`编辑完成保存退出之后,那么这个定时任务实际就会写入到/var/spool/cron目录中,每个用户的定时任务用自己的用户名进行区分

- crontab的执行任务

  执行任务既可以是系统命令,也可以是某个shell脚本

  - 示例

    - 让系统每隔 5 分钟就向 /tmp/test 文件中写入一行“11”

      ```cmd
      [root@localhost ~]# crontab -e
      #进入编辑界面
      */5 * * * * /bin/echo "11" >> /tmp/test
      ```

      > 如果要1分钟执行一次,可以把`*/5`换成`*`,或者是把`*/5`换成`*/1`即可
      >
      > 如果我们定时执行的是系统命令，那么最好使用绝对路径。

    - 让系统在每周二的凌晨 5 点 05 分重启一次

      ```cmd
      [root@localhost ~]# crontab -e
      5 5 * * 2 /sbin/shutdown -r now
      ```

      > 如果服务器的负载压力比较大，则建议每周重启一次，让系统状态归零

    - 在每月1号、10号、15号的凌晨 3 点 30 分都定时执行日志备份脚本 autobak.sh

      ```cmd
      [root@localhost ~]# crontab -e
      30 3 1,10,15 * * /root/sh/autobak.sh
      ```

    - 查看定时任务

      ```cmd
      [root@localhost ~]# crontab -l
      #查看root用户的crontab任务
      */5 * * * * /bin/echo "11" >> /tmp/test
      5.5 * * 2 /sbin/shutdown -r now
      30.3 1，10，15 * * /root/sh/autobak.sh
      ```

    - 删除某个定时任务

      执行`crontab -e`进入定时任务编辑模式,然后手动的删除对应的定时任务即可

    - 删除所有的定时任务

      `crontab -r`

系统的crontab设置

- `crontab -e`是编辑每个用户对应的定时任务,如果要设定系统的定时任务,则需要编辑/etc/crontab这个配置文件

## free

查看系统内存状态

命令格式

```cmd
[root@localhost ~]# free [选项]
```

选项

- `-m`: 以MB单位显示内存使用情况
- `-g`: 以GB单位显示内存使用情况

示例

- 基本使用

  ```cmd
  [root@localhost ~]# free -m
                    total       used    free   shared   buffers    cached
  Mem:           725        666      59           0       132         287
  -/+ buffers/cache:     245     479
  Swap:           996            0     996
  ```

- 第一行显示的格式列的列表头含义

  - total 是总内存数；
  - used 是已经使用的内存数；
  - free 是空闲的内存数；
  - shared 是多个进程共享的内存总数；
  - buffers 是缓冲内存数；
  - cached 是缓存内存数。

# 系统日志管理

## rsyslogd

是linux的日志服务

查看rsyslogd是否启动

```cmd
ps aux | grep "rsyslog" | grep -v "grep"
```

## 日志文件

系统的日志文件会保存在/var/log目录下

重要的日志文件

- /var/log/cron: 记录与系统定时任务相关的日志
- /var/log/cpus: 记录打印信息的日志
- /var/log/lasllog: 记录系统中所有用户最后一次的登入时间
- /var/log/mailog: 记录邮件信息的日志

采用rpm方式安装的系统服务也会把默认日志记录在/var/log目录下

## 日志格式

日志格式

- 事件产生的时间
- 产生事件的服务器的主机名
- 产生事件的服务名或程序名
- 事件的具体信息

示例

- 查看/var/log/secure 日志

  ```cmd
  [root@localhost ~]# vi /var/log/secure
  Jun 5 03：20：46 localhost sshd[1630]：Accepted password for root from 192.168.0.104 port 4229 ssh2
  # 6月5日 03：20：46 本地主机 sshd服务产生消息：接收从192.168.0.104主机的4229端口发起的ssh连接的密码
  Jun 5 03：20：46 localhost sshd[1630]：pam_unix(sshd：session)：session opened for user root by (uid=0)
  #时间 本地主机 sshd服务中pam_unix模块产生消息：打开用户root的会话（UID为0）
  Jun 5 03：25：04 localhost useradd[1661]：new group：name=bb， GID=501
  #时间 本地主机 useradd命令产生消息：新建立bb组，GID为501
  ```

## 系统日志配置文件

/etc/rsyslog.conf

用到了再说

# 备份与恢复

## 备份策略

- 完全备份

  把所有需要备份的数据全部备份

  - 缺点
    - 需要备份的数据量较大
    - 备份之间长
    - 占用空间大

- 增量备份

  先进行一次完全备份,当运行一段时间后,比较当前系统和完全备份数据之间的差异,只备份有差异的数据

  - 优点
    - 备份数据量少,耗时短,占用空间小
  - 缺点
    - 数据恢复比较麻烦

## 备份数据

tar

- 使用tar命令将数据打包,从而实现数据的备份

- 示例

  - 打包并压缩目录

    `tar -zcvf /$osdata/etc.data/etc_$BAKDATE.tar.gz /etc`

dump

- 使用dump可以实现备份分区,文件或目录

- 安装该命令

  `yum -y install dump`

- 基本格式

  ```cmd
  [root@localhost ~]# dump [选项] 备份之后的文件名 原文件或目录
  ```

- 示例

  - 备份分区

    先查看分区

    ```cmd
    [root@localhost ~]# df -h
    文件系统  容量 已用 可用 已用% 挂载点
    /dev/sda3   20G 3.0G 16G 17% /
    tmpfs   30 6M 0 30 6M 0% /dev/shm
    /dev/sda1   194M 26M 158M 15% /boot
    /dev/sr0   3.5G 3.5G 0 100% /mnt/cdrom
    ```

    备份/boot分区

    ```cmd
    [rootSlocalhost ~]# dump -0uj -f /root/boot.bak.bz2 /boot/
    #备份命令。先执行一次完全备份,并压缩和更新备份时间
    ```

  - 备份文件或目录

    ```cmd
    [root@localhost ~]# dump -0j -f /root/etc.dump.bz2 /etc/
    #完全备份/etc/目录
    ```

restore

- 还原dump操作备份下的文件,目录或分区

- 命令格式

  ```cmd
  [root@localhost ~]# restore [模式选项] [-f]
  ```

- 示例

  - 查看备份文件的内容

    `restore -t -f boot.bak.bz2`

  - 还原备份文件

    `restore -r -f /root/boot.bak.bz2`

# 其他

测试接口联通性

```shell
wget ip:port
```

例如：

```shell
wget xxx.xxx.xxx.xxx:8000
```



# 参考文档

- [linux入门教程](http://c.biancheng.net/linux_tutorial/)









-