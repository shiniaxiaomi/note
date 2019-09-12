[TOC]



# 基本内容

## js引入

javascript代码必须位于`<script>`标签中,他可以位于html的`<head>`和`<body>`标签中

### 直接使用

```html
<script>
	console.log("hello")
</script>
```

### 外部引入

```html
<script src="myScript.js"></script>
```

## js输出

- 使用 window.alert() 写入警告框

  弹出提示框

  `alert("hello")`

- 使用 document.write() 写入 HTML 输出

  直接在`<body>`标签中覆盖写入

  `document.write(5 + 6);`

- 使用 innerHTML 写入 HTML 元素

  可以直接控制元素内部的代码

  `document.getElementById("demo").innerHTML = 5 + 6;`

- 使用 console.log() 写入浏览器控制台

  打印在控制台中

  `consolo.log("hello")`

## 变量

定义变量

```js
var pi = 3.14;
var person = "Bill Gates";
```

变量相加

1. `var x = 3 + 5 + "8";`

   结果是: 88

2. `var x = "8" + 3 + 5;`

   结果是: 835

js中的变量拥有动态类型,会根据要做运算的类型进行相应的转化

## 数据类型

js有多种数据类型,如`数值`、`字符串值`、`数组`、`对象`等等

```js
//变量的定义
var length = 7;                             // 数字
var lastName = "Gates";                      // 字符串
var cars = ["Porsche", "Volvo", "BMW"];         // 数组
var x = {firstName:"Bill", lastName:"Gates"};    // 对象

//变量的使用
consolo.log(length) 
consolo.log(lastName) 
consolo.log(cars[0]) 
consolo.log(x.firstName) 
```

typeof运算符

- 可以使用typeof运算符来确定js变量的类型

  ```js
  typeof "Bill"              // 返回 "string"
  typeof 3.14                // 返回 "number"
  ```

undefined和null的区别

- 在js中,没有值的变量,其的值就是undefined

- 在js中,null是`nothing`的意思,表示不存在,他表示的是一个对象

  ```js
  typeof undefined              // undefined
  typeof null                   // object
  null === undefined            // false
  null == undefined             // true
  ```

## 函数

```js
//定义函数
function myFunction(a, b) {
    return a * b;                // 函数返回 a 和 b 的乘积
}
// 调用函数
var x = myFunction(4, 3);        
```

## 对象

示例

```js
//定义对象
var person = {
  firstName: "Bill",
  lastName : "Gates",
  id       : 678,
  fullName : function() {
    return this.firstName + " " + this.lastName;
  }
};
//访问对象属性
console.log(person.firstName);
console.log(person['firstName']);
//调用对象中函数
console.log(person.fullName()); 
```

this 关键词

- 在函数定义中,this指的是这个对象
- 但是有时这个this会变,一般都会使用`var _this=this`来保存当前的this对象

## 字符串

### 查找字符串

1. `indexOf()`

   - 返回文本首次出现的索引位置

     `str.indexOf("china")`

   - 从哪个索引开始查找

     `str.indexOf("china",50)`

2. `search()`

   搜索特定值的字符串,返回匹配的位置

   - 正常搜索

     `var pos = str.search("locate");`

   - 使用正则表达式

     `var n = str.search(/w3school/i); `

     > 请注意正则表达式不带引号
     >
     > 正则表达式规则见本文的正则表达式笔记

### 截取字符串

1. `slice(start,end)`

   提取指定索引的字符串内容,并返回

   ```js
   var str = "Apple, Banana, Mango";
   //正常使用
   var res = str.slice(7,13); //结果是: Banana
   //省略第二个参数
   var res = str.slice(7); //结果是: Banana, Mango(截取剩余部分)
   ```

2. `substring(start,end)`

   功能和`slice()`一样

3. `substr(start,length)`

   提取首个索引往后length长度的字符串内容,并返回

   ```js
   var str = "Apple, Banana, Mango";
   //正常使用
   var res = str.substr(7,6); //结果是: Banana
   //省略第二个参数
   var res = str.substr(7); //结果是: Banana, Mango(截取剩余部分)
   ```

### 替换字符串内容

`replace()`

用另一个值替换字符串中的指定值

- 简单使用(只替换首个匹配值)

  ```js
  str = "Please visit Microsoft and Microsoft!";
  var n = str.replace("Microsoft", "W3School");//只替换首个匹配值
  ```

- 支持正则表达式

  ```js
  str = "Please visit Microsoft!";
  var n = str.replace(/MICROSOFT/i, "W3School");//正则表达式 /i（大小写不敏感）
  var n = str.replace(/Microsoft/g, "W3School");//全部替换
  ```

  > 请注意正则表达式不带引号
  >
  > 正则表达式规则见本文的正则表达式笔记

### 其他

- 获取字符串长度

  `str.length`

- 大小写转化

  1. 转换成大写

     `str.toUpperCase()`

  2. 转换成小写

     `str.toLowerCase()`

- 拼接多个字符串

  `str.concat("hello"," ","world");`

- 删除两端空白符

  `str.trim()`

- 提取字符串字符

  `str.charAt(0)`

- 字符串属性访问

  `str[0]`

- 拆分字符串

  `str.split("|")`

### 正则表达式(字符串)

#### 语法和示例

语法

`/pattern/modifiers`

示例

`str.search(/w3school/i)`

> /w3school/i 是一个正则表达式
>
> w3school 是模式(pattern) ,搜索使用
>
> i 是修饰符 (大小写不敏感)

在`search()`和 `replace()`中都可以使用正则表达式

#### 模式和规则

正则表达式模式

1. `[abc]`: 查找方括号之间的任何字符
2. `[0-9]`: 查找任何从0到9的数字
3. `(x|y)`: 查找由`|`分割的人格选项

修饰符

1. `i`: 对大小写不敏感
2. `g`: 执行全局匹配(查找所有匹配而非找到第一个匹配后停止)
3. `m`: 执行多行匹配

元字符

1. `\d`: 查找数字
2. `\s`: 查找空白字符
3. `\b`: 匹配单词边界

定义量词

1. `n+`: 匹配任何包含至少一个n的字符串
2. `n*`: 匹配任何包含零个或多个n的字符串
3. `n?`: 匹配任何包换零个或一个n的字符串

#### 测试方法

`test()`是一个正则表达式方法,通过模式来搜索字符串后返回true或false

```js
var patt = /e/;
patt.test("The best things in life are free!"); 
```

`exec()`是一个正则表达式方法,通过模式来搜索字符串后返回已找到的文本

```js
var patt = /e/;
patt.exec("The best things in life are free!");
//结果是: e
```

## 数值转换

`var x=123`

- 数值转字符串

  `x.toString()`

- 字符串转数值

  `parseInt("10");  `

## 数组

### 基本操作

- 定义数组: `var arr=["1","2"]`

- 将数组转化为字符串 : `arr.toString()`

- 将数组转化为字符串并以`|`分隔 : `arr.join("|")`

- 添加数组末尾元素: `arr.push("3")`

  > 在数组的结尾处添加新元素

- 弹出数组末尾元素: `arr.pop()`

  > 将数组的结尾出的元素弹出

- 弹出数组第一个元素: `arr.shift()`

- 添加数组第一个元素: `arr.unshift("0")`

- 访问数组: `arr[0]`

### 数组遍历

- `forEach()`

  每个数组元素调用一个函数

  ```js
  var arr=['1','2','3']
  var sum=0;
  arr.forEach(function(value,index,array){
      sum+=value;
  })
  ```

  > 该函数接受3个参数,(元素值,元素索引,数组本身)

- `map()`

  通过对每个数组元素执行函数来创建新数组

  不会对没有值的数组元素执行函数

  不会修改原始数组

  ```js
  var arr=[1,2,3]
  var arr1=arr.map(function(value,index,array){
      return value*2;
  })
  console.log(arr.toString()) //结果是: [1,2,3]
  console.log(arr1.toString()) //结果是: [2,4,6]
  ```

- `filter()`

  创建一个包含通过测试的数组元素的新数组

  ```js
  var arr=[45, 4, 9, 16, 25]
  //过滤出大于18的数值,并返回数组
  var arr1=arr.filter(function(value, index, array){
      return value>18;
  })
  console.log(arr.toString()) //结果是: [45, 4, 9, 16, 25]
  console.log(arr1.toString()) //结果是: [45,25]
  ```

### 数组查找

- `indexOf()`

  在数组中搜索元素值并返回其索引

  ```js
  var arr=["Apple", "Orange", "Apple", "Mango"]
  var index=arr.indexOf("Apple"); //结果返回0,如果没找到则返回-1
  ```

- `find()`

  返回通过测试函数的第一个数组元素的值

  ```js
  var arr=[4, 9, 16, 25, 29]
  //查找（返回）大于 18 的第一个元素的值
  var value=arr.find(function(value, index, array){
      return value > 18;
  })
  ```

- `findIndex()`

  返回通过测试函数的第一个数组元素的索引

  ```js
  var arr=[4, 9, 16, 25, 29]
  //查找（返回）大于 18 的第一个元素的索引
  var index=arr.findIndex(function(value, index, array){
      return value > 18;
  })
  ```

