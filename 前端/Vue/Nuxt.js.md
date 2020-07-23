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
    package.js
  ```
  
    第二次部署只需要更新`.nuxt`文件即可

## 安装依赖，运行项目

- 进入项目路径,安装依赖
    `cnpm i #`
- 使用pm2启动项目 
    `pm2 start npm --name "72cun-nuxt" -- run start`

# nuxt项目的详细记录

## 创建页面

在pages目录中的所有的*.vue文件都会自动的生成应用的路由配置

例如:

在pages目录下创建hello.vue文件,内容如下:

```vue
<template>
  <h1>Hello world!</h1>
</template>
```

然后启动项目:

```shell
npm run dev
```

打开链接:`http://localhost:3000/hello`

> 即在pages目录下创建的vue文件件,就是一个路由请求,请求就为该文件的名称

## 目录结构说明

### nuxt.config.js 文件

> 配置文件

1. css
   
   配置所有页面都需要引用的css文件

2. dev
   
   配置当前的nuxt引用是开发模式还是生产模式
   
   > 默认值为true
   > 
   > 当使用`nuxt`命令时,dev会被强制设置为true
   > 
   > 当使用`nuxt build`,`nuxt start`或`nuxt generate`命令时,dev会被强制设置成false

3. env
   
   配置客户端和服务端的环境变量
   
   使用方式:
   
   ```js
   module.exports = {
     env: {
       baseUrl: process.env.BASE_URL || 'http://localhost:3000'
     }
   }
   ```
   
   编译前:
   
   ```js
   if (process.env.test == 'testing123')
   ```
   
   编译后:
   
   ```js
   if ('testing123' == 'testing123')
   ```

4. head
   
   配置应用默认的meta标签

5. plugins
   
   配置需要在根vue.js应用实例化之前需要运行的JavaScript插件

6. server
   
   配置服务器实例变量

## 动态路由

示例:

在pages目录下创建blog目录,在blog目录下创建`_id.vue`文件

然后在`_id.vue`文件中使用时可以通过`this.$route.params.id`可以在vue的data中使用并获取到对应路由中传入的id值

## 默认页面的结构布局

可以通过在`layouts/default.vue`文件来扩展应用的默认布局

> 注意:别忘了在布局文件中添加`<nuxt/>`组件用于显示页面的主图内容

默认布局`default.vue`的源码如下:

```vue
<template>
  <nuxt/>
</template>
```

自定义布局`blog.vue`示例:

```vue
<template>
  <div>
    <div>博客导航栏</div>
    <nuxt/>
  </div>
</template>
```

在pages目录下的`*.vue`文件都是默认使用`default.vue`的默认布局,如果你需要在某个文件中使用自定义布局,那么,我们需要在指定的`*.vue`文件中指明使用哪个布局文件,如告诉`pages/posts.vue`页面使用自定义布局:

```vue
<template>
  ...
</template>
<script>
export default {
  layout: 'blog' //指定使用哪个布局
}
</script>
```

## 异步数据asyncData方法

`asyncData`方法会在组件(页面组件)每次加载之前被调用,他可以在服务端或路由更新之前被调用,这个方法被调用时,第一个参数为当前页面的上下文对象,可以通过该对象获取对应的数据,如动态路由中的数据:

```js
export default {
  async asyncData ({ params }) {
    const { data } = await axios.get(`https://my-api/posts/${params.id}`)
    return { title: data.title }
  }
}
```

通过`asyncData`方法返回的数据会融合data方法返回的数据后,一并返回给模板进行数据展示,如:

```vue
<template>
  <h1>{{ title }}</h1>
</template>
```

## 服务端调用vue的生命周期

在任何 Vue 组件的[生命周期](https://vuejs.org/v2/guide/instance.html#Lifecycle-Diagram)内， 只有 `beforeCreate` 和 `created` 这两个方法会在 **客户端和服务端**被调用。其他生命周期函数仅在客户端被调用。

## 使用第三方模块

使用在客户端和服务端使用 [axios](https://github.com/mzabriskie/axios) 做 HTTP 请求 示例:

首先使用npm安装axios:

```shell
npm install --save axios
```

然后在页面中这样使用:

```vue
<template>
  <h1>{{ title }}</h1>
</template>

<script>
import axios from 'axios'

export default {
  async asyncData ({ params }) {
    let { data } = await axios.get(`https://my-api/posts/${params.id}`)
    return { title: data.title }
  }
}
</script>
```

## 使用Vue插件

使用[vue-notifications](https://github.com/se-panfilov/vue-notifications)插件显示应用的通知信息 示例:

首先增加文件 `plugins/vue-notifications.js`,内容如下：

```js
import Vue from 'vue'
import VueNotifications from 'vue-notifications'

Vue.use(VueNotifications)
```

然后,在`nuxt.config.js` 内配置 `plugins` 如下：

```js
module.exports = {
  plugins: ['~/plugins/vue-notifications']
}
```
