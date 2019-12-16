

# Scratch file（草稿箱）

你可以创建草稿文件来记录公共的内容或者代码，但是该草稿文件不会属于特定的项目，它会被每个项目共享，但是文件并不存在与项目中

使用快捷键`shift+command+N`可以快速的创建草稿文件，你可以创建有类型的文件（支持语法高亮），普通的文本文件或者是可以保存数据库连接信息等等，它可以保存任何项目共享的内容

它会在idea中的project窗口中存在，你可以随时访问，像这样

![image-20191120103801218](/Users/yingjie.lu/Documents/note/.img/image-20191120103801218.png)

#  设置注释生成模版

1. 在创建类时生成的模版设置

   在配置项中搜索template关键字即可

   ![image-20191122110232677](/Users/yingjie.lu/Documents/note/.img/image-20191122110232677.png)

   修改Class，Interface，Enum，AnnotationType的选项卡

   将以下内容加入到模版中即可

   ```java
   /**
    *@ClassName ${NAME}
    *@Description 
    *@Author ${USER}
    *@Date ${DATE} ${TIME}
    *@Version 1.0
   */
   ```

2. 在方法上生成的模版设置

   - 生成类上的注解模版

     ![image-20191122110431224](/Users/yingjie.lu/Documents/note/.img/image-20191122110431224.png)

     将以下内容放入模版中

     ```java
     /** 
      * @ClassName $name$
      * @Author $user$
      * @Description $end$
      * @Date $date$ $time$
      * @Version 1.0
      **/
     ```

     点击右边的`Edit variables`,配置对应的变量即可

     ![image-20191122110529483](/Users/yingjie.lu/Documents/note/.img/image-20191122110529483.png)

   - 配置生成方法上的模版

     ![image-20191122110635328](/Users/yingjie.lu/Documents/note/.img/image-20191122110635328.png)

     将以下内容放入模版中

     ```java
     * 
      * @Author $user$
      * @Description $end$
      * @Date $date$ $time$
      * @Param $param$
      * @return $return$
      **/
     ```

     点击右边的`Edit variables`,配置对应的变量即可

     ![image-20191122110705555](/Users/yingjie.lu/Documents/note/.img/image-20191122110705555.png)

     > 其中的param是使用脚本生成的，脚本内容如下：
     >
     > ```js
     > groovyScript("def result=''; def params=\"${_1}\".replaceAll('[\\\\[|\\\\]|\\\\s]', '').split(',').toList();result+='['; for(i = 0; i < params.size(); i++) {result+= params[i]+ ((i < params.size() - 1) ? ':null,':':null')};result+=']'; return result", methodParameters()) 
     > ```

# 快捷键

## Mac快捷键

### 最常用的

- search everywhere: double shift

- go to file: shift +command + O
- recent files : command+E
- Navigation bar : command + 方向上键
- find in path（全局搜索） : shift + command +F
- replace in path （全局替换）：shift+command +R
- scratch file（创建草稿）：shift + command +N

### 效率

- class... (搜索class文件，也可以通过doube shift调出): command +O 
- file structure(文件结构)：command +F12
- type hierarchy(类型层级)：ctrl+H
- next method : ctrl+方向下
- previous method：ctrl+方向上

### code

- Override Methods：ctrl+O

- Implement Methods：ctrl+i 

- Generate...(生成代码)：command+N
- Comment with Line Comment（行注释）：command+/
- Comment with Block Comment（块注释）：option+command+/
- Optimize import（优化包导入）：ctrl+command+O
- Move Statement Down/Up（选中代码块上下移动）：shift+command+方向上/下
- 折叠代码
  - Expand：command+`+`
  - Collapse： command+`-`

### 运行调试

运行

- Build Project：command+F9

- Run：ctrl+R
- Debug: ctrl+D

调试

- Step Over（单步跳过）：F8
- Force Step Over（强制单步跳过）：option+command+F8
- Step Into（步入）：F7
- Smart Step Into（只能步入）：shift+F7
- Step Out（步出）：shift+F8
- Run to Cursor（运行到光标处）：option+F9
- Resume Program（恢复并继续执行程序）：option+commnd+R
- Evaluate Expression（计算表达式）：option+F8
- Quick Evaluate Expression（快速计算表达式）：option+command+F8
- show Execution Point（现实当前断点）：option+F10
- Toggle Line Breakpoint（添加或删除行断点）：command+F8

### 版本管理

- Commit：command+K
- Push：shift+command+K
- Update Project：Command+T

### 其他

- Preference（自定义设置）：command+`,`

## Windows快捷键

### 效率

查看当前文件结构(方法和参数) Ctrl+F12

查询当前元素的在其他地方的使用 Ctrl+F7

查找整个工程中使用地某一个类、方法或者变量的位置 Alt+F7

快速打开文件 Ctrl+Shift+N

查看当前方法的声名 Ctrl+P

自动引入变量 Ctrl+Alt+V

显示类结构图(继承层次) Ctrl+H

快速打开或隐藏工程面板 Alt+1

在方法间快速定位 Alt+上下方向键

快速定位高亮错误 F2

扩大范围选中 Ctrl+W

打开指定的类或方法/Ctrl+鼠标点击 Ctrl+B

从接口直接调转到实现类 Ctrl+Alt+B/鼠标点击

关闭打开的文件 Ctrl+F4

### 常用

格式化 Ctrl+Alt+L

生成构造器/get/set方法 Alt+insert

导包 Ctrl+Alt+O

自动代码(提示自定义的模板) Ctrl+J

返回上一次浏览的位置 Ctrl+Alt+左右方向键

向下插入新行 Shift+Enter

全局查找 Ctrl+Shift+F

定位行 Ctrl+G

当前方法开展和折叠 Ctrl+加号或减号

隐藏/恢复所有窗口 Ctrl+Shift+F12

查看类的说明文档 Ctrl+Q或者自定义的Ctrl+Shift+D

### 其他

最近的文件 Ctrl+E

重写方法 Ctrl+O

计算变量值(debug使用) Alt+F8

大小写转化  Ctrl+Shift+U

项目 Alt+1

收藏 Alt+2

TODO Alt+6

结构 Alt+7

复制路径 Ctrl+Shift+C

快速打开idea的option配置 Ctrl+Shift+A

### 调试部分,编译

停止 Ctrl+F12

选择调试 Alt+Shift+F9

选择运行 Alt+Shift+F10

编译 Ctrl+Shift+F9

运行 Ctrl+Shift+F10

查看断点 Ctrl+Shift+F8

步过 F8

步入 F7

智能步入 Shift+F8

步出 Shift+F8

运行至光标处 Alt+F9

恢复程序 F9

定位到断点 Alt+F10

生成项目 Ctrl+F9

### 重构

弹出重构菜单 Ctrl+Alt+Shift+T

重命名 Shift+F6

重命名所有引用的变量或方法 Shift+F6

# 插件

- Free MyBatis plugin

  轻松通过快捷键找到MyBatis中对应的Mapper和XML，CTRL+ALT+B

- JRebel for IntelliJ

  热部署插件

- Lombok

  自动生成get和set方法等

- Mybatis Generator Plus

  视图化操作界面，根据数据库表自动生成Mybatis代码，包括model，xml，mapper等

- CodeGlance

  在编辑代码最右侧，显示一块代码小地图 
  
- Mybatis Log Plugin

  mybatis日志插件，可以将打印的日志生成sql放到数据库中直接执行

- PackageJars

  打成jar包的插件



