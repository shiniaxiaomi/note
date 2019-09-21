[TOC]

# 简介

Express 是一个简洁而灵活的 node.js Web应用框架, 提供了一系列强大特性帮助你创建各种 Web 应用，和丰富的 HTTP 工具。

使用 Express 可以快速地搭建一个完整功能的网站。

Express 框架核心特性：

- 可以设置中间件来响应 HTTP 请求。
- 定义了路由表用于执行不同的 HTTP 请求动作。
- 可以通过向模板传递参数来动态渲染 HTML 页面。

# 安装

安装express

`cnpm install express --save`

## hello world

- 创建一个demo.js

  ```js
  var express = require('express');//导入express模块 
  var app = express();//获取app对象
   
  //当'/'请求时的回调(request 和 response 对象来处理请求和响应的数据)
  app.get('/', function (req, res) {
     res.send('Hello World');
  })
   
  //启动server并监听再8081端口
  var server = app.listen(8081, function () {
    var host = server.address().address;
    var port = server.address().port;
    console.log("应用实例，访问地址为 http://%s:%s", host, port);
  })
  ```

- 执行demo.js

  `node demo.js`

- 访问网址http://localhost:8081

# 路由

分别对应不同的url请求

- 访问主页

  `app.get('/', function (req, res){})`

- 普通的url请求

  `app.get('/del_user', function (req, res) {})`

- 使用正则来匹配url请求

  `app.get('/ab*cd', function(req, res) {})`

# 静态资源

Express 提供了内置的中间件 express.static 来设置静态文件

- 设置public目录为静态资源文件路径

  ```js
  var express = require('express');
  var app = express();
  app.use('/public', express.static('public'));
  ```

- 在public目录下放`logo.png`图片并访问

  `http://localhost:8081/public/logo.png`即可看到图片

# [API](http://www.expressjs.com.cn/4x/api.html)

## express全局方法

### express.json([options])

设置express框架中处理json的一些配置

> 此中间件在Express v4.16.0及更高版本中可用。

这是Express中的内置中间件功能。该功能会查看`Content-Type`标头与`type`选项匹配的请求, 解析后在`request`对象上填充包含已解析数据的新对象`req.body`

option对象属性

- inflate

  类型: 布尔 (默认为true)

  > 启动或禁止压缩json文本

- limit

  类型: String (默认为"100kb")

  > 控制最大请求体大小

- type

  类型: String (默认为"application/json")

  > 用于确认需要解析的类型

### express.static(root,[options])

设置应用的静态资源路径

> 为获取最佳的结果,推荐使用反向代理缓存来提高服务静态资源的性能

root参数

- 指定静态资源的根目录, 其通过req.url和root组合来确定提供的文件, 如果没有找到,则会调用next() 继续递归的寻找资源文件

options参数

- maxAge

  类型: 数值或字符串 (默认为0)

  > 设置静态资源的缓存时间

- 示例

  ```js
  var options = {
    dotfiles: 'ignore',
    etag: false,
    extensions: ['htm', 'html'],
    index: false,
    maxAge: '1d', //缓存时间设置为1天
    redirect: false,
    setHeaders: function (res, path, stat) {
      res.set('x-timestamp', Date.now())
    }
  }
  ```
  
  简单使用
  
  ```js
  app.use("", express.static("/css"));
  app.use("", express.static("/js"));
  ```
  
  

## express对象

### express对象属性

#### app.locals

该属性为此次应用程序中的全局变量,该变量在程序的整个生命周期中保持不变

设置一些全局变量

```js
app.locals.title = 'My App';
app.locals.strftime = require('strftime');
app.locals.email = 'me@myapp.com';
```

### express对象方法

#### app.all(path,callback,[callback...])

此方法是用于匹配所有的http请求(包括了get和post等类型的请求), 该方法在http请求匹配时会被最前匹配,匹配之后如果其他匹配模式也符合,则继续回调

path参数

- 用于匹配匹配url的正则表达式

callback参数

- 回调函数

  ```js
  app.all('/secret', function (req, res, next) {
      console.log('Accessing the secret section ...')
    	next() // 接着下一个匹配的http处理器
  })
  ```

- 可以填写多个回调函数

  ```js
  app.all('*', requireAuthentication, loadUser);
  //如同
  app.all('*', requireAuthentication);
  app.all('*', loadUser);
  ```

#### 其他http请求处理函数

- app.get(path,callback [,callback ...])
- app.post(path,callback [,callback ...])
- app.delete(path,callback,[callback...])
- app.put(path,callback,[callback...])

用法都和上面的`app.all(path,callback,[callback...])`相同

#### app.listen([port [，host [，backlog]]] [，callback])

绑定并监听指定主机和端口上的连接

```js
var server = app.listen(80, function() {
    console.log("应用实例启动成功!");
});
```

#### app.param（[name]，callback）

指定当有http中带有name中的参数时,则会触发该回调函数

> 如果name是数组,则callback则按声名的顺序为其声名的每个参数注册触发器

```js
app.param('id', function (req, res, next, id) {
  console.log('CALLED ONLY ONCE',id);
  next();  // 接着下一个匹配的http处理器
});
app.get('/user/:id', function (req, res, next) {
  console.log('although this matches');
  next();
});
```

> 当发送请求`/user/19`时,上面两个回调函数都会被调用,并且都能够回去到id的值, 而且`param`对应的回调会先于其他回调函数

#### app.render(view, [locals], callback)

通过在callback中渲染参数,并返回视图

```js
app.render('email', { name: 'Tobi' }, function(err, html){
  // ...
});
```

#### app.use（[path，] callback [，callback ...]）

在指定的路径中安装指定的中间件函数,当请求的路径和请求的url匹配时,就会执行中间件函数

> 默认的path为''/'',因此每个请求都会执行该回调函数

```js
app.use(function (req, res, next) {
  console.log('Time: %d', Date.now());
  next();
});
```

中间件的执行顺序很重要,具体参考API文档

## request对象(请求)

### req对象的参数

#### req.app

此属性包含了express创建出来的实例,可以获取到之前在app中set的一些全局变量

```js
req.app.get('views')
```

#### req.body

包含请求正文中提交的键值对数据,默认情况下,当解析url请求的数据参数后,会将解析完的内容填充到req.body中

> 解析http的参数需要安装对应的中间件才可以正常的使用

```js
var app = require('express')();
var bodyParser = require('body-parser');
var multer = require('multer'); // v1.0.5
var upload = multer(); // for parsing multipart/form-data

app.use(bodyParser.json()); // for parsing application/json
app.use(bodyParser.urlencoded({ extended: true })); // for parsing application/x-www-form-urlencoded

app.post('/profile', upload.array(), function (req, res, next) {
  console.log(req.body);
  res.json(req.body);
});
```

#### req.cookies

使用`cookie-parser`中间件时,此属性时包含请求发送的cookie的对象; 如果请求不包含cookie,则默认为{}

```js
// Cookie: name=tj
req.cookies.name
// => "tj"
```

#### req.hostname

获取http的host主机名

```js
// Host: "example.com:3000"
req.hostname
// => "example.com"
```

#### req.ip

获取远程的ip

```javascript
req.ip
// => "127.0.0.1"
```

#### req.method

获取http请求的方法类型(post,get...)

#### req.params

此属性是一个对象,包好了url请求中的参数

> 如果url的请求是`/user/:name`,则
>
> ```js
> // GET /user/tj
> req.params.name
> // => "tj"
> ```

#### req.path

获取url的请求,不包含域名和参数

```javascript
// example.com/users?sort=desc
req.path
// => "/users"
```

#### req.query

此属性是一个对象,包含url中那个查询字符串参数的属性; 如果没有查询字符串,则为空对象{}

```javascript
// GET /search?q=tobi+ferret
req.query.q
// => "tobi ferret"
```

#### req.xhr

一个布尔属性,如果是true则表示请求的`X-Requested-With`头字段是“XMLHttpRequest”

```javascript
req.xhr
// => true
```

### req对象的方法

#### req.get(field)

获取http的header中的字段

```javascript
req.get('Content-Type');
// => "text/plain"
```

## response对象(响应)

### res对象属性

#### res.app

用法和req.app一样

### res对象方法

#### res.append(field [, value])

在http的返回的消息头中添加一些字段,如果没有该字段,则会被创建; 这个value可以是String也可以是一个array

```js
res.append('Link', ['<http://localhost/>', '<http://localhost:3000/>']);
res.append('Set-Cookie', 'foo=bar; Path=/; HttpOnly');
res.append('Warning', '199 Miscellaneous warning');
```

#### res.cookie(name, value [, options])

设置cookies; value可以是String也可以是JSON

options参数

- expires

  类型是Date,设置cookie的过期日期

- maxAge

  类型是Number,设置cookie从现在开始后多少毫秒钟过期

- path

  类型是String, 设置cookie对应的url路径

```js
res.cookie('name', 'tobi', { domain: '.example.com', path: '/admin', secure: true });
res.cookie('rememberme', '1', { expires: new Date(Date.now() + 900000), httpOnly: true });
```

#### res.clearCookie(name [, options])

根据name来清除对应的cookie

```javascript
res.clearCookie('name', { path: '/admin' }); //可以设置option来指定path来对应指定的cookie
```

#### res.download(path [, filename] [, options] [, fn])

可以指定path对应指定的文件,然后当访问这个url的时候,会把文件返回给用户

> 该方法使用的res.sendFile()来实现的,默认是去指定的资源路径下找文件

```javascript
res.download('/report-12345.pdf');
res.download('/report-12345.pdf', 'report.pdf');//可以指定文件名称
res.download('/report-12345.pdf', 'report.pdf',function(err){});//可以指定回调函数
```

#### res.end([data] [, encoding])

直接结束response进程

```javascript
res.end();
res.status(404).end();
```

#### res.get(field)

通过指定对应的字段来获取response的header中的数据

```javascript
res.get('Content-Type');
// => "text/plain"
```

#### res.json([body])

发送一个JSON的response,数据就直接是一个json格式的

```javascript
res.json(null);
res.json({ user: 'tobi' });
res.status(500).json({ error: 'message' });
```

#### res.redirect([status,] path)

重定向到指定的url,默认的http状态是302

```javascript
res.redirect('/foo/bar');
res.redirect('http://example.com');
res.redirect(301, 'http://example.com');
res.redirect('../login');
```

#### res.render(view [, locals] [, callback])

渲染一个视图,并将html页面返回给客户端

- view

  指定一个视图,一般是html页面路径

- locals

  指定一个对象,里面包含了需要渲染到html中的数据

- callback

  回调函数

```javascript
// send the rendered view to the client
res.render('index');

// if a callback is specified, the rendered HTML string has to be sent explicitly
res.render('index', function(err, html) {
  res.send(html);
});

// pass a local variable to the view
res.render('user', { name: 'Tobi' }, function(err, html) {
  // ...
});
```

#### res.send([body])

发送一个http response

- body

  该参数可以是一个Buffer object,object,String或者是Array

  ```javascript
  res.send(new Buffer('whoop'));
  res.send({ some: 'json' });
  res.send('<p>some html</p>');
  res.status(404).send('Sorry, we cannot find that!');
  res.status(500).send({ error: 'something blew up' });
  ```

#### res.sendFile(path [, options] [, fn])

根据指定的path来返回对应的文件, path必须是绝对路径

option参数

- headers

  指定文件对应的http的消息头

- root

  指定资源文件的根路径,如果没有该参数,则path必须要为绝对路径

- fn

  在文件传输结束或报错的时候的回调

  如果指定了回调函数,则在文件传输错误时必须要关闭这个response生命周期

```javascript
app.get('/file/:name', function (req, res, next) {
  var options = {
    root: __dirname + '/public/',
    dotfiles: 'deny',
    headers: {
        'x-timestamp': Date.now(),
        'x-sent': true
    }
  };

  var fileName = req.params.name;
  res.sendFile(fileName, options, function (err) {
    if (err) {
      next(err);
    } else {
      console.log('Sent:', fileName);
    }
  });
});
```

该函数还支持更细粒度化的操作

```javascript
// 根据不同用户的id和fileName来发送对应的文件
app.get('/user/:uid/photos/:file', function(req, res){
  var uid = req.params.uid
    , file = req.params.file;

  req.user.mayViewFilesFrom(uid, function(yes){
    if (yes) {
      res.sendFile('/uploads/' + uid + '/' + file);
    } else {
      res.status(403).send("Sorry! You can't see that.");
    }
  });
});
```

#### res.sendStatus(statusCode)

直接发送一个http状态码以直接结束请求

```javascript
res.sendStatus(200); // equivalent to res.status(200).send('OK')
res.sendStatus(403); // equivalent to res.status(403).send('Forbidden')
res.sendStatus(404); // equivalent to res.status(404).send('Not Found')
res.sendStatus(500); // equivalent to res.status(500).send('Internal Server Error')
```

#### res.set(field [, value])

设置response响应的header信息

```javascript
res.set('Content-Type', 'text/plain');

res.set({
  'Content-Type': 'text/plain',
  'Content-Length': '123',
  'ETag': '12345'
});
```

#### res.status(code)

设置http响应的状态码,并可以进行下一步操作

```javascript
res.status(403).end();
res.status(400).send('Bad Request');
res.status(404).sendFile('/absolute/path/to/404.png');
```

# 模板渲染

`app.engine(ext, callback)`

使用该方法可以创建一个模板渲染引擎

```javascript
var fs = require('fs') // this engine requires the fs module
app.engine('ntl', function (filePath, options, callback) { // 定义template engine
  fs.readFile(filePath, function (err, content) {
    if (err) return callback(err)
    // this is an extremely simple template engine
    var rendered = content.toString().replace('#title#', '<title>' + options.title + '</title>')
    .replace('#message#', '<h1>' + options.message + '</h1>')
    return callback(null, rendered)
  })
})
app.set('views', './views') // 指定要渲染的视图的目录
app.set('view engine', 'ntl') // 注册 template engine
```

使用模板引擎进行渲染

```javascript
app.get('/', function (req, res) {
  res.render('index', { title: 'Hey', message: 'Hello there!' })
})
```

# 相关模块

## express-session模块

这是一个session模块,可以快速的将session添加到express框架中

使用

- 安装

  `cnpm i express-session -S`

- 创建

  ```js
  var session = require("express-session");
  app.use(
    session({
      secret: "this is a string key", //加密的字符串，里面内容可以随便写
      resave: false, //强制保存session,即使它没变化
      saveUninitialized: true //强制将未初始化的session存储，默认为true
    })
  );
  ```

- 使用

  ```js
  req.session.isLogin=true; //创建session
  console.log(req.session.isLogin); //获取session
  ```




# 参考文档

[express教程](https://www.runoob.com/nodejs/nodejs-express-framework.html)

[express官方文档](http://www.expressjs.com.cn/)