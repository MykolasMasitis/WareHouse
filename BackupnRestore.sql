use lpu
go

backup database lpu
	to disk = 'd:\mssql\backup\lpu_2021_1qt.bak'
	with compression

backup database test
	to disk = 'd:\mssql\backup\test_backup.bak'
	with differential

-- bakuptype=1 (full), position - нужен последний!, 5 - differntial, 2 - incremental (transational)
restore headeronly 
	from disk = 'd:\mssql\backup\20210715.bak'

restore filelistonly
	from disk = 'd:\mssql\backup\20210715.bak'
	with file = 2

restore database lpu
	from disk = 'd:\mssql\backup\20210715.bak' with file = 1 /*эта цифра - последний из position*/

-- если поднимаем full, а потом differential, то так:
restore database lpu
	from disk = 'd:\mssql\backup\20210715.bak'
	with file = 1, norecovery

restore database lpu
	from disk = 'd:\mssql\backup\20210715.bak'
	with file = 3, recovery

-- если забыли и указали в последнем restore norecovery, то:
restore database lpu
	with recovery -- перевод в рабочее состояние
