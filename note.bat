:: 使用quicker软件时使用以下路径
:: 需要自行修改note文件夹的路径
:: %cd%是获取当前cmd的路径 

@set myPath=%cd%
@cd %myPath%
@cd ../
@set myPath=%cd%\Documents\note

:: 如果是使用powershell测试时,使用以下路径
:: set myPath=%cd%

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
@set /p isMerge=  如果没有报错直接回车即可,如果报错则输入pull来解决冲突: 
@ if not '%isMerge%' == '' (
    @set flag=open
    @ goto gitpull
) 
exit

:gitpull
@cd %myPath%
git pull
@ if '%flag%'=='open' (
    code %myPath%
) else (
    @set /p isMerge=  '如果没有报错直接回车即可,如果报错则输入merge进行合并冲突'
	@ if '%isMerge%' == '' code %myPath%
)
exit

:gitmerge
code %myPath%
exit