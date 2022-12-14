-- Скрипт проверки корректности загруки периода в хранилище. Начало разработки 26.06.2021
-- Проверяем корректность загрузки файла FactMek, сравнивая сумму снятий со значением s_mek файла aisoms
-- Перед запуском установить переменную @period соответственно загружаемому периоду
-- select top 100 * from facts.Services order by NEWID() -- случайная сортировка
-- Сравниваем общие цифры: кол-во пролеченных, кол-во услуг, общая сумма - сравнить вручную!
select @@VERSION
select SYSTEM_USER
--delete from facts.aisoms where q='S7' and period='202201' and mcod='0371001'
--delete from facts.aisoms where q='R4' and period='202104'
--delete from facts.pr4 where period='202107'
--delete from facts.pr4st where period='202107'
--delete from facts.mag02 where period='202107'

SET NOCOUNT ON
USE lpu
GO 

-- Шаг 1. Проверяем макропоказатели.
-- Сравнить вручную, открыв "Сводный счет за период" (Записей в people) и "Витрину SOAP" (остальные параметры)
USE lpu
DECLARE @q char(6) = 'S7'
DECLARE @period char(6) = '202202'
SELECT COUNT(DISTINCT sn_pol) as 'Записей в people' FROM facts.Services WHERE q=@q and period=@period -- это значение сравнить с кол-вом записей в сводном people за период
SELECT SUM(s_all) as 'Представлено услуг к оплате' FROM facts.Services WHERE q=@q and period=@period -- это значение сравить с итоговой суммой в витрине SOAP
SELECT SUM(s_lek) as 'Представлено ЛС к оплате' FROM facts.Services b  WHERE q=@q and period=@period -- это значение сравить с итоговой суммой в витрине SOAP
SELECT SUM(s_all) as 'Снято услуг по МЭК' FROM facts.Services  WHERE q=@q and period=@period AND ismek>0
GO 
-- Если все совпало, переходим к Шагу 2
-- Шаг 1. Проверяем макропоказатели.

-- Если макропоказатели соответствуют, то переходим к шагу 2.
-- если не загрузилось какое-то МО, то здесь мы его увидим
DECLARE @period char(6) = '202201'
DECLARE @q char(6) = 'S7'
select * from facts.aisoms where q=@q and period=@period and s_pred>0 and mcod not in (
select distinct mcod FROM facts.Services WHERE q=@q and period=@period)
GO 
-- если не загрузилось какое-то МО, то здесь мы его увидим

-- Шаг 2. Сравниваем МЭК в factServices и aisoms -  это работает независимо от файла facts.Mek! На основе поле IsMek!
SET NOCOUNT ON
USE lpu
DECLARE @period char(6) = '202202'
DECLARE @q char(6) = 'S7'
IF OBJECT_ID('tempdb..#table01') IS NOT NULL DROP TABLE #table01
SELECT mcod, sum(s_all) as s_mek INTO #table01 FROM facts.Services WHERE q=@q and period=@period AND ismek>0 GROUP BY mcod
IF OBJECT_ID('tempdb..#table02') IS NOT NULL DROP TABLE #table02
SELECT a.mcod, a.s_mek as s_aisoms, b.s_mek as s_talon INTO #table02 FROM facts.aisoms a LEFT OUTER JOIN #table01 b ON a.mcod=b.mcod 
	WHERE q=@q and period=@period AND (isnull(a.s_mek,0)<>isnull(b.s_mek,0))
DECLARE @result int = 0;
SELECT @result = COUNT(*) FROM #table02 
IF @result>0
BEGIN 
 SELECT * FROM #table02 
END
ELSE
BEGIN
 PRINT 'Mek->FactServices, период '+@period+': все ок!'
END 
IF OBJECT_ID('tempdb..#table01') IS NOT NULL DROP TABLE #table01
IF OBJECT_ID('tempdb..#table02') IS NOT NULL DROP TABLE #table02
GO 
-- Шаг 2. Сравниваем МЭК в factServices и aisoms
-- Сравниваем МЭК в factServices и aisoms
-- если все ок, то переходим к Шагу 3.
--update facts.aisoms set s_pred=5109635.11 where q='S7' and period='202008' and mcod='0205143' 
--update facts.aisoms set s_pred=3729749.13 where q='S7' and period='202008' and mcod='0306006' 
-- Шаг 3. Сравниваем цифры по МО: сумма представленных, сумма ЛС в разрезе МО
SET NOCOUNT ON
USE lpu
DECLARE @period char(6) = '202202'
DECLARE @q char(6) = 'S7'
IF OBJECT_ID('tempdb..#table01') IS NOT NULL DROP TABLE #table01
SELECT mcod, sum(s_all) as s_all, sum(s_lek) as s_lek INTO #table01 FROM facts.Services WHERE q=@q and period=@period GROUP BY mcod
IF OBJECT_ID('tempdb..#table02') IS NOT NULL DROP TABLE #table02
SELECT a.mcod, s_pred, s_all, a.s_lek INTO #table02 FROM facts.aisoms a LEFT OUTER JOIN #table01 b ON a.mcod=b.mcod 
	WHERE q=@q and period=@period AND (isnull(a.s_pred,0)<>isnull(b.s_all,0) OR isnull(a.s_lek,0)<>isnull(b.s_lek,0))
DECLARE @result int = 0;
SELECT @result = COUNT(*) FROM #table02 
IF @result>0
BEGIN 
 SELECT * FROM #table02 
END
ELSE
BEGIN
 PRINT 'Talon->FactServices, период '+@period+': все ок!'
END 
IF OBJECT_ID('tempdb..#table01') IS NOT NULL DROP TABLE #table01
IF OBJECT_ID('tempdb..#table02') IS NOT NULL DROP TABLE #table02
GO 
-- Шаг 3. Сравниваем цифры по МО: сумма представленных, сумма ЛС в разрезе МО

-- эти фрагменты, если потребуется перезагрузка какого-то МО
DECLARE @period char(6) = '202201'
DECLARE @mcod char(7) = '4144650'
delete FROM facts.Services where period=@period and mcod=@mcod
GO
SET DATEFORMAT DMY
bulk insert [lpu].[facts].[FactServices] from '\\s01-9700-db05\lpu2smo\base\202105\4144650\talon.csv'
	with (fieldterminator=';', firstrow=1, codepage=1251, ROWTERMINATOR = '\n')
go
-- эти фрагменты, если потребуется перезагрузка какого-то МО

-- Шаг 4. Сравниваем снятия в FactMek с цифрами в aisoms
SET NOCOUNT ON
USE lpu
DECLARE @period char(6) = '202202'
DECLARE @q char(6) = 'S7'
IF OBJECT_ID('tempdb..#table01') IS NOT NULL DROP TABLE #table01
SELECT mcod, SUM(s_all) AS s_all INTO #table01 FROM
	(SELECT *, FIRST_VALUE(serviceId) OVER(PARTITION BY mcod, recid_lpu ORDER BY serviceId) AS _recid FROM facts.Mek WHERE q=@q and period=@period) AS t
		WHERE _recid=serviceId GROUP BY mcod ORDER BY mcod
IF OBJECT_ID('tempdb..#table02') IS NOT NULL DROP TABLE #table02
SELECT a.mcod,s_all,s_mek INTO #table02 FROM facts.aisoms a LEFT OUTER JOIN #table01 b ON a.mcod=b.mcod 
	WHERE q=@q and period=@period AND isnull(a.s_mek,0) <> isnull(b.s_all,0)
DECLARE @result int = 0;
SELECT @result = COUNT(*) FROM #table02 
IF @result>0
BEGIN 
 SELECT * FROM #table02 
END
ELSE
BEGIN
 PRINT 'Е-файлы->FactMek, период '+@period+': все ок!'
END 
IF OBJECT_ID('tempdb..#table01') IS NOT NULL DROP TABLE #table01
IF OBJECT_ID('tempdb..#table02') IS NOT NULL DROP TABLE #table02
GO

-- facts.Mek
-- Шаг 4. Сравниваем снятия в FactMek с цифрами в aisoms
-- select * FROM facts.Mek where period='202202' and q='I3' and mcod='0105006'
-- delete FROM facts.Mek where period='202202' and q='I3'
-- эти фрагменты, если потребуется перезагрузка

DECLARE @q char(2)='S7'
DECLARE @period char(6) = '202007'
DECLARE @mcod char(7)='0367664'
--delete FROM [facts].[Mek] where q=@q and period=@period and mcod=@mcod
select * FROM [facts].[Mek] where q=@q and period=@period and mcod=@mcod
GO

SET DATEFORMAT DMY
bulk insert facts.Mek from '\\s01-9700-db05\lpu2smo\base\202007\0367664\e0367664.csv'
	with (fieldterminator=';', firstrow=1, codepage=1251, ROWTERMINATOR = '\n')
go
-- эти фрагменты, если потребуется перезагрузка

-- вторая проблема при обработке 202105 - расхождение в s_own
update facts.Services set typ='1' where period='202105' and mcod=prmcod and typ<>1 and mp='p'
-- вторая проблема при обработке 202105 - расхождение в s_own
--delete from facts.mag02 where period='202102' and q='S7'
-- delete from facts.pr4 where period='202112' and q='S7'

-- Шаг 5. тест Приложения 4
DECLARE @period char(6) = '202202'
DECLARE @q char(6) = 'S7'
IF OBJECT_ID('tempdb..#pr4_exp001') IS NOT NULL DROP TABLE #pr4_exp001
SELECT * INTO #pr4_exp001 FROM facts.vw_pr4
-- результирующую строку сравнить с итоговой строкой в Приложении 4
select sum(p_all) as p_all, sum(s_all) as s_all, 
		sum(p_empty) as p_empty, sum(s_empty) as s_empty,
		sum(p_own) as p_own, sum(s_own) as s_own,
		sum(p_others) as p_others, sum(s_others) as s_others, --  иметь в виду, что эта цифра в lpu2smo считаетя неверно!
		sum(p_guests) as p_guests, sum(s_guests) as s_guests, 
		sum(p_bad) as p_bad, sum(s_bad) as s_bad 
		from #pr4_exp001 where q=@q and period=@period
-- если где-то появится ненулевая строка, значит в этом параметре расхождения!
select a.mcod, a.s_all as pr4_s_all, b.s_all as s_all from facts.pr4 a join #pr4_exp001 b on a.q=b.q and a.period=b.period and a.mcod=b.mcod  where a.q=@q and a.period=@period and a.s_all<>b.s_all
select a.mcod, a.s_own as pr4_s_own, b.s_own from facts.pr4 a join #pr4_exp001 b on a.q=b.q and a.period=b.period and a.mcod=b.mcod  where a.q=@q and a.period=@period and a.s_own<>b.s_own
select a.mcod, a.s_empty as pr4_s_empty, b.s_empty from facts.pr4 a join #pr4_exp001 b on a.q=b.q and a.period=b.period and a.mcod=b.mcod  where a.q=@q and a.period=@period and a.s_empty<>b.s_empty
select a.mcod, a.s_guests as pr4_s_guests, b.s_guests from facts.pr4 a join #pr4_exp001 b on a.q=b.q and a.period=b.period and a.mcod=b.mcod  where a.q=@q and a.period=@period and a.s_guests<>b.s_guests
select a.mcod, a.s_others as pr4_s_others, b.s_others from facts.pr4 a join #pr4_exp001 b on a.q=b.q and a.period=b.period and a.mcod=b.mcod  where a.q=@q and a.period=@period and a.s_others<>b.s_others
select a.mcod, a.s_bad as pr4_s_bad, b.s_bad from facts.pr4 a join #pr4_exp001 b on a.q=b.q and a.period=b.period and a.mcod=b.mcod  where a.q=@q and a.period=@period and a.s_bad<>b.s_bad
-- если будет расхождение, можно вывести:
-- select a.mcod, a.s_others as pr4, b.s_others as my, a.s_others-b.s_others as diff from facts.pr4 a join #pr4_exp001 b 
--	on a.period=b.period and a.mcod=b.mcod  where b.period='202102' and a.s_others<>b.s_others order by diff desc
IF OBJECT_ID('tempdb..#pr4_exp001') IS NOT NULL DROP TABLE #pr4_exp001 -- 132.48
GO
-- среднее время выполнение 10 минут! уже больше - 13,5!
-- Шаг 5. тест Приложения 4
--delete from facts.Surgeries where mcod in ('0105005','0105008','0105012','0105062','0105107','0105170','0105191','0305023','0305051','0305066',
--	'0305068','0305121','0305180','0305195','0305212','0305218','0305219','0306001','0306004','0306005',
--	'0341504','0343003','0343079','0343081','6332119') and period='202103'

-- Шаг 6. тест Приложения 4 стоматология
DECLARE @period char(6) = '202202'
DECLARE @q char(6) = 'S7'
IF OBJECT_ID('tempdb..#pr4_exp001') IS NOT NULL DROP TABLE #pr4_exp001
SELECT * INTO #pr4_exp001 FROM facts.vw_pr4st

-- результирующую строку сравнить с итоговой строкой в Приложении 4
select sum(p_all) as p_all, sum(s_all) as s_all, 
	   sum(p_empty) as p_empty, sum(s_empty) as s_empty,
	   sum(p_own) as p_own, sum(s_own) as s_own,
	   sum(p_others) as p_others, sum(s_others) as s_others, --  иметь в виду, что эта цифра в lpu2smo считаетя неверно!
	   sum(p_guests) as p_guests, sum(s_guests) as s_guests, 
	   sum(p_bad) as p_bad, sum(s_bad) as s_bad 
	   from #pr4_exp001 where q=@q and period=@period
-- если где-то появится ненулевая строка, значит в этом параметре расхождения!
select a.mcod, a.s_all as pr4_s_all, b.s_all as s_all from facts.pr4st a join #pr4_exp001 b on a.q=b.q and a.period=b.period and a.mcod=b.mcod  where a.q=@q and a.period=@period and a.s_all<>b.s_all
select a.mcod, a.s_own as pr4_s_own, b.s_own from facts.pr4st a join #pr4_exp001 b on a.q=b.q and a.period=b.period and a.mcod=b.mcod  where a.q=@q and a.period=@period and a.s_own<>b.s_own
select a.mcod, a.s_empty as pr4_s_empty, b.s_empty from facts.pr4st a join #pr4_exp001 b on a.q=b.q and a.period=b.period and a.mcod=b.mcod  where a.q=@q and a.period=@period and a.s_empty<>b.s_empty
select a.mcod, a.s_guests as pr4_s_guests, b.s_guests from facts.pr4st a join #pr4_exp001 b on a.q=b.q and a.period=b.period and a.mcod=b.mcod  where a.q=@q and a.period=@period and a.s_guests<>b.s_guests
select a.mcod, a.s_others as pr4_s_others, b.s_others from facts.pr4st a join #pr4_exp001 b on a.q=b.q and a.period=b.period and a.mcod=b.mcod  where a.q=@q and a.period=@period and a.s_others<>b.s_others
select a.mcod, a.s_bad as pr4_s_bad, b.s_bad from facts.pr4st a join #pr4_exp001 b on a.q=b.q and a.period=b.period and a.mcod=b.mcod  where a.q=@q and a.period=@period and a.s_bad<>b.s_bad
-- если будет расхождение, можно вывести:
--select a.mcod, a.s_others as pr4, b.s_others as my, a.s_others-b.s_others as diff from facts.pr4 a join facts.pr4_exp001 b 
--	on a.period=b.period and a.mcod=b.mcod  where b.period='202105' and a.s_others<>b.s_others order by diff desc
IF OBJECT_ID('tempdb..#pr4_exp001') IS NOT NULL DROP TABLE #pr4_exp001
GO
-- Шаг 6. тест Приложения 4 стоматология
select * from facts.Drugs where q='S7' and period='202106' and mcod='0150712'
-- Шаг 7.
-- facts.Drugs
SET NOCOUNT ON
USE lpu
DECLARE @period char(6) = '202202'
DECLARE @q char(6) = 'S7'
IF OBJECT_ID('tempdb..#table01') IS NOT NULL DROP TABLE #table01
SELECT mcod, sum(s_all) as s_all INTO #table01 FROM facts.Drugs WHERE q=@q and period=@period GROUP BY mcod
IF OBJECT_ID('tempdb..#table02') IS NOT NULL DROP TABLE #table02
SELECT a.mcod, s_lek, s_all INTO #table02 FROM facts.aisoms a LEFT OUTER JOIN #table01 b ON a.mcod=b.mcod 
	WHERE q=@q and period=@period AND isnull(a.s_lek,0)<>isnull(b.s_all,0)
DECLARE @result int = 0;
SELECT @result = COUNT(*) FROM #table02 
IF @result>0
BEGIN 
 SELECT * FROM #table02 
END
ELSE
BEGIN
 PRINT 'LS->FactDrugs, период '+@period+': все ок!'
END 
IF OBJECT_ID('tempdb..#table01') IS NOT NULL DROP TABLE #table01
IF OBJECT_ID('tempdb..#table02') IS NOT NULL DROP TABLE #table02
GO 
-- facts.Drugs
-- Шаг 7.
select * from facts.Surgeries where q='I3' and period='202103'
-- Проверка соответствия поля sum_flk в aisoms файлу ошибок
IF OBJECT_ID('facts.vw_checkload','V') IS NOT NULL DROP VIEW facts.vw_checkload
GO
create view facts.vw_checkload  with schemabinding as 
select period, mcod, s_pred, s_all, s_mek, s_def from 
(select period, mcod, 
	s_pred, coalesce((select sum(s_all) from facts.Services b where period=a.period and mcod=a.mcod), 0) as s_all,
	s_mek, coalesce((select sum(s_all) from facts.Services b where period=a.period and mcod=a.mcod and ismek>0), 0) as s_def
	from facts.aisoms a) b where b.s_all<>b.s_all or b.s_mek<>b.s_def
go 

select * from facts.vw_checkload where period='202105'
-- Проверка соответствия поля sum_flk в aisoms файлу ошибок

