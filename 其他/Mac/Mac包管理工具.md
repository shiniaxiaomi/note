[TOC]

# 介绍

包管理工具非常的方便，安装一些东西直接使用包管理工具安装即可，他会帮你配置好环境变量，非常的方便

本文使用的是`Homebrew`包管理工具

# 安装

在终端中输入命令：

```shell
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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