[TOC]

# 配置环境变量

1. 编辑配置文件：`sudo vi /etc/profile`

2. 添加环境变量：

   ```shell
   export MAVEN_HOME=/usr/local/apache-maven-3.6.0
   export PATH=$PATH:$MAVEN_HOME
   ```

3. 使配置文件立即生效

   `source /etc/profile`

# 终端使用

1. 终端清屏

   真实清屏：`Command+K`

   假清屏：`Ctrl+L`

2. 搜索历史命令

   