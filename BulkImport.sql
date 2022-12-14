-- Скрипт массовой (bulk) загрузки данных в хранилище lpu
-- Предварительно должны быть выгружены talon.csv, err.csv, hoqq.csv
-- Полная ревизия закончена к 22.06.2021, загружены данные 202101, объем БД одного месяца 2,5Gb

-- select date_format from sys.dm_exec_requests where session_id = @@spid
-- SELECT name, collation_name  FROM sys.databases  WHERE name = N'lpu';

-- select count(*) from facts.Services where period='202104'

-- Ctrl+Shift+R для обновления кеша IntelliSence в случае появления волнистой линии под чем-нибудь, что реально существует...

-- на эту ошибку обратить внимание!
-- Error 7330:Cannot fetch a row from OLE DB provider "BULK" for linked server "(null)".

-- delete from facts.Mek where period='202012' and q='S7' and mcod='0105003'
-- Ctrl+Shift+R - обновить кэш...
use lpu
go

EXEC facts.delOncoFile '202010', 'I3'
GO
EXEC facts.delServFile '202010', 'I3'
GO 
EXEC facts.delAggrFile '202010', 'I3'

--delete from facts.aisoms where period='202201' and q='I3'
--delete from facts.pr4st where period='202202' and q='S7'
--delete from facts.aisoms where period='202201' and q='I3'
--delete from facts.Services where period='202201' and q='R4' and mcod='0371001'

-- Если I3, то указывать явно!
SET DATEFORMAT DMY
exec facts.BulkImportTalon '202202','I3'
-- 09:25 один период с индексками! Ингосс - 2 минуты
SET DATEFORMAT DMY
exec facts.BulkImportTalon '202202','R4'
SET DATEFORMAT DMY
exec facts.BulkImportTalon '202003','R2'
-- Если S7, то не указывать
SET DATEFORMAT DMY
exec facts.BulkImportTalon '202202'
-- it takes approximately 12 mins...
go 
--delete from facts.Services where period='202201' and q='I3' and mcod='0205125'

-- Если надо загрузить какую-то отдельную МО
SET DATEFORMAT DMY
 bulk insert facts.Services from '\\s01-9700-db05\lpu2smo\base\202201\0371001\talon.csv'
	with (CHECK_CONSTRAINTS, fieldterminator=';', firstrow=1, codepage=1251, ROWTERMINATOR = '\n')
SET DATEFORMAT DMY
 bulk insert facts.Services from '\\s01-9700-db05\lpu2smo\baser4\202201\0371001\talon.csv'
	with (fieldterminator=';', firstrow=1, codepage=1251, ROWTERMINATOR = '\n')
-- Если надо загрузить какую-то отдельную МО

exec sp_who
select * from facts.Mek where mcod='5344611'
-- select top 1000 * from facts.Services order by NEWID() -- случайная выборка для тестового хранилища
-- Error 4860:Cannot bulk load. - допустимая ошибка
-- The file "\\s01-9700-db05\lpu2smo\base\202101\1306624\e1306624.csv" does not exist.
--delete from facts.Mek where period='202202' and q='S7'
-- Если S7, то не указывать
SET DATEFORMAT DMY
exec facts.BulkImportMek '202202'
-- Если I3, то указывать явно!
SET DATEFORMAT DMY
exec facts.BulkImportMek '202202', 'I3'
SET DATEFORMAT DMY
exec facts.BulkImportMek '202202', 'R4'
SET DATEFORMAT DMY
exec facts.BulkImportMek '202003', 'R2'
go 
select * from facts.Mek where mcod='0343036'
-- Если надо загрузить какую-то отдельную МО
  truncate table facts.Mek
delete from facts.mek where q='S7' and period='202202'
SET DATEFORMAT DMY
 bulk insert facts.mek from '\\s01-9700-db05\lpu2smo\baser4\202007\0305219\e0305219.csv'
	with (fieldterminator=';', firstrow=1, codepage=1251, ROWTERMINATOR = '\n', FIRE_TRIGGERS) 
-- Если надо загрузить какую-то отдельную МО

-- delete from facts.Surgeries where period='202106'
-- select count(*) from facts.Surgeries where period='202102'
-- delete from facts.Surgeries where period='202102'
select facts.seek_factservices_recid('I3', '202101', '0105003', '355')
print @id
go 

-- Если S7, то не указывать
SET DATEFORMAT DMY
exec facts.BulkImportSurg '202202'
-- Если I3, то указывать явно!
SET DATEFORMAT DMY
exec facts.BulkImportSurg '202202', 'I3'
SET DATEFORMAT DMY
exec facts.BulkImportSurg '202002', 'R4'
SET DATEFORMAT DMY
exec facts.BulkImportSurg '202003', 'R2'
go
--delete from facts.Surgeries where period='202105' and q='R4'
SET DATEFORMAT DMY
bulk insert facts.Surgeries from '\\s01-9700-db05\lpu2smo\basei3\202201\0141740\ho.csv'
	with (fieldterminator=';', firstrow=1, codepage=1251, ROWTERMINATOR = '\n')


-- Cannot fetch a row from OLE DB provider "BULK" for linked server "(null)". - много таких ошибок!
go

IF OBJECT_ID('facts.BulkImportTalon','P') IS NOT NULL DROP PROCEDURE facts.BulkImportTalon
GO
CREATE PROCEDURE facts.BulkImportTalon (@period char(6), @qcod varchar(2)=NULL)
	AS
	SET NOCOUNT ON

	SET DATEFORMAT DMY
	DECLARE @Sql varchar(max)
	DECLARE @file varchar(256)
	--DECLARE @errorfile varchar(256)
	--SET @errorfile = '\\s01-9700-db05\lpu2smo\base'+ISNULL(@qcod,'')+'\' + @period + '\BulkLoadErrors.txt'
	
	DECLARE @mcod char(7)
	DECLARE my_cur CURSOR FOR SELECT mcod FROM facts.aisoms WHERE q=ISNULL(@qcod,'S7') AND period=@period AND s_pred>0
	OPEN my_cur
	FETCH NEXT FROM my_cur INTO @mcod

	WHILE @@FETCH_STATUS = 0
		BEGIN
		-- print @mcod+'...'
		RAISERROR (@mcod, 0, 0) WITH NOWAIT
		SET @file = '\\s01-9700-db05\lpu2smo\base'+ISNULL(@qcod,'')+'\' + @period + '\' + @mcod + '\talon.csv'
		--SET @file = 'e:\lpu2smo\base\' + @period + '\' + @mcod + '\talon.csv'
		--SET @file = 'y:\base\' + @period + '\' + @mcod + '\talon.csv'

		SET @Sql = 'bulk insert facts.Services from ' + QUOTENAME(@file, '''' ) + 
			' with (CHECK_CONSTRAINTS, fieldterminator=' + QUOTENAME(';', '''' ) + ', firstrow=1, ROWTERMINATOR = ' + 
			QUOTENAME('\n','''' )+', codepage=' + QUOTENAME('1251', '''' )+', MAXERRORS = 1' + ')'
		BEGIN TRY
			EXEC (@Sql)
		END TRY

		BEGIN CATCH 
			PRINT 'Error ' + CONVERT(VARCHAR, ERROR_NUMBER()) + ':' + ERROR_MESSAGE()
		END CATCH 

		FETCH NEXT FROM my_cur INTO @mcod
		
		END

	CLOSE my_cur
	DEALLOCATE my_cur
GO

IF OBJECT_ID('facts.BulkImportMek','P') IS NOT NULL DROP PROCEDURE facts.BulkImportMek
GO
CREATE PROCEDURE facts.BulkImportMek (@period char(6), @qcod varchar(2)=NULL)
	AS
	SET NOCOUNT ON
	DECLARE @Sql varchar(max)
	DECLARE @file varchar(256)
	
	DECLARE @mcod char(7)
	DECLARE my_cur CURSOR FOR SELECT mcod FROM facts.aisoms WHERE q=ISNULL(@qcod,'S7') AND period=@period AND s_mek>0
	OPEN my_cur
	FETCH NEXT FROM my_cur INTO @mcod

	WHILE @@FETCH_STATUS = 0
		BEGIN
		-- print @mcod+'...'
		RAISERROR (@mcod, 0, 0) WITH NOWAIT
		SET @file = '\\s01-9700-db05\lpu2smo\base'+ISNULL(@qcod,'')+'\' + @period + '\' + @mcod + '\e'+@mcod+'.csv'

		SET @Sql = 'bulk insert facts.Mek from ' + QUOTENAME(@file, '''' ) + 
			' with (fieldterminator=' + QUOTENAME(';', '''' ) + ', firstrow=1, codepage=1251, ROWTERMINATOR = ' + 
			QUOTENAME('\n','''' )+', MAXERRORS = 1, FIRE_TRIGGERS'+')'
		BEGIN TRY
			EXEC (@Sql)
		END TRY

		BEGIN CATCH 
			PRINT 'Error ' + CONVERT(VARCHAR, ERROR_NUMBER()) + ':' + ERROR_MESSAGE()
		END CATCH 

		FETCH NEXT FROM my_cur INTO @mcod
		
		END

	CLOSE my_cur
	DEALLOCATE my_cur
GO

IF OBJECT_ID('facts.BulkImportSurg','P') IS NOT NULL DROP PROCEDURE facts.BulkImportSurg
GO
CREATE PROCEDURE facts.BulkImportSurg (@period char(6), @qcod varchar(2)=NULL)
	AS
	SET NOCOUNT ON
	SET DATEFORMAT DMY

	DECLARE @Sql varchar(max)
	DECLARE @file varchar(256)
	
	DECLARE @mcod char(7)
	DECLARE my_cur CURSOR FOR SELECT mcod FROM facts.aisoms WHERE q=ISNULL(@qcod,'S7') AND period=@period AND s_pred>0
	OPEN my_cur
	FETCH NEXT FROM my_cur INTO @mcod

	WHILE @@FETCH_STATUS = 0
		BEGIN
		-- print @mcod+'...'
		RAISERROR (@mcod, 0, 0) WITH NOWAIT
		SET @file = '\\s01-9700-db05\lpu2smo\base' + ISNULL(@qcod,'') + '\' + @period + '\' + @mcod + '\ho.csv'

		SET @Sql = 'bulk insert facts.Surgeries from ' + QUOTENAME(@file, '''' ) + 
			' with (fieldterminator=' + QUOTENAME(';', '''' ) + ', firstrow=1, codepage=1251, ROWTERMINATOR = ' + 
			QUOTENAME('\n','''' )+', MAXERRORS = 1, FIRE_TRIGGERS'+')'
		BEGIN TRY
			EXEC (@Sql)
		END TRY

		BEGIN CATCH 
			PRINT 'Error ' + CONVERT(VARCHAR, ERROR_NUMBER()) + ':' + ERROR_MESSAGE()
		END CATCH 

		FETCH NEXT FROM my_cur INTO @mcod
		
		END

	CLOSE my_cur
	DEALLOCATE my_cur
GO

IF OBJECT_ID('facts.delOncoFile','P') IS NOT NULL DROP PROCEDURE facts.delOncoFile
GO
CREATE PROCEDURE facts.delOncoFile (@period char(6), @q char(2))
	AS
	SET NOCOUNT ON
	DELETE FROM facts.Cases        WHERE period = @period AND q = @q
	DELETE FROM facts.Consiliums   WHERE period = @period AND q = @q
	DELETE FROM facts.Denials      WHERE period = @period AND q = @q
	DELETE FROM facts.Drugs        WHERE period = @period AND q = @q
	DELETE FROM facts.igh          WHERE period = @period AND q = @q
	DELETE FROM facts.mrf          WHERE period = @period AND q = @q
	DELETE FROM facts.OncoServices WHERE period = @period AND q = @q
	DELETE FROM facts.Referrals    WHERE period = @period AND q = @q
GO

IF OBJECT_ID('facts.delServFile','P') IS NOT NULL DROP PROCEDURE facts.delServFile
GO
CREATE PROCEDURE facts.delServFile (@period char(6), @q char(2))
	AS
	SET NOCOUNT ON
	DELETE FROM facts.Services  WHERE period = @period and q = @q
	DELETE FROM facts.Mek       WHERE period = @period and q = @q
	DELETE FROM facts.Surgeries WHERE period = @period and q = @q
GO

IF OBJECT_ID('facts.delAggrFile','P') IS NOT NULL DROP PROCEDURE facts.delAggrFile
GO
CREATE PROCEDURE facts.delAggrFile (@period char(6), @q char(2))
	AS
	SET NOCOUNT ON
	DELETE FROM facts.pr4    WHERE period = @period and q = @q
	DELETE FROM facts.pr4st  WHERE period = @period and q = @q
	DELETE FROM facts.mag02  WHERE period = @period and q = @q
	DELETE FROM facts.aisoms WHERE period = @period and q = @q
GO

DELETE FROM facts.aisoms WHERE period = '202008' and q = 'I3'
DELETE FROM facts.pr4st WHERE period = '202011' and q = 'S7'
-- выводит все настройки, включая set dateformat, set language etc.
--DBCC USEROPTIONS

--set dateformat dmy
-- выводит все настройки, включая set dateformat, set language etc.
