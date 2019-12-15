# 快速安装nuxt.js
- 使用vue脚手架进行初始化
    `vue init nuxt-community/starter-template  <project-name>`
- 进入到对应的路径后安装上package.js上的依赖
    `cnpm install #`
- 将core-js退回到2.6.2版本
    `cnpm install  core-js@2.6.2 -S`
- 运行项目      
    `npm run dev`

# 在linux上部署nuxt.js
## 安装node.js(自带npm包管理工具)
- 下载node.js       
    https://nodejs.org/en/download/
    ![](/Users/yingjie.lu/Documents/note/.img/cms522565.png)
- 将下载好的压缩包上传至服务器的中，进入压缩包所在的目录，然后运行解压命名      
    `tar -vxf node-v0.10.26-linux-x64.tar.gz`
- 解压完成后进入解压后的`nodejs`中的`bin`目录，执行ls会看到两个文件`node`和`npm`，执行命令`./node -v`
    ```shell
    cd node-v0.10.26-linux-x64/bin
    ls
    ./node -v
    ```
- 将npm 和node两个命令设置成全局变量
    ```shell
    ln -s /lyj/node-v0.10.28-linux-x64/bin/node /usr/local/bin/node
    ln -s /lyj/node-v0.10.28-linux-x64/bin/npm /usr/local/bin/npm
    ```
- 设置安装全局的模块的安装路径
    - 查看默认全局安装路径
    `npm config get prefix`
    - 1.新建一个全局安装的路径
    `npm config get prefix`
    - 2.配置npm使用新的路径
    `npm config set prefix '~/.npm-global'`
    - 3.编辑~/.bashrc文件，加入下面一行
        ```shell
        vim ~/.bashrc 
        export PATH=~/.npm-global/bin:$PATH
        ```
    - 4.更新系统环境变量(永久更新系统环境变量)
    `source ~/.bashrc`
- 安装cnpm(linux)
    ```shell
    npm install -g cnpm --registry=https://registry.npm.taobao.org
    ln -s /lyj/node-v0.10.28-linux-x64/bin/cnpm /usr/local/bin/cnpm
    ```
- 安装cnpm(windows)
`npm install -g cnpm --registry=https://registry.npm.taobao.org`  
找到`nodejs\node_global`的文件夹,在此文件夹下运行上述该命令即可全局安装cnpm

## 项目编译上传
- 对项目进行编译
    `npm run build`
- 首次部署需要将4个文件上传至服务器中
    ```java
    .nuxt
    static
    nuxt.config.js
    packa.js
    ```
    第二次部署只需要更新`.nuxt`文件即可

## 安装依赖，运行项目
- 进入项目路径,安装依赖
    `cnpm i #`
- 使用pm2启动项目 
    `pm2 start npm --name "72cun-nuxt" -- run start`