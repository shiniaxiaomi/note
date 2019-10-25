[TOC]

# 安装nuxt
`vue init nuxt-community/starter-template  <project-name>`

# 进入项目安装依赖
`cnpm install #`

# 其他操作
- 回退版本 `cnpm install  core-js@2.6.2 -S`
- 安装cross-env `cnpm i cross-env -S`
- 安装elementUI `cnpm i  element-ui -S`
- 安装axios `cnpm i axios -S`
- 安装crypto `cnpm i crypto -S`

# 配置nuxt.config.js(参考)
```js
//防止nuxt结合elementUI的时候报错
global.HTMLElement =
  typeof window === "undefined" ? Object : window.HTMLElement;

module.exports = {
  /*
   ** Headers of the page
   */
  head: {
    title: "notes-nuxt",
    meta: [
      { charset: "utf-8" },
      { name: "viewport", content: "width=device-width, initial-scale=1" },
      { hid: "description", name: "description", content: "Nuxt.js project" }
    ],
    link: [{ rel: "icon", type: "image/x-icon", href: "/favicon.ico" }]
  },
  css: ["element-ui/lib/theme-chalk/index.css"],
  plugins: [
    // ssr: true表示这个插件只在服务端起作用
    { src: "~/plugins/ElementUI", ssr: true }
    // { src: "~/plugins/localstorange", ssr: false },
    // { src: "~/plugins/auth.js", ssr: false }
  ],
  env: {
    BASE_URL: process.env.BASE_URL,
    NODE_ENV: process.env.NODE_ENV
  },
  /*
   ** Customize the progress bar color
   */
  loading: { color: "#3B8070" },
  /*
   ** Build configuration
   */
  build: {
    /*
     ** Run ESLint on save
     */
    extend(config, { isDev, isClient }) {
      if (isDev && isClient) {
        config.module.rules.push({
          enforce: "pre",
          test: /\.(js|vue)$/,
          // loader: "eslint-loader",
          exclude: /(node_modules)/
        });
      }
    },
    // 防止element-ui被多次打包
    vendor: ["element-ui", "axios"]
  }
};
```

# 配置package.json(参考)
```js
{
  "name": "notes-nuxt",
  "version": "1.0.0",
  "description": "Nuxt.js project",
  "author": "陆英杰 <34340797+shiniaxiaomi@users.noreply.github.com>",
  "private": true,
  "config": {
    "nuxt": {
      "host": "0.0.0.0",
      "port": "80"
    }
  },
  "scripts": {
    "dev": "cross-env BASE_URL=http://127.0.0.1:8000 NODE_ENV=dev nuxt",
    "build": "cross-env BASE_URL=http://134.175.150.32:10000 NODE_ENV=prod nuxt build",
    "start": "cross-env BASE_URL=http://134.175.150.32:10000 NODE_ENV=prod nuxt start",
    "generate": "nuxt generate",
    "lint": "eslint --ext .js,.vue --ignore-path .gitignore .",
    "precommit": "npm run lint"
  },
  "dependencies": {
    "nuxt": "^2.0.0",
    "axios": "^0.18.0",
    "crypto": "^1.0.1",
    "element-ui": "^2.8.2"
  },
  "devDependencies": {
    "babel-eslint": "^10.0.1",
    "eslint": "^4.19.1",
    "eslint-friendly-formatter": "^4.0.1",
    "eslint-loader": "^2.1.1",
    "eslint-plugin-vue": "^4.0.0"
  }
}

```

# 配置plugins文件夹文件
## axios.js
```js
import axios from "axios";
import qs from "qs";
import Vue from "vue";

// 设置baseURL
axios.defaults.baseURL = process.env.BASE_URL;
// axios.defaults.baseURL = "http://127.0.0.1:8000"; //本地
// axios.defaults.baseURL = "http://134.175.150.32:10000"; //生产服务器ip地址

// 允许携带cookie
axios.defaults.withCredentials = true;

// 将请求的参数转化成key-value的形式，方便后端springmvc直接进行参数绑定
axios.defaults.transformRequest = function(data) {
  return qs.stringify(data);
};

const Axios = axios.create();

//添加请求拦截器
// Axios.interceptors.request.use(
//     config => {
//         //在发送请求之前做某事，比如说 设置loading动画显示
//         return config;
//     },
//     error => {
//         //请求错误时做些事
//         return Promise.reject(error);
//     }
// );

//添加响应拦截器
// Axios.interceptors.response.use(
//     response => {
//         //对响应数据做些事，比如说把loading动画关掉
//         return response;
//     },
//     error => {
//         //请求错误时做些事
//         return Promise.reject(error);
//     }
// );

// 创建axios对象，暴露
export default Axios;

```

## ElementUI.js
```js
import Vue from 'vue'
import ElementUI from 'element-ui'
Vue.use(ElementUI)
```

# 最终运行
`npm run dev`