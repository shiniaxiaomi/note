:rechoose
@set /p choice= ��ѡ��push,pull,merge: 

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
@set /p message= �����ύ��Ϣ: 
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