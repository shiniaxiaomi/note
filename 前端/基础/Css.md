# 简介

css指层叠样式表(*C*ascading *S*tyle *S*heets)

- 样式定义如何显示html元素

- 外部样式表可以极大的提交工作效率,外部样式表通常存储在css文件中

- 多个样式定义可层叠为一个

  层叠次序(由高到低)

  1. 内联样式(在html元素内部)
  2. 内部样式表(位于`<head>`标签内部)
  3. 外部样式表
  4. 浏览器缺省设置

创建css样式表

1. 内联样式

   ```html
   <p style="margin-left: 20px">This is a paragraph</p>
   ```

2. 内部样式

   ```html
   <head>
       <style type="text/css">
         hr {color: sienna;}
       </style>
   </head>
   ```

3. 外部css

   ```html
   <head>
   	<link rel="stylesheet" type="text/css" href="mystyle.css" />
   </head>
   ```

[css参考手册](https://www.w3school.com.cn/cssref/index.asp)

# css语法

## 基础语法

```css
selector {
    property1: value1;
    property2: value2;
}
```

- selector: 选择器,选取指定的元素
- property: 元素的样式属性
- value: 元素的样式属性值

> 每个property:value以`;`分隔

![CSS 语法](/Users/yingjie.lu/Documents/note/.img/ct_css_selector.gif)

## 高级语法

选择器的分组

> 被分组的选择器就可以分享相同的声明,分组以`,`分隔

```css
h1,h2,h3,h4,h5,h6 {
  color: green;
  }
```

样式继承问题

- 子元素从父元素继承属性
- 通过 CSS 继承，子元素将继承最高级元素所拥有的属性
- 如果需要某些子元素不要继承父元素的样式,则对该子元素单独设置样式属性即可

```css
body {
	font-family: Verdana, sans-serif;
}

/* p标签本应该继承body的字体样式,但是当p标签在单独声明字体样式时,就不会继承最高级元素的样式属性 */
p {
	font-family: Times, "Times New Roman", serif;
}
```

# css选择器

## 后代选择器(div span)

通过元素的位置来进行选择,即选择的元素必须是上一个标签元素的子节点

该选择器可以让你的css样式代码更加的简洁

```css
li strong {
    font-style: italic;
    font-weight: normal;
  }
```

> 即只要是li标签内部的strong标签都会拥有该样式

## 子选择器(div > li)

选择标签元素的直接子元素(即该子元素的父节点就是标签元素)

```css
h1 > strong {
    color:red;
}
```

> h1的直接子元素为strong标签的会被选中

## 兄弟选择器(div + span)

可选择紧接在另一个元素后的元素,且二者有相同的父元素

```css
h1 + p {
    margin-top:50px;
}
```

> 选择紧接在 h1 元素后出现的p元素

## id选择器(#id)

可以选择指定id的元素

> 一般都是唯一的元素,因为id是唯一的

```css
#red {
    color:red;
}
```

## 类选择器(.class)

可以选择指定的class的元素

> 类选择器以一个`.`显示

```css
.center {
    text-align: center
}
```

## 属性选择器([href])

可以选择拥有指定属性的元素

```css
[title] {
	color:red;
}
```

> 为带有 title 属性的所有元素设置样式

```css
[title~=hello] { 
    color:red; 
}
```

> 为带有 title 属性并且等于`hello`的所有元素设置样式

## 伪类(:hover)

css伪类用于向某些选择器添加特殊的效果

语法

`selector : pseudo-class {property: value}`

> 使用`:`加上`属性`来表示

- `:active`: 向被激活的元素添加样式
- `:focus`: 向拥有键盘输入焦点的元素添加样式
- `:hover`: 当鼠标悬浮在元素上方时,向元素添加样式
- `:link`: 向未被访问的链接添加样式
- `:visited`: 向已被访问的链接添加样式
- `:first-child`: 向元素的第一个子元素添加样式

```css
a:hover { 
background-color:yellow;
}
p > i:first-child {
  font-weight:bold;
} 
```

## 伪元素(:before)

伪元素用于向某些选择器设置特殊效果

语法

`selector : pseudo-element {property:value;}`

> `:`加上`属性`

- `:before`: 在元素之前添加内容

  ```css
  h1:before{
    content:url(logo.gif);
  }
  ```

- `:after`: 在元素之后添加内容

  ```css
  h1:after{
    content:url(logo.gif);
  }
  ```

# css普通样式

## 背景

- 背景颜色

  使用`background-color`为元素设置背景色,该属性不能被继承

  ```css
  p {background-color: gray;}
  ```

- 背景图片

  使用`background-image`为元素设置背景图片,默认值为none

  ```css
  body {
      background-image: url(/eg_bg_04.gif);
      background-repeat: repeat;/* 加上该属性可以使背景平铺 */
  }
  ```

  > url: 为图片的资源链接

## 文本

可以改变文本的颜色,字符间距,对齐文本,装饰文本,对文本进行缩进

- 缩进文本

  ```css
  p {text-indent: 5em;}
  ```

- 水平对齐

  ```css
  div {text-align:center;}
  ```

- 词间隔

  ```css
  p.spread {word-spacing: 30px;}
  ```

  > 可以为负数

- 字母间隔

  ```css
  h4 {letter-spacing: 20px}
  ```

  > 可以为负数

- 文本装饰

  ```css
  a {text-decoration: none;}
  ```

  > 去除a标签的下划线

- 处理空白符

  ```css
  p {white-space: normal;}
  ```

## 字体

定义文本字体系列,大小,加粗,分格(如斜体)和变形

- 指定字体系列

  ```css
  body {font-family: sans-serif;}
  ```

  > 为了防止用户为安装该字体,可以填写多个字体来设置默认字体

- 字体风格

  ```css
  p.normal {font-style:normal;} /* 正常显示 */
  p.italic {font-style:italic;} /* 斜体显示 */
  p.oblique {font-style:oblique;} /* 倾斜显示 */
  ```

- 字体加粗

  ```css
  p.normal {font-weight:normal;}
  p.thick {font-weight:bold;}
  p.thicker {font-weight:900;}
  ```

  > 1. 使用`bold`关键字可以将文本设置为粗体
  >
  > 2. 关键字100-900为字体指定了9级加粗度,400等于normal,700等于bold

- 字体大小

  ```css
  h1 {font-size:60px;}
  h2 {font-size:2.5em;}  /* 40px / 16 = 2.5em */
  p {font-size:0.875em;} /* 14px / 16 = 0.875em */
  ```

## 链接

- a:link - 普通的、未被访问的链接
- a:visited - 用户已访问的链接
- a:hover - 鼠标指针位于链接的上方
- a:active - 链接被点击的时刻

```css
a:link {color:#FF0000;}		/* 未被访问的链接 */
a:visited {color:#00FF00;}	/* 已被访问的链接 */
a:hover {color:#FF00FF;}	/* 鼠标指针移动到链接上 */
a:active {color:#0000FF;}	/* 正在被点击的链接 */
```

## 列表

允许放置,修改列表项标志,或者将图片作为列表项标志

```css
ul {list-style-type : square} /* 将列表标志设置为方块 */
ul {list-style-type : none} /* 去除列表标志 */
ul li {list-style-image : url(xxx.gif)} /* 将列表标志设置为图片 */
```

## 表格

```css
table, th, td {
  	border: 1px solid blue; /* 边框 */
   	width:100%; /* 宽度 */
    height:50px; /* 高度 */
    text-align:center; /* 内容水平居中 */
    vertical-align:center; /* 内容垂直居中 */
    padding:15px; /* 内边距 */
}
```

# css高级样式

## 对齐

使用多种属性来水平对齐块元素

- 使用`margin`属性来水平对齐

  可通过将左和右外边距设置为 "auto"，来对齐块元素

  ```css
  .center{
      margin-left:auto;
      margin-right:auto;
      width:70%;
  }
  /* 或者是 */
  .center{
      margin: 0 auto;
      width:70%;
  }
  ```

  > 如果宽度`width`是100%,则对齐没有效果

- 使用`position`属性进行左和右对齐

  ```css
  .right{
      position:absolute;
      right:0px;
      width:300px;
  }
  ```

- 使用`float`属性来进行左和右对齐

  ```css
  .right{
      float:right;
      width:300px;
  }
  ```

## 尺寸

- height - 设置元素的高度
- width - 设置元素的宽度
- max-height - 设置元素的最大高度
- max-width - 设置元素的最大宽度
- min-height - 设置元素的最小高度
- min-width - 设置元素的最小宽度
- line-height - 设置行高

## 分类

分类属性允许你规定如何以及在何处显示元素

- display - 设置是否及如何显示元素
  1. block: 将元素设置为块级元素
  2. inline: 将元素设置为内联元素
  3. none: 隐藏元素
- float - 定义元素在哪个方向浮动
  1. left: 设置左浮动
  2. right: 设置右浮动
- position - 设置元素在文档中的定位方式
  1. `static` : 静态定位
  2. `fixed` : 固定定位
  3. `relative` : 相对定位
  4. `absolute` : 绝对定位
  5. `sticky` : 粘贴定位











# css盒模型

css盒模型规定了元素的内容,内边距,边框和外边距

![CSS 框模型](/Users/yingjie.lu/Documents/note/.img/ct_boxmodel.gif)

元素边框最内部分是实际的内容,直接包围内容的是内边距,内边距呈现了元素的背景,内边距的边缘时边框,边框以外时外边距,外边距默认是透明的,因此不会遮挡其后的任何元素

> 背景作用于由内容,内边距和边框组成的区域

内边距,边框和外边距都是可选的,默认值都是零,但是,许多元素将被设置了外边距和内边距,我们可以通过将元素的margin和padding设置为零来覆盖这些浏览器样式,我们可以这样设置

```css
* {
  margin: 0;
  padding: 0;
}
```

在css中,width和height指的是元素内容区域的宽度和高度; 增加内边距,边框和外边距不会影响内容区域的尺寸,但是会增加元素框的总尺寸

## 内边距(padding)

paddind属性定义元素的内边距; padding属性接受长度值会百分比值,但不允许使用负值

```css
/* 默认上右下左的内边距都是10px */
h1 {padding: 10px;}
/* 配置了上右下左的内边距 */
h2 {padding: 10px 0.25em 2ex 20%;}
```

单边内边距属性

- padding-top
- padding-right
- padding-bottom
- padding-left

## 边框(border)

边框是围绕元素内容和内边距的一条或多条线

border属性允许你规定元素边框的样式,宽度和颜色

> 元素属性的边框绘制是在元素的背景之上的,即不会被背景覆盖

### 边框的样式

```css
a:link img {border-style: outset;}
/* 为一个边框定义多种样式 */
p.aside {border-style: solid dotted dashed double;}
```

定义单边样式

- border-top-style
- border-right-style
- border-bottom-style
- border-left-style

### 边框的宽度

可以通过`border-width`属性指定边框的宽度

指定宽度的两种方式

- 指定长度值

  使用`2px`或`0.1rem`

- 指定关键字

  使用`thin`,`medium`(默认)或`thick`

```css
p {border-width: thick;}
```

定义单边宽度

- border-top-width
- border-right-width
- border-bottom-width
- border-left-width

设置没有边框

- `border-style: none`(默认)

  > 如果设置了没有边框,则设定边框宽度就已经不起作用了

### 边框颜色

使用`border-color`属性设置边框颜色

```css
p {border-color: blue;}
```

定义单边颜色

- border-top-color
- border-right-color
- border-bottom-color
- border-left-color

## 外边距(margin)

围绕在元素边框的空外区域是外边距, 设置外边距会在元素外创建额外的'空白'

margin属性接受任何长度单位,百分数值和负值

- 长度单位i

  ```css
  /* 默认上右下左的外边距都是10px */
  h1 {margin : 10px;}
  /* 配置上右下左的外边距 */
  h1 {margin : 10px 0px 15px 5px;}
  ```

- 百分数值

  ```css
  p {margin : 10%;}
  ```

  > 百分数是相对于父元素的width计算的

单边外边距属性

- margin-top
- margin-right
- margin-bottom
- margin-left

## 外边距合并

外边距合并指的是当两个**垂直外边距**相遇时,他们将形成一个外边距

> 即外边距会重叠在一起,以最大的外边距为标准

只有普通文档流中的**垂直外边距**才会发生合并; 行内框,浮动框和绝对定位之间的外边距不会合并

# css定位(position)

position属性允许你对元素进行定位

position属性值

- `static` : 静态定位
- `fixed` : 固定定位
- `relative` : 相对定位
- `absolute` : 绝对定位
- `sticky` : 粘贴定位
- `float` : 浮动

## 静态定位(static)

HTML 元素的默认值，即没有定位，遵循正常的文档流对象。

静态定位的元素不会受到 top, bottom, left, right影响。

> 静态定位: 属于文档流

```css
div.static {
    position: static;
    border: 3px solid #73AD21;
}
```

## 固定定位(fixed)

元素的位置相对于浏览器窗口是固定位置。

即使窗口是滚动的它也不会移动

> 固定定位: 脱离文档流

```css
p.pos_fixed {
    position:fixed;
    top:30px;
    right:5px;
}
```

## 相对定位(relative)

相对定位元素的定位是相对其正常位置偏移某个距离。

> 相对定位: 属于文档流

```css
#box_relative {
  position: relative;
  left: 30px;
  top: 20px;
}
```

![CSS 相对定位实例](/Users/yingjie.lu/Documents/note/.img/ct_css_positioning_relative_example.gif)

> 使用相对定位时,无论是否进行移动,元素仍占据原来的空间,因此,移动元素会导致覆盖其他元素

## 绝对定位(absolute)

绝对定位的元素的位置相对于最近的已定位父元素，如果元素没有已定位的父元素，那么它的位置相对于`<html>`

窗口滚动则它也会移动

> 绝对定位: 脱离文档流

```css
#box_relative {
  position: absolute;
  left: 30px;
  top: 20px;
}
```

![CSS 绝对定位实例](/Users/yingjie.lu/Documents/note/.img/ct_css_positioning_absolute_example.gif)

> 因为绝对定位的元素会脱离文档流,所以他们呢会覆盖页面上的其他元素; 可以通过设置`z-index`属性来控制这些元素的堆放次序

## 粘贴定位(sticky)

sticky 英文字面意思是粘，粘贴; 

基于用户的滚动位置来定位

粘性定位的元素是依赖于用户的滚动，在 **position:static** 与 **position:fixed** 定位之间切换。

在没有滚动时,元素则按照正常的文档流进行定位; 当页面盾冬超出目标区域时,它的表现就像`fixed`,会固定在目标位置

> 粘贴定位: 更具用户的滚动来动态改变是否属于文档流

```css
div.sticky {
    position: sticky;
    top: 0;
    background-color: green;
    border: 2px solid #4CAF50;
}
```

## 浮动(float)

会使元素向左或向右移动，其周围的元素也会重新排列

一个浮动元素会尽量向左或向右移动，直到它的外边缘碰到包含框或另一个浮动框的边框为止

> 浮动定位: 脱离文档流

示例

![CSS 浮动实例 - 向右浮动的元素](/Users/yingjie.lu/Documents/note/.img/ct_css_positioning_floating_right_example.gif)

> 当把框 1 向右浮动时，它脱离文档流并且向右移动，直到它的右边缘碰到包含框的右边缘

![CSS 浮动实例 - 向左浮动的元素](/Users/yingjie.lu/Documents/note/.img/ct_css_positioning_floating_left_example.gif)

> 1. 当框 1 向左浮动时，它脱离文档流并且向左移动，直到它的左边缘碰到包含框的左边缘。因为它不再处于文档流中，所以它不占据空间，实际上覆盖住了框 2，使框 2 从视图中消失
>
> 2. 如果把所有三个框都向左移动，那么框 1 向左浮动直到碰到包含框，另外两个框向左浮动直到碰到前一个浮动框

![CSS 浮动实例 2 - 向左浮动的元素 ](/Users/yingjie.lu/Documents/note/.img/ct_css_positioning_floating_left_example_2.gif)

> 如果包含框太窄，无法容纳水平排列的三个浮动元素，那么其它浮动块向下移动，直到有足够的空间。如果浮动元素的高度不同，那么当它们向下移动时可能被其它浮动元素“卡住”

# 参考文档

[w3school - css教程](https://www.w3school.com.cn/css/index.asp)