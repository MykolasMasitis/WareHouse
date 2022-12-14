/*
Макрос предназначен для формирования файлов-справочников профиль медицинской помощи - диспансерное наблюдение.
Конец разработки: 27.08.2021
Алгоритм: 
1. Из хранилища выбираем все диагнозы, установленные на приемах специалиста одного профиля (кардиолог, эндокринолог и т.д.).
2. Из отобранных диагнозов удаляются все Z-ки.
3. Диагнозы, встретившиеся 1 (один) раз считаются недостоверными и удаляются.
4. Диагнозы, не входящие в 3 (три) наиболее распространенные рубрики из числа 1 (первой) сотни и встретившиеся менее ста раз, удаляются.
5. Считается распростаненность (prevalence) для каждого профиля МП.
6. Собирается сводный файл по всем специальностям
7. Считается распростаненность (prevalence) нозологий по сводному файлу.

Идея не очень, не использовать.
*/

use lpu
go

-- Терапия
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Терапия')) 
	DROP TABLE Наблюдение.Терапия

CREATE TABLE Наблюдение.Терапия (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Терапия ADD CONSTRAINT PK_therapy_observatione PRIMARY KEY (ds)

--select 27 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Терапия from
insert into Наблюдение.Терапия
select 27 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1015,1016,1025,1035,1805,1806,1811,101003,101004,101015,101016,101031) -- Терапия
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Наблюдение.Терапия where ds like'Z%' -- убираем все Z-ки
--DELETE from Наблюдение.Терапия where ds like'U07%' -- убираем COVID

DELETE from Наблюдение.Терапия where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.Терапия where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Терапия where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100
	
declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.Терапия);
update Наблюдение.Терапия set total=@total

update Наблюдение.Терапия set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.Терапия ORDER BY cnt desc
go
-- Терапия

-- кардиология, 118 (Диагнозы: I,Q,R)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Кардиология')) 
	DROP TABLE Наблюдение.Кардиология
CREATE TABLE Наблюдение.Кардиология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Кардиология ADD CONSTRAINT PK_cardiologia_observatione PRIMARY KEY (ds)

insert into Наблюдение.Кардиология
select 118 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1045,101105)
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 

DELETE from Наблюдение.Кардиология where ds like'Z%' -- убираем все Z-ки
-- DELETE from Наблюдение.Кардиология where ds like'U07%' -- убираем COVID
DELETE from Наблюдение.Кардиология where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.Кардиология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Кардиология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.[Кардиология]);
update Наблюдение.[Кардиология] set total=@total

update Наблюдение.[Кардиология] set prevalence = cast(cnt as decimal) / cast(total as decimal)

GO 
-- кардиология

-- эндокринология, 31 (Диагнозы: E,M,O)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Эндокринология')) 
	DROP TABLE Наблюдение.Эндокринология
CREATE TABLE Наблюдение.Эндокринология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Эндокринология ADD CONSTRAINT PK_endocrinologia_observatione PRIMARY KEY (ds)

--select 31 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Эндокринология from
insert into Наблюдение.Эндокринология
select 31 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1075,101125) -- эндокринология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Наблюдение.Эндокринология where ds like'Z%' -- убираем все Z-ки
--DELETE from Наблюдение.Эндокринология where ds like'U07%' -- убираем COVID
DELETE from Наблюдение.Эндокринология where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.Эндокринология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Эндокринология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.Эндокринология);
update Наблюдение.Эндокринология set total=@total

update Наблюдение.Эндокринология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.Эндокринология ORDER BY cnt desc
GO 
-- эндокринология

-- гастроэнтерология, 114 (Диагнозы: K)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Гастроэнтерология')) 
	DROP TABLE Наблюдение.Гастроэнтерология
CREATE TABLE Наблюдение.Гастроэнтерология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Гастроэнтерология ADD CONSTRAINT PK_gastro_observatione PRIMARY KEY (ds)

--select 114 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Гастроэнтерология from
insert into Наблюдение.Гастроэнтерология
select 114 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1055,101215) -- гастроэнтерология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 

DELETE from Наблюдение.Гастроэнтерология where ds like'Z%' -- убираем все Z-ки
--DELETE from Наблюдение.Гастроэнтерология where ds like'U07%' -- убираем COVID

DELETE from Наблюдение.Гастроэнтерология where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.Гастроэнтерология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Гастроэнтерология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.Гастроэнтерология);
update Наблюдение.Гастроэнтерология set total=@total

update Наблюдение.Гастроэнтерология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.Гастроэнтерология ORDER BY cnt desc
GO
-- гастроэнтерология

-- нефрология, 89 (Диагнозы: N)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Нефрология')) 
	DROP TABLE Наблюдение.Нефрология
CREATE TABLE Наблюдение.Нефрология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Нефрология ADD CONSTRAINT PK_nephrology_observatione PRIMARY KEY (ds)

--select 89 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Нефрология from
insert into Наблюдение.Нефрология
select 89 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1065,101205) -- нефрология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Наблюдение.Нефрология where ds like'Z%' -- убираем все Z-ки
--DELETE from Наблюдение.Нефрология where ds like'U07%' -- убираем COVID

DELETE from Наблюдение.Нефрология where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.Нефрология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Нефрология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.Нефрология);
update Наблюдение.Нефрология set total=@total

update Наблюдение.Нефрология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.Нефрология ORDER BY cnt desc
go
-- нефрология

-- инфекция, 32 (B,J,A)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Инфекция')) 
	DROP TABLE Наблюдение.Инфекция
CREATE TABLE Наблюдение.Инфекция (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Инфекция ADD CONSTRAINT PK_сontagio_observatione PRIMARY KEY (ds)

--select 32 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Инфекция from
insert into Наблюдение.Инфекция
select 32 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1095,101135) -- инфекция
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 

DELETE from Наблюдение.Инфекция where ds like'Z%' -- убираем все Z-ки
--DELETE from Наблюдение.Инфекция where ds like'U07%' -- убираем COVID
DELETE from Наблюдение.Инфекция where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.Инфекция where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Инфекция where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.Инфекция);
update Наблюдение.Инфекция set total=@total

update Наблюдение.Инфекция set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.Инфекция ORDER BY cnt desc
GO
-- инфекция

-- гематология, 16 (D,C)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Гематология')) 
	DROP TABLE Наблюдение.Гематология
CREATE TABLE Наблюдение.Гематология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Гематология ADD CONSTRAINT PK_HAEMATOLOGIA_observatione PRIMARY KEY (ds)

--select 16 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Гематология from
insert into Наблюдение.Гематология
select 16 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1085,1706,1746,101743,101910) -- гематология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Наблюдение.Гематология where ds like'Z%' -- убираем все Z-ки
--DELETE from Наблюдение.Гематология where ds like'U07%' -- убираем COVID
DELETE from Наблюдение.Гематология where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.Гематология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Гематология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.Гематология);
update Наблюдение.Гематология set total=@total

update Наблюдение.Гематология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.Гематология ORDER BY cnt desc
GO
-- гематология

-- хирург, 30
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Хирургия')) 
	DROP TABLE Наблюдение.Хирургия
CREATE TABLE Наблюдение.Хирургия (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Хирургия ADD CONSTRAINT PK_chirurgia_observatione PRIMARY KEY (ds)

--select 30 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Хирургия from
insert into Наблюдение.Хирургия
select 30 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1145,101035) -- хирург
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Наблюдение.Хирургия where ds like'Z%' -- убираем все Z-ки
--DELETE from Наблюдение.Хирургия where ds like'U07%' -- убираем COVID

DELETE from Наблюдение.Хирургия where cnt=1 -- убираем все единичные диагнозы
/*
delete from Наблюдение.Хирургия where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Хирургия where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100
*/

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.Хирургия);
update Наблюдение.Хирургия set total=@total

update Наблюдение.Хирургия set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.Хирургия ORDER BY cnt desc
GO
-- хирург

-- урология, 145 (N)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Урология')) 
	DROP TABLE Наблюдение.Урология
CREATE TABLE Наблюдение.Урология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Урология ADD CONSTRAINT PK_urology_observatione PRIMARY KEY (ds)

--select 145 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Урология from
insert into Наблюдение.Урология
select 145 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1165,101085)
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Наблюдение.Урология where ds like'Z%' -- убираем все Z-ки
--DELETE from Наблюдение.Урология where ds like'U07%' -- убираем COVID

DELETE from Наблюдение.Урология where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.Урология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Урология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.Урология);
update Наблюдение.Урология set total=@total

update Наблюдение.Урология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.Урология ORDER BY cnt desc
go
-- урология

-- травматолог-ортопед, 28
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Травматология')) 
	DROP TABLE Наблюдение.Травматология

CREATE TABLE Наблюдение.Травматология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Травматология ADD CONSTRAINT PK_traumatology_observatione PRIMARY KEY (ds)

--select 28 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Травматология from
insert into Наблюдение.Травматология
select 28 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1155,101045)
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 

DELETE from Наблюдение.Травматология where ds like'Z%' -- убираем все Z-ки
--DELETE from Наблюдение.Травматология where ds like'U07%' -- убираем COVID

DELETE from Наблюдение.Травматология where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.Травматология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Травматология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.Травматология);
update Наблюдение.Травматология set total=@total

update Наблюдение.Травматология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.Травматология ORDER BY cnt desc
go
-- травматолог-ортопед

-- онкология, 17 (N,C,D)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Онкология')) 
	DROP TABLE Наблюдение.Онкология

CREATE TABLE Наблюдение.Онкология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Онкология ADD CONSTRAINT PK_oncologia_observatione PRIMARY KEY (ds)

--select 17 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Онкология from
insert into Наблюдение.Онкология
select 17 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1195,1722,1757,101751) -- онкология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Наблюдение.Онкология where ds like'Z%' -- убираем все Z-ки
DELETE from Наблюдение.Онкология where ds like'U07%' -- убираем COVID

DELETE from Наблюдение.Онкология where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.Онкология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Онкология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.Онкология);
update Наблюдение.Онкология set total=@total

update Наблюдение.Онкология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.Онкология ORDER BY cnt desc
go
-- онкология

-- офтальмология, 20 (Диагноз H)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Офтальмология')) 
	DROP TABLE Наблюдение.Офтальмология

CREATE TABLE Наблюдение.Офтальмология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Офтальмология ADD CONSTRAINT PK_ophthalmologia_observatione PRIMARY KEY (ds)

--select 20 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Офтальмология from
insert into Наблюдение.Офтальмология
select 20 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1265,101065) -- офтальмология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Наблюдение.Офтальмология where ds like'Z%' -- убираем все Z-ки
DELETE from Наблюдение.Офтальмология where ds like'U07%' -- убираем COVID

DELETE from Наблюдение.Офтальмология where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.Офтальмология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Офтальмология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.Офтальмология);
update Наблюдение.Офтальмология set total=@total

update Наблюдение.Офтальмология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.Офтальмология ORDER BY cnt desc
go
-- офтальмология

-- ЛОР, 19 (Диагноз J,H)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.ЛОР')) 
	DROP TABLE Наблюдение.ЛОР

CREATE TABLE Наблюдение.ЛОР (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.ЛОР ADD CONSTRAINT PK_lor_observatione PRIMARY KEY (ds)

--select 19 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.ЛОР from
insert into Наблюдение.ЛОР
select 19 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1275,10105)
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Наблюдение.ЛОР where ds like'Z%' -- убираем все Z-ки
--DELETE from Наблюдение.ЛОР where ds like'U07%' -- убираем COVID

DELETE from Наблюдение.ЛОР where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.ЛОР where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.ЛОР where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.ЛОР);
update Наблюдение.ЛОР set total=@total

update Наблюдение.ЛОР set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.ЛОР ORDER BY cnt desc
go
-- ЛОР

-- Неврология, 14 (Диагнозы I,M,G)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Неврология')) 
	DROP TABLE Наблюдение.Неврология

CREATE TABLE Наблюдение.Неврология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Неврология ADD CONSTRAINT PK_neurology_observatione PRIMARY KEY (ds)

--select 14 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Неврология from
insert into Наблюдение.Неврология
select 14 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1305,1306,101165)
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Наблюдение.Неврология where ds like'Z%' -- убираем все Z-ки
--DELETE from Наблюдение.Неврология where ds like'U07%' -- убираем COVID

DELETE from Наблюдение.Неврология where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.Неврология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Неврология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.Неврология);
update Наблюдение.Неврология set total=@total

update Наблюдение.Неврология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.Неврология ORDER BY cnt desc
go
-- Неврология

-- Дерматовенерология, 10 (L,B)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Дерматовенерология')) 
	DROP TABLE Наблюдение.Дерматовенерология

CREATE TABLE Наблюдение.Дерматовенерология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Дерматовенерология ADD CONSTRAINT PK_Dermatovenerology_observatione PRIMARY KEY (ds)

--select 10 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Дерматовенерология from
insert into Наблюдение.Дерматовенерология
select 10 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1335,101115) -- Дерматовенерология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Наблюдение.Дерматовенерология where ds like'Z%' -- убираем все Z-ки
DELETE from Наблюдение.Дерматовенерология where ds like'U07%' -- убираем COVID

DELETE from Наблюдение.Дерматовенерология where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.Дерматовенерология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Дерматовенерология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.Дерматовенерология);
update Наблюдение.Дерматовенерология set total=@total

update Наблюдение.Дерматовенерология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.Дерматовенерология ORDER BY cnt desc
go
-- Дерматовенерология

-- Ревматология, 91 (Диагнозы M)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Ревматология')) 
	DROP TABLE Наблюдение.Ревматология

CREATE TABLE Наблюдение.Ревматология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Ревматология ADD CONSTRAINT PK_reumatology_observatione PRIMARY KEY (ds)

--select 91 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Ревматология from
insert into Наблюдение.Ревматология
select 10 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1375,1377,1713,1772) -- Ревматология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Наблюдение.Ревматология where ds like'Z%' -- убираем все Z-ки
--DELETE from Наблюдение.Ревматология where ds like'U07%' -- убираем COVID

DELETE from Наблюдение.Ревматология where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.Ревматология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Ревматология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.Ревматология);
update Наблюдение.Ревматология set total=@total

update Наблюдение.Ревматология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.Ревматология ORDER BY cnt desc
go
-- Ревматология

-- Аллергология 255, (Диагнозы J,L)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Аллергология')) 
	DROP TABLE Наблюдение.Аллергология

CREATE TABLE Наблюдение.Аллергология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Аллергология ADD CONSTRAINT PK_allergology_observatione PRIMARY KEY (ds)

--select 255 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Аллергология from
insert into Наблюдение.Аллергология
select 255 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1415,101095) -- Аллергология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Наблюдение.Аллергология where ds like'Z%' -- убираем все Z-ки
--DELETE from Наблюдение.Аллергология where ds like'U07%' -- убираем COVID

DELETE from Наблюдение.Аллергология where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.Аллергология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Аллергология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.Аллергология);
update Наблюдение.Аллергология set total=@total

update Наблюдение.Аллергология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.Аллергология ORDER BY cnt desc
go
-- Аллергология

-- Пульмонология, 262 (Диагноз J)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Пульмонология')) 
	DROP TABLE Наблюдение.Пульмонология

CREATE TABLE Наблюдение.Пульмонология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Пульмонология ADD CONSTRAINT PK_pulmonology_observatione PRIMARY KEY (ds)

--select 262 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Пульмонология from
insert into Наблюдение.Пульмонология
select 262 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1435,1716,1775,101729,101906) -- Пульмонология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Наблюдение.Пульмонология where ds like'Z%' -- убираем все Z-ки
--DELETE from Наблюдение.Пульмонология where ds like'U07%' -- убираем COVID

DELETE from Наблюдение.Пульмонология where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.Пульмонология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Пульмонология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.Пульмонология);
update Наблюдение.Пульмонология set total=@total

update Наблюдение.Пульмонология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.Пульмонология ORDER BY cnt desc
go
-- Пульмонология

-- Гинекология, 8 (Диагнозы N)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Гинекология')) 
	DROP TABLE Наблюдение.Гинекология

CREATE TABLE Наблюдение.Гинекология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Гинекология ADD CONSTRAINT PK_gynaecologia_observatione PRIMARY KEY (ds)

--select 8 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Гинекология from
insert into Наблюдение.Гинекология
select 8 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1445,101072) -- Гинекология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Наблюдение.Гинекология where ds like'Z%' -- убираем все Z-ки
--DELETE from Наблюдение.Гинекология where ds like'U07%' -- убираем COVID

DELETE from Наблюдение.Гинекология where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.Гинекология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Гинекология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.Гинекология);
update Наблюдение.Гинекология set total=@total

update Наблюдение.Гинекология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.Гинекология ORDER BY cnt desc
go
-- Гинекология

-- Колопроктология, 43 (Диагнозы K)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Колопроктология')) 
	DROP TABLE Наблюдение.Колопроктология

CREATE TABLE Наблюдение.Колопроктология (prvs dec(4) not null, ds char(6) not null, name varchar(160), 
	cnt int not null default 0, prevalence decimal(7,6), total int not null default 0)
ALTER TABLE Наблюдение.Колопроктология ADD CONSTRAINT PK_coloproctology_observatione PRIMARY KEY (ds)

--select 43 as prvs, a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Колопроктология from
insert into Наблюдение.Колопроктология
select 43 as prvs, a.ds as ds, b.name as name, a.cnt as cnt, 0 as prevalence, 0 as total from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1465,1717,1776,101763) -- Колопроктология
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
DELETE from Наблюдение.Колопроктология where ds like'Z%' -- убираем все Z-ки
--DELETE from Наблюдение.Колопроктология where ds like'U07%' -- убираем COVID

DELETE from Наблюдение.Колопроктология where cnt=1 -- убираем все единичные диагнозы

delete from Наблюдение.Колопроктология where left(ds,1) not in (
select ds from (
select top 3 left(ds,1) as ds, COUNT(*) as _cnt 
	from Наблюдение.Колопроктология where cnt>=100 group by left(ds,1) order by _cnt desc) a) and cnt<100

declare @total int;
set @total = (select sum(cnt) as total from Наблюдение.Колопроктология);
update Наблюдение.Колопроктология set total=@total

update Наблюдение.Колопроктология set prevalence = cast(cnt as decimal) / cast(total as decimal)

--SELECT * FROM Наблюдение.Колопроктология ORDER BY cnt desc
go
-- Гинекология

/*
Скрипт выше формирует справочник соответствий диагноз-профиль МП для каждового профиля МП отдельно
Скрипт ниже соибрает все справочники в один
*/

IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.[Все специальности]')) 
	DROP TABLE Наблюдение.[Все специальности]
select top 1 * into Наблюдение.[Все специальности] from Наблюдение.Аллергология
truncate table  Наблюдение.[Все специальности]

insert into Наблюдение.[Все специальности]
--select * into Наблюдение.[Все специальности] from
select * from 
(
select * from Наблюдение.Аллергология 
union all 
select * from Наблюдение.Гастроэнтерология
union all 
select * from Наблюдение.Гематология
union all 
select * from Наблюдение.Гинекология
union all 
select * from Наблюдение.Дерматовенерология
union all 
select * from Наблюдение.Инфекция
union all 
select * from Наблюдение.Кардиология
union all 
select * from Наблюдение.Колопроктология
union all 
select * from Наблюдение.ЛОР
union all 
select * from Наблюдение.ЛФК
union all 
select * from Наблюдение.Неврология
union all 
select * from Наблюдение.Нефрология
union all 
select * from Наблюдение.Онкология
union all 
select * from Наблюдение.Офтальмология
union all 
select * from Наблюдение.Пульмонология
union all 
select * from Наблюдение.Ревматология
union all 
select * from Наблюдение.Терапия
union all 
select * from Наблюдение.Травматология
union all 
select * from Наблюдение.Урология
union all 
select * from Наблюдение.Физиотерапия
union all 
select * from Наблюдение.Хирургия
union all 
select * from Наблюдение.Эндокринология
) a
create index idx_allspecs on Наблюдение.[Все специальности] (prvs,ds)
go 

declare @total int
select @total =  sum(total) from 
	(select prvs, max(total) as total from [Диагнозы].[Все специальности] group by prvs) a
select @total
update [Диагнозы].[Все специальности] set total=@total
update [Диагнозы].[Все специальности] set prevalence = cast(cnt as decimal) / cast(total as decimal)
go





IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('Наблюдение.Кардиология')) DROP TABLE Наблюдение.Кардиология
select a.ds as ds, b.name as name, a.cnt as cnt into Наблюдение.Кардиология from
	(select ds, COUNT(distinct sn_pol) as cnt from dbo.FactServices a
	where cod in (1045,101105)
	group by ds) a 
	join dim.ds b on a.ds=b.code order by cnt desc 
