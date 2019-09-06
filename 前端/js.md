对象转json

```js
var str = JSON.stringify(params);
```

json转对象

```js
var data = JSON.parse(httpRequest.responseText);
```

js发送get请求

```js
//发送get请求
function ajaxGetUtil(url,handleFunction){
	var httpRequest = new XMLHttpRequest();//第一步：建立所需的对象
	httpRequest.open('GET', url, true);//第二步：打开连接  将请求参数写在url中  ps:"./Ptest.php?name=test&nameone=testone"
	httpRequest.send();//第三步：发送请求  将请求参数写在URL中

	httpRequest.onreadystatechange = function () {
		if (httpRequest.readyState == 4 && httpRequest.status == 200) {
			handleFunction(JSON.stringify(httpRequest.responseText));//获取到json字符串，还需解析
		}
	};
}
```

js发送post请求

```js
//发送get请求
function ajaxPostUtil(url,dataObj,handleFunction){
	var httpRequest = new XMLHttpRequest();//第一步：创建需要的对象
	httpRequest.open('post', url); //第二步：打开连接/***发送json格式文件必须设置请求头 ；如下 - */
    httpRequest.setRequestHeader("Content-type","application/x-www-form-urlencoded");//设置普通类型数据,如(a=1&b=2)
	httpRequest.setRequestHeader("Content-type","application/json");//设置json类型数据,如({a:1,b:2})
	httpRequest.send(JSON.stringify(dataObj));//发送请求 将json写入send中

	httpRequest.onreadystatechange = function () {//请求后的回调接口，可将请求成功后要执行的程序写在其中
		if (httpRequest.readyState == 4 && httpRequest.status == 200) {//验证请求是否发送成功
			handleFunction(JSON.stringify(httpRequest.responseText));//获取到json字符串，还需解析
		}
	};
}
```

使用js刷新页面

`location.reload();`