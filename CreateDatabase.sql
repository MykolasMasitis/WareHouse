-- Скрипт создания хранилища lpu (Data Warehouse, DWH)
-- Начало разработки: 04 августа 2019 г.
-- Полная ревизия закончена к 22.06.2021, загружены данные 202101, объем БД одного месяца 2,5Gb, после добавления 202102 20813,56 MB
-- Хранилище больше не пересоздавать, все ОК!

-- DBCC SHRINKDATABASE ('lpu', 10) упаковка БД. После многократного BulkImport размер вырос до 20813,56 MB, после упаковки уменьшился до 5196.13 MB
-- DBCC SHRINKDATABASE ('lpu', truncateonly)
-- EXEC sp_spaceused определение размера БД
-- SELECT name, log_reuse_wait_desc FROM sys.databases 
-- DBCC SHRINKFILE (1,TRUNCATEONLY)
 -- DBCC SHRINKFILE ('lpu_log', 200)

-- DBCC SQLPERF ( LOGSPACE ) -- сколько занимет лог-файл

-- select file_name(7)

-- SELECT name, log_reuse_wait_desc FROM sys.databases 
--  select * from sys.dm_tran_session_transactions

-- commit transaction 

-- SELECT name,recovery_model_desc AS Recovery_model 
-- FROM sys.databases 
-- ORDER BY recovery_model_desc, name

-- проверить, нет ли активных транзакций
dbcc opentran
use lpu
commit tran 

select @@VERSION
USE [master]
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name=N'lpu')
 BEGIN 
  ALTER DATABASE lpu SET single_user WITH rollback immediate
  DROP DATABASE lpu
END 
GO

DECLARE @DWH_PATH varchar(256)
-- Директория должны быть предварительно создана, иначе ошибка
SET @DWH_PATH = 'D:\MSSQL\DATA\lpu\'

DECLARE @Sql varchar(max)
-- Заменить название lpu на то, что надо !
SET @Sql = 
'CREATE DATABASE lpu CONTAINMENT = NONE 
 ON  PRIMARY 
( NAME = "lpu", FILENAME = ' + QUOTENAME(@DWH_PATH +'lpu.mdf', '''' ) + ' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ),
 FILEGROUP [Temporary]
( NAME = "Temp", FILENAME = ' + QUOTENAME(@DWH_PATH +'Temp.ndf', '''' ) + ' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [Default] DEFAULT
( NAME = "Default", FILENAME = ' + QUOTENAME(@DWH_PATH +'Default.ndf', '''' ) + ', SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [FastGrowingFiles]
( NAME = "FastGrowingFiles", FILENAME = ' + QUOTENAME(@DWH_PATH +'BigAndFast.ndf', '''' )  + ' , SIZE = 3GB , MAXSIZE = UNLIMITED, FILEGROWTH = 1GB ), 
 FILEGROUP [SlowGrowingFiles]
( NAME = "SlowGrowingFiles", FILENAME = ' + QUOTENAME(@DWH_PATH +'SmallAndSlow.ndf', '''' )  +' , SIZE =5012KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = "lpu_log", FILENAME = ' + QUOTENAME(@DWH_PATH +'lpu_log.ldf', '''' ) + ' , SIZE = 1GB , MAXSIZE = UNLIMITED , FILEGROWTH = 10%)
COLLATE Cyrillic_General_CI_AI'
EXEC (@Sql)
-- Модель восстановления Simple!
ALTER DATABASE lpu SET RECOVERY SIMPLE;
GO

USE lpu
GO

-- Схема для размерностей
IF EXISTS (SELECT * FROM sys.schemas WHERE name='dim') DROP SCHEMA dim
GO
CREATE SCHEMA dim
GO
-- Схема для фактов
IF EXISTS (SELECT * FROM sys.schemas WHERE name='facts') DROP SCHEMA facts
GO
CREATE SCHEMA facts
GO
-- Схема для расчетов
IF EXISTS (SELECT * FROM sys.schemas WHERE name='cal') DROP SCHEMA calc
GO
CREATE SCHEMA calc
GO
-- Schema for data marts
IF EXISTS (SELECT * FROM sys.schemas WHERE name='marts') DROP SCHEMA cmarts
GO
CREATE SCHEMA marts
GO


-- Схема для статистики
IF EXISTS (SELECT * FROM sys.schemas WHERE name='Статистика') DROP SCHEMA Статистика
GO
CREATE SCHEMA Статистика
GO

IF EXISTS (SELECT * FROM sys.schemas WHERE name='Диагнозы') DROP SCHEMA Диагнозы
GO
CREATE SCHEMA Диагнозы
GO

IF EXISTS (SELECT * FROM sys.schemas WHERE name='Наблюдение') DROP SCHEMA Наблюдение
GO
CREATE SCHEMA Наблюдение
GO

IF EXISTS (SELECT * FROM sys.schemas WHERE name='Заболеваемость') DROP SCHEMA Заболеваемость
GO
CREATE SCHEMA Заболеваемость
GO
IF EXISTS (SELECT * FROM sys.schemas WHERE name='Форма12') DROP SCHEMA Форма12
GO
CREATE SCHEMA Форма12
GO

-- This only works in Enterprise edition
IF EXISTS(SELECT * FROM sys.partition_functions WHERE name = 'pfServices' ) 
	DROP PARTITION FUNCTION pfServices
GO 
CREATE PARTITION FUNCTION pfServices (smallint) AS RANGE RIGHT 
	FOR VALUES (2020,2021,2022)
GO 
-- This only works in Enterprise edition

-- Сделать Job и запустить его 01.01.2020
--ALTER PARTITION FUNCTION ServicesPartFunc() SPLIT RANGE (202001)
--GO 
--ALTER PARTITION FUNCTION ServicesPartFunc() MEREG RANGE (201901)
--GO 
-- Сделать Job и запустить его 01.01.2020

--CREATE PARTITION SCHEME ServicesPartScheme AS PARTITION ServicesPartFunc TO ([FastGrowingFiles], [Default])
--GO
--ALTER PARTITION SCHEME ServicesPartScheme NEXT USED [Default]
--GO 


print 'The first step of creating lpu DWH has been performed successfully!'
print 'Run CreateDimensions.sql'
-- print 'Run UserDefinedErrors.sql'
