:rechoose
@set /p choice= 请选择push还是pull: 

@ if "%choice%"=="push" (
    @ goto gitpush
) 

@ if "%choice%"=="pull" (
    @ goto gitpull
) 

@ goto rechoose

:gitpush
@set /p message= 输入提交信息: 
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