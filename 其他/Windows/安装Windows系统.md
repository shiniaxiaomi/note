# 介绍

记录一下Windows安装的过程

# 步骤

## 下载镜像

1. 去window官网下载window系统安装工具setup.exe

   [下载地址](https://www.microsoft.com/zh-cn/software-download/windows10ISO/)

   ![image-20191031160102047](/Users/yingjie.lu/Documents/note/.img/image-20191031160102047.png)

2. 下载完工具之后,双击运行安装工具,等待工具下载完镜像,然后选择保存镜像到桌面即可(即不要选择让工具帮你制作U盘启动工具)

## 使用UltraISO制作U盘启动

1. 下载UltraISO软件

2. 打开UltraISO软件,选择打开之前保存到桌面的window镜像文件

   ![image-20191031165413553](/Users/yingjie.lu/Documents/note/.img/image-20191031165413553.png)

   打开进行后镜像后,选择`启动`选项卡的写入`写入硬盘映像`

   ![image-20191031165413553](/Users/yingjie.lu/Documents/note/.img/image-20191031165413553.png)

   之后会弹出写入映像操作界面,确认一下要写入的硬盘(U盘),然后点击写入按钮即可

   ![image-20191031165413553](/Users/yingjie.lu/Documents/note/.img/image-20191031165413553.png)

## 安装window

1. 重启电脑,选择U盘启动





# 参考文档

无



在磁盘分区时，前面两个esp和msr是什么东西:

一. esp即EFI系统分区

1、全称EFI system partition，简写为ESP。[msr分区](https://www.baidu.com/s?wd=msr分区&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)本身没有做任何工作，是名副其实的保留分区。ESP虽然是一个FAT16或FAT32格式的物理分区，但是其分区标识是EF(十六进制) 而非常规的0E或0C。

因此，该分区在 Windows [操作系统](https://www.baidu.com/s?wd=操作系统&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)下一般是不可见的。支持EFI模式的电脑需要从ESP启动系统，EFI固件可从ESP加载EFI启动程序和应用程序。

2、ESP是一个独立于[操作系统](https://www.baidu.com/s?wd=操作系统&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)之外的分区，[操作系统](https://www.baidu.com/s?wd=操作系统&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)被引导之后，就不再依赖它。这使得ESP非常适合用来存储那些系统级的维护性的工具和数据，比如：引导管理程序、驱动程序、系统维护工具、系统备份等，甚至可以在ESP里安装一个特殊的操作系统。

3、ESP也可以看做是一个安全的隐藏的分区，可以把引导管理程序、系统维护工具、系统恢复工具及镜像等放到ESP，可以自己打造“一键恢复系统”。而且，不仅可以自己进行DIY，还要更方便、更通用。

二、[msr分区](https://www.baidu.com/s?wd=msr分区&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)是保留分区

1、windows不会向[msr分区](https://www.baidu.com/s?wd=msr分区&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)建立文件系统或者写数据，而是为了调整分区结构而保留的分区。在Win8以上系统更新时，会检测msr分区。msr分区本质上就是写在[分区表](https://www.baidu.com/s?wd=分区表&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)上面的“未分配空间”，目的是微软不想让别人乱动。

2、msr分区的用途是防止将一块GPT磁盘接到老系统中，被当作未格式化的空硬盘而继续操作（例如重新格式化）导致数据丢失。GPT磁盘上有了这个分区，当把它接入XP等老系统中，会提示无法识别的磁盘，也无法进一步操作。