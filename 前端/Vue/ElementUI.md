[TOC]

# 介绍

使用Vue开发的前端UI框架

# 安装

npm安装：

```js
npm i element-ui -S
```

直接引入js

```html
<!-- 引入样式 -->
<link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
<!-- 引入组件库 -->
<script src="https://unpkg.com/element-ui/lib/index.js"></script>
```

# 快速开始

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <!-- import CSS -->
  <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
</head>
<body>
  <div id="app">
    <el-button @click="visible = true">Button</el-button>
    <el-dialog :visible.sync="visible" title="Hello world">
      <p>Try Element</p>
    </el-dialog>
  </div>
</body>
  <!-- import Vue before Element -->
  <script src="https://unpkg.com/vue/dist/vue.js"></script>
  <!-- import JavaScript -->
  <script src="https://unpkg.com/element-ui/lib/index.js"></script>
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

对于不会css布局的同学来说，ElementUI提供的Layout布局非常的好用

我们可以通过基础的24分栏，方便简单的创建布局

通过 row 和 col 组件，并通过 col 组件的 `span` 属性我们就可以自由地组合布局。

## 基础布局

![image-20191120152351912](/Users/yingjie.lu/Documents/note/.img/image-20191120152351912.png)

```html
<el-row>
  <el-col :span="12"><div class="grid-content bg-purple"></div></el-col>
  <el-col :span="12"><div class="grid-content bg-purple-light"></div></el-col>
</el-row>
```

> 一个row中会被分为24份，我们可以通过`:span`来分配这24分栏的占比，如果总数超过24则会被挤到下一行

> 在被col分割后，生成的col内部也会存在一个基础的24分栏，我们可以在其内部再通过`:span`来进行24分栏比例分配

## 设置分栏间隔

通过 Row 组件 提供 `gutter` 属性来指定每一栏之间的间隔，默认间隔为 0。

例如：

![image-20191120152333198](/Users/yingjie.lu/Documents/note/.img/image-20191120152333198.png)

```html
<el-row :gutter="20">
  <el-col :span="8"><div class="grid-content bg-purple"></div></el-col>
  <el-col :span="8"><div class="grid-content bg-purple"></div></el-col>
  <el-col :span="8"><div class="grid-content bg-purple"></div></el-col>
</el-row>
```

> 通过`:gutter="20"`属性的设置，我们可以将三个col组件的间隔设置为20px

## 混合布局

这个布局是在基础布局的基础上建立的

![image-20191120152410336](/Users/yingjie.lu/Documents/note/.img/image-20191120152410336.png)

```html
<el-row :gutter="20">
  <el-col :span="8"><div class="grid-content bg-purple"></div></el-col>
  <el-col :span="8"><div class="grid-content bg-purple"></div></el-col>
  <el-col :span="4"><div class="grid-content bg-purple"></div></el-col>
  <el-col :span="4"><div class="grid-content bg-purple"></div></el-col>
</el-row>
<el-row :gutter="20">
  <el-col :span="4"><div class="grid-content bg-purple"></div></el-col>
  <el-col :span="16"><div class="grid-content bg-purple"></div></el-col>
  <el-col :span="4"><div class="grid-content bg-purple"></div></el-col>
</el-row>
```

## 分栏偏移

通过制定 col 组件的 `offset` 属性可以指定分栏偏移的栏数。

![image-20191120152517902](/Users/yingjie.lu/Documents/note/.img/image-20191120152517902.png)

```html
<el-row :gutter="20">
  <el-col :span="6"><div class="grid-content bg-purple"></div></el-col>
  <el-col :span="6" :offset="6"><div class="grid-content bg-purple"></div></el-col>
</el-row>
<el-row :gutter="20">
  <el-col :span="6" :offset="6"><div class="grid-content bg-purple"></div></el-col>
  <el-col :span="6" :offset="6"><div class="grid-content bg-purple"></div></el-col>
</el-row>
```

## 对齐方式

将 `type` 属性赋值为 'flex'，可以启用 flex 布局，并可通过 `justify` 属性来指定 start, center, end, space-between, space-around 其中的值来**定义子元素的排版方式**。

![image-20191120152631435](/Users/yingjie.lu/Documents/note/.img/image-20191120152631435.png)

```html
<el-row type="flex" class="row-bg" justify="space-around">
  <el-col :span="6"><div class="grid-content bg-purple"></div></el-col>
  <el-col :span="6"><div class="grid-content bg-purple-light"></div></el-col>
  <el-col :span="6"><div class="grid-content bg-purple"></div></el-col>
</el-row>
```

## 响应式布局

参照了 Bootstrap 的 响应式设计，预设了五个响应尺寸：`xs`、`sm`、`md`、`lg` 和 `xl`。

![image-20191120152756673](/Users/yingjie.lu/Documents/note/.img/image-20191120152756673.png)

```html
<el-row :gutter="10">
  <el-col :xs="8" :sm="6" :md="4" :lg="3" :xl="1"><div class="grid-content bg-purple"></div></el-col>
  <el-col :xs="4" :sm="6" :md="8" :lg="9" :xl="11"><div class="grid-content bg-purple-light"></div></el-col>
  <el-col :xs="4" :sm="6" :md="8" :lg="9" :xl="11"><div class="grid-content bg-purple"></div></el-col>
  <el-col :xs="8" :sm="6" :md="4" :lg="3" :xl="1"><div class="grid-content bg-purple-light"></div></el-col>
</el-row>
```

>xs : `<768px` 响应式栅格数或者栅格属性对象
>
>sm : `≥768px` 响应式栅格数或者栅格属性对象
>
>md : `≥992px` 响应式栅格数或者栅格属性对象
>
>lg : `≥1200px` 响应式栅格数或者栅格属性对象
>
>xl : `≥1920px` 响应式栅格数或者栅格属性对象

简单的响应式布局示例：

```html
<el-row :gutter="10">
    <el-col :xs="14" :sm="14" :md="6" :lg="5" :xl="4"></el-col>
    <el-col :xs="10" :sm="10" :md="18" :lg="19" :xl="20">
        <el-row :gutter="10">
            <el-col :xs="24" :sm="24" :md="6" :lg="4" :xl="3"></el-col>
        </el-row>
    </el-col>
</el-row>
```

# 按钮

按钮类型

```html
<el-button>默认按钮</el-button>
<el-button plain>朴素按钮</el-button>
<el-button round>圆角按钮</el-button>
<el-button type="text">文字按钮</el-button>
<el-button type="primary" icon="el-icon-search">图标按钮</el-button>
```

按钮大小

```html
<el-button round>默认按钮</el-button>
  <el-button size="medium" round>中等按钮</el-button>
  <el-button size="small" round>小型按钮</el-button>
  <el-button size="mini" round>超小按钮</el-button>
```

# 文字链接

颜色区别

```html
<el-link href="https://element.eleme.io" target="_blank">默认链接</el-link>
<el-link type="primary">主要链接</el-link>
<el-link type="success">成功链接</el-link>
  <el-link type="warning">警告链接</el-link>
  <el-link type="danger">危险链接</el-link>
  <el-link type="info">信息链接</el-link>
```

类型

```html
<el-link :underline="false">无下划线</el-link>
<el-link icon="el-icon-edit">编辑</el-link>
```

# Form表单

## 输入框

```html
<el-input v-model="input" placeholder="请输入内容"></el-input>
```

[更多参考](https://element.eleme.cn/#/zh-CN/component/input)

## 表单

```html
<el-form :label-position="labelPosition" label-width="80px" :model="form">
  <el-form-item label="名称">
    <el-input v-model="form.name"></el-input>
  </el-form-item>
</el-form>

data() {
      return {
        form: {
          name: '',
        }
      };
    }
```

[更多参考](https://element.eleme.cn/#/zh-CN/component/form)

# 表格

```html
<el-table
      :data="tableData"
      style="width: 100%">
      <el-table-column
        prop="date"
        label="日期"
        width="180">
      </el-table-column>
</el-table>

data() {
  return {
    tableData: [{
      date: '2016-05-02'
    },{
      date: '2016-05-03'
    }]
  }
}
```

# 消息提示

## 消息提示

![image-20191120162619146](/Users/yingjie.lu/Documents/note/.img/image-20191120162619146.png)

```js
this.$message('这是一条消息提示');
this.$message({
  message: '恭喜你，这是一条成功消息',
  type: 'success'
});
this.$message({
  message: '警告哦，这是一条警告消息',
  type: 'warning'
});
this.$message.error('错了哦，这是一条错误消息');
```

## 弹框提示

![image-20191120163012390](/Users/yingjie.lu/Documents/note/.img/image-20191120163012390.png)

```js
this.$confirm('此操作将永久删除该文件, 是否继续?', '提示', {
  confirmButtonText: '确定',
  cancelButtonText: '取消',
  type: 'warning'
}).then(() => {
  this.$message({
    type: 'success',
    message: '删除成功!'
  });
}).catch(() => {
  this.$message({
    type: 'info',
    message: '已取消删除'
  });          
});
```

## Dialog对话框

![image-20191120163204180](/Users/yingjie.lu/Documents/note/.img/image-20191120163204180.png)

```js
<el-dialog title="收货地址" :visible.sync="dialogFormVisible">
  <el-form :model="form">
    <el-form-item label="活动名称" :label-width="formLabelWidth">
      <el-input v-model="form.name" autocomplete="off"></el-input>
    </el-form-item>
  </el-form>
  <div slot="footer" class="dialog-footer">
    <el-button @click="dialogFormVisible = false">取 消</el-button>
    <el-button type="primary" @click="dialogFormVisible = false">确 定</el-button>
  </div>
</el-dialog>

data() {
  return {
    dialogFormVisible: true,
    form: {
      name: '',
    },
    formLabelWidth: '120px'
  };
}
```

## Popover弹出框

![image-20191120163558437](/Users/yingjie.lu/Documents/note/.img/image-20191120163558437.png)

```html
<el-popover
            placement="top-start"
            title="标题"
            width="200"
            trigger="hover"
            content="这是一段内容,这是一段内容,这是一段内容,这是一段内容。">
  <el-button slot="reference">hover 激活</el-button>
</el-popover>
```

# 参考文档

[官方文档](https://element.eleme.cn/#/zh-CN/component/installation)