:: 声明采用UTF-8编码
chcp 65001
:: 将外部传入的变量赋值给notePath
set notePath=%1
:: 从第9个开始截取到最后两个,在把md加上
set "notePath=%notePath:~9,-2%md" 
echo %notePath%

start /d "C:\Program Files\Typora\" Typora.exe "%notePath%"
pause