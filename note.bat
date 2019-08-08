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
@cd C:\Users\yingjie.lu\Documents\note
git add .
git commit -m %message%
git push
@set /p isMerge=  
if not '%isMerge%' == '' goto rechoose
exit

:gitpull
@cd C:\Users\yingjie.lu\Documents\note
git pull
@set /p isMerge=  
if '%isMerge%' == 'merge' code C:\Users\yingjie.lu\Documents\note
exit

:gitmerge
code C:\Users\yingjie.lu\Documents\note
exit