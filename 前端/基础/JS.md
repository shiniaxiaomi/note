

# js基本内容

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

### 定义函数

```js
function myFunction(a, b) {
    return a * b;                // 函数返回 a 和 b 的乘积
}      
```

> 如果参数没有传递,则会被默认设置为`undefined`

### 函数调用

```js
var x = myFunction(4, 3); 
```

### 闭包

全局变量能够通过闭包实现局部私有

- 错误示例

  ```js
  function count() {
    var arr = [];
    for (var i = 1; i < 3; i++) {
      arr.push(function() {
        return i * i;
      });
    }
    return arr;
  }
  var result = count();//返回的是一个函数数组
  //调用函数后的结果
  console.log(result[0]());//结果: 9
  console.log(result[1]());//结果: 9
  ```

  > 产生错误的原因主要是发生在延迟调用的时候,一般是返回一个函数,然后在需要的时候再去调用,那么这时候就可能会出现这种数据错误的情况发生
  >
  > 1. 为什么会发生这种错误,就是因为函数是延迟执行的,当执行时,这个`i`变量已经变成3了,所以每次在延迟调用函数的时候,返回的都是9

- 正确示例

  ```js
  function count() {
    var arr = [];
    for (var i = 1; i < 3; i++) {
      arr.push(
        (function(i) {
          return function() {
            return i * i;
          };
        })(i)
      );
    }
    return arr;
  }
  var result = count();//返回的是一个函数数组
  //调用函数后的结果
  console.log(result[0]());//结果: 9
  console.log(result[1]());//结果: 9
  ```

  > 我们要避免这种错误的发生,就需要使用到闭包,利用函数的作用域来解决这个问题
  >
  > 1. 首先是创建一个函数,将当前的变量传入这个函数,这样就保证了这个变量的值已经存在了当前函数的作用域中,然后直接调用这个函数,返回一个函数,返回的函数里面就是要对数据进行的一些列操作,在返回的函数里操作的变量就是已经保存在之前函数作用域里面的变量值,不会随着外界的变量值的改变而改变

## 对象

### 直接定义对象

```js
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
//对象赋值,赋值的是引用
var a=person;
```

### 创建对象模板(类class)

使用函数的方式定义一个类,因为函数有局部作用域,因此可以当作类来使用

使用`new`关键字就可以创建出作用域不同的对象了

```js
//定义一个Person类
function Person(age) {
  this.age = age;
  this.add = function() {
    this.age++;
  };
}
```

使用

```js
var person1 = new Person(2);//创建一个person1
var person2 = new Person(3);//创建一个person2
person2.add();//person2加1

console.log(person1);//结果: Person { age: 2, add: [Function] }
console.log(person2);//结果: Person { age: 4, add: [Function] }
```

#### 往构造器中添加新属性

`Person.prototype.name = "aaa";`

`Person.prototype.reduce= function(){this.age--};`

```js
function Person(age) {
  this.age = age;
  this.add = function() {
    this.age++;
  };
}
Person.prototype.name = "aaa"; //添加新属性
Person.prototype.reduce= function(){ //添加新方法
    this.age--
};

var person = new Person(2);//创建一个person
person.reduce();//调用新添加的方法
console.log(person.name); //结果: aaa
console.log(person); //结果: Person { age: 1, add: [Function] }
```

> 使用`.prototype`往构造器中添加属性和方法时,直接打印new出来的对象是看不到新添加的属性和方法的

### 添加对象属性

`person.age=12`

### 删除对象属性

`delete person.age`

> `delete`关键字会同时删除属性的值和属性本身,删除之后该属性将无法使用,需重新添加

### 添加对象方法

```js
person.add=function(){
    this.age++;
}
```

### 删除对象方法

`delete person.add`

### this 关键词

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

### 日期格式化（非常好用）

```js
//日期格式化
//使用方式：new Date().Format("yyyy/MM/dd hh:mm:ss");
//分隔符自行替换即可
Date.prototype.Format = function(fmt) {
  var o = {
    "M+" : this.getMonth()+1,                 //月份
    "d+" : this.getDate(),                    //日
    "h+" : this.getHours(),                   //小时
    "m+" : this.getMinutes(),                 //分
    "s+" : this.getSeconds(),                 //秒
    "q+" : Math.floor((this.getMonth()+3)/3), //季度
    "S"  : this.getMilliseconds()             //毫秒
  };
  //"y+" : 年份
  if(/(y+)/.test(fmt))
    fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
  for(var k in o)
    if(new RegExp("("+ k +")").test(fmt))
      fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
  return fmt;
}
```

