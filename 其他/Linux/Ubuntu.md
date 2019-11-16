[TOC]

# 介绍

Ubuntu是另一种linux的派系，和CenterOS是不同的派系

# 命令

命令表格

| apt 命令         | 命令的功能                     |
| ---------------- | ------------------------------ |
| apt install      | 安装软件包                     |
| apt remove       | 移除软件包                     |
| apt purge        | 移除软件包及配置文件           |
| apt update       | 刷新存储库索引                 |
| apt upgrade      | 升级所有可升级的软件包         |
| apt autoremove   | 自动删除不需要的包             |
| apt full-upgrade | 在升级软件包时自动处理依赖关系 |
| apt search       | 搜索应用程序                   |
| apt show         | 显示装细节                     |

1. 他使用的apt包管理工具

   如果搜索不到软件，需要更新一下系统

   使用以下命令

   ```shell
   apt update 
   apt upgrade
   ```

2. 查询软件

   使用`apt search ...`来查询可以安装的软件

   示例：

   ```shell
   apt search java |grep openjdk-8-jdk
   ```

3. 安装软件

   ```shell
   apt install git
   apt install openjdk-8-jdk
   apt install nodejs
   apt install npm
   npm install -g forever
   apt install nginx-full
   ```

# apt一般的安装路径

- 一般的包基本上都安装在`/usr/share`目录下
- 可运行程序一般在/usr/bin, 库在/usr/lib

如果实在想找，用find、whereis、locate命令进行相应的查找





