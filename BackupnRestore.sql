use lpu
go

backup database lpu
	to disk = 'd:\mssql\backup\lpu_2021_1qt.bak'
	with compression

backup database test
	to disk = 'd:\mssql\backup\test_backup.bak'
	with differential

-- bakuptype=1 (full), position - ����� ���������!, 5 - differntial, 2 - incremental (transational)
restore headeronly 
	from disk = 'd:\mssql\backup\20210715.bak'

restore filelistonly
	from disk = 'd:\mssql\backup\20210715.bak'
	with file = 2

restore database lpu
	from disk = 'd:\mssql\backup\20210715.bak' with file = 1 /*��� ����� - ��������� �� position*/

-- ���� ��������� full, � ����� differential, �� ���:
restore database lpu
	from disk = 'd:\mssql\backup\20210715.bak'
	with file = 1, norecovery

restore database lpu
	from disk = 'd:\mssql\backup\20210715.bak'
	with file = 3, recovery

-- ���� ������ � ������� � ��������� restore norecovery, ��:
restore database lpu
	with recovery -- ������� � ������� ���������
