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
@ call :delay 1000 
git commit -m "%message%"
@ call :delay 1000 
git push
@ call :delay 1000 
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
    @ call :delay 1000 
    @set /p isMerge=����˴κϲ����ύ����Ϣ:
    git commit -m %isMerge%
    @ call :delay 1000 
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

::-----------����Ϊ��ʱ�ӳ���--------------------
:delay
if "%1"=="" goto :eof
set DelayTime=%1
set TotalTime=0
set NowTime=%time%
::��ȡ��ʼʱ�䣬ʱ���ʽΪ��13:01:05.95
:delay_continue
set /a minute1=1%NowTime:~3,2%-100
set /a second1=1%NowTime:~-5,2%%NowTime:~-2%0-100000
set NowTime=%time%
set /a minute2=1%NowTime:~3,2%-100
set /a second2=1%NowTime:~-5,2%%NowTime:~-2%0-100000
set /a TotalTime+=(%minute2%-%minute1%+60)%%60*60000+%second2%-%second1%
if %TotalTime% lss %DelayTime% goto delay_continue
goto :eof