# BootStrap4.3笔记

## 快速入门

最基本的模板

```html
<!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">

    <title>Hello, world!</title>
  </head>
  <body>
    <h1>Hello, world!</h1>

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.4.1/dist/jquery.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
  </body>
</html>
```

## 文档内容记录

### 颜色

#### 文字

https://v4.bootcss.com/docs/utilities/colors/#color

```html
<p class="text-primary">.text-primary</p>
<p class="text-secondary">.text-secondary</p>
<p class="text-success">.text-success</p>
<p class="text-danger">.text-danger</p>
<p class="text-warning">.text-warning</p>
<p class="text-info">.text-info</p>
<p class="text-light bg-dark">.text-light</p>
<p class="text-dark">.text-dark</p>
<p class="text-body">.text-body</p>
<p class="text-muted">.text-muted</p>
<p class="text-white bg-dark">.text-white</p>
<p class="text-black-50">.text-black-50</p>
<p class="text-white-50 bg-dark">.text-white-50</p>
```

#### 背景

https://v4.bootcss.com/docs/utilities/colors/#background-color

```html
<div class="p-3 mb-2 bg-primary text-white">.bg-primary</div>
<div class="p-3 mb-2 bg-secondary text-white">.bg-secondary</div>
<div class="p-3 mb-2 bg-success text-white">.bg-success</div>
<div class="p-3 mb-2 bg-danger text-white">.bg-danger</div>
<div class="p-3 mb-2 bg-warning text-dark">.bg-warning</div>
<div class="p-3 mb-2 bg-info text-white">.bg-info</div>
<div class="p-3 mb-2 bg-light text-dark">.bg-light</div>
<div class="p-3 mb-2 bg-dark text-white">.bg-dark</div>
<div class="p-3 mb-2 bg-white text-dark">.bg-white</div>
<div class="p-3 mb-2 bg-transparent text-dark">.bg-transparent</div>
```

### 响应式

可以通过一下的配置来针对不同的屏幕大小

```css
// Extra small devices (portrait phones, less than 576px)
@media (max-width: 575.98px) { ... }

// Small devices (landscape phones, 576px and up)
@media (min-width: 576px) and (max-width: 767.98px) { ... }

// Medium devices (tablets, 768px and up)
@media (min-width: 768px) and (max-width: 991.98px) { ... }

// Large devices (desktops, 992px and up)
@media (min-width: 992px) and (max-width: 1199.98px) { ... }

// Extra large devices (large desktops, 1200px and up)
@media (min-width: 1200px) { ... }
```

例如:

在屏幕小于768px时,使用指定的样式:

```css
@media (max-width: 768px){
	...
}
```

在屏幕大于768px时,使用指定的样式

```css
@media (min-width: 768px){
	...
}
```

在屏幕大于768px,小于1200px时,使用指定的样式

```css
@media (min-width: 768px) and (max-width: 1200px){
	...
}
```

### 布局

https://v4.bootcss.com/docs/layout/overview/

在bootstrap中有3种容器,分别为: 

1. `.container`: 响应式的,不同的屏幕大小其最大宽度都会发生变化
2. `.container-fluid`: 流式布局,跨越整个视窗宽度,占100%的屏幕
3. `.container-{breakpoint}`,例如`.container-sm`,可以设置特殊化设置

**这些容器在不同的屏幕大小下会有不同的max-width**:

| max-width:         | Extra small <576px | Small ≥576px | Medium ≥768px | Large ≥992px | Extra large ≥1200px |
| ------------------ | ------------------ | ------------ | ------------- | ------------ | ------------------- |
| `.container`       | 100%               | 540px        | 720px         | 960px        | 1140px              |
| `.container-sm`    | 100%               | 540px        | 720px         | 960px        | 1140px              |
| `.container-md`    | 100%               | 100%         | 720px         | 960px        | 1140px              |
| `.container-lg`    | 100%               | 100%         | 100%          | 960px        | 1140px              |
| `.container-xl`    | 100%               | 100%         | 100%          | 100%         | 1140px              |
| `.container-fluid` | 100%               | 100%         | 100%          | 100%         | 100%                |

### 栅格

https://v4.bootcss.com/docs/layout/grid/

#### 堆叠到水平(***)

比如屏幕大小为sm时,元素会被挤的很小,这是需要让每个元素独占一行,即所谓的堆叠到对平,这是就可以使用以下代码:

使用`col-sm`,`col-md`等可以实现该效果,并且当屏幕在对应的大小时,就可以让元素独占一行

当屏幕大于设置值时,就按照均分或者给定的列宽比例显示

```html
<div class="container">
  <div class="row">
    <div class="col-sm-8">col-sm-8</div>
    <div class="col-sm-4">col-sm-4</div>
  </div>
  <div class="row">
    <div class="col-sm">col-sm</div>
    <div class="col-sm">col-sm</div>
    <div class="col-sm">col-sm</div>
  </div>
</div>
```

在上述的代码中:

- 第一个row中

  一个列为`col-sm-8`,一个列为`col-sm-4`,则表示当屏幕大于sm时,两个列按照8:4显示,当屏幕小于等于sm时,这两个列就独占一行

- 第二个row中

  三个列都为`col-sm`,则表示当屏幕大于,三个列按照1:1:1显示,当屏幕小于等于sm时,这三个列就独占一行

> 其中的`col-sm`中的sm可以替换成其他的屏幕大小,效果相同
>
> 例如:如果设置为`col-md`,则屏幕在大于md时,按照给定的比例显示,在小于等于md时,每个列独占一行

**重要**

可以理解成当使用`col-sm-*`时,就表示,当屏幕大于sm时,就按照该比例显示

当同时使用`col-sm-*`和`col-md-*`时,则当屏幕大于md时,就按照md比例显示,当屏幕大于sm小于md时,就按照sm比例显示

当只使用`col-*`时,则任何屏幕都按照指定比例显示(优先级最低)

当一列同时使用`col-*`和`col-sm-*`时,则当屏幕大于sm时,就按照sm比例显示,如果小于sm,则按照col比例显示

#### 混合搭配(***)

通过上述的堆叠到水平,可以理解`col-sm`之类的语句的函数,混合搭配就是使用单纯`col-*`

和`col-sm-*`之类的语句进行搭配使用,基本的规则如下:

- 当一列同时使用`col-*`和`col-sm-*`时,则当屏幕大于sm时,就按照sm比例显示,如果小于sm,则按照col比例显示

#### 等宽

```html
<div class="container">
    <div class="row">
        <div class="col">等宽</div>
        <div class="col">等宽</div>
        <div class="col">等宽</div>
    </div>
</div>
```

![image-20200129110247272](/Users/yingjie.lu/Documents/note/.img/image-20200129110247272.png)

#### 一个列固定,其他等宽

```html
<div class="container">
    <div class="row">
        <div class="col">等宽(平分剩下的宽度)</div>
        <div class="col-6">占6格</div>
        <div class="col">等宽(平分剩下的宽度)</div>
    </div>
</div>
```

> 使用`col-6`就是固定的,使用`col`就是剩下的平分(即等宽)
>
> ![image-20200129110225586](/Users/yingjie.lu/Documents/note/.img/image-20200129110225586.png)

#### 根据内容的多少自动变化宽度

```html
<div class="container">
    <div class="row">
        <div class="col">111</div>
        <div class="col-md-auto">占用少</div>
    </div>
</div>

<div class="container">
    <div class="row">
        <div class="col">111</div>
        <div class="col-md-auto">占用多占用多占用多占用多占用多占用多</div>
    </div>
</div>
```

![image-20200129110156903](/Users/yingjie.lu/Documents/note/.img/image-20200129110156903.png)

#### 设置列的宽度

```html
<div class="container">
  <div class="row">
    <div class="col-8">占8份</div>
    <div class="col-4">占4份</div>
  </div>
</div>
```

![image-20200129110439542](/Users/yingjie.lu/Documents/note/.img/image-20200129110439542.png)

#### 设置不同屏幕大小的列的宽度

```html
<div class="container">
  <div class="row">
    <div class="col-sm-8">col-sm-8</div>
    <div class="col-sm-4">col-sm-4</div>
  </div>
  <div class="row">
    <div class="col-sm">col-sm</div>
    <div class="col-sm">col-sm</div>
    <div class="col-sm">col-sm</div>
  </div>
</div>
```

![image-20200129110547772](/Users/yingjie.lu/Documents/note/.img/image-20200129110547772.png)

#### 设置一行最多几列,多的另起一行

```html
<div class="container">
  <div class="row row-cols-2">
    <div class="col">1</div>
    <div class="col">2</div>
    <div class="col">另起一行</div>
    <div class="col">另起一行</div>
  </div>
</div>
```

![image-20200129110716353](/Users/yingjie.lu/Documents/note/.img/image-20200129110716353.png)

#### 设置列的对齐方式

```html
<div class="container">
  <!--左对齐-->
  <div class="row justify-content-start">
    <div class="col-4"></div>
    <div class="col-4"></div>
  </div>
  <!--居中-->
  <div class="row justify-content-center">
    <div class="col-4"></div>
    <div class="col-4"></div>
  </div>
  <!--右对齐-->
  <div class="row justify-content-end">
    <div class="col-4"></div>
    <div class="col-4"></div>
  </div>
  <!--有间隙的均分一行-->
  <div class="row justify-content-around">
    <div class="col-4"></div>
    <div class="col-4"></div>
  </div>
  <!--分散在左右两边-->
  <div class="row justify-content-between">
    <div class="col-4"></div>
    <div class="col-4"></div>
  </div>
</div>
```

![image-20200129111240272](/Users/yingjie.lu/Documents/note/.img/image-20200129111240272.png)

#### 偏移列

```html
<div class="container">
  <div class="row">
    <div class="col-md-4">.col-md-4</div>
    <!--往右偏移4份-->
    <div class="col-md-4 offset-md-4">.col-md-4 .offset-md-4</div>
  </div>
</div>
```

![image-20200129111425016](/Users/yingjie.lu/Documents/note/.img/image-20200129111425016.png)









### 页面内容

#### 排版

https://v4.bootcss.com/docs/content/typography/

### 组件

#### 徽章

示例1:

```html
<h1>Example heading <span class="badge badge-secondary">New</span></h1>
```

![image-20200129112529336](/Users/yingjie.lu/Documents/note/.img/image-20200129112529336.png)

示例2:

```html
<button type="button" class="btn btn-primary">
  Notifications <span class="badge badge-light">4</span>
</button>
```

![image-20200129112544447](/Users/yingjie.lu/Documents/note/.img/image-20200129112544447.png)

自定义徽章:

```html
<span class="badge badge-primary">Primary</span>
<span class="badge badge-secondary">Secondary</span>
<span class="badge badge-success">Success</span>
<span class="badge badge-danger">Danger</span>
<span class="badge badge-warning">Warning</span>
<span class="badge badge-info">Info</span>
<span class="badge badge-light">Light</span>
<span class="badge badge-dark">Dark</span>
```

![image-20200129112605230](/Users/yingjie.lu/Documents/note/.img/image-20200129112605230.png)

链接徽章:

```html
<a href="#" class="badge badge-primary">Primary</a>
<a href="#" class="badge badge-secondary">Secondary</a>
<a href="#" class="badge badge-success">Success</a>
<a href="#" class="badge badge-danger">Danger</a>
<a href="#" class="badge badge-warning">Warning</a>
<a href="#" class="badge badge-info">Info</a>
<a href="#" class="badge badge-light">Light</a>
<a href="#" class="badge badge-dark">Dark</a>
```

> 可以直接当做链接来使用

#### 面包屑导航

```html
<nav aria-label="breadcrumb">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="#">Home</a></li>
    <li class="breadcrumb-item"><a href="#">Library</a></li>
    <li class="breadcrumb-item active" aria-current="page">Data</li>
  </ol>
</nav>
```

![image-20200129113153134](/Users/yingjie.lu/Documents/note/.img/image-20200129113153134.png)

#### 按钮

https://v4.bootcss.com/docs/components/buttons/

按钮组

https://v4.bootcss.com/docs/components/button-group/

#### 卡片

https://v4.bootcss.com/docs/components/card/#list-groups

#### 折叠

https://v4.bootcss.com/docs/components/collapse/

#### 下拉菜单

https://v4.bootcss.com/docs/components/dropdowns/#single-button

#### 表单

https://v4.bootcss.com/docs/components/forms/

#### 输入框

https://v4.bootcss.com/docs/components/input-group/#basic-example

#### 列表组

https://v4.bootcss.com/docs/components/list-group/#basic-example

#### 模态框

https://v4.bootcss.com/docs/components/modal/#varying-modal-content

使用时需要js进行初始化:

```js
$('#myModal').modal(options)
```

#### 导航(目录)

https://v4.bootcss.com/docs/components/navs/#vertical

#### 导航栏

https://v4.bootcss.com/docs/components/navbar/#supported-content

导航栏中的文字

https://v4.bootcss.com/docs/components/navbar/#text

导航栏的定位

https://v4.bootcss.com/docs/components/navbar/#placement

#### 分页

https://v4.bootcss.com/docs/components/pagination/#overview

#### 弹出框

https://v4.bootcss.com/docs/components/popovers/#example

#### 滚动监听(*)

https://v4.bootcss.com/docs/components/scrollspy/#example-with-nested-nav

可以使用在导航(目录)上,鼠标滚动,目录会重新定位

#### 文字提示框

https://v4.bootcss.com/docs/components/tooltips/#examples

```html
<!--上边-->
<button type="button" class="btn btn-secondary" data-toggle="tooltip" data-placement="top" title="Tooltip on top">
  Tooltip on top
</button>
<!--右边-->
<button type="button" class="btn btn-secondary" data-toggle="tooltip" data-placement="right" title="Tooltip on right">
  Tooltip on right
</button>
<!--下边-->
<button type="button" class="btn btn-secondary" data-toggle="tooltip" data-placement="bottom" title="Tooltip on bottom">
  Tooltip on bottom
</button>
<!--左边-->
<button type="button" class="btn btn-secondary" data-toggle="tooltip" data-placement="left" title="Tooltip on left">
  Tooltip on left
</button>
```

使用

需要结合js:

```js
$('#example').tooltip(options)
```

如果需要滚动条:

```js
$('#example').tooltip({ boundary: 'window' })
```

### 工具类

bootstrap提供了很多很好用的工具类,可以加快和便捷样式的编写

#### 快速使用margin和padding属性

https://v4.bootcss.com/docs/utilities/spacing/

> 间隔(margin和padding)(***)

主要格式如下:

- `{property}{sides}-{size}`: 针对`xs`
- `{property}{sides}-{breakpoint}-{size}`:`{breakpoint}`的值可以为`sm`，`md`，`lg`，和`xl`

`{property}`的值可为`m`和`p`,`m`表示margin,`p`表示padding

`{sides}`的值可为以下几种:

- `t`-对于设置`margin-top`或`padding-top`
- `b`-对于设置`margin-bottom`或`padding-bottom`
- `l`-对于设置`margin-left`或`padding-left`
- `r`-对于设置`margin-right`或`padding-right`
- `x`-对于同时设置`*-left`和`*-right`
- `y`-对于同时设置`*-top`和`*-bottom`

`{size}`的值可为以下几种:

- `0`-对于消除`margin`或`padding`通过将其设置为的类`0`
- `1`- （默认情况下）的类时，设置`margin`或`padding`以`$spacer * .25`
- `2`- （默认情况下）的类时，设置`margin`或`padding`以`$spacer * .5`
- `3`- （默认情况下）的类时，设置`margin`或`padding`以`$spacer`
- `4`- （默认情况下）的类时，设置`margin`或`padding`以`$spacer * 1.5`
- `5`- （默认情况下）的类时，设置`margin`或`padding`以`$spacer * 3`
- `auto`-对于将设为`margin`自动的类

##### 示例:

- `mx-2`:左右margin为2
- `my-2`:上下margin为2
- `mx-2 my-2`:上下左右margin为2
- `mt-2`:上margin为2
- `mb-2`:下margin为2
- `ml-2`:左margin为2
- `mr-2`:右margin为2

> 设置padding则将`m`改为`p`即可

##### 设置水平居中

```html
<div class="mx-auto" style="width: 200px;">
  Centered element
</div>
```

##### 清除margin或padding

```html
<div class="mx-0 my-0" style="width: 200px;">
  Centered element
</div>
```

#### 边框

https://v4.bootcss.com/docs/utilities/borders/

设置边框的样式

##### 将图片的边框设置为圆形

https://v4.bootcss.com/docs/utilities/borders/#border-radius

```html
<img src="..." width="30" height="30" class="rounded-circle" alt="">
```

> 添加`rounded-circle`样式即可

#### 清除浮动

https://v4.bootcss.com/docs/utilities/clearfix/

目前不知道怎么用

#### Display属性

https://v4.bootcss.com/docs/utilities/display/

可以快速的指定在哪种屏幕大小中显示或隐藏

规则如下:

共有两种命名格式:

- `.d-{value}` 针对于xs
- `.d-{breakpoint}-{value}`,其中的`{breakpoint}`的值可为sm,md,lg,xl

其中的value可以填写以下属性:

- `none`
- `inline`
- `inline-block`
- `block`
- `table`
- `table-cell`
- `table-row`
- `flex`
- `inline-flex`

例如:

- 可以通过设置`class="d-inline"`让块级元素变为行内元素

  ```html
  <div class="d-inline p-2 bg-primary text-white">d-inline</div>
  <div class="d-inline p-2 bg-dark text-white">d-inline</div>
  ```

- 可以通过设置`class="d-block"`让行内元素变为块级元素

  ```html
  <span class="d-block p-2 bg-primary text-white">d-block</span>
  <span class="d-block p-2 bg-dark text-white">d-block</span>
  ```

##### 在不同屏幕大小下隐藏元素

https://v4.bootcss.com/docs/utilities/display/#hiding-elements

示例:

当屏幕小于lg时隐藏

```html
<div class="row">
  <div class="col-lg-9"></div>
  <div class="col-lg-3 d-none d-lg-block"></div>
</div>
```

> 当屏幕大于lg时,两个列按照9:3的比例显示;
>
> 当屏幕小于等于lg时,第一个列独占一行(100%宽度),第二行隐藏
>
> 重点:一般`d-none d-lg-block`会和`col-lg`一同使用比较好

#### 内嵌不同比例的iframe

https://v4.bootcss.com/docs/utilities/embed/

用于加载视频等信息,例如:

```html
<div class="embed-responsive embed-responsive-16by9">
  <iframe class="embed-responsive-item" src="https://www.youtube.com/embed/zpOULjyy-n8?rel=0" allowfullscreen></iframe>
</div>
```

![image-20200129121100648](/Users/yingjie.lu/Documents/note/.img/image-20200129121100648.png)

#### Flex布局(**)

https://v4.bootcss.com/docs/utilities/flex/

通过简单的设置class即可实现任意元素内的Flex布局

示例:

```html
<div class="container">
    <div class="d-flex p-2 bd-highlight">
        实现了Flex布局的div
        <div class="p-2">test</div>
        <button>我是按钮</button>
    </div>

    <div class="p-2 bd-highlight">
        没有实现了Flex布局
        <div class="p-2">test</div>
        <button>我是按钮</button>
    </div>
</div>
```

![image-20200129121555012](/Users/yingjie.lu/Documents/note/.img/image-20200129121555012.png)

...

#### Float浮动(**)

https://v4.bootcss.com/docs/utilities/float/

添加简单的class即可实现元素的浮动

```html
<div class="container">
    <div class="float-left">在父容器中左浮动</div><br>
    <div class="float-right">在父容器中右浮动</div><br>
    <div class="float-none">不浮动,占满行</div>
</div>
```

![image-20200129122140859](/Users/yingjie.lu/Documents/note/.img/image-20200129122140859.png)

#### 溢出自动滚动(Overflow)(**)

```html
<div class="overflow-auto">...</div>
<div class="overflow-hidden">...</div>
```

> **这个只有在div容器设置了高度之后才会生效**

![image-20200129122439338](/Users/yingjie.lu/Documents/note/.img/image-20200129122439338.png)

#### 定位Position(***)

https://v4.bootcss.com/docs/utilities/position/

普通的定位:

```html
<div class="position-static">...</div>
<div class="position-relative">...</div>
<div class="position-absolute">...</div>
<div class="position-fixed">...</div>
<div class="position-sticky">...</div>
```

使元素固定在顶部不滚动:

```html
<div class="fixed-top">...</div>
```

使元素固定在底部不滚动:

```html
<div class="fixed-bottom">...</div>
```

##### 使元素粘贴在顶部:

```html
<div class="sticky-top" style="top: 50px">...</div>
```

> 非常的好用,通过`sticky-top`即可实现粘贴工具,还可以通过style设置top来控制粘贴距离顶部的距离
>
> 可以配合上内容溢出后自动滚动,即再添加`class="overflow-auto"`即可实现内部内容也可溢出滚动(注意:主要给容器固定高度才可以实现该功能)

简单示例:

```html
<div class="container">
  <h1>测试</h1>
  <div class="sticky-top overflow-auto" style="height: 300px;top: 10px;">
    <iframe src="http://www.baidu.com" width="100%" height="500px"></iframe>
  </div>
  <iframe src="https://cn.bing.com/" width="100%" height="1000px"></iframe>
</div>
```

> 只有一个粘贴的元素

两个粘贴的元素

```html
<div class="container">
  <h1>测试</h1>
  <div class="sticky-top overflow-auto" style="height: 300px;top: 10px;">
    <iframe src="http://www.baidu.com" width="100%" height="500px"></iframe>
  </div>
  <div class="sticky-top overflow-auto" style="height: 300px;top: 350px;">
    <iframe src="http://www.baidu.com" width="100%" height="500px"></iframe>
  </div>
  <iframe src="https://cn.bing.com/" width="100%" height="1000px"></iframe>
</div>
```

#### 设置阴影

https://v4.bootcss.com/docs/utilities/shadows/

```html
<div class="shadow-none p-3 mb-5 bg-light rounded">无阴影</div>
<div class="shadow-sm p-3 mb-5 bg-white rounded">小阴影</div>
<div class="shadow p-3 mb-5 bg-white rounded">一般阴影</div>
<div class="shadow-lg p-3 mb-5 bg-white rounded">大阴影</div>
```

![image-20200129125318923](/Users/yingjie.lu/Documents/note/.img/image-20200129125318923.png)

#### 尺寸(***)

https://v4.bootcss.com/docs/utilities/sizing/

快速设置元素的尺寸,可以是宽度或高度,可以是相对于父元素的或是相对于视窗

##### 相当于父元素的宽度设置

```html
<div class="w-25" style="background-color: #eee;">Width 25%</div>
<div class="w-50" style="background-color: #eee;">Width 50%</div>
<div class="w-75" style="background-color: #eee;">Width 75%</div>
<div class="w-100" style="background-color: #eee;">Width 100%</div>
<div class="w-auto" style="background-color: #eee;">Width auto</div>
```

> `w-25`表示设置该元素为其父元素的宽度的25%

![image-20200129125805395](/Users/yingjie.lu/Documents/note/.img/image-20200129125805395.png)

##### 相当于父元素的高度设置

```html
<div class="container">
  <div style="height: 100px;">
    <div class="h-25 d-inline-block" style="width: 120px;">Height 25%</div>
    <div class="h-50 d-inline-block" style="width: 120px;">Height 50%</div>
    <div class="h-75 d-inline-block" style="width: 120px;">Height 75%</div>
    <div class="h-100 d-inline-block" style="width: 120px;">Height 100%</div>
    <div class="h-auto d-inline-block" style="width: 120px;">Height auto</div>
  </div>
</div>
```

> `h-25`表示设置该元素为其父元素的高度的25%

![image-20200129130046305](/Users/yingjie.lu/Documents/note/.img/image-20200129130046305.png)

##### 快速设置相对于父元素的最大宽度和最大高度

最大宽度:`class="mw-100"`

最大高度:`class="mh-100"`

最大宽度和最大高度:`class="mw-100 mh-100"`

##### 相当于视窗的高度和宽度

```html
<div class="min-vw-100">Min-width 100vw</div>
<div class="min-vh-100">Min-height 100vh</div>
<div class="vw-100">Width 100vw</div>
<div class="vh-100">Height 100vh</div>
```

#### 拉伸链接

https://v4.bootcss.com/docs/utilities/stretched-link/

将链接可点击的区域变大

```html
<div>
    <a href="#" class="btn btn-primary stretched-link">Go somewhere</a>
</div>
```

通过在a标签中添加`stretched-link`类,可以链接可以延伸到包裹其的父元素

#### 文本相关

https://v4.bootcss.com/docs/utilities/text/

##### 对齐

```html
<p class="text-left">Left aligned text on all viewport sizes.</p>
<p class="text-center">Center aligned text on all viewport sizes.</p>
<p class="text-right">Right aligned text on all viewport sizes.</p>
```

##### 文字折行

```html
<div class="badge badge-primary text-wrap" style="width: 6rem;">
  This text should wrap.
</div>
```

> 添加上`text-wrap`类即可

##### 文字溢出后省略为...

```html
<!-- Block level -->
<div class="row">
  <div class="col-2 text-truncate">
    Praeterea iter est quasdam res quas ex communi.
  </div>
</div>

<!-- Inline level -->
<span class="d-inline-block text-truncate" style="max-width: 150px;">
  Praeterea iter est quasdam res quas ex communi.
</span>
```

> 添加上`text-truncate`类即可

##### 单词中断

```html
<p class="text-break">mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm</p>
```

> 添加上`text-break`类即可

##### 字体加粗

```html
<!--加粗-->
<p class="font-weight-bold">Bold text.</p>
<!--更粗-->
<p class="font-weight-bolder">Bolder weight text (relative to the parent element).</p>
```

##### 设置等宽字体

```html
<p class="text-monospace">This is in monospace</p>
```

##### 重置文本颜色

```html
<p class="text-muted">
  Muted text with a <a href="#" class="text-reset">重置链接的颜色</a>.
</p>
```

> 用 `.text-reset` 类重置文本或链接的颜色，以便从父元素继承颜色属性。

##### 去掉链接的下划线

```html
<a href="#" class="text-decoration-none">不带下划线的链接</a>
```

#### 垂直对齐

https://v4.bootcss.com/docs/utilities/vertical-align/

```html
<span class="align-baseline">baseline</span>
<span class="align-top">top</span>
<span class="align-middle">middle</span>
<span class="align-bottom">bottom</span>
<span class="align-text-top">text-top</span>
<span class="align-text-bottom">text-bottom</span>
```