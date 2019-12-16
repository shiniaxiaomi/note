# 非递归计数器

内容如下：

```html
<div id='header'>
  <h1>111</h1>
  <h2>222</h2>
  <h3>333</h3>
  <h4>444</h4>
  <h5>555</h5>
  <h6>666</h6>
  <h1>333</h1>
<div>
```

设置计数器

```css
/* 当遇到#header元素时(最外层的元素)，初始化或清零所有标题的计数器 */
#header{
  counter-reset:header-h1,header-h2,header-h3,header-h4,header-h5,header-h6;
}
/* 当遇到h1元素时，初始化或清零除计数器header-h1以外的所有计数器 */
#header h1{
  counter-reset:header-h2,header-h3,header-h4,header-h5,header-h6;
}
/* 当遇到h2元素时，初始化或清零除计数器header-h1，header-h2以外的所有计数器，以此类推 */
#header h2{
  counter-reset:header-h3,header-h4,header-h5,header-h6;
}
#header h3{
  counter-reset:header-h4,header-h5,header-h6;
}
#header h4{
  counter-reset:header-h5,header-h6;
}
#header h5{
  counter-reset:header-h6;
}
/* 当遇到h6元素时，无需初始化或清零除计数器header-h6，因为h6是最后一级 */
```

> `counter-reset`表示如果没有初始化计数器，则初始化。如果已存在计数器，则将计数器清零。

增加并显示计数器的数值

```css
#header h1::before{
  	counter-increment: header-h1;/*增加header-h1计数器*/
    content: counter(header-h1) ".";/*显示header-h1计数器的数值*/
}
/*以此类推来设置h2-h6*/
#header h2::before{
  	counter-increment: header-h2;
    content: counter(header-h2) ".";
}
#header h3::before{
  	counter-increment: header-h3;
    content: counter(header-h3) ".";
}
#header h4::before{
  	counter-increment: header-h4;
    content: counter(header-h4) ".";
}
#header h5::before{
  	counter-increment: header-h5;
    content: counter(header-h5) ".";
}
#header h6::before{
  	counter-increment: header-h6;
    content: counter(header-h6) ".";
}
```

> `::before`表示将指定的内容显示在h1标题的内容前面
>
> 如果要在一个标题中显示其他计数器，则将`counter(计数器名称)`放在指定的`content`中即可