使用：

```js
new Date().Format("yyyy/MM/dd hh:mm:ss");
new Date().Format("yyyy/MM/dd");
new Date().Format("hh:mm:ss");
new Date(1574054819458).Format("yyyy/MM/dd hh:mm:ss");
```

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

- 通过`F12`打开浏览器的调试器进行调试
- 使用`console.log()`打印信息进行调试
- 使用`debugger`设置断点进行调试

# js Dom(Html)

当页面被加载时,浏览器会创建页面的文档对象模型(Document Object Model)

Html Dom 模型会被结构化为对象树

![DOM HTML 树](/Users/yingjie.lu/Documents/note/.img/ct_htmltree.gif)

通过这个对象模型,js就能够动态创建和修改html

## document对象

### 查找html元素

旧方法:

- 通过id查找元素: `document.getElementById(id)`
- 通过tag查找元素: `document.getElementsByTagName(tag)`
- 通过class查找元素: `document.getElementsByClassName(name)`

**新方法:**

> 使用`querySelectorAll()`可以找出(id、类名、类型、属性、属性值等等)的所有html元素

- 查找class: `document.querySelectorAll(".intro")`
- 查找id: `document.querySelectorAll("#id")`
- 查找tag: `document.querySelectorAll("div")`
- 更多功能
  1. 查找tag和class: `document.querySelectorAll("div.intro")`
  2. 查找`<a>`标签中的target属性: `document.querySelectorAll("a[target]")`
  3. 查找每个父元素为div的p元素: `document.querySelectorAll("div > p")`
  4. 查找多种标签: `document.querySelectorAll("div,span,h2")`

### 改变html元素

- 改变元素的inner html: `element.innerHTML = "<div>111</div>"`
- 设置元素的attribute: `element.setAttribute("myId", 1)`
- 获取元素的attribute: `element.setAttribute("href")`
- 设置元素的class: `element.style.display='none'`
- 获取元素的class: `element.style.display`

### 添加和删除元素

- 创建元素: 

  `document.createElement(element)`

  ```js
  var para = document.createElement("p");//创建p元素
  var node = document.createTextNode("这是一个新段落。");//创建文本节点
  para.appendChild(node);//将文本节点添加到p标签中
  
  //结果:
  //<p>这是一个新段落。</p>
  ```

- 添加元素: 

  1. 加到子元素中的最有一个: `document.appendChild(element)`
  2. 在某个元素之前插入一个元素: `element.insertBefore(para, child);`

  > 其中的`element`,`para`和`child`都属于dom节点元素

- 删除元素: 

  `parent.removeChild(child);`

  > 先找到父元素,然后再删除子元素

  ```js
  var parent = document.getElementById("div1");//找到父元素
  var child = document.getElementById("p1");//找到子元素
  parent.removeChild(child);//使用父元素的removeChild方法删除子元素
  ```

### 事件(Event)

添加事件的两种方法

- 添加点击事件: `document.getElementById(id).onclick = function(){...}`
- 注册点击事件: `document.getElementById("myBtn").addEventListener("click", function(){...});`

阻止事件冒泡

- `addEventListener(event, function, useCapture);`

  > useCapture的默认值是 false，将使用冒泡传播，如果该值设置为 true，则事件使用捕获传播。

删除事件

- `element.removeEventListener("mousemove", myFunction);`

