[TOC]

# 介绍

npm是一个包管理工具(Package Manager)

# 安装

新版本的nodejs已经集成了npm,只需要安装nodejs即可(安装方法可见笔记[node.js.md](./node.js.md))

# 替换npm

## 安装cnpm替换npm

使用淘宝定制的cnpm命令行工具代替默认的npm

安装cnpm

```cmd
npm install -g cnpm --registry=https://registry.npm.taobao.org
# 之后即可使用cnpm来安装包即可
cnpm install <包>
```

## 直接将npm的源替换成taobao的源（推荐）

1. 修改文件`/Users/yingjie.lu/.npmrc`

   在文件中加入

   ```shell
   registry =https://registry.npm.taobao.org
   ```

   保存即可

2. 直接输入命令：`npm config set registry https://registry.npm.taobao.org/`

验证是否配置成功：

在命令行中输入以下命令

```shell
$ npm config get registry
https://registry.npm.taobao.org/
```

如果配置的源则说明配置成功



如果想还原npm的镜像源，则直接删除`/Users/yingjie.lu/.npmrc`即可

## 安装其他模块

本地安装

- ```cmd
  npm install <包>    
  # 或者
  npm i <包>
  ```

  > 本地安装会将安装包放在当前目录下的node_modules 目录下(即运行 npm 命令时所在的目录),如果没有node_modules 目录,则会在当前目录下生成node_modules 目录

全局安装

- ```cmd
  npm install <包> -g   # 全局安装 
  ```

  > 全局安装会就将安装包放在你node的安装目录下

- 查看全局安装时安装包安装的位置

  ```cmd
  npm prefix -g
  ```

# 常用命令

- 查看命令帮助

  `npm help <某命令>`

- 列出各命令

  `npm -l`

- 查看安装信息

  ```cmd
  # 全局安装信息
  npm ls -g
  # 列出当前项目中的包
  npm ls
  ```

- 卸载包

  `npm uninstall <包名>`

- 更新包

  ```cmd
  # 更新当前项目中安装的某个包
  npm update <包名>
  # 更新当前项目中安装的所有包
  npm update
  # 更新全局安装的包
  npm update <包名> -g
  ```

- 搜索包

  `npm search <关键字>`

- 列出npm的配置

  `npm config list -l`

- 列出bin目录

  `npm bin`

# 使用package.json

当项目中需要依赖多个包时,就需要使用package.json记录下所使用到的包

- 它以文档的形式规定了项目所依赖的包
- 可以确定每个包所使用的版本
- 项目的构建可以重复，在多人协作时更加方便

创建package.json文件

- 通过`npm init`命令生成遵守规范的package.json文件

- 手动创建

  > 文件中必须包含: name和version

指定依赖包

- dependencies : 在生产环境中需要依赖的包

  使用`npm install <packge> --save`命令安装依赖包并自动添加依赖到文件（或者使用简写的参数 `-S`, `S`必须是大小）

- devDependencies: 仅在开发和测试环节中需要依赖的包

  > 使用`npm install <packge> --save-dev`命令自动添加依赖到文件（或者使用简写的参数 `-D`）

一键安装package.json中的依赖

- `npm install`

  > npm会根据package.json中记录的数据,将所依赖的包一次性的全部安装,方便快捷

设置默认配置

- 使用`npm set`命令设置环境变量,这些值会保存在`~/.npmrc`中

- ```js
  $ npm set init-author-name 'Your name'
  $ npm set init-author-email 'Your email'
  $ npm set init-author-url 'http://yourdomain.com'
  $ npm set init-license 'MIT'
  ```

- 下次在使用`npm init`创建项目时,会默认使用这些默认配置

更改全局安装目录

- 使用`npm config`进行配置

  `npm config set prefix <目录>`

  更改目录后记得在系统环境变量PATH中添加该路径

# npm脚本

`package.json`文件有一个`scripts`字段，可以用于指定脚本命令，供`npm`直接调用。

```js
"scripts": {
    "lint": "jshint **.js",
    "test": "mocha test/"
}
```

- `npm run lint`可以运行脚本中的 lint 命令
- `npm run test`可以运行脚本中的 test 命令

`npm run`命令会自动在环境变量`$PATH`添加`node_modules/.bin`目录，所以`scripts`字段里面调用命令时不用加上路径

















