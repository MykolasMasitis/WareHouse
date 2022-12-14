declare @schema varchar(50) = 'dim'
declare @table varchar(50) = 'Ds'
declare @command varchar(250) = 'select top 20 * from '+quotename(@schema)+'.'+quotename(@table)
select @command
exec (@command)

-- Переключаемся на рабочую базу
use lpu
go

alter table [Заболеваемость].[Первичные приемы] add caseid int default 0
go 
update a 
	set caseid = case_id
	from [Заболеваемость].[Первичные приемы] a
left join (select recid, 
	DENSE_RANK() over (order by sn_pol, left(ds,3)) as case_id
	from [Заболеваемость].[Первичные приемы]) b on a.recid=b.recid
go 
-- (10187843 row(s) affected) 31 минута

;with cte as
(select caseid, count(*) as cnt from [Заболеваемость].[Первичные приемы] group by caseid)
select top 100 cnt, count(*) as count from cte group by cnt order by count desc
go

;with cte (caseid, cnt) as
(select caseid as caseid, count(*) as cnt from [Заболеваемость].[Первичные приемы] group by caseid)
select * from [Заболеваемость].[Первичные приемы] a where a.caseid = cte.caseid
go

;with cte as
(select caseid, count(*) as cnt
from [Заболеваемость].[Первичные приемы]
group by caseid 
)
select cnt, count(*) as _cnt from cte
group by cnt order by _cnt desc
go

IF OBJECT_ID('tempdb..#table01') IS NOT NULL DROP TABLE #table01
;with cte as
(select caseid, count(*) as cnt
from [Заболеваемость].[Первичные приемы]
group by caseid 
)
select top 100 * into #table01 from [Заболеваемость].[Первичные приемы]
where caseid in (select caseid from cte where cnt=1) order by NEWID()
go

select * from #table01 order by sn_pol

-- отбираем все первичные приемы
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Заболеваемость.[Первичные приемы]')) 
	DROP TABLE Заболеваемость.[Первичные приемы]
-- удалять не надо - на ней вьюшки
-- select top 1 * into Заболеваемость.[Первичные приемы] from facts.Services
-- truncate table  Заболеваемость.[Первичные приемы]
CREATE TABLE Заболеваемость.[Первичные приемы] (recid int, 
	sn_pol varchar(25), c_i varchar(30), ages dec(3), sex tinyint, d_u date, ds char(6), cod dec(6),
	prvs dec(4), ord dec(1), date_ord date, lpu_ord dec(6), 
	p_cel char(3), dn dec(1), c_zab dec(1), n_obr tinyint, ischron bit default 0,
	CONSTRAINT [pk_pervpr_recid] PRIMARY KEY NONCLUSTERED (recid))
GO
insert into Заболеваемость.[Первичные приемы]
	(
		recid, sn_pol, c_i, ages, sex, cod, d_u, ds, 
		prvs, ord, date_ord, lpu_ord, p_cel, dn, c_zab
	)
select 
	recid, sn_pol, c_i, ages, sex, cod, d_u, ds, 
	prvs, ord, date_ord, lpu_ord, p_cel, dn, c_zab
from facts.Services   
where cod in (1001,1011,1013,1021,1031,1041,1043,1051,1061,1071,1081,1091,1101,1111,1114,1115,1141,1151,
		1153,1161,1191,1201,1261,1271,1276,1301,1331,1371,1411,1431,1441,1443,1461,1511,1801,1803,1808,1823,1825,
		101001,101005,101011,101013,101032,101041,101051,101059,101061,101070,101081,101091,101111,101121,
		101131,101161,101168,101171,101181,101184,101185,101201,101211)
-- (10860888 row(s) affected)

create index idx_pervpr on Заболеваемость.[Первичные приемы] (cod) include (recid)
create index idx_pervpr_recid on Заболеваемость.[Первичные приемы] (recid)
create index idx_pervpr_sn_pol on Заболеваемость.[Первичные приемы] (sn_pol) include (recid)
create index idx_pervpr_ds on Заболеваемость.[Первичные приемы] (ds) include (recid)
create index idx_pervpr_prvs on Заболеваемость.[Первичные приемы] (prvs) include (recid)
create index idx_pervpr_p_cel on Заболеваемость.[Первичные приемы] (p_cel) include (recid)
create index idx_pervpr_dn on Заболеваемость.[Первичные приемы] (dn) include (recid)
create index idx_pervpr_c_zab on Заболеваемость.[Первичные приемы] (c_zab) include (recid)
create index idx_pervpr_d_u on Заболеваемость.[Первичные приемы] (d_u) include (recid)
create index idx_pervpr_ischron on Заболеваемость.[Первичные приемы] (ischron) include (recid)

ALTER TABLE Заболеваемость.[Первичные приемы]
	ADD CONSTRAINT pervpr_c_zab_FK FOREIGN KEY (c_zab) REFERENCES dim.c_zab(code)
ALTER TABLE Заболеваемость.[Первичные приемы]
	ADD CONSTRAINT pervpr_d_u_FK FOREIGN KEY (d_u) REFERENCES dim.Dates(d_u)
ALTER TABLE Заболеваемость.[Первичные приемы]
	ADD CONSTRAINT pervpr_ds_FK FOREIGN KEY (ds) REFERENCES dim.Ds(code)
ALTER TABLE Заболеваемость.[Первичные приемы]
	ADD CONSTRAINT pervpr_prvs_FK FOREIGN KEY (prvs) REFERENCES dim.Prvs(code)
ALTER TABLE Заболеваемость.[Первичные приемы]
	ADD CONSTRAINT pervpr_ord_FK FOREIGN KEY (ord) REFERENCES dim.Ord(code)
ALTER TABLE Заболеваемость.[Первичные приемы]
	ADD CONSTRAINT pervpr_p_cel_FK FOREIGN KEY (p_cel) REFERENCES dim.P_cel(code)
ALTER TABLE Заболеваемость.[Первичные приемы]
	ADD CONSTRAINT pervpr_dn_FK FOREIGN KEY (dn) REFERENCES dim.Dn(code)
GO

-- отбираем все первичные приемы

-- select DB_ID('lpu')
--select top 1000 sn_pol,mcod,ds,c_zab,c.name, cod,b.name,d_u from Заболеваемость.[Первичные приемы] a
--join dim.Tarif b on a.cod=b.code
--join dim.Ds c on a.ds=c.code
--where sn_pol+ds in (
--select sn_pol+ds from Заболеваемость.[Первичные приемы] group by sn_pol,ds having COUNT(*)>1)
--order by sn_pol, ds, d_u asc

-- устанавливаем правильный профиль
update Заболеваемость.[Первичные приемы] 
	set prvs = 
	(case 
		when cod in (1041,1042,1043,1044,1045,1702,1742,1780,101101,101102,101103,101105,101107,101741,101908)
			then 118
		when cod in (1071,1072,1073,1075,1705,1745,101121,101122,101125,101127,101130,101705,101909)
			then 31
		when cod in (1051,1052,1053,1055,1703,1743,101211,101212,101213,101215,101217,101731,101902)
			then 114
		when cod in (1061,1062,1065,1704,1744,101201,101202,101203,101205,101207,101703,101904)
			then 89
		when cod in (1091,1092,1093,1095,1097,1747,101131,101132,101133,101135,101137,101735)
			then 32
		when cod in (1081,1082,1083,1085,1706,1746,101743,101910)
			then 16
		when cod in (1141,1142,1143,1145,1147,1707,1750,1753,1755,1756,1780,101032,101033,101034,101035,101037,101707,101745,101911)
			then 30
		when cod in (1161,1162,1163,1165,1167,1709,1752,101081,101082,101083,101085,101087,101711,101905)
			then 145
		when cod in (1101,1102,1748,101171,101172,101771,101924)
			then 63
		when cod in (1111,1112,1113,1114,1115,1117,1730,1749,101181,101182,101183,101184,101185,101187,101773,101926)
			then 59
		when cod in (1151,1152,1153,1154,1155,1157,1708,1751,101041,101042,101045,101047,101709,101912)
			then 28
		when cod in (1191,1192,1193,1195,1722,1757,101751)
			then 17
		when cod in (1261,1262,1263,1265,1267,1710,1764,101061,101062,101065,101067,101713,101913)
			then 20
		when cod in (1271,1272,1273,1275,1276,1277,1278,1279,1280,1765,101051,101052,101053,101054,101055,101056,101057,101058,101059,101060,101914)
			then 19
		when cod in (1301,1302,1303,1305,1306,1307,1712,1767,101161,101162,101163,101165,101167,101168,101169,101170,101717,101917) -- Неврология
			then 14
		when cod in (1331,1332,1333,1335,1337,1726,1769,101111,101112,101113,101115,1011171,101721,101916) -- Дерматовенерологи
			then 10
		when cod in (1371,1372,1373,1375,1377,1713,1772) -- Ревматология
			then 91
		when cod in (1411,1412,1415,1714,1773,101091,101092,101093,101095,101097,101727,101907) -- Аллергология
			then 255
		when cod in (1431,1432,1433,1435,1716,1775,101729,101906) -- Пульмонология
			then 262
		when cod in (1441,1442,1443,1445,1447,1727,1763,101070,101071,101072,101073,101719,101915) -- Гинекология
			then 8
		when cod in (1461,1462,1465,1717,1776,101763) -- Колопроктология
			then 43
		when cod in (1001,1002,1011,1012,1013,1014,1015,1016,1017,1018,1021,1022,1025,1027,1031,1032,1035,
			1511,1512,1513,1515,1801,1802,1803,1804,1805,1806,1807,1808,1823,1825,
			101001,101002,101003,101004,101005,101006,101011,101012,101013,
			101014,101015,101016,101017,101018,101027,101028,101029,101030,101031) -- Терапия
			then 27
		when cod in (9401,9402,9403,9404,9405,9406,9407,
			109401,109402,109403,109404,109405,109406,109407,109408,109409)
			then 171
		when cod in (1201)
			then 74 -- радиология
		else 0
	end)
-- (10860888 row(s) affected)
--select cod, count(*) from Заболеваемость.[Первичные приемы] where prvs=0 group by cod
-- может быть, удалить нули???
go 
-- устанавливаем правильный профиль

-- удаляем несвойственные профилю диагнозы
begin tran 
delete a from Заболеваемость.[Первичные приемы] a 
	left join Статистика.[Все специальности] b 
	on a.prvs=b.prvs and a.ds=b.ds 
	where b.cnt is null
commit 
-- (673045 row(s) affected)
-- после этого начинает работать внешний ключ на диагнозы. Но подумать на этот счет!
-- удаляем несвойственные диагнозы

-- проставляем порядковый номер обращения
update a 
	set n_obr = b.n_obr
	from [Заболеваемость].[Первичные приемы] a
left join (select recid, 
	ROW_NUMBER() over (partition by sn_pol, ds order by d_u asc) as n_obr
	from [Заболеваемость].[Первичные приемы]) b on a.recid=b.recid
-- после формирования индексов ускорение до 6 минут!
-- делается долго - 18 минут!

alter table [Заболеваемость].[Первичные приемы] add ischron bit default 0

begin tran 
update a
set ischron = 1
from [Заболеваемость].[Первичные приемы] a
left outer join (select sn_pol,ds from [Заболеваемость].[Диспансерные приемы]) b
on a.sn_pol=b.sn_pol and a.ds=b.ds 
where b.sn_pol is not null
-- (127169 row(s) affected) всего лишь!
commit

/*
c_zab=1 - Острое 
c_zab=2 - Впервые в жизни установленное хроническое,
c_zab=3 - Ранее установленное хроническое
*/
select c_zab, count(*), COUNT(distinct sn_pol)
from [Заболеваемость].[Первичные приемы]
group by c_zab
go 
--c_zab                                               
--------------------------------------- ----------- -----------
--2                                       1608447     1031137
--3                                       412283      258168
--1                                       2983208     1711027
--0                                       5183905     2327436

-- создан бэкап 01092022.bak

begin tran
update a
set c_zab = 1
--select top 1000 *
from [Заболеваемость].[Первичные приемы] a
join 
(select top 20 * from [dim].[ОстрыеХронические] order by [Острых] desc) b 
on a.ds=b.Код
where c_zab = 0
-- top 10: (1763801 row(s) affected)
-- top 20: (125281 row(s) affected)
-- 50 минут выполнялось!
commit

begin tran
update a
set c_zab = 1
-- select top 1000 *
from [Заболеваемость].[Первичные приемы] a
join 
(select top 20 * from [dim].[ОстрыеХронические] order by [Хронических] desc) b 
on a.ds=b.Код
where c_zab = 0
-- (422758 row(s) affected)
-- top 20: (181446 row(s) affected)
commit
-- после этого вот такой результат
--c_zab                                   
----------------------------------------- -----------
--0                                       2690619
--1                                       5476494
--2                                       1608447
--3                                       412283

-- создаем вьюшки для амбулаторно-поликлинической заболеваемости

-- Prevalence - общая заболеваемость (распространенность, болезненность)
-- совокупность всех имеющихся срединаселения заболеваний, впервые выявленных в данном году и
-- зарегистрированных в предыдущие годы, по поводу которых больные вновь обратились за медицинской
-- помощью в данном году
-- Incidence - первичная заболеваемость (собственно заболеваемость) термин, рекомендованный ВОЗ
-- частота новых, нигде ранее неучтенных и впервые в данном году выявленных среди населения заболеваний
IF OBJECT_ID('Заболеваемость.Первичная','V') IS NOT NULL DROP VIEW Заболеваемость.Первичная
GO
create view Заболеваемость.Первичная with schemabinding as
(
SELECT recid, sn_pol, c_i, ages, sex, cod, d_u, ds, 
		prvs, ord, date_ord, lpu_ord, p_cel, dn, c_zab,
		ROW_NUMBER() over (partition by sn_pol, ds order by d_u asc) as n_obr
  FROM [Заболеваемость].[Первичные приемы] where c_zab in (1,2) -- 1-Острое, 2-Впервые в жизни установленное хроническое
)
GO
-- Закомментировано из-за наличия оконной функции
--CREATE UNIQUE CLUSTERED INDEX
--    ix_zab_amb_perv ON Заболеваемость.Первичная (recid)
--go

-- пример select, когда необходимо вывести столбец, не участующий в group
select a.code, a.name, b.cnt
from dim.Ds a
inner join
(select ds, count(*) as cnt from [Заболеваемость].[Общая] a
	where c_zab=2 group by ds) as b
on a.code=b.ds 
where cnt>2
order by 3 desc

-- prevalence - термин, рекомендованный ВОЗ
IF OBJECT_ID('Заболеваемость.Общая','V') IS NOT NULL DROP VIEW Заболеваемость.Общая
GO
create view Заболеваемость.Общая with schemabinding as
(
SELECT recid, sn_pol, c_i, ages, sex, cod, d_u, ds, prvs, ord, date_ord, lpu_ord, p_cel, dn, c_zab,
	ROW_NUMBER() over (partition by sn_pol, ds order by d_u asc) as n_obr
  FROM [Заболеваемость].[Первичные приемы] where c_zab in (0,1,2,3) -- 1-Острое, 2-Впервые в жизни установленное хроническое,3-Ранее установленное хроническое
)
GO
CREATE UNIQUE CLUSTERED INDEX
    ix_zab_amb_common ON Заболеваемость.Общая (recid)
CREATE INDEX
    ix_zab_amb_ages ON Заболеваемость.Общая (ages) include (recid)

go
-- создаем вьюшки для Заболеваемости

--select * from [Заболеваемость].[Общая] where c_zab=1

DECLARE @people int = 5113770 -- средняя численность на июль 2021
DECLARE @adults int = 4000000 -- взрослые
DECLARE @teenagers int = 0 -- подростки
DECLARE @children int = @people - @adults

select c_zab, ((count(*)*1000.0)/@adults)/7*12 as 'Первичная Взрослые' from Заболеваемость.Первичная
	where ages>=18 /*and ds not like 'U07%'*/  -- 695, 669 без COVID
	group by c_zab

select c_zab, ((count(*)*1000.0)/@adults)/7*12 as 'Распространенность' from Заболеваемость.Общая
	where ages>=18 /*and ds not like 'U07%'*/  -- 695, 669 без COVID
	group by c_zab

select ((count(*)*1000.0)/@children)/7*12 as 'Первичная Взрослые' from Заболеваемость.Первичная
	where ages<18 /*and ds not like 'U07%'*/  -- 752, 749 без COVID
go

select a.*, b.name, c.name from facts.Services a
join dim.Tarif b on a.cod=b.code
join dim.Ds c on a.ds=c.code
where sn_pol='0247600818000200' order by d_u asc

;with cte as
(select *, ROW_NUMBER() over(partition by sn_pol order by d_u,cod) as row from facts.Services)
select COUNT(*) from cte 
join dim.Tarif b on cte.cod=b.code
where row=1 and b.name like 'Прием%'

;with cte as
(select *, ROW_NUMBER() over(partition by sn_pol order by d_u,cod) as row from facts.Services)
select COUNT(*) from cte 
join dim.Tarif b on cte.cod=b.code
where row=1 and b.name not like 'Прием%'