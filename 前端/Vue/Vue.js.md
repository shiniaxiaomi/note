# 介绍

Vue是一个用于构建用户界面的渐进式框架，使用Vue时，你只需要关心数据，当你修改数据时，Vue会帮你渲染好视图，非常的方便

# 安装

在html中引入vue.js即可快速的使用

在开发环境时可以引入：

```html
<!-- 开发环境版本，包含了有帮助的命令行警告 -->
<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
```

在生产环境时可以引入：

```html
<!-- 生产环境版本，优化了尺寸和速度 -->
<script src="https://cdn.jsdelivr.net/npm/vue"></script>
```

# 快速入门

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>

    <!-- 开发环境版本，包含了有帮助的命令行警告 -->
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
</head>
<body>

    <div id="app">
        {{ message }}
    </div>
    
</body>

<script>
var app = new Vue({
  el: '#app',
  data: {
    message: 'Hello Vue!'
  }
})
</script>

</html>
```

## 文本内容替换

可以直接在html中使用`{{ message }}`来直接替换

## 绑定属性

```html
<span v-bind:title="message">
  鼠标悬停几秒钟查看此处动态绑定的提示信息！
</span>	
```

使用`v-bind:title="message"`即可动态的绑定数据，而message则存在在data中

你可以省略前缀`v-bind`，直接使用`:title="message"`

## 条件判断

可以使用`v-if="seen"`来控制一个元素是否加载（狭义的显示）

```js
<div id="app-3">
  <p v-if="seen">现在你看到我了</p>
</div>

var app3 = new Vue({
  el: '#app-3',
  data: {
    seen: true
  }
})
```

## 循环

使用`v-for`来循环显示元素

```js
<div id="app-4">
  <ol>
    <li v-for="todo in todos">
      {{ todo.text }}
    </li>
  </ol>
</div>

var app4 = new Vue({
  el: '#app-4',
  data: {
    todos: [
      { text: '学习 JavaScript' },
      { text: '学习 Vue' },
      { text: '整个牛项目' }
    ]
  }
})
```

## 处理用户输入实现双向绑定

使用`v-model`可以实现表单输入和应用状态之间的双向绑定

```js
<div id="app-6">
  <p>{{ message }}</p>
  <input v-model="message">
</div>

var app6 = new Vue({
  el: '#app-6',
  data: {
    message: 'Hello Vue!'
  }
})
```

## 构建组建

在Vue中，一个组件本质上时一个拥有预定于选项的一个Vue实例；



注册一个全局组件（todo-item）：

```js
// 定义名为 todo-item 的新组件
Vue.component('todo-item', {
  template: '<li>这是个待办项</li>'
})

var app = new Vue(...)
```

使用注册的组件：

```html
<ol>
  <!-- 创建一个 todo-item 组件的实例 -->
  <todo-item></todo-item>
</ol>
```



注册一个复杂的组件：

组件可以接受一个`prop`属性

```js
Vue.component('todo-item', {
  // todo-item 组件现在接受一个
  // "prop"，类似于一个自定义特性。
  // 这个 prop 名为 todo。
  props: ['todo'],
  template: '<li>{{ todo.text }}</li>'
})

var app7 = new Vue({
  el: '#app-7',
  data: {
    groceryList: [
      { id: 0, text: '蔬菜' },
      { id: 1, text: '奶酪' },
      { id: 2, text: '随便其它什么人吃的东西' }
    ]
  }
})
```

现在我们可以使用`v-bind`指令将代办事项传到循环输出的每个组件中：

```html
<div id="app-7">
  <ol>
    <!--
      现在我们为每个 todo-item 提供 todo 对象
      todo 对象是变量，即其内容可以是动态的。
      我们也需要为每个组件提供一个“key”，稍后再
      作详细解释。
    -->
    <todo-item
      v-for="item in groceryList"
      v-bind:todo="item"
      v-bind:key="item.id"
    ></todo-item>
  </ol>
</div>
```

# Vue实例

通过`new Vue()`来创建Vue实例

```js
var vm = new Vue({
  // 选项
	el: '#app',
  data: {
    newTodoText: '',
  },
	//钩子
	created: function () {
    // `this` 指向 vm 实例
    console.log('a is: ' + this.a)
  },
	// 在 `methods` 对象中定义方法
  methods: {
    greet: function (event) {
      // `this` 在方法里指向当前 Vue 实例
      alert('Hello ' + this.name + '!')
    }
  },
	//计算属性
	computed: {
    // 计算属性的 getter
    reversedMessage: function () {
      // `this` 指向 vm 实例
      return this.message.split('').reverse().join('')
    }
  },
	//监听器
  watch: {
      // 如果 `question` 发生改变，这个question函数就会运行
      question: function (newQuestion, oldQuestion) {
          this.answer=newQuestion;
      }
    }
})
```

# Vue的生命周期

![lifecycle](/Users/yingjie.lu/Documents/note/.img/lifecycle.png)

1. new Vue()

2. 初始化（事件&生命周期）

   **钩子：beforeCreate**

3. 初始化（注入&校验）

   **钩子：created**

4. 进行模版解析

   **钩子：beforeMount**

5. 挂载dom元素

   **钩子：mounted**

6. 挂载完毕后开始数据data监听

   如果数据改变，则重新渲染更新

   **钩子：beforeUpdate**

   **钩子：updated**

7. 当调用vm.$destroy()函数时

   **钩子：beforeDestory**

8. 解除绑定（销毁子组件及事件监听器）

9. 销毁完毕

   **钩子：destroyed**

# 模版语法

## 插值

### 文本

```html
<span>Message: {{ msg }}</span>
```

### 原始html

将双大括号内的数据解释为html,只需要标记`v-html`即可

```html
<p>Using v-html directive: <span v-html="rawHtml"></span></p>
```

> rawHtml为：
>
> ```js
> data:{
> 	rawHtml:'<span style="color:red">this should be red.</span>'
> }
> ```
>

### 特性

当不能作用在html标签上时，可以使用`v-bind`指令来解决

```html
<div v-bind:id="dynamicId"></div>
```

如果`dynamicId`在data中改变了，那么div中的id属性也会动态的改变

```html
<button v-bind:disabled="isButtonDisabled">Button</button>
```

如果 `isButtonDisabled` 的值是 `null`、`undefined` 或 `false`，则 `disabled` 特性甚至不会被包含在渲染出来的 `` 元素中。

### 使用js表达式

vue支持在双大括号中计算js表达式：

支持一下几种：

```js
{{ number + 1 }}

{{ ok ? 'YES' : 'NO' }}

{{ message.split('').reverse().join('') }}

<div v-bind:id="'list-' + id"></div>
```

## 指令

指令是带有`v-`前缀的特殊属性，指令需要的值是单个js表达式（`v-for`指令除外）

指令的职责是当表达式的值改变时，会动态的作用到dom中

如：

```html
<p v-if="seen">现在你看到我了</p>
```

> 这里可以根据表达式 `seen` 的值的真假来插入/移除`<p>`元素。

### 参数

一些指令能够接受一个参数，来更新html特性的属性，如：

```html
<a v-bind:href="url">...</a>
```

> 这里href是参数，告知v-bind指令将该元素的href特性与表达式url的值绑定



`v-on`指令可以监听dom事件：

```html
<a v-on:click="doSomething">...</a>
```

> 监听a标签的额点击事件

### 修饰符

修饰符`.`指明特殊后缀，用于之处一个指令应该以特殊方式绑定，例如`.preven`修饰符告诉`v-on`指令对于触发的事件调用`event.preventDefault()`方法

```html
<form v-on:submit.prevent="onSubmit">...</form>
```

## 缩写

- v-bind缩写

  ```html
  <!-- 完整语法 -->
  <a v-bind:href="url">...</a>
  
  <!-- 缩写 -->
  <a :href="url">...</a>
  ```

- v-on缩写

  ```html
  <!-- 完整语法 -->
  <a v-on:click="doSomething">...</a>
  
  <!-- 缩写 -->
  <a @click="doSomething">...</a>
  ```

# 计算属性

如果在模版内部放太多的逻辑会让模版过重且难以维护，所以我们可以使用计算属性来解决，例如：

```js
<div id="example">
  <p>Original message: "{{ message }}"</p>
  <p>Computed reversed message: "{{ reversedMessage }}"</p>
</div>

var vm = new Vue({
  el: '#example',
  data: {
    message: 'Hello'
  },
  computed: {
    // 计算属性的reversedMessage值可以直接在模版中引用
    reversedMessage: function () {
      // `this` 指向 vm 实例
      return this.message.split('').reverse().join('')
    }
  }
})
```

计算属性中，如果data中的属性值改变，并且计算属性中使用到了，那么会触发计算属性重新计算，计算后会缓存计算结果，每次渲染模版时不会重新计算，而使用缓存值，这将大大提高性能

> 在模版中直接使用js表达式，则每次重新渲染模版时都会进行重新的计算，而不会没有缓存值

# 监听器

我们可以使用`watch`选项来提供一个更通用的方法来响应数据的变化，当需要在数据变化时执行一步或开销较大的操作时，这个方式是最有用的

例如：

```js
<div id="watch-example">
  <p>
    Ask a yes/no question:
    <input v-model="question">
  </p>
  <p>{{ answer }}</p>
</div>

var watchExampleVM = new Vue({
  el: '#watch-example',
  data: {
    question: '',
    answer: 'I cannot give you an answer until you ask a question!'
  },
  watch: {
    // 如果 `question` 发生改变，这个question函数就会运行
    question: function (newQuestion, oldQuestion) {
      	this.answer=newQuestion;
    }
  }
})
```

# Class与Style绑定

## 绑定HTML Class

### 对象语法

我们可以使用`v-bind:class`来更方便的动态切换class

例如：

```html
<div v-bind:class="{ active: isActive }"></div>
```

> 上面的语法表示 `active` 这个 class 存在与否将取决于数据属性 `isActive` 的值为true或false

我们可以传入更多的属性来动态切换多个class

```js
<div
  class="static"
  v-bind:class="{ active: isActive, 'text-danger': hasError }"
></div>

data: {
  isActive: true,
  hasError: false
}
```

结果渲染为：

```html
<div class="static active"></div>
```

> 当 `isActive` 或者 `hasError` 变化时，class 列表将相应地更新

绑定的数据对象不必内联定义在模板里，例如：

```js
<div v-bind:class="classObject"></div>

data: {
  classObject: {
    active: true,
    'text-danger': false
  }
}
```

### 数组语法

我们可以把一个数组传给`v-bind:class`,以应用一个 class 列表,例如：

```js
<div v-bind:class="[activeClass, errorClass]"></div>

data: {
  activeClass: 'active',
  errorClass: 'text-danger'
}
```

我们也可以使用三元表达式来切换class

```html
<div v-bind:class="[isActive ? activeClass : '', errorClass]"></div>
```

## 绑定内联样式

### 对象语法

`v-bind:style`可以方便的修改标签的style属性

```js
<div v-bind:style="{ color: activeColor, fontSize: fontSize + 'px' }"></div>

data: {
  activeColor: 'red',
  fontSize: 30
}
```

或者直接绑定到一个样式对象上，这会让模版更清晰

```js
<div v-bind:style="styleObject"></div>

data: {
  styleObject: {
    color: 'red',
    fontSize: '13px'
  }
}
```

### 数组语法

`v-bind:style`通过数组语法可以将多个样式对象应用到同一个元素上

```html
<div v-bind:style="[baseStyles, overridingStyles]"></div>
```

# 条件渲染

## v-if

简单使用：

```html
<h1 v-if="awesome">Vue is awesome!</h1>
```

在`<template>`元素上使用：

```html
<template v-if="ok">
  <h1>Title</h1>
  <p>Paragraph 1</p>
</template>
```

配合v-else使用：

```html
<h1 v-if="awesome">Vue is awesome!</h1>
<h1 v-else>Oh no 😢</h1>
```

v-else-if使用：

```html
<div v-if="type === 'A'">A</div>
<div v-else-if="type === 'B'">B</div>
<div v-else-if="type === 'C'">C</div>
<div v-else>Not A/B/C</div>
```



使用key管理可复用的元素

Vue 会尽可能高效地渲染元素，通常会复用已有元素而不是从头开始渲染

```html
<template v-if="loginType === 'username'">
  <label>Username</label>
  <input placeholder="Enter your username" key="username-input">
</template>
<template v-else>
  <label>Email</label>
  <input placeholder="Enter your email address" key="email-input">
</template>
```

> 当你来回的切换v-if和v-else的元素时，因为你使用了key来缓存，那么vue不会反复的创建使用key来标识的标签对象，而是重复利用

## v-show

`v-show`的用法和`v-if`相像，带有 `v-show` 的元素始终会被渲染并保留在 DOM 中。`v-show` 只是简单地切换元素的 CSS 属性 `display`。

```html
<h1 v-show="awesome">Vue is awesome!</h1>
```

## v-for

### 简单循环渲染（数组）：

```js
<ul>
  <li v-for="item in items">
    {{ item.message }}
  </li>
</ul>

data: {
    items: [
      { message: 'Foo' },
      { message: 'Bar' }
    ]
  }
```

### 循环渲染（对象）：

```js
<ul>
  <li v-for="(value,index) in object">
    {{ index }}.{{ value }}
  </li>
</ul>

data: {
    object: {
      title: 'How to do lists in Vue',
      author: 'Jane Doe',
      publishedAt: '2016-04-10'
    }
  }
```

> 渲染结果：
>
> - 0.How to do lists in Vue
> - 1.Jane Doe
> - 2.2016-04-10

### 数组更新检测

Vue将以下数组方法来更新数据：

- `push()`
- `pop()`
- `shift()`
- `unshift()`
- `splice()`
- `sort()`
- `reverse()`

# 事件处理

## 简单事件处理

可以用 `v-on` 指令监听 DOM 事件，并在触发时运行一些 JavaScript 代码。

例如：

```js
<button v-on:click="counter += 1">Add</button>

data: {
    counter: 0
  }
```

## 指定事件处理方法

```js
<button v-on:click="greet">Greet</button>

var example2 = new Vue({
  el: '#example-2',
  // 在 `methods` 对象中定义方法
  methods: {
    greet: function (event) {
      // `this` 在方法里指向当前 Vue 实例
      alert('Hello ' + this.name + '!')
      // `event` 是原生 DOM 事件
      if (event) {
        alert(event.target.tagName)
      }
    }
  }
})

// 也可以用 JavaScript 直接调用方法
example2.greet() // => 'Hello Vue.js!'
```

## 事件方法传递参数

```js
<div id="example-3">
  <button v-on:click="say('hi')">Say hi</button>
  <button v-on:click="say('what')">Say what</button>
</div>

new Vue({
  el: '#example-3',
  methods: {
    say: function (message) {
      alert(message)
    }
  }
})
```

## 事件修饰符

在事件处理程序中调用 `event.preventDefault()` 或 `event.stopPropagation()` 是非常常见的需求

在Vue中可以使用`v-on`的事件修饰符来方便快速的完成：

- `.stop`
- `.prevent`
- `.capture`
- `.self`
- `.once`
- `.passive`

```html
<!-- 阻止单击事件继续传播 -->
<a v-on:click.stop="doThis"></a>

<!-- 提交事件不再重载页面 -->
<form v-on:submit.prevent="onSubmit"></form>

<!-- 修饰符可以串联 -->
<a v-on:click.stop.prevent="doThat"></a>

<!-- 只有修饰符 -->
<form v-on:submit.prevent></form>

<!-- 添加事件监听器时使用事件捕获模式 -->
<!-- 即内部元素触发的事件先在此处理，然后才交由内部元素进行处理 -->
<div v-on:click.capture="doThis">...</div>

<!-- 只当在 event.target 是当前元素自身时触发处理函数 -->
<!-- 即事件不是从内部元素触发的 -->
<div v-on:click.self="doThat">...</div>
```

## 按键修饰符

Vue 允许为 `v-on` 在监听键盘事件时添加按键修饰符，例如：

```html
<!-- 只有在 `key` 是 `Enter` 时调用 `vm.submit()` -->
<input v-on:keyup.enter="submit">
```



按键码的别名：

- `.enter`
- `.tab`
- `.delete` (捕获“删除”和“退格”键)
- `.esc`
- `.space`
- `.up`
- `.down`
- `.left`
- `.right`

我们可以使用按键码别名或者是使用keyCodes



我们还可以通过全局`config.keyCodes` 对象自定义按键修饰符别名：

```js
// 可以使用 `v-on:keyup.f1`
Vue.config.keyCodes.f1 = 112
```

## 系统修饰键

### ctrl,alt,shift,command键

可以用如下修饰符来实现仅在按下相应按键时才触发鼠标或键盘事件的监听器。

- `.ctrl`
- `.alt`
- `.shift`
- `.meta`

> 注意：在 Mac 系统键盘上，meta 对应 command 键 (⌘)。在 Windows 系统键盘 meta 对应 Windows 徽标键 (⊞)。

例如：

```html
<!-- Alt + C -->
<input @keyup.alt.67="clear">

<!-- Ctrl + Click -->
<div @click.ctrl="doSomething">Do something</div>
```

> 请注意修饰键与常规按键不同，在和 `keyup` 事件一起用时，事件触发时修饰键必须处于按下状态。换句话说，只有在按住 `ctrl` 的情况下释放其它按键，才能触发 `keyup.ctrl`。而单单释放 `ctrl` 也不会触发事件。如果你想要这样的行为，请为 `ctrl` 换用 `keyCode`：`keyup.17`。

### .exact 修饰符

`.exact` 修饰符允许你控制由精确的系统修饰符组合触发的事件。

示例：

```html
<!-- 即使 Alt 或 Shift 被一同按下时也会触发 -->
<button @click.ctrl="onClick">A</button>

<!-- 有且只有 Ctrl 被按下的时候才触发 -->
<button @click.ctrl.exact="onCtrlClick">A</button>

<!-- 没有任何系统修饰符被按下的时候才触发 -->
<button @click.exact="onClick">A</button>
```

### 鼠标修饰符

- `.left`
- `.right`
- `.middle`

# 表单输入绑定

使用`v-model`指令可以在`<input>,<textarea>,<select>`元素中创建双向数据绑定，它会根据控件类型自动选取正确的方法来更新元素



`v-model` 在内部为不同的输入元素使用不同的属性并抛出不同的事件：

- text 和 textarea 元素使用 `value` 属性和 `input` 事件；
- checkbox 和 radio 使用 `checked` 属性和 `change` 事件；
- select 字段将 `value` 作为 prop 并将 `change` 作为事件。



## 文本

```html
<input v-model="message" placeholder="edit me">
<p>Message is: {{ message }}</p>
```

## 多行文本

```html
<p style="white-space: pre-line;">{{ message }}</p>
<br>
<textarea v-model="message" placeholder="add multiple lines"></textarea>
```

## 复选框

```html
<input type="checkbox" id="checkbox" v-model="checked">
<label for="checkbox">{{ checked }}</label>
```

## 单选按钮

```html
<div id="example-4">
  <input type="radio" id="one" value="One" v-model="picked">
  <label for="one">One</label>
  <br>
  <input type="radio" id="two" value="Two" v-model="picked">
  <label for="two">Two</label>
  <br>
  <span>Picked: {{ picked }}</span>
</div>

new Vue({
  el: '#example-4',
  data: {
    picked: ''
  }
})
```

## 选择框

```html
<div id="example-5">
  <select v-model="selected">
    <option disabled value="">请选择</option>
    <option>A</option>
    <option>B</option>
    <option>C</option>
  </select>
  <span>Selected: {{ selected }}</span>
</div>

new Vue({
  el: '#example-6',
  data: {
    selected: []
  }
})
```

## 修饰符

### .lazy

### .number

### .trim

自动过滤用户输入的首尾空白字符

```html
<input v-model.trim="msg">
```

# 组件基础

https://cn.vuejs.org/v2/guide/components.html

# 经验总结

## 解决vue在刷新页面时内容闪动的问题

在vue容器的div里面加上 v-cloak

```html
<div id="app" v-cloak>
  //...
</div>
```

在加入以下样式

```css
<style type="text/css">
  [v-cloak] {
    display: none !important;
  }
</style>
```

## 指定不解析某个html标签中的内容

只要在html标签中添加`v-pre`即可

```html
<div id="blog" class="markdown-body" v-pre>
  ${blog!}
</div>
```

# 参考文档

[官方文档](https://cn.vuejs.org/v2/guide/)