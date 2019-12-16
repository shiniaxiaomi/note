# 介绍

可以在mac上运行任何自定义的配置，非常的方便

# 工作流（workflows）

工作流可以将繁琐的内容使用一套工作流模版来实现，实现后只需一个命令，那么就可以完成一套完整并且繁琐的工作，这将大大的提高工作的效率

## 工作流中的变量

在工作流中定义变量后，就可以使用{var:变量名}来使用

![image-20191121134222387](/Users/yingjie.lu/Documents/note/.img/image-20191121134222387.png)

点击右上角的这个按钮，会出现以下界面：

![image-20191121134308933](/Users/yingjie.lu/Documents/note/.img/image-20191121134308933.png)

可以在这个界面的右边定义全局变量：

- 在bash中引用变量：`$domain`

- 在python中引用变量：

  只能通过bash来运行python文件，然后将变量从外部传入到python中，例如：

  ```shell
  python3 /Users/yingjie.lu/Tool/Alfred/searchNote.py $1 $domain
  ```

## 怎么将内容显示在Alfred列表中

有两种方式，一种是json格式，一种是xml格式

- json格式

  ```json
  {"items": [
      {
          "uid": "desktop",
          "type": "file",
          "title": "Desktop",
          "subtitle": "~/Desktop",
          "arg": "~/Desktop",
          "autocomplete": "Desktop",
          "icon": {
              "type": "fileicon",
              "path": "~/Desktop"
          }
      }
  ]}
  ```

  只要脚本输出的格式是这样的json格式，那么Alfred就会将其解析，并显示在列表中，例如：

  ![image-20191121135207785](/Users/yingjie.lu/Documents/note/.img/image-20191121135207785.png)

  这个是从网站上请求数据后解析生成在Alfred的搜索列表中的

  示例代码如下：

  ```python
  # -*- coding: utf-8 -*-
  import sys
  import requests
  from urllib.parse import unquote # 导入转码工具包
  
  query = sys.argv[1] #获取参数
  domain=sys.argv[2]
  query=unquote(query, 'utf-8') #编码格式转化
  
  url=domain+"/getJson/" +query
  
  response = requests.get(url)
  # print(response.text)
  
  sys.stdout.write(response.text)
  ```

  > 我这里请求到的response数据直接就是生成好的json对象，所以不用解析直接输出即可
  >
  > 返回数据如下：
  >
  > ```json
  > {
  > 	"items": [{
  > 		"uid": "JavaFX",
  > 		"type": "url",
  > 		"title": "JavaFX",
  > 		"subtitle": "/Java/其他/JavaFX.html",
  > 		"arg": "/Java/其他/JavaFX.html",
  > 		"autocomplete": "",
  > 		"icon": {
  > 			"type": "",
  > 			"path": ""
  > 		}
  > 	}, {
  > 		"uid": "Java基础",
  > 		"type": "url",
  > 		"title": "Java基础",
  > 		"subtitle": "/Java/基础/Java基础.html",
  > 		"arg": "/Java/基础/Java基础.html",
  > 		"autocomplete": "",
  > 		"icon": {
  > 			"type": "",
  > 			"path": ""
  > 		}
  > 	}]
  > }
  > ```

- xml格式

  不推荐使用

  XML的数据格式如下：

  ```xml
  <?xml version="1.0"?>
  <items>
    <item uid="desktop" arg="~/Desktop" valid="YES" autocomplete="Desktop" type="file">
      <title>Desktop</title>
      <subtitle>~/Desktop</subtitle>
      <icon type="fileicon">~/Desktop</icon>
    </item>
  </items>
  ```

  > 直接将上述xml内容直接返回给Alfred，也可以生成搜索列表，不过官方推荐使用json的方式









# 参考文档

[效率神器插件推荐](https://hufangyun.com/2018/alfred-workflow-recommend/)

[官方workflows文档](https://www.alfredapp.com/help/workflows/)