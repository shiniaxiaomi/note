[TOC]

# 批处理常见命令

## rem(注解)

`rem` 或者`::`

> 注释命令，一般用来给程序加上注解
>
> `rem`命令后的内容不被执行，但能回显
>
> `::`命令后的内容不被执行，且不回显

## set(设置变量,获取用户输入)

- 新建变量

  `set a=1`

- 获取用户输入
  
  `set /p set msg=请输入信息:`
  
  > 用户输入的数据会保存在msg变量中
  
- 使用变量

  `%msg%`

  > 直接在变量左右加上%

- 其他变量

  - 获取电脑的用户

    `%userName%`

  - 获取当前文件的路径

    `%cd%`

## echo(打印输出,修改文件内容)

- 可以控制整体的打印输出

  - 关闭

    `@echo off`

  - 打开

    `@echo on`

- 输出提示信息

  `echo 你好`

- 输出空行，即相当于输入一个回车

  `echo.`

- 建立新文件或增加文件内容 

  格式: ECHO 文件内容>>文件名

  - 新建文件

    `ECHO @ECHO OFF>AUTOEXEC.BAT`

  - 追加内容

    `ECHO C:\CPAV\BOOTSAFE>>AUTOEXEC.BAT`

  - 输出变量

    `echo %msg%`

    > msg是变量,需要在左右加上%

## pause(暂停)

`pause`

> 运行显示：
> 请按任意键继续. . .

## title(设置cmd窗口标题)

`title 新标题`

## goto(跳转程序)

`if "%a%"=="" goto noparms`

示例:

```bat
:start ::标记点
set /a var+=1
echo %var%
if %var% leq 3 GOTO start
pause
```

运行结果:

>1
>2
>3
>4

## start(调用外部程序)

批处理中调用外部程序的命令（该外部程序在新窗口中运行，批处理程序继续往下执行，不理会外部程序的运行状况），如果直接运行外部程序则必须等外部程序完成后才继续执行剩下的指令

示例:

> - 调用图形界面打开D盘
>
>   `start explorer d:\`

## call(调用其他bat脚本)

CALL命令可以在批处理执行过程中调用另一个批处理，当另一个批处理执行完后，再继续执行原来的批处理

用法:

`CALL [drive:][path]filename [batch-parameters]`

## if(条件判断)

语法:

- `IF [NOT] string1==string2 command`

  > 检测当前变量的值做出判断，为了防止字符串中含有空格，可用以下格式
  > if [NOT] {string1}=={string2} command
  > if [NOT] [string1]==[string2] command
  > if [NOT] "string1"=="string2" command

- `IF [NOT] EXIST filename command`

  > 示例:
  >
  > IF EXIST autoexec.bat echo 文件存在！

## setlocal(变量延迟加载)

没有开启延迟加载

```bat
@echo off
set a=4
set a=5 & echo %a%
pause
结果：4
```

开启延迟加载

```bat
@echo off
setlocal enabledelayedexpansion
set a=4
set a=5 & echo !a!
pause 
结果：5
```

> 变量延迟的启动语句是“setlocal enabledelayedexpansion”，并且变量要用一对叹号“!!”括起来（注意要用英文的叹号），否则就没有变量延迟的效果。

# 常用特殊符号

## @(命令行回显屏蔽)

在命令前面加上`@`可以屏蔽该命令的回显

## % (批处理变量引导符)

- 引用变量

  `%var%`

- 引用外部参数

  > %0  %1  %2  %3  %4  %5  %6  %7  %8  %9  %*为命令行传递给批处理的参数
  >
  > %0 批处理文件本身，包括完整的路径和扩展名
  > %1 第一个参数
  > %9 第九个参数
  >
  > 
  >
  > 示例:
  >
  > `copy %0 d:\wind.bat`

## **>> (重定向符)**

`>>`是传递并在文件的末尾追加，而`>`是覆盖

> 示例:
>
> `echo hello > 1.txt`
>
> `echo world >>1.txt`
>
> 
>
> 这时候1.txt 内容如下:
> hello
> world

## **&(组合命令)**

语法：第一条命令 & 第二条命令 [& 第三条命令...]

&、&&、||为组合命令，顾名思义，就是可以把多个命令组合起来当一个命令来执行。这在批处理脚本里是允许的，而且用的非常广泛

> 示例:
>
> `dir z:\ & dir y:\ & dir c:\`

## **&& (组合命令)**

这个命令和上边`&`命令的类似，但区别是，第一个命令失败时，**后边的命令也不会执行**

> 示例:
>
> `dir z:\ && dir y:\ && dir c:\`

## **""  (字符串界定符)**

双引号允许在字符串中包含空格，可以进入一个特殊目录

`cd "program files"`

## **() 括号**

小括号在批处理编程中有特殊的作用，左右括号必须成对使用，括号中可以包括多行命令，这些命令将被看成一个整体，视为一条命令行。

括号在for语句和if语句中常见，用来嵌套使用循环或条件语句，其实括号()也可以单独使用

> 示例:
>
> ```bat
> (
>     echo 1
>     echo 2
>     echo 3
> )
> ```

# 循环

[见参考文档](https://www.cnblogs.com/iTlijun/p/6137027.html)

# 系统变量

```bat
%ALLUSERSPROFILE% 本地 返回“所有用户”配置文件的位置。
%APPDATA% 本地 返回默认情况下应用程序存储数据的位置。
%CD% 本地 返回当前目录字符串。
%CMDCMDLINE% 本地 返回用来启动当前的 Cmd.exe 的准确命令行。
%CMDEXTVERSION% 系统 返回当前的“命令处理程序扩展”的版本号。
%COMPUTERNAME%  系统 返回计算机的名称。
%COMSPEC%  系统 返回命令行解释器可执行程序的准确路径。
%DATE%  系统 返回当前日期。使用与 date /t 命令相同的格式。由 Cmd.exe 生成。有关
date 命令的详细信息，请参阅 Date。
%ERRORLEVEL%  系统 返回上一条命令的错误代码。通常用非零值表示错误。
%HOMEDRIVE%  系统 返回连接到用户主目录的本地工作站驱动器号。基于主目录值而设置。用
户主目录是在“本地用户和组”中指定的。
%HOMEPATH%  系统 返回用户主目录的完整路径。基于主目录值而设置。用户主目录是在“本地用户和组”中指定的。
%HOMESHARE%  系统 返回用户的共享主目录的网络路径。基于主目录值而设置。用户主目录是
在“本地用户和组”中指定的。
%LOGONSERVER%  本地 返回验证当前登录会话的域控制器的名称。
%NUMBER_OF_PROCESSORS%  系统 指定安装在计算机上的处理器的数目。
%OS%  系统 返回操作系统名称。Windows 2000 显示其操作系统为 Windows_NT。
%PATH% 系统 指定可执行文件的搜索路径。
%PATHEXT% 系统 返回操作系统认为可执行的文件扩展名的列表。
%PROCESSOR_ARCHITECTURE%  系统 返回处理器的芯片体系结构。值：x86 或 IA64 基于
Itanium
%PROCESSOR_IDENTFIER% 系统 返回处理器说明。
%PROCESSOR_LEVEL%  系统 返回计算机上安装的处理器的型号。
%PROCESSOR_REVISION% 系统 返回处理器的版本号。
%PROMPT% 本地 返回当前解释程序的命令提示符设置。由 Cmd.exe 生成。
%RANDOM% 系统 返回 0 到 32767 之间的任意十进制数字。由 Cmd.exe 生成。
%SYSTEMDRIVE% 系统 返回包含 Windows server operating system 根目录（即系统根目录）
的驱动器。
%SYSTEMROOT%  系统 返回 Windows server operating system 根目录的位置。
%TEMP% 和 %TMP% 系统和用户 返回对当前登录用户可用的应用程序所使用的默认临时目录。
有些应用程序需要 TEMP，而其他应用程序则需要 TMP。
%TIME% 系统 返回当前时间。使用与 time /t 命令相同的格式。由 Cmd.exe 生成。有关
time 命令的详细信息，请参阅 Time。
%USERDOMAIN% 本地 返回包含用户帐户的域的名称。
%USERNAME% 本地 返回当前登录的用户的名称。
%USERPROFILE% 本地 返回当前用户的配置文件的位置。
%WINDIR% 系统 返回操作系统目录的位置。
```



# 条件判断

语法:

```bat
IF [NOT] ERRORLEVEL number command
IF [NOT] string1==string2 command
IF [NOT] EXIST filename command
```

增强用法中还有一些用来判断数字的符号：

```bat
EQU - 等于
NEQ - 不等于
LSS - 小于
LEQ - 小于或等于
GTR - 大于
GEQ - 大于或等于
```

> 示例:
>
> `IF EXIST filename (
>         del filename
>     ) ELSE (
>         echo filename missing
>     )` 
>
> 或者
>
> `if exist filename (del filename) else (echo filename missing)`

# 延时

延时子程序(精确度10毫秒，误差50毫秒内)

```bat
::-----------以下为延时子程序--------------------
:delay
@echo off
if "%1"=="" goto :eof
set DelayTime=%1
set TotalTime=0
set NowTime=%time%
::读取起始时间，时间格式为：13:01:05.95
:delay_continue
set /a minute1=1%NowTime:~3,2%-100
set /a second1=1%NowTime:~-5,2%%NowTime:~-2%0-100000
set NowTime=%time%
set /a minute2=1%NowTime:~3,2%-100
set /a second2=1%NowTime:~-5,2%%NowTime:~-2%0-100000
set /a TotalTime+=(%minute2%-%minute1%+60)%%60*60000+%second2%-%second1%
if %TotalTime% lss %DelayTime% goto delay_continue
goto :eof
```

调用延时子程序

`call :delay 10`

# 生成随机数

示例:

```bat
::生成5个100以内的随机数
@echo off
setlocal enabledelayedexpansion
for /L %%i in (1 1 5) do (
    set /a randomNum=!random!%%100
    echo 随机数：!randomNum!
)
pause
```

> 运行结果：（每次运行不一样）
> 随机数：91
> 随机数：67
> 随机数：58
> 随机数：26
> 随机数：20
> 请按任意键继续. . .

# 参考文档

https://www.cnblogs.com/iTlijun/p/6137027.html