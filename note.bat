@set path = C:\Users\yingjie.lu\Documents\note

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
echo %path%
@cd %path%
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
@cd %path%
git pull
@ if '%flag%'=='open' (
    code %path%
) else (
    @set /p isMerge=  '如果没有报错直接回车即可,如果报错则输入merge进行合并冲突'
	@ if '%isMerge%' == '' code %path%
)
exit

:gitmerge
code %path%
exit