use lpu
go

IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('facts.dsp')) 
	DROP TABLE facts.dsp
CREATE TABLE facts.dsp (
	-- на эту таблицу будут (могут) ссылать другие фактические таблицы, поэтому первичный ключ нужен
	recid int NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED, 
	q char(2), period char(7), mcod char(7), 
	sn_pol varchar(25),	c_i varchar(30), ds char(6), 
	fam varchar(40), im varchar(40), ot varchar(40), dr date, ages dec(3), sex dec(1), 
	cod dec(6),	rslt dec(3), d_u date, s_all dec(10,2),	er char(3),	tip tinyint,
	c_zab dec(1), p_cel char(3), dn dec(1), healthGr varchar(5)) ON [FastGrowingFiles] /*ON ServicesPartScheme(Year)*/
GO

-- Загружаем предварительно выгруженные из lpu2smo файлы dsp
SET DATEFORMAT DMY
-- S7
 bulk insert facts.dsp from '\\s01-9700-db05\lpu2smo\base\202112\dsp.csv'
	with (fieldterminator=';', firstrow=1, codepage=1251, ROWTERMINATOR = '\n')
-- I3
 bulk insert facts.dsp from '\\s01-9700-db05\lpu2smo\basei3\202112\dsp.csv'
	with (fieldterminator=';', firstrow=1, codepage=1251, ROWTERMINATOR = '\n')
-- R4
 bulk insert facts.dsp from '\\s01-9700-db05\lpu2smo\baser4\202112\dsp.csv'
	with (fieldterminator=';', firstrow=1, codepage=1251, ROWTERMINATOR = '\n')
-- Загружаем предварительно выгруженные из lpu2smo файлы dsp
--select count(*) from [facts].[dsp]
-- снятые на МЭК удаляем
delete from [facts].[dsp] where er is not null
-- снятые на МЭК удаляем

-- УД первого этапа - удаляем
delete from [facts].[dsp] where cod in (1975,1976)
-- УД первого этапа - удаляем

-- посмотрим, остались ли дубли по sn_pol,d_u,ds
;with cte as
(select sn_pol, d_u, ds, count(*) as cnt from [facts].[dsp] group by sn_pol,d_u,ds)
select * from [facts].[dsp] a
 join cte b on a.sn_pol=b.sn_pol and a.d_u=b.d_u and a.ds=b.ds where b.cnt>1
 order by a.sn_pol
-- и, если остались, удаляем все, кроме первого
;WITH duplicateRemoval as (
    SELECT 
        sn_pol,d_u,ds
        ,ROW_NUMBER() OVER(PARTITION BY sn_pol,d_u,ds ORDER BY sn_pol,d_u,ds) ranked
    from [facts].[dsp]
)
DELETE
FROM duplicateRemoval
WHERE ranked > 1;
-- посмотрим, остались ли дубли по sn_pol,d_u,ds

-- посмотрим, какие rslt
;with cte as (
select rslt, count(*) as cnt from [facts].[dsp] group by rslt)
select cte.rslt, cte.cnt, b.name from cte 
left outer join dim.Rslt b on cte.rslt=b.code order by rslt desc
-- посмотрим, какие rslt

-- устанавливаем группы здоровья
--alter table [facts].[dsp] add healthGr varchar(5)
update [facts].[dsp] set healthGr = 
(
	case 
		when rslt in ('317','343','347','332','321') then '1'
		when rslt in ('318','353','344','348','362','361','333','322') then '2'
		when rslt in ('357','355','357','373') then '3а'
		when rslt in ('358','356','358','374') then '3б'
		when rslt in ('362','349','334','323') then '3'
		when rslt in ('363','350','335','324') then '4'
		when rslt in ('364','351','336','325') then '5'
	end
)

;with cte as
(select ds, count(*) as cnt from [facts].[dsp] group by ds)
select b.code, b.name, cte.cnt from cte
	join dim.Ds b on cte.ds=b.code
	where LEFT(cte.ds,1)!='Z'
	order by cte.cnt desc

select c_zab, COUNT(*) from [facts].[dsp] group by c_zab
select dn, COUNT(*) from [facts].[dsp] group by dn


select COUNT(distinct sn_pol) from [facts].[dsp]
-- 567979 человек прошли диспансеризацию

-- 1. Обнуляем ранее расчитанные значения
update Статистика.Ф12_Т0000_2021
	set n_cases = 0, n_p1000=0

-- 2. расчет первой строки -итоговой заболеваемости
-- вариант с общей заболеваемостью
update Статистика.Ф12_Т0000_2021
	set n_cases = outertable.cnt
	from 
		(select count(*) as cnt from [facts].[dsp] a 
			left join dim.Ds b on a.ds=b.code 
			where 
			(ds between 'A00' and 'T98.99'or ds in ('U07.1', 'U07.2')) 
			and b.f12t1000str is not null) as outertable
	where n_str='1'
update Статистика.Ф12_Т0000_2021
	set n_cases = outertable.cnt
	from 
		( select f12t1000str, count(*) as cnt from [facts].[dsp] a 
			left join dim.Ds b on a.ds=b.code 
			where 
			b.f12t1000str is not null 
			group by f12t1000str) as outertable
	where n_str=outertable.f12t1000str
-- вариант с общей заболеваемостью

-- 2. расчет первой строки -итоговой заболеваемости
-- вариант с первичной заболеваемостью
update Статистика.Ф12_Т0000_2021
	set n_cases = outertable.cnt
	from 
		(select count(*) as cnt from [facts].[dsp] a 
			left join dim.Ds b on a.ds=b.code where 
			-- острые (1), первичные хронические (2), раз в год хронические (3)
			(ds between 'A00' and 'T98.99'or ds in ('U07.1', 'U07.2')) 
			and b.f12t1000str is not null) as outertable
	where n_str='1'
update Статистика.Ф12_Т0000_2021
	set n_cases = outertable.cnt
	from 
		( select f12t1000str, count(*) as cnt from [facts].[dsp] a 
			left join dim.Ds b on a.ds=b.code 
			where 
			-- острые (1), первичные хронические (2), раз в год хронические (3)
			b.f12t1000str is not null 
			group by f12t1000str) as outertable
	where n_str=outertable.f12t1000str
-- вариант с первичной заболеваемостью

-- после заполнения заполенены только субстроки!

select * from Статистика.Ф12_Т0000_2021 where _substr=0

select sum(n_p1000) from [Статистика].[Ф12_Т0000_2021] where _str>1 and _substr=0
go

-- Заполняем строки вида 1,2,3 и т.д.
with cte (_str, _substr, _ssubstr, qwerty) as
(select _str, _substr, _ssubstr, sum(n_cases) over (partition by _str) as qwerty from Статистика.Ф12_Т0000_2021)
update Статистика.Ф12_Т0000_2021 set n_cases = cte.qwerty from cte
join Статистика.Ф12_Т0000_2021 on cte._str=Статистика.Ф12_Т0000_2021._str and 
	cte._substr=Статистика.Ф12_Т0000_2021._substr and 
	cte._ssubstr=Статистика.Ф12_Т0000_2021._ssubstr where Статистика.Ф12_Т0000_2021._str>0 and Статистика.Ф12_Т0000_2021._substr=0
go
-- Заполняем подстроки  вида 1.1,1.2,1.3 и т.д При наличии суб-субстрок должны появится цифры...
with cte (_str, _substr, _ssubstr, qwerty) as
(select _str, _substr, _ssubstr, sum(n_cases) over (partition by _str, _substr) as qwerty from Статистика.Ф12_Т0000_2021)
update Статистика.Ф12_Т0000_2021 set n_cases = cte.qwerty from cte
join Статистика.Ф12_Т0000_2021 on cte._str=Статистика.Ф12_Т0000_2021._str and cte._substr=Статистика.Ф12_Т0000_2021._substr and cte._ssubstr=Статистика.Ф12_Т0000_2021._ssubstr 
	where Статистика.Ф12_Т0000_2021._str>0 and Статистика.Ф12_Т0000_2021._substr>0 and Статистика.Ф12_Т0000_2021._ssubstr=0
go

-- Пересчитываем в случаев на 1000 человек
DECLARE @people int = 567979 -- это средняя численность населения по I3+R4+S7. На эту цифру делить!
--update [Статистика].[Ф12_Т0000_2021] set n_p1000 = (n_cases/@people) * 1000
update [Статистика].[Ф12_Т0000_2021] set n_p1000 = round(n_cases/598,1)
go



