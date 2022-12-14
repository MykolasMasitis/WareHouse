-- Четвертый скрипт создания хранилища lpu
-- Полная ревизия закончена к 22.06.2021, загружены данные 202101, объем БД одного месяца 2,5Gb

USE lpu
GO

IF OBJECT_ID('dim.[Хронические заболевания]','V') IS NOT NULL DROP VIEW dim.[Хронические заболевания]
GO
CREATE VIEW dim.[Хронические заболевания] WITH SCHEMABINDING AS SELECT 
	a.code as 'Код диагноза', b.name as 'Диагноз по МКБ-10', a.cnt
	FROM dim.chronicDs a
LEFT OUTER JOIN dim.Ds b ON a.code=b.code
GO
select * from dim.[Хронические заболевания] order by cnt desc 

IF OBJECT_ID('facts.[Операции]','V') IS NOT NULL DROP VIEW facts.[Операции]
GO
CREATE VIEW facts.[Операции] WITH SCHEMABINDING AS SELECT a.period as 'Период', a.mcod, a.lpuid, 
	a.sn_pol as 'Полис ОМС', a.c_i as 'Карта', a.ages as 'Полных лет', f.name as 'Пол', 
	a.ds as 'Код диагноза', d.name as 'Диагноз по МКБ-10', 
	a.service as 'Код услуги', g.name as 'Наименование услуги', 
	a.surgery as 'Код операции', h.name as 'Наименование операции',
	d_u
	FROM facts.Surgeries a
LEFT OUTER JOIN dim.Ds d ON a.ds=d.code
LEFT OUTER JOIN dim.Sex f ON a.sex=f.code
LEFT OUTER JOIN dim.Tarif g ON a.service=g.code
LEFT OUTER JOIN dim.Surgeries h ON a.surgery=h.code
GO
select * from dim.Surgeries where code='A16.20.005.001'
select [Код операции], count(*) as cnt from facts.Операции group by [Код операции] order by cnt desc
select * from facts.Операции where [Код операции]='A16.20.005.001'
IF OBJECT_ID('facts.[МедПомощь]','V') IS NOT NULL DROP VIEW facts.[МедПомощь]
GO
CREATE VIEW facts.[МедПомощь] WITH SCHEMABINDING AS SELECT a.q as 'СМО', a.period as 'Период', a.mcod, a.lpuid, a.fil_id as 'Филиал',
	a.sn_pol as 'Полис ОМС', a.c_i as 'Карта', a.ages as 'Полных лет', /*a.sex,*/ f.name as 'Пол', /*a.AttTyp,*/ c.name as 'Прикрепление',
	a.ord, p.name as 'Тип направления', a.lpu_ord,
	iif(a.ismek=1, 'Да', 'Нет') as 'МЭК', a.cod as 'Код услуги', e.name as 'Наименование услуги', a.usltip, b.name as 'Тип МП', 
	a.usl_ok, q.name as 'Условия оказания',
	a.tip as 'Tip', g.name as 'Признак прерванности', d_u as 'Дата', a.Mp, h.name as 'Канал финансирования',
	a.k_u, a.tarif as 'Тариф', a.s_all as 'Сумма', a.s_lek as 'Стоимость ЛС', a.kd_fact, a.n_kd, a.d_type, a.otd, /*a.otd1, i.name as 'Возраст обслуживания',*/
	/*a.otd23, j.name as 'Профиль отделения', a.profil, l.name as 'profilname', a.otd456, k.name as 'Профиль чего-то',*/
	a.ds as 'Код диагноза', d.name as 'Диагноз по МКБ-10', a.p_cel, r.name as 'Цель посещения'
	/*a.rslt, m.name as 'rslt_name', a.ishod, o.name as 'ishod_name', a.prvs, n.name as 'prvs_name', a.det, a.novor*/
	FROM facts.Services a
LEFT OUTER JOIN dim.UslTip b ON a.usltip=b.code
LEFT OUTER JOIN dim.AttTyp c ON a.Typ=c.code
LEFT OUTER JOIN dim.Ds d ON a.ds=d.code
LEFT OUTER JOIN dim.Tarif e ON a.cod=e.code
LEFT OUTER JOIN dim.Sex f ON a.sex=f.code
LEFT OUTER JOIN dim.Tip g ON a.tip=g.code
LEFT OUTER JOIN dim.FinTyp h ON a.Mp=h.code
/*LEFT OUTER JOIN dim.VozObs i ON a.otd1=i.code*/
/*LEFT OUTER JOIN dim.ProfOt j ON a.otd23=j.code*/
/*LEFT OUTER JOIN dim.Prv002 k ON a.otd456=k.code*/
/*LEFT OUTER JOIN dim.Prv002 l ON a.profil=l.code*/
/*LEFT OUTER JOIN dim.Rslt m ON a.rslt=m.code*/
/*LEFT OUTER JOIN dim.Prvs n ON a.prvs=n.code*/
/*LEFT OUTER JOIN dim.Ishod o ON a.ishod=o.code*/
LEFT OUTER JOIN dim.Ord p ON a.ord=p.code
LEFT OUTER JOIN dim.UslOK q ON a.usl_ok=q.code

LEFT OUTER JOIN dim.p_cel r ON a.p_cel=r.code
GO
-- select top 100 * from facts.[МедПомощь]

IF OBJECT_ID('facts.[ОнкоСлучаи]','V') IS NOT NULL DROP VIEW facts.[ОнкоСлучаи]
GO
CREATE VIEW facts.[ОнкоСлучаи] WITH SCHEMABINDING AS SELECT a.period as 'Период', a.mcod, a.lpuid, 
	a.sn_pol as 'Полис ОМС', a.c_i as 'Карта', a.ages as 'Полных лет', f.name as 'Пол', c.name as 'Прикрепление',
	a.ds as 'Код диагноза', d.name as 'Диагноз по МКБ-10', a.cod, e.name as 'Наименование услуги', a.d_u,
	a.ds1_t, g.name as 'Повод обращения', /*a.stad,*/ h.st as 'Стадия', /*a.onk_t,*/ i.t as 'Tumor', 
	/*a.onk_n, */j.n as 'Nodus', /*a.onk_m,*/ k.m as 'Metastatis', iif(a.mtstz=1, 'Да', 'Нет') as 'Метастазы',
	a.sod as 'Суммарная очаговая доза', a.k_fr as 'Кол-ов фракций', a.wei as 'Вес', a.hei as 'Рост', a.bsa as 'Площадь тела'
	FROM facts.Cases a
LEFT OUTER JOIN dim.AttTyp c ON a.AttTyp=c.code
LEFT OUTER JOIN dim.Ds d ON a.ds=d.code
LEFT OUTER JOIN dim.Tarif e ON a.cod=e.code
LEFT OUTER JOIN dim.Sex f ON a.sex=f.code
LEFT OUTER JOIN dim.ds1_t g ON a.ds1_t=g.code
LEFT OUTER JOIN dim.stad h ON a.stad=h.code
LEFT OUTER JOIN dim.onk_t i ON a.onk_t=i.code
LEFT OUTER JOIN dim.onk_n j ON a.onk_n=j.code
LEFT OUTER JOIN dim.onk_m k ON a.onk_m=k.code
GO
-- select top 100 * from facts.[ОнкоСлучаи]

IF OBJECT_ID('facts.[ОнкоУслуги]','V') IS NOT NULL DROP VIEW facts.[ОнкоУслуги]
GO
CREATE VIEW facts.[ОнкоУслуги] WITH SCHEMABINDING AS SELECT a.period as 'Период', a.mcod, a.lpuid, 
	a.sn_pol as 'Полис ОМС', a.c_i as 'Карта', a.ages as 'Полных лет', f.name as 'Пол', c.name as 'Прикрепление',
	a.ds as 'Код диагноза', d.name as 'Диагноз по МКБ-10', a.cod, e.name as 'Наименование услуги', a.d_u,
	a.onlech, h.name as 'Тип услуги', a.onhir, i.name as 'Тип хирургического лечения', a.onlekl, j.name as 'Линия лекарственной терапии', 
	a.onlekv, k.name as 'Цикл лекарственной терапии', a.onluch, l.name as 'Тип лучевой терапии', a.pptr
	FROM facts.OncoServices a
LEFT OUTER JOIN dim.AttTyp c ON a.AttTyp=c.code
LEFT OUTER JOIN dim.Ds d ON a.ds=d.code
LEFT OUTER JOIN dim.Tarif e ON a.cod=e.code
LEFT OUTER JOIN dim.Sex f ON a.sex=f.code
LEFT OUTER JOIN dim.onlech h ON a.onlech=h.code
LEFT OUTER JOIN dim.onhir i ON a.onhir=i.code
LEFT OUTER JOIN dim.onlekl j ON a.onlekl=j.code
LEFT OUTER JOIN dim.onlekv k ON a.onlekv=k.code
LEFT OUTER JOIN dim.onluch l ON a.onluch=l.code
GO
select top 100 * from facts.[ОнкоУслуги]

IF OBJECT_ID('facts.[Диагноситические показатели]','V') IS NOT NULL DROP VIEW facts.[Диагноситические показатели]
GO
CREATE VIEW facts.[Диагноситические показатели] WITH SCHEMABINDING AS SELECT a.period as 'Период', a.mcod, a.lpuid, 
	a.sn_pol as 'Полис ОМС', a.c_i as 'Карта', a.ages as 'Полных лет', f.name as 'Пол', c.name as 'Прикрепление',
	a.ds as 'Код диагноза', d.name as 'Диагноз по МКБ-10', a.d_u as 'Дата исследования', 
	a.tip, g.name as 'Тип диагностического показателя', a.mrf, h.name as 'Диагностический показатель mrf', 
	a.mrf_rslt, i.name as 'Результат mrf', a.igh, j.name as 'Диагностический показатель igh', a.igh_rslt, k.name as 'Результат igh', 
	a.rslt as 'Результат'
	FROM facts.OncoDiag a
LEFT OUTER JOIN dim.AttTyp c ON a.AttTyp=c.code
LEFT OUTER JOIN dim.Ds d ON a.ds=d.code
LEFT OUTER JOIN dim.Tarif e ON a.cod=e.code
LEFT OUTER JOIN dim.Sex f ON a.sex=f.code
LEFT OUTER JOIN dim.diagtip g ON a.tip=g.code
LEFT OUTER JOIN dim.mrf h ON a.mrf=h.code
LEFT OUTER JOIN dim.mrf_rslt i ON a.mrf_rslt=i.code
LEFT OUTER JOIN dim.igh j ON a.igh=j.code
LEFT OUTER JOIN dim.igh_rslt k ON a.igh_rslt=k.code
GO
select top 100 * from facts.[Диагноситические показатели]

IF OBJECT_ID('facts.[Морфологические исследования]','V') IS NOT NULL DROP VIEW facts.[Морфологические исследования]
GO
CREATE VIEW facts.[Морфологические исследования] WITH SCHEMABINDING AS SELECT a.period as 'Период', a.mcod, a.lpuid, 
	a.sn_pol as 'Полис ОМС', a.c_i as 'Карта', a.ages as 'Полных лет', f.name as 'Пол', c.name as 'Прикрепление',
	a.ds as 'Код диагноза', d.name as 'Диагноз по МКБ-10', a.d_u as 'Дата исследования', 
	'гистологический признак' as 'Тип диагностического показателя', 
	a.mrf, h.name as 'Диагностический показатель mrf', 
	a.mrf_rslt, i.name as 'Результат mrf', 
	a.rslt as 'Результат'
	FROM facts.mrf a
LEFT OUTER JOIN dim.AttTyp c ON a.AttTyp=c.code
LEFT OUTER JOIN dim.Ds d ON a.ds=d.code
LEFT OUTER JOIN dim.Tarif e ON a.cod=e.code
LEFT OUTER JOIN dim.Sex f ON a.sex=f.code
LEFT OUTER JOIN dim.mrf h ON a.mrf=h.code
LEFT OUTER JOIN dim.mrf_rslt i ON a.mrf_rslt=i.code
GO
select top 100 * from facts.[Морфологические исследования]

IF OBJECT_ID('facts.[Имунногистохимические ислледования]','V') IS NOT NULL DROP VIEW facts.[Имунногистохимические ислледования]
GO
CREATE VIEW facts.[Имунногистохимические ислледования] WITH SCHEMABINDING AS SELECT a.period as 'Период', a.mcod, a.lpuid, 
	a.sn_pol as 'Полис ОМС', a.c_i as 'Карта', a.ages as 'Полных лет', f.name as 'Пол', c.name as 'Прикрепление',
	a.ds as 'Код диагноза', d.name as 'Диагноз по МКБ-10', a.d_u as 'Дата исследования', 
	'маркёр (ИГХ)' as 'Тип диагностического показателя', 
	a.igh, j.name as 'Диагностический показатель igh', a.igh_rslt, k.name as 'Результат igh', 
	a.rslt as 'Результат'
	FROM facts.igh a
LEFT OUTER JOIN dim.AttTyp c ON a.AttTyp=c.code
LEFT OUTER JOIN dim.Ds d ON a.ds=d.code
LEFT OUTER JOIN dim.Tarif e ON a.cod=e.code
LEFT OUTER JOIN dim.Sex f ON a.sex=f.code
LEFT OUTER JOIN dim.igh j ON a.igh=j.code
LEFT OUTER JOIN dim.igh_rslt k ON a.igh_rslt=k.code
GO
select top 100 * from facts.[Имунногистохимические ислледования]


IF OBJECT_ID('facts.[Лекарственные средства]','V') IS NOT NULL DROP VIEW facts.[Лекарственные средства]
GO
CREATE VIEW facts.[Лекарственные средства] WITH SCHEMABINDING AS SELECT a.period as 'Период', a.mcod, a.lpuid, a.sn_pol as 'Полис ОМС', a.c_i as 'Карта', a.ages as 'Полных лет', 
	/*a.sex,*/ f.name as 'Пол', /*a.AttTyp,*/ c.name as 'Прикрепление',
	a.ds as 'Код диагноза', iif(a.isokds=1, 'Да', 'Нет') as 'Диагноз допустимый?',/*d.name as 'Диагноз по МКБ-10',  */
	/*a.cod as 'Код услуги',*/ iif(a.isokcod=1, 'Да', 'Нет') as 'Услуга допустимая?', e.name as 'Услуга/койко-день/МЭС', 
	a.regnum, a.d_u as 'Дата применения', a.code_sh as 'Код схемы', a.n_par, a.r_up, g.name as 'Наименование упаковки', a.tip_opl, a.n_ru, 
	a.ot_d as 'Дневная доза', a.dt_q, a.dt_d as 'Курсовая доза', a.sid, a.gd_sid, a.edizm as 'Единица измерения', a.tarif as 'Стоимость единицы',
	a.en as 'Единиц назначения', a.s_all as 'Стоимость курса',
	b.name as 'Наименование ЛС', b.forlek
	FROM facts.Drugs a
LEFT OUTER JOIN dim.TariOn b ON a.gd_sid=b.code
LEFT OUTER JOIN dim.AttTyp c ON a.AttTyp=c.code
/*LEFT OUTER JOIN dim.Ds d ON a.ds=d.cod*/
LEFT OUTER JOIN dim.Tarif e ON a.cod=e.code
LEFT OUTER JOIN dim.Sex f ON a.sex=f.code
LEFT OUTER JOIN dim.medpack g ON a.r_up=g.r_up
GO
select top 100 * from facts.[Лекарственные средства]

IF OBJECT_ID('facts.[Направления]','V') IS NOT NULL DROP VIEW facts.[Направления]
GO
CREATE VIEW facts.[Направления] WITH SCHEMABINDING AS SELECT a.period as 'Период', a.mcod, a.lpuid, 
	a.sn_pol as 'Полис ОМС', a.c_i as 'Карта', a.ages as 'Полных лет', f.name as 'Пол', c.name as 'Прикрепление',
	a.ds as 'Код диагноза', d.name as 'Диагноз по МКБ-10', 
	a.reason, g.name as 'Цель направления', a.lpu_id as 'МО направления', a.d_u as 'Дата направления', a.n_ref as 'Номер направления'
	FROM facts.Referrals a
LEFT OUTER JOIN dim.AttTyp c ON a.AttTyp=c.code
LEFT OUTER JOIN dim.Ds d ON a.ds=d.code
LEFT OUTER JOIN dim.Sex f ON a.sex=f.code
LEFT OUTER JOIN dim.onnapr g ON a.reason=g.code
GO

select top 100 * from facts.[Направления]

IF OBJECT_ID('facts.[Онкоконсилиумы]','V') IS NOT NULL DROP VIEW facts.[Онкоконсилиумы]
GO
CREATE VIEW facts.[Онкоконсилиумы] WITH SCHEMABINDING AS SELECT a.period as 'Период', a.mcod, a.lpuid, 
	a.sn_pol as 'Полис ОМС', a.c_i as 'Карта', a.ages as 'Полных лет', f.name as 'Пол', c.name as 'Прикрепление',
	a.ds as 'Код диагноза', d.name as 'Диагноз по МКБ-10', 
	a.cod, g.name as 'Наименование услуги', d_u, a.reason, h.name
	FROM facts.Consiliums a
LEFT OUTER JOIN dim.AttTyp c ON a.AttTyp=c.code
LEFT OUTER JOIN dim.Ds d ON a.ds=d.code
LEFT OUTER JOIN dim.Sex f ON a.sex=f.code
LEFT OUTER JOIN dim.Tarif g ON a.cod=g.code
LEFT OUTER JOIN dim.consiliumreason h ON a.reason=h.code
GO

select top 100 * from facts.[Онкоконсилиумы]

select * from facts.Consiliums
select recid, count(*) from facts.Consiliums group by recid having count(*)>1
select * from facts.Онкоконсилиумы
select reason, count(*) from facts.[Онкоконсилиумы] group by reason

IF OBJECT_ID('facts.vw_pr4','V') IS NOT NULL DROP VIEW facts.vw_pr4
GO
create view facts.vw_pr4 with schemabinding as 
select q, period, mcod,
	(select count(distinct sn_pol) from facts.Services where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental=0 and f_type in ('ft','fp','vz','up')) as p_all,
	(select sum(s_all) from facts.Services where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental=0 and f_type in ('ft','fp','vz','up')) as s_all,
	(select count(distinct sn_pol) from facts.Services  where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental=0 and f_type='vz') as p_guests,
	(select sum(s_all) from facts.Services where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental=0 and f_type='vz') as s_guests,
	(select count(distinct sn_pol) from facts.Services where q=a.q and period=a.period and prmcod=a.mcod and ismek=0 and IsDental=0 and f_type='vz') as p_others,
	(select sum(s_all) from facts.Services where q=a.q and period=a.period and prmcod=a.mcod and ismek=0 and IsDental=0 and f_type='vz') as s_others,
	(select count(distinct sn_pol) from facts.Services where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental=0 and f_type='up') as p_bad,
	(select sum(s_all) from facts.Services where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental=0 and f_type='up') as s_bad,
	(select count(distinct sn_pol) from facts.Services  where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental=0 and f_type='fp') as p_own,
	(select sum(s_all) from facts.Services where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental=0 and f_type='fp') as s_own,
	(select count(distinct sn_pol) from facts.Services where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental=0 and f_type='ft') as p_empty,
	(select sum(s_all) from facts.Services where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental=0 and f_type='ft') as s_empty
	from facts.pr4 a
go 

IF OBJECT_ID('facts.fn_pr4','IF') IS NOT NULL DROP FUNCTION facts.fn_pr4
GO
CREATE FUNCTION facts.fn_pr4 (@period char(6))
RETURNS TABLE
AS
RETURN 
select mcod,
	(select count(distinct sn_pol) from facts.Services where period=@period and mcod=a.mcod and ismek=0 and mp='p') as p_all,
	(select sum(s_all) from facts.Services where period=@period and mcod=a.mcod and ismek=0 and mp='p') as s_all,
	(select count(distinct sn_pol) from facts.Services where period=@period and mcod=a.mcod and ismek=0 and mp='p' and vz>0 ) as p_guests,
	(select sum(s_all) from facts.Services where period=@period and mcod=a.mcod and ismek=0 and vz>0) as s_guests,
	(select count(distinct sn_pol) from facts.Services where period=@period and prmcod=a.mcod and ismek=0 and mp='p' and typ='2' and vz>0) as p_others,
	(select sum(s_all) from facts.Services where period=@period and prmcod=a.mcod and ismek=0 and mp in ('p') and typ='2' and vz>0) as s_others,
	(select count(distinct sn_pol) from facts.Services where period=@period and mcod=a.mcod and ismek=0 and mp='p' and typ='2' and vz=0) as p_bad,
	(select sum(s_all) from facts.Services where period=@period and mcod=a.mcod and ismek=0 and mp='p' and typ='2' and vz=0) as s_bad,
	(select count(distinct sn_pol) from facts.Services where period=@period and mcod=a.mcod and ismek=0 and typ='1' and mp='p') as p_own,
	(select sum(s_all) from facts.Services where period=@period and mcod=a.mcod and ismek=0 and typ='1' and mp='p') as s_own,
	(select count(distinct sn_pol) from facts.Services where period=@period and mcod=a.mcod and ismek=0 and typ='0' and mp='p') as p_empty,
	(select sum(s_all) from facts.Services where period=@period and mcod=a.mcod and ismek=0 and typ='0' and mp='p') as s_empty
	from facts.pr4 a where period=@period
go

--select  * into dbo.pr4_202101 from dbo.fn_pr4('202101')

--IF OBJECT_ID('dbo.vw_pr4st','V') IS NOT NULL DROP VIEW dbo.vw_pr4st
--GO
--create view dbo.vw_pr4st with schemabinding as 
--select mcod,
--	(select count(distinct sn_pol) from facts.Services where mcod=a.mcod and ismek=0 and Mp in ('s')) as p_all,
--	(select sum(s_all) from facts.Services where mcod=a.mcod and ismek=0 and Mp in ('s')) as s_all,
--	(select count(distinct sn_pol) from facts.Services where mcod=a.mcod and ismek=0 and vz>0 and Mp in ('s')) as p_guests,
--	(select sum(s_all) from facts.Services where mcod=a.mcod and ismek=0 and  vz>0 and Mp in ('s')) as s_guests,
--	(select count(distinct sn_pol) from facts.Services where prmcod=a.mcod and ismek=0 and vz>0 and Mp in ('s')) as p_others,
--	(select sum(s_all) from facts.Services where prmcod=a.mcod and ismek=0 and vz>0 and Mp in ('s')) as s_others,
--	(select count(distinct sn_pol) from facts.Services where mcod=a.mcod and ismek=0 and typ='1' and Mp in ('s')) as p_own,
--	(select sum(s_all) from facts.Services where mcod=a.mcod and ismek=0 and typ='1' and Mp in ('s')) as s_own,
--	(select count(distinct sn_pol) from facts.Services where mcod=a.mcod and ismek=0 and typ='0' and Mp in ('s')) as p_empty,
--	(select sum(s_all) from facts.Services where mcod=a.mcod and ismek=0 and typ='0' and Mp in ('s')) as s_empty
--	from dbo.pr4st a /*facts.Services a where a.ispilots=1 group by mcod*/
--go 

IF OBJECT_ID('facts.vw_pr4st','V') IS NOT NULL DROP VIEW facts.vw_pr4st
GO
create view facts.vw_pr4st with schemabinding as 
select q, period, mcod,
	(select count(distinct sn_pol) from facts.Services where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental<>0 and f_type in ('ft','fp','vz','up')) as p_all,
	(select sum(s_all) from facts.Services where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental<>0 and f_type in ('ft','fp','vz','up')) as s_all,
	(select count(distinct sn_pol) from facts.Services where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental<>0 and f_type='vz') as p_guests,
	(select sum(s_all) from facts.Services where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental<>0 and f_type='vz') as s_guests,
	(select count(distinct sn_pol) from facts.Services where q=a.q and period=a.period and prmcod=a.mcod and ismek=0 and IsDental<>0 and f_type='vz') as p_others,
	(select sum(s_all) from facts.Services where q=a.q and period=a.period and prmcod=a.mcod and ismek=0 and IsDental<>0 and f_type='vz') as s_others,
	(select count(distinct sn_pol) from facts.Services where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental<>0 and f_type='up') as p_bad,
	(select sum(s_all) from facts.Services where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental<>0 and f_type='up') as s_bad,
	(select count(distinct sn_pol) from facts.Services where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental<>0 and f_type='fp') as p_own,
	(select sum(s_all) from facts.Services where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental<>0 and f_type='fp') as s_own,
	(select count(distinct sn_pol) from facts.Services where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental<>0 and f_type='ft') as p_empty,
	(select sum(s_all) from facts.Services where q=a.q and period=a.period and mcod=a.mcod and ismek=0 and IsDental<>0 and f_type='ft') as s_empty
	from facts.pr4st a
go 

select * from facts.vw_pr4st

select sum(p_all) as p_all, sum(s_all) as s_all, 
	   sum(p_own) as p_own, sum(s_own) as s_own, 
	   sum(p_empty) as p_empty, sum(s_empty) as s_empty,
	   sum(p_guests) as p_guests, sum(s_guests) as s_guests, 
	   sum(p_others) as p_others, sum(s_others) as s_others
	   from facts.vw_pr4st
go 

IF OBJECT_ID('facts.vw_mag02','V') IS NOT NULL DROP VIEW facts.vw_mag02
GO
create view facts.vw_mag02 with schemabinding as 
select period, mcod,
	(select sum(s_all) from facts.Services where period=a.period and mcod=a.mcod) as s_all,  -- 
	(select sum(s_lek) from facts.Services where period=a.period and mcod=a.mcod) as s_lek,  -- ok
	(select sum(s_all+s_lek) from facts.Services where period=a.period and mcod=a.mcod and f_type='st' /*usltip in (4,5,6)*/) as st_all, -- ok
	(select sum(s_all+s_lek) from facts.Services where period=a.period and mcod=a.mcod /*and IsDental=0*/ and f_type='fh' /*Mp in ('4','8')*//* and ismek=0*/) as s_dop, -- ok
	(select sum(s_all) from facts.Services where period=a.period and mcod=a.mcod and IsDental<>0 and f_type='fh' /*Mp in ('8')*/) as st_dop, -- ok

	(select sum(s_all) from facts.Services where period=a.period and mcod=a.mcod and IsDental>0 /*and
		(ispilots>0 or mcod in ('4344623','4344700','4344621','4344640','4344613','4134752','0343036','0244124'))*/ and f_type<>'fh' /*(Mp<>'8'*/) 
		as s_dental,
	(select sum(s_all) from facts.Services where period=a.period and mcod=a.mcod and IsDental>0 and
		(ispilots>0 or mcod in ('4344623','4344700','4344621','4344640','4344613','4134752','0343036','0244124')) and f_type<>'fh' /*Mp<>'8'*/ and typ='0') 
		as sd_empty,
	
	(select sum(s_all) from facts.Services where period=a.period and mcod=a.mcod and ismek>0) as s_mek,
	(select sum(s_lek) from facts.Services where period=a.period and mcod=a.mcod and ismek>0) as ls_mek,
	(select sum(s_all) from facts.Services where period=a.period and mcod=a.mcod and ismek>0 and IsDental=0 and f_type in ('ft','fp','vz','up') /*Mp='p'*/ and ispilot>0) as s_pmek,
	(select sum(s_all) from facts.Services where period=a.period and mcod=a.mcod and ismek>0 and IsDental>0 and f_type in ('ft','fp','vz','up') /*Mp='s' and ispilots>0*/) as s_pstmek,
	(select sum(s_all) from facts.Services where period=a.period and mcod=a.mcod and ismek>0 and IsDental>0 and f_type not in ('ft','fp','vz','up') /*Mp<>'s'*/) as s_dstmek,
	(select sum(s_all) from facts.Services where period=a.period and mcod=a.mcod and ismek>0 and IsDental>0 and f_type in ('ft','fp','vz','up') /*Mp<>'s'*/ and typ='0') as s_dstmek0,
	(select sum(s_all) from facts.Services where period=a.period and mcod=a.mcod and ismek>0 and IsDental=0 and (ispilot=0 or f_type not in ('ft','fp','vz','up')) /*Mp<>'p'*/) as s_dmek

	from facts.Services a group by period, mcod
go 

-- сверить вручную с итоговыми цифрами формы МАГ-02
	declare @period char(6)='202105'
	select sum(s_all) as s_all, sum(s_lek) as s_lek, sum(st_all) as st_all, sum(s_dop) as s_dop, sum(st_dop) as st_dop,
		sum(s_dental) as s_dental, sum(sd_empty) as sd_empty, 
		sum(s_mek) as s_mek, sum(ls_mek) as ls_mek, sum(s_pmek) as s_pmek, sum(s_pstmek) as s_pstmek,
		sum(s_dstmek) as s_dstmek, sum(s_dstmek0) as s_dstmek0, sum(s_dmek) as s_dmek
		from dbo.vw_mag02 where period=@period
	go

-- Для 201904
begin transaction 
update facts.Services set mp='p' where mcod='0105115' and mp!='p'
commit 

update facts.Services set typ='1' where sn_pol='7747710839003651'

begin transaction 
update facts.Services set mp='8' where mcod='6343085' and s_all=480.92 and sn_pol='7747310881001180'
commit

begin transaction 
update facts.Services set mp='8' where mcod='5105932' and s_all=495.70 and sn_pol='7771850893001552'
commit 

select * from facts.Services where mp='p' and ispilot=0 and ishorlpu=0

select * from facts.Services where mp='4' and ispilot=0 and ishorlpu=0
select * from facts.Services where mp='4' and ispilot=0

begin transaction 
-- update facts.Services set mp = null where mp='4' and ispilot=0 and ishorlpu=0 Нельзя! Допуслуги у всех!
commit 


select * from facts.Services where mp='8' and ispilots=0 and ishorlpus=0

select * from facts.Services where mp='p' and ispilot=0 and ishorlpu=0

begin transaction 
update facts.Services set mp = null where mp='p' and ispilot=0 and ishorlpu=0
commit 

select * from facts.Services where mp='s' and ispilots=0 and ishorlpus=0
begin transaction 
update facts.Services set mp = null where mp='s' and ispilots=0 and ishorlpus=0
rollback 
commit 
-- Для 201904
go 

IF OBJECT_ID('dbo.vw_sh0','V') IS NOT NULL DROP VIEW dbo.vw_sh0
GO
create view dbo.vw_sh0  with schemabinding as 
select mcod,
	(select count(distinct sn_pol) from facts.Services where mcod=a.mcod and usl_ok=3) as acc_plk,
	(select sum(k_u) from facts.Services where mcod=a.mcod and usl_ok=3) as usl_plk, 
	(select sum(s_all) from facts.Services where mcod=a.mcod and usl_ok=3) as sum_plk,
	(select count(distinct sn_pol) from facts.Services where mcod=a.mcod and usl_ok=2) as acc_dst,
	(select sum(k_u) from facts.Services where mcod=a.mcod and usl_ok=2) as usl_dst, 
	(select sum(s_all) from facts.Services where mcod=a.mcod and usl_ok=2) as sum_dst,
	(select count(distinct c_i) from facts.Services where mcod=a.mcod and usl_ok=1) as acc_st,
	(select count(cod) from facts.Services where mcod=a.mcod and usl_ok=1) as usl_st, 
	(select sum(s_all) from facts.Services where mcod=a.mcod and usl_ok=1) as sum_st,
	(select count(distinct c_i) from facts.Services where mcod=a.mcod and usl_ok=4) as acc_02,
	(select count(cod) from facts.Services where mcod=a.mcod and usl_ok=4) as usl_02, 
	(select sum(s_all) from facts.Services where mcod=a.mcod and usl_ok=4) as sum_02

	from facts.Services a group by mcod
go 


IF OBJECT_ID('facts.vw_checkpr4','V') IS NOT NULL DROP VIEW facts.vw_checkpr4
GO
create view facts.vw_checkpr4  with schemabinding as 
select mcod, p_all, s_all, p_own, s_own, p_guests, s_guests from 
(select mcod, 
	p_all, coalesce((select s_all from facts.vw_pr4 b where mcod=a.mcod), 0) as s_all,
	p_own, coalesce((select s_own from facts.vw_pr4 b where mcod=a.mcod), 0) as s_own,
	p_guests, coalesce((select s_guests from facts.vw_pr4 b where mcod=a.mcod), 0) as s_guests,
	p_others, coalesce((select s_others from facts.vw_pr4 b where mcod=a.mcod), 0) as s_others,
	p_bad, coalesce((select s_bad from facts.vw_pr4 b where mcod=a.mcod), 0) as s_bad
	from facts.pr4 a) b /*where a.p_all<>b.p_all or b.s_all<>b.s_all or b.p_own<>b.p_own or b.s_own<>b.s_own or
	b.p_guests<>b.p_guests or b.s_guests<>b.s_guests or b.p_others<>b.p_others or b.s_others<>b.s_others or
	b.p_bad<>b.p_bad or b.s_bad<>b.s_bad*/
go 

select a.mcod, a.s_all, b.s_all, a.s_own, b.s_own, a.s_others, b.s_others
	from dbo.pr4st a right outer join dbo.vw_pr4st b on a.mcod=b.mcod 
	where a.s_all<>b.s_all or a.s_own<>b.s_own or a.s_others<>b.s_others

select a.mcod, a.s_all, b.s_all, a.s_own, b.s_own 
	from dbo.pr4 a left join dbo.vw_pr4 b on a.mcod=b.mcod 

select * from dbo.vw_pr4
select * from dbo.pr4

select * from dbo.vw_checkpr4

select sum(s_all) from facts.services
select sum(s_all) from facts.services where ismek>0



select * from facts.Cases

select a.recid, a.sn_pol, b.recid, b.sn_pol from facts.Services a
	inner join facts.cases b on a.recid=b.recid 

select * from facts.[ОнкоСлучаи]

select * from facts.Consiliums

select vz, count(*) from facts.services group by vz

select cod,floor(cod/1000) from facts.services where cod=97002

select * from facts.services where floor(cod/1000)=99


select * from facts.services

select CEILING(125000/1000)


SELECT top 10 a.period as 'Период', a.mcod, a.lpuid, a.fil_id as 'Филиал',
	a.sn_pol as 'Полис ОМС', a.c_i as 'Карта', a.ages as 'Полных лет', 
	a.ord, a.lpu_ord,
	iif(a.ismek=1, 'Да', 'Нет') as 'МЭК', a.usltip, b.name as 'Тип МП'
	FROM facts.Services a
LEFT OUTER JOIN dim.UslTip b ON a.usltip=b.code

SELECT top 10 a.period as 'Период', a.mcod, a.lpuid, a.fil_id as 'Филиал',
	a.sn_pol as 'Полис ОМС', a.c_i as 'Карта', a.ages as 'Полных лет', 
	a.ord, a.lpu_ord,
	iif(a.ismek=1, 'Да', 'Нет') as 'МЭК', a.usltip, b.name as 'Тип МП'
	FROM facts.Services a
LEFT OUTER JOIN dim.UslTip b ON a.usltip>b.code

update facts.Services set mp='' where period='202105' and  mp='p' and f_type not in ('ft','fp','vz','up')

