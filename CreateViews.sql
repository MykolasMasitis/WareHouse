/*
-- Перенос tempdb
Use master
GO

SELECT 
name AS [LogicalName]
,physical_name AS [Location]
,state_desc AS [Status]
FROM sys.master_files
WHERE database_id = DB_ID(N'tempdb');
GO

USE master;
GO

ALTER DATABASE tempdb 
MODIFY FILE (NAME = tempdev, FILENAME = 'D:\MSSQL\DATA\tempdb.mdf');
GO

ALTER DATABASE tempdb 
MODIFY FILE (NAME = templog, FILENAME = 'D:\MSSQL\Log\templog.ldf');
GO
*/

use i3
go 

alter table facts.services add num tinyint
go 

with cte (period,mcod,recid_lpu, num) as
(
select period,mcod,recid_lpu, ROW_NUMBER() over (partition by sn_pol,otd,ds,cod,d_u,pcod order by recid_lpu) as num
	from facts.services
)
update facts.Services set num=cte.num from cte 
	join facts.Services on cte.period=facts.Services.period and 
		cte.mcod=facts.Services.mcod and 
		cte.recid_lpu=facts.Services.recid_lpu
go 
select sn_pol,otd,ds,cod,d_u,pcod,num,recid_lpu from facts.Services where sn_pol='0157040896000095' and ds='D27' order by d_u
go 

IF OBJECT_ID('facts.vw_services','V') IS NOT NULL DROP VIEW facts.vw_services
GO
create view facts.vw_services with schemabinding as
	select a.period, a.mcod, /*b.fullname as headname,*/ c.fullname as branchname,
	sn_pol, c_i, ages, a.sex, cod, d.name as servname, d_u, k_u, tarif, s_all,
	s_lek, kd_fact, a.n_kd, otd, pcod,
	ds, e.name as dsname, /*profil, f.name,*/
	rslt, g.name as rsltname, prvs, h.name as prvsname, ishod, i.name as ishodname,
	p_cel, j.name as p_celname/*, num*/ from facts.Services a
	/*join dim.sprlpu b on a.lpuid=b.fil_id*/
	join dim.sprlpu c on a.fil_id=c.fil_id
	join dim.Tarif d on a.cod=d.code
	join dim.Ds e on a.ds=e.code
	-- join dim.ProfOt f on a.profil=f.code
	join dim.Rslt g on a.rslt=g.code
	join dim.Prvs h on a.prvs=h.code
	join dim.Ishod i on a.ishod=i.code
	join dim.p_cel j on a.p_cel=j.code
go 

Create unique clustered index pk_vw_services on facts.vw_services 
	(sn_pol,ds,cod,d_u,otd,pcod/*,num*/) 
	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, 
	IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, 
	ALLOW_PAGE_LOCKS = ON) on [FastGrowingFiles]
ALTER INDEX ALL ON facts.vw_services REBUILD
drop index pk_vw_services on facts.vw_services
go 
select top 150 * from facts.vw_services
go

declare @PageNumber int = 1
declare @PageSize int = 10
select * from facts.vw_services 
	order by sn_pol,ds,cod,d_u,otd,pcod,num offset @PageSize * (@PageNumber - 1) rows 
	fetch next @PageSize rows only OPTION (RECOMPILE)
go

--UPDATE STATISTICS facts.vw_services pk_vw_services WITH FULLSCAN
go 




select a.*, b.name, c.name from facts.Services a
join dim.Tarif b on a.cod=b.code
join dim.Ds c on a.ds=c.code
where sn_pol='0170860874000087 ' order by d_u asc

