# 简介

html是用来描述网页的一种语言

- HTML 指的是超文本**标记语言** (**H**yper **T**ext **M**arkup **L**anguage)
- html使用标记标签来描述网页

# 标签

## 标题(h1-h6)

通过`<h1>`-`<h6>`等标签进行定义

> 块级元素,独占一行

```html
<h1>This is a heading</h1>
```

## 段落(p)

通过` <p>` 标签进行定义

> 块级元素,整个元素独占一行

```html
<p>This is a paragraph.</p>
```

> 浏览器会省略了p标签内的多余的空格和换行

在段落下还可以使用一些标签来丰富段落的展示

- `<del>`: 定义删除字
- `<strong>`: 定义加重语气
- ...

更多段落下使用的标签参考: [文本格式化](https://www.w3school.com.cn/html/html_formatting.asp)

## 格式化文本(pre)

通过` <pre>` 标签进行定义

在该标签下的文本会保留原来的格式

```html
<pre>
for i = 1 to 10
     print i
next i
</pre>
```

## 链接(a)

通过 `<a>` 标签进行定义的

> 内联元素,不会独占一行

```html
<a href="http://www.w3school.com.cn">This is a link</a>
```

- href: 指定另一个文档的链接

- name: 创建文档内的书签(即创建锚点)

  ```html
  <div name="div">aaa</div>
  <a href="#div">跳转到div</a>
  ```

- target: 定义被链接的文档的打开方式

  1. _blank: 在新窗口打开
  2. _parent: 在父窗口打开
  3. _self: 在当前窗口打开
  4. _top: 在最顶层窗口打开
  5. framename: 指定frame中打开

## 图像(img)

通过 `<img>` 标签进行定义的

> 内联元素,不会独占一行

```html
<img src="w3school.jpg" alt="Big Boat" width="104" height="142" />
```

- src: 指向图像的url地址
- alt: 如果图像加载错误则会提示该信息
- width: 定义图像的宽度
- height: 定义图像的高度

## 水平线(分隔线)(hr)

通过 `<hr/>` 标签进行定义的

```js
<hr />
```

## 换行(br)

通过 `<br/>` 标签进行定义的

## 表格(table)

由 `<table>` 标签来定义,每个表格均由若干的`<tr>`组成行,每行又由若干个`<td>`组成列,一个`td`就是一个单元格; 单元格中可以包含文本,图片,列表,段落,表单,水平线等

> 块级元素,独占一行

```html
<table border="1">
    <th>Heading</th>
    <tr>
        <td>1</td>
        <td>2</td>
    </tr>
    <tr>
        <td>3</td>
        <td>4</td>
    </tr>
</table>
```

- `<th>`: 定义表格的表头

更多内容参考: [html表格](https://www.w3school.com.cn/html/html_tables.asp)

## 列表(ul>li)

### 无序列表

无序列表始于 `<ul>` 标签。每个列表项始于 `<li>`

> 块级元素,独占一行

```html
<ul>
  <li>咖啡</li>
  <li>茶
    <ul>
    <li>红茶</li>
    <li>绿茶
      <ul>
      <li>中国茶</li>
      <li>非洲茶</li>
      </ul>
    </li>
    </ul>
  </li>
  <li>牛奶</li>
</ul>
```

### 有序列表

有序列表始于` <ol>` 标签。每个列表项始于 `<li>` 标签

有序列表同无序列表

## 块级容器(div)

可用作其他html元素的容器(盛放其他元素)

> 块级元素,独占一行

```html
<div>
	<a>111</a>
    <h1>11111</h1>
</div>
```

## 内联容器(span)

可用作文本的容器(盛放其他元素)

> 内联元素,不会独占一行

```html
<span>
	<p>1111111</p>
    <p>2222222</p>
</span>
```

## 内嵌窗口(iframe)

```html
<iframe src="http://72cun.cn" width="200" height="200" frameborder="0" name="iframe_a"></iframe>
```

- src: 指定要加载的页面

- width: 设置iframe的宽度

- height: 设置iframe的高度

- frameborder: 设置iframe的边框

- name: 给iframe设定名称

  > 用于a链接跳转的之后可以指定跳转到该iframe中

## html头部元素

### 标题(title)

```html
<head>
	<title>Title of the document</title>
</head>
```

### 文档描述和关键字(meta)

一些搜索引擎会利用 meta 元素的 name 和 content 属性来索引您的页面

```html
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <meta name="author" content="w3school.com.cn">
    <meta name="description" content="HTML examples">
    <meta name="keywords" content="HTML, DHTML, CSS, XML, XHTML, JavaScript, VBScript">
</head>
```

### 外部资源链接(link)

```html
<head>
    <link rel="stylesheet" type="text/css" href="mystyle.css" />
    <script src="myjs.js"></script>
</head>
```

### 内部样式(style)

```html
<head>
    <style type="text/css">
        body {background-color:yellow}
        p {color:blue}
    </style>
</head>
```

### 客户端脚本(script)

```html
<script>console.log("hello")</script>
```

# 属性

html标签可以拥有属性,可以提供更多的信息

属性总是以名称/值对的形式出现,比如: name='value'

属性总是在html元素的开始标签中规定

常用的属性

- class: 规定元素的类名
- id: 规定元素的id
- style: 规定元素的行内样式(inline style)
- title: 规定元素的额外信息(鼠标悬浮提示)

更多属性参考: [HTML 标准属性参考手册](https://www.w3school.com.cn/tags/html_ref_standardattributes.asp)





