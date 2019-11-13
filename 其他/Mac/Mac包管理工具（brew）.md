[TOC]

# 介绍

包管理工具非常的方便，安装一些东西直接使用包管理工具安装即可，他会帮你配置好环境变量，非常的方便

本文使用的是`Homebrew`包管理工具

# 安装

在终端中输入命令：

```shell
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

# 修改国内源(阿里云)

1. 替换brew.git

   进入到仓库的指定目录

   ```shell
   cd "$(brew --repo)"
   ```

   替换brew.git

   ```shell
   git remote set-url origin https://mirrors.aliyun.com/homebrew/brew.git
   ```

   进入到仓库的指定目录

   ```shell
   cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
   ```

   替换homebrew-core.git

   ```shell
   git remote set-url origin https://mirrors.aliyun.com/homebrew/homebrew-core.git
   ```

   刷新源

   ```shell
   brew update
   ```

# 包管理工具的原理

使用包管理工具brew进行安装，它会将软件都安装在`/usr/local/Cellar`目录下

并且它会将软件的命令通过软连接的方式放到`/usr/local/bin`目录下，这样就直接配置了环境变量，就不需要我们手动的再去配置了

# 常用命令

- brew help [COMMAND]

  命令帮助文档

- brew search 正则表达式

  搜索软件

- brew install 软件名

  安装软件

- brew uninstall 软件名

  卸载软件

- brew list [软件名]

  列出软件

  示例：

  当要修改已经安装的maven的配置文件时，输入以下命令进行查找

  ```shell
  $ brew list maven
  /usr/local/Cellar/maven/3.6.2/bin/mvn
  /usr/local/Cellar/maven/3.6.2/bin/mvnDebug
  /usr/local/Cellar/maven/3.6.2/bin/mvnyjp
  /usr/local/Cellar/maven/3.6.2/libexec/bin/ (4 files)
  /usr/local/Cellar/maven/3.6.2/libexec/boot/plexus-classworlds-2.6.0.jar
  /usr/local/Cellar/maven/3.6.2/libexec/conf/ (3 files)
  /usr/local/Cellar/maven/3.6.2/libexec/lib/ (55 files)
  ```

  从上面可以看到，maven的配置文件就位于`/usr/local/Cellar/maven/3.6.2/libexec/conf/`目录下，非常的方便

- brew update

  更新Homebrew源

- brew upgrade [软件名]

  更新该软件包（如果软件名不写，则全部更新）

更多命令：[Homebrew中文网站](https://brew.sh/index_zh-cn.html)

# 示例

- 如果搜索不到对应的软件，就更新一下Homebrew源

  ```shell
  brew update
  brew upgrade
  ```

- 搜索软件

  ```shell
  brew search nodejs
  ```

- 安装软件

  ```shell
  brew install nodejs
  ```

- 查询软件是否安装

  ```shell
  brew list nodejs
  ```

- 卸载软件

  ```sHell
  brew uninstall nodejs
  ```

# 参考文档

[Homebrew-CSDN](https://blog.csdn.net/TransientJoy/article/details/77866704)

[Homebrew中文网站](https://brew.sh/index_zh-cn.html)