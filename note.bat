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
@set /p isMerge=  ���û�б���ֱ�ӻس�����,�������������pull�������ͻ: 
@ if not '%isMerge%' == '' (
    @set flag=open
    @ goto gitpull
) 
exit

:gitpull
@cd C:\Users\yingjie.lu\Documents\note
git pull
@ if not '%flag%'=='open' (
	@set /p isMerge=  '����merge���кϲ���ͻ'
	@ if '%isMerge%' == 'merge' code C:\Users\yingjie.lu\Documents\note
) else (
	code C:\Users\yingjie.lu\Documents\note
)
exit

:gitmerge
code C:\Users\yingjie.lu\Documents\note
exit