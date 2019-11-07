[TOC]

# 配置环境变量

1. 在用户目录下创建.bash_profile文件

   `touch ~/.bash_profile`

2. 编辑.bash_profile文件

   `vim ~/.bash_profile`

3. 添加环境变量

   ```shell
   export vscode=/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin
   export PATH=$vscode:$PATH
   ```

4. 让该配置文件立即生效

   `source  ~/.bash_profile`

5. 退出终端重新打开即可使用code命令来打开vscode

[参考链接](https://www.jianshu.com/p/f63611e8e821)

# 终端使用

1. 终端清屏

   真实清屏：`Command+K`

   假清屏：`Ctrl+L`

2. 搜索历史命令：`Ctrl+R`

3. 在Finder中打开当前目录：`open .`

   