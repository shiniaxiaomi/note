:rechoose
@set /p choice= ��ѡ��push����pull: 

@ if "%choice%"=="push" (
    @ goto gitpush
) 

@ if "%choice%"=="pull" (
    @ goto gitpull
) 

@ goto rechoose

:gitpush
@set /p message= �����ύ��Ϣ: 
@cd C:\Users\yingjie.lu\Documents\note
git add .
git commit -m %message%
git push
@pause
exit

:gitpull
@cd C:\Users\yingjie.lu\Documents\note
git pull
exit