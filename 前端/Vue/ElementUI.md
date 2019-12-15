# 介绍

使用Vue开发的前端UI框架

# 安装

npm安装：

```js
npm i element-ui -S
```

直接引入js

```html
<!-- import element CSS -->
<link href="https://cdn.bootcss.com/element-ui/2.12.0/theme-chalk/index.css" rel="stylesheet">
<!--vue.js-->
<script src="https://cdn.bootcss.com/vue/2.6.10/vue.min.js"></script>
<!--element.js-->
<script src="https://cdn.bootcss.com/element-ui/2.12.0/index.js"></script>
```

# 快速开始

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=0">
    <title>index</title>
    <!-- import element CSS -->
    <link href="https://cdn.bootcss.com/element-ui/2.12.0/theme-chalk/index.css" rel="stylesheet">
  </head>

  <body>
    <div id="app">
      <el-button @click="visible = true">Button</el-button>
      <el-dialog :visible.sync="visible" title="Hello world">
        <p>Try Element</p>
      </el-dialog>
    </div>
  </body>
  
  <!--vue.js-->
  <script src="https://cdn.bootcss.com/vue/2.6.10/vue.min.js"></script>
  <!--element.js-->
  <script src="https://cdn.bootcss.com/element-ui/2.12.0/index.js"></script>

  <script>
    new Vue({
      el: '#app',
      data: function() {
        return { visible: false }
      }
    })
  </script>

</html>
```

# Layout布局

通过 row 和 col 组件，并使用 `span` 属性我们就可以自由地组合布局。

## 基础布局

```html
<el-row>
  <el-col :span="12"></el-col>
  <el-col :span="12"></el-col>
</el-row>
```

> row表示一行，col表示一列，一行有24份，col中的`:span`属性设置该列占多少份
>
> 如果一行中的col总和大于24份，则会被挤到下一行

> 在被col分割后，生成的col内部也会存在一个基础的24分栏，我们可以在其内部再通过`:span`来进行24分栏比例分配

## 设置每列的间隔

通过在row中设置 `gutter` 属性来指定每栏之间的间隔

例如：

![image-20191120152333198](/Users/yingjie.lu/Documents/note/.img/image-20191120152333198.png)

```html
<el-row :gutter="20">
  <el-col :span="8"></el-col>
  <el-col :span="8"></el-col>
  <el-col :span="8"></el-col>
</el-row>
```

> 上述一行中的3列之间的间隔为20px

## 混合布局

在一列中再添加一行row

```html
<el-row>
	<el-col :span="12"></el-col>
  <el-col :span="12">
    <el-row>
      <el-col :span="24"></el-col>
    </el-row>
  </el-col>
</el-row>
```

## 偏移列

通过设置col中的`offset`属性来偏移列

> 其设置的是偏移的份数

```html
<el-row>
  <el-col :span="6"></el-col>
  <el-col :span="6" :offset="6"></el-col>
</el-row>
```

> 往右偏移6个份数

## 对齐方式

定义一行中的列的排列方式

### 列靠左

![image-20191215232508503](/Users/yingjie.lu/Documents/note/.img/image-20191215232508503.png)

```html
<el-row type="flex" class="row-bg">
  <el-col :span="6"></el-col>
  <el-col :span="6"></el-col>
  <el-col :span="6"></el-col>
</el-row>
```

> 默认使用该种对齐方式，无需设置

### 居中列

![image-20191215232223121](/Users/yingjie.lu/Documents/note/.img/image-20191215232223121.png)

```html
<el-row type="flex" class="row-bg" justify="center">
  <el-col :span="6"></el-col>
  <el-col :span="6"></el-col>
  <el-col :span="6"></el-col>
</el-row>
```

> 每列都紧挨着，并且居中

### 列靠右

![image-20191215232652695](/Users/yingjie.lu/Documents/note/.img/image-20191215232652695.png)

```html
<el-row type="flex" class="row-bg" justify="end">
  <el-col :span="6"></el-col>
  <el-col :span="6"></el-col>
  <el-col :span="6"></el-col>
</el-row>
```

> 每列都紧挨着，并且靠右

### 将每列均匀的排列

![image-20191215232914496](/Users/yingjie.lu/Documents/note/.img/image-20191215232914496.png)

```html
<el-row type="flex" class="row-bg" justify="space-around">
  <el-col :span="6"></el-col>
  <el-col :span="6"></el-col>
  <el-col :span="6"></el-col>
</el-row>
```

> 每列的左右都会有一定的间距

## 响应式布局

参照了 Bootstrap 的 响应式设计，预设了五个响应尺寸：`xs`、`sm`、`md`、`lg` 和 `xl`。

![image-20191120152756673](/Users/yingjie.lu/Documents/note/.img/image-20191120152756673.png)

```html
<el-row>
  <el-col :xs="24" :sm="16" :md="12" :lg="6" :xl="3"></el-col>
</el-row>
```

> `:xs="24"`：当屏幕<`768px`时，该列将占24份
>
> `:sm="16"`：当`768px`<屏幕<`992px`，该列占16分
>
> `:md="12"`：当`992px`<屏幕<`1200px`，该列占12分
>
> `:lg="6"`：当`1200px`<屏幕<`1920px`，该列占6分
>
> `:xl="3"`：当屏幕>`1920px`，该列占3分

基本原则：当屏幕越小，占用的份数越大；当屏幕越大，占用的份数越小；

> 因为一行的份数总是24份，但是屏幕越大，一行的像素越多，即每份的像素越多，所以如果想要保持列的宽度基本不变，则减少列所占用的份数即可

# 按钮

```html
<el-button>默认按钮</el-button>
<el-button round>圆角按钮</el-button>
<el-button type="text">文字按钮</el-button>
```

```html
<el-button size="medium">中等按钮</el-button>
<el-button size="small">小型按钮</el-button>
<el-button size="mini">超小按钮</el-button>
```

# 文字链接

```html
<el-link>默认链接</el-link>
<el-link type="danger">危险链接</el-link>
<el-link type="info">信息链接</el-link>
```

```html
<el-link :underline="false">无下划线</el-link>
```

# 消息提示

## 消息提示

```js
this.$message('这是一条消息提示');
```

## 弹框提示

```js
this.$confirm('此操作将永久删除该文件, 是否继续?', '提示', {
  confirmButtonText: '确定',
  cancelButtonText: '取消',
  type: 'warning'
}).then(() => {
  //...
});
```

# 抽屉

```html
<el-drawer
           id="header"
           title="导航"
           :visible.sync="outline_drawer"
           direction="ltr"
           :modal="true"
           :size="outline_size">
  	<h1>test</h1>
</el-drawer>

<script>
data:{
	outline_size:'20%', 
  outline_drawer: false,
}
</script>
```

> `direction="ltr"` ：设置打开的方向（从做往右）
>
> `:modal="true"`：设置是否需要遮罩层
>
> `:size="outline_size"`：设置抽屉的大小
>
> `:visible.sync="outline_drawer"`：设置抽屉打开或关闭
>
> `title="导航"`：设置抽屉的标题

# 标签页

```html
<el-tabs type="border-card" :stretch="true">
  <el-tab-pane label="大纲">
    <h1>test1</h1>
  </el-tab-pane>
  <el-tab-pane label="目录">
    <h1>test2</h1>
  </el-tab-pane>
</el-tabs>
```

> `type="border-card"`：将标签页设置为卡片风格
>
> `:stretch="true"`：设置标签的宽度自动撑开

# 输入框

```html
<el-input
        placeholder="输入关键字进行过滤"
        v-model="filterDirText">
</el-input>

<script>
data:{
	filterDirText:'', 
}
</script>
```

> `v-model="filterDirText"`：设置保存输入框值的变量

# 树

```html
<el-tree
        class="filter-tree"
        :data="dirData"
        :props="defaultDirProps"
        default-expand-all
        :expand-on-click-node="false"
        :filter-node-method="filterNode"
        @node-click="handleNodeClick"
        ref="tree">
</el-tree>

<script>
data:{
		dirData:[], //保存节点的数据
    defaultDirProps: { //设置节点内容的对应关系
      children: 'child',
      label: 'name',
      value:'url'
    },
},
methods:{
  	//节点点击的回调
    handleNodeClick(data,node,nodes) {
      if(node.isLeaf){
        window.location="/blog"+data.url;
      }
    },
    //节点的过滤回调
    filterNode(value, data) {
      if (!value) return true;
      return data.name.toLowerCase().indexOf(value.toLowerCase()) !== -1;
    },
}
</script>
```

> `:data="dirData"`：绑定数据
>
> `:props="defaultDirProps"`：设置节点内容的对应关系
>
> `default-expand-all`：设置默认将树的节点全部展开
>
> `:expand-on-click-node="false"`：设置为点击节点不收缩
>
> `:filter-node-method="filterNode"`：设置过滤节点的回调
>
> `@node-click="handleNodeClick"`：设置节点点击的回调

# 参考文档

[2.12.0版本的官方文档](https://element.eleme.cn/2.12/#/zh-CN/component/installation)

