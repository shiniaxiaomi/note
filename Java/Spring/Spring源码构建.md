# 介绍

本文记录如何构建spring-framework的源码

# 步骤

1. 首先克隆spring-framework的源码

   `https://github.com/spring-projects/spring-framework.git`

   > 最好选择5.x.x的版本，尽量不要选择最新版本

2. 克隆完成后，进入到对应的目录，可以看到spring提供了如何将代码导入到idea的md文档，打开md文件，仔细阅读，按照spring指导文档的步骤进行

   - 进入到代码对应的根目录，然后执行该目录文件下的gradlew文件，执行命令如下：

     `./gradlew :spring-oxm:compileTestJava`

     构建成功后，可以看到如下图所示

     ![image-20191225154612388](/Users/yingjie.lu/Documents/note/.img/image-20191225154612388.png)

     > 注意：如果发现网络问题而导致不能下载所需要的文件，则可以看一下以下提示

     > 在执行上述命令时，会去下载gradle-5.6.4-bin.zip文件，下载的链接为`https://services.gradle.org/distributions/gradle-5.6.4-bin.zip`，如果网络被墙，则可以通过其他途径将该文件下载好，放置到项目的目录中，我放置的文件目录位置为：`/Users/yingjie.lu/Code/spring-framework-5.1.x/gradle/gradle-5.6.4-bin.zip`，然后修改`/Users/yingjie.lu/Code/spring-framework-5.1.x/gradle/wrapper/gradle-wrapper.properties`文件，将其中的`distributionUrl`属性的值修改为我们本地的`gradle-5.6.4-bin.zip`文件的所在路径即可，修改完成后的文件如图所示：
     >
     > ![image-20191225155114190](/Users/yingjie.lu/Documents/note/.img/image-20191225155114190.png)

3. 构建成功之后，打开idea的`import project`，选择对应的项目

   ![image-20191225155748339](/Users/yingjie.lu/Documents/note/.img/image-20191225155748339.png)

   然后选择以Gradle的方式打开

   ![image-20191225155838586](/Users/yingjie.lu/Documents/note/.img/image-20191225155838586.png)

   点击finished即可

4. 打开项目后，点击右侧菜单栏的Gradle选项，点击刷新按钮可以开始构建

   ![image-20191225160054598](/Users/yingjie.lu/Documents/note/.img/image-20191225160054598.png)

# 添加自己的代码

点击右键，New -> Module，然后新建自己的module即可，新建完成之后，gradle会自动重新在构建一次，不过这次构建会比较快

![image-20191225160525010](/Users/yingjie.lu/Documents/note/.img/image-20191225160525010.png)

构建成功之后，需要将spring-context的依赖导入到我们自己的项目中

```js
dependencies {
    compile(project(":spring-context"))
}
```

这样就可以使用spring的源码来进行调试运行了

# 加快Spring源码的编译

当我们调试自己的代码时，每次运行项目都需要重新编译spring的源码，而spring源码的编译比较耗时，所以我们需要去除掉一些不必要的步骤来加快编译的速度

找到项目根目录下的`build.gradle`文件，注释掉以下的一些代码即可，可以将编译保证在1分钟之内（不同性能电脑的时间各不相同）

```js
//	test {
//		useJUnitPlatform()
//		include(["**/*Tests.class", "**/*Test.class"])
//		systemProperty("java.awt.headless", "true")
//		systemProperty("testGroups", project.properties.get("testGroups"))
//		systemProperty("io.netty.leakDetection.level", "paranoid")
//	}


publishing {
  publications {
    mavenJava(MavenPublication) {
      //  artifact docsZip
      //  artifact schemaZip
      //  artifact distZip
    }
  }
}
```



# 其他

当你修改完项目后，需要重新编译时，则重新点击右侧菜单栏的Gradle选项，点击刷新即可重新编译项目