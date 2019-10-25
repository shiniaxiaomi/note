:: 在使用前还需要进行git和vscode的环境变量配置
:: 将C:\Program Files\Microsoft VS Code\bin和C:\Program Files\Git\cmd加入到环境变量中即可
:: 需要自行修改note文件夹的路径
@set drive=D:
@set myPath=%drive%\note\

:: 切换到note目录下
@cd %myPath%
@ %drive%

:rechoose
@set /p choice=请选择push,pull,merge: 

@ if "%choice%"=="push" (
    @ goto gitpush
) 

@ if "%choice%"=="pull" (
    @ goto gitpull
) 

@ if "%choice%"=="merge" (
    @ goto gitmerge
) 

@ goto rechoose

:gitpush
@set /p message=输入提交信息: 

git add .
git commit -m "%message%"
git push
@set /p isMerge=如果没有报错直接回车即可退出,如果报错则输入pull来解决冲突: 
@ if not '%isMerge%' == '' (
    @set flag=open
    @ goto gitpull
) 
@ if '%isMerge%' == 'exit' exit
@ if '%isMerge%' == '' exit
exit

:gitpull
git pull
@ if '%flag%'=='open' (
    code %myPath%
    exit
) else goto askMerge

:askMerge
@set /p isMerge=如果没有报错直接回车即可退出,如果报错则输入merge进行合并冲突: 
@ if '%isMerge%' == 'exit' exit
@ if '%isMerge%' == '' exit
@ if '%isMerge%' == 'merge' (
    :: 拉取冲突因为本地冲突,先将代码提交到本地仓库,然后在拉取,git会进行自动合并,之后在使用vscode进行解决冲突的合并
    git add .
    @set /p isMerge=输入此次合并所提交的信息:
    git commit -m %isMerge%
    git pull
    code %myPath%
    exit
)
:: 清空变量
set isMerge=
goto askMerge




:gitmerge
code %myPath%
exit