[TOC]

# 简介

jQuery是一个JavaScript库,他极大的简化了JavaScript编程

[jQuery的官方参考文档](https://api.jquery.com/) - 很重要

jQuery包含以下特性

- HTML 元素选取
- HTML 元素操作
- CSS 操作
- HTML 事件函数
- JavaScript 特效和动画
- HTML DOM 遍历和修改
- AJAX

jQuery下载

- [生产环境3.4.1](https://code.jquery.com/jquery-3.4.1.min.js)
- [开发环境3.4.1](https://code.jquery.com/jquery-3.4.1.js)

jQuery使用

- 添加到head标签中

  ```html
  <head>
  <script src="jquery.js"></script>
  </head>
  ```

- 引用cdn

  ```html
  <head>
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js">
  </script>
  </head>
  ```

# 语法

基础语法

`$(selector).action()`

- `$`定义jQuery
- `selector`表示要查询和查找的html元素
- `action()`表示执行对元素的操作

示例

- `$("#test").hide() `

# 文档就绪函数

为了防止文档在完全加载（就绪）之前运行 jQuery 代码,需要在文档解析就绪后才执行jQuery代码

```js
$(document).ready(function(){
	...
});
```

# 选择器

## 元素选择器

简单使用

- `$("p")` : 选取p标签元素
- `$("p.intro")`" : 选取class为intro并且为p标签的元素
- `$("#demo")` : 选取id为demo的元素

更多使用

- `$(#demo .top div>span)`: 选取id是demo下的,class是top下的,父元素是div的span元素

## 属性选择器

使用XPath表达式来选择带有给定属性的元素

- `$("[href]")` :选取所有所有带有href属性的元素
- `$("[myId]=='demo'")` : 选取属性myId等于demo的元素

## [更多选择参考文档](https://www.w3school.com.cn/jquery/jquery_ref_selectors.asp)

# 事件(Event)

- `$(document).ready(function)` : 绑定文档就是事件
- `$(selector).click(function)`: 绑定元素的点击事件
- `$(selector).focus(function)`: 绑定元素获得焦点事件
- `$(selector).blur(function)`: 绑定元素失去焦点事件

[更多事件的参考文档](https://www.w3school.com.cn/jquery/jquery_ref_events.asp)

# 动画效果

## 显示和隐藏

- 显示

  ```js
  $(selector).show();//简单使用
  $(selector).show(speed,callback);//可以设定时间和回调
  ```

- 隐藏

  ```js
  $(selector).hide();//简单使用
  $(selector).hide(speed,callback);//可以设定时间和回调
  ```

- 显示或隐藏来回切换

  ```js
  $("button").click(function(){
    $("p").toggle();
  });
  ```

# Dom节点操作

jQuery拥有非常强大的操作dom节点的能力

jQuery提供一系列与dom相关的方法,使得访问和操作元素的属性变得很容易

## 获得内容

- `.text()`: 设置或返回所选元素的文本方法
- `.html()`: 设置或返回所选元素的内容(包括html标记)
- `.val()`: 设置或返回表单字段的值

示例

- `$("#id").text()`: 获取元素的文本
- `$("#id").text("111")`: 设置元素的文本

## 获取属性

`.attr()`: 用于获取和设置元素的属性

- `$("#id").attr("href")`: 获取元素的href属性
- `$("#id").attr("href","www.72cun.cn")`: 设置元素的href属性

设置多个属性

```js
$("#w3s").attr({
    "href" : "http://www.72cun.cn",
    "title" : "72cun 网址收藏"
  });
```

## 添加元素

- `.append() `- 在被选元素的子元素的结尾插入内容(插入的元素会称为该元素的子节点)

  ```js
  $("p").append("Some appended text.");
  ```

  > 在p标签的内部的最后加入文本

  ```js
  $("ol").append("<li>Some appended text.</li>");
  ```

  > 在ol标签的内容的最后加入`li`标签

- `.prepend()` - 在被选元素的子元素的开头插入内容(插入的元素会称为该元素的子节点)

  ```js
  $("p").prepend("Some prepended text.");
  ```

- `.after() `- 在被选元素的同级别之后插入内容(插入的元素会称为该元素的兄弟节点)

  用法和上述一样

- `.before()` - 在被选元素的同级别之前插入内容(插入的元素会称为该元素的兄弟节点)

  用法和上述一样

## 创建元素

- `var p=$("<p>111</p>");`

  > 创建了一个有内容的p标签元素

- `$("ol").append("<li>Some appended text.</li>");`

  > 直接通过文本的形式,直接插入到元素中,就相当于创建了一个元素

## 删除元素

- `.remove() `- 删除被选元素（及其子元素）

  ```js
  $("#div1").remove();
  ```

  > `remove()`可以带一个参数,用来过滤删除的元素
  >
  > 如`$("p").remove(".italic");`
  >
  > 删除 class="italic" 的所有 <p> 元素

- `.empty() `- 从被选元素中删除子元素

  ```js
  $("#div1").empty();
  ```

## 设置css和class

- `.addClass()` - 向被选元素添加一个或多个类

  ```js
  $("div").addClass("important bule");
  ```

- `.removeClass()` - 从被选元素删除一个或多个类

  ```js
  $("h1,h2,p").removeClass("blue");
  ```

- `.toggleClass()` - 对被选元素进行添加/删除类的切换操作

  ```js
  $("h1,h2,p").toggleClass("blue");
  ```

- `.css()` - 设置或返回style属性

  ```js
  $("#id").css("display"); //获取display的值
  $("#id").css("display","none"); //设置display的值为none,则隐藏该元素
  
  //设置多个属性
  $("p").css({"background-color":"yellow","font-size":"200%"});
  ```

## 调整尺寸

- `.width()` - 设置或返回元素的宽度（不包括内边距、边框或外边距）
- `.height()` - 设置或返回元素的高度（不包括内边距、边框或外边距）

示例

```js
$("#div1").width(500).height(500);
```

# 节点导航

jQuery提供很多方法给我们遍历Dom树

## 向父级遍历

- `.parent()` : 返回被选元素的直接父元素

  ```js
  $("span").parent();
  ```

- `.parents()` : 返回被选元素的所有祖先元素，它一路向上直到文档的根元素

  ```js
  $("span").parents();
  ```

  > 该方法还可以设置参数来过滤父元素
  >
  > `$("span").parents("ul");`
  >
  > 返回所有 <span> 元素的所有祖先，并且它是 <ul> 元素

- `.parentsUntil()` : 返回介于两个给定元素之间的所有祖先元素

  ```js
  $("span").parentsUntil("div");//返回介于 <span> 与 <div> 元素之间的所有祖先元素
  ```

## 向子节点遍历

- `.children()` : 返回被选元素的所有直接子元素(该方法只会向下一级Dom树进行遍历)

  ```js
  $("div").children();//返回每个 <div> 元素的所有直接子元素
  ```

  > 该方法也可以和`.parents()`方法一样,设置参数来过滤子元素
  >
  > `$("div").children("p.demo");`
  >
  > 返回类名为 "demo" 的所有 <p> 元素，并且它们是 <div> 的直接子元素

- `.find()` : 返回被选元素的子元素，一路向下直到最后一个zi元素

  ```js
   $("div").find("p>span");//查找div下的,父元素是p标签的span元素
  ```

## 向兄弟节点遍历

- `.siblings()` : 返回被选元素的所有兄弟节点

  ```js
  $("h2").siblings();//返回所有兄弟节点
  $("h2").siblings("p");//返回是p标签的兄弟节点
  ```

- `.next()` : 返回被选元素的下一个兄弟节点

  ```js
  $("h2").next();
  ```

- `.nextAll()` : 返回被选元素的所有在其元素后面的兄弟节点

- `.nextUntil()` : 返回介于两个给定参数之间的所有兄弟节点

  ```js
  $("h2").nextUntil("h6");//返回介于 <h2> 与 <h6> 元素之间的所有兄弟节点
  ```

- `.prev()` : 和`next()`一样,只是方向相反,往前查找

- `.prevAll()` : 和`nextAll()`一样,只是方向相反,往前查找

- `.prevUntil()` : 和`nextUntil()`一样,只是方向相反,往前查找

## 过滤和选择已经筛选出的节点

- `.first()` : 返回被选元素的首个元素

  ```js
  $("div p").first();//相当于.eq(0)
  ```

- `.last()` : 返回被选元素的最后一个元素

  ```js
  $("div p").last();
  ```

- `.eq()` : 返回被选元素中带有指定索引号的元素

  ```js
  $("p").eq(1);
  ```

- `.filter()` : 匹配的元素会被返回

  ```js
  $("p").filter(".intro");//返回带有类名 "intro" 的所有 <p> 元素
  ```

- `.not()` : 返回不匹配标准的所有元素

  ```js
  $("p").not(".intro");//返回不带有类名 "intro" 的所有 <p> 元素
  ```

# Ajax

Asynchronous JavaScript and XML

ajax可以在不重载整个网页的情况下,从后台加载数据,并显示在网页上

## load()

从服务器加载数据，并把返回的数据放入被选元素中

`$(selector).load(URL,data,callback);`

- url: 必须传入,指定需要加载的数据的url
- data: 可选,与请求一同发送的查询字符串键/值对集合
- callback: 可选,load()方法执行完成后的回调

## $.get()

通过 HTTP GET 请求从服务器上请求数据。

`$.get(URL,callback);`

- url: 必传,指定请求资源的url
- callback: 可选,请求成功后的回调

```js
$.get("demo_test.asp",function(data,status){
    alert("Data: " + data + "\nStatus: " + status);
  });
```

## $.post()

通过 HTTP POST 请求从服务器上请求数据。

`$.post(URL,data,callback);`

- url: 必传,指定请求的url
- data: 可选,连同请求发送的数据
- callback: 可选,请求成功后的回调

```js
$.post("demo_test_post.asp",
  {
    name:"Donald Duck",
    city:"Duckburg"
  },
  function(data,status){
    alert("Data: " + data + "\nStatus: " + status);
  });
```

# 参考文档

[w3school-jQuery教程](https://www.w3school.com.cn/jquery/index.asp)

[jQuery的官方参考文档](https://api.jquery.com/)