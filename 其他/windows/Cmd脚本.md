[TOC]

# 常用命令

## help(帮助)

可以查看全部的CMD指令

## 目录操作

### 进入目录(cd)

- 进入指定目录

  `cd d:/`

- 进入并更改目录
  `cd /d d:/mp4`

- 返回上一级目录
  `cd ../`

- 返回更目录
  `cd /`

- 当前目录
  `cd ./`

### 建立目录(md)

`md demo`

### 复制目录(xcopy)

`xcopy demo1 demo2`

### 删除整个文件夹(deltree)

`deltree demo`

### 显示磁盘目录(dir)

`dir`

## 文件操作

### 复制文件(copy)

`copy 1.txt 2.txt`

### 删除文件(del)

`del 1.txt`

### 重命名文件(ren)

`ren .git .Git`

## 变量操作

### 设置变量

`set a=1`

### 使用变量

输出上面定义的变量a

`@echo %a%`

输出系统环境变量中的path路径

`@echo %path%`

# 其他命令

## 查看ip

`ipconfig`

## 清除当前行

按`esc`键

## 清除当前屏幕

`cls`

## 让cmd运行后不关闭窗口

`pause`



