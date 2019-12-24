# 介绍

依赖构建工具

# 安装

1. 首先检查你的jdk版本

   ```shell
   $ java -version
   java version "1.8.0_121"
   ```

2. 安装gradle

   ```shell
   brew install gradle
   ```

3. 将gradle的源改为国内的

   创建`~/.gradle/init.gradle`文件

   ```shell
   vim ~/.gradle/init.gradle
   ```

   ```js
   allprojects{
     repositories {
       def ALIYUN_REPOSITORY_URL = 'http://maven.aliyun.com/nexus/content/groups/public'
       def ALIYUN_JCENTER_URL = 'http://maven.aliyun.com/nexus/content/repositories/jcenter'
       all { ArtifactRepository repo ->
         if(repo instanceof MavenArtifactRepository){
           def url = repo.url.toString()
           if (url.startsWith('https://repo1.maven.org/maven2')) {
             project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_REPOSITORY_URL."
             remove repo
           }
           if (url.startsWith('https://jcenter.bintray.com/')) {
             project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_JCENTER_URL."
             remove repo
           }
         }
           }
       maven {
         url ALIYUN_REPOSITORY_URL
         url ALIYUN_JCENTER_URL
       }
     }
   }
   ```

4. 在第一次项目构建的时候，需要下载`https\://services.gradle.org/distributions/gradle-6.0.1-all.zip`文件，但是由于网络问题，不能够下载，导致项目不能够正常的编译，所以，我们需要通过其他途径来解决改问题
   - 先通过各种途径下载到`gradle-6.0.1-all.zip`文件（方法就不多解释了），然后将下载文件放在`~/.gradle`目录下
   - 将本地的该文件的地址即`file:///Users/yingjie.lu/.gradle/gradle-6.0.1-all.zip`复制到`gradle-wrapper.properties`文件中的`distributionUrl`属性值下
   - 在重新构建即可

# 构建项目

```shell
gradle build
```













