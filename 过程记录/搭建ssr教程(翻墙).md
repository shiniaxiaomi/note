[TOC]

# 参考文档
http://www.dakamao8.com/1045.html

# 安装步骤
## 租赁国外的服务器
租赁地址
https://www.vultr.com/

## 安装ssr
登入xshell,输入命令 
`wget --no-check-certificate https://freed.ga/github/shadowsocksR.sh; bash shadowsocksR.sh`

> 如果报错,则执行yum install wget -y,在重复上面的命令

安装成功后保存截图
![在这里插入图片描述](../.img/.搭建ssr教程(翻墙)/2019080620544085.png)

## 安装锐速脚本
1. 更换内核
`wget -N --no-check-certificate https://freed.ga/kernel/ruisu.sh && bash ruisu.sh`
> 脚本安装需要1-3分钟，耐心等待服务器重启，服务器重启之后，重新连接继续安装就行了
2. 锐速安装脚本
`wget -N --no-check-certificate https://github.com/91yun/serverspeeder/raw/master/serverspeeder.sh && bash serverspeeder.sh`
> 如果不成功可以使用备用脚本
> `wget -N --no-check-certificate https://raw.githubusercontent.com/91yun/serverspeeder/master/serverspeeder-all.sh && bash serverspeeder-all.sh`

出现下图就算成功了
![在这里插入图片描述](../.img/.搭建ssr教程(翻墙)/20190806205726251.png)


# 连接Shadowsocks
![在这里插入图片描述](../.img/.搭建ssr教程(翻墙)/20190806210213250.png)

# 其他操作
## 查看80端口
`netstat -lnp|grep 80`
## 修改ssr服务信息
`vi /etc/shadowsocks.json`
## 重启ssr
`service shadowsocks restart`