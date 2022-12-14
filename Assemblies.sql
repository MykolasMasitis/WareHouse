DROP ASSEMBLY DemoAssembly
CREATE ASSEMBLY DemoAssembly
	FROM 'C:\Hope\Hope\SQLDll\bin\Debug\SQLDll.dll'
	WITH PERMISSION_SET = SAFE
GO

DROP PROCEDURE facts.sp_GetPr4
GO
CREATE PROCEDURE facts.sp_GetPr4(@qCod nchar(2), @period nchar(6), @mcod nchar(7))
	AS EXTERNAL NAME DemoAssembly.Demo.GetPr4
GO 

EXEC facts.sp_GetPr4 @qCod='I3', @period='202101', @mcod='0105003'
GO 

exec sp_configure 'xp_cmdshell', 1
reconfigure
go

--exec master..xp_cmdshell 'bcp "select * from dim.Dn"'

