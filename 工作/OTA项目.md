应用部署对应负责人

原始非配：

| 服务名称                   | 部署机器      | 开发责任人                          | 说明                                 |
| :------------------------- | ------------- | ----------------------------------- | ------------------------------------ |
| ros-glcarcom-translator    | 172.22.122.22 | Yan.Liang1/Fanlin.Zeng/Yingjie.Lu   | 翻译GLCARCOM消息的服务，进行消息提取 |
| ros-operation-logs-service | 172.22.122.22 | Yan.Liang1/Fanlin.Zeng/Yingjie.Lu   | 后台页面用户操作日志服务             |
| ros-security-service       | 172.22.122.25 | Yan.Liang1/Fanlin.Zeng/Yingjie.Lu   | SSO，TOKEN发放，权限验证服务         |
| ros-odoo-service           | 172.22.122.25 | Yan.Liang1/Fanlin.Zeng/Yingjie.Lu   | 和ODOO系统对接服务                   |
| ros-workflow-service       | 172.22.122.25 | Yan.Liang1/Fanlin.Zeng/Yingjie.Lu   | ROS系统内部处理工作流，审批服务      |
| ros-tsp-gateway-service    | 172.22.122.21 | Yan.Liang1/Fanlin.Zeng              |                                      |
| ros-notice-service         | 172.22.122.21 | Yan.Liang1/Fanlin.Zeng              |                                      |
| ros-file-service           | 172.22.122.21 | Yan.Liang1/Fanlin.Zeng              |                                      |
| rvdc-measure-service       | 172.22.122.26 | Yan.Liang1/e-qimengchao/Fanlin.Zeng |                                      |

当前分配：

| 服务名称                   | 部署机器      | 开发责任人    | 说明                                       | 是否启动成功                                                 |
| -------------------------- | ------------- | ------------- | ------------------------------------------ | ------------------------------------------------------------ |
| ros-workflow-service       | 172.22.122.25 | 陆英杰        | ROS系统内部处理工作流，审批服务            | 失败：有一个jar包冲突了                                      |
| rvdc-measure-service       | 172.22.122.26 | 陆英杰        | 处理TSP上行跟RVDC任务相关消息的服务        | 启动成功：修改了数据库连接地址和nacos注册地址                |
| rvdc-admin-api             | 172.22.122.26 | 陆英杰        | 处理用户在界面上操作RVDC任务相关动作的服务 | 启动成功：修改了数据库连接地址和nacos注册地址                |
| rvdc-task-service          | 172.22.122.26 | 戚梦超/陆英杰 | 处理RVDC异步定时任务的服务                 | 启动成功：根据dev-aliyun配置文件添加了dev-geely配置文件，修改了数据连接地址和nacos注册地址<br /><br />eureka的地址不能连接 |
| rvdc-data-analysis-service | 172.22.122.26 | 戚梦超/陆英杰 | 处理RVDC统计任务相关功能的服务             | 启动成功：根据dev-aliyun配置文件添加了dev-geely配置文件，修改了数据连接地址<br />修改了bootstrap.yml的nacos注册地址 |





运行命令：

- rvdc-data-analysis-service（成功）服务名：geely-rvdc-analysis-service

  ```java
  nohup java -jar geely-rvdc-analysis-service.jar --spring.profiles.active=dev-aliyun >/dev/null 2>&1 &
  ```

- rvdc-task-service(成功) 服务名：geely-rvdc-task-service

  ```java
  scp geely-rvdc-task-service.jar root@172.22.122.26:~/lyj
  ```

  ```java
  nohup java -jar geely-rvdc-task-service.jar --spring.profiles.active=dev-aliyun >/dev/null 2>&1 &
  ```

- rvdc-admin-api(成功) 服务名：geely-rvdc-admin-service

  ```java
  nohup java -jar geely-rvdc-admin-service.jar --spring.profiles.active=dev-aliyun >/dev/null 2>&1 &
  ```

- rvdc-measure-service(成功) 服务名：geely-rvdc-measure-service

  ```java
  nohup java -jar geely-rvdc-measure-service.jar --spring.profiles.active=dev-aliyun >/dev/null 2>&1 &
  ```

- ros-workflow-service(部署在25上-没成功) 服务名：geely-ros-business-state-service

  ```java
  scp geely-ros-business-state-service.jar root@172.22.122.25:~/lyj
  ```

  ```java
  nohup java -jar geely-ros-business-state-service.jar --spring.profiles.active=dev-aliyun >/dev/null 2>&1 &
  ```

  

ps -ef |grep geely-r



JVM的参数配置:

```java
-Xmx1g -Xms1g
```



指定程序运行的参数：

```java
--spring.profiles.active=dev-geely
--spring.cloud.nacos.config.server-addr=172.22.122.21:8848
--spring.cloud.nacos.discovery.server-addr=172.22.122.21:8848
```



bootstrap的优先级最高，配置不会被覆盖