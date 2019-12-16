# 介绍

## Windows注册表

注册表被称为Windows操作系统的核心，它的工作原理实质是一个庞大的数据库，存放了关于计算机硬件的配置信息、系统和应用软件的初始化信息、应用软件和文档文件的关联关系、硬件设备的说明以及各种状态信息和数据，包括Windows操作时不断引用的信息。例如：系统中的硬件资源、硬件信息、分配正在使用的端口、每个用户的配置文件、计算机上安装的应用程序以及每个应用程序可以创建的文件类型等。 

## Reg文件

REG文件实际上是一种windows操作系统的注册表脚本文件，双击REG文件即可将其中的数据导入到注册表当中。利用REG文件我们可以直接对注册表进行任何修改操作 

# 注册表的组成

1. 根键：这个称为HKEY_XXXXX，某一项的句柄项：附加的文件夹和一个或多个值
2. 子项：在某一个项（父项）下面出现的项（子项）
3. 值项：带有一个名称和一个值的有序值，每个项都可包括任何数量的值项，值项由三个部分组成：名称、数据类型和数据。 
   - 名称：不包括反斜线的字符、数字、代表符和空格的任意组合。同一键中不可有相同的名称
   - 数据类型：包括字符串、二进制和双字节等
   - 数据：值项的具体值，它的大小可以占用64KB 

---

## 根键的5种类型

1. HKEY_CLASSES_ROOT
   该根键包括**启动应用程序所需的全部信息**，包括扩展名，应用程序与文档之间的关系，驱动程序名，DDE和OLE信息，类ID
   编号和应用程序与文档的图标等。
2. HKEY_CURRENT_USER
   该根键包括**当前登录用户的配置信息**，包括环境变量，个人程序以及桌面设置等
3. HKEY_LOCAL_MACHINE
   该根键包括**本地计算机的系统信息**，包括硬件和操作系统信息，安全数据和计算机专用的各类软件设置信息
4. HKEY_USERS
   该根键包括计算机的**所有用户使用的配置数据**，这些数据只有在用户登录系统时才能访问。这些信息告诉系统当前用户使
   用的图标，激活的程序组，开始菜单的内容以及颜色，字体
5. HKEY_CURRENT_CONFIG
   该根键包括**当前硬件的配置信息**，其中的信息是从HKEY_LOCAL_MACHINE中映射出来的。 

### HKEY_CLASSES_ROOT

在这一个根键中记录的是WINDOWS操作系统中所有数据文件的信息内容，主要记录了不同文件的文件扩展名和与
之相对应的应用程序; 

> 如当我们打开文档时,window会查询该根键找对该文档对应打开的应用软件类型,然后调用应用软件打开该文档

这个根键的子键非常多的，它主要分为两种：

1. 已经注册的各类文件的扩展名
2. 各种文件类型的有关信息 

接下来我们拿`.md`文件来进行举例(如果你有安装Typora软件的话,这是一个markdown文档编辑器):

- 打开注册表可以发现,在注册表的`HKEY_CLASSES_ROOT`根键下,存在`.md`的子项,这个是用来标识我们电脑上的`.md`文件(即markdown文件)的,如下图所示

  ![image-20191030095610166](/Users/yingjie.lu/Documents/note/.img/image-20191030095610166.png)

  我们可以看到`.md`子项对应的数据类型是`TyporaMarkdownFile`类型的,那么window是怎么知道该类型的呢?

- 我们可以在`HKEY_CLASSES_ROOT`根键下查找`TyporaMarkdownFile`关键字,那么我们会发现,在注册表中还存在`TyporaMarkdownFile`子项,如图所示:

  ![image-20191030100030109](/Users/yingjie.lu/Documents/note/.img/image-20191030100030109.png)

  它的`command`子项中存在着打开对应应用程序的命令

- 所以,当我们在电脑上双击`.md`文件时,windows会去注册表中找到对应的`.md`文件由谁来处理,查到结果是`TyporaMarkdownFile`,那么Windows又去注册表中查找`TyporaMarkdownFile`究竟是哪个应用软件,找到`TyporaMarkdownFile`子项后,通过`command`子项中保存的命令打开对应的应用软件,并将我们要打开的`.md`的文件信息传入,这样就能实现我们在桌面双击`.md`文件,就能够使用Tytora软件打开对用的markdown文件

### HKEY_CURRENT_USER

此根键中保存的信息（当前用户的子项信息）与`HKEY_USERS_DEFAULT`下面的一模一样的; 任何对 HKEY_CURRENT_USER根键中的信息的修改都会导致对HKEY_USERS_DEFAULT中子项的修改 

### HKEY_LOCAL_MACHINE

此根键中存放的是用来控制系统和软件的设置，由于这些设置是针对那些使用Windows系统的用户而设置的，是一个公共配置信息，所以它与具体的用户没多大关系。 

1. HARDWARE子项：该子项包括了系统使用的浮点处理器、串口等信息; 
   1. ACPI:存放高级电源管理接口数据；
   2. DEVICEMAP：用于存放设备映射；
   3. DEscriptION：存放有关系统信息；
   4. RESOURCEMAP：用于存放资源列表
