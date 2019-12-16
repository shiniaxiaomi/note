# 遍历文件夹工具

```java
/**
 * 遍历文件夹
 * @param file 需要遍历的文件路径
 * @param dirFilter 文件夹过滤
 * @param fileFilter 文件过滤
 * @param dirCallBack 目录回调
 * @param fileCallBack 文件回调
*/
public static void mapDir(File file, FileFilter dirFilter, FileFilter fileFilter, CallBack dirCallBack, CallBack fileCallBack) {
  //如果是文件
  if(file.isFile()){
    boolean accept = fileFilter.accept(file);
    if(!accept) return;//如果不符合过滤条件，则返回
    fileCallBack.callback(file);//文件回调
    return;
  }

  //如果是目录
  boolean accept = dirFilter.accept(file);
  if(!accept) return;//如果不符合过滤条件，则返回

  dirCallBack.callback(file);//目录回调

  //继续遍历目录
  File[] files = file.listFiles();
  for (File childFile : files) {
    mapDir(childFile,dirFilter,fileFilter,dirCallBack,fileCallBack);
  }
}
```

文件夹和文件过滤器需要实现Filter接口

```java
public class DirFilter implements FileFilter {
    @Override
    public boolean accept(File file) {
        //去除隐藏文件
        if(file.getName().startsWith(".")){
            return false;
        }
        return true;
    }
}
```

```java
public class BlogFilter implements java.io.FileFilter {
    @Override
    public boolean accept(File file) {
        //去除隐藏文件
        if(file.getName().startsWith(".")){
            return false;
        }
        //去除不以.md结尾的文件
        if(!file.getName().endsWith(".md")){
            return false;
        }
        return true;
    }
}
```

> 可以在文件夹和文件过滤器中排除一些文件夹和文件

目录回调和文件回调需要实现CallBack接口

```java
public class DirCallBack implements CallBack {
    @Override
    public void callback(File file) {
        System.out.println(file.getName());
    }
}
```

```java
public class BlogCallBack implements CallBack {
    @Override
    public void callback(File file) {
        System.out.println(file.getName());
    }
}
```

> 可以在目录和文件回调时做具体的操作

如果需要在遍历文件夹后获取到整个的目录结构，需要对mapDir函数进行修改，需要添加存放整体目录结构的对象

