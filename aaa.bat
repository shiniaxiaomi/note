

@ if '%flag%'=='open' (
    code %myPath%
) else (
    REM set /p isMerge=如果没有报错直接回车即可退出,如果报错则输入merge进行合并冲突: 
	REM  if '%isMerge%' == 'merge' (
    REM     :: 拉取冲突因为本地冲突,先将代码提交到本地仓库,然后在拉取,git会进行自动合并,之后在使用vscode进行解决冲突的合并
    REM     git add .
    REM     git commit -m '解决冲突'
    REM     git pull
    REM     code %myPath%
    REM     pause
    REM )
    REM  if '%isMerge%' == 'exit' exit
    REM  if '%isMerge%' == '' exit
    REM echo 1
    set /p a=sddddd:
    set /p b=dsfsdf:
    
)

if '%b%'=='1' echo 1

echo %a%
pause