[TOC]

# 配置环境变量

## 环境变量应该去哪里找

可以在终端输入`echo $PATH`进行查看

```shel
$ echo $PATH
/usr/bin:/bin:/usr/sbin:/sbin
```

会出现以下4个路径：

- `/usr/bin`
- `/bin`
- `/usr/sbin`
- `/sbin`

这四个路径存放了许多应用的bin目录路径，一般是通过软连接的方式存放在这些文件夹中，然后将这个文件夹配置到PATH路径下，计算机就可以找到对应命令的bin目录了



按照这个思路，mac中的包管理工具brew就是通过来实现的；通过brew安装的应用都会存在于`/usr/local/Cellar`文件夹下，但是brew会将把这些应用的bin目录通过软连接的方式放到`/usr/local/bin`目录下，以便能够添加到PATH路径中



所以，如果我们如果找不到对应的命令，不妨输入`echo $PATH`，去`/usr/bin:/bin:/usr/sbin:/sbin`目录中去寻找一下，如果想要找到目录对应的安装路径，在找到PATH路径中找到了对应的bin目录，那么这个问题也就迎刃而解了

## 用户配置文件配置环境变量

1. 在用户目录下创建.bash_profile文件

   `touch ~/.bash_profile`

2. 编辑.bash_profile文件

   `vim ~/.bash_profile`

3. 添加环境变量

   ```shell
   export vscode=/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin
   export PATH=$vscode:$PATH
   ```

4. 让该配置文件立即生效

   `source  ~/.bash_profile`

5. 退出终端重新打开即可使用code命令来打开vscode

[参考链接](https://www.jianshu.com/p/f63611e8e821)

# 终端使用

1. 终端清屏

   真实清屏：`Command+K`

   假清屏：`Ctrl+L`

2. 搜索历史命令：`Ctrl+R`

3. 在Finder中打开当前目录：`open .`

# 快速搜索

可以用于搜索文件或者是搜索环境变量或者应用的安装路径

## 使用locate命令搜索

使用locate命令可以进行环境变量的搜索，该命令很高效，因为mac会维护文件的索引

```shell
locate java
locate java | grep java$
```

## 使用find命令搜索

使用find命令需要指定一个路径，然后计算机会遍历该路径下的所有文件进行搜索，相对来说，这样的效率是比较低的，但是该命令非常的好用，因为任何的文件都可以通过该命令搜索出来

示例如下：

```shell
find Documents/note -name Java*
```

## 使用Finder的智能搜索

使用Finder新建智能文件夹进行准确的搜索（名称+内容）