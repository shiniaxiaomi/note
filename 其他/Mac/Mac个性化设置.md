1. 终端自动补全时忽略大小写

   `echo "set completion-ignore-case on" >> ~/.inputrc`

2. mac开启任意来源安装软件

   `sudo spctl --master-disable`





## 禁止Mac中的`.DS_Store`文件的生成

在命令行输入以下命令即可：

```shell
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
```



之后也可以使用以下命令恢复`.DS_Store`文件的继续生成

```shell
defaults delete com.apple.desktopservices DSDontWriteNetworkStores
```



删除电脑上已存在的`.DS_Store`文件

```shell
find ~ -name ".DS_Store" -delete
```

