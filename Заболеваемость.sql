-- c_zab=2 - ������� � ����� ������������� ���� ��� ������, �������, ���������� �����!!!
;with cte as
(select sn_pol, ds from [��������������].[��� ������] 
	where c_zab=2
	group by sn_pol,ds)
select COUNT(*) from cte
-- 3 446 821
-- c_zab=2 - ������� � ����� ������������� ���� ��� ������, �������, ���������� �����!!!

-- ����� ��������� ������� �������� ����� 1
--select cnt*100.0/COUNT(*) from dim.Sex 
--join 
--(select COUNT(*) as cnt from dim.Sex where cast(code as int)>1) t1 on 1=1
--group by cnt

-- � ������ �������
--select 
--	SUM(case when cast(code as int)>1 then 1 else 0 end)*100.0/COUNT(*) 
--	from dim.Sex

--;with cte as
--(select p_cel, count(*) as cnt from [��������������].[��������� ������] group by p_cel)
--select cte.p_cel, b.name, cnt from cte	
--	join dim.p_cel b on cte.p_cel=b.code order by cnt desc

--;with cte as
--(select p_cel, count(*) as cnt from [��������������].[��� ������] group by p_cel)
--select cte.p_cel, b.name, cnt from cte	
--	join dim.p_cel b on cte.p_cel=b.code order by cnt desc
--go
--select top 100 * from [��������������].[��� ������] order by caseid, n_obr
--;with cte as
--(select sn_pol, LEFT(ds,3) as ds, COUNT(*) as cnt 
--	from [��������������].[��� ������] group by sn_pol, left(ds,3))
--select cnt, COUNT(*) as c_nt from cte group by cnt

--ALTER DATABASE lpu SET SINGLE_USER WITH ROLLBACK IMMEDIATE
--ALTER DATABASE lpu SET MULTI_USER 

declare @schema varchar(50) = 'dim'
declare @table varchar(50) = 'Ds'
declare @command varchar(250) = 'select top 20 * from '+quotename(@schema)+'.'+quotename(@table)
select @command
exec (@command)

-- ������������� �� ������� ����
use lpu
go

-- ������ ���� �����������


-- �������� ��� ��������� ������

-- select DB_ID('lpu')
--select top 1000 sn_pol,mcod,ds,c_zab,c.name, cod,b.name,d_u from ��������������.[��������� ������] a
--join dim.Tarif b on a.cod=b.code
--join dim.Ds c on a.ds=c.code
--where sn_pol+ds in (
--select sn_pol+ds from ��������������.[��������� ������] group by sn_pol,ds having COUNT(*)>1)
--order by sn_pol, ds, d_u asc

/*
c_zab=1 - ������ 
c_zab=2 - ������� � ����� ������������� �����������,
c_zab=3 - ����� ������������� �����������
*/
select c_zab, count(*), COUNT(distinct sn_pol)
from [��������������].[��������� ������]
group by c_zab
go 
--c_zab                                               
--------------------------------------- ----------- -----------
--2                                       1608447     1031137
--3                                       412283      258168
--1                                       2983208     1711027
--0                                       5183905     2327436

-- ��������� �������� ������ �������� �� �������� c_zab
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dim.AcuteIllnesses')) 
	DROP TABLE dim.AcuteIllnesses
;with cte as 
	(select ds, COUNT(*) as cnt from [��������������].[��������� ������] a 
		where c_zab=1 group by ds)
select CAST(a.ds as char(6)) as ds, b.name, a.cnt as cnt, 
	(select sum(cnt) from cte) as total
	 into dim.AcuteIllnesses -- ������ �����������
	from dim.Ds b
	join cte a on b.code=a.ds
	order by a.cnt desc 
alter table dim.AcuteIllnesses drop column prevalance
alter table dim.AcuteIllnesses add prevalance as cast(cast(cnt as dec)/total as dec(11,9))

select * from [dim].[AcuteIllnesses] order by cnt desc

declare @total int = (select sum(cnt) from dim.AcuteIllnesses)
alter table dim.AcuteIllnesses add Total int default 0
update dim.AcuteIllnesses set Total = @total

-- � ����������� �����������
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dim.ChronicIllnesses')) 
	DROP TABLE dim.ChronicIllnesses
;with cte as 
	(select ds, COUNT(*) as cnt from [��������������].[��������� ������] a 
		where c_zab in (2,3) group by ds)
select CAST(a.ds as char(6)) as ds, b.name, a.cnt as cnt, 
	(select sum(cnt) from cte) as total
	 into dim.ChronicIllnesses -- ������ �����������
	from dim.Ds b
	join cte a on b.code=a.ds
	order by a.cnt desc 
alter table dim.ChronicIllnesses add prevalance as cast(cast(cnt as dec)/total as dec(11,9))
go
-- ������ �� ������!

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

create view dim.[�����������������] as 
	with cte_1 (AcuteDs, Acutecnt) as (select ds, cnt from dim.AcuteDeseases),
	cte_2 (ChronicDs, ChronicCnt) as (select ds, cnt from dim.ChronicDeseases)
	select code '���', name '������������', 
		coalesce(Acutecnt,0) as '������', 
		coalesce(ChronicCnt,0) as '�����������' from dim.Ds a
	left outer join cte_1 on a.code = cte_1.AcuteDs
	left outer join cte_2 on a.code = cte_2.ChronicDs
	where Acutecnt>0 or ChronicCnt>0
go 

-- ��� ����� ���������� ����� ���������������� ����������� ��� ������ ��������!
select top 50 * from [dim].[�����������������] where [������]>0 order by [������] desc
select top 50 * from [dim].[�����������������] where [������]>0 order by [�����������] desc
go 

-- ��������� ������� ������� ��, ������� ������, ��� � 2 ����, ��� �����������
declare @times int = 2
select [���], [������������], [������], [�����������] from [dim].[�����������������] where [�����������]=0 or [������]/[�����������] > @times order by [������] desc
select [���], [������������], [�����������], [������] from [dim].[�����������������] where [������]=0 or [�����������]/[������] >= @times order by [�����������] desc
go 
-- ��� ����� ���������� ����� ���������������� ����������� ��� ������ ��������!

-- ���� - ��������� c_zab ���, ��� ��� �������� - 0 (�� ����������). ����� 5 ��� (����� ��������!)
select c_zab, count(*)
from [��������������].[��������� ������] group by c_zab

-- ������ ����� 01092022.baj
begin tran
update a
set c_zab = 1
--select top 1000 *
from [��������������].[��������� ������] a
join 
(select top 20 * from [dim].[�����������������] order by [������] desc) b 
on a.ds=b.���
where c_zab = 0
-- top 10: (1763801 row(s) affected)
-- top 20: (125281 row(s) affected)
-- 50 ����� �����������!
commit

begin tran
update a
set c_zab = 1
-- select top 1000 *
from [��������������].[��������� ������] a
join 
(select top 20 * from [dim].[�����������������] order by [�����������] desc) b 
on a.ds=b.���
where c_zab = 0
-- (422758 row(s) affected)
-- top 20: (181446 row(s) affected)
commit
-- ����� ����� ��� ����� ���������
--c_zab                                   
----------------------------------------- -----------
--0                                       2690619
--1                                       5476494
--2                                       1608447
--3                                       412283

-- ������� ������ ��� �����������-��������������� ��������������

-- Prevalence - ����� �������������� (������������������, �������������)
-- ������������ ���� ��������� �������������� �����������, ������� ���������� � ������ ���� �
-- ������������������ � ���������� ����, �� ������ ������� ������� ����� ���������� �� �����������
-- ������� � ������ ����
-- Incidence - ��������� �������������� (���������� ��������������) ������, ��������������� ���
-- ������� �����, ����� ����� ���������� � ������� � ������ ���� ���������� ����� ��������� �����������
IF OBJECT_ID('��������������.���������','V') IS NOT NULL DROP VIEW ��������������.���������
GO
create view ��������������.��������� with schemabinding as
(
SELECT recid, sn_pol, c_i, ages, sex, cod, d_u, ds, 
		prvs, ord, date_ord, lpu_ord, p_cel, dn, c_zab,
		ROW_NUMBER() over (partition by sn_pol, ds order by d_u asc) as n_obr
  FROM [��������������].[��������� ������] where c_zab in (1,2) -- 1-������, 2-������� � ����� ������������� �����������
)
GO
-- ���������������� ��-�� ������� ������� �������
--CREATE UNIQUE CLUSTERED INDEX
--    ix_zab_amb_perv ON ��������������.��������� (recid)
--go

-- ������ select, ����� ���������� ������� �������, �� ���������� � group
select a.code, a.name, b.cnt
from dim.Ds a
inner join
(select ds, count(*) as cnt from [��������������].[�����] a
	where c_zab=2 group by ds) as b
on a.code=b.ds 
where cnt>2
order by 3 desc

-- prevalence - ������, ��������������� ���
IF OBJECT_ID('��������������.�����','V') IS NOT NULL DROP VIEW ��������������.�����
GO
create view ��������������.����� with schemabinding as
(
SELECT recid, sn_pol, c_i, ages, sex, cod, d_u, ds, prvs, ord, date_ord, lpu_ord, p_cel, dn, c_zab,
	ROW_NUMBER() over (partition by sn_pol, ds order by d_u asc) as n_obr
  FROM [��������������].[��������� ������] where c_zab in (0,1,2,3) -- 1-������, 2-������� � ����� ������������� �����������,3-����� ������������� �����������
)
GO
CREATE UNIQUE CLUSTERED INDEX
    ix_zab_amb_common ON ��������������.����� (recid)
CREATE INDEX
    ix_zab_amb_ages ON ��������������.����� (ages) include (recid)

go
-- ������� ������ ��� ��������������

--select * from [��������������].[�����] where c_zab=1

DECLARE @people int = 5113770 -- ������� ����������� �� ���� 2021
DECLARE @adults int = 4000000 -- ��������
DECLARE @teenagers int = 0 -- ���������
DECLARE @children int = @people - @adults

select c_zab, ((count(*)*1000.0)/@adults)/7*12 as '��������� ��������' from ��������������.���������
	where ages>=18 /*and ds not like 'U07%'*/  -- 695, 669 ��� COVID
	group by c_zab

select c_zab, ((count(*)*1000.0)/@adults)/7*12 as '������������������' from ��������������.�����
	where ages>=18 /*and ds not like 'U07%'*/  -- 695, 669 ��� COVID
	group by c_zab

select ((count(*)*1000.0)/@children)/7*12 as '��������� ��������' from ��������������.���������
	where ages<18 /*and ds not like 'U07%'*/  -- 752, 749 ��� COVID
go

select a.*, b.name, c.name from facts.Services a
join dim.Tarif b on a.cod=b.code
join dim.Ds c on a.ds=c.code
where sn_pol='0247600818000200' order by d_u asc

;with cte as
(select *, ROW_NUMBER() over(partition by sn_pol order by d_u,cod) as row from facts.Services)
select COUNT(*) from cte 
join dim.Tarif b on cte.cod=b.code
where row=1 and b.name like '�����%'

;with cte as
(select *, ROW_NUMBER() over(partition by sn_pol order by d_u,cod) as row from facts.Services)
select COUNT(*) from cte 
join dim.Tarif b on cte.cod=b.code
where row=1 and b.name not like '�����%'

/*
����������� �����������:
	1. ������� ������� �������������� (���)
		- ������������ ����������, 
		- ����������� ����������� ������� ������ � �����������, 
		- ������ ��������� ��������� ��������������, 
		- ��������� ���������� �����, 
		- ����������� ��������� ���������������
	2. ������-�������� �����������
		- ����������� ��������������� �������,
		- ������������ �����,
		- ��������� ������,
		- �������� ������,
		- ��������� ������,
		- ����������� ���������.
	3. �������������� �����������
	4. �������� ������

�� ����������� ����������� �������������� ����� ����������� ������ ���� ��� � ���� 
��� ������ ���������. ���� �+� �������� � ��� ������, ���� ����������� ����������� 
�������� � �������� ������� � �����. ��� ������ ��������� �������� � ������ ���� 
�� ������ ���������� ������������ �����������, ����������� � ���������� ����, 
�������� ���� ������ (�). ��� ��������� ���������� � ������ ���� �� ������ 
���������� ����������� ����������� ������� �� ��������������. 

�� ������ ������ ����������� � ������� �������� ������������� ������� �������� ���� �+�. 

��������� �������������� - ������� � ����� ����������������� ����������� � ������� ������������� ������� (���)
����� �������������� - ��� ����������� ���������, ������� ����� �� ������������ ������ (���): ������,
	�����������, ����� � ��������� �����

*/


