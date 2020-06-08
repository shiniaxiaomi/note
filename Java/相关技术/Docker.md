通过docker启动mysql镜像

```shell
docker run --name mysql -v /docker/mysql/data:/var/lib/mysql -p 3308:3306 -e MYSQL_ROOT_PASSWORD=aq1sw2de -d 172.22.122.21:5000/mysql-5.7  --lower_case_table_names=1
```

> --name mysql 指定镜像名称为mysql
>
> -v /docker/mysql/data:/var/lib/mysql 挂在docekr中mysql的数据到系统的/var/lib/mysql目录下
>
> -p 3308:3306 指定端口映射，将linux的3308映射到docker的3306
>
> -e MYSQL_ROOT_PASSWORD=密码 指定mysql的密码
>
> -d 172.22.122.21:5000/mysql-5.7 指定要启动mysql的镜像版本
>
> --lower_case_table_names=1 添加忽略大小写参数（要添加在最后面）