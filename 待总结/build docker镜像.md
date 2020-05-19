build docker镜像



```shell
Docker Build

Docker Build: building image at path /var/jenkins_home/workspace/docker-geely-rvdc-measure-service-dev

Step 1/9 : FROM java:8
 ---> d23bdf5b1b1b

Step 2/9 : MAINTAINER Shenghao.Zhu@Geely.com
 ---> Using cache
---> a22be2636144

Step 3/9 : WORKDIR /geelyapp
 ---> Using cache
 ---> de4a9d0e4a57

Step 4/9 : ADD target/geely-rvdc-measure-service.jar application.jar
 ---> ee2e028bd06d

Step 5/9 : ADD skywalking-agent skywalking-agent
 ---> ade9152e47a0

# 配置生效哪个配置文件
Step 6/9 : ENV SPRING_PROFILES_ACTIVE="dev-aliyun"
 ---> Running in 51e17aea9524
Removing intermediate container 51e17aea9524
 ---> 0712d50632d2

# 配置JVM启动变量
Step 7/9 : ENV JVM_OPTS="-Xmx1g -Xms1g"
 ---> Running in eeedd3a75532
Removing intermediate container eeedd3a75532
 ---> 09f576b6f744

Step 8/9 : RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime   && echo 'Asia/Shanghai' >/etc/timezone EXPOSE 8800
 ---> Running in 71b482759e05
Removing intermediate container 71b482759e05
 ---> e918aab2b44e

# 设置命令行参数
Step 9/9 : ENTRYPOINT ["java","-javaagent:/geelyapp/skywalking-agent/skywalking-agent.jar","-Dskywalking.agent.service_name=geely-rvdc-measure-service","-jar","application.jar", "${JVM_OPTS}", "--spring.profiles.active=${SPRING_PROFILES_ACTIVE}"]
 ---> Running in 425ca75e8f0c
Removing intermediate container 425ca75e8f0c
 ---> e29279036bd5
Successfully built e29279036bd5
```