[所有事件参考文档](https://www.w3school.com.cn/jsref/dom_obj_event.asp)

- 元素失去焦点: `onblur`
- 域的内容被改变: `onchange`
- 点击事件: `onclick`
- 元素获得焦点: `onfocus`
- 按键按下: `onkeydown`
- 按键按下并松开: `onkeypress`
- 按键松开: `onkeyup`
- 鼠标按下: `onmousedown`
- 鼠标松开: `onmouseup`
- 鼠标移入: `onmouseover`
- 鼠标移出: `onmouseout`
- 窗口或框架重新调整大小: `onresize`
- 文本被选中: `onselect`
- 用户退出页面: `onunload`

其他

- 不再派发事件: `event.stopPropagation()`
- 取消事件的默认动作: `event.preventDefault()`

### 获取html中的其他属性

- 返回文档的cookie: `document.cookie`
- 返回文档的uri: `document.documentURI`
- 返回文档服务器的域名: `document.domain`
- 返回所有`<a>`标签元素: `document.links`
- 返回文档的完整 URL: `document.URL`
- 返回 `<title>` 元素: `document.title`

## Dom导航

节点树中的节点关系

- 节点树中,顶端节点被称为根节点
- 每个节点都有父节点,除了根节点
- 每个节点都可以有子节点
- 兄弟节点指的时拥有相同父节点的节点

![DOM HTML 树](/Users/yingjie.lu/Documents/note/.img/dom_navigate.gif)

节点之间的导航

- parentNode: 用于访问父节点
- childNodes[*nodenumber*]: 访问节点中的所有子节点
- firstChild: 访问节点中的第一个子节点
- lastChild: 访问节点中的最后一个子节点
- nextSibling: 访问下一个兄弟节点
- previousSibling: 访问上一个兄弟节点

节点属性

- nodeName: 节点的名称(只读,元素的标签名)
- nodeValue: 节点的值
  1. 元素节点: undefined
  2. 文本节点: 文本内容
  3. 属性节点: 节点属性值

## 文档就绪函数

为了防止文档在完全加载（就绪）之前运行 JavaScript代码,需要在文档解析就绪后才执行JavaScript代码

```js
window.onload = function() {
  ...
};
```

# js Bom(Browser Object Model)

浏览器对象模型(Browser Object Model),针对于浏览器来说的

之前的Dom是正对于html中的节点树来说的

## Window对象

所有浏览器都支持window对象,他代表浏览器的窗口

所有全局js对象,函数和变量都会自动称为window对象的成员

- 全局变量时window对象的属性

- 全局函数时window对象的方法

- 甚至document对象也是window对象的属性

  `window.document.getgetElementById(id)`

有两个属性来确定浏览器窗口的尺寸

- window.innerHeight - 浏览器窗口的内高度（以像素计）
- window.innerWidth - 浏览器窗口的内宽度（以像素计）

获取浏览器的大小通用的做法

```js
var w = window.innerWidth
|| document.documentElement.clientWidth
|| document.body.clientWidth;

var h = window.innerHeight
|| document.documentElement.clientHeight
|| document.body.clientHeight; 
```

其他窗口方法

- window.open() - 打开新窗口
- window.close() - 关闭当前窗口
- window.moveTo() -移动当前窗口
- window.resizeTo() -重新调整当前窗口

## Screen对象

- screen.width: 访问者屏幕的宽度
- screen.height: 访问者屏幕的高度
- screen.availWidth: 屏幕的可用宽度,出去窗口工具条之类的宽度
- screen.availHeight: 屏幕的可用高度,出去窗口工具条之类的宽度

## Location对象

- window.location.href 返回当前页面的 href (URL)

  跳转页面: `window.location.href="www.72cun.cn"`

- window.location.hostname 返回 web 主机的域名

- window.location.pathname 返回当前页面的路径或文件名

- window.location.assign 加载新文档

## 弹出框

- 警告框

  `window.alert("sometext");`

- 确认框

  ```js
  var r = confirm("请按按钮");
  if (r == true) {
      x = "您按了确认！";
  } else {
      x = "您按了取消！";
  }
  ```

- 提示框

  ```js
  var person = prompt("请输入您的姓名", "比尔盖茨");
  if (person != null) {
      console.log(person);
  }
  ```

## 定时器(Timing 事件)

window 对象允许以指定的时间间隔执行代码。

- 等待指定毫秒数后执行函数,只执行一次

  `var timeId = setTimeout(function,millisecond)`

- 指定毫秒数间隔重复执行该函数

  `var timeId = setInterval(function,milliosecond)`

停止定时器

- `window.clearTimeout(timeId)`
- `window.clearInterval(timeId)`

## js Cookies

Cookie 是在您的计算机上存储在小的文本文件中的数据。

当web服务器向浏览器发送网页,连接被关闭后,服务器就会忘记用户的一切

Cookie就是为了解决''如果记住用户信息''而发明的

- 当用户第一次访问时,就会把用户信息记录在本地的cookie中
- 下次再访问时,cookie就可用从本地直接获取信息了

当用户再向web服务器发送请求时,浏览器会把本地的cookie信息带上一同发送给服务器,那么web服务器就可以拿到用户的信息,而不是需要用户重新再录入一遍

### 创建cookie

简单的创建

```js
document.cookie = "username=Bill Gates";
```

添加有效日期

```js
document.cookie = "username=John Doe; expires=Sun, 31 Dec 2017 12:00:00 UTC";
```

添加cookie属于哪些路径下

```js
document.cookie = "username=Bill Gates; expires=Sun, 31 Dec 2017 12:00:00 UTC; path=/";
```

### 读取cookie

```js
var x = document.cookie;
//结果: cookie1=value; cookie2=value; cookie3=value;
```

### 删除cookie

直接把 expires 参数设置为过去的日期即可

```js
document.cookie = "username=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
```

> 应该定义 cookie 路径以确保删除正确的 cookie

### 常用工具函数

- 设置cookie的函数

  ```js
  function setCookie(cname, cvalue, exdays) {
      var d = new Date();
      d.setTime(d.getTime() + (exdays*24*60*60*1000));
      var expires = "expires="+ d.toUTCString();
      document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
  } 
  ```

- 获取cookie的函数

  ```js
  function getCookie(cname) {
      var name = cname + "=";
      var decodedCookie = decodeURIComponent(document.cookie);
      var ca = decodedCookie.split(';');
      for(var i = 0; i <ca.length; i++) {
          var c = ca[i];
          while (c.charAt(0) == ' ') {
              c = c.substring(1);
           }
           if (c.indexOf(name) == 0) {
              return c.substring(name.length, c.length);
           }
       }
      return "";
  } 
  ```

- 检测cookie的函数

  ```js
  function checkCookie() {
      var username = getCookie("username");
      if (username != "") {
          alert("Welcome again " + username);
      } else {
          username = prompt("Please enter your name:", "");
          if (username != "" && username != null) {
              setCookie("username", username, 365);
          }
      }
  } 
  ```

# js Ajax

ajax可以不刷新页面更新页面数据

ajax的工作原理

![AJAX](/Users/yingjie.lu/Documents/note/.img/ajax.gif)

## XMLHttpRequest对象

XMLHttpRequest对象的方法

- `new XMLHttpRequest()` :创建XMLHttpRequest对象
- `abort()` : 取消当前请求
- `open(method, url, async)` : 规定请求
  1. method: 请求类型,GET或POST
  2. url: 请求的网址
  3. async：true（异步）或 false（同步)
- `send()`: 将请求发送到服务器,用于GET请求
- `send(String)`: 将请求发送到服务器,用于POST请求
- `setRequestHeader()`: 向要发送的消息头添加键值对

XMLHttpRequest对象的属性

- `onreadystatechange`: 定义当readyState 属性发生变化时被调用的函数
- `readyState`: 保存XMLHttpRequest 的状态
  - 0：请求未初始化
  - 1：服务器连接已建立
  - 2：请求已收到
  - 3：正在处理请求
  - 4：请求已完成且响应已就绪
- `responseText`: 以字符串返回响应数据
- `responseXML`: 以 XML 数据返回响应数据
- `status`: 返回请求的状态号
  1. 200: "OK"
  2. 403: "Forbidden"
  3. 404: "Not Found"
- `statusText`: 返回状态文本（比如 "OK" 或 "Not Found"）

## 发送get请求

```js
//发送get请求
function ajaxGetUtil(url,isSync,handleFunction){//isSync为true表示异步,false为同步
	var httpRequest = new XMLHttpRequest();//建立所需的对象
	httpRequest.open('GET', url, isSync);//打开连接  将请求参数写在url中(如"/getData?a=1")
	httpRequest.send();//发送请求  将请求参数写在URL中

	httpRequest.onreadystatechange = function () {
		if (httpRequest.readyState == 4 && httpRequest.status == 200) {
             //将返回的数据转为json对象传入到回调函数中
			handleFunction(JSON.stringify(httpRequest.responseText));//获取到json字符串，还需解析
		}
	};
}
```

## 发送post请求

```js
//发送post请求
function ajaxPostUtil(url,dataObj,isSync,handleFunction){//isSync为true表示异步,false为同步
	var httpRequest = new XMLHttpRequest();//创建需要的对象
	httpRequest.open('post', url,isSync); //打开连接
    httpRequest.setRequestHeader("Content-type","application/x-www-form-urlencoded");//设置普通类型数据
	httpRequest.setRequestHeader("Content-type","application/json");//设置json类型数据,如({a:1,b:2})
	httpRequest.send(JSON.stringify(dataObj));//发送请求 (将对象转为json发送)
	httpRequest.onreadystatechange = function () {
        //验证请求是否发送成功
		if (httpRequest.readyState == 4 && httpRequest.status == 200) {
            //将返回的数据转为json对象传入到回调函数中
			handleFunction(JSON.stringify(httpRequest.responseText));
		}
	};
}
```

# js Json

JavaScript Object Notation(JavaScript对象标记法)

json语法

- 数据在名称/值对中

  值必须时以下数据类型之一

  1. 字符串
  2. 数字
  3. 对象(json对象)
  4. 数组
  5. 布尔
  6. NUll

- 数据由逗号分隔

- 花括号容纳对象

- 方括号容纳数组

定义json对象

```js
var json={
	"name":"bill",
    "age":12
}
```

使用

```js
//查询
console.log(json.name)
console.log(json["name"])
//修改
json.name="111"
json["name"]="111"
//删除
delete json.name
```

定义json数组

```js
var arr=[
    {"name":"bill","age":12},
    {"name":"2222","age":13}
]
//查询
arr[0].name
//修改
arr[0].name="222"
//删除
delete arr[0].name
```

将json字符串解析成对象

```js
var obj = JSON.parse('{ "name":"Bill Gates", "age":62, "city":"Seattle"}');
```

将对象解析成json字符串

```js
var myJSON = JSON.stringify(obj);
```

遍历json中的对象(`for-in`)

```js
myObj =  { "name":"Bill Gates", "age":62, "car":null };
for (x in myObj) {//获取到键
   console.log(myobj[x]);//打印值
}
```

嵌套json对象

```js
myObj =  {
   "name":"Bill Gates",
   "age":62,
   "cars": {
	  "car1":"Porsche",
	  "car2":"BMW",
	  "car3":"Volvo"
   }
}
//访问
x = myObj.cars.car2;
x = myObj.cars["car2"];
//修改
myObj.cars.car3 = "Mercedes Benz";
//删除
delete myObj.cars.car1;
```

# 获取键盘按键码

```html
<!DOCTYPE html>
<html>
<head>
</head>

<body onkeyup="document.getElementById('demo').innerHTML = event.keyCode;">
<p><b>注释：</b>尝试此示例时，请确保右框架具有焦点！</p>
<p>单击此页面，然后按键盘上的键。</p>
<p id="demo"></p>

</body>
</html>
```

随便打开一个页面,并直接在控制台输入即可运行

```js
document.getElementsByTagName("html")[0].innerHTML=`
<body onkeyup="document.getElementById('demo').innerHTML = event.keyCode;">
<p><b>注释：</b>尝试此示例时，请确保右框架具有焦点！</p>
<p>单击此页面，然后按键盘上的键。</p>
<p id="demo"></p>
`
```

# 积累

## 使用js刷新页面

`location.reload();`

## 全局按键事件

```js
document.onkeydown=function (event) {
    var key = event.keyCode;
    if(key == 13){
        //...
    }
    event.preventDefault();//阻止默认事件
}
```

## 全局多个按键事件

```js
//全局快捷键
var q_key=81;
var Q_key=113;
var w_key=87;
var W_key=119;
document.onkeypress=function (event) {
  var key = event.keyCode;
  if(event.shiftKey && (key==q_key || key==Q_key)){
    vue.outline_drawer=!vue.outline_drawer;
    event.preventDefault();//阻止默认事件
  }else if(event.shiftKey && (key==w_key || key==W_key)){
    vue.dir_drawer=!vue.dir_drawer;
    event.preventDefault();//阻止默认事件
  }
}
```



## 复制对象而不是引用

复制对象

```js
var obj={a:1,b:2};
var obj2=$.extend(true,{},obj);
```

赋值数组

```js
var obj2 =JSON.parse(JSON.stringify(obj));
```

## jQuery和js对象的相互转化

jQuery转js

```js
$("div")[0]
$("div").get(0)
```

js转jQuery

```js
$(document.getElementById("demo"))
```

## 同步的执行方法

添加`async`关键字即可

```js
async function test(filePath,targetPath){
  await fs.createReadStream(filePath).pipe(unzip.Extract({ path: targetPath }));
}
```

# 参考文档

[JavaScript教程](https://www.w3school.com.cn/js/index.asp)

