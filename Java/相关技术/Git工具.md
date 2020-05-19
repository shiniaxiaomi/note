# 介绍

Git是目前使用最多的分布式版本控制工具

# 安装

## linux

`sudo yum install git`

## windows

[下载安装程序](https://git-scm.com/downloads)

# 基本命令

## 克隆仓库

`git clone https://github.com/xxx/xxx.git`

> 可在后面添加名称指定克隆后生成的文件夹名称
>
> 例如：`git clone https://github.com/xxx/xxx.git note`

## 初始化本地仓库

`git init`

## 关联远程仓库

`git remote add  `

例如：`git remote add origin https://github.com/xxx/xxx.git`

> 在首次push时需要关联远程仓库
>
> `git push --set-upstream origin master`
>
> 可简化为`git push -u origin master`

## 删除关联的远程分支

`git remote remove `

示例：`git remote remove origin`

> 删除本地关联的名为origin的远程分支

## 查看本地仓库的状态

`git status`

## 将文件添加到暂存区

`git add .`

> 添加所有文件到暂存区

`git add 文件名`

> 添加指定文件到暂存区

## 将文件从暂存区中删除

`git restore --stage <文件名>`

例如：`git restore --stage .`

## 将暂存区的内容提交到本地仓库

`git commit -m '备注'`

## 回退提交

`git reset head^`

> 回退到上一次提交的版本

> head表示当前版本，上一次提交为head^，上上次提交为head^^，上100次提交为head~100

版本状态图如下所示：

![1565354190680](file:///Users/yingjie.lu/Documents/note/.img/1565354190680.png?lastModify=1576576006?lastModify=1576590920)

## 查看提交日志

`git log`

## 回退提交到任意版本

查看提交的所有记录

`git reflog`

```shell
$ git reflog
e93bc37 (HEAD -> master) HEAD@{0}: commit: ttt
150337e HEAD@{1}: commit: c
a709180 HEAD@{9}: commit: b
b1416c1 (origin/master) HEAD@{10}: commit (initial): init
```

直接输入`git reset 提交记录id`，如`150337e`即可回退到指定提交版本

## 将本地提交推送到远程

`git push`

> 推送到已经关联的远程分支中

`git push -u origin master`

> 将本地分支推送到远程的master分支中，如果远程没有master分支，则创建，并且创建关联关系，下次直接使用`git push`即可

# 分支操作

## 查看分支

- 查看本地分支

  `git branch`

- 查看远程分支

  `git branch -r`

- 查看所有分支

  `git branch -a`

## 创建本地分支

`git branch dev`

> 在本地了创建了一个dev分支

## 远程创建新分支

> 将本地分支推送并在远程创建分支，简单来说就是：`git push origin <分支名称>`

现在本地创建新分支(假设我目前在develop分支)

```shell
git branch -b release 
```

查看一下分支情况：`git branch -a`

```shell
$ git branch -a
  develop
  master
* release
  remotes/origin/HEAD -> origin/master
  remotes/origin/develop
  remotes/origin/master
```

> 当前指向本地的release分支

将本地的release分支推送到远程：

```shell
git push origin release
```

## 切换本地分支

`git checkout <分支名>`

例如：`git checkout dev`

## 推送到指定的远程分支

`git push origin `

示例：`git push origin dev`

## 拉取指定远程分支到本地

`git pull origin `

示例：`git pull origin dev`

## 拉取远程分支到本地，并在新建本地仓库

`git checkout -b <本地分支名> origin/<远程分支名>`

示例：`git checkout -b dev origin/dev`

## 删除本地分支

`git branch -d <本地分支名>`

示例：`git branch -d dev`

## 删除远程分支

`git push origin --d [分支名称]`

## 重命名本地分支名称

`git branch -m <旧分支名> <新分支名>`

## 重命名远程分支名称

先将本地分支重命名，然后推送到远程，然后将远程旧分支删除即可

## 合并本地分支

`git merge dev`

> 将dev分支合并到当前分支中

# 解决冲突

直接使用工具如idea，vscode等解决冲突即可

Git用`<<<<<<<`，`=======`，`>>>>>>>`标记出不同分支的内容

```js
Git tracks changes of files.
<<<<<<< HEAD
Creating a new branch is quick & simple.
=======
Creating a new branch is quick AND simple.
>>>>>>> feature1
```

> `<<<<<<< HEAD`和`=======`之间的内容为最新分支的内容
>
> `=======`和`>>>>>>> feature1`之间的内容为feature1分支的内容

解决完冲突后，需要将最终结果再次提交和推送到远程，具体如图所示：

![git-br-conflict-merged](file:///Users/yingjie.lu/Documents/note/.img/0-1565415846652.png?lastModify=1576576006?lastModify=1576590920)

# 分支管理策略

## 简单分支管理

首先，默认master分支应该是稳定的，也就是仅用来发布新版本

成员都应该有一个对应的开发分支，每个人都在自己的dev分支中开发着相应的功能，当开发完成时，在把自己的dev分支合并到master分支上

当分配给每个人的重要的任务都开发完成并且都合并到master上后，就可以发布一个master的升级版本，具体如图所示：

![git-br-policy](file:///Users/yingjie.lu/Documents/note/.img/0-1565425746153.png?lastModify=1576576006?lastModify=1576590920)

一般来说，发布前需要经过很多的测试，如果测试出bug，那么就可以从master分支中新建一个bug分支，用来修复对应的bug，修复完成后，在把bug分支合并回master分支，然后可以删除掉bug，在测试master分支，如果没有bug，则可以按照流程进行发布了。

## 复杂分支管理

在互联网公司,产品的更新迭代很快,所以对应的git分支也有多个

### 主分支

主分支有两个：dev分支和master分支

这两个分支的生命周期贯穿整个项目。自项目成立就存在了这两个分支。

master分支是稳定且可发布分支，而dev是开发分支。

- 对于dev分支来说

  每个人的开发任务是不一样的，那么每个人都应该有一个自己的dev分支来开发自己的任务。而每个人的dev分支都应该是从dev分支上创建出来的。

- 对于master分支来说

  当部分的功能都开发完了，并且各人的dev分支都合并到了主dev分支，那么就标志着这一版本的一个重大升级已经完成，然后就需要将合并完后的主dev分支进行测试，如果测试通过，则将主dev分支再合并到master上，需要保证master分支是稳定可使用的。

  > 如果简单一点，可以直接拿master分支的代码直接发布

具体如图所示：

![这里写图片描述](file:///Users/yingjie.lu/Documents/note/.img/20180624162549140.png?lastModify=1576590920)

### 其他分支

主要是hotfix分支

> 这个分支是上线后修复一些特别紧急或严重的bug，那么需要从master分支拉取，修复完后，将该分支合并回master分支和dev分支

如图所示：

![这里写图片描述](file:///Users/yingjie.lu/Documents/note/.img/20180624172850247.png?lastModify=1576590920)

## 分支管理总结

一般按照上述的分支管理即可应付多大多数场景，如果还需要再细分，可以参考以下图片：

![这里写图片描述](file:///Users/yingjie.lu/Documents/note/.img/20180624174835949.png?lastModify=1576590920)

# 标签管理

在发布新版本时，通常需要将当前版本打一个标签（tag），标签只是记录当前一瞬间的版本的状态，即快照

标签的原理其实就是一个指向某个commit的指针

为什么要引入标签？因为commit的id不好记忆，那么tag就可以将commit的id和一个容易记忆的名字联系在一起。

## 创建标签

`git tag <标签名> [-m <标签说明>]`

示例：

`git tag v1.0`

`git tag v1.0 -m '1.0版本发布'`

> 标签创建后只存在本地，需要显式的将标签推送到远程

## 查看标签

`git tag`

> 使用`git show <标签名>`可以查看对应的标签说明

## 删除本地标签

`git tag -d <标签名>`

## 将标签推送到远程

`git push origin <标签名>`

示例：`git push origin v1.0`

> 推送所有标签：`git push origin --tags`

# git相关配置

## 忽略指定文件

在git工作区的根目录下创建`.gitigonre`文件，git会自动忽略掉该文件中指定的内容

示例：

```properties
# 忽略以.iml结尾的文件
*.iml
# 忽略target文件夹
target
# 忽略java文件夹下的a.txt文件
java/a.txt
```

> `.gitigonre`文件也需要被git管控，所以需要提交到git仓库中

## 配置别名（alias）

### 配置当前项目下的别名

`git config alias.别名 命令`

示例：`git config alias.ci "commit"`

使用：`git ci`就相当于`git commit`

> 配置文件的路径为当前项目下的`.git/config`

### 配置全局别名

`git config --global alias.别名 命令`

> 配置文件的路径为`~/.gitconfig`

# 原理

## 本地仓库的结构

![1565355268609](file:///Users/yingjie.lu/Documents/note/.img/1565355268609.png?lastModify=1576576006?lastModify=1576590920)

## 管理修改

git跟踪并管理的是修改，而非文件

如果没有将工作区中的内容添加到暂存区，那么执行`git commit`之后，git只会将暂存区的内容提交到仓库

## 分支原理

git每次提交串成一条时间线,这条时间线就是一个分支

在master分支中，`master`指向最新的`commit`，`head`指向`master`，如图所示：

![1565409404088](file:///Users/yingjie.lu/Documents/note/.img/1565409404088.png?lastModify=1576576006?lastModify=1576590920)

每次提交，master分支会在右端串连上最新的提交，并且master指针会向右移动一格，执行最新的提交

当我们创建了新分支dev，git就会创建一个dev指针也指向最新的提交，而head指针就指向了dev指针，如图所示：

![1565409527909](file:///Users/yingjie.lu/Documents/note/.img/1565409527909.png?lastModify=1576576006?lastModify=1576590920)

所以，git创建分支很快，因为只需要增加一个dev指针和修改head指针的指向即可

在dev分支中进行了一次commit提交，那么最新的提交会继续添加到时间线的最右端，然后dev指针指向最新提交（即dev指针向右移动一格），而master指针不变，如图所示：

![git-br-dev-fd](file:///Users/yingjie.lu/Documents/note/.img/0-1565409653004.png?lastModify=1576576006?lastModify=1576590920)

假如dev分支的工作完成了，就可以把dev分支合并回master分支。因为没有冲突，所以git就直接把master分支指向dev指向的当前提交，那么就完成了合并，如图所示：

![git-br-ff-merge](file:///Users/yingjie.lu/Documents/note/.img/0-1565409749594.png?lastModify=1576576006?lastModify=1576590920)

合并完分支后，我们可以选择删除掉dev分支，即删除掉dev指针即可，那么就会只剩下master分支，如图所示：

![git-br-rm](file:///Users/yingjie.lu/Documents/note/.img/0-1565409790707.png?lastModify=1576576006?lastModify=1576590920)

# 问题汇总

## 解决gitbash的中文乱码

编辑`C:\Program Files\Git\etc\gitconfig`文件，在文件末尾增加以下内容：

```properties
[gui]  
    encoding = utf-8  #代码库统一使用utf-8  
[i18n]  
    commitencoding = utf-8  #log编码  
[svn]  
    pathnameencoding = utf-8  #支持中文路径 
```

编辑`C:\Program Files\Git\etc\git-completion.bash`文件，在文件末尾增加以下内容：

```properties
alias ls='ls --show-control-chars --color=auto'  #ls能够正常显示中文 
```

编辑`C:\Program Files\Git\etc\inputrc`文件，修改output-meta和convert-meta属性值：

```properties
set output-meta on  #bash可以正常输入中文  
set convert-meta off  
```

编辑`C:\Program Files\Git\etc\profile`文件，在文件末尾添加如下内容：

```properties
export LESSHARESET=utf-8  
```

## 解决git账号更改导致不能push和pull

当出现以下报错时，则说明当前项目或系统中git的用户名有冲突：

```properties
remote: HTTP Basic: Access denied
fatal: Authentication failed for 'http://******/java/gh-assemble.Git/'
```

解决办法：

执行命令`git config –-system –-unset credential.helper`,再重新输入账号和密码即可

> 如果解决还解决不了,则执行`git config –-global http.emptyAuth true`
>
> 若出现`error: key does not contain a section: –-system`报错,则使用将cmd使用管理员身份运行,再执行命令即可

## 记住用户名和密码

`git config --global credential.helper store`

# 参考文档

[廖雪峰的git教程](https://www.liaoxuefeng.com/wiki/896043488029600)