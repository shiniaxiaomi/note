# 配置开机启动

软件配置开机启动后会在`~/Library/LaunchAgents`目录生成一个相对应软件的文件，如果该目录中存在对应的文件，那么开机的时候就会将该目录中存在的文件的对应软件全部启动

所以，如果想要去掉应用的开机启动，就去该目录下删除掉对应的软件的文件即可

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

# 终端

## 使用

1. 终端清屏

   真实清屏：`Command+K`

   假清屏：`Ctrl+L`

2. 搜索历史命令：`Ctrl+R`

3. 在Finder中打开当前目录：`open .`

## 在终端中使用代理

1. 使用shadowsocks代理

   右键`shadowsocks`，点击复制终端代理命令

   ![image-20191122232912045](/Users/yingjie.lu/Documents/note/.img/image-20191122232912045.png)

   默认的命令如下：

   ```shell
   export http_proxy=http://127.0.0.1:1087;export https_proxy=http://127.0.0.1:1087;
   ```

   复制到终端中回车即可

   注意：

   这种方式是能在当前的命令行窗口中开启了代理，如果换一个窗口，则不会使用代理（即在哪个窗口输入代理命令，即代理哪个窗口，只是临时生效）

2. 使用命令方式开启代理

   在终端中开启ssh连接，并监听本地的特定端口

   例如：

   ```shell
   ssh -D 20000 root@xxx.xxx.xxx.xxx
   ```

   > 这样，你的电脑就会监听本地的20000端口，当你把请求发送到20000端口时，就会通过这个端口往外转发（即代理），然后获取数据后并返回

   在开启ssh连接之后，还需要和第一种方法一样，在特定的窗口设置代理（推荐使用临时代理）

   ```shell
   # 配置http，https访问的
   export http_proxy=socks5://127.0.0.1:20000;export https_proxy=socks5://127.0.0.1:20000
   ```

   如果要永久性的修改代理配置，可以参考[链接](http://www.imooc.com/article/285912)，不过不推荐修改

## 解决ssh空闲时间自动断连的问题

修改`/etc/ssh/ssh_config`文件

```shell
sudo vim /etc/ssh/ssh_config
```

![image-20191122234252037](/Users/yingjie.lu/Documents/note/.img/image-20191122234252037.png)

在最下面一行添加以下内容即可：

```shell
ServerAliveInterval 60
```

具体的参考[链接](https://blog.csdn.net/SandyLoo/article/details/74979817)

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

# 其他设置

## 主次屏设置

只需要将小屏上方的白条拖到大屏上方即可

![image-20191223175835975](/Users/yingjie.lu/Documents/note/.img/image-20191223175835975.png)

