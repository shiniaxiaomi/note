#coding=utf-8

import subprocess
import sys

# 调用的命令为 py note.py D:/note/README.md

# 路径变量的格式为D:/note/README.md
notePath=sys.argv[1] #note的路径变量
cmd='"C:\Program Files\Typora\Typora.exe" "%s"' % (notePath)
ps = subprocess.Popen(cmd); # 执行cmd命令
ps.wait();#让程序阻塞