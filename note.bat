:: ��Ҫ�����޸�note�ļ��е�·��
@set myPath=C:\Users\%userName%\Documents\note\

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
@set /p isMerge=  ���û�б���ֱ�ӻس������˳�,�������������pull�������ͻ: 
@ if not '%isMerge%' == '' (
    @set flag=open
    @ goto gitpull
) 
@ if '%isMerge%' == 'exit' exit
@ if '%isMerge%' == '' exit
exit

:gitpull
@cd %myPath%
git pull
@ if '%flag%'=='open' (
    code %myPath%
) else (
    @set /p isMerge=  '���û�б���ֱ�ӻس������˳�,�������������merge���кϲ���ͻ'
	@ if '%isMerge%' == 'merge' (
        :: ��ȡ��ͻ��Ϊ���س�ͻ,�Ƚ������ύ�����زֿ�,Ȼ������ȡ,git������Զ��ϲ�,֮����ʹ��vscode���н����ͻ�ĺϲ�
        git add .
        @set /p message= ���뱾���ύ����Ϣ:
        git commit -m %message%
        git pull
        code %myPath%
    )
    @ if '%isMerge%' == 'exit' exit
    @ if '%isMerge%' == '' exit
)
exit

:gitmerge
code %myPath%
exit