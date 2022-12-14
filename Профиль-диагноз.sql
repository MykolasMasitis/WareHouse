/*
Макрос предназначен для формирования файлов-справочников профиль медицинской помощи - диагноз.
Конец разработки: 27.08.2021
Алгоритм: 
1. Из хранилища выбираем все диагнозы, установленные на приемах специалиста одного профиля (кардиолог, эндокринолог и т.д.).
2. Из отобранных диагнозов удаляются все Z-ки.
3. Диагнозы, встретившиеся 1 (один) раз считаются недостоверными и удаляются.
4. Диагнозы, не входящие в 3 (три) наиболее распространенные рубрики из числа 1 (первой) сотни и встретившиеся менее ста раз, удаляются.
5. Считается распростаненность (prevalence) для каждого профиля МП.
6. Собирается сводный файл по всем специальностям
7. Считается распростаненность (prevalence) нозологий по сводному файлу.

Повторное формирование файла-справочника не требуется!
*/

use lpu
go

-- Стоматология
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Стоматология')) 
	DROP TABLE Диагнозы.Стоматология

CREATE TABLE Диагнозы.Стоматология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Стоматология ADD CONSTRAINT PK_dental_diagnoses PRIMARY KEY (ds)

--select 27 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Терапия from
insert into Диагнозы.Стоматология
select 27 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1762,9401,9402,9403,9404,9405,9406,9407,
		101753,109401,109402,109403,109404,109405,109406,109407,109408,109409,109412)
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Диагнозы.Стоматология where ds like'Z%' -- убираем все Z-ки
--DELETE from Диагнозы.Стоматология where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.Стоматология where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Стоматология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Стоматология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100
	
declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Стоматология);
update Диагнозы.Стоматология set total=@total

update Диагнозы.Стоматология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Стоматология ORDER BY cnt desc
go
-- Стоматология

-- Терапия
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Терапия')) 
	DROP TABLE Диагнозы.Терапия

CREATE TABLE Диагнозы.Терапия (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Терапия ADD CONSTRAINT PK_therapy_diagnoses PRIMARY KEY (ds)

--select 27 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Терапия from
insert into Диагнозы.Терапия
select 27 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1001,1002,1011,1012,1013,1014,1015,1016,1017,1018,1021,1022,1025,1027,1031,1032,1035,
		1511,1512,1513,1515,1801,1802,1803,1804,1805,1806,1807,1808,1820,1821,1823,1824,1825,1826,
		101001,101002,101003,101004,101005,101006,101011,101012,101013,
		101014,101015,101016,101017,101018,101027,101028,101029,101030,101031) -- Терапия
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Диагнозы.Терапия where ds like'Z%' -- убираем все Z-ки
--DELETE from Диагнозы.Терапия where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.Терапия where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Терапия where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Терапия where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100
	
declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Терапия);
update Диагнозы.Терапия set total=@total

update Диагнозы.Терапия set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Терапия ORDER BY cnt desc
go
-- Терапия

-- кардиология, 118 (Диагнозы: I,Q,R)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Кардиология')) 
	DROP TABLE Диагнозы.Кардиология
CREATE TABLE Диагнозы.Кардиология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Кардиология ADD CONSTRAINT PK_cardiologia_diagnoses PRIMARY KEY (ds)

insert into Диагнозы.Кардиология
select 118 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1041,1042,1043,1044,1045,1702,1742,1780,101101,101102,101103,101105,101107,101741,101908)
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 

DELETE from Диагнозы.Кардиология where ds like'Z%' -- убираем все Z-ки
-- DELETE from Диагнозы.Кардиология where ds like'U07%' -- убираем COVID
DELETE from Диагнозы.Кардиология where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Кардиология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Кардиология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.[Кардиология]);
update Диагнозы.[Кардиология] set total=@total

update Диагнозы.[Кардиология] set prevalence = cast(cnt as decimal) / cast(total as decimal)

GO 
-- кардиология

-- эндокринология, 31 (Диагнозы: E,M,O)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Эндокринология')) 
	DROP TABLE Диагнозы.Эндокринология
CREATE TABLE Диагнозы.Эндокринология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Эндокринология ADD CONSTRAINT PK_endocrinologia_diagnoses PRIMARY KEY (ds)

--select 31 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Эндокринология from
insert into Диагнозы.Эндокринология
select 31 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1071,1072,1073,1075,1705,1745,101121,101122,101125,101127,101130,101705,101909) -- эндокринология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Диагнозы.Эндокринология where ds like'Z%' -- убираем все Z-ки
--DELETE from Диагнозы.Эндокринология where ds like'U07%' -- убираем COVID
DELETE from Диагнозы.Эндокринология where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Эндокринология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Эндокринология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Эндокринология);
update Диагнозы.Эндокринология set total=@total

update Диагнозы.Эндокринология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Эндокринология ORDER BY cnt desc
GO 
-- эндокринология

-- гастроэнтерология, 114 (Диагнозы: K)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Гастроэнтерология')) 
	DROP TABLE Диагнозы.Гастроэнтерология
CREATE TABLE Диагнозы.Гастроэнтерология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Гастроэнтерология ADD CONSTRAINT PK_gastro_diagnoses PRIMARY KEY (ds)

--select 114 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Гастроэнтерология from
insert into Диагнозы.Гастроэнтерология
select 114 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1051,1052,1053,1055,1703,1743,101211,101212,101213,101215,101217,101731,101902) -- гастроэнтерология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 

DELETE from Диагнозы.Гастроэнтерология where ds like'Z%' -- убираем все Z-ки
--DELETE from Диагнозы.Гастроэнтерология where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.Гастроэнтерология where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Гастроэнтерология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Гастроэнтерология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Гастроэнтерология);
update Диагнозы.Гастроэнтерология set total=@total

update Диагнозы.Гастроэнтерология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Гастроэнтерология ORDER BY cnt desc
GO
-- гастроэнтерология

-- нефрология, 89 (Диагнозы: N)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Нефрология')) 
	DROP TABLE Диагнозы.Нефрология
CREATE TABLE Диагнозы.Нефрология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Нефрология ADD CONSTRAINT PK_nephrology_diagnoses PRIMARY KEY (ds)

--select 89 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Нефрология from
insert into Диагнозы.Нефрология
select 89 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1061,1062,1065,1704,1744,101201,101202,101203,101205,101207,101703,101904) -- нефрология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Диагнозы.Нефрология where ds like'Z%' -- убираем все Z-ки
--DELETE from Диагнозы.Нефрология where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.Нефрология where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Нефрология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Нефрология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Нефрология);
update Диагнозы.Нефрология set total=@total

update Диагнозы.Нефрология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Нефрология ORDER BY cnt desc
go
-- нефрология

-- инфекция, 32 (B,J,A)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Инфекция')) 
	DROP TABLE Диагнозы.Инфекция
CREATE TABLE Диагнозы.Инфекция (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Инфекция ADD CONSTRAINT PK_сontagio_diagnoses PRIMARY KEY (ds)

--select 32 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Инфекция from
insert into Диагнозы.Инфекция
select 32 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1091,1092,1093,1095,1097,1747,101131,101132,101133,101135,101137,101735) -- инфекция
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 

DELETE from Диагнозы.Инфекция where ds like'Z%' -- убираем все Z-ки
--DELETE from Диагнозы.Инфекция where ds like'U07%' -- убираем COVID
DELETE from Диагнозы.Инфекция where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Инфекция where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Инфекция where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Инфекция);
update Диагнозы.Инфекция set total=@total

update Диагнозы.Инфекция set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Инфекция ORDER BY cnt desc
GO
-- инфекция

-- гематология, 16 (D,C)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Гематология')) 
	DROP TABLE Диагнозы.Гематология
CREATE TABLE Диагнозы.Гематология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Гематология ADD CONSTRAINT PK_HAEMATOLOGIA_diagnoses PRIMARY KEY (ds)

--select 16 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Гематология from
insert into Диагнозы.Гематология
select 16 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1081,1082,1083,1085,1706,1746,101743,101910) -- гематология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Диагнозы.Гематология where ds like'Z%' -- убираем все Z-ки
--DELETE from Диагнозы.Гематология where ds like'U07%' -- убираем COVID
DELETE from Диагнозы.Гематология where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Гематология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Гематология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Гематология);
update Диагнозы.Гематология set total=@total

update Диагнозы.Гематология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Гематология ORDER BY cnt desc
GO
-- гематология

-- хирург, 30
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Хирургия')) 
	DROP TABLE Диагнозы.Хирургия
CREATE TABLE Диагнозы.Хирургия (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Хирургия ADD CONSTRAINT PK_chirurgia_diagnoses PRIMARY KEY (ds)

--select 30 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Хирургия from
insert into Диагнозы.Хирургия
select 30 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1141,1142,1143,1145,1147,1707,1750,1753,1755,1756,1780,101032,101033,101034,101035,101037,101707,101745,101911) -- хирург
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Диагнозы.Хирургия where ds like'Z%' -- убираем все Z-ки
--DELETE from Диагнозы.Хирургия where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.Хирургия where cnt=1 -- убираем все единичные диагнозы
/*
delete from Диагнозы.Хирургия where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Хирургия where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100
*/

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Хирургия);
update Диагнозы.Хирургия set total=@total

update Диагнозы.Хирургия set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Хирургия ORDER BY cnt desc
GO
-- хирург

-- урология, 145 (N)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Урология')) 
	DROP TABLE Диагнозы.Урология
CREATE TABLE Диагнозы.Урология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Урология ADD CONSTRAINT PK_urology_diagnoses PRIMARY KEY (ds)

--select 145 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Урология from
insert into Диагнозы.Урология
select 145 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1161,1162,1163,1165,1167,1709,1752,101081,101082,101083,101085,101087,101711,101905) -- уролог
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Диагнозы.Урология where ds like'Z%' -- убираем все Z-ки
--DELETE from Диагнозы.Урология where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.Урология where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Урология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Урология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Урология);
update Диагнозы.Урология set total=@total

update Диагнозы.Урология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Урология ORDER BY cnt desc
go
-- урология

-- фто, 63 (много разных диагнозов, в статистике не учитывать!)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Физиотерапия')) 
	DROP TABLE Диагнозы.Физиотерапия
CREATE TABLE Диагнозы.Физиотерапия (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Физиотерапия ADD CONSTRAINT PK_physiotherapy_diagnoses PRIMARY KEY (ds)

--select 63 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Физиотерапия from
insert into Диагнозы.Физиотерапия
select 63 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1101,1102,1748,101171,101172,101771,101924) -- фто
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Диагнозы.Физиотерапия where ds like'Z%' -- убираем все Z-ки
-- DELETE from Диагнозы.Физиотерапия where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.Физиотерапия where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Физиотерапия where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Физиотерапия where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Физиотерапия);
update Диагнозы.Физиотерапия set total=@total

update Диагнозы.Физиотерапия set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Физиотерапия ORDER BY cnt desc
go
-- фто

-- лфк, 59 (в статистике не учитывать!)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.ЛФК')) 
	DROP TABLE Диагнозы.ЛФК
CREATE TABLE Диагнозы.ЛФК (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.ЛФК ADD CONSTRAINT PK_lfk_diagnoses PRIMARY KEY (ds)

--select 59 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.ЛФК from
insert into Диагнозы.ЛФК
select 59 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1111,1112,1113,1114,1115,1117,1730,1749,101181,101182,101183,101184,101185,101187,101773,101926) -- лфк
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 

DELETE from Диагнозы.ЛФК where ds like'Z%' -- убираем все Z-ки
--DELETE from Диагнозы.ЛФК where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.ЛФК where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.ЛФК where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.ЛФК where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.ЛФК);
update Диагнозы.ЛФК set total=@total

update Диагнозы.ЛФК set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.ЛФК ORDER BY cnt desc
go
-- лфк

-- травматолог-ортопед, 28
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Травматология')) 
	DROP TABLE Диагнозы.Травматология

CREATE TABLE Диагнозы.Травматология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Травматология ADD CONSTRAINT PK_traumatology_diagnoses PRIMARY KEY (ds)

--select 28 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Травматология from
insert into Диагнозы.Травматология
select 28 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1151,1152,1153,1154,1155,1157,1708,1751,101041,101042,101045,101047,101709,101912)
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 

DELETE from Диагнозы.Травматология where ds like'Z%' -- убираем все Z-ки
--DELETE from Диагнозы.Травматология where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.Травматология where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Травматология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Травматология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Травматология);
update Диагнозы.Травматология set total=@total

update Диагнозы.Травматология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Травматология ORDER BY cnt desc
go
-- травматолог-ортопед

-- онкология, 17 (N,C,D)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Онкология')) 
	DROP TABLE Диагнозы.Онкология

CREATE TABLE Диагнозы.Онкология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Онкология ADD CONSTRAINT PK_oncologia_diagnoses PRIMARY KEY (ds)

--select 17 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Онкология from
insert into Диагнозы.Онкология
select 17 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1191,1192,1193,1195,1722,1757,101751) -- онкология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Диагнозы.Онкология where ds like'Z%' -- убираем все Z-ки
DELETE from Диагнозы.Онкология where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.Онкология where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Онкология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Онкология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Онкология);
update Диагнозы.Онкология set total=@total

update Диагнозы.Онкология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Онкология ORDER BY cnt desc
go
-- онкология

-- офтальмология, 20 (Диагноз H)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Офтальмология')) 
	DROP TABLE Диагнозы.Офтальмология

CREATE TABLE Диагнозы.Офтальмология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Офтальмология ADD CONSTRAINT PK_ophthalmologia_diagnoses PRIMARY KEY (ds)

--select 20 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Офтальмология from
insert into Диагнозы.Офтальмология
select 20 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1261,1262,1263,1265,1267,1710,1764,101061,101062,101065,101067,101713,101913) -- офтальмология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Диагнозы.Офтальмология where ds like'Z%' -- убираем все Z-ки
DELETE from Диагнозы.Офтальмология where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.Офтальмология where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Офтальмология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Офтальмология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Офтальмология);
update Диагнозы.Офтальмология set total=@total

update Диагнозы.Офтальмология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Офтальмология ORDER BY cnt desc
go
-- офтальмология

-- ЛОР, 19 (Диагноз J,H)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.ЛОР')) 
	DROP TABLE Диагнозы.ЛОР

CREATE TABLE Диагнозы.ЛОР (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.ЛОР ADD CONSTRAINT PK_lor_diagnoses PRIMARY KEY (ds)

--select 19 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.ЛОР from
insert into Диагнозы.ЛОР
select 19 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1271,1272,1273,1275,1276,1277,1278,1279,1280,1765,101051,101052,101053,101054,101055,101056,101057,101058,101059,101060,101914) -- ЛОР
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Диагнозы.ЛОР where ds like'Z%' -- убираем все Z-ки
--DELETE from Диагнозы.ЛОР where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.ЛОР where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.ЛОР where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.ЛОР where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.ЛОР);
update Диагнозы.ЛОР set total=@total

update Диагнозы.ЛОР set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.ЛОР ORDER BY cnt desc
go
-- ЛОР

-- Неврология, 14 (Диагнозы I,M,G)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Неврология')) 
	DROP TABLE Диагнозы.Неврология

CREATE TABLE Диагнозы.Неврология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Неврология ADD CONSTRAINT PK_neurology_diagnoses PRIMARY KEY (ds)

--select 14 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Неврология from
insert into Диагнозы.Неврология
select 14 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1301,1302,1303,1305,1306,1307,1712,1767,101161,101162,101163,101165,101167,101168,101169,101170,101717,101917) -- Неврология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Диагнозы.Неврология where ds like'Z%' -- убираем все Z-ки
--DELETE from Диагнозы.Неврология where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.Неврология where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Неврология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Неврология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Неврология);
update Диагнозы.Неврология set total=@total

update Диагнозы.Неврология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Неврология ORDER BY cnt desc
go
-- Неврология

-- Дерматовенерология, 10 (L,B)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Дерматовенерология')) 
	DROP TABLE Диагнозы.Дерматовенерология

CREATE TABLE Диагнозы.Дерматовенерология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Дерматовенерология ADD CONSTRAINT PK_Dermatovenerology_diagnoses PRIMARY KEY (ds)

--select 10 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Дерматовенерология from
insert into Диагнозы.Дерматовенерология
select 10 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1331,1332,1333,1335,1337,1726,1769,101111,101112,101113,101115,1011171,101721,101916) -- Дерматовенерология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Диагнозы.Дерматовенерология where ds like'Z%' -- убираем все Z-ки
DELETE from Диагнозы.Дерматовенерология where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.Дерматовенерология where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Дерматовенерология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Дерматовенерология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Дерматовенерология);
update Диагнозы.Дерматовенерология set total=@total

update Диагнозы.Дерматовенерология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Дерматовенерология ORDER BY cnt desc
go
-- Дерматовенерология

-- Ревматология, 91 (Диагнозы M)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Ревматология')) 
	DROP TABLE Диагнозы.Ревматология

CREATE TABLE Диагнозы.Ревматология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Ревматология ADD CONSTRAINT PK_reumatology_diagnoses PRIMARY KEY (ds)

--select 91 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Ревматология from
insert into Диагнозы.Ревматология
select 10 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1371,1372,1373,1375,1377,1713,1772) -- Ревматология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Диагнозы.Ревматология where ds like'Z%' -- убираем все Z-ки
--DELETE from Диагнозы.Ревматология where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.Ревматология where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Ревматология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Ревматология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Ревматология);
update Диагнозы.Ревматология set total=@total

update Диагнозы.Ревматология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Ревматология ORDER BY cnt desc
go
-- Ревматология

-- Аллергология 255, (Диагнозы J,L)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Аллергология')) 
	DROP TABLE Диагнозы.Аллергология

CREATE TABLE Диагнозы.Аллергология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Аллергология ADD CONSTRAINT PK_allergology_diagnoses PRIMARY KEY (ds)

--select 255 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Аллергология from
insert into Диагнозы.Аллергология
select 255 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1411,1412,1415,1714,1773,101091,101092,101093,101095,101097,101727,101907) -- Аллергология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Диагнозы.Аллергология where ds like'Z%' -- убираем все Z-ки
--DELETE from Диагнозы.Аллергология where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.Аллергология where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Аллергология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Аллергология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Аллергология);
update Диагнозы.Аллергология set total=@total

update Диагнозы.Аллергология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Аллергология ORDER BY cnt desc
go
-- Аллергология

-- Пульмонология, 262 (Диагноз J)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Пульмонология')) 
	DROP TABLE Диагнозы.Пульмонология

CREATE TABLE Диагнозы.Пульмонология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Пульмонология ADD CONSTRAINT PK_pulmonology_diagnoses PRIMARY KEY (ds)

--select 262 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Пульмонология from
insert into Диагнозы.Пульмонология
select 262 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1431,1432,1433,1435,1716,1775,101729,101906) -- Пульмонология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Диагнозы.Пульмонология where ds like'Z%' -- убираем все Z-ки
--DELETE from Диагнозы.Пульмонология where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.Пульмонология where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Пульмонология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Пульмонология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Пульмонология);
update Диагнозы.Пульмонология set total=@total

update Диагнозы.Пульмонология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Пульмонология ORDER BY cnt desc
go
-- Пульмонология

-- Гинекология, 8 (Диагнозы N)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Гинекология')) 
	DROP TABLE Диагнозы.Гинекология

CREATE TABLE Диагнозы.Гинекология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Гинекология ADD CONSTRAINT PK_gynaecologia_diagnoses PRIMARY KEY (ds)

--select 8 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Гинекология from
insert into Диагнозы.Гинекология
select 8 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1441,1442,1443,1445,1447,1727,1763,101070,101071,101072,101073,101719,101915) -- Гинекология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Диагнозы.Гинекология where ds like'Z%' -- убираем все Z-ки
--DELETE from Диагнозы.Гинекология where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.Гинекология where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Гинекология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Гинекология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Гинекология);
update Диагнозы.Гинекология set total=@total

update Диагнозы.Гинекология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Гинекология ORDER BY cnt desc
go
-- Гинекология

-- Колопроктология, 43 (Диагнозы K)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.Колопроктология')) 
	DROP TABLE Диагнозы.Колопроктология

CREATE TABLE Диагнозы.Колопроктология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Диагнозы.Колопроктология ADD CONSTRAINT PK_coloproctology_diagnoses PRIMARY KEY (ds)

--select 43 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Диагнозы.Колопроктология from
insert into Диагнозы.Колопроктология
select 43 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1461,1462,1465,1717,1776,101763) -- Колопроктология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Диагнозы.Колопроктология where ds like'Z%' -- убираем все Z-ки
--DELETE from Диагнозы.Колопроктология where ds like'U07%' -- убираем COVID

DELETE from Диагнозы.Колопроктология where cnt=1 -- убираем все единичные диагнозы

delete from Диагнозы.Колопроктология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Диагнозы.Колопроктология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Диагнозы.Колопроктология);
update Диагнозы.Колопроктология set total=@total

update Диагнозы.Колопроктология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Диагнозы.Колопроктология ORDER BY cnt desc
go
-- Гинекология

/*
Скрипт выше формирует справочник соответствий диагноз-профиль МП для каждового профиля МП отдельно
Скрипт ниже соибрает все справочники в один
*/

IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Диагнозы.[Все специальности]')) 
	DROP TABLE Диагнозы.[Все специальности]
select top 1 * into Диагнозы.[Все специальности] from Диагнозы.Аллергология
truncate table  Диагнозы.[Все специальности]

insert into Диагнозы.[Все специальности]
--select * into Диагнозы.[Все специальности] from
select * from 
(
select * from Диагнозы.Аллергология 
union all 
select * from Диагнозы.Гастроэнтерология
union all 
select * from Диагнозы.Гематология
union all 
select * from Диагнозы.Гинекология
union all 
select * from Диагнозы.Дерматовенерология
union all 
select * from Диагнозы.Инфекция
union all 
select * from Диагнозы.Кардиология
union all 
select * from Диагнозы.Колопроктология
union all 
select * from Диагнозы.ЛОР
union all 
select * from Диагнозы.ЛФК
union all 
select * from Диагнозы.Неврология
union all 
select * from Диагнозы.Нефрология
union all 
select * from Диагнозы.Онкология
union all 
select * from Диагнозы.Офтальмология
union all 
select * from Диагнозы.Пульмонология
union all 
select * from Диагнозы.Ревматология
union all 
select * from Диагнозы.Терапия
union all 
select * from Диагнозы.Травматология
union all 
select * from Диагнозы.Урология
union all 
select * from Диагнозы.Физиотерапия
union all 
select * from Диагнозы.Хирургия
union all 
select * from Диагнозы.Эндокринология
) a
create index idx_allspecs on Диагнозы.[Все специальности] (prvs,ds)
go 

declare @total int
select @total =  sum(total) from 
	(select prvs, max(total) as total from [Диагнозы].[Все специальности] group by prvs) a
select @total
update [Диагнозы].[Все специальности] set total=@total
update [Диагнозы].[Все специальности] set prevalence = cast(cnt as decimal) / cast(total as decimal)
go
