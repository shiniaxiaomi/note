:: ��ʹ��ǰ����Ҫ����git��vscode�Ļ�����������
:: ��C:\Program Files\Microsoft VS Code\bin��C:\Program Files\Git\cmd���뵽���������м���
:: ��Ҫ�����޸�note�ļ��е�·��
@set drive=D:
@set myPath=%drive%\note\

:: �л���noteĿ¼��
@cd %myPath%
@ %drive%

:rechoose
@set /p choice=��ѡ��push,pull,merge: 

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
@set /p message=�����ύ��Ϣ: 

git add .
git commit -m "%message%"
git push
@set /p isMerge=���û�б���ֱ�ӻس������˳�,�������������pull�������ͻ: 
@ if not '%isMerge%' == '' (
    @set flag=open
    @ goto gitpull
) 
@ if '%isMerge%' == 'exit' exit
@ if '%isMerge%' == '' exit
exit

:gitpull
git pull
@ if '%flag%'=='open' (
    code %myPath%
    exit
) else goto askMerge

:askMerge
@set /p isMerge=���û�б���ֱ�ӻس������˳�,�������������merge���кϲ���ͻ: 
@ if '%isMerge%' == 'exit' exit
@ if '%isMerge%' == '' exit
@ if '%isMerge%' == 'merge' (
    :: ��ȡ��ͻ��Ϊ���س�ͻ,�Ƚ������ύ�����زֿ�,Ȼ������ȡ,git������Զ��ϲ�,֮����ʹ��vscode���н����ͻ�ĺϲ�
    git add .
    @set /p isMerge=����˴κϲ����ύ����Ϣ:
    git commit -m %isMerge%
    git pull
    code %myPath%
    exit
)
:: ��ձ���
set isMerge=
goto askMerge




:gitmerge
code %myPath%
exit