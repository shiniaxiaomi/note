使用brew安装完应用后，应用的配置文件一般都会存在在`/usr/local/etc`目录下



使用brew安装redis：

- brew search redis

- brew install redis@3.2

- 安装成功之后，你可以将redis的bin目录添加到环境变量中

  ```shell
  echo 'export PATH="/usr/local/opt/redis@3.2/bin:$PATH"' >> ~/.zshrc
  ```

- 启动

  直接启动：`redis-server`

  使用绝对路径启动：`/usr/local/opt/redis@3.2/bin/redis-server`

  使用配置文件启动：`redis-server /usr/local/etc/redis.conf`

  启动redis客户端：`redis-cli`



---



使用brew安装mysql：

- brew search mysql

- brew install mysql@5.7

- 安装完成之后，会帮你设置好环境变量，不用再设置

- 使用`mysql_secure_installation`命令设置mysql密码（前提需要先启动mysql）；如果不想设置密码，可以直接使用`mysql -uroot`登入

- 如果要设置mysql开启启动，需要执行命令`brew services start mysql@5.7`

- 启动mysql

  直接启动：`mysql.server start`

  使用绝对路径启动：`/usr/local/opt/mysql@5.7/bin/mysql.server start`

