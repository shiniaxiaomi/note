
@ if '%flag%'=='open' (
    code C:\Users\yingjie.lu\Documents\note
) else (
    @set /p isMerge=  '如果没有报错直接回车即可,如果报错则输入merge进行合并冲突'
	@ if '%isMerge%' == '' code C:\Users\yingjie.lu\Documents\note
)