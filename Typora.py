#coding=utf-8
import subprocess
import sys
from urllib.parse import unquote

# 调用的命令为 py Typora.py D:/note/README.md

# 路径变量的格式为D:/note/README.md
notePath=sys.argv[1] #note的路径变量
# 将路径变量进行解码(从而可以使用中文)
notePath=unquote(notePath[7:], 'utf-8') 

cmd='"open /Applications/Typora.app" "%s"' % (notePath)
ps = subprocess.Popen(cmd); # 执行cmd命令
ps.wait();#让程序阻塞
