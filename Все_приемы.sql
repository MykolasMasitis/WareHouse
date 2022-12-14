-- ��� ������ ������ ������������� ������������� sql
declare @schema varchar(50) = 'dim'
declare @table varchar(50) = 'Ds'
declare @command varchar(250) = 'select top 20 * from '+quotename(@schema)+'.'+quotename(@table)
select @command
exec (@command)

-- ������������� �� ������� ����. � ����� ����� ���������� �������� ���.
use lpu
go

-- ��������� ������� ������� [��� ������]
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('����������.[��� ������]')) 
	DROP TABLE ����������.[��� ������]
-- select top 1 * into ����������.[��� ������] from facts.Services
-- truncate table  ����������.[��� ������]
CREATE TABLE ����������.[��� ������] (recid int, 
	sn_pol varchar(25), c_i varchar(30), ages dec(3), sex tinyint, d_u date, ds char(6), cod dec(6),
	prvs dec(4), ord dec(1), date_ord date, lpu_ord dec(6), 
	p_cel char(3), dn dec(1), c_zab dec(1), n_obr tinyint default 0, caseid int default 0,
	ischron bit default 0, smallDs char(1),
	CONSTRAINT [pk_allappointments_recid] PRIMARY KEY NONCLUSTERED (recid))
GO
-- ������� ���� �� �������. ������ ��������� ������.
create index ix_allappointments on ����������.[��� ������] (cod) include (recid)
-- �������� ������ ������� 6,5 �����!
create index ix_allappointments_recid on ����������.[��� ������] (recid)
create index ix_allappointments_sn_pol on ����������.[��� ������] (sn_pol) include (recid)
create index ix_allappointments_ds on ����������.[��� ������] (ds) include (recid)
create index ix_allappointments_prvs on ����������.[��� ������] (prvs) include (recid)
create index ix_allappointments_p_cel on ����������.[��� ������] (p_cel) include (recid)
create index ix_allappointments_dn on ����������.[��� ������] (dn) include (recid)
create index ix_allappointments_c_zab on ����������.[��� ������] (c_zab) include (recid)
create index ix_allappointments_d_u on ����������.[��� ������] (d_u) include (recid)
create index ix_allappointments_ischron on ����������.[��� ������] (ischron) include (recid)
go
-- ��������� �������
insert into ����������.[��� ������]
	(
		recid, sn_pol, c_i, ages, sex, cod, d_u, ds, 
		prvs, ord, date_ord, lpu_ord, p_cel, dn, c_zab, smallDs
	)
select
	recid, sn_pol, c_i, ages, sex, cod, d_u, ds, 
	prvs, 
	ord, date_ord, lpu_ord, p_cel, dn, c_zab, LEFT(ds,1)
from facts.Services   
where ((cod>1000 and cod<1999) or (cod>101000 and cod<101999))
	-- ����� ����� ������ �� ����! ��� �����, �� �������.
	/* and LEFT(ds,1) not in ('V','W','X','Y','Z') */
go
-- ���������, ������� ���������� �������
select COUNT(*) from [����������].[��� ������]
-- �� ������ ���������� �����
select COUNT(*) from [facts].[Services]
-- ��� �������: 38610133 ������� �� 111751548 �����

-- �����, ��� ���� ������� ��� ������ � ���������� ������������� ���������, ������ �� ������� �����
-- �� ����!
begin tran
;with cte as
(select ds, COUNT(*) as cnt from [����������].[��� ������] group by ds)
delete a 
	from [����������].[��� ������] a
	join cte on a.ds = cte.ds
	where cte.cnt<=1
-- (547 row(s) affected) �����-��!
commit

-- �����! �����!
-- ������, �������� ����� �������� �� ��������������
-- ������� ��� ���
ALTER INDEX ALL ON [����������].[��� ������] DISABLE
ALTER INDEX ALL ON [����������].[��� ������] REBUILD
-- ������� ��� ���

alter table [����������].[��� ������] add smallDs as SUBSTRING(ds,1,1)
alter table [����������].[��� ������] add rubr as SUBSTRING(ds,1,3)

create index ix_small_ds on ����������.[��� ������] (smallDs) include (recid)
-- ����� ����� �������
alter table [����������].[��� ������] add ischron bit default 0

-- ������������� ������� �����
ALTER TABLE ����������.[��� ������]
	ADD CONSTRAINT allappointments_c_zab_FK FOREIGN KEY (c_zab) REFERENCES dim.c_zab(code)
ALTER TABLE ����������.[��� ������]
	ADD CONSTRAINT allappointments_d_u_FK FOREIGN KEY (d_u) REFERENCES dim.Dates(d_u)
ALTER TABLE ����������.[��� ������]
	ADD CONSTRAINT allappointments_ds_FK FOREIGN KEY (ds) REFERENCES dim.Ds(code)
-- ��� ����, ����� ��� ����������� ��������, �������� �������� � dim.Prvs (0,'�� ����������')
ALTER TABLE ����������.[��� ������]
	ADD CONSTRAINT allappointments_prvs_FK FOREIGN KEY (prvs) REFERENCES dim.Prvs(code)
--select prvs, COUNT(*) from [����������].[��� ������] a
--	left outer join dim.Prvs b on a.prvs=b.code
--where b.code is null 
--group by prvs order by prvs
-- 54 ����� � ������� prvs
ALTER TABLE ����������.[��� ������]
	ADD CONSTRAINT allappointments_ord_FK FOREIGN KEY (ord) REFERENCES dim.Ord(code)
-- ��� ������������ �������� �������� ������ '', '�� ���������'
ALTER TABLE ����������.[��� ������]
	ADD CONSTRAINT allappointments_p_cel_FK FOREIGN KEY (p_cel) REFERENCES dim.P_cel(code)
--select p_cel, COUNT(*) as cnt from [����������].[��� ������] a
--	left outer join dim.p_cel b on a.p_cel=b.code
--where b.code is null 
--group by p_cel
ALTER TABLE ����������.[��� ������]
	ADD CONSTRAINT allappointments_dn_FK FOREIGN KEY (dn) REFERENCES dim.Dn(code)
GO

-- ������������� ���������� ������� �� ����������� spv015!
-- �� ����!
--update ����������.[��� ������] 
--	set prvs = 
--	(case 
--		when cod in (1041,1042,1043,1044,1045,1702,1742,1780,101101,101102,101103,101105,101107,101741,101908)
--			then 118
--		when cod in (1071,1072,1073,1075,1705,1745,101121,101122,101125,101127,101130,101705,101909)
--			then 31
--		when cod in (1051,1052,1053,1055,1703,1743,101211,101212,101213,101215,101217,101731,101902)
--			then 114
--		when cod in (1061,1062,1065,1704,1744,101201,101202,101203,101205,101207,101703,101904)
--			then 89
--		when cod in (1091,1092,1093,1095,1097,1747,101131,101132,101133,101135,101137,101735)
--			then 32
--		when cod in (1081,1082,1083,1085,1706,1746,101743,101910)
--			then 16
--		when cod in (1141,1142,1143,1145,1147,1707,1750,1753,1755,1756,1780,101032,101033,101034,101035,101037,101707,101745,101911)
--			then 30
--		when cod in (1161,1162,1163,1165,1167,1709,1752,101081,101082,101083,101085,101087,101711,101905)
--			then 145
--		when cod in (1101,1102,1748,101171,101172,101771,101924)
--			then 63
--		when cod in (1111,1112,1113,1114,1115,1117,1730,1749,101181,101182,101183,101184,101185,101187,101773,101926)
--			then 59
--		when cod in (1151,1152,1153,1154,1155,1157,1708,1751,101041,101042,101045,101047,101709,101912)
--			then 28
--		when cod in (1191,1192,1193,1195,1722,1757,101751)
--			then 17
--		when cod in (1261,1262,1263,1265,1267,1710,1764,101061,101062,101065,101067,101713,101913)
--			then 20
--		when cod in (1271,1272,1273,1275,1276,1277,1278,1279,1280,1765,101051,101052,101053,101054,101055,101056,101057,101058,101059,101060,101914)
--			then 19
--		when cod in (1301,1302,1303,1305,1306,1307,1712,1767,101161,101162,101163,101165,101167,101168,101169,101170,101717,101917) -- ����������
--			then 14
--		when cod in (1331,1332,1333,1335,1337,1726,1769,101111,101112,101113,101115,1011171,101721,101916) -- �����������������
--			then 10
--		when cod in (1371,1372,1373,1375,1377,1713,1772) -- ������������
--			then 91
--		when cod in (1411,1412,1415,1714,1773,101091,101092,101093,101095,101097,101727,101907) -- ������������
--			then 255
--		when cod in (1431,1432,1433,1435,1716,1775,101729,101906) -- �������������
--			then 262
--		when cod in (1441,1442,1443,1445,1447,1727,1763,101070,101071,101072,101073,101719,101915) -- �����������
--			then 8
--		when cod in (1461,1462,1465,1717,1776,101763) -- ���������������
--			then 43
--		when cod in (1001,1002,1011,1012,1013,1014,1015,1016,1017,1018,1021,1022,1025,1027,1031,1032,1035,1811,
--			1511,1512,1513,1515,1801,1802,1803,1804,1805,1806,1807,1808,1823,1825,
--			101001,101002,101003,101004,101005,101006,101011,101012,101013,
--			101014,101015,101016,101017,101018,101027,101028,101029,101030,101031) -- �������
--			then 27
--		when cod in (9401,9402,9403,9404,9405,9406,9407,
--			109401,109402,109403,109404,109405,109406,109407,109408,109409)
--			then 171
--		else 0
--	end)
--select cod, count(*) from ��������������.[������������ ������] where prvs=0 group by cod
-- ����� ����� �� ������ �������� ������� �������� - ���������!
go 

alter table [����������].[��� ������] add caseid int default 0
go

-- �������� ������������� ���������� ����� ��������� �� ����� ������ ���������
-- �� ���� ������ ����� ������! ��� ����� ����� ������� �� ������ � ���� �12_0000.sql!
update a 
	set n_obr = b.n_obr
	from [����������].[��� ������] a
left join (select recid, 
	ROW_NUMBER() over (partition by sn_pol, left(ds,3) order by d_u asc) as n_obr
	from [����������].[��� ������]) b on a.recid=b.recid
-- 05:55 ��� ������� ��������! 38610133 row(s) affected)

-- ��������� �� ����!
update a 
	set caseid = case_id
	from [����������].[��� ������] a
left join (select recid, 
	DENSE_RANK() over (order by sn_pol, rubr) as case_id
	from [����������].[��� ������]) b on a.recid=b.recid
-- ��������� �� ����!

;with cte as
(select caseid, count(*) as cnt
from [����������].[��� ������]
group by caseid 
)
select cnt, count(*) as _cnt from cte
group by cnt order by _cnt desc
go


drop table #table01
;with cte as
(select caseid, count(*) as cnt
from [����������].[��� ������]
group by caseid 
)
select top 100 * into #table01 from [����������].[��� ������]
where caseid in (select caseid from cte where cnt=1)
go

select a.caseid, b.name, c.name, a.* from [����������].[��� ������] a
join dim.Tarif b on a.cod = b.code
join dim.Ds c on a.ds = c.code
where sn_pol in (select distinct sn_pol from #table01)
order by sn_pol, d_u

select caseid, min(caseid), max(caseid) from [����������].[��� ������] 

select top 100 * from [����������].[��� ������] order by caseid