## 日期

### 创建Date对象

- `new Date()`

  > 用当前日期和时间创建新的日期对象,只会记录当前的时候,不会变化

- `new Date(year, month, day, hours, minutes, seconds, milliseconds)`

  > 指定日期和时间创建新的日期对象,参数可省略

- `new Date(milliseconds)`

- `new Date(date string)`

### 日期对象的方法

- 获取毫秒数: `getTime()`

  ```js
  new Date().getTime()
  ```

- 获取年: `getFullYear()`

- 获取月: `getMonth()`

- 获取日: `getDate()`

- 获取小时: `getHours() `

- 获取分钟: `getMinutes()`

- 获取秒: `getSeconds()`

- 获取毫秒: `getMilliseconds()`

## 随机数

- 总是返回小于1的数

  `var value=Math.random()`

  > value的范围: [0,1)

- 随机整数

  1. 返回0-9之间的数

     `Math.floor(Math.random() * 10)`

     > [0,10)的整数

  2. 返回 1 至 10 之间的数

     `Math.floor(Math.random() * 10) + 1;`

     > [1,11)的整数

- 生成一个介于某个范围的随机整数

  ```js
  function getRndInteger(min, max) {
      return Math.floor(Math.random() * (max - min) ) + min;
  }
  // [0,max-min] + min = [min,max)
  // 能取到最小值,不能取到最大值
  ```

## 异常处理

try 语句使您能够测试代码块中的错误。

catch 语句允许您处理错误。

throw 语句允许您创建自定义错误。

finally 使您能够执行代码，在 try 和 catch 之后，无论结果如何。

```js
try {
     //供测试的代码块
} catch(err) {
     //处理错误的代码块
} finally {
     //无论 try / catch 结果如何都执行的代码块
}
```

## 变量作用域

### var关键字

- 全局作用域

  1. 将变量声明在全局中

     ```js
     //定义全局变量
     var value = " porsche";
     
     function myFunction() {
         console.log(value) //使用的是全局变量
     }
     ```

  2. 在变量为声明时便给其赋值,则会使该变量上升至全局作用域

     ```js
     function myFunction() {
         value="111";//为定义就使用,则会使得value自动变成为全局变量
     }
     ```

- 局部作用域

  函数作用域内的变量属于局部变量

  ```js
  function myFunction() {
      var value = "porsche";//定义了局部变量
  }
  ```

### let关键字

该关键字提供了块作用域

```js
{ 
  let x = 10;//let声明的变量x的作用域只在{}内部
}
// 此处不可以使用 x
```

`let`关键字在全局变量,局部变量和函数变量和`var`关键字的用法一样

### const关键字

`const`关键字定义的变量和`let`关键字定义的变量类似,但是不能重新赋值

## 调试技巧













# 参考文档

[JavaScript教程](https://www.w3school.com.cn/js/index.asp)







对象转json

```js
var str = JSON.stringify(params);
```

json转对象

```js
var data = JSON.parse(httpRequest.responseText);
```

js发送get请求

```js
//发送get请求
function ajaxGetUtil(url,handleFunction){
	var httpRequest = new XMLHttpRequest();//第一步：建立所需的对象
	httpRequest.open('GET', url, true);//第二步：打开连接  将请求参数写在url中  ps:"./Ptest.php?name=test&nameone=testone"
	httpRequest.send();//第三步：发送请求  将请求参数写在URL中

	httpRequest.onreadystatechange = function () {
		if (httpRequest.readyState == 4 && httpRequest.status == 200) {
			handleFunction(JSON.stringify(httpRequest.responseText));//获取到json字符串，还需解析
		}
	};
}
```

js发送post请求

```js
//发送get请求
function ajaxPostUtil(url,dataObj,handleFunction){
	var httpRequest = new XMLHttpRequest();//第一步：创建需要的对象
	httpRequest.open('post', url); //第二步：打开连接/***发送json格式文件必须设置请求头 ；如下 - */
    httpRequest.setRequestHeader("Content-type","application/x-www-form-urlencoded");//设置普通类型数据,如(a=1&b=2)
	httpRequest.setRequestHeader("Content-type","application/json");//设置json类型数据,如({a:1,b:2})
	httpRequest.send(JSON.stringify(dataObj));//发送请求 将json写入send中

	httpRequest.onreadystatechange = function () {//请求后的回调接口，可将请求成功后要执行的程序写在其中
		if (httpRequest.readyState == 4 && httpRequest.status == 200) {//验证请求是否发送成功
			handleFunction(JSON.stringify(httpRequest.responseText));//获取到json字符串，还需解析
		}
	};
}
```

使用js刷新页面

`location.reload();`