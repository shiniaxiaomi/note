:: ʹ��quicker���ʱʹ������·��
:: ��Ҫ�����޸�note�ļ��е�·��
:: %cd%�ǻ�ȡ��ǰcmd��·�� 

@set myPath=%cd%
@cd %myPath%
@cd ../
@set myPath=%cd%\Documents\note

:: �����ʹ��powershell����ʱ,ʹ������·��
:: set myPath=%cd%

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
@cd %myPath%
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
@cd %myPath%
git pull
@ if '%flag%'=='open' (
    code %myPath%
) else (
    @set /p isMerge=  '���û�б���ֱ�ӻس�����,�������������merge���кϲ���ͻ'
	@ if '%isMerge%' == '' code %myPath%
)
exit

:gitmerge
code %myPath%
exit