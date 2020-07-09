安装npm：

1. brew search npm

2. brew install npm

---

配置npm的镜像：

1. 先查看一下npm的镜像源

   npm get registry 

2. 设置成淘宝镜像

   npm config set registry http://registry.npm.taobao.org/

   > 换回原始镜像：npm config set registry https://registry.npmjs.org/

---

使用：

通过npm config -h来查看config相关的命令：

- 通过`npm config ls -l`来查看所有的配置

- 从中可以看到：

  ```shell
  userconfig = "/Users/luyingjie/.npmrc"
  globalconfig = "/usr/local/etc/npmrc"
  registry = "https://registry.npmjs.org/"
  metrics-registry = "https://registry.npmjs.org/"
  ```

如果是用户配置，就直接修改`/Users/luyingjie/.npmrc`文件中的配置即可