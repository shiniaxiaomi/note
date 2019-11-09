Ubuntu是另一种linux的派系，和CenterOS是不同的派系



他使用的apt包管理工具

如果搜索不到软件，需要更新一下系统

使用以下命令

```shell
apt update 
apt upgrade
```



查询软件

使用`apt search ...`来查询可以安装的软件

示例：

```shell
apt search java |grep openjdk-8-jdk
```



安装软件

```shell
apt install git
apt install openjdk-8-jdk
apt install nodejs
apt install npm
npm install -g forever
apt install nginx-full
```



