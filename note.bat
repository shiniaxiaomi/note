@set path = C:\Users\yingjie.lu\Documents\note

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
echo %path%
@cd %path%
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
@cd %path%
git pull
@ if '%flag%'=='open' (
    code %path%
) else (
    @set /p isMerge=  '���û�б���ֱ�ӻس�����,�������������merge���кϲ���ͻ'
	@ if '%isMerge%' == '' code %path%
)
exit

:gitmerge
code %path%
exit