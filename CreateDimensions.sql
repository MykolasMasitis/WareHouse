-- Ver. 01.0. Release Date: 09 Aug 2019
-- The second step of creating Database LPU
-- The next (the 3rd) step is perfoming out of VFP module and populate the tables created here
-- Полная ревизия закончена к 22.06.2021, загружены данные 202101, объем БД одного месяца 2,5Gb

-- это сделано для  OPENROWSET('vfpoledb','C:\lpu2smo\update\', 'SELECT * FROM sprlpuib')
--EXEC sp_configure 'show advanced options', 1
--RECONFIGURE WITH OVERRIDE
--GO
--EXEC sp_configure 'ad hoc distributed queries', 1
--RECONFIGURE WITH OVERRIDE
--GO

--USE [master]
--GO
--EXEC master.dbo.sp_MSset_oledb_prop N'VFPOLEDB', N'AllowInProcess', 1
--GO

SET NOCOUNT ON
GO
USE [lpu]
GO

DECLARE @table sysname;
SET @table = 'dim.People';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.People
CREATE TABLE dim.People
	(sn_pol varchar(25), enp char(6), fam varchar(40), im varchar(40), ot varchar(40), 
	 sex dec(1), dr date, CONSTRAINT [PK_People] PRIMARY KEY CLUSTERED (sn_pol))
	ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.Dates';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.Dates
CREATE TABLE dim.Dates 
	(d_u date, period char(7), year int, CONSTRAINT [PK_Dates] PRIMARY KEY CLUSTERED (d_u ASC))
	ON [Default]
CREATE UNIQUE INDEX idx_dates_date ON dim.Dates (d_u)
GO

set nocount on
declare @startDate date;
declare @currentDate date;
set @startDate = CAST('2012-01-01' as datetime)
set @currentDate = @startDate

while (@currentDate <= cast('2024-01-01' as datetime))
 begin
	insert into dim.Dates 
	(d_u, period, year) 
		values 
	(@currentDate, STR(YEAR(@currentDate),4) + FORMAT(MONTH(@currentDate), '00'), YEAR(@currentDate))
	set @currentDate = DATEADD(DAY, 1, @currentDate)
 end
GO
--UPDATE a
--SET dateId=b.dateId
--FROM facts.Services a
--INNER JOIN dim.Dates b 
--	ON a.d_u=b.date
update a set dateId=dateId-1 from facts.Services a
--GO


DECLARE @table sysname;
SET @table = 'dim.Surgeries';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.Surgeries
CREATE TABLE dim.Surgeries (code varchar(15) NOT NULL PRIMARY KEY CLUSTERED, name varchar(250)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.sprlpu';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE [dim].[sprlpu]
CREATE TABLE [dim].[sprlpu](/*period char(6),*/ fil_id dec(6), lpu_id dec(6), mcod char(7), name varchar(50), fullname varchar(150), 
	cokr char(2), address varchar(100), ved dec(3), ogrn char(15), tpn varchar(1), tpns varchar(1), vmp varchar(3),
	CONSTRAINT [PK_sprlpu] PRIMARY KEY CLUSTERED (/*period,*/ fil_id ASC)) ON [Default]
CREATE NONCLUSTERED INDEX idx_sprlpu ON dim.sprlpu (/*period,*/ fil_id ASC) INCLUDE (fullname)
--SELECT * FROM OPENROWSET('vfpoledb','C:\lpu2smo\update', 'SELECT * FROM sprlpuib') -- работать не будет - 32 бита под 64-мя не работает
--alter table dim.sprlpu drop constraint PK_sprlpu
--drop index idx_sprlpu on dim.sprlpu
--alter table dim.sprlpu 
--	ADD CONSTRAINT PK_sprlpu PRIMARY KEY CLUSTERED (fil_id ASC)
--delete from dim.sprlpu where period!='202107'
-- select * from dim.sprlpu
GO

DECLARE @table sysname;
SET @table = 'dim.lpudogs';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE [dim].[lpudogs]
CREATE TABLE [dim].[lpudogs](period char(4) /*год!*/, lpu_id dec(5) not null, mcod char(7), dogs varchar(16), ddogs date, inn char(10), kpp char(9),
	account char(16), old_acc char(16), bank_acc char(20), dog2020 char(16),
	CONSTRAINT [PK_lpudogs] PRIMARY KEY CLUSTERED (period, lpu_id ASC)) ON [Default]
GO 
--alter TABLE [dim].[lpudogs] drop constraint PK_lpudogs
--alter TABLE [dim].[lpudogs] alter column lpu_id dec(5) not null
--alter TABLE [dim].[lpudogs]
--	add CONSTRAINT [PK_lpudogs] PRIMARY KEY CLUSTERED (period, lpu_id ASC)

--  Эксперимент по селекту из xml
/*
DECLARE @tbl TABLE (ID INT IDENTITY PRIMARY KEY, xmldata XML NOT NULL);
INSERT INTO @tbl (xmldata) VALUES
('<nsiDictionaryEntryInfoList>
  <entries>
    <fields>
      <entry>
        <key>TPNS</key>
      </entry>
      <entry>
        <key>END_DATE</key>
        <value>20211231</value>
      </entry>
      <entry>
        <key>FIL_ID</key>
        <value>5225</value>
      </entry>
      <entry>
        <key>START_DATE</key>
        <value>20210101</value>
      </entry>
      <entry>
        <key>DEPARTMENT_HEALTH_CODE</key>
      </entry>
      <entry>
        <key>F_CODE</key>
        <value>775225</value>
      </entry>
      <entry>
        <key>OMS_CODE</key>
        <value>1334748</value>
      </entry>
      <entry>
        <key>DEPARTMENT_CODE</key>
        <value>39</value>
      </entry>
      <entry>
        <key>NAME</key>
        <value>ООО " ЦТА И КПМ"</value>
      </entry>
      <entry>
        <key>VERSION_ID</key>
        <value>256.160621</value>
      </entry>
      <entry>
        <key>CODE</key>
        <value>5225</value>
      </entry>
      <entry>
        <key>PR_T</key>
      </entry>
      <entry>
        <key>TPN</key>
        <value>3</value>
      </entry>
      <entry>
        <key>PR_S</key>
      </entry>
      <entry>
        <key>LPU_OGRN</key>
        <value>1027708006787</value>
      </entry>
      <entry>
        <key>DISTRICT_CODE</key>
        <value>01</value>
      </entry>
      <entry>
        <key>ADDRESS</key>
        <value>123060, г. Москва, ул. Маршала Соколовского, д. 4</value>
      </entry>
      <entry>
        <key>FULL_NAME</key>
        <value>ООО " ЦТА И КПМ"</value>
      </entry>
      <entry>
        <key>VMP</key>
        <value>1</value>
      </entry>
      <entry>
        <key>ID</key>
        <value>C594C06A38FB07DCE053C0A8C233EE9A</value>
      </entry>
      <entry>
        <key>SMO_CODE</key>
        <value>IN</value>
      </entry>
    </fields>
  </entries>
  <entries>
    <fields>
      <entry>
        <key>TPNS</key>
        <value>2</value>
      </entry>
      <entry>
        <key>END_DATE</key>
        <value>20211231</value>
      </entry>
      <entry>
        <key>FIL_ID</key>
        <value>5203</value>
      </entry>
      <entry>
        <key>START_DATE</key>
        <value>20210101</value>
      </entry>
      <entry>
        <key>DEPARTMENT_HEALTH_CODE</key>
      </entry>
      <entry>
        <key>F_CODE</key>
        <value>775226</value>
      </entry>
      <entry>
        <key>OMS_CODE</key>
        <value>6343742</value>
      </entry>
      <entry>
        <key>DEPARTMENT_CODE</key>
        <value>4</value>
      </entry>
      <entry>
        <key>NAME</key>
        <value>ФНКЦ ФХМ, КБ № 123 ФМБА РОССИИ</value>
      </entry>
      <entry>
        <key>VERSION_ID</key>
        <value>256.160621</value>
      </entry>
      <entry>
        <key>CODE</key>
        <value>5226</value>
      </entry>
      <entry>
        <key>PR_T</key>
      </entry>
      <entry>
        <key>TPN</key>
        <value>2</value>
      </entry>
      <entry>
        <key>PR_S</key>
      </entry>
      <entry>
        <key>LPU_OGRN</key>
        <value>1027739756428</value>
      </entry>
      <entry>
        <key>DISTRICT_CODE</key>
        <value>09</value>
      </entry>
      <entry>
        <key>ADDRESS</key>
        <value>143000 Московская область, г.Одинцово, Красногорское шоссе, дом 15</value>
      </entry>
      <entry>
        <key>FULL_NAME</key>
        <value>ФГБУ ФНКЦ ФХМ ФМБА РОССИИ</value>
      </entry>
      <entry>
        <key>VMP</key>
        <value>13</value>
      </entry>
      <entry>
        <key>ID</key>
        <value>C594C06A38FC07DCE053C0A8C233EE9A</value>
      </entry>
      <entry>
        <key>SMO_CODE</key>
        <value>IN</value>
      </entry>
    </fields>
  </entries>
</nsiDictionaryEntryInfoList>')

select
A.entry.value('(entry/key/text())[3]','VARCHAR(50)') as tpns
from
(select cast(c as xml) from openrowset(bulk 'e:\nsi\base\202106\sprlpu.xml', single_blob) as T(c))
as S(c) 
cross apply c.nodes('nsiDictionaryEntryInfoList/entries/fields') as A(entry) -- выпоолняется 17 минут!
go 
*/
--  Эксперимент по селекту из xml


DECLARE @table sysname;
SET @table = 'dim.Sex';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE [dim].[Sex]
--IF OBJECT_ID('dim.Sex', 'U') IS NOT NULL DROP TABLE dim.Sex
GO
CREATE TABLE [dim].[Sex]([code] dec(1), [name] char(12),
CONSTRAINT [PK_sex] PRIMARY KEY CLUSTERED ([code] ASC)) ON [Default]
--INSERT INTO [dim].[sex] (code,name) VALUES (0, 'не определен')
INSERT INTO [dim].[Sex] (code,name) VALUES (1, 'мужской')
INSERT INTO [dim].[Sex] (code,name) VALUES (2, 'женский')
GO

DECLARE @table sysname;
SET @table = 'dim.VozObs';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE [dim].[VozObs]
CREATE TABLE [dim].[VozObs]([code] tinyint, [name] char(20), CONSTRAINT [PK_vozobs] PRIMARY KEY CLUSTERED ([code] ASC)) ON [Default]
INSERT INTO [dim].[VozObs] (code,name) VALUES (1, 'взрослое население')
INSERT INTO [dim].[VozObs] (code,name) VALUES (2, 'детское население')
INSERT INTO [dim].[VozObs] (code,name) VALUES (3, 'смешанное население')
GO

DECLARE @table sysname;
SET @table = 'dim.UslOK';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE [dim].[UslOK]
CREATE TABLE [dim].[UslOK]([code] tinyint, [name] char(20), CONSTRAINT [PK_uslok] PRIMARY KEY CLUSTERED ([code] ASC)) ON [Default]
INSERT INTO [dim].[UslOK] (code,name) VALUES (1, 'Стационарно')
INSERT INTO [dim].[UslOK] (code,name) VALUES (2, 'В дневном стационаре')
INSERT INTO [dim].[UslOK] (code,name) VALUES (3, 'Амбулаторно')
INSERT INTO [dim].[UslOK] (code,name) VALUES (4, 'Вне МО')
GO

DECLARE @table sysname;
SET @table = 'dim.UslTip';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE [dim].[UslTip]
CREATE TABLE [dim].[UslTip]([code] tinyint, [name] char(25), CONSTRAINT [PK_UslTip] PRIMARY KEY CLUSTERED ([code] ASC)) ON [Default]
INSERT INTO [dim].[UslTip] (code,name) VALUES (0, 'Тип не определен')
INSERT INTO [dim].[UslTip] (code,name) VALUES (1, 'Амбулаторная услуга')
INSERT INTO [dim].[UslTip] (code,name) VALUES (2, 'Койко-день')
INSERT INTO [dim].[UslTip] (code,name) VALUES (3, 'ЭКО')
INSERT INTO [dim].[UslTip] (code,name) VALUES (4, 'МЭС')
INSERT INTO [dim].[UslTip] (code,name) VALUES (5, 'ВМП')
INSERT INTO [dim].[UslTip] (code,name) VALUES (6, '56023/156003')
GO

/*
DECLARE @table sysname;
SET @table = 'dim.StageTarifDWN';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.StageTarifDWH
CREATE TABLE dim.StageTarifDWH(code dec(6) NOT NULL PRIMARY KEY CLUSTERED, 
tpn char(1), name varchar(250), uet1 dec(5,2), uet2 dec(5,2), n_kd dec(3), iscurrent bit, start datetime, stop datetime)
	ON [Default]
GO
*/
truncate table dim.tarifdwh
/*
if  not exists (select * from dim.TarifDWH)
	print 'Nothing in there!'
else
	print 'OK!'
*/

DECLARE @table sysname;
SET @table = 'dim.Tarif';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.Tarif
CREATE TABLE dim.Tarif(code dec(6) NOT NULL PRIMARY KEY CLUSTERED, tpn char(1), name varchar(250), uet1 dec(5,2), uet2 dec(5,2), n_kd dec(3))
	ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.Ds';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.Ds
CREATE TABLE dim.Ds(code char(6) NOT NULL PRIMARY KEY CLUSTERED, name varchar(160), sex tinyint, f12str varchar(15)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.chronicDs';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.chronicDs
CREATE TABLE dim.chronicDs(code char(6) NOT NULL PRIMARY KEY CLUSTERED, cnt int) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.ProfOt';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.ProfOt
CREATE TABLE dim.ProfOt(code char(2) NOT NULL PRIMARY KEY CLUSTERED, name varchar(107)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.Prv002';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.Prv002
CREATE TABLE dim.Prv002(code char(3) NOT NULL PRIMARY KEY CLUSTERED, name varchar(100)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.Tip';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.Tip
CREATE TABLE dim.Tip(code char(1) NOT NULL PRIMARY KEY CLUSTERED, name varchar(250)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.Ord';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.Ord
CREATE TABLE dim.Ord(code dec(1) NOT NULL PRIMARY KEY CLUSTERED, name varchar(250)) ON [Default]
INSERT INTO [dim].[Ord] (code,name) VALUES (1, 'плановая госпитализация (кроме госпитализации в МО, подведомственные федеральным органам власти')
INSERT INTO [dim].[Ord] (code,name) VALUES (2, 'экстренная госпитализация (пациент доставлен бригадой СМП / НМП)')
INSERT INTO [dim].[Ord] (code,name) VALUES (3, 'пациент обратился самостоятельно')
INSERT INTO [dim].[Ord] (code,name) VALUES (4, 'направление от МО системы ОМС города Москвы, в т.ч. «актив» ССиНМП им. Пучкова ')
INSERT INTO [dim].[Ord] (code,name) VALUES (5, 'плановая  госпитализация в МО, под-ведомственные федеральным органам власти')
INSERT INTO [dim].[Ord] (code,name) VALUES (6, 'допризывник направлен военкоматом')
INSERT INTO [dim].[Ord] (code,name) VALUES (7, 'наличие распределения Москомспорта на проведение углубленных медицинских осмотров')
INSERT INTO [dim].[Ord] (code,name) VALUES (8, 'наличие договора МО с дошкольным / школьным  учреждением в соответствии с приказом ДЗ о раскреплении,
	наличие договора МО с учреждением по проведению вакцинопрофилактики ')
INSERT INTO [dim].[Ord] (code,name) VALUES (9, 'направление от иных учреждений ')
GO

DECLARE @table sysname;
SET @table = 'dim.Rslt'; -- справочник НСИ rsv009xx.dbf, результат лечения
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.Rslt
CREATE TABLE dim.Rslt(code dec(3) NOT NULL PRIMARY KEY CLUSTERED, name varchar(100)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.Prvs'; -- справочник НСИ spv015xx.dbf, специальность исполнителя медицинской помощи
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.Prvs
CREATE TABLE dim.Prvs(code dec(4) NOT NULL PRIMARY KEY CLUSTERED, name varchar(51)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.Ishod'; -- справочник НСИ isv012xx.dbf, исход заболевания
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.Ishod
CREATE TABLE dim.Ishod(code dec(3) NOT NULL PRIMARY KEY CLUSTERED, 
	name varchar(60)) ON [Default]
insert into dim.Ishod (code,name) values (0, 'не определен')
GO

DECLARE @table sysname;
SET @table = 'dim.FinTyp';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.FinTyp
CREATE TABLE dim.fintyp(code char(1) NOT NULL PRIMARY KEY CLUSTERED, name varchar(50)) ON [Default]
INSERT INTO [dim].[Fintyp] (code,name) VALUES ('p', 'подушевые терапия')
INSERT INTO [dim].[FinTyp] (code,name) VALUES ('s', 'подушевые стоматология')
INSERT INTO [dim].[FinTyp] (code,name) VALUES ('4', 'допуслуги терапия')
INSERT INTO [dim].[FinTyp] (code,name) VALUES ('8', 'допуслуги стоматология')
GO

DECLARE @table sysname;
SET @table = 'dim.AttTyp';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.AttTyp
CREATE TABLE dim.AttTyp(code char(1) NOT NULL PRIMARY KEY CLUSTERED, name varchar(50)) ON [Default]
INSERT INTO dim.AttTyp (code,name) VALUES ('0', 'неприкрепленные')
INSERT INTO dim.AttTyp (code,name) VALUES ('1', 'свои')
INSERT INTO dim.AttTyp (code,name) VALUES ('2', 'чужие')
GO

DECLARE @table sysname;
SET @table = 'dim.Dn';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.Dn
CREATE TABLE dim.Dn(code dec(1) NOT NULL PRIMARY KEY CLUSTERED, name varchar(50)) ON [Default]
INSERT INTO [dim].[Dn] (code,name) VALUES (0, '')
INSERT INTO [dim].[Dn] (code,name) VALUES (1, 'состоит')
INSERT INTO [dim].[Dn] (code,name) VALUES (2, 'взят')
INSERT INTO [dim].[Dn] (code,name) VALUES (3, 'снят')
INSERT INTO [dim].[Dn] (code,name) VALUES (4, 'снят по выздоровлению')
GO

DECLARE @table sysname;
SET @table = 'dim.Reab';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.Reab
CREATE TABLE dim.Reab(code dec(1) NOT NULL PRIMARY KEY CLUSTERED, name varchar(50)) ON [Default]
INSERT INTO [dim].[Reab] (code,name) VALUES (0, '')
INSERT INTO [dim].[Reab] (code,name) VALUES (1, 'реабилитация')
GO

DECLARE @table sysname;
SET @table = 'dim.Ds_Onk';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.Ds_Onk
CREATE TABLE dim.Ds_Onk(code dec(1) NOT NULL PRIMARY KEY CLUSTERED, name varchar(50)) ON [Default]
INSERT INTO [dim].[Ds_Onk] (code,name) VALUES (0, 'нет подозрения на ЗНО')
INSERT INTO [dim].[Ds_Onk] (code,name) VALUES (1, 'есть подозрение на ЗНО')
GO

DECLARE @table sysname;
SET @table = 'dim.p_cel';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.p_cel
CREATE TABLE dim.p_cel(code char(3) NOT NULL PRIMARY KEY CLUSTERED, name varchar(100)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.c_zab';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.c_zab
CREATE TABLE dim.c_zab(code dec(1) NOT NULL PRIMARY KEY CLUSTERED, name varchar(100)) ON [Default]
GO

-- Справочники для onk_sl
DECLARE @table sysname;
SET @table = 'dim.ds1_t'; -- оригинанльное название onreasxx.dbf
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.ds1_t
CREATE TABLE dim.ds1_t(code smallint NOT NULL PRIMARY KEY CLUSTERED, name varchar(100)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.stad'; -- оригинанльное название onstadxx.dbf
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.stad
CREATE TABLE dim.stad (code smallint NOT NULL PRIMARY KEY CLUSTERED, ds char(6), st char(5)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.onk_t'; -- оригинанльное название ontum_xx.dbf
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.onk_t
CREATE TABLE dim.onk_t(code smallint NOT NULL PRIMARY KEY CLUSTERED, ds char(6), t char(5), name varchar(100)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.onk_n'; -- оригинанльное название ontum_xx.dbf
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.onk_n
CREATE TABLE dim.onk_n(code smallint NOT NULL PRIMARY KEY CLUSTERED, ds char(6), n char(5), name varchar(100)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.onk_m'; -- оригинанльное название onmet_xx.dbf
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.onk_m
CREATE TABLE dim.onk_m(code smallint NOT NULL PRIMARY KEY CLUSTERED, ds char(6), m char(5), name varchar(100)) ON [Default]
GO
-- Справочники для onk_sl

-- Справочники для onk_ls
DECLARE @table sysname;
SET @table = 'dim.TariOn';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.TariOn
CREATE TABLE dim.TariOn(code char(8) NOT NULL PRIMARY KEY CLUSTERED, 
	name char(25), forlek varchar(160), dozlp varchar(25), mass_value dec(5,2), mass_unit varchar(10), vol_value dec(5,2), 
	vol_unit varchar(10), pr_v_value dec(5,2), pr_v_unit varchar(10), p_mas_value dec(5,2), p_mas_unit varchar(10), edizm varchar(10))
	ON [Default]
GO 

DECLARE @table sysname;
SET @table = 'dim.Medicaments';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.Medicaments
CREATE TABLE dim.Medicaments(dd_sid char(10) NOT NULL PRIMARY KEY CLUSTERED, 
	dd_name varchar(100), is_oms bit, mass_value dec(5,2), mass_unit varchar(10), vol_value dec(5,2), vol_unit varchar(10), gd_sid char(8),
	gd_name varchar(100)) ON [Default]
GO 

DECLARE @table sysname;
SET @table = 'dim.medpack';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.medpack
CREATE TABLE dim.medpack(r_up char(10) NOT NULL PRIMARY KEY CLUSTERED, 
	name varchar(100), pmp_id char(10), type varchar(50), qty_value dec(10,2), qty_unit varchar(10), mass_value dec(5,2), mass_unit varchar(10),
	vol_value dec(5,2), vol_unit varchar(10)) ON [Default]
GO 

DECLARE @table sysname;
SET @table = 'dim.medicament_mfc';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.medicament_mfc
CREATE TABLE dim.medicament_mfc(dd_id char(10) NOT NULL PRIMARY KEY CLUSTERED, md_id char(10), name varchar(250), mfc_name varchar(250), mfc_country varchar(25),
	n_ru char(20), d_issued date, d_end date, own_name varchar(250), own_country varchar(25), version_id char(10)) ON [Default]
GO 

-- Справочники для onk_ls

-- Справочники для onk_cons
DECLARE @table sysname;
SET @table = 'dim.consiliumreason'; -- оригинанльное название onconsxx.dbf
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.consiliumreason
CREATE TABLE dim.consiliumreason(code smallint NOT NULL PRIMARY KEY CLUSTERED, name varchar(100)) ON [Default]
GO
-- Справочники для onk_cons

DECLARE @table sysname;
SET @table = 'dim.periods';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.periods
--CREATE TABLE dim.periods(code smallint NOT NULL PRIMARY KEY CLUSTERED, name char(7), isactive bit) ON [Default]
--insert into dim.periods values (108, '202101',1),(109, '202102',1),(110, '202103',1),(111, '202104',1),
--	(112, '202105',1),(113, '202106',1)
CREATE TABLE dim.periods(code char(7) NOT NULL PRIMARY KEY CLUSTERED, 
	[year] smallint not null, [month] tinyint not null, quater tinyint not null, 
	semester tinyint not null) ON [Default]
insert into dim.periods values 
	('202001',2020,1,1,1),('202002',2020,2,1,1),('202003',2020,3,1,1),
	('202004',2020,4,2,1),('202005',2020,5,2,1),('202006',2020,6,2,1),
	('202007',2020,7,3,2),('202008',2020,8,3,2),('202009',2020,9,3,2),
	('202010',2020,10,4,2),('202011',2020,11,4,2),('202012',2020,12,4,2)
insert into dim.periods values 
	('202101',2021,1,1,1),('202102',2021,2,1,1),('202103',2021,3,1,1),
	('202104',2021,4,2,1),('202105',2021,5,2,1),('202106',2021,6,2,1),
	('202107',2021,7,3,2),('202108',2021,8,3,2),('202109',2021,9,3,2),
	('202110',2021,10,4,2),('202111',2021,11,4,2),('202112',2021,12,4,2)
insert into dim.periods values 
	('202201',2022,1,1,1),('202202',2022,2,1,1),('202203',2022,3,1,1),
	('202204',2022,4,2,1),('202205',2022,5,2,1),('202206',2022,6,2,1),
	('202207',2022,7,3,2),('202208',2022,8,3,2),('202209',2022,9,3,2),
	('202210',2022,10,4,2),('202211',2022,11,4,2),('202212',2022,12,4,2)
--insert into dim.periods values (108, '202101',1),(109, '202102',1),(110, '202103',1),(111, '202104',1),
--	(112, '202105',1),(113, '202106',1)
GO 

-- Справочник категории допуслуги
DECLARE @table sysname;
SET @table = 'dim.dopreason';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.dopreason
CREATE TABLE dim.dopreason([code] tinyint NOT NULL PRIMARY KEY CLUSTERED, [name] char(100), Typ char(1)) ON [Default]
GO
-- Справочник категории допуслуги

DECLARE @table sysname;
SET @table = 'dim.ososch';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.ososch
CREATE TABLE dim.ososch(code char(1) NOT NULL PRIMARY KEY CLUSTERED, name char(70)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.reab';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.reab
CREATE TABLE dim.reab (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name char(25)) ON [Default]
INSERT INTO dim.reab(code,name) VALUES (0, '')
INSERT INTO dim.reab(code,name) VALUES (1, 'реабилитация')
GO

DECLARE @table sysname;
SET @table = 'dim.ds_onk';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.ds_onk
CREATE TABLE dim.ds_onk (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name char(25)) ON [Default]
INSERT INTO dim.ds_onk (code,name) VALUES (0, 'нет подозрения на ЗНО')
INSERT INTO dim.ds_onk (code,name) VALUES (1, 'есть подозрение на ЗНО')
GO

DECLARE @table sysname;
SET @table = 'dim.diagtip';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.diagtip
CREATE TABLE dim.diagtip (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name char(25)) ON [Default]
INSERT INTO dim.diagtip (code,name) VALUES (1, 'гистологический признак') -- onmrf_XX
INSERT INTO dim.diagtip (code,name) VALUES (2, 'маркёр (ИГХ)')            -- onigh_XX
GO

DECLARE @table sysname;
SET @table = 'dim.mrf';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.mrf
CREATE TABLE dim.mrf (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name varchar(50)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.mrf_rslt';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.mrf_rslt
CREATE TABLE dim.mrf_rslt (code tinyint NOT NULL PRIMARY KEY CLUSTERED, mrf_code tinyint, name varchar(50)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.igh';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.igh
CREATE TABLE dim.igh (code tinyint NOT NULL PRIMARY KEY CLUSTERED, igh varchar(25), name varchar(50)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.igh_rslt';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.igh_rslt
CREATE TABLE dim.igh_rslt (code tinyint NOT NULL PRIMARY KEY CLUSTERED, igh_code tinyint, r_i varchar(25), name varchar(150)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.onnapr';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.onnapr
CREATE TABLE dim.onnapr (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name varchar(150)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.onprot';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.onprot
CREATE TABLE dim.onprot (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name varchar(150)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.onlech';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.onlech
CREATE TABLE dim.onlech (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name varchar(250)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.onhir';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.onhir
CREATE TABLE dim.onhir (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name varchar(250)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.onlekl';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.onlekl
CREATE TABLE dim.onlekl (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name varchar(250)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.onlekv';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.onlekv
CREATE TABLE dim.onlekv (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name varchar(250)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.onluch';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.onluch
CREATE TABLE dim.onluch (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name varchar(250)) ON [Default]
GO

DECLARE @table sysname;
SET @table = 'dim.onczab';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.onczab
CREATE TABLE dim.onczab (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name char(50)) ON [Default]
INSERT INTO dim.onczab (code,name) VALUES (1, 'Острое')
INSERT INTO dim.onczab (code,name) VALUES (2, 'Впервые в жизни установленное хроническое')
INSERT INTO dim.onczab (code,name) VALUES (3, 'Ранее установленное хроническое')
GO

DECLARE @table sysname;
SET @table = 'dim.q';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.q
CREATE TABLE dim.q (code char(2) NOT NULL PRIMARY KEY CLUSTERED, name char(50)) ON [Default]
INSERT INTO dim.q (code,name) VALUES ('I3', 'ООО СК "ИНГОССТРАХ-М"')
INSERT INTO dim.q (code,name) VALUES ('S7', 'ОАО СК "СОГАЗ-МЕД"')
INSERT INTO dim.q (code,name) VALUES ('R2', 'РОСНО-МС')
INSERT INTO dim.q (code,name) VALUES ('R4', 'ООО "СМК РЕСО-МЕД"')
GO

DECLARE @table sysname;
SET @table = 'dim.Typ';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.Typ
CREATE TABLE dim.Typ (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name char(50)) ON [Default]
INSERT INTO dim.Typ(code,name) VALUES (0, 'Неприкрепленный пациент')
INSERT INTO dim.Typ(code,name) VALUES (1, 'Свой пациент')
INSERT INTO dim.Typ (code,name) VALUES (2, 'Чужой пациент')
GO

DECLARE @table sysname;
SET @table = 'dim.usltip';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.usltip
CREATE TABLE dim.usltip (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name char(50)) ON [Default]
INSERT INTO dim.usltip(code,name) VALUES (0, 'Не определен')
INSERT INTO dim.usltip(code,name) VALUES (1, 'Амбулаторная услуга')
INSERT INTO dim.usltip (code,name) VALUES (2, 'ЭКО')
INSERT INTO dim.usltip (code,name) VALUES (3, 'Койка-день')
INSERT INTO dim.usltip (code,name) VALUES (4, 'МЭС')
INSERT INTO dim.usltip (code,name) VALUES (5, 'ВМП')
GO

DECLARE @table sysname;
SET @table = 'dim.Mp';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.Mp
CREATE TABLE dim.Mp (code char(1) NOT NULL PRIMARY KEY CLUSTERED, name char(50)) ON [Default]
INSERT INTO dim.Mp (code,name) VALUES ('p', 'Подушевая терапия')
INSERT INTO dim.Mp (code,name) VALUES ('s', 'Подушевая стоматология')
INSERT INTO dim.Mp (code,name) VALUES ('4', 'Допуслуги, терапия')
INSERT INTO dim.Mp (code,name) VALUES ('8', 'Допуслуги, стоматология')
INSERT INTO dim.Mp (code,name) VALUES ('m', 'МЭС')
GO

--DECLARE @table sysname;
--SET @table = 'dim.dopreason';
--IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.dopreason
--CREATE TABLE dim.dopreason (code tinyint NOT NULL PRIMARY KEY CLUSTERED, 
--	name char(50)) ON [Default]
--INSERT INTO dim.dopreason (code,name) VALUES (0, '')
--INSERT INTO dim.dopreason (code,name) VALUES (1, 'Tpn=r в тарифе')
--INSERT INTO dim.dopreason (code,name) VALUES (2, 'Симультанное хирургическое вмешательство')
--INSERT INTO dim.dopreason (code,name) VALUES (3, 'Женская консультация при медицинском учреждении только пилоты!')
--INSERT INTO dim.dopreason (code,name) VALUES (4, 'приемные отделения с коечным/без коечного фонда,,выездная бригада')
--INSERT INTO dim.dopreason (code,name) VALUES (5, 'приемные отделения с коечным/без коечного фонда')
--INSERT INTO dim.dopreason (code,name) VALUES (6, 'УМО')
--INSERT INTO dim.dopreason (code,name) VALUES (7, '29,129,49,149 раздел для госпитализированных чужих')
--INSERT INTO dim.dopreason (code,name) VALUES (8, 'Tpn=r в тарифе, стоматология')
--INSERT INTO dim.dopreason (code,name) VALUES (9, 'Женская консультация при медицинском учреждении')
--INSERT INTO dim.dopreason (code,name) VALUES (10, 'приемные отделения с коечным/без коечного фонда,,выездная бригада')

DECLARE @table sysname;
SET @table = 'dim.vz';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.vz
CREATE TABLE dim.vz (code tinyint NOT NULL PRIMARY KEY CLUSTERED, 
	name varchar(100)) ON [Default]
INSERT INTO dim.vz (code,name) VALUES (0, '')
INSERT INTO dim.vz (code,name) VALUES (1, 'направление, в т.ч. договор с ДШО/ШО, договор на проведение вакцинопрофилактики и "актив" ССиНМП')
INSERT INTO dim.vz (code,name) VALUES (2, 'неотложная помощь (по реестру медицинских услуг)')
INSERT INTO dim.vz (code,name) VALUES (3, 'услуги, оказанные в травмапункте (в дополнение к  коду 2)')
INSERT INTO dim.vz (code,name) VALUES (4, 'услуги ЖК')
INSERT INTO dim.vz (code,name) VALUES (5, 'услуги ЦЗ')
INSERT INTO dim.vz (code,name) VALUES (6, '')
INSERT INTO dim.vz (code,name) VALUES (9, '')
GO

DECLARE @table sysname;
SET @table = 'dim.f_type';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.f_type
CREATE TABLE dim.f_type (code char(2) NOT NULL PRIMARY KEY CLUSTERED, name varchar(500)) ON [Default]
INSERT INTO dim.f_type (code,name) VALUES ('fh', 
	'Медицинская услуга оплачивается за единицу объёма (по тарифу) и входит в "Дополнительные услуги" МО')
INSERT INTO dim.f_type (code,name) VALUES ('fp', 
	'Медицинская услуга оплачивается из средств  подушевого норматива финансирования на прикрепленных к данной МО застрахованных лиц')
INSERT INTO dim.f_type (code,name) VALUES ('ft', 
	'Медицинская услуга оплачивается за единицу объёма (по тарифу) и относится к первичным приёмам врачей-специалистов, а также услугам травматологических пунктов, оказанных лицам, не прикреплённым ни к одной из МО с ПФ')
INSERT INTO dim.f_type (code,name) VALUES ('st', 
	'Медицинская услуга оплачиваются за законченный/прерванный случай госпитализации и включают в себя медицинские стандарты и ВМП из справочника пакета НСИ АИС ОМС "REESMS", услуги раздела 99/199, услуги 56029/156003 (за исключением оказанных в приёмном отде')
INSERT INTO dim.f_type (code,name) VALUES ('up', 
	'Медицинская услуга оплачивается из средств  подушевого норматива финансирования на прикрепленных к данной МО застрахованных лиц (медицинские услуги, имеющие признаки ошибок "PH", "PF", "PG")')
INSERT INTO dim.f_type (code,name) VALUES ('vz', 
	'Медицинская услуга оплачиваются из средств подушевого норматива финансирования МО прикрепления застрахованного лица путём проведения горизонтальных взаиморасчётов')
GO

DECLARE @table sysname;
SET @table = 'dim.usl_ok';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE dim.usl_ok
CREATE TABLE dim.usl_ok (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name varchar(500)) ON [Default]
INSERT INTO dim.usl_ok (code,name) VALUES (0, 'Не определен')
INSERT INTO dim.usl_ok (code,name) VALUES (1, 'Стационарно')
INSERT INTO dim.usl_ok (code,name) VALUES (2, 'Дневной стационар')
INSERT INTO dim.usl_ok (code,name) VALUES (3, 'Амбулаторно')
INSERT INTO dim.usl_ok (code,name) VALUES (4, 'Вне МО')
GO

print 'The second step of creating kms database has been performed successfully!'
print 'You may fill the dictionaries now using VFP app lpu2smo.exe!'