[TOC]



打包命令jar的参数

- `-c`: 创建新的jar包
- `-f`: 指定jar的名称
- `-v`: 在控制台输出打包的过程

使用命令进行打包

- 进入当前要打包的目录下,打包所有class文件

  `jar -cvf demo.jar *.class`  

  > jar -cvf jar包名称 要打包的class文件

- 直接打包整个目录

  `jar -cvf demo.jar com`

  > jar -cvf jar包名称 要打包的目录 



# 参考文档

https://blog.csdn.net/u014252871/article/details/53434530