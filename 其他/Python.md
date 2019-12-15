

# 介绍



# 安装

[下载链接](https://www.python.org/ftp/python/3.8.0/python-3.8.0-amd64.exe)

打开下载的文件并安装,按照步骤点击

![image-20191029121610623](/Users/yingjie.lu/Documents/note/.img/image-20191029121610623.png)

之后一路next即可

![image-20191029121957803](/Users/yingjie.lu/Documents/note/.img/image-20191029121957803.png)

![image-20191029122024025](/Users/yingjie.lu/Documents/note/.img/image-20191029122024025.png)

安装成功后测试:

- 打开cmd,输入python看能否进入python环境,输入exit()退出

# 替换pip为国内源

进入到当前用户目录下，创建`.pip`文件夹，然后在文件夹中创建`pip.conf`文件，再将源地址添加进去即可

以下是命令：

```shell
$ cd
$ mkdir .pip
$ cd .pip
$ vim pip.conf
```

将以下内容复制进入即可

```shell
[global]
index-url = https://mirrors.aliyun.com/pypi/simple
```

# 使用pip安装第三方包

## 查询：

pip search 包名

```shell
pip search requests
```

## 安装

pip install 包名

```shell
pip install requests
```

## 卸载

pip uninstall 包名

```shell
pip uninstall requests
```

## 查看命令帮助

```shell
pip3 --help
```

# 切换python版本

如果你使用的是brew安装的python，那么直接将环境变量中的python指向到新安装的python的bin目录下即可

1. 修改用户目录下的`.bash_profile`文件

   ```shell
   vim ~/.bash_profile
   ```

2. 将以下代码复制到文件中

   ```shell
   # 配置python3
   export Python3=/usr/local/Cellar/python/3.7.5/bin
   export PATH=$Python3:$PATH
   
   alias python=python3
   alias pip=pip3
   ```

3. 使得配置生效

   ```shell
   source ~/.bash_profile
   ```

验证是否配置成功：

- 在命令行输入`python --version`，如果出现了你想要的版本，那么就说明配置成功

# 总结

## 发送一个http请求

1. 安装第三方包`requests`

   ```shell
   pip3 install requests
   ```

2. 使用

   ```python
   # -*- coding: utf-8 -*-
   import sys
   import requests
   
   url="http://luyingjie.cn"
   response = requests.get(url)
   print(response.text)
   ```

## python获取外部传入的参数

调用命令为`py note.py D:/note/README.md`

```python
import sys #导入sys包
print(sys.argv) # 通过sys.argv可以获取到外部传入参数的一个数组
notePath=sys.argv[1] # 通过取到参数数组的第一个值来获取对应的参数
```

## 通过python执行cmd命令或调用本地应用程序

```python
import subprocess #导入subprocess包
cmd='"C:\Program Files\Typora\Typora.exe" "%s"' % (notePath) #定义cmd命令,通过''来包裹字符串可以使得字符串中可以存在一些特殊的字符,如空格等, notepath变量将会被替换到%s中
ps = subprocess.Popen(cmd); # 执行cmd命令
ps.wait();#让程序阻塞
```

## python转码

1. 安装第三方包`urlquote`

   ```shell
   pip3 install urlquote
   ```

2. 使用

   ```python
   from urllib.parse import unquote # 导入转码工具包
   # 将路径变量进行解码(从而可以使用中文)
   notePath=unquote(notePath[7:], 'utf-8') #将notePath变量先分割在进行转码
   ```

## 不让python的黑窗口出现

1. 使用pythonw(pyw)命令执行py脚本

## 将py文件转化为exe文件

1. 首先下载pyinstaller

   [下载对应的压缩包](https://github.com/pyinstaller/pyinstaller/archive/develop.tar.gz)并解压到指定目录(`D:\pyinstaller-develop`)

2. 在下载对应你的python版本的pywin32

   [pywin32网址](https://sourceforge.net/projects/pywin32/files/pywin32/Build 221/)

   双击pywin32-221.win-amd64-py3.5.exe安装，注意安装的时候会自动检测之前安装的Python。下一步，下一步。  

   > 最好在此过程中记录一下该文件的安装路径: `C:\Users\yingjie.lu\AppData\Local\Programs\Python\Python35\Lib\site-packages\`

   在cmd命令行进入Python3.5目录下的Scripts目录(默认路径为`C:\Users\yingjie.lu\AppData\Local\Programs\Python\Python35\Scripts`)并执行：`python pywin32_postinstall.py -install`命令  

   在cmd命令行中进入`D:\pyinstaller-develop`目录(之前解压的pyInstaller文件夹)，然后执行：`python setup.py install` 

3. 制作exe文件

   将.py文件放到`D:\pyinstaller-develop`目录下

   在cmd命令行中进入该目录,并执行命令` python pyinstaller.py -F note.py`

   生成了一个新目录`D:\pyinstaller-develop\hello`, 在该目录的dist文件夹下生成了一个hello.exe

# 参考文档