2. SAM子项：这部分被保护了，看不到
3. SECURITY子项：该子项只是为将来的高级功能而预留的
4. SOFTWARE子项：该子项中保留的是所有已安装的32位应用程序的信息，各个程序的控制信息分别安装在相应的子项中，由于不同的计算机安装的应用程序互不相同，因此这个子项下面的子项信息也不完全一样。
5. SYSTEM子项：该子项是启动时所需的信息和修复系统时所需要的信息

### HKEY_USERS

此根键中保存的是默认用户（default)，当前登录用户和软件（software) 的信息，其中DEFAULT子项是其中最重要的，它的配置是针对未来将会被创建的新用户的。新用户根据默认用户的配置信息来生成自己的配置文件，该配置文件包括环境、屏幕和声音等多种信息，其中常用的3项有 :

1. AppEvents子项：它包括了各种应用事件的列表：EventLabels:按字母顺序列表；Schemes:按事件分类列表
2. Control Panel子项：它包括内容与桌面、光标、键盘和鼠标等设置有关
3. Keyboard layout子项：用于键盘的布局(如语言的加载顺序等)
   - Preload:语言的加载顺序
   - Substitutes:设置可替换的键盘语言布局
   - Toggle:用于选择键盘语言 

### HKEY_CURRENT_CONFIG

此根键存放的是当前配置的文件信息 

## 值项中的9种数据类型

作用: 指定项值的数据类型

9种数据类型:

1. REG_SZ 
2. REG_MULTI_SZ 
3. REG_DWORD_BIG_ENDIAN 
4. REG_DWORD 
5. REG_BINARY 
6. REG_DWORD_LITTLE_ENDIAN 
7. REG_LINK 
8. REG_FULL_RESOURCE_DESCRIPTOR 
9. REG_EXPAND_SZ  

以下是常用类型的解释:

|  中文名称  |   数据类型   |                         保存的值类型                         |
| :--------: | :----------: | :----------------------------------------------------------: |
|  字符串值  |    REG_SZ    |                       固定长度的文本串                       |
|  二进制值  |  REG_BINARY  | 多数硬件组件信息都以二进制数据存储,而以十六进制格式显示在注册表编辑器中 |
|   DWORD    |  REG_DWORD   | 数据以4字节长的数表示; 许多设备驱动程序和服务的参数是这种类型 |
| 多字符串值 | REG_MULTI_SZ | 多重字符串; 其中包含格式可被用户读取的列表或多值的值通常为该类型; 项用空格,盗号或者其他标记分开; |

# 注册表操作

## 编辑注册表

使用`Windows+R`打开运行,在运行中输入`regedit`回车后即可打开编辑注册表进行直接的编辑了

## Reg命令

### 帮助命令

REG QUERY /?
REG ADD /?
REG DELETE /?
REG COPY /?
REG SAVE /?
REG RESTORE /?
REG LOAD /?
REG UNLOAD /?
REG COMPARE /?
REG EXPORT /?
REG IMPORT /?
REG FLAGS /?

### 查询

命令查询帮助:

`reg query /?`

命令格式:

`reg query KeyName [/s] [/f Data [/k][/d][/e]] ` 

- `KeyName` : 以 `ROOTKEY\SubKey` 名称形式(SubKey: 在选择的 ROOTKEY 下的注册表项的全名)

  示例: `reg query HKEY_CLASSES_ROOT\typora`

  > 查询`HKEY_CLASSES_ROOT`根键下的`typora`子项

- `/s`: 循环查询所有子项和值(如 dir /s)

- `/f`: 指定搜索的数据或模式(如果字符串包含空格，请使用双引号。默认为 "*")

  - `/k`: 指定只在项名称中搜索
  - `/d`: 指定只在数据中搜索
  - `/e`: 指定只返回完全匹配(默认是返回所有匹配)

示例:

```cmd
reg query HKEY_CLASSES_ROOT\typora /s
```

> 循环查询所有的typora下的子项
>
> 查询结果:
>
> ```cmd
> HKEY_CLASSES_ROOT\typora
>     (默认)    REG_SZ    URL:Typora Protocol
>     URL Protocol    REG_SZ    D:\note\Typora.py
> 
> HKEY_CLASSES_ROOT\typora\DefaultIcon
>     (默认)    REG_SZ    D:\note\Typora.py,1
> 
> HKEY_CLASSES_ROOT\typora\shell
>     (默认)    REG_SZ
> 
> HKEY_CLASSES_ROOT\typora\shell\open
>     (默认)    REG_SZ
> 
> HKEY_CLASSES_ROOT\typora\shell\open\command
>     (默认)    REG_SZ    pyw D:\note\Typora.py %1
> ```

### 添加

命令查询帮助:

`reg add /?`

命令格式:

`reg add KeyName [/t Type][/d Data][/f] ` 

> 在做添加操作时,cmd命令行需要使用管理员身份运行,不然操作会被拒绝

- `KeyName `: 以 `ROOTKEY\SubKey` 名称形式

  例如: `HKEY_CLASSES_ROOT\typora`

- `/t`: RegKey 数据类型,总共有九种数据类型,默认采用 REG_SZ

- `/d`: 要分配给添加的注册表 ValueName 的数据

- `/f`: 强行覆盖现有注册表项并且不提示

示例:

```cmd
reg add HKEY_CLASSES_ROOT\typora /d 111 /f
```

> 创建typora子项

```cmd
reg add HKEY_CLASSES_ROOT\typora111\path\aaa /d 222222 /f
```

> 在typora下创建递归子项

### 删除

命令查询帮助:

`reg delete /?`

命令格式:

`reg delete KeyName [/v ValueName | /ve | /va] [/f] ` 

> 在做添加操作时,cmd命令行需要使用管理员身份运行,不然操作会被拒绝

- `KeyName `: 以 `ROOTKEY\SubKey` 名称形式

  例如: `HKEY_CLASSES_ROOT\typora`

- `ValueName`: 所选项下面的要删除的值名称(如果省略，则删除该项下面的所有子项和值)

- `/ve`: 删除空值名称的值(默认)

- `/va`: 删除该项下面的所有值

- `/f`: 不用提示，强制删除

示例:

```cmd
reg delete HKEY_CLASSES_ROOT\typora111 /f
```

> 强制删除`typora111`子项

### 导出

命令查询帮助:

`reg export /?`

命令格式:

`reg export KeyName FileName [/y] ` 

- `KeyName `: 以 `ROOTKEY\SubKey` 名称形式

  例如: `HKEY_CLASSES_ROOT\typora`

- `FileName`: 要导出的磁盘文件名

- `/y`: 不用提示就强行覆盖现有文件

示例:

```cmd
reg export HKEY_CLASSES_ROOT\typora D:/typora.reg
```

> 导出文件的内容:
>
> ```cmd
> Windows Registry Editor Version 5.00
> 
> [HKEY_CLASSES_ROOT\typora]
> @="URL:Typora Protocol"
> "URL Protocol"="D:\\note\\Typora.py"
> 
> [HKEY_CLASSES_ROOT\typora\DefaultIcon]
> @="D:\\note\\Typora.py,1"
> 
> [HKEY_CLASSES_ROOT\typora\shell]
> @=""
> 
> [HKEY_CLASSES_ROOT\typora\shell\open]
> @=""
> 
> [HKEY_CLASSES_ROOT\typora\shell\open\command]
> @="pyw D:\\note\\Typora.py %1"
> ```

### 导入

命令查询帮助:

`reg import /?`

命令格式:

`reg import FileName [/y] ` 

- `FileName`: 要导出的磁盘文件名

示例:

```cmd
reg import D:/typora111.reg
```

# 编写一个Reg文件Demo

该文件的作用是: 

- 当你在页面发起一个`typora:D:/note/README.md`的请求时
- 它会到注册表中找到对应的url协议对应的`typora`指令
- 从而可以调用本地的一些命令
- 这里调用的是python的命令,运行`D:\\note\\Typora.py`脚本,并将请求的参数传入
- 在python脚本中运行typora应用,并打开对应的md文件

```cmd
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\typora]
@="URL:Typora Protocol"
"URL Protocol"="D:\\note\\Typora.py"

[HKEY_CLASSES_ROOT\typora\DefaultIcon]
@="D:\\note\\Typora.py,1"

[HKEY_CLASSES_ROOT\typora\shell]
@=""

[HKEY_CLASSES_ROOT\typora\shell\open]
@=""

[HKEY_CLASSES_ROOT\typora\shell\open\command]
@="pyw D:\\note\\Typora.py %1"
```

Python脚本如下(有用到的可以参考一下):

```python
#coding=utf-8
import subprocess
import sys
from urllib.parse import unquote

# 调用的命令为 py Typora.py D:/note/README.md

# 路径变量的格式为D:/note/README.md
notePath=sys.argv[1] #note的路径变量
# 将路径变量进行解码(从而可以使用中文)
notePath=unquote(notePath[7:], 'utf-8') 

cmd='"C:\Program Files\Typora\Typora.exe" "%s"' % (notePath)
ps = subprocess.Popen(cmd); # 执行cmd命令
ps.wait();#让程序阻塞
```

# 注册表个性化设置

1. 去掉桌面快捷方式上的小键头
   位置：HKEY_CLASSES_ROOT\LNKFILE项 ：IsShortcut
   操作：删除此项 
   要求:   需要重启计算机
2. 为右键菜单添加“在新窗口打开”命令
   位置：HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shell
   新建子项：NewWindow
   修改：将默认值项值改为“在新窗口打开”
   继续：在NewWindow项下新建个子项command
   修改：将默认值项值改为explorer.exe 
3. 清除注册表垃圾（需重启）
   位置1：HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
   位置2：HKEY_LOCAL_MACHINE\SOFTWARE
   操作：很简单了，没用的删了吧 
4. 缩短关闭无响应程序的等待时间（需重启）
   位置：HKEY_USERS\.DEFAULT\Control Panel\Desktop
   值项：WaitToKillTimeout
   修改：增大一点可以加快处理程序的速度 

# 参考文档

[windows注册表内容详解](http://blog.sina.com.cn/s/blog_4d41e2690100q33v.html)