-- c_zab=2 - впервые в жизни установленные хрон заб похоже, наконец, правильный ответ!!!
;with cte as
(select sn_pol, ds from [Заболеваемость].[Все приемы] 
	where c_zab=2
	group by sn_pol,ds)
select COUNT(*) from cte
-- 3 446 821
-- c_zab=2 - впервые в жизни установленные хрон заб похоже, наконец, правильный ответ!!!

-- хотим посчитать процент значений более 1
--select cnt*100.0/COUNT(*) from dim.Sex 
--join 
--(select COUNT(*) as cnt from dim.Sex where cast(code as int)>1) t1 on 1=1
--group by cnt

-- и второй вариант
--select 
--	SUM(case when cast(code as int)>1 then 1 else 0 end)*100.0/COUNT(*) 
--	from dim.Sex

--;with cte as
--(select p_cel, count(*) as cnt from [Заболеваемость].[Первичные приемы] group by p_cel)
--select cte.p_cel, b.name, cnt from cte	
--	join dim.p_cel b on cte.p_cel=b.code order by cnt desc

--;with cte as
--(select p_cel, count(*) as cnt from [Заболеваемость].[Все приемы] group by p_cel)
--select cte.p_cel, b.name, cnt from cte	
--	join dim.p_cel b on cte.p_cel=b.code order by cnt desc
--go
--select top 100 * from [Заболеваемость].[Все приемы] order by caseid, n_obr
--;with cte as
--(select sn_pol, LEFT(ds,3) as ds, COUNT(*) as cnt 
--	from [Заболеваемость].[Все приемы] group by sn_pol, left(ds,3))
--select cnt, COUNT(*) as c_nt from cte group by cnt

--ALTER DATABASE lpu SET SINGLE_USER WITH ROLLBACK IMMEDIATE
--ALTER DATABASE lpu SET MULTI_USER 

declare @schema varchar(50) = 'dim'
declare @table varchar(50) = 'Ds'
declare @command varchar(250) = 'select top 20 * from '+quotename(@schema)+'.'+quotename(@table)
select @command
exec (@command)

-- Переключаемся на рабочую базу
use lpu
go

-- теперь надо попробовать


-- отбираем все первичные приемы

-- select DB_ID('lpu')
--select top 1000 sn_pol,mcod,ds,c_zab,c.name, cod,b.name,d_u from Заболеваемость.[Первичные приемы] a
--join dim.Tarif b on a.cod=b.code
--join dim.Ds c on a.ds=c.code
--where sn_pol+ds in (
--select sn_pol+ds from Заболеваемость.[Первичные приемы] group by sn_pol,ds having COUNT(*)>1)
--order by sn_pol, ds, d_u asc

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

-- попробуем отобрать острые диагнозы по признаку c_zab
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dim.AcuteIllnesses')) 
	DROP TABLE dim.AcuteIllnesses
;with cte as 
	(select ds, COUNT(*) as cnt from [Заболеваемость].[Первичные приемы] a 
		where c_zab=1 group by ds)
select CAST(a.ds as char(6)) as ds, b.name, a.cnt as cnt, 
	(select sum(cnt) from cte) as total
	 into dim.AcuteIllnesses -- острые заболевания
	from dim.Ds b
	join cte a on b.code=a.ds
	order by a.cnt desc 
alter table dim.AcuteIllnesses drop column prevalance
alter table dim.AcuteIllnesses add prevalance as cast(cast(cnt as dec)/total as dec(11,9))

select * from [dim].[AcuteIllnesses] order by cnt desc

declare @total int = (select sum(cnt) from dim.AcuteIllnesses)
alter table dim.AcuteIllnesses add Total int default 0
update dim.AcuteIllnesses set Total = @total

-- и хронические заболевания
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dim.ChronicIllnesses')) 
	DROP TABLE dim.ChronicIllnesses
;with cte as 
	(select ds, COUNT(*) as cnt from [Заболеваемость].[Первичные приемы] a 
		where c_zab in (2,3) group by ds)
select CAST(a.ds as char(6)) as ds, b.name, a.cnt as cnt, 
	(select sum(cnt) from cte) as total
	 into dim.ChronicIllnesses -- острые заболевания
	from dim.Ds b
	join cte a on b.code=a.ds
	order by a.cnt desc 
alter table dim.ChronicIllnesses add prevalance as cast(cast(cnt as dec)/total as dec(11,9))
go
-- похоже на правду!

select top 100 * from dim.AcuteIllnesses order by prevalance desc
select COUNT(*) from dim.AcuteIllnesses

select top 100 * from dim.ChronicIllnesses order by prevalance desc
select COUNT(*) from dim.ChronicIllnesses

select a.*, b.* from [dim].[ChronicIllnesses] a
	left outer join [dim].[AcuteIllnesses] b on a.ds=b.ds
	where a.prevalance/b.prevalance>=10
	order by a.prevalance desc

select COUNT(*) from [dim].[AcuteIllnesses] a
	inner join [dim].[ChronicIllnesses] b on a.ds=b.ds
go

create view dim.[ОстрыеХронические] as 
	with cte_1 (AcuteDs, Acutecnt) as (select ds, cnt from dim.AcuteDeseases),
	cte_2 (ChronicDs, ChronicCnt) as (select ds, cnt from dim.ChronicDeseases)
	select code 'Код', name 'Наименование', 
		coalesce(Acutecnt,0) as 'Острых', 
		coalesce(ChronicCnt,0) as 'Хронических' from dim.Ds a
	left outer join cte_1 on a.code = cte_1.AcuteDs
	left outer join cte_2 on a.code = cte_2.ChronicDs
	where Acutecnt>0 or ChronicCnt>0
go 

-- так можно посмотреть самые распространенные хронические или острые диагнозы!
select top 50 * from [dim].[ОстрыеХронические] where [Острых]>0 order by [Острых] desc
select top 50 * from [dim].[ОстрыеХронические] where [Острых]>0 order by [Хронических] desc
go 

-- попробуем считать острыми те, которые больше, чем в 2 раза, чем хронических
declare @times int = 2
select [Код], [Наименование], [Острых], [Хронических] from [dim].[ОстрыеХронические] where [Хронических]=0 or [Острых]/[Хронических] > @times order by [Острых] desc
select [Код], [Наименование], [Хронических], [Острых] from [dim].[ОстрыеХронические] where [Острых]=0 or [Хронических]/[Острых] >= @times order by [Хронических] desc
go 
-- так можно посмотреть самые распространенные хронические или острые диагнозы!

-- цель - заполнить c_zab там, где его значение - 0 (не определено). Таких 5 млн (более половины!)
select c_zab, count(*)
from [Заболеваемость].[Первичные приемы] group by c_zab

-- создан бэкап 01092022.baj
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

/*
Хронические заболевания:
	1. Болезни системы кровообращения (БСК)
		- артериальную гипертонию, 
		- хроническую ишемическую болезнь сердца и стенокардию, 
		- острое нарушение мозгового кровообращения, 
		- нарушения сердечного ритма, 
		- хроническую сердечную недостаточность
	2. Бронхо-легочные заболевания
		- хронический необструктивный бронхит,
		- бронхиальная астма,
		- кистозный фиброз,
		- эмфизема легких,
		- саркоидоз легких,
		- хроническая пневмония.
	3. онкологические заболевания
	4. Сахарный диабет

На хронические заболевания статистический талон заполняется только один раз в году 
при первом обращении. Знак «+» ставится в том случае, если хроническое заболевание 
выявлено у больного впервые в жизни. При первом обращении больного в данном году 
по поводу обострения хронического заболевания, выявленного в предыдущие годы, 
ставится знак «минус» (–). При повторных обращениях в данном году по поводу 
обострений хронических заболеваний диагноз не регистрируется. 

На каждое острое заболевание в разделе «впервые установленный диагноз» ставится знак «+». 

Первичная заболеваемость - впервые в жизни диагностированные заболевания в течение определенного периода (год)
Общая заболеваемость - все заболевания населения, имевшие место за определенный период (год): острые,
	хронические, новые и известные ранее

*/


