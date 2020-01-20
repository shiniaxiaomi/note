# 安装步骤
## 租赁国外的服务器
租赁地址

- 国外

  https://www.vultr.com/

- 国内

  https://www.aliyun.com/（香港）

> 选择 Ubuntu 19.10 x64或更高 的系统版本

## 安装环境

根据需要去安装

1. 安装git

2. 安装python


在Ubuntu 中,git和python3已经是默认安装好的,我们可以不用安装

> 如果要安装,可以使用以下命令安装
>
> `apt install python`
>
> `apt install git`

## 安装

[访问github获取对应的脚本](https://github.com/cn2t/doubi-SSR)

> 使用第一个即可(或者可以按照需要选择对应的脚本)

或者直接复制下方链接,运行即可,也可直接安装

```shell
wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ssr.sh && chmod +x ssr.sh && bash ssr.sh
```

安装成功之后

![1572148180276](/Users/yingjie.lu/Documents/note/.img/1572148180276.png)

将ssr链接复制到软件上即可

# ssr软件下载

ShadowsocksX：https://www.emptyus.com/

ShadowsocksX-NG：https://github.com/shadowsocks/ShadowsocksX-NG

# 遇到的问题

如果在使用的过程中，不能科学上网了，但是你的ip有没有被封，那有可能就是你的服务器的端口被封了，所以我们需要重新换一个端口

# 遇到连接不稳定的问题

如果遇到连接不稳定，就是时不时能连上，但是经常会断连，或者连服务器都不能登入，但是可以ping通，这个就非常有可能是你接入的运营商的网络问题，所以，如果遇到上述问题，又很难解决掉，可以尝试切换网络来解决问题（注意需要切换为不同运营商）

> 我之前sim卡使用的移动的，就会出现这样的问题，然后换成电信卡之后就没有该问题了
>
> 这个不是说所有的移动都不行，可能会针对地区

# 参考文档

http://www.dakamao8.com/1045.html