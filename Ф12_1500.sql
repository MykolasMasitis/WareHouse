-- ����� 12 (���������� �������� �������� �� 20.12.2021 N 932, ��������� �� 2022 ���)
-- �������� � ����� �����������, ������������������ � �������, 
-- ����������� � ������ ������������ ��������� ���������� 
-- ������� (1500) - ���� ������ ���� ��� �����

DECLARE @people int = 7400000 -- ��� ������� ����������� ��������� �� I3+R4+S7. �� ��� ����� ������!

-- ������� ��������� ������� ��� ��������� ������� - ��������, ��� � ����� - ������� (1000)
IF OBJECT_ID('����������.�12_�1500_2021') IS NOT NULL DROP TABLE ����������.�12_�1500_2021
create table ����������.�12_�1500_2021 (
	-- ���������� � ������?
	show bit default 1,
	-- ������������ ������� � ��������� ��������
	name varchar(250),
	-- ����� ������: 1,2,3 � �.�.
	_str tinyint default 0,
	-- ����� ��������� � �������� ������, �������� 1 � 1.1, 2 � 1.2, 0 � 1.0
	_substr tinyint default 0,
	-- ����� ��������� � ���������, �������� 3 � 1.2.3
	_ssubstr tinyint default 0,
	-- N ������
	n_str varchar(10) collate Cyrillic_General_CI_AI not null primary key nonclustered,
	-- ��� �� ���-10 ����������
	ds varchar(50),
	-- ���������������� ����������� � ����� �� 0 �� 3 ��� ������������, �����
	n_cases_03 int default 0, 
	-- �� ��� (�� n_cases_03) � ����� �� ����
	n_cases_01 int default 0, 
	-- �� ��� (�� n_cases_03) � ����� �� ���� �� 3 ���
	n_cases_13 int default 0, 
	-- �� ��� (�� n_cases_014) ����� ��� ������������ ����������
	in_dsp int default 0, 
	-- �� ��� (�� n_cases_014) � ��� ����� � ���������, ������������� ������� � �����
	n_primary int default 0,
	-- �� ����������� � ������� � ����� ������������� ��������� (�� n_primary) ����� ��� ������������ ����������
	in_disp_prim int default 0,
	-- �� ����������� � ������� � ����� ������������� ��������� (�� n_primary) �������� ��� ����������� (��������� �� �����)
	n_primary_prof int default 0,
	-- ����� � ������������� ����� (��� �������� ������)
	out_disp int default 0,
	-- ������� ��� ������������ ����������� �� ����� ��������� ���� (��� �������� ������)
	n_disp int default 0
) 

-- ������ ���� (��� �������) ������� ������, ��������������� ������� �������� �����
-- insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('', '', '')
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������������� ����������� - �����', '1', '�00-�98',1,0,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('� ��� �����: ��������� ������������ � ������������ �������', '2', '�00-�99',2,0,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���: �������� ��������', '2.1', '�00-�09',2,1,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������������� ��������', '2.2', '�39',2,2,0)
insert into ����������.�12_�1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '2.3','',2,3,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������������', '3', '�00-D48',3,0,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������������� ���������������', '3.1', '�00-�96',3,1,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������������  ����������, ������������ � ����������� �� ������', '3.1.1', '�81-�96',3,1,1)
insert into ����������.�12_�1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '3.1.2','',3,1,2)
insert into ����������.�12_�1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '3.2','',3,2,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� �����, ������������ ������� � ��������� ���������, ����������� �������� ��������', '4', 'D50-D89',4,0,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������', '4.1', 'D50-D64',4,1,0)
insert into ����������.�12_�1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '4.2','',4,2,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ����������� �������, ������������ ������� � ��������� ������ �������', '5', 'E00-E89',5,0,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ���������� ������', '5.1', 'E00-E07',5,1,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���: ������� ���������� ������ ���������������', '5.1.1', 'E00',5,1,1)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� ����������', '5.1.2', 'E03.1',5,1,2)
insert into ����������.�12_�1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '5.1.3', '',5,1,3)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������� ������', '5.2', 'E10-E14',5,2,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������ ��������', '5.3', 'E22',5,3,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����������������� ������������', '5.6', 'E25',5,6,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�����', '5.9', 'E55.0',5,9,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������������', '5.10', 'E70.0',5,10,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� ������ ��������� (������������)', '5.11', 'E74.2',5,11,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������', '5.14', 'E84',5,14,0)
insert into ����������.�12_�1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '5.15','',5,15,0)
insert into ����������.�12_�1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '5.2', '',5,2,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����������� ������������ � ������������ ���������', '6', 'F01, F03-F99',6,0,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���: ���������� ����������', '6.1', 'F70 - F79',6,1,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������� ������������ ���� � �����', '6.2', 'F80',6,2,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������� ������������ �������� �������� �������', '6.3', 'F82',6,3,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����� ������������ ���������������� ��������', '6.4', 'F84',6,4,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���: ������� ������, ��������� ������, ������� �����, ���������������� ������������ �������� ��������', '6.4.1', 'F84.03',6,4,1)
insert into ����������.�12_�1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '6.4.2', '',6,4,2)
insert into ����������.�12_�1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '6.5','',6,5,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ������� �������', '7', 'G00-G98',7,0,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���  ������� ������������ �������', '7.9.1', 'G80',7,9,1)
insert into ����������.�12_�1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '7.9.2', '',7,9,2)
insert into ����������.�12_�1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '7.10','',7,10,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ����� � ��� ������������ ��������', '8', 'H00-H59',8,0,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ��� ��������������', '8.6', 'H35.1',8,6,0)
insert into ����������.�12_�1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '8.7','',8,7,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ��� � ������������ ��������', '9', 'H60-H95',9,0,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������ � �������������� ������ �����', '9.4', '�90',9,4,0)
insert into ����������.�12_�1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '9.5','',9,5,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ������� ��������������', '10', 'I00-I99',10,0,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ������� �������', '11', 'J00-J98',11,0,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���: ������ ������������� �������� ������� ����������� �����', '11.1', 'J00 - J06',11,1,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�����', '11.2', 'J09-J11',11,2,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������', '11.3', 'J12-J16,J18',11,3,0)
insert into ����������.�12_�1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '11.4','',11,4,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ������� �����������', '12', 'K00-K92',12,0,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ���� � ��������� ���������', '13', 'L00-L98',13,0,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ������-�������� ������� � �������������� �����', '14', 'M00-M99',14,0,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ����������� �������', '15', 'N00-N99',15,0,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� ���������, ����������� � ������������� �������', '17', 'P00-P96',17,0,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���: ������� ������', '17.1', 'P10 - P15',17,1,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������������� ���������������� ������������� � ����� � ��������������', '17.2', 'P52',17,2,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ ��������� ������������� ������� � ��������������', '17.3', 'P91',17,3,0)
insert into ����������.�12_�1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '17.4','',17,4,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� �������� (������ ��������), ���������� � ����������� ���������', '18', 'Q00-Q99',18,0,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� �������� �������� ������� �������  ', '18.1', 'Q00-Q07',18,1,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� �������� ������� ��������������', '18.2', 'Q20-Q28',18,2,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� ���� � ���� (������ ���� � ������ �����)', '18.3', 'Q35-Q37',18,3,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����������� ��������, �� ������������������ � ������ ��������', '18.4', 'Q90 - Q99',18,4,0)
insert into ����������.�12_�1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '18.5','',18,5,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������, �������� � ���������� �� �����, ���������� ��� ����������� � ������������ �������������, �� ������������������ � ������ ��������', '19', 'R00-R99',19,0,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������, ���������� � ��������� ������ ����������� ����������� ������� ������', '20', 'S00-T98',20,0,0)
insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���: �������� ��������� ���� (������ � ����� ������� ������� W54)', '20.1', 'S01, S11, S21, S31, S41, S51, S61, S71, S81, S91',20,1,0)
insert into ����������.�12_�1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '20.2','',20,2,0)

insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('COVID-19', '21', 'U07.1, U07.2',21,0,0)

-- ���� (�� 14 ��� ������������)
-- �������, �������� �� ��������� �������� ��������� � ��������� � ���������� ���������������
-- ����������, � ������� ��������� ������ �� ���������!
--insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�����', '1.0', 'Z00-Z99')
--insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� � ���������� ��������������� ��� ������������ ������� � ������������ ', '1.1', 'Z00-Z13')
--insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������� ��������� ��� ��������, ��������� � ������������� ���������', '1.2', 'Z20-Z29')
--insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� � ���������� ��������������� � ����� � ����������������, ������������ � �������������� �������', '1.3', 'Z30-Z39')
--insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� � ���������� ��������������� � ����� � �������������� ���������� ������������� �������� � ��������� ����������� ������', '1.4', 'Z40-Z54')
--insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������� ��������� ��� ��������, ��������� � ���������-�������������� � ���������������� ����������������', '1.5', 'Z55-Z65')
--insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� � ���������� ��������������� � ����� � ������� ����������������', '1.6', 'Z70-Z76')
--insert into ����������.�12_�1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������� ��������� ��� ��������, ���������  � ������ ��� �������� ��������� � ������������� ����������������, ��������� �� ��������', '1.7', 'Z80-Z99')

select * from ����������.�12_�1500_2021
	
-- ������ ���� ������������ ��� ������� ����������� ����������� ���������.
update dim.Ds set f12t1500str = '2.3' where code between 'A00' and 'B99.99' -- ������
update dim.Ds set f12t1500str = '2.1' where code between 'A00' and 'A09.99'
update dim.Ds set f12t1500str = '2.2' where code like 'A39%'

update dim.Ds set f12t1500str = '3.2' where code between 'C00' and 'D48.99' -- ������
update dim.Ds set f12t1500str = '3.1.2' where code between 'C00' and 'C96.99' -- ������
update dim.Ds set f12t1500str = '3.1.1' where code between 'C81' and 'C96.99'

update dim.Ds set f12t1500str = '4.2' where code between 'D50' and 'D89.99' -- ������
update dim.Ds set f12t1500str = '4.1' where code between 'D50' and 'D64.99'

--update dim.Ds set f12t1500str = '5' where code between 'E00' and 'E89.99'
update dim.Ds set f12t1500str = '5.15' where code between 'E00' and 'E89.99'  -- ������
--update dim.Ds set f12t1500str = '5.1' where code between 'E00' and 'E07.99' 
update dim.Ds set f12t1500str = '5.1.3' where code between 'E00' and 'E07.99' -- ������
update dim.Ds set f12t1500str = '5.1.1' where code like 'E00%'
update dim.Ds set f12t1500str = '5.1.2' where code like 'E03.1%'
update dim.Ds set f12t1500str = '5.2' where code between 'E10' and 'E14.99'
update dim.Ds set f12t1500str = '5.3' where code like 'E22%'
update dim.Ds set f12t1500str = '5.6' where code like 'E25%'
update dim.Ds set f12t1500str = '5.9' where code like 'E55.0%'
update dim.Ds set f12t1500str = '5.10' where code like 'E70.0%'	
update dim.Ds set f12t1500str = '5.11' where code like 'E74.2%'
update dim.Ds set f12t1500str = '5.14' where code like 'E84%'

--update dim.Ds set f12t1500str = '6' where code like 'F01%' or code between 'F03' and 'F99.99'
update dim.Ds set f12t1500str = '6.5' where code like 'F01%' or code between 'F03' and 'F99.99' -- ������
update dim.Ds set f12t1500str = '6.1' where code between 'F70' and 'F79.99'
update dim.Ds set f12t1500str = '6.2' where code like 'F80%'
update dim.Ds set f12t1500str = '6.3' where code like 'F82%'
-- update dim.Ds set f12t1500str = '6.4' where code between 'F10' and 'F19.99'
update dim.Ds set f12t1500str = '6.4.2' where code like 'F84%' -- ������
update dim.Ds set f12t1500str = '6.4.1' where code between 'F84.0' and 'F84.39'

--update dim.Ds set f12t1500str = '7' where code between 'G00' and 'G98.99'
update dim.Ds set f12t1500str = '7.10' where code between 'G00' and 'G98.99' -- ������
--update dim.Ds set f12t1500str = '7.9' where code between 'G80' and 'G83.99'
update dim.Ds set f12t1500str = '7.9.2' where code between 'G80' and 'G83.99' -- ������
update dim.Ds set f12t1500str = '7.9.1' where code like 'G80%'

--update dim.Ds set f12t1500str = '8' where code between 'H00' and 'H59.99'
update dim.Ds set f12t1500str = '8.7' where code between 'H00' and 'H59.99'
update dim.Ds set f12t1500str = '8.6' where code like 'H35.1%'

--update dim.Ds set f12t1500str = '9' where code between 'H60' and 'H95.99'
update dim.Ds set f12t1500str = '9.5' where code between 'H60' and 'H95.99' -- ������
update dim.Ds set f12t1500str = '9.4' where code like 'H90%'

update dim.Ds set f12t1500str = '10' where code between 'I00' and 'I99.99'

--update dim.Ds set f12t1500str = '11' where code between 'J00' and 'J98.99'
update dim.Ds set f12t1500str = '11.4' where code between 'J00' and 'J98.99'
update dim.Ds set f12t1500str = '11.1' where code between 'J00' and 'J06.99'
update dim.Ds set f12t1500str = '11.2' where code between 'J09' and 'J11.99'
update dim.Ds set f12t1500str = '11.3' where code between 'J12' and 'J16.99' or code like 'J18%'

update dim.Ds set f12t1500str = '12' where code between 'K00' and 'K92.99'

update dim.Ds set f12t1500str = '13' where code between 'L00' and 'L98.99'

update dim.Ds set f12t1500str = '14' where code between 'M00' and 'M99.99'

update dim.Ds set f12t1500str = '15' where code between 'N00' and 'N99.99'

-- update dim.Ds set f12t1500str = '17' where code between 'P00' and 'P96.99'
update dim.Ds set f12t1500str = '17.4' where code between 'P00' and 'P96.99'
update dim.Ds set f12t1500str = '17.1' where code between 'P10' and 'P15.99'
update dim.Ds set f12t1500str = '17.2' where code like 'P52%'
update dim.Ds set f12t1500str = '17.3' where code like 'P91%'

--update dim.Ds set f12t1500str = '18' where code between 'Q00' and 'Q99.99'
update dim.Ds set f12t1500str = '18.5' where code between 'Q00' and 'Q99.99'
update dim.Ds set f12t1500str = '18.1' where code between 'Q00' and 'Q07.99'
update dim.Ds set f12t1500str = '18.2' where code between 'Q20' and 'Q28.99'
update dim.Ds set f12t1500str = '18.3' where code between 'Q35' and 'Q37.99'
update dim.Ds set f12t1500str = '18.4' where code between 'Q90' and 'Q99.99'

update dim.Ds set f12t1500str = '19' where code between 'R00' and 'R99.99'

--update dim.Ds set f12t1500str = '20' where code between 'S00' and 'T98.99'
update dim.Ds set f12t1500str = '20.2' where code between 'S00' and 'T98.99'
update dim.Ds set f12t1500str = '20.1' where substring(code,1,3) in ('S01', 'S11', 'S21', 'S31', 'S41', 'S51', 'S61', 'S71', 'S81', 'S91')

update dim.Ds set f12t1500str = '21' where code in ('U07.1', 'U07.2')
-- ���������

-- � ��� ��� ����� �� ���������
update ����������.�12_�1500_2021
	set n_cases_03 = outertable.cnt
	from 
		(select count(*) as cnt from [��������������].[�����] a 
			left join dim.Ds b on a.ds=b.code where 
			ages<=3 and (ds between 'A00' and 'T98.99'or ds in ('U07.1', 'U07.2')) and b.f12t1500str is not null) as outertable
	where n_str='1'
update ����������.�12_�1500_2021
	set n_cases_01 = outertable.cnt
	from 
		(select count(*) as cnt from [��������������].[�����] a 
			left join dim.Ds b on a.ds=b.code where 
			ages<=1 and (ds between 'A00' and 'T98.99'or ds in ('U07.1', 'U07.2')) and b.f12t1500str is not null) as outertable
	where n_str='1'
update ����������.�12_�1500_2021
	set n_cases_13 = outertable.cnt
	from 
		(select count(*) as cnt from [��������������].[�����] a 
			left join dim.Ds b on a.ds=b.code where 
			(ages between 1 and 3) and (ds between 'A00' and 'T98.99'or ds in ('U07.1', 'U07.2')) and b.f12t1500str is not null) as outertable
	where n_str='1'
update ����������.�12_�1500_2021
	set n_cases_03 = outertable.cnt
	from 
		( select f12t1500str, count(*) as cnt from [��������������].[�����] a 
			left join dim.Ds b on a.ds=b.code where ages<=3 and b.f12t1500str is not null group by f12t1500str) as outertable
	where n_str=outertable.f12t1500str
update ����������.�12_�1500_2021
	set n_cases_01 = outertable.cnt
	from 
		( select f12t1500str, count(*) as cnt from [��������������].[�����] a 
			left join dim.Ds b on a.ds=b.code where 
			ages<=1 and b.f12t1500str is not null group by f12t1500str) as outertable
	where n_str=outertable.f12t1500str
update ����������.�12_�1500_2021
	set n_cases_13 = outertable.cnt
	from 
		( select f12t1500str, count(*) as cnt from [��������������].[�����] a 
			left join dim.Ds b on a.ds=b.code where 
			ages between 1 and 3 and b.f12t1500str is not null group by f12t1500str) as outertable
	where n_str=outertable.f12t1500str
-- ����� ���������� ���������� ������ ���������!

select * from ����������.�12_�1500_2021
go

-- ��������� ������ ���� 1,2,3 � �.�.
with cte (_str, _substr, _ssubstr, qwerty) as
(select _str, _substr, _ssubstr, sum(n_cases_03) over (partition by _str) as qwerty from ����������.�12_�1500_2021)
update ����������.�12_�1500_2021 set n_cases_03 = cte.qwerty from cte
join ����������.�12_�1500_2021 on cte._str=����������.�12_�1500_2021._str and 
	cte._substr=����������.�12_�1500_2021._substr and 
	cte._ssubstr=����������.�12_�1500_2021._ssubstr where ����������.�12_�1500_2021._str>0 and ����������.�12_�1500_2021._substr=0
go
-- ��������� ���������  ���� 1.1,1.2,1.3 � �.� ��� ������� ���-�������� ������ �������� �����...
with cte (_str, _substr, _ssubstr, qwerty) as
(select _str, _substr, _ssubstr, sum(n_cases_03) over (partition by _str, _substr) as qwerty from ����������.�12_�1500_2021)
update ����������.�12_�1500_2021 set n_cases_03 = cte.qwerty from cte
join ����������.�12_�1500_2021 on cte._str=����������.�12_�1500_2021._str and cte._substr=����������.�12_�1500_2021._substr and cte._ssubstr=����������.�12_�1500_2021._ssubstr 
	where ����������.�12_�1500_2021._str>0 and ����������.�12_�1500_2021._substr>0 and ����������.�12_�1500_2021._ssubstr=0
go

with cte (_str, _substr, _ssubstr, qwerty) as
(select _str, _substr, _ssubstr, sum(n_cases_01) over (partition by _str) as qwerty from ����������.�12_�1500_2021)
update ����������.�12_�1500_2021 set n_cases_01 = cte.qwerty from cte
join ����������.�12_�1500_2021 on cte._str=����������.�12_�1500_2021._str and 
	cte._substr=����������.�12_�1500_2021._substr and 
	cte._ssubstr=����������.�12_�1500_2021._ssubstr where ����������.�12_�1500_2021._str>0 and ����������.�12_�1500_2021._substr=0
go
-- ��������� ���������  ���� 1.1,1.2,1.3 � �.� ��� ������� ���-�������� ������ �������� �����...
with cte (_str, _substr, _ssubstr, qwerty) as
(select _str, _substr, _ssubstr, sum(n_cases_01) over (partition by _str, _substr) as qwerty from ����������.�12_�1500_2021)
update ����������.�12_�1500_2021 set n_cases_01 = cte.qwerty from cte
join ����������.�12_�1500_2021 on cte._str=����������.�12_�1500_2021._str and cte._substr=����������.�12_�1500_2021._substr and cte._ssubstr=����������.�12_�1500_2021._ssubstr 
	where ����������.�12_�1500_2021._str>0 and ����������.�12_�1500_2021._substr>0 and ����������.�12_�1500_2021._ssubstr=0
go

with cte (_str, _substr, _ssubstr, qwerty) as
(select _str, _substr, _ssubstr, sum(n_cases_13) over (partition by _str) as qwerty from ����������.�12_�1500_2021)
update ����������.�12_�1500_2021 set n_cases_13 = cte.qwerty from cte
join ����������.�12_�1500_2021 on cte._str=����������.�12_�1500_2021._str and 
	cte._substr=����������.�12_�1500_2021._substr and 
	cte._ssubstr=����������.�12_�1500_2021._ssubstr where ����������.�12_�1500_2021._str>0 and ����������.�12_�1500_2021._substr=0
go
-- ��������� ���������  ���� 1.1,1.2,1.3 � �.� ��� ������� ���-�������� ������ �������� �����...
with cte (_str, _substr, _ssubstr, qwerty) as
(select _str, _substr, _ssubstr, sum(n_cases_13) over (partition by _str, _substr) as qwerty from ����������.�12_�1500_2021)
update ����������.�12_�1500_2021 set n_cases_13 = cte.qwerty from cte
join ����������.�12_�1500_2021 on cte._str=����������.�12_�1500_2021._str and cte._substr=����������.�12_�1500_2021._substr and cte._ssubstr=����������.�12_�1500_2021._ssubstr 
	where ����������.�12_�1500_2021._str>0 and ����������.�12_�1500_2021._substr>0 and ����������.�12_�1500_2021._ssubstr=0
go

-- ����-�����
-- 1. ������� � dim.Ds �������� ���������������� ���������?
select * from dim.ds where code between 'A00' and 'T98.%' and f12t1500str is null -- ��� ����

-- 2. ������������ ����� (2.0, 3.0 � �.�.) - ������ ���� ����� ������ 1.0
select n_cases_01 from ����������.�12_�1500_2021 where _str=1
select count(*) as cnt from [��������������].[�����] a 
			left join dim.Ds b on a.ds=b.code where 
				ages<=1 and (ds between 'A00' and 'T98.99' or ds in ('U07.1', 'U07.2')) and b.f12t1500str is not null
select sum(n_cases_01) from ����������.�12_�1500_2021 where 
	_str in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21) and _substr=0

select n_cases_03 from ����������.�12_�1500_2021 where _str=1
select count(*) as cnt from [��������������].[�����] a 
			left join dim.Ds b on a.ds=b.code where 
				ages<=3 and (ds between 'A00' and 'T98.99' or ds in ('U07.1', 'U07.2')) and b.f12t1500str is not null
select sum(n_cases_03) from ����������.�12_�1500_2021 where 
	_str in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21) and _substr=0

select n_cases_13 from ����������.�12_�1500_2021 where _str=1
select count(*) as cnt from [��������������].[�����] a 
			left join dim.Ds b on a.ds=b.code where 
				(ages between 1 and 3) and (ds between 'A00' and 'T98.99' or ds in ('U07.1', 'U07.2')) and b.f12t1500str is not null
select sum(n_cases_13) from ����������.�12_�1500_2021 where 
	_str in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21) and _substr=0
-- ���� ��� ����� �������, ������ ����� �� ���������!

-- 3. ��������� ����� �������� �� ��������� ������
-- Unit tests
