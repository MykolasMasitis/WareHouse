-- Creating facts.OncoDiag (onk_diag)
-- Таблица диагностических процедур при ЗНО
/*
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('facts.OncoDiag')) DROP TABLE facts.OncoDiag
CREATE TABLE facts.OncoDiag (
	q char(2), period_id smallint, period char(6), mcod char(7), lpuid dec(4), /*services_id int,*/
	sn_pol varchar(25), c_i varchar(30), ages dec(3), sex dec(1), AttTyp char(1),
	ds varchar(6), cod dec(6), 
	d_u date, 
	-- 1 - mrf или 2 - igh
	tip tinyint, /* diag_code dec(3),*/ 
	-- гистологический признак (морфология)
	mrf tinyint, mrf_rslt tinyint, 
	-- иммуногистохимический анализ
	igh tinyint, igh_rslt tinyint, 
	rslt tinyint/*1 или пусто*/, met_issl tinyint /*метод исследования, не заполняется!*/,
	recid_sl varchar(7), 
	serviceId int NOT NULL
	)
-- Creating facts.OncoDiag
GO
--CREATE UNIQUE INDEX idx_factsoncodiag_unik ON facts.OncoDiag (q, period, mcod, sn_pol, cod, diag_tip, diag_code, diag_rslt)
GO 
IF OBJECT_ID('facts.uAddFactOncoDiag','TR') IS NOT NULL DROP TRIGGER facts.uAddFactOncoDiag
GO
CREATE TRIGGER facts.uAddFactOncoDiag ON facts.OncoDiag
AFTER INSERT 
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @q char(6)           = (select q from inserted)
	DECLARE @period char(6)      = (select period from inserted)
	DECLARE @mcod char(7)        = (select mcod from inserted)
	DECLARE @recid_sl varchar(7) = (select recid_sl from inserted)

	DECLARE @serviceId int = facts.seek_factcases_serviceId(@q, @period, @mcod, @recid_sl)
	UPDATE facts.OncoDiag SET serviceId=@serviceId WHERE OncoDiag.recid_sl=@recid_sl

END
GO
-- Creating facts.OncoDiag (onk_diag)
*/
