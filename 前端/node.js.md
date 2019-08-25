[TOC]

# 介绍 

node.js就是运行在服务端的javascript

node.js是一个基于chrome JavaScript运行是建立的一个平台

node.js是一个事件驱动I/O服务端JavaScript环境,基于Google的V8引擎,性能非常好

# 安装

在Windows下安装

- 直接去[官网](https://nodejs.org/en/download/)上下载.exe文件,安装即可使用

- 检查是否安装成功

  ```cmd
  node --version
  ```

在linux下安装

- 下载直接解压即可

  ```cmd
  wget https://nodejs.org/dist/v10.9.0/node-v10.9.0-linux-x64.tar.xz    # 下载
  tar xf  node-v10.9.0-linux-x64.tar.xz       # 解压
  cd node-v10.9.0-linux-x64/                  # 进入解压目录
  ./bin/node -v                               # 执行node命令 查看版本
  ```

# helloworld

在命令行中输入命令

- 在命令行中输入node,即可进入node环境
- 输入`console.log("Hello World")`即可运行输出结果

在命令行中运行js

- 编写hello.js

  ```js
  console.log("Hello World")
  ```

- 运行hello.js

  ```cmd
  node hello.js # 使用node运行js
  ```

# 创建web应用

- 创建一个server.js文件

- 引入需要用到的模块

  使用`require`指令来载入其他用到的模块

  ```js
  var http = require("http");
  ```

- 创建服务器

  ```js
  http.createServer(function (request, response) {
      // 发送 HTTP 头部 
      // HTTP 状态值: 200 : OK
      // 内容类型: text/plain
      response.writeHead(200, {'Content-Type': 'text/plain'});
  
      // 发送响应数据 "Hello World"
      response.end('Hello World\n');
  }).listen(8888);
  
  // 终端打印如下信息
  console.log('Server running at http://127.0.0.1:8888/');
  ```

- 运行server.js

  ```cmd
  node server.js
  ```

# npm包管理工具

npm是随同nodejs一起安装的包管理工具

当需要使用到其他模块的使用,可以是使用npm来方便的下载对应的模块

npm的教程可见笔记[npm.md](./npm.md)

# 回调函数

node.js 异步编程的直接体现就是回调。node使用了大量的回调函数，node所有 API 都支持回调函数,这就大大提高了 Node.js 的性能，可以处理大量的并发请求

回调函数一般作为函数的最后一个参数出现

```js
function foo1(name, age, callback) { }
function foo2(value, callback1, callback2) { }
```

示例

- 读取文件

  ```js
  var fs = require("fs");
  
  fs.readFile('input.txt', function (err, data) {
      if (err) return console.error(err);
      console.log(data.toString());
  });
  
  console.log("程序执行结束!");
  ```

  运行结果

  ```js
  程序执行结束!
  菜鸟教程官网地址：www.runoob.com
  ```

# 事件循环

node.js是单进程单线程应用程序,但是V8引擎提供了异步执行回调接口,通过这些接口可以处理大量的并发

node.js中基本上所有的事件机制都是用设计模式中的观察者模式实现的

node.js单线程类似进入一个while(true)的事件循环,直到没有事件观察者退出,每个异步事件都生成一个事件观察者,如果有事件发生就调用该回调函数

# EventEmitter

EventEmitter属于events模块,通过示例化EventEmitter类来绑定和监听事件

步骤

- 引入events模块,创建EventEmitter对象

  ```js
  // 引入 events 模块
  var events = require('events');
  // 创建 eventEmitter 对象
  var eventEmitter = new events.EventEmitter();
  ```

- 绑定事件处理程序

  ```js
  // 绑定事件及事件的处理程序
  eventEmitter.on('eventName', eventHandler);
  ```

- 触发事件,从而触发回调函数

  ```js
  // 触发事件
  eventEmitter.emit('eventName');
  ```

示例

- 创建event.js文件

  ```js
  var EventEmitter = require('events').EventEmitter; 
  var event = new EventEmitter();
  // 绑定回调事件
  event.on('some_event', function() { 
      console.log('some_event 事件触发'); 
  }); 
  setTimeout(function() { 
      //触发回调事件
      event.emit('some_event'); 
  }, 1000); 
  ```

# Buffer

缓冲区,专门存放二进制数据的缓冲区

# Stream

Stream 是一个抽象接口，Node 中有很多对象实现了这个接口; 例如，对http 服务器发起请求的request 对象就是一个 Stream，还有stdout（标准输出）。

四种类型

- Readable - 可读操作。
- Writable - 可写操作。
- Duplex - 可读可写操作.
- Transform - 操作被写入数据，然后读出结果。

所有的Stream对象都是EventEmitter 的实例,常用的事件有:

- data - 当有数据可读时触发。
- end - 没有更多的数据可读时触发。
- error - 在接收和写入过程中发生错误时触发。
- finish - 所有数据已被写入到底层系统时触发。

示例

- 从流中读取数据

  读取文本

  ```js
  var fs = require("fs");
  var data = '';
  
  // 创建可读流
  var readerStream = fs.createReadStream('input.txt');
  
  // 设置编码为 utf8。
  readerStream.setEncoding('UTF8');
  
  // 处理流事件 --> data, end, and error
  readerStream.on('data', function(chunk) {
     data += chunk;
  });
  readerStream.on('end',function(){
     console.log(data);
  });
  readerStream.on('error', function(err){
     console.log(err.stack);
  });
  
  console.log("程序执行完毕");
  ```

- 写入流

  写入文本

  ```js
  var fs = require("fs");
  var data = '菜鸟教程官网地址：www.runoob.com';
  
  // 创建一个可以写入的流，写入到文件 output.txt 中
  var writerStream = fs.createWriteStream('output.txt');
  
  // 使用 utf8 编码写入数据
  writerStream.write(data,'UTF8');
  
  // 标记文件末尾
  writerStream.end();
  
  // 处理流事件 --> finish and error
  writerStream.on('finish', function() {
      console.log("写入完成。");
  });
  writerStream.on('error', function(err){
     console.log(err.stack);
  });
  
  console.log("程序执行完毕");
  ```

- 管道流

  管道提供了一个输出流到输入流的机制。通常我们用于从一个流中获取数据并将数据传递到另外一个流中。一般可用在复制文件等

  ```js
  var fs = require("fs");
  
  // 创建一个可读流
  var readerStream = fs.createReadStream('input.txt');
  
  // 创建一个可写流
  var writerStream = fs.createWriteStream('output.txt');
  
  // 管道读写操作
  // 读取 input.txt 文件内容，并将内容写入到 output.txt 文件中
  readerStream.pipe(writerStream);
  
  console.log("程序执行完毕");
  ```

- 链式流

  链式是通过连接输出流到另外一个流并创建多个流操作链的机制。链式流一般用于管道操作。

  接下就是用管道和链式来压缩和解压文件。

  ```js
  var fs = require("fs");
  var zlib = require('zlib');
  
  // 压缩 input.txt 文件为 input.txt.gz
  fs.createReadStream('input.txt')
    .pipe(zlib.createGzip())
    .pipe(fs.createWriteStream('input.txt.gz'));
    
  console.log("文件压缩完成。");
  ```

# 模块系统

为了让Node.js的文件可以相互调用，Node.js提供了一个简单的模块系统。

简单的创建模块

- 创建模块
  - 创建hello.js模块

    ```js
    exports.world = function() {
      console.log('Hello World');
    }
    ```

    > hello.js 通过 exports 对象把 world 作为模块的访问接口, 在 main.js 中通过 require('./hello') 加载这个模块，然后就可以直接访问 hello.js 中 exports 对象的成员函数了。

    即exports对象就是require所获取的对象,那个对象就可以直接使用world这个方法

- 引入模块并调用
  - ```js
    var hello = require('./hello');
    hello.world();
    ```

把一个对象封装到模块中

- 创建hello.js

  ```js
  function Hello() { 
      var name; 
      this.setName = function(thyName) { 
          name = thyName; 
      }; 
      this.sayHello = function() { 
          console.log('Hello ' + name); 
      }; 
  }; 
  module.exports = Hello;
  ```

  将Hello直接赋值给module.exports,那么通过require获取到的就是一个对象,使用时需要new一个对象

- 引入模块并使用

  ```js
  //main.js 
  var Hello = require('./hello'); 
  hello = new Hello(); 
  hello.setName('BYVoid'); 
  hello.sayHello(); 
  ```

系统模块

- 使用

  `var http = require("http");`

模块的加载

- require方法接受以下几种参数的传递
  - http、fs、path等，原生模块。
  - ./mod或../mod，相对路径的文件模块。
  - /pathtomodule/mod，绝对路径的文件模块。
  - mod，非原生模块的文件模块。

总结

- exports 和 module.exports 的使用

  如果要对外暴露属性或方法，就用 exports 就行，要暴露对象(类似class，包含了很多属性和方法)，就用 module.exports。

# 函数

在JavaScript中，一个函数可以作为另一个函数的参数; 我们可以先定义一个函数，然后传递，也可以在传递参数的地方直接定义函数。

示例

- 声明函数

  ```js
  function say(word) {
    console.log(word);
  }
  
  function execute(value , someFunction) {
    someFunction(value);
  }
  
  execute("Hello" , say);
  ```

- 匿名函数

  ```js
  function execute(value , someFunction) {
    someFunction(value);
  }
  
  execute("Hello",function(word){ 
      console.log(word) 
  });
  ```

# 全局对象

全局对象的所有属性都可以在程序的任何地方访问

 Node.js 中的全局对象是 global

- __filename

  表示当前正在执行的脚本的文件名, 他将输出文件所在位置的绝对路径

  示例

  - `console.log( __filename );`

- __dirname

  表示当前执行脚本所在的目录

  示例

  - `console.log( __dirname );`

- setTimeout(cb, ms)

  全局函数,在指定的毫秒(ms)数后执行指定函数(cb); setTimeout() 只执行一次指定函数; 返回一个代表定时器的句柄值。

  示例

  - ```js
    function printHello(){
       console.log( "Hello, World!");
    }
    // 两秒后执行以上函数
    setTimeout(printHello, 2000);
    ```

- clearTimeout(t)

  全局函数,用于停止一个之前通过 setTimeout() 创建的定时器; 参数 t 是通过 setTimeout() 函数创建的定时器。

  示例

  - ```js
    function printHello(){
       console.log( "Hello, World!");
    }
    // 两秒后执行以上函数
    var t = setTimeout(printHello, 2000);
    
    // 清除定时器
    clearTimeout(t);
    ```

- setInterval(cb, ms)

  全局函数,在指定的毫秒(ms)数后执行指定函数(cb)。setInterval() 方法会不停地调用函数，直到 clearInterval() 被调用或窗口被关闭。

  示例

  - `setInterval(printHello, 2000);`

- console

  用于提供控制台标准输出

  示例

  - ```js
    console.log('Hello world'); 
    console.log('byvoid%diovyb', 1991); 
    ```

    > 结果
    >
    > ```js
    > Hello world 
    > byvoid1991iovyb 
    > ```

- [process](https://www.runoob.com/nodejs/nodejs-global-object.html)

  用于描述当前Node.js 进程状态的对象，提供了一个与操作系统的简单接口

  - 事件

    - 示例

      ```js
      process.on('exit', function(code) {  
        console.log('退出码为:', code);
      });
      console.log("程序执行结束");
      ```

      结果

      ```js
      程序执行结束
      退出码为: 0
      ```

  - 退出状态码

    - 很多...

  - 属性

    - 示例

      ```js
      // 获取执行路径
      console.log(process.execPath);
      ```

  - 方法

    - 示例

      ```js
      // 输出当前目录
      console.log('当前目录: ' + process.cwd());
      
      // 输出当前版本
      console.log('当前版本: ' + process.version);
      
      // 输出内存使用情况
      console.log(process.memoryUsage());
      ```

# [fs模块](https://www.runoob.com/nodejs/nodejs-fs.html)

标准的文件操作API,文件系统模块(fs)

`var fs = require("fs")`

示例

- 读取文件

  - 异步读取文件

    ```js
    var fs = require("fs");
    
    // 异步读取
    fs.readFile('input.txt', function (err, data) {
       if (err) {
           return console.error(err);
       }
       console.log("异步读取: " + data.toString());
    });
    ```

  - 同步读取文件

    ```js
    var fs = require("fs");
    
    // 同步读取
    var data = fs.readFileSync('input.txt');
    console.log("同步读取: " + data.toString());
    ```

- 写入文件

  ```js
  var fs = require("fs");
  
  fs.writeFile('input.txt', '我是通 过fs.writeFile 写入文件的内容',  function(err) {
     if (err) {
         return console.error(err);
     }
     console.log("数据写入成功！");
  });
  ```

- 关闭文件

  `fs.close(fd, callback)`

  参数

  - fd - 通过 fs.open() 方法返回的文件描述符。
  - callback - 回调函数，没有参数。

- 删除文件

  `fs.unlink(path, callback)`

- 创建目录

  `fs.mkdir(path[, options], callback)`

  参数

  - path - 文件路径。
  - options 参数可以是：
    - recursive - 是否以递归的方式创建目录，默认为 false。
    - mode - 设置目录权限，默认为 0777。
  - callback - 回调函数，没有参数。

- 读取目录

  `fs.readdir(path, callback)`

  > 回调函数带有两个参数err, files，err 为错误信息，files 为 目录下的文件数组列表。

- 删除目录

  `fs.rmdir(path, callback)`

# web模块

 http 模块

- GET/POST请求

  - 示例

    - 获取url参数

      ```js
      var http = require('http');
      var url = require('url');
      var util = require('util');
       
      http.createServer(function(req, res){
          res.writeHead(200, {'Content-Type': 'text/plain'});
       
          // 解析 url 参数
          var params = url.parse(req.url, true).query;
          res.write("网站名：" + params.name);
          res.write("\n");
          res.write("网站 URL：" + params.url);
          res.end();
       
      }).listen(3000);
      ```

    - 获取post请求

      ```js
      var http = require('http');
      var querystring = require('querystring');
      var util = require('util');
       
      http.createServer(function(req, res){
          // 定义了一个post变量，用于暂存请求体的信息
          var post = '';     
       
          // 通过req的data事件监听函数，每当接受到请求体的数据，就累加到post变量中
          req.on('data', function(chunk){    
              post += chunk;
          });
       
          // 在end事件触发后，通过querystring.parse将post解析为真正的POST请求格式，然后向客户端返回。
          req.on('end', function(){    
              post = querystring.parse(post);
              res.end(util.inspect(post));
          });
      }).listen(3000);
      ```

# Express 框架

Express 是一个简洁而灵活的 node.js Web应用框架, 提供了一系列强大特性帮助你创建各种 Web 应用，和丰富的 HTTP 工具。

使用 Express 可以快速地搭建一个完整功能的网站。

Express 框架核心特性：

- 可以设置中间件来响应 HTTP 请求。
- 定义了路由表用于执行不同的 HTTP 请求动作。
- 可以通过向模板传递参数来动态渲染 HTML 页面。

# 参考文档

[node.js教程](https://www.runoob.com/nodejs/nodejs-tutorial.html)









