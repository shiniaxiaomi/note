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
@cd d:/myNote
@d:
git add .
git commit -m %message%
git push
@pause
exit

:gitpull
@cd d:/myNote
@d:
git pull
exit