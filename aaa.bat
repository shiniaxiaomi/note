

@ if '%flag%'=='open' (
    code %myPath%
) else (
    REM set /p isMerge=���û�б���ֱ�ӻس������˳�,�������������merge���кϲ���ͻ: 
	REM  if '%isMerge%' == 'merge' (
    REM     :: ��ȡ��ͻ��Ϊ���س�ͻ,�Ƚ������ύ�����زֿ�,Ȼ������ȡ,git������Զ��ϲ�,֮����ʹ��vscode���н����ͻ�ĺϲ�
    REM     git add .
    REM     git commit -m '�����ͻ'
    REM     git pull
    REM     code %myPath%
    REM     pause
    REM )
    REM  if '%isMerge%' == 'exit' exit
    REM  if '%isMerge%' == '' exit
    REM echo 1
    set /p a=sddddd:
    set /p b=dsfsdf:
    
)

if '%b%'=='1' echo 1

echo %a%
pause