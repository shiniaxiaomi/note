set flag=open
@ if not '%flag%'=='open' (
	@set /p isMerge=  '输入merge进行合并冲突'
	@ if '%isMerge%' == 'merge' code C:\Users\yingjie.lu\Documents\note
) else (
	code C:\Users\yingjie.lu\Documents\note
)