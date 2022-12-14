-- Ver. 02.0. Release Date: 25 June 2017
-- Третий скрипт создания хранилища lpu
-- All this code here is absolutely idempotent and can be executed repeatedly without ill effect
-- Полная ревизия закончена к 22.06.2021, загружены данные 202101, объем БД одного месяца 2,5Gb
/*
-- скрипт для удаления онок-данных периода, здесь - 202102
delete from facts.Cases where period='202102'
delete from facts.Consiliums where period='202102'
delete from facts.Denials where period='202102'
delete from facts.Drugs where period='202102'
delete from facts.OncoDiag where period='202102'
delete from facts.OncoServices where period='202102'
delete from facts.Referrals where period='202102'
*/
-- select count(*) from facts.Services -- 23 307 260 - три месяца, 
-- select count(*) from facts.Services -- 14 874 256- после отката к первому бэкапу
-- use lpu
-- truncate table facts.aisoms
-- select * from facts.aisoms
-- truncate table facts.pr4
-- select * from facts.pr4
-- truncate table facts.pr4st
-- select * from facts.pr4st
-- truncate table facts.mag02
-- select * from facts.mag02
-- truncate table facts.mek
-- truncate table facts.services
-- truncate table facts.surgeries
-- go 

SET NOCOUNT ON
GO
USE lpu
GO
-- select * from facts.mag02 where q='I3'
-- update facts.pr4 set q='S7'
--alter schema facts transfer dbo.aisoms
--go 

-- Creating facts.Services (talon)
-- facts.Services - таблица оказанных услуг

IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('facts.aisoms')) DROP TABLE facts.aisoms
CREATE TABLE facts.aisoms (q char(2), period char(6), lpuid dec(4), mcod char(7),
	pazval dec(6), finval dec(12,2), pazvals dec(6), finvals dec(12,2), 
	paz dec(6), nsch dec(6), s_pred dec(12,2), s_lek dec(12,2), 
	s_mek dec(12,2), s_mek2 dec(12,2), s_532 dec(12,2), ls_flk dec(12,2), s_ppa dec(12,2), pf_flk dec(12,2), st_flk dec(12,2),
	s_avans dec(12,2), s_pr_avans dec(12,2), s_avans2 dec(12,2), s_pr_avans2 dec(12,2), 
	e_mee dec(12,2), e_ekmp dec(12,2), dolg_b dec(12,2), 
	CONSTRAINT [pk_aisoms] PRIMARY KEY CLUSTERED (q, period, mcod)) ON [FastGrowingFiles]
GO
--alter table facts.aisoms drop constraint pk_aisoms
--ALTER TABLE facts.aisoms ADD CONSTRAINT pk_aisoms PRIMARY KEY CLUSTERED (q, period, mcod)

-- Приложение 4 ПК lpu2smo - импортируется для диагностических целей (для контроля загрузки), в дальнейшем не используется
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('facts.pr4')) DROP TABLE facts.pr4
CREATE TABLE facts.pr4 (q char(2), period char(6), lpuid dec(4), mcod char(7),
	pazval dec(7), finval dec(12,2), p_all dec(7), s_all dec(12,2), p_empty dec(7), s_empty dec(12,2),
	p_own dec(7), s_own dec(12,2), p_guests dec(7), s_guests dec(12,2), p_others dec(7), s_others dec(12,2),
	p_bad dec(7), s_bad dec(12,2), 
	CONSTRAINT [pk_pr4] PRIMARY KEY CLUSTERED (q, period, mcod)) ON [FastGrowingFiles]
GO
--alter table facts.pr4 drop constraint pk_pr4
--ALTER TABLE facts.pr4 ADD CONSTRAINT pk_pr4 PRIMARY KEY CLUSTERED (q, period, mcod)

-- Приложение 4 (стоматология) ПК lpu2smo - импортируется для диагностических целей (для контроля загрузки), в дальнейшем не используется
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('facts.pr4st')) DROP TABLE facts.pr4st
CREATE TABLE facts.pr4st (q char(2), period char(6), lpuid dec(4), mcod char(7),
	pazval dec(7), finval dec(12,2), p_all dec(7), s_all dec(12,2), p_empty dec(7), s_empty dec(12,2),
	p_own dec(7), s_own dec(12,2), p_guests dec(7), s_guests dec(12,2), p_others dec(7), s_others dec(12,2),
	p_bad dec(7), s_bad dec(12,2), 
	CONSTRAINT [pk_pr4st] PRIMARY KEY CLUSTERED (q, period, mcod)) ON [FastGrowingFiles]
GO
--alter table facts.pr4st drop constraint pk_pr4st
--ALTER TABLE facts.pr4st ADD CONSTRAINT pk_pr4st PRIMARY KEY CLUSTERED (q, period, mcod)

IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('facts.mag02')) DROP TABLE facts.mag02
CREATE TABLE facts.mag02 (q char(2), period char(6), lpuid dec(4), mcod char(7),
	s_all dec(12,2), s_stac dec(12,2), s_dental dec(12,2), s_dental_0 dec(12,2), s_dop_all dec(12,2), s_dop_dent dec(12,2), 
	mek_all dec(12,2), mek_p dec(12,2), mek_r dec(12,2), mek_dent_p dec(12,2), mek_dent_r dec(12,2), mek_dent_r_0 dec(12,2),
	CONSTRAINT [pk_mag02] PRIMARY KEY CLUSTERED (q, period, mcod)) ON [FastGrowingFiles]
GO
-- alter table facts.mag02 drop constraint pk_mag02
-- ALTER TABLE facts.mag02 ADD CONSTRAINT pk_mag02 PRIMARY KEY CLUSTERED (q, period, mcod)

-- Creating facts.Services (talon)
-- facts.Services - таблица оказанных услуг
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('facts.Services')) DROP TABLE facts.Services
CREATE TABLE facts.Services (
	-- на эту таблицу будут (могут) ссылать другие фактические таблицы, поэтому первичный ключ нужен
	recid int NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED, 
	recid_lpu varchar(7),
	q char(2) not null, year smallint, period char(6), mcod char(7), lpuid dec(4), fil_id dec(5), ispilot bit, ispilots bit, ishorlpu bit, ishorlpus bit, 
	sn_pol varchar(25), c_i varchar(30), ages dec(3), sex tinyint, Typ char(1), prmcod char(7), prmcods char(7),
	ismek bit, cod dec(6), usltip tinyint, tip char(1), d_u date, Mp char(1), dopreason tinyint, vz tinyint, k_u dec(4), tarif dec(10,2), 
	s_all dec(10,2), s_lek dec(10,2), kd_fact dec(4), n_kd dec(3), d_type char(1),  f_type char(2),
	otd char(8), otd1 tinyint/*vozobs*/, otd23 char(2)/*profot*/, otd456 char(3), otdn char(2), usl_ok tinyint, 
	ds char(6), ds_0 char(6), pcod char(10), profil char(3), rslt dec(3), prvs dec(4), ishod dec(3), 
	ds_2 char(6), ds_3 char(6), det dec(1), vnov_m dec(4), novor varchar(9), n_u varchar(14), n_vmp varchar(17),
	ord dec(1), date_ord date, lpu_ord dec(6), ds_onk dec(1), p_cel char(3), dn dec(1),
	reab dec(1), tal_d date, napr_v_in dec(1), c_zab dec(1), IsOnk /*по диагнозу*/bit, IsOnk2 /*по 4,5,6 позиции кода отделения */bit,
	IsDental bit
	) ON [FastGrowingFiles] /*ON ServicesPartScheme(Year)*/
GO

alter table facts.services alter column otd1 tinyint

ALTER TABLE facts.services
	ADD CONSTRAINT service_q_fk FOREIGN KEY (q) REFERENCES dim.q(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_period_fk FOREIGN KEY (period) REFERENCES dim.periods(code)
--ALTER TABLE facts.services
--	ADD CONSTRAINT services_lpu_id_fk FOREIGN KEY (lpuid) REFERENCES dim.lpudogs
ALTER TABLE facts.services
	ADD CONSTRAINT services_sex_fk FOREIGN KEY (sex) REFERENCES dim.sex(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_typ_fk FOREIGN KEY (Typ) REFERENCES dim.Typ(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_cod_fk FOREIGN KEY (cod) REFERENCES dim.Tarif(code)
--insert into dim.Tarif (code) select cod as code from facts.Services where cod not in (select code from dim.Tarif) group by cod
ALTER TABLE facts.services
	ADD CONSTRAINT services_usltip_fk FOREIGN KEY (usltip) REFERENCES dim.usltip(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_tip_fk FOREIGN KEY (Tip) REFERENCES dim.Tip(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_Mp_fk FOREIGN KEY (Mp) REFERENCES dim.Mp(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_dopreason_fk FOREIGN KEY (dopreason) REFERENCES dim.dopreason(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_vz_fk FOREIGN KEY (vz) REFERENCES dim.vz(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_d_type_fk FOREIGN KEY (d_type) REFERENCES dim.ososch(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_f_type_fk FOREIGN KEY (f_type) REFERENCES dim.f_type(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_otd1_fk FOREIGN KEY (otd1) REFERENCES dim.vozobs(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_otd23_fk FOREIGN KEY (otd23) REFERENCES dim.profot(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_otd456_fk FOREIGN KEY (otd456) REFERENCES dim.prv002(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_profil_fk FOREIGN KEY (profil) REFERENCES dim.prv002(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_usl_ok_fk FOREIGN KEY (usl_ok) REFERENCES dim.usl_ok(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_ds_fk FOREIGN KEY (ds) REFERENCES dim.ds(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_ds_0_fk FOREIGN KEY (ds_0) REFERENCES dim.ds(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_ds_2_fk FOREIGN KEY (ds_2) REFERENCES dim.ds(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_ds_3_fk FOREIGN KEY (ds_3) REFERENCES dim.ds(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_ord_fk FOREIGN KEY (ord) REFERENCES dim.ord(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_p_cel_fk FOREIGN KEY (p_cel) REFERENCES dim.p_cel(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_dn_fk FOREIGN KEY (dn) REFERENCES dim.dn(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_c_zab_fk FOREIGN KEY (c_zab) REFERENCES dim.c_zab(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_rslt_fk FOREIGN KEY (rslt) REFERENCES dim.rslt(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_prvs_fk FOREIGN KEY (prvs) REFERENCES dim.prvs(code)
ALTER TABLE facts.services
	ADD CONSTRAINT services_ishod_fk FOREIGN KEY (ishod) REFERENCES dim.ishod(code)

-- два отделения 31 - 1 и 37 - 2369128 (Скорая) обнуляем!

select otd23, COUNT(*) as cnt from facts.Services where 
	otd23 not in (select code from dim.profot) group by otd23
select otd456, COUNT(*) as cnt from facts.Services where 
	otd456 not in (select code from dim.Prv002) group by otd456 -- 396,953,395,810 - 1 
select top 1000 *  from facts.Services where 
	otd456 not in (select code from dim.Prv002)
select ds, COUNT(*) as cnt from facts.Services where 
	ds not in (select code from dim.ds) group by ds

select ishod, COUNT(*) as cnt from facts.Services where 
	ishod not in (select code from dim.ishod) group by ishod

insert into dim.ds (code) values ('T76.8 ')
insert into dim.ds (code) values ('D67.5 ')

select f_type, count(*) as cnt from facts.Services group by f_type

insert into dim.ososch (code) values ('4')
insert into dim.ososch (code) values ('a')
insert into dim.ososch (code) values ('C')
insert into dim.ososch (code) values ('e')
insert into dim.ososch (code) values ('s')
insert into dim.ososch (code) values ('y')

begin tran
update  a
	set ds_3 = null
	from facts.Services a
	left outer join dim.Ds b on a.ds_3 = b.code
where b.code is null
commit

begin tran
update  a
	set ds_0 = null
	from facts.Services a
	left outer join dim.Ds b on a.ds_0 = b.code
where b.code is null


begin tran
update  a
	set otd456 = null
	from facts.Services a
where mcod='0371001 '
commit

begin tran
update  a
	set otd456 = null
	from facts.Services a
where otd456 = '   '
update  a
	set otd456 = null
	from facts.Services a
where otd456 = '   '

update  a
	set profil = null
	from facts.Services a
where profil = '810'

update  a
	set prvs = 0
	from facts.Services a
where prvs = 1127

begin tran
update  a
	set profil = null
	from facts.Services a
where profil = '   '

begin tran
update  a
	set otd23 = null
	from facts.Services a
where otd23 in ('31','37')

begin tran
update  a
	set f_type = null
	from facts.Services a
	left outer join dim.f_type b on a.f_type = b.code
where b.code is null
commit

begin tran
update  a
	set Mp = null
	from facts.Services a
	left outer join dim.Mp b on a.Mp = b.code
where b.code is null
commit

-- выполнялось чуть больше часа! с индексом и подключенным Fk в два раза быстрее!
begin tran
update  b
	set tip=null
	from facts.Services b
	left outer join dim.Tip a on b.tip=a.code
where a.code is null
rollback
commit

-- так не делать! время около 20 часов и не выполнилось!!!
begin tran 
update facts.Services set tip=null where tip not in 
(select tip from facts.Services where tip not in (select code from dim.Tip) group by tip)
rollback
alter table facts.services alter column period char(6)

begin tran
update facts.Services set sex=1 where sex not in (1,2)
commit
-- полчаса на замену типа!
alter table facts.services alter column sex tinyint not null
-- полчаса на замену типа!
alter table facts.services alter column Typ tinyint not null

-- этот индекс использует функция facts.seek_factservices_recid поиска recid по recid_lpu
-- 1 час 20 мие 
CREATE UNIQUE INDEX idx_factservices_recid_lpu ON facts.Services (q, period, mcod, recid_lpu) INCLUDE (recid)
-- не удалось! ошибка ниже!
create index idx_factservices_un ON facts.Services (q,period,mcod,ismek,isdental,f_type) include (sn_pol,s_all,s_lek)
--The statement has been terminated.
--Msg 802, Level 17, State 0, Line 116
--There is insufficient memory available in the buffer pool.

create index idx_factservices_un2 ON facts.Services (q,period,prmcod,ismek,isdental,f_type) include (sn_pol,s_all,s_lek)
--drop index idx_factservices_recid_lpu ON facts.Services
--drop index idx_factservices_un ON facts.Services
--drop index idx_factservices_un2 ON facts.Services
-- создаем индексы для каждого FK! Индивидуально.
CREATE INDEX idx_services_q ON facts.Services (q) INCLUDE (recid)
CREATE INDEX idx_services_period ON facts.Services (period) INCLUDE (recid)
CREATE INDEX idx_services_mcod ON facts.Services (mcod) INCLUDE (recid)
CREATE INDEX idx_services_cod ON facts.Services (cod) INCLUDE (recid)
-- индекс ниже создан за 9 минут!
CREATE INDEX idx_services_tip ON facts.Services (tip) INCLUDE (recid)
drop index idx_factservices_un ON facts.Services
--drop index idx_services_period ON facts.Services
go 

update facts.services set year = CAST(LEFT(period,4) as smallint)
-- 1 h 12 min

-- создаем индексы для каждого FK!

-- drop current primary key constraint
--ALTER TABLE dbo.persion 
--DROP CONSTRAINT PK_persionId;
--GO

-- add new auto incremented field
--ALTER TABLE dbo.persion 
--ADD pmid BIGINT IDENTITY;
--GO

-- create new primary key constraint
--ALTER TABLE dbo.persion 
--ADD CONSTRAINT PK_persionId PRIMARY KEY NONCLUSTERED (pmid, persionId);
--GO
-- Пробуем на основании этого выражения создать суррогатный primary key
-- create unique index idx_primary on facts.services (q,period,fil_id,sn_pol,c_i,ds,d_u,cod,pcod)
-- drop index idx_primary on facts.services
-- Пробуем на основании этого выражения создать суррогатный primary key

-- эти индексы созданы для оптимизации вьюшек facts.vw_pr4, facts.vw_pr4st и функций на их основе - facts.fn_pr4
--create index idx_factservices_unik ON facts.Services (q,period,mcod,ismek,mp,typ,vz) include (sn_pol,s_all)
--drop index idx_factservices_unik ON facts.Services
--create index idx_factservices_unik2 ON facts.Services (q,period,prmcod,ismek,mp,typ,vz) include (sn_pol,s_all)
--drop index idx_factservices_unik2 ON facts.Services
--ALTER INDEX idx_factservices_unik ON facts.Services DISABLE -- temporarily disable index
--CREATE INDEX idx_factservices_unik ON facts.Services(q,period,mcod,ismek,mp,typ,vz) include (sn_pol,s_all) WITH(DROP_EXISTING=ON) -- после disable
--ALTER INDEX idx_factservices_unik ON facts.Services REBUILD;
-- эти индексы созданы для оптимазиции вьюшек facts.vw_pr4, facts.vw_pr4st и функций на их основе - facts.fn_pr4

-- это индексы под новую вьюшку vw_pr4n (основана на f_type)
--drop index idx_factservices_un ON facts.Services
--alter index idx_factservices_un ON facts.Services rebuild
--EXEC sp_rename 'idx_factservices_un', 'idx_factservices_unik', N'INDEX'
--EXEC sp_rename @objname = N'idx_factservices_un', @newname = N'idx_factservices_unik', @objtype = N'INDEX';
--drop index idx_factservices_un2 ON facts.Services
--alter index idx_factservices_un2 ON facts.Services rebuild
-- это индексы по новую вьюшку vw_pr4n (основана на f_type)
GO 
-- CREATE INDEX idx_factservices_mcod ON facts.Services (mcod) INCLUDE (ages, sex, s_all)
GO
-- Creating facts.Services

IF OBJECT_ID('facts.seek_factservices_recid','FN') IS NOT NULL DROP FUNCTION facts.seek_factservices_recid
GO 
CREATE FUNCTION facts.seek_factservices_recid (@q char(2)='', @period char(6)='', @mcod char(7)='', @recid_lpu varchar(7)='')
RETURNS int
BEGIN
	DECLARE @t_recid int, @recid int
	SET @recid = (SELECT recid FROM facts.Services 
		WHERE q=@q and period=@period and mcod=@mcod and recid_lpu=@recid_lpu)
	RETURN @recid
END;
GO 


IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('facts.Surgeries')) DROP TABLE facts.Surgeries
CREATE TABLE facts.Surgeries (q char(2), period_id smallint, period char(6), mcod char(7), lpuid dec(4), fil_id dec(5), 
	sn_pol varchar(25), c_i varchar(30), ages dec(3), sex dec(1),
	ismek bit, service dec(6), ds char(6), d_u date, 
	surgery varchar(14), k_u dec(2), 
	-- это recid_lpu = recid_lpu в Services - по нему ищем recid
	recid_lpu varchar(7), 
	-- это поле заполняется триггером (ниже) при bulk insert - это значение recid facts.Services
	serviceId int,
	CONSTRAINT [pk_facts_surgeries] PRIMARY KEY NONCLUSTERED (q, period, mcod, c_i, service, surgery))
	ON [FastGrowingFiles] /*ON ServicesPartScheme(Year)*/
GO
-- CREATE UNIQUE INDEX idx_factsurgeries_unik ON facts.Surgeries (q, period, mcod, c_i, service, surgery) INCLUDE (recid)
GO
IF OBJECT_ID('facts.uAddFactSurgeries','TR') IS NOT NULL DROP TRIGGER facts.uAddFactSurgeries
GO
CREATE TRIGGER facts.uAddFactSurgeries ON facts.Surgeries
AFTER INSERT 
AS
BEGIN
	SET NOCOUNT ON

	-- Это версия триггера под одну строку - не работает при bulk insert!
	--DECLARE @q char(2)            = (select q from inserted)
	--DECLARE @period char(6)       = (select period from inserted)
	--DECLARE @mcod char(7)         = (select mcod from inserted)
	--DECLARE @recid_lpu varchar(7) = (select recid_lpu from inserted)

	--DECLARE @id int = facts.seek_factservices_recid(@q, @period, @mcod, @recid_lpu)
	
	--DECLARE @recid int = (select recid from inserted)
	--UPDATE facts.Mek SET serviceId=@id WHERE Mek.recid=@recid
	
	-- Это - набор (set)-ориентированная версия триггера, работающая с bulk insert!
	
	UPDATE p
    SET serviceId = facts.seek_factservices_recid(i.q, i.period, i.mcod, i.recid_lpu)
    FROM facts.Surgeries p
    INNER JOIN Inserted i ON i.recid_lpu = p.recid_lpu

END
GO
CREATE INDEX idx_surgeries_q ON facts.Surgeries (q) 
CREATE INDEX idx_surgeries_period ON facts.Surgeries (period) 
CREATE INDEX idx_surgeries_mcod ON facts.Surgeries (mcod) 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('facts.Mek')) DROP TABLE facts.Mek
CREATE TABLE facts.Mek (
	q char(2), period_id smallint, period char(6), mcod char(7), lpuid dec(4), fil_id dec(5), 
	sn_pol varchar(25), c_i varchar(30), ages dec(3), sex dec(1), AttTyp char(1),
	cod dec(6), usltip tinyint, usl_ok tinyint, FinTyp char(1),
	f char(1), c_err char(3), osn230 char(6), s_all dec(10,2), comment varchar(250),
	-- это recid_lpu = recid_lpu в Services - по нему ищем recid
	recid_lpu varchar(7),
	-- это поле заполняется триггером (ниже) при bulk insert - это значение recid facts.Services
	serviceId int, 
	/*CONSTRAINT [pk_facts_mek] PRIMARY KEY NONCLUSTERED (q, period, mcod, recid_lpu, f, c_err)*/)
	ON [FastGrowingFiles]
GO
-- CREATE UNIQUE INDEX idx_factmek_unik ON facts.Mek (q, period, mcod, recid_lpu, f, c_err) INCLUDE (recid)
GO
IF OBJECT_ID('facts.uAddFactMek','TR') IS NOT NULL DROP TRIGGER facts.uAddFactMek
GO
CREATE TRIGGER facts.uAddFactMek ON facts.Mek
AFTER INSERT 
AS
BEGIN
	SET NOCOUNT ON
	--DECLARE @q char(2)            = (select q from inserted)
	--DECLARE @period char(6)       = (select period from inserted)
	--DECLARE @mcod char(7)         = (select mcod from inserted)
	--DECLARE @recid_lpu varchar(7) = (select recid_lpu from inserted)

	--DECLARE @id int = facts.seek_factservices_recid(@q, @period, @mcod, @recid_lpu)
	
	--DECLARE @recid int = (select recid from inserted)
	--UPDATE facts.Mek SET serviceId=@id WHERE Mek.recid=@recid

	UPDATE p
    SET serviceId = facts.seek_factservices_recid(i.q, i.period, i.mcod, i.recid_lpu)
    FROM facts.Mek p
    INNER JOIN Inserted i 
		ON i.q = p.q and i.period=p.period and i.mcod=p.mcod and i.recid_lpu = p.recid_lpu

END
GO
CREATE INDEX idx_mek_q ON facts.Mek (q) 
CREATE INDEX idx_mek_period ON facts.Mek (period) 
CREATE INDEX idx_mek_mcod ON facts.Mek (mcod) 
GO

-- Переименование таблицы
-- EXEC sp_rename 'FactOncoServices', 'OncoServices'
-- Перенос таблицы в другую схему
-- alter schema facts transfer dbo.OncoServices
-- update facts.Services set q='S7'

-- Creating facts.Cases (onk_sl). На момент загрузки этой таблицы facts.Services должна быть загружена!
-- Случаи лечения онкологического заболевания
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('facts.Cases')) DROP TABLE facts.Cases
CREATE TABLE facts.Cases (
	q char(2), period_id smallint, period char(6), mcod char(7), lpuid dec(4), /*services_id int,*/
	sn_pol varchar(25), c_i varchar(30), ages dec(3), sex dec(1), AttTyp char(1), ds char(6), cod dec(6), d_u date,
	ds1_t smallint, stad smallint, onk_t smallint, onk_n smallint, onk_m smallint, mtstz bit, sod dec(5,2), k_fr tinyint, 
	wei dec(4,1), hei smallint, bsa dec(3,2),
	-- это recid_lpu в facts.Services
	recid_s varchar(7), 
	-- нужен для привязки записей из oncoservices, onk_protqq - в ней ссылка на этот id
	recid_sl varchar(7), 
	-- заполняем значением recid из facts.Services, должно сать уникальным
	serviceId int NOT NULL PRIMARY KEY NONCLUSTERED
	) 
	ON [FastGrowingFiles]
-- Creating facts.Cases (onk_sl)
GO
CREATE UNIQUE INDEX idx_factcases_recid ON facts.Cases (q, period, mcod, recid_sl) INCLUDE (recid_s)
GO 
IF OBJECT_ID('facts.seek_factcases_serviceId','FN') IS NOT NULL DROP FUNCTION facts.seek_factcases_serviceId
GO 
CREATE FUNCTION facts.seek_factcases_serviceId (@q char(2)='', @period char(6)='', @mcod char(7)='', @recid_sl varchar(7)='')
RETURNS int
BEGIN
	-- DECLARE @t_recid int, @recid int
	DECLARE @recid int = (SELECT serviceId FROM facts.Cases WHERE q=@q and period=@period and mcod=@mcod and recid_sl=@recid_sl)
	RETURN @recid
END;
GO 
IF OBJECT_ID('facts.uAddFactCases','TR') IS NOT NULL DROP TRIGGER facts.uAddFactCases
GO
CREATE TRIGGER facts.uAddFactCases ON facts.Cases
AFTER INSERT 
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @q char(2)            = (select q from inserted)
	DECLARE @period char(6)       = (select period from inserted)
	DECLARE @mcod char(7)         = (select mcod from inserted)
	DECLARE @recid_lpu varchar(7) = (select recid_s from inserted)

	DECLARE @id int = facts.seek_factservices_recid(@q, @period, @mcod, @recid_lpu)

	UPDATE facts.Cases SET serviceId=@id WHERE 
		Cases.q=@q and Cases.period=@period and Cases.mcod=@mcod and Cases.recid_s=@recid_lpu
END
GO
CREATE INDEX idx_cases_q ON facts.Cases (q) 
CREATE INDEX idx_cases_period ON facts.Cases (period) 
CREATE INDEX idx_cases_mcod ON facts.Cases (mcod) 
GO

-- Creating facts.Cases (onk_sl)
-- select * from facts.OncoServices where serviceid=318401
--select q,period,mcod,recid_usl from facts.OncoServices group by q,period,mcod,recid_usl having count(*)>1

-- Creating facts.OncoServices (onk_usl)
-- Дополнительные сведения об услуге при ЗНО
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('facts.OncoServices')) DROP TABLE facts.OncoServices
CREATE TABLE facts.OncoServices (
	q char(2), period_id smallint, period char(6), mcod char(7), lpuid dec(4), 
	sn_pol varchar(25), c_i varchar(30), ages dec(3), sex dec(1), AttTyp char(1), ds char(6),
	cod dec(6), d_u date,
	onlech /*usl_tip*/ tinyint, onhir /*hir_tip*/ tinyint, onlekl /*lek_tip_l*/ tinyint, onlekv /*lek_tip_v*/ tinyint, 
	onluch /*luch_tip*/ tinyint, pptr bit,
	recid_sl varchar(7), 
	recid_usl varchar(7), 
	-- заполняем значением recid из facts.Services
	serviceId int NOT NULL PRIMARY KEY NONCLUSTERED )
	ON [FastGrowingFiles]
-- Creating facts.OncoServices (onk_usl)
GO 
CREATE UNIQUE INDEX idx_factoncoservices_recid ON facts.OncoServices (q, period, mcod, recid_usl) INCLUDE (serviceId)
GO 
IF OBJECT_ID('facts.seek_factoncoservices_recid','FN') IS NOT NULL DROP FUNCTION facts.seek_factoncoservices_recid
GO 
/*
CREATE FUNCTION facts.seek_factoncoservices_recid (@q char(2)='', @period char(7)='', @mcod char(7)='', @recid_usl varchar(7)='')
RETURNS int
BEGIN
	DECLARE @recid int = (SELECT recid FROM facts.OncoServices WHERE q=@q and period=@period and mcod=@mcod and recid_usl=@recid_usl)
	RETURN @recid
END;
GO
*/
/* 
IF OBJECT_ID('facts.seek_factoncoservices_case_id','FN') IS NOT NULL DROP FUNCTION facts.seek_factoncoservices_case_id
GO 
CREATE FUNCTION facts.seek_factoncoservices_case_id (@q char(2)='', @period char(6)='', @mcod char(7)='', @recid_usl varchar(7)='')
RETURNS int
BEGIN
	DECLARE @case_id int = (SELECT case_id FROM facts.OncoServices WHERE q=@q and period=@period and mcod=@mcod and recid_usl=@recid_usl)
	RETURN @case_id
END;
GO
*/ 

IF OBJECT_ID('uAddFactOncoServices','TR') IS NOT NULL DROP TRIGGER uAddFactOncoServices
GO
CREATE TRIGGER facts.uAddFactOncoServices ON facts.OncoServices
AFTER INSERT 
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @q char(2)           = (select q from inserted)
	DECLARE @period char(6)      = (select period from inserted)
	DECLARE @mcod char(7)        = (select mcod from inserted)
	DECLARE @recid_sl varchar(7) = (select recid_sl from inserted)
	DECLARE @recid_usl varchar(7) = (select recid_usl from inserted)

	DECLARE @serviceId int = facts.seek_factcases_serviceId(@q, @period, @mcod, @recid_sl)

	UPDATE facts.OncoServices SET serviceId=@serviceId 
		WHERE q=@q and period=@period and mcod=@mcod and recid_usl=@recid_usl
END
GO
CREATE INDEX idx_OncoServices_q ON facts.OncoServices (q) 
CREATE INDEX idx_OncoServices_period ON facts.OncoServices (period) 
CREATE INDEX idx_OncoServices_mcod ON facts.OncoServices (mcod) 
GO
-- Creating facts.OncoServices (onk_usl)

-- Разбиваем файл facts.OncoDiag (onk_diag) на два: facts.mrf facts.igh
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('facts.mrf')) DROP TABLE facts.mrf
CREATE TABLE facts.mrf (
	q char(2), period_id smallint, period char(6), mcod char(7), lpuid dec(4),
	sn_pol varchar(25), c_i varchar(30), ages dec(3), sex dec(1), AttTyp char(1),
	ds varchar(6), cod dec(6), 
	d_u date, rslt tinyint /*1 - результат получен, 0 - нет*/, mrf tinyint, mrf_rslt tinyint,
	recid_sl varchar(7), 
	serviceId int 
	)
GO
CREATE UNIQUE INDEX idx_facts_mrf ON facts.mrf (sn_pol, d_u, mrf)
GO 

IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('facts.igh')) DROP TABLE facts.igh
CREATE TABLE facts.igh (
	q char(2), period_id smallint, period char(6), mcod char(7), lpuid dec(4), /*services_id int,*/
	sn_pol varchar(25), c_i varchar(30), ages dec(3), sex dec(1), AttTyp char(1),
	ds varchar(6), cod dec(6), 
	d_u date, rslt tinyint /*1 - результат получен, 0 - нет*/, igh tinyint, igh_rslt tinyint, 
	recid_sl varchar(7), 
	serviceId int
	)
GO
CREATE UNIQUE INDEX idx_facts_igh ON facts.igh (sn_pol, d_u, igh)
GO 
CREATE INDEX idx_igh_q ON facts.igh (q) 
CREATE INDEX idx_igh_period ON facts.igh (period) 
CREATE INDEX idx_igh_mcod ON facts.igh (mcod) 
GO

-- Разбиваем файл facts.OncoDiag (onk_diag) на два: facts.mrf facts.igh

-- Creating facts.Drugs (onk_ls)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('facts.Drugs')) DROP TABLE facts.Drugs
CREATE TABLE facts.Drugs (
	q char(2), period_id smallint, period char(6), mcod char(7), lpuid dec(4), 
	sn_pol varchar(25), c_i varchar(30), ages dec(3), sex dec(1), AttTyp char(1),
	ds varchar(6), isokds bit, cod dec(6), isokcod bit, regnum char(6), d_u /*date_inj*/ date, code_sh varchar(10), n_par varchar(40), r_up varchar(10), tip_opl tinyint, 
	n_ru varchar(20), ot_d dec(11,4), dt_q tinyint, dt_d dec(11,4), sid varchar(10), gd_sid varchar(8), edizm char(2), 
	tarif dec(11,2), en dec(7,2), s_all dec(11,2),
	serviceId int, 
	recid_s varchar(7))
	ON [FastGrowingFiles]
GO
--CREATE UNIQUE INDEX idx_facts_drugs ON facts.drugs (sn_pol, d_u, sid, dt_d)
GO 
IF OBJECT_ID('facts.uAddFactDrugs','TR') IS NOT NULL DROP TRIGGER facts.uAddFactDrugs
GO
CREATE TRIGGER facts.uAddFactDrugs ON facts.Drugs
AFTER INSERT 
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @q char(2)            = (select q from inserted)
	DECLARE @period char(6)       = (select period from inserted)
	DECLARE @mcod char(7)         = (select mcod from inserted)
	DECLARE @recid_s varchar(7)   = (select recid_s from inserted)

	DECLARE @serviceId int   = facts.seek_factservices_recid(@q, @period, @mcod, @recid_s)

	UPDATE facts.Drugs SET serviceId=@serviceId 
		WHERE q=@q and period=@period and mcod=@mcod and Drugs.recid_s=@recid_s
END
GO
CREATE INDEX idx_Drugs_q ON facts.Drugs (q) 
CREATE INDEX idx_Drugs_period ON facts.Drugs (period) 
CREATE INDEX idx_Drugs_mcod ON facts.Drugs (mcod) 
GO

-- Creating facts.Drugs (onk_ls)

-- Creating facts.Consiliums (onk_cons)
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('facts.Consiliums')) DROP TABLE facts.Consiliums
CREATE TABLE facts.Consiliums (
	q char(2), period_id smallint, period char(6), mcod char(7), lpuid dec(4), /*services_id int,*/
	sn_pol varchar(25), c_i varchar(30), ages dec(3), sex dec(1), AttTyp char(1),
	ds varchar(6), cod dec(6), reason /*pr_cons*/ tinyint, d_u /*dt_cons*/ date,
	recid_s varchar(7),
	serviceId int)
GO
CREATE UNIQUE INDEX idx_facts_consiliums ON facts.consiliums (sn_pol,d_u)
GO 

IF OBJECT_ID('uAddFactConsiliums','TR') IS NOT NULL DROP TRIGGER uAddFactConsiliums
GO
CREATE TRIGGER facts.uAddFactConsiliums ON facts.Consiliums
AFTER INSERT 
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @q char(2)            = (select q from inserted)
	DECLARE @period char(6)       = (select period from inserted)
	DECLARE @mcod char(7)         = (select mcod from inserted)
	DECLARE @recid_lpu varchar(7) = (select recid_s from inserted)

	DECLARE @id int = facts.seek_factservices_recid(@q, @period, @mcod, @recid_lpu)

	DECLARE @recid int = (select serviceId from inserted)
	UPDATE facts.Consiliums SET serviceId=@id WHERE Consiliums.recid_s=@recid_lpu
END
GO
CREATE INDEX idx_Consiliums_q ON facts.Consiliums (q) 
CREATE INDEX idx_Consiliums_period ON facts.Consiliums (period) 
CREATE INDEX idx_Consiliums_mcod ON facts.Consiliums (mcod) 
GO

-- Creating facts.Consiliums (onk_cons)

-- Creating facts.Referrals (onk_napr_v_out) не проверено!
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('facts.Referrals')) DROP TABLE facts.Referrals
CREATE TABLE facts.Referrals (
	q char(2), period_id smallint, period char(6), mcod char(7), lpuid dec(4), /*services_id int,*/
	sn_pol varchar(25), c_i varchar(30), ages dec(3), sex dec(1), AttTyp char(1), ds varchar(6), 
	reason tinyint, lpu_id dec(6), d_u date, n_ref varchar(16),
	recid_s varchar(7),
	serviceId int)
-- Creating facts.Referrals (onk_napr_v_out)
IF OBJECT_ID('uAddFactReferrals','TR') IS NOT NULL DROP TRIGGER uAddFactReferrals
GO
CREATE TRIGGER facts.uAddFactReferrals ON facts.Referrals
AFTER INSERT 
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @q char(2)            = (select q from inserted)
	DECLARE @period char(6)       = (select period from inserted)
	DECLARE @mcod char(7)         = (select mcod from inserted)
	DECLARE @recid_lpu varchar(7) = (select recid_s from inserted)

	DECLARE @id int = facts.seek_factservices_recid(@q, @period, @mcod, @recid_lpu)

	UPDATE facts.Referrals SET serviceId=@id WHERE Referrals.recid_s=@recid_lpu
END
GO
CREATE INDEX idx_Referrals_q ON facts.Referrals (q) 
CREATE INDEX idx_Referrals_period ON facts.Referrals (period) 
CREATE INDEX idx_Referrals_mcod ON facts.Referrals (mcod) 
GO
-- Creating facts.Referrals (onk_napr_v_out)

-- Creating facts.Denials (onk_prot) не проверено!
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('facts.Denials')) DROP TABLE facts.Denials
CREATE TABLE facts.Denials (
	q char(2), period_id smallint, period char(6), mcod char(7), lpuid dec(4), case_id int,
	sn_pol varchar(25), c_i varchar(30), ages dec(3), sex dec(1), AttTyp char(1), ds varchar(6), 
	d_u date, code tinyint,
	recid_sl varchar(7), 
	serviceId int, 
	)
-- Creating facts.Denials (onk_prot)

IF OBJECT_ID('uAddFactDenials','TR') IS NOT NULL DROP TRIGGER uAddFactDenials
GO
CREATE TRIGGER facts.uAddFactDenials ON facts.Denials
AFTER INSERT 
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @q char(7)           = (select q from inserted)
	DECLARE @period char(7)      = (select period from inserted)
	DECLARE @mcod char(7)        = (select mcod from inserted)
	DECLARE @recid_sl varchar(7) = (select recid_sl from inserted)

	DECLARE @serviceId int = facts.seek_factcases_serviceId(@q, @period, @mcod, @recid_sl)

	UPDATE facts.Denials SET serviceId=@serviceId WHERE Denials.recid_sl=@recid_sl
END
GO
CREATE INDEX idx_Denials_q ON facts.Denials (q) 
CREATE INDEX idx_Denials_period ON facts.Denials (period) 
CREATE INDEX idx_Denials_mcod ON facts.Denials (mcod) 
GO

-- Амбулаторно-поликлиническая заболеваемость. Считается только по первичным приемам.

print 'The third step of creating kms database has been performed successfully!'
--print 'Run CreateRelation.sql now!'
print 'Заполняйте БД (aisoms,pr4,pr4st,) из lpu2smo'

-- begin transaction 
 -- здесь что-то делаем
 -- читаем с параметром nolock
-- select * from facts.aisoms with (nolock)
-- и, если все норм, коммитим
-- commit
select * from facts.Services where recid=309248
/*
-- facts.Cases ok!
select a.recid, a.sn_pol, b.recid, b.sn_pol from facts.Services a join facts.Cases b on a.recid=b.recid
select * from facts.Cases
-- facts.Cases ok!

-- facts.Consiliums ok!
select a.recid, a.sn_pol, b.recid, b.sn_pol from facts.Services a join facts.Consiliums b on a.recid=b.recid
select * from facts.Consiliums
-- facts.Consiliums ok!

-- facts.Denials -

-- facts.Drugs -

-- facts.OncoDrugs ok!
select a.recid, a.sn_pol, b.recid, b.sn_pol from facts.Services a join facts.OncoDiag b on a.recid=b.case_id
select * from facts.OncoDiag
-- facts.OncoDrugs ok!

-- facts.OncoServices ok!
select a.recid, a.sn_pol, b.recid, b.sn_pol from facts.Services a join facts.OncoServices b on a.recid=b.case_id
select * from facts.OncoServices
-- facts.OncoServices ok!

-- facts.Referrals ok!
select a.recid, a.sn_pol, b.recid, b.sn_pol from facts.Services a join facts.Referrals b on a.recid=b.recid
select * from facts.Referrals
-- facts.Referrals ok!
*/