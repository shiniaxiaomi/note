:: 需要自行修改note文件夹的路径
@set myPath=C:\Users\%userName%\Documents\note\

:rechoose
@set /p choice= 请选择push,pull,merge: 

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
@set /p message= 输入提交信息: 
@cd %myPath%
git add .
git commit -m %message%
git push
@set /p isMerge=  如果没有报错直接回车即可退出,如果报错则输入pull来解决冲突: 
@ if not '%isMerge%' == '' (
    @set flag=open
    @ goto gitpull
) 
@ if '%isMerge%' == 'exit' exit
@ if '%isMerge%' == '' exit
exit

:gitpull
@cd %myPath%
git pull
@ if '%flag%'=='open' (
    code %myPath%
) else (
    @set /p isMerge=  '如果没有报错直接回车即可退出,如果报错则输入merge进行合并冲突'
	@ if '%isMerge%' == 'merge' (
        :: 拉取冲突因为本地冲突,先将代码提交到本地仓库,然后在拉取,git会进行自动合并,之后在使用vscode进行解决冲突的合并
        git add .
        @set /p message= 输入本次提交的信息:
        git commit -m %message%
        git pull
        code %myPath%
    )
    @ if '%isMerge%' == 'exit' exit
    @ if '%isMerge%' == '' exit
)
exit

:gitmerge
code %myPath%
exit