# 介绍

在非mac电脑上安装mac系统,就被称为黑苹果,黑苹果要解决很多硬件兼容带来的问题

# 黑苹果的历史

在2005年,苹果将系统架构转向了Intel的x86结构,才使得现在可以在普通电脑上安装mac成为可能

第一代版本采用了更换定制内核的方法,第二代是由某个黑客写了一个名为 chameleon的bootloader，国内大家称呼为“变色龙” ,这是第一个广泛性的引导器; 第三代出现了新的引导方法: Clover Bootloader,即四叶草; 它支持UEFI启动,相较于Chameleon功能更加强大,适配更加完美; 

# 评定黑苹果的稳定

一台完美的黑苹果主要包括以下几个方面: CPU,显卡,声卡,网卡,蓝牙,电源管理,USB,睡眠,散热;

1. CPU: 一般的CPU基本上都没有问题
2. 显卡: 一般只能使用集成显卡, 但是如果你是AMD的显卡,基本上可以驱动
3. 声卡: 是否正常
4. 网卡: 能够正常稳定的上网
5. 蓝牙: 能够驱动蓝牙
6. 电源管理: 远程CPU电源管理,变频等等
7. USB: 能够驱动USB
8. 睡眠: 一般在笔记本上需求较多,能够正常睡眠
9. 散热: 能够驱动风扇进行良好的散热

# 黑苹果原理

电脑系统的启动需要两个东西一起应用

1. 一个是Bootloader,就是启动器
2. 一个是兼容这个启动器的操作系统

启动器就是唤醒操作系统的一个小系统,它被烧录在主板ROM上,目前的通用启动器由BIOS和UEFI,苹果的引导方法是用自己定制的EFI搭配各种软件引导进入macOS的,但是EFI是UEFI的前身,UEFI在其基础上再做了修改,但是普通的UEFI还是无法引导macOS,因为不仅仅是不兼容,而且无法提供各类macOS启动需要的数据和验证

从黑苹果的历史可知,黑苹果的方法无非就两种:

1. 替换内核,非常的繁琐
2. 使用启动器

所以,我们现在的安装黑苹果的方式基本上都是使用第二种方式:使用启动器

大神开发出第三方的启动器,让UEFI先启动这个第三方的启动器,然后第三方的启动器在引导macOS,并且在启动过程中提供各类参数,数据和跳过验证等

目前最主流的是UEFI+Clover的方式:

- 使用UEFI+Clover方式引导macOS实际上是每次主板启动,都会引导硬盘EFI分区中的Clover,然后再由定制的Clover来引导macOS,Clover的功能非常强大,可以加载各种定制EFI文件
- 我们可以把Clover理解为一个安装在硬盘上的Bootloader

# 黑苹果安装大致流程

首先,我们需要利用macOS镜像制作一个macOS安装U盘,接着我们需要在U盘的EFI分区中安装Clover引导,这样我们在电脑中插入U盘时,UEFI就会引导U盘的EFI分区的Clover,我们再借助Clover进入macOS安装环境

其中最大的难点就在于如何配置Clover引导([Clover 配置详解](https://www.jianshu.com/p/b156b0177a24)),Clover配置选项繁多,功能定义不清晰,总之,只要我们能设置好Clover引导,我们就能顺利进入macOS安装界面,一步步安装macOS即可;

> 所以,如果我们能拿到你电脑配置对应的安装成功案例的Clover,那么你只要复制其Clover,那么你也可以快速的安装成功(只要配置类似,基本也能顺利安装);因此,你会在论坛上进场看到有人伸手要EFI(其中包含了Clover)

在安装完macOS后,我们需要把U盘的Clover文件放到硬盘的EFI分区中,之后我们直接让UEFI启动硬盘的EFI分区中的Clover,Clover在引导macOS启动,那么就无需U盘了;

在装完macOS系统后,会出现我们的部分硬件不能够很好的被macOS所驱动,如网卡,显卡,USB,蓝牙等等,这是我们就需要安装对应的驱动来使得我们的硬件工作;往往这一步才是非常的痛苦,也非常考验黑苹果的功底;

# Clover启动器

## Clover兼EFI的目录结构

![EFI](/Users/yingjie.lu/Documents/note/.img/EFI.png)

## Clover使用教程

[具体参考教程](https://www.i5seo.com/the-past-and-present-of-clover-and-the-tutorial-of-using-clover.html)

[clover详细参数配置详解](https://www.jianshu.com/p/b156b0177a24)

[Clover隐藏多余分区](https://blog.csdn.net/JoeBlackzqq/article/details/89892079)https://post.m.smzdm.com/p/a07mnz0w/)

# dell 7559 i7安装记录

## 参考文档

- https://www.tonymacx86.com/threads/guide-dell-inspiron-15-7559-el-capitan-hackintosh-dual-boot-with-windows.196138/ 

- https://github.com/fengwenhua/dell-7559-hackintosh 

  > 重要：这个链接中包含了可以完整使用的EFI文件，如果机型相同的话，可以直接覆盖使用，但是后续的安装会有一些小小的问题，后面会讲到

- https://blog.daliansky.net/macOS-Mojave-10.14.3-18D42-official-version-with-Clover-4859-original-image.html

## 安装

资源：

- [镜像下载](https://mirrors.dtops.cc/iso/MacOS/daliansky_macos/10.14/macOS%20Mojave%2010.14.3%2818D42%29%20Installer%20with%20Clover%204859.dmg)

  > 我使用的是10.14.3（18D109）版本的镜像
  >
  > 如果想安装更高版本的，可以访问该[网址](https://mirrors.dtops.cc/iso/MacOS/daliansky_macos)去下载

### 制作启动盘

TransMac: 制作mac安装盘

- 右键以管理员身份运行软件,找到自己对应的U盘,右键选择`Format Disk for Mac`,并进行重命名为`Mac OS`,点击OK,之后就会对U盘进行格式化
- 格式化完成后,还是在软件中找到对应的U盘,右键选择`Restore with Disk Image`,进行写入Mac OS镜像文件文件; 我们选择好下载的Mac OS镜像后,点击OK,那么软件就会开始往U盘中写入镜像文件,过程比较漫长,需要等待一会儿; 镜像写入完成之后,如果软件弹窗问你是否需要格式化该U盘,选择`否`即可

DiskGenius: 分区软件 

- 打开软件，进入到U盘中的EFI文件夹，将该[网址](https://github.com/fengwenhua/dell-7559-hackintosh)中的附件中的`最终的CLOVER`的内容替换掉EFI/CLOVER中的文件

  > 该操作是将已经设置好的引导文件配置到U盘中，之后我们就可以使用U盘进行引导安装和引导启动系统
  
- 将你要安装的硬盘进行格式化并分区为NTFS

  > 只有分区后的在安装Mac系统时才能够被识别

### 设置BIOS

```shell
 - 先恢复BIOS默认设置，保证我们的初始设置是一致的
 
 Advanced选项卡：
 - VT for Direct I/O									Disabled
 - SATA Operation 										AHCI
 - SupportAssist System Resolution		off
 - Advanced Battery Charge Mode				Disabled
 
 Security选项卡：
 - Firmware TPM												Disabled
 
 Boot选项卡：
 - Boot List Option 									UEFI
 - Secure Boot												Disabled
```

### 安装Mac OS

- 重启电脑,按F12进入BIOS设置,将电脑启动项设置为U盘启动

- 重启电脑后会进入到Clover模式,选择Mac OS系统,按一下空格,进行设置,将`Verbose(-v)`模式打开,这样在安装系统时会显示详细的安装系统,当你安装时卡住也可以手机拍照到论坛进行问题排查(如果超过15分钟不动,那么就需要进行拍照排查了)

- 进入到安装界面之后,首先选择`磁盘工具`,然后选择`显示所有设备`,选择我们需要安装Mac OS的对应的硬盘,点击`抹掉`,这时我们要给这个硬盘起一个名字,那么我取名为Mac OS,并且格式要选择`Mac OS 扩展 (日志式)`,如下图所示:

  ![1572359085742](/Users/yingjie.lu/Documents/note/.img/1572359085742.png)

  抹掉完成后,我们就可以把磁盘工具关掉,进入终端,我们需要修改该系统的日期,在终端中输入以下命令:

  ```cmd
  date 102723252015.06
  ```

  > 该命令是将该版本的时间进行调整，不然在安装时会出现该镜像已损坏的情况
  >
  > 注意：在安装的整个过程中最好全过程断网

  回车即可修改时间,修改完之后,退出终端,然后选择第二项:`安装Mac OS`,接下来一路next,之后我们需要选择我们刚才起好名字要安装系统的硬盘,然后点击安装,安装完之后会进入第一次重启

- 重启之后，按F12进入BIOS设置，再次设置为U盘启动，然后我们又进入到了Clover引导，这次我们选择我们要安装的硬盘（已经起过名字Mac OS的硬盘）进行启动，之后又回进入到漫长的安装等待（大概15分钟），安装成功后会进入第二次重启

  > 注意：在使用之前提供的链接中的Clover直接替换会出现一些奇怪的现象，导致你在按F12的时候不能进入系统的引导项，这时你需要重启按F2进入Boot设置，然后将Boot中的多余的引导项删除，如我的Boot中就会出现两个Mac OS引导项，从而导致我进入不了F12，所以删除掉之后就可以进入F12了，如果没有出现这种情况可以忽略，直接进入F12开始下一步即可

- 第二次重启后,会看到以下界面:

  ![1572359532395](/Users/yingjie.lu/Documents/note/.img/1572359532395.png)

  这时我们需要选择第二个,按一下空格,勾选`Verbose(-V)`选项,然后回退后回车进行安装,安装完成之后就会进入到苹果的系统设置界面

  > 在系统设置时先不要进行联网

  一路next,并创建好电脑账号

### 驱动安装及引导

1. 让计算机脱离U盘的引导启动

   进入到mac系统后,打开命令行终端,执行` diskutil list `命令,查看此时电脑中的所有硬盘分区情况,会显示下图类似的情况:

   ![image-20191101160159874](/Users/yingjie.lu/Documents/note/.img/image-20191101160159874.png)

   我们需要找到我们对应的硬盘,然后让硬盘中的EFI文件夹显示出来,这样我们就可以操作EFI文件夹,从而来修改引导

   我们找到我们的安装Mac的硬盘对应的`IDENTIFIER`,如`disk0`,找到我们U盘对应的`IDENTIFIER`,如`disk1`,接下来我们需要执行以下命令:

   ```shell
   sudo diskutil mountDisk disk0  # 将安装Mac硬盘中的EFI分区显示出来
   sudo diskutil mountDisk disk1  # 将USB的EFI分区显示出来
   # 打开Finder,就可以看到两个EFI分区
   ```

   然后将U盘中的`EFI/CLOVER`覆盖硬盘中的`EFI/CLOVER`

   重启电脑，按F2进入到Boot选项卡将你的引导项添加进入即可

   > 进入Boot选项卡，找到`File Brower Add Boot Option`回车，然后Mac OS安装的硬盘，找到`EFI/Boot/BootX64.efi`文件，按回车，然后输入名称`Mac OS`即可
   >
   > 在`Boot Option priorties`中将第一个选项设置为你刚添加的引导项即可（Mac OS）

   此时重启电脑就可以直接通过硬盘来引导,就可以拔掉U盘了

2. 安装系统对应的硬件驱动（该操作基本不需要，如果有些缺陷可使用该方式进行修复）

   启动Mac系统后,打开软件`Clover Configuration`软件,可以在该软件中对我们硬盘中的`EFI/CLOVER/config.plist`文件进行进一步的图形化编辑

   > 注意: 在打开软件后,我们是找到`EFI/CLOVER/config.plist`文件的,所以我们需要执行上一个步骤,即打开命令行终端,执行命令`diskutil list`用来查看并找到我们硬盘的分区,然后再执行`sudo diskutil mountDisk disk0`命令即可,此时`EFI/CLOVER/config.plist`文件就可以找到了

### 其他

Dell 7559的无限驱动是不能够使用的，但是连接网线是可以上网的，所以在还没有买到无线USB网卡的时候，可以先使用网线代替安装软件

无线USB驱动的购买：我购买的是CF-WU815N（Mac免驱）

### 以后的事

自己搭建台式迷你黑苹果硬件配置：

- 机箱: 酷鱼 MeralGear Plus
- 主板: 华硕 B450-I GAMING
- 内存: 海盗船复仇者 8G*2 2400
- 散热器: 猫头鹰L9A
- 显卡: Radeon RXVegall Graphics
- 电源: 酷鱼 DC 150W 电源适配器+模块

# HP ProBook 440 G5 i5-7200U 安装记录

可以直接使用的EFI兼教程：https://github.com/RichardAmare/HpProbook440G4-hackintosh

# 驱动记录

ACPIBatteryManager.kext 电池驱动

AppleALC.kext 声卡驱动

ApplePS2SmartTouchPad.kext 解决触摸板问题

CodecCommander.kext 解决睡眠唤醒后声卡无音补丁

CPUFriend.kext  调整 macOS CPU性能

CPUFriendDataProvider.kext 调整 macOS CPU性能

HibernationFixup.kext 睡眠驱动

Lilu.kext 黑苹果内核扩展补丁，很多驱动都依赖于他

网卡驱动：

- NullEthernet.kext
- RealtekRTL8100.kext
- RealtekRTL8111.kext
  网线的驱动

SATA-unsupported.kext SATA磁盘阵列驱动

VirtualSMC.kext 仿冒苹果SMC设备的驱动文件

VoodooI2C.kext i2c 触控板驱动

VoodooI2CHID.kext 触控版驱动

WhateverGreen.kext 修复黑苹果AMD/NVIDIA显卡黑屏、花屏、睡眠黑评估等各种问题显卡驱动补丁

















驱动安装参考：https://www.jianshu.com/p/81e329c50120

# 学习参考

## 教程参考

悦享教程:

- [图文教程](https://www.yuexiang.fun/1153.html)
- [配套的视频教程](https://www.bilibili.com/video/av58248756)

什么值得买:

- [一些帖子挺不错](https://post.m.smzdm.com/fenlei/bangongruanjian/brand-1687/)

mac镜像: 

- [下载地址](https://mirrors.dtops.cc/iso/MacOS/daliansky_macos/10.13/)(已经尝试)
-  或者下载macOS Mojave镜像: [【黑果小兵】macOS Mojave 10.14.3 18D42 正式版 with Clover 4859原版镜像](https://blog.daliansky.net/macOS-Mojave-10.14.3-18D42-official-version-with-Clover-4859-original-image.html) 

## 知识获取

- [tonymacx86.com](http://www.tonymacx86.com/)：这是国外的一个黑苹果论坛 ,  首推论坛 

  包含了采购指南:  适合没有配置的情况下想配一台黑苹果专用主机的人 

  包含了安装指南:

- [Github](http://www.github.com/)：Github也是一个非常好的黑果资源搜索器，首先大部分的Kexts开发者都把库放到了这里 

- [远景论坛](http://bbs.pcbeta.com/)：算是国内最大的黑苹果论坛 

- [B站](http://search.bilibili.com/all?keyword=黑苹果): 很多视频教程

- 诸多个人论坛:  国光、黑果小兵、nickwoodhams 等

# 参考文档

[**黑果小兵的部落阁**](https://blog.daliansky.net/) 

[**黑苹果社区**](https://osx.cx/tag/%E9%BB%91%E8%8B%B9%E6%9E%9C/)

[**GitHub-EFI及安装教程**](https://github.com/daliansky/Hackintosh)