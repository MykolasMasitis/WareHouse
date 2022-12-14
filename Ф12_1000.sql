-- ����� 12 (���������� �������� �������� �� 20.12.2021 N 932, ��������� �� 2022 ���)
-- �������� � ����� �����������, ������������������ � �������, 
-- ����������� � ������ ������������ ��������� ���������� 
-- ������� (1000) - ���� �� 14 ��� ������������

DECLARE @people int = 7400000 -- ��� ������� ����������� ��������� �� I3+R4+S7. �� ��� ����� ������!

-- ������� ��������� ������� ��� ��������� ������� - ��������, ��� � ����� - ������� (1000)
IF OBJECT_ID('����������.�12_�1000_2021') IS NOT NULL DROP TABLE ����������.�12_�1000_2021
create table ����������.�12_�1000_2021 (
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
	-- ���������������� ����������� � ����� �� 0 �� 14 ��� ������������, �����
	n_cases_014 int default 0, 
	-- �� ��� (�� n_cases_014) � ����� �� 0 �� 4 ���
	n_cases_04 int default 0, 
	-- �� ��� (�� n_cases_014) � ����� �� 5 �� 9 ���
	n_cases_59 int default 0, 
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
-- insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('', '', '')
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������������� ����������� - �����', '1', '�00-�98',1,0,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('� ��� �����: ��������� ������������ � ������������ �������', '2', '�00-�99',2,0,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���: �������� ��������', '2.1', '�00-�09',2,1,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������������� ��������', '2.2', '�39',2,2,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� �������', '2.3', '�15-�19',2,3,0)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '2.4','',2,4,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������������', '3', '�00-D48',3,0,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������������� ���������������', '3.1', '�00-�96',3,1,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������������  ����������, ������������ � ����������� �� ������', '3.1.1', '�81-�96',3,1,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '3.1.2','',3,1,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����������������� ���������������', '3.2', 'D10-D36',3,2,0)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '3.3','',3,3,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� �����, ������������ ������� � ��������� ���������, ����������� �������� ��������', '4', 'D50-D89',4,0,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������', '4.1', 'D50-D64',4,1,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ��� ������������� ������', '4.1.1', 'D60-D61',4,1,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '4.1.2', '',4,1,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� �������������� �����, ������� � ������ ��������������� ���������', '4.2', 'D65-D69',4,2,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���: ���������', '4.2.1', 'D66-D68',4,2,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '4.2.2', '',4,2,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� ���������, ����������� �������� ��������', '4.3', 'D80-D89',4,3,0)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '4.4','',4,4,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ����������� �������, ������������ ������� � ��������� ������ �������', '5', 'E00-E89',5,0,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ���������� ������', '5.1', 'E00-E07',5,1,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���: ������� ���������� ������ ���������������', '5.1.1', 'E00',5,1,1)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������ ���, ��������� � ������ ����������������', '5.1.2', 'E01.0-2',5,1,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������������� ���������� ���������� ������ ��������������� � ������ ����� �����������', '5.1.3', 'E02, E03',5,1,3)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ ����� �������������� ����', '5.1.4', 'E04',5,1,4)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������� (�����������)', '5.1.5', 'E05',5,1,5)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������� (�����������)', '5.1.6', 'E06',5,1,6)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '5.1.7', '',5,1,7)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������� ������', '5.2', 'E10-E14',5,2,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ����: � ���������� ����', '5.2.1', 'E10.3, E11.3, E12.3, E13.3, E14.3',5,2,1)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('� ���������� �����', '5.2.2', 'E10.2, E11.2, E12.2, E13.2, E14.2',5,2,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���� (�� ���. 5.2): �������� ������ I ����', '5.2.3', 'E10',5,2,3)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������� ������ II ����', '5.2.4', 'E11',5,2,4)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '5.2.5', '',5,2,5)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������ ��������', '5.3', 'E22',5,3,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������������', '5.4', 'E23.0',5,4,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� ������', '5.5', 'E23.2',5,5,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����������������� ������������', '5.6', 'E25',5,6,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� ��������', '5.7', 'E28',5,7,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� �����', '5.8', 'E29',5,8,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�����', '5.9', 'E55.0',5,9,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������', '5.10', 'E66',5,10,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������������', '5.11', 'E70.0',5,11,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� ������ ��������� (������������)', '5.12', 'E74.2',5,12,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ����', '5.13', 'E75.2',5,13,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� ������ ������������������� (������������������)', '5.14', 'E76',5,14,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������', '5.15', 'E84',5,15,0)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '5.16','',5,16,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����������� ������������ � ������������ ���������', '6', 'F01, F03-F99',6,0,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����������� ������������ � ������������ ���������, ��������� � ������������� ������������� �������', '6.1', 'F10-F19',6,1,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ������, ��������� ������, ������� �����, ���������������� ������������ �������� ��������', '6.2', 'F84.0-3',6,2,0)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '6.3','',6,3,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ������� �������', '7', 'G00-G98',7,0,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������������� ������� ����������� ������� �������', '7.1', 'G00-G09',7,1,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������� ��������', '7.1.1', 'G00',7,1,1)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������, ������ � ��������������', '7.1.2', 'G04',7,1,2)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '7.1.3', '',7,1,3)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� �������, ���������� ��������������� ����������� ������� �������', '7.2', 'G10-G12',7,2,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������������� � ������ ������������ ���������', '7.3', 'G20,G21,G23-G25',7,3,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ����������', '7.3.1', 'G20',7,3,1)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ ���������������� � ������������   ���������', '7.3.2', 'G25',7,3,2)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '7.3.3', '',7,3,3)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ �������������� ������� ������� �������', '7.4', 'G30-G31',7,4,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����������������� ������� ����������� ������� �������', '7.5', 'G35-G37',7,5,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ��� ���������� �������', '7.5.1', 'G35',7,5,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '7.5.2', '',7,5,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������� � ��������������� ������������', '7.6', 'G40-G47',7,6,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������, �������������� ������', '7.6.1', 'G40-G41',7,6,1)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� ������������ ������������ ����������� �������� [�����] � �����������   �������� ', '7.6.2', 'G45',7,6,2)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '7.6.3', '',7,6,3)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� ��������� ������, ������� � ������ ��������� �������������� �������  �������', '7.7', 'G50-G64',7,7,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���  ������� ������-�����', '7.7.1', 'G61.0',7,7,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '7.7.2', '',7,7,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ������-��������� ������� �  ����', '7.8', 'G70-G73',7,8,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� ', '7.8.1', 'G70.0, 2',7,8,1)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������� ��������� �������', '7.8.2', 'G71.0',7,8,2)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '7.8.3', '',7,8,3)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������ ������� � ������ �������������� ��������', '7.9', 'G80-G83',7,9,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���  ������� ������������ �������', '7.9.1', 'G80',7,9,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '7.9.2', '',7,9,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������ ������������ (����������) ������� �������', '7.10', 'G90',7,10,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� ����������', '7.11', 'G95.1',7,11,0)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '7.12','',7,12,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ����� � ��� ������������ ��������', '8', 'H00-H59',8,0,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���: ������������', '8.1', 'H10',8,1,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������', '8.2', 'H16',8,2,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ����: ��������', '8.2.1', 'H16.0',8,2,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '8.2.2', '',8,2,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������', '8.3', 'H25-H26',8,3,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������������� ����������', '8.4', 'H30',8,4,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������� �������� � �������� ��������', '8.5', 'H33.0',8,5,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������������', '8.6', 'H35.1',8,6,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����������� ������ � ������� ������', '8.7', 'H35.3',8,7,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������', '8.8', 'H40',8,8,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������������� ������', '8.9', 'H44.2',8,9,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ����������� ����� � ���������� �����', '8.10', 'H46-H48',8,10,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ��� ������� ����������� �����', '8.10.1', 'H47.2',8,10,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '8.10.2', '',8,10,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ���� �����, ��������� ���������������� �������� ����, ����������� � ���������', '8.11', 'H49-H52',8,11,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������', '8.11.1', 'H52.1',8,11,1)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�����������', '8.11.2', 'H52.2',8,11,2)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '8.11.3', '',8,11,3)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� � ���������� ������', '8.12', '�54',8,12,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���  ������� ����� ����', '8.12.1', '�54.0',8,12,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '8.12.2', '',8,12,2)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '8.13','',8,13,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ��� � ������������ ��������', '9', 'H60-H95',9,0,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ��������� ���', '9.1', 'H60-H61',9,1,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� �������� ��� � ������������ ��������', '9.2', '�65-H66, H68-�74',9,2,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ ����', '9.2.1', 'H65.0, H65.1, H66.0',9,2,1)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����������� ����', '9.2.2', 'H65.2-4;H66.1-3',9,2,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� �������� (�����������) �����', '9.2.3', 'H68-H69',9,2,3)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� ���������� ���������', '9.2.4', 'H72',9,2,4)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ ������� �������� ��� � ������������ ��������', '9.2.5', 'H74',9,2,5)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '9.2.6', '',9,2,6)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ����������� ���', '9.3', '�80-H81, �83',9,3,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� ', '9.3.1', '�80',9,3,1)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� �������', '9.3.2', '�81.0',9,3,2)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '9.3.3', '',9,3,3)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������ � �������������� ������ �����', '9.4', '�90',9,4,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������ ������ ����� ������������', '9.4.1', '�90.0',9,4,1)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������������� ������ �����    ������������', '9.4.2', '�90.3',9,4,2)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '9.4.3', '',9,4,3)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '9.5','',9,5,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ������� ��������������', '10', 'I00-I99',10,0,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ ������������� ���������', '10.1', 'I00-I02',10,1,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����������� ������������� ������� ������ ', '10.2', 'I05-I09',10,2,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ��� ������������� ��������� �������� ', '10.2.1', 'I05-I08',10,2,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '10.2.2', '',10,2,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������, �����������������  ���������� �������� ���������', '10.3', 'I10-I13',10,3,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������� �����������', '10.3.1', 'I10',10,3,1)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������������� ������� ������  (��������������� ������� �  ���������������� ���������� ������)', '10.3.2', 'I11',10,3,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������������� (���������������) ������� � ����������������  ����������  ����� ', '10.3.3', 'I12',10,3,3)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������������� (���������������) ������� � ����������������  ���������� ������ �  �����', '10.3.4', 'I13',10,3,4)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '10.3.5', '',10,3,5)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����������� ������� ������', '10.4', 'I20-I25',10,4,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ ������� ������', '10.5', 'I30',10,5,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���: ������ ����������', '10.5.1', 'I30',10,5,1)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ � ��������� ����������', '10.5.2', 'I33',10,5,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ ���������', '10.5.3', 'I40',10,5,3)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������������', '10.5.4', 'I42',10,5,4)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '10.5.5', '',10,5,5)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������������ �������', '10.6', 'I60 - I69',10,6,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����������������� �������������', '10.6.1', 'I60',10,6,1)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������������� � ������ �������������� �������������  ', '10.6.2', 'I61, I62',10,6,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� �����', '10.6.3', 'I63',10,6,3)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������, �� ����������, ��� �������������  ��� �������', '10.6.4', 'I64',10,6,4)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� � ������ ���������������, ������������  �������, �� ���������� �  �������� ����� ', '10.6.5', 'I65-I66',10,6,5)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ ������������������ �������', '10.6.6', 'I67',10,6,6)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����������� ������������������ ��������', '10.6.7', 'I69',10,6,7)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '10.6.8', 'I69',10,6,8)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ���, ������������� ������� � ������������� �����', '10.8', 'I80-I83, I85-I89',10,8,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values (' ������ � ������������', '10.8.1', 'I80',10,8,1)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ���������� ����', '10.8.2', 'I81',10,8,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� ���������� ��� ������ �����������', '10.8.3', 'I83',10,8,3)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '10.8.4', '',10,8,4)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '10.9','',10,9,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ������� �������', '11', 'J00-J98',11,0,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ ������������� �������� ������� ����������� �����', '11.1', 'J00-J06',11,1,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ �������� � �������', '11.1.1', 'J04',11,1,1)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ ������������� �������� [����] � ����������', '11.1.2', 'J05',11,1,2)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '11.1.3', '',11,1,3)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�����', '11.2', 'J09-J11',11,2,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������', '11.3', 'J12-J16,J18',11,3,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ��� ���������������, ��������� S. Pneumoniae', '11.3.1', 'J13',11,3,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '11.3.2', '',11,3,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ ������������� �������� ������ ����������� �����', '11.4', 'J20-J22',11,4,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������� ����� (��������)', '11.5', 'J30.1',11,5,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����������� ������� �������� � ���������, ���������������� �������', '11.6', 'J35-J36',11,6,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ����������� � ������������, �������� ', '11.7', 'J40-J43',11,7,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ ����������� ������������� �������� �������', '11.8', 'J44',11,8,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������������ �������', '11.9', 'J47',11,9,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�����; ������������� ������', '11.10', 'J45, J46',11,10,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ ���������������� �������� �������, ������� � ������������� ��������� ������ ����������� �����, ������ ������� ������', '11.11', 'J84-J90, J92-J94',11,11,0)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '11.12','',11,12,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ������� �����������', '12', 'K00-K92',12,0,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���� ������� � ������������������ �����', '12.1', 'K25-K26',12,1,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� � ��������', '12.2', 'K29',12,2,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�����', '12.3', '�40-�46',12,3,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������������� ������� � �����', '12.4', 'K50-K52',12,4,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ ������� ���������', '12.5', '�55-�63',12,5,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���  �������������� ����� � �������������� ��������� ��� �����', '12.5.1', '�56',12,5,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '12.5.2', '',12,5,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������', '12.6', '�64',12,6,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ������', '12.7', 'K70-K76',12,7,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���  ������ � ������ ������', '12.7.1', '�74',12,7,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '12.7.2', '',12,7,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� �������� ������, �������������� �����', '12.8', 'K80-83',12,8,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ������������� ������', '12.9', 'K85-K86',12,9,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���  ������ ����������', '12.9.1', '�85',12,9,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '12.9.2', '',12,9,2)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '12.10','',12,10,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ���� � ��������� ���������', '13', 'L00-L98',13,0,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����������� ��������', '13.1', 'L20',13,1,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� ��������', '13.2', 'L23-L25',13,2,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ ��������� (������)', '13.3', 'L30',13,3,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������', '13.4', 'L40',13,4,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���� ������� ���������������', '13.4.1', 'L40.5',13,4,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '13.4.2', '',13,4,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� ������� ��������', '13.5', 'L93.0',13,5,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������������� ������������', '13.6', 'L94.0',13,6,0)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '13.7','',13,7,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ������-�������� ������� � �������������� �����', '14', 'M00-M99',14,0,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����������', '14.1', '�00-�25',14,1,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���: �������������� ������ � ����������', '14.1.1', 'M00.1',14,1,1)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� ����������', '14.1.2', 'M02',14,1,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������ ������ (�������������� �  ��������������)', '14.1.3', 'M05, M06',14,1,3)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� (����������) ������ ', '14.1.4', 'M08',14,1,4)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������', '14.1.5', '�15-�19',14,1,5)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '14.1.6', '',14,1,6)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� ��������� �������������� �����', '14.2', 'M30-M35',14,2,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ��� ��������� ������� ��������', '14.2.1', 'M32',14,2,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '14.2.2', '',14,2,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������� ����������', '14.3', 'M40-M43',14,3,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������������', '14.4', '�45-�49',14,4,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ��� �������������� ���������', '14.4.1', 'M45',14,4,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '14.4.2', '',14,4,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� ������������ �������� � ���������', '14.5', '�65-�68',14,5,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� � �����������', '14.6', 'M80-M94',14,6,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���  �����������', '14.6.1', '�80-�81',14,6,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '14.6.2', '',14,6,2)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '14.7','',14,7,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� ����������� �������', '15', 'N00-N99',15,0,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������������, ����������������������  ������� �����, ������ ������� ����� �  �����������', '15.1', 'N00-N07,N09-N15,N25-N28',15,1,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������� ���������������', '15.2', 'N17-N19',15,2,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������ �������', '15.3', 'N20-N21, N23',15,3,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ ������� ������� �������', '15.4', 'N30-N32, N34-N36, N39',15,4,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� �������������� ������', '15.5', 'N40-N42',15,5,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('����������������� ��������� ��������   ������', '15.6', 'N60',15,6,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�������������� ������� ������� ������� �������', '15.7', 'N70-N73,N75-N77',15,7,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���  ���������� � �������', '15.7.1', 'N70',15,7,1)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '15.7.2', '',15,7,2)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�����������', '15.8', 'N80',15,8,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������ � ��������� ����� �����', '15.9', 'N86',15,9,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������ ����������� ', '15.10', 'N91-N94',15,10,0)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '15.11','',15,11,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������, ���� � ������������ ������', '16', 'O00-O99',16,0,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� ���������, ����������� � ������������� �������', '17', 'P00-P96',17,0,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� �������� (������ ��������), ���������� � ����������� ���������', '18', 'Q00-Q99',18,0,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� �������� �������� ������� �������  ', '18.1', 'Q00-Q07',18,1,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� �������� �����', '18.2', 'Q10-Q15',18,2,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� �������� ������� ��������������', '18.3', 'Q20-Q28',18,3,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� �������� ���� � ����� �����, ������ ���������� �������� ������� ������� �������', '18.4', 'Q50-Q52',18,4,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������������� ���� � ��������������������', '18.5', 'Q56',18,5,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� ���������� �����', '18.6', 'Q65',18,6,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������� ������', '18.7', 'Q80',18,7,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('���������������', '18.8', 'Q85.0',18,8,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������� �����', '18.9', 'Q90',18,9,0)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '18.10','',18,10,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������, �������� � ���������� �� �����, ���������� ��� ����������� � ������������ �������������, �� ������������������ � ������ ��������', '19', 'R00-R99',19,0,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������, ���������� � ��������� ������ ����������� ����������� ������� ������', '20', 'S00-T98',20,0,0)
insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�� ���: �������� ��������� ���� (������ � ����� ������� ������� W54)', '20.1', 'S01, S11, S21, S31, S41, S51, S61, S71, S81, S91',20,1,0)
insert into ����������.�12_�1000_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, '������', '20.2','',20,2,0)

insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('COVID-19', '21', 'U07.1, U07.2',21,0,0)

-- ���� (�� 14 ��� ������������)
-- �������, �������� �� ��������� �������� ��������� � ��������� � ���������� ���������������
-- ����������, � ������� ��������� ������ �� ���������!
--insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('�����', '1.0', 'Z00-Z99')
--insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� � ���������� ��������������� ��� ������������ ������� � ������������ ', '1.1', 'Z00-Z13')
--insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������� ��������� ��� ��������, ��������� � ������������� ���������', '1.2', 'Z20-Z29')
--insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� � ���������� ��������������� � ����� � ����������������, ������������ � �������������� �������', '1.3', 'Z30-Z39')
--insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� � ���������� ��������������� � ����� � �������������� ���������� ������������� �������� � ��������� ����������� ������', '1.4', 'Z40-Z54')
--insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������� ��������� ��� ��������, ��������� � ���������-�������������� � ���������������� ����������������', '1.5', 'Z55-Z65')
--insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('��������� � ���������� ��������������� � ����� � ������� ����������������', '1.6', 'Z70-Z76')
--insert into ����������.�12_�1000_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('������������� ��������� ��� ��������, ���������  � ������ ��� �������� ��������� � ������������� ����������������, ��������� �� ��������', '1.7', 'Z80-Z99')

select * from ����������.�12_�1000_2021
	
-- ������ ���� ������������ ��� ������� ����������� ����������� ���������.
-- ������� ���� � dim.Ds f12t1000str varchar(15) - ��������� ��� ������� ������
-- ��������� �������� �� "������"
-- update dim.Ds set f12t1000str = '2' where code between 'A00' and 'B99.99'
update dim.Ds set f12t1000str = '2.4' where code between 'A00' and 'B99.99'
update dim.Ds set f12t1000str = '2.1' where code between 'A00' and 'A09.99'
update dim.Ds set f12t1000str = '2.2' where code like 'A39%'
update dim.Ds set f12t1000str = '2.3' where code between 'B15' and 'B19.99'

--update dim.Ds set f12t1000str = '3' where code between 'C00' and 'D48.99'
update dim.Ds set f12t1000str = '3.3' where code between 'C00' and 'D48.99'
--update dim.Ds set f12t1000str = '3.1' where code between 'C00' and 'C96.99'
update dim.Ds set f12t1000str = '3.1.2' where code between 'C00' and 'C96.99'
update dim.Ds set f12t1000str = '3.1.1' where code between 'C81' and 'C96.99'
update dim.Ds set f12t1000str = '3.2' where code between 'D10' and 'D36.99'

--update dim.Ds set f12t1000str = '4' where code between 'D50' and 'D89.99'
update dim.Ds set f12t1000str = '4.4' where code between 'D50' and 'D89.99'
--update dim.Ds set f12t1000str = '4.1' where code between 'D50' and 'D64.99'
update dim.Ds set f12t1000str = '4.1.2' where code between 'D60' and 'D61.99'
update dim.Ds set f12t1000str = '4.1.1' where code between 'D60' and 'D61.99'
--update dim.Ds set f12t1000str = '4.2' where code between 'D65' and 'D69.99'
update dim.Ds set f12t1000str = '4.2.2' where code between 'D65' and 'D69.99'
update dim.Ds set f12t1000str = '4.2.1' where code between 'D66' and 'D68.99'
update dim.Ds set f12t1000str = '4.3' where code between 'D80' and 'D89.99'

--update dim.Ds set f12t1000str = '5' where code between 'E00' and 'E89.99'
update dim.Ds set f12t1000str = '5.16' where code between 'E00' and 'E89.99'
--update dim.Ds set f12t1000str = '5.1' where code between 'E00' and 'E07.99'
update dim.Ds set f12t1000str = '5.1.7' where code between 'E00' and 'E07.99'
update dim.Ds set f12t1000str = '5.1.1' where code like 'E00%'
update dim.Ds set f12t1000str = '5.1.2' where code between 'E01.0' and 'E01.29'
update dim.Ds set f12t1000str = '5.1.3' where code like 'E02%' or code like 'E03%'
update dim.Ds set f12t1000str = '5.1.4' where code like 'E04%'
update dim.Ds set f12t1000str = '5.1.5' where code like 'E05%'
update dim.Ds set f12t1000str = '5.1.6' where code like 'E06%'
--update dim.Ds set f12t1000str = '5.2' where code between 'E10' and 'E14.99'
update dim.Ds set f12t1000str = '5.2.5' where code between 'E10' and 'E14.99'
update dim.Ds set f12t1000str = '5.2.1' where code in ('E10.3', 'E11.3', 'E12.3', 'E13.3', 'E14.3')
update dim.Ds set f12t1000str = '5.2.2' where code in ('E10.2', 'E11.2', 'E12.2', 'E13.2', 'E14.2')
update dim.Ds set f12t1000str = '5.2.3' where code like 'E10%'
update dim.Ds set f12t1000str = '5.2.4' where code like 'E11%'
update dim.Ds set f12t1000str = '5.3' where code like 'E22%'
update dim.Ds set f12t1000str = '5.4' where code like 'E23.0%'
update dim.Ds set f12t1000str = '5.5' where code like 'E23.2%'
update dim.Ds set f12t1000str = '5.6' where code like 'E25%'
update dim.Ds set f12t1000str = '5.7' where code like 'E28%'
update dim.Ds set f12t1000str = '5.8' where code like 'E29%'
update dim.Ds set f12t1000str = '5.9' where code like 'E55.0%'
update dim.Ds set f12t1000str = '5.10' where code like 'E66%'
update dim.Ds set f12t1000str = '5.11' where code like 'E70.0%'
update dim.Ds set f12t1000str = '5.12' where code like 'E74.2%'
update dim.Ds set f12t1000str = '5.13' where code like 'E75.2%'
update dim.Ds set f12t1000str = '5.14' where code like 'E76%'
update dim.Ds set f12t1000str = '5.15' where code like 'E84%'

--update dim.Ds set f12t1000str = '6' where code like 'F01%' or code between 'F03' and 'F99.99'
update dim.Ds set f12t1000str = '6.2' where code like 'F01%' or code between 'F03' and 'F99.99'
update dim.Ds set f12t1000str = '6.1' where code between 'F10' and 'F19.99'

--update dim.Ds set f12t1000str = '7' where code between 'G00' and 'G98.99'
update dim.Ds set f12t1000str = '7.12' where code between 'G00' and 'G98.99'
--update dim.Ds set f12t1000str = '7.1' where code between 'G00' and 'G09.99'
update dim.Ds set f12t1000str = '7.1.3' where code between 'G00' and 'G09.99'
update dim.Ds set f12t1000str = '7.1.1' where code like 'G00%'
update dim.Ds set f12t1000str = '7.1.2' where code like 'G04%'
update dim.Ds set f12t1000str = '7.2' where code between 'G10' and 'G12.99'
--update dim.Ds set f12t1000str = '7.3' where code in ('G20%','G21%') or code between 'G23%' and 'G25%'
update dim.Ds set f12t1000str = '7.3.3' where code in ('G20%','G21%') or code between 'G23%' and 'G25%'
update dim.Ds set f12t1000str = '7.3.1' where code like 'G20%'
update dim.Ds set f12t1000str = '7.3.2' where code like 'G25%'
update dim.Ds set f12t1000str = '7.4' where code between 'G30' and 'G31.99'
--update dim.Ds set f12t1000str = '7.5' where code between 'G35' and 'G37.99'
update dim.Ds set f12t1000str = '7.5.2' where code between 'G35' and 'G37.99'
update dim.Ds set f12t1000str = '7.5.1' where code like 'G35%'
--update dim.Ds set f12t1000str = '7.6' where code between 'G40' and 'G47.99'
update dim.Ds set f12t1000str = '7.6.3' where code between 'G40' and 'G47.99'
update dim.Ds set f12t1000str = '7.6.1' where code between 'G40' and 'G41.99'
update dim.Ds set f12t1000str = '7.6.2' where code like 'G45%'
--update dim.Ds set f12t1000str = '7.7' where code between 'G50' and 'G64.99'
update dim.Ds set f12t1000str = '7.7.2' where code between 'G50' and 'G64.99'
update dim.Ds set f12t1000str = '7.7.1' where code like 'G61.0%'
--update dim.Ds set f12t1000str = '7.8' where code between 'G70' and 'G73.99'
update dim.Ds set f12t1000str = '7.8.3' where code between 'G70' and 'G73.99'
update dim.Ds set f12t1000str = '7.8.1' where code in ('G70.0','G70.2')
update dim.Ds set f12t1000str = '7.8.2' where code like 'G71.0%'
--update dim.Ds set f12t1000str = '7.9' where code between 'G80' and 'G83.99'
update dim.Ds set f12t1000str = '7.9.2' where code between 'G80' and 'G83.99'
update dim.Ds set f12t1000str = '7.9.1' where code like 'G80%'
update dim.Ds set f12t1000str = '7.10' where code like 'G90%'
update dim.Ds set f12t1000str = '7.11' where code like 'G95.1%'

--update dim.Ds set f12t1000str = '8' where code between 'H00' and 'H59.99'
update dim.Ds set f12t1000str = '8.13' where code between 'H00' and 'H59.99'
update dim.Ds set f12t1000str = '8.1' where code like 'H10%'
--update dim.Ds set f12t1000str = '8.2' where code like 'H16%'
update dim.Ds set f12t1000str = '8.2.2' where code like 'H16%'
update dim.Ds set f12t1000str = '8.2.1' where code like 'H16.0%'
update dim.Ds set f12t1000str = '8.3' where code between 'H25' and 'H26.99' -- like 'H46%'
update dim.Ds set f12t1000str = '8.4' where code like 'H30%'
update dim.Ds set f12t1000str = '8.5' where code like 'H33.0%'
update dim.Ds set f12t1000str = '8.6' where code like 'H35.1%'
update dim.Ds set f12t1000str = '8.7' where code like 'H35.3%'
update dim.Ds set f12t1000str = '8.8' where code like 'H40%'
update dim.Ds set f12t1000str = '8.9' where code like 'H44.2%'
--update dim.Ds set f12t1000str = '8.10' where code between 'H46' and 'H48.99'
update dim.Ds set f12t1000str = '8.10.2' where code between 'H46' and 'H48.99'
update dim.Ds set f12t1000str = '8.10.1' where code like 'H47.2%'
--update dim.Ds set f12t1000str = '8.11' where code between 'H49' and 'H52.99'
update dim.Ds set f12t1000str = '8.11.3' where code between 'H49' and 'H52.99'
update dim.Ds set f12t1000str = '8.11.1' where code like 'H52.1%'
update dim.Ds set f12t1000str = '8.11.2' where code like 'H52.2%'
--update dim.Ds set f12t1000str = '8.12' where code like 'H54%'
update dim.Ds set f12t1000str = '8.12.2' where code like 'H54%'
update dim.Ds set f12t1000str = '8.12.1' where code like 'H54.0%'

--update dim.Ds set f12t1000str = '9' where code between 'H60' and 'H95.99'
update dim.Ds set f12t1000str = '9.5' where code between 'H60' and 'H95.99'
update dim.Ds set f12t1000str = '9.1' where code between 'H60%' and 'H61.99%'
--update dim.Ds set f12t1000str = '9.2' where code between 'H65%' and 'H66.99%' or code between 'H68%' and 'H74.99%'
update dim.Ds set f12t1000str = '9.2.6' where code between 'H65%' and 'H66.99%' or code between 'H68%' and 'H74.99%'
update dim.Ds set f12t1000str = '9.2.1' where code in ('H65.0','H65.1','H66.0')
update dim.Ds set f12t1000str = '9.2.2' where code in ('H65.2','H65.3','H65.4') or code in ('H66.1','H66.2','H66.3')
update dim.Ds set f12t1000str = '9.2.3' where code between 'H68' and 'H69.99'
update dim.Ds set f12t1000str = '9.2.4' where code like 'H72%'
update dim.Ds set f12t1000str = '9.2.5' where code like 'H74%'
--update dim.Ds set f12t1000str = '9.3' where code between 'H80' and 'H81.99' or code like 'H83%'
update dim.Ds set f12t1000str = '9.3.3' where code between 'H80' and 'H81.99' or code like 'H83%'
update dim.Ds set f12t1000str = '9.3.1' where code like 'H80%'
update dim.Ds set f12t1000str = '9.3.2' where code like 'H81.0%'
--update dim.Ds set f12t1000str = '9.4' where code like 'H90%'
update dim.Ds set f12t1000str = '9.4.3' where code like 'H90%'
update dim.Ds set f12t1000str = '9.4.1' where code like 'H90.0%'
update dim.Ds set f12t1000str = '9.4.2' where code like 'H90.3%'

--update dim.Ds set f12t1000str = '10' where code between 'I00' and 'I99.99'
update dim.Ds set f12t1000str = '10.9' where code between 'I00' and 'I99.99'
update dim.Ds set f12t1000str = '10.1' where code between 'I00' and 'I02.99'
--update dim.Ds set f12t1000str = '10.2' where code between 'I05' and 'I09.99'
update dim.Ds set f12t1000str = '10.2.2' where code between 'I05' and 'I09.99'
update dim.Ds set f12t1000str = '10.2.1' where code between 'I05' and 'I08.99'
--update dim.Ds set f12t1000str = '10.3' where code between 'I10' and 'I13.99'
update dim.Ds set f12t1000str = '10.3.5' where code between 'I10' and 'I13.99'
update dim.Ds set f12t1000str = '10.3.1' where code like 'I10%'
update dim.Ds set f12t1000str = '10.3.2' where code like 'I11%'
update dim.Ds set f12t1000str = '10.3.3' where code like 'I12%'
update dim.Ds set f12t1000str = '10.3.4' where code like 'I13%'
update dim.Ds set f12t1000str = '10.4' where code between 'I20' and 'I25.99'
--update dim.Ds set f12t1000str = '10.5' where code between 'I30' and 'I51.99'
update dim.Ds set f12t1000str = '10.5.5' where code between 'I30' and 'I51.99'
update dim.Ds set f12t1000str = '10.5.1' where code like 'I30%'
update dim.Ds set f12t1000str = '10.5.2' where code like 'I33%'
update dim.Ds set f12t1000str = '10.5.3' where code like 'I40%'
update dim.Ds set f12t1000str = '10.5.4' where code like 'I42%'
--update dim.Ds set f12t1000str = '10.6' where code between 'I60' and 'I69.99'
update dim.Ds set f12t1000str = '10.6.8' where code between 'I60' and 'I69.99'
update dim.Ds set f12t1000str = '10.6.1' where code like 'I60%'
update dim.Ds set f12t1000str = '10.6.2' where code between 'I61' and 'I62.99'
update dim.Ds set f12t1000str = '10.6.3' where code like 'I63%'
update dim.Ds set f12t1000str = '10.6.4' where code like 'I64%'
update dim.Ds set f12t1000str = '10.6.5' where code between 'I65' and 'I66.99'
update dim.Ds set f12t1000str = '10.6.6' where code like 'I67%'
update dim.Ds set f12t1000str = '10.6.7' where code like 'I69%'
--update dim.Ds set f12t1000str = '10.8' where code between 'I80' and 'I83.99' or code between 'I85' and 'I89.99'
update dim.Ds set f12t1000str = '10.8.4' where code between 'I80' and 'I83.99' or code between 'I85' and 'I89.99'
update dim.Ds set f12t1000str = '10.8.1' where code like 'I80%'
update dim.Ds set f12t1000str = '10.8.2' where code like 'I81%'
update dim.Ds set f12t1000str = '10.8.3' where code like 'I83%'

--update dim.Ds set f12t1000str = '11' where code between 'J00' and 'J98.99'
update dim.Ds set f12t1000str = '11.11' where code between 'J00' and 'J98.99'
--update dim.Ds set f12t1000str = '11.1' where code between 'J00' and 'J06.99'
update dim.Ds set f12t1000str = '11.1.3' where code between 'J00' and 'J06.99'
update dim.Ds set f12t1000str = '11.1.1' where code like 'J04%'
update dim.Ds set f12t1000str = '11.1.2' where code like 'J05%'
update dim.Ds set f12t1000str = '11.2' where code between 'J09' and 'J11.99'
--update dim.Ds set f12t1000str = '11.3' where code between 'J12' and 'J16.99' or code like 'J18%'
update dim.Ds set f12t1000str = '11.3.2' where code between 'J12' and 'J16.99' or code like 'J18%'
update dim.Ds set f12t1000str = '11.3.1' where code like 'J13%'
update dim.Ds set f12t1000str = '11.4' where code between 'J20' and 'J22.99'
update dim.Ds set f12t1000str = '11.5' where code like 'J30.1%'
update dim.Ds set f12t1000str = '11.6' where code between 'J35' and 'J36.99'
update dim.Ds set f12t1000str = '11.7' where code between 'J40' and 'J43.99'
update dim.Ds set f12t1000str = '11.8' where code like 'J44%'
update dim.Ds set f12t1000str = '11.9' where code like 'J47%'
update dim.Ds set f12t1000str = '11.9' where code like 'J45%' or code like 'J46%'
update dim.Ds set f12t1000str = '11.10' where code between 'J84' and 'J90.99' or code between 'J92' and 'J94.99'

--update dim.Ds set f12t1000str = '12' where code between 'K00' and 'K92.99'
update dim.Ds set f12t1000str = '12.10' where code between 'K00' and 'K92.99'
update dim.Ds set f12t1000str = '12.1' where code between 'K25' and 'K26.99'
update dim.Ds set f12t1000str = '12.2' where code like 'K29%'
update dim.Ds set f12t1000str = '12.3' where code between 'K40' and 'K46.99'
update dim.Ds set f12t1000str = '12.4' where code between 'K50' and 'K52.99'
--update dim.Ds set f12t1000str = '12.5' where code between 'K55' and 'K63.99'
update dim.Ds set f12t1000str = '12.5.2' where code between 'K55' and 'K63.99'
update dim.Ds set f12t1000str = '12.5.1' where code like 'K56%'
update dim.Ds set f12t1000str = '12.6' where code like 'K64%'
--update dim.Ds set f12t1000str = '12.7' where code between 'K70' and 'K76.99'
update dim.Ds set f12t1000str = '12.7.2' where code between 'K70' and 'K76.99'
update dim.Ds set f12t1000str = '12.7.1' where code like 'K74%'
update dim.Ds set f12t1000str = '12.8' where code between 'K80' and 'K83.99'
--update dim.Ds set f12t1000str = '12.9' where code between 'K85' and 'K86.99'
update dim.Ds set f12t1000str = '12.9.2' where code between 'K85' and 'K86.99'
update dim.Ds set f12t1000str = '12.9.1' where code like 'K85%'

--update dim.Ds set f12t1000str = '13' where code between 'L00' and 'L98.99'
update dim.Ds set f12t1000str = '13.7' where code between 'L00' and 'L98.99'
update dim.Ds set f12t1000str = '13.1' where code like 'L20%'
update dim.Ds set f12t1000str = '13.2' where code between 'L23' and 'L25.99'
update dim.Ds set f12t1000str = '13.3' where code like 'L30%'
--update dim.Ds set f12t1000str = '13.4' where code like 'L40%'
update dim.Ds set f12t1000str = '13.4.2' where code like 'L40%'
update dim.Ds set f12t1000str = '13.4.1' where code like 'L40.5%'
update dim.Ds set f12t1000str = '13.5' where code like 'L93.0%'
update dim.Ds set f12t1000str = '13.6' where code like 'L94.0%'

--update dim.Ds set f12t1000str = '14' where code between 'M00' and 'M99.99'
update dim.Ds set f12t1000str = '14.7' where code between 'M00' and 'M99.99'
--update dim.Ds set f12t1000str = '14.1' where code between 'M00' and 'M25.99'
update dim.Ds set f12t1000str = '14.1.6' where code between 'M00' and 'M25.99'
update dim.Ds set f12t1000str = '14.1.1' where code like 'M00.1%'
update dim.Ds set f12t1000str = '14.1.2' where code like 'M02%'
update dim.Ds set f12t1000str = '14.1.3' where code like 'M05%' or code like 'M06%'
update dim.Ds set f12t1000str = '14.1.4' where code like 'M08%'
update dim.Ds set f12t1000str = '14.1.5' where code between 'M15' and 'M19.99'
--update dim.Ds set f12t1000str = '14.2' where code between 'M30' and 'M35.99'
update dim.Ds set f12t1000str = '14.2.2' where code between 'M30' and 'M35.99'
update dim.Ds set f12t1000str = '14.2.1' where code like 'M32%'
update dim.Ds set f12t1000str = '14.3' where code between 'M40' and 'M43.99'
--update dim.Ds set f12t1000str = '14.4' where code between 'M45' and 'M48.99'
update dim.Ds set f12t1000str = '14.4.2' where code between 'M45' and 'M48.99'
update dim.Ds set f12t1000str = '14.4.1' where code like 'M45%'
update dim.Ds set f12t1000str = '14.5' where code between 'M65' and 'M68.99'
--update dim.Ds set f12t1000str = '14.6' where code between 'M80' and 'M94.99'
update dim.Ds set f12t1000str = '14.6.2' where code between 'M80' and 'M94.99'
update dim.Ds set f12t1000str = '14.6.1' where code between 'M80' and 'M81.99'

--update dim.Ds set f12t1000str = '15' where code between 'N00' and 'N99.99'
update dim.Ds set f12t1000str = '15.11' where code between 'N00' and 'N99.99'
update dim.Ds set f12t1000str = '15.1' where code between 'N00' and 'N07.99' OR code between 'N09' and 'N15.99' OR code between 'N25' and 'N28.99'
update dim.Ds set f12t1000str = '15.2' where code between 'N17' and 'N19.99'
update dim.Ds set f12t1000str = '15.3' where code between 'N20' and '21.99' OR code like 'N23%'
update dim.Ds set f12t1000str = '15.4' where code between 'N30' and 'N32.99' OR code between 'N34' and 'N36.99' OR code like 'N39%'
update dim.Ds set f12t1000str = '15.5' where code between 'N40' and 'N42.99'
update dim.Ds set f12t1000str = '15.6' where code like 'N60%'
--update dim.Ds set f12t1000str = '15.7' where code between 'N70' and 'N73.99' or code between 'N75' and 'N76.99'
update dim.Ds set f12t1000str = '15.7.2' where code between 'N70' and 'N73.99' or code between 'N75' and 'N76.99'
update dim.Ds set f12t1000str = '15.7.1' where code like 'N70%'
update dim.Ds set f12t1000str = '15.8' where code like 'N80%'
update dim.Ds set f12t1000str = '15.9' where code like 'N86%'
update dim.Ds set f12t1000str = '15.10' where code between 'N91' and 'N94.99'

update dim.Ds set f12t1000str = '16' where code between 'O00' and 'O99.99'

update dim.Ds set f12t1000str = '17' where code between 'P00' and 'P96.99'

--update dim.Ds set f12t1000str = '18' where code between 'Q00' and 'Q99.99'
update dim.Ds set f12t1000str = '18.10' where code between 'Q00' and 'Q99.99'
update dim.Ds set f12t1000str = '18.1' where code between 'Q00' and 'Q07.99'
update dim.Ds set f12t1000str = '18.2' where code between 'Q10' and 'Q15.99'
update dim.Ds set f12t1000str = '18.3' where code between 'Q20' and 'Q28.99'
update dim.Ds set f12t1000str = '18.4' where code between 'Q50' and 'Q52.99'
update dim.Ds set f12t1000str = '18.5' where code like 'Q56%'
update dim.Ds set f12t1000str = '18.6' where code like 'Q65%'
update dim.Ds set f12t1000str = '18.7' where code like 'Q80%'
update dim.Ds set f12t1000str = '18.8' where code like 'Q85.0%'
update dim.Ds set f12t1000str = '18.9' where code like 'Q90%'

update dim.Ds set f12t1000str = '19' where code between 'R00' and 'R99.99'

--update dim.Ds set f12t1000str = '20' where code between 'S00' and 'T98.99'
update dim.Ds set f12t1000str = '20.2' where code between 'S00' and 'T98.99'
update dim.Ds set f12t1000str = '20.1' where substring(code,1,3) in ('S01', 'S11', 'S21', 'S31', 'S41', 'S51', 'S61', 'S71', 'S81', 'S91')

update dim.Ds set f12t1000str = '21' where code in ('U07.1', 'U07.2')
-- ���������

-- � ��� ��� ����� �� ���������
update ����������.�12_�1000_2021
	set n_cases_014 = outertable.cnt
	from 
		(select count(*) as cnt from [��������������].[�����] a 
			left join dim.Ds b on a.ds=b.code where 
			ages<=14 and (ds between 'A00' and 'T98.99'or ds in ('U07.1', 'U07.2')) and b.f12t1000str is not null) as outertable
	where n_str='1'
update ����������.�12_�1000_2021
	set n_cases_014 = outertable.cnt
	from 
		( select f12t1000str, count(*) as cnt from [��������������].[�����] a 
			left join dim.Ds b on a.ds=b.code where ages<=14 and b.f12t1000str is not null group by f12t1000str) as outertable
	where n_str=outertable.f12t1000str
update ����������.�12_�1000_2021
	set n_cases_04 = outertable.cnt
	from 
		( select f12t1000str, count(*) as cnt from [��������������].[�����] a 
			left join dim.Ds b on a.ds=b.code where ages<=4 and b.f12t1000str is not null group by f12t1000str) as outertable
	where n_str=outertable.f12t1000str
update ����������.�12_�1000_2021
	set n_cases_59 = outertable.cnt
	from 
		( select f12t1000str, count(*) as cnt from [��������������].[�����] a 
			left join dim.Ds b on a.ds=b.code where ages between 5 and 14 and b.f12t1000str is not null group by f12t1000str) as outertable
	where n_str=outertable.f12t1000str
-- ����� ���������� ���������� ������ ���������!

select * from ����������.�12_�1000_2021
go

-- ��������� ������ ���� 1,2,3 � �.�.
with cte (_str, _substr, _ssubstr, qwerty) as
(select _str, _substr, _ssubstr, sum(n_cases_014) over (partition by _str) as qwerty from ����������.�12_�1000_2021)
update ����������.�12_�1000_2021 set n_cases_014 = cte.qwerty from cte
join ����������.�12_�1000_2021 on cte._str=����������.�12_�1000_2021._str and 
	cte._substr=����������.�12_�1000_2021._substr and 
	cte._ssubstr=����������.�12_�1000_2021._ssubstr where ����������.�12_�1000_2021._str>0 and ����������.�12_�1000_2021._substr=0
go
-- ��������� ���������  ���� 1.1,1.2,1.3 � �.� ��� ������� ���-�������� ������ �������� �����...
with cte (_str, _substr, _ssubstr, qwerty) as
(select _str, _substr, _ssubstr, sum(n_cases_014) over (partition by _str, _substr) as qwerty from ����������.�12_�1000_2021)
update ����������.�12_�1000_2021 set n_cases_014 = cte.qwerty from cte
join ����������.�12_�1000_2021 on cte._str=����������.�12_�1000_2021._str and cte._substr=����������.�12_�1000_2021._substr and cte._ssubstr=����������.�12_�1000_2021._ssubstr 
	where ����������.�12_�1000_2021._str>0 and ����������.�12_�1000_2021._substr>0 and ����������.�12_�1000_2021._ssubstr=0
go

-- ����-�����
-- 1. ������� � dim.Ds �������� ���������������� ���������?
select * from dim.ds where code between 'A00' and 'T98.%' and f12t1000str is null -- ��� ����

-- 2. ������������ ����� (2.0, 3.0 � �.�.) - ������ ���� ����� ������ 1.0
select n_cases_014 from ����������.�12_�1000_2021 where _str=1
select count(*) as cnt from [��������������].[�����] a 
			left join dim.Ds b on a.ds=b.code where 
				ages<=14 and (ds between 'A00' and 'T98.99' or ds in ('U07.1', 'U07.2')) and b.f12t1000str is not null
select sum(n_cases_014) from ����������.�12_�1000_2021 where 
	_str in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21) and _substr=0
-- ���� ��� ����� �������, ������ ����� �� ���������!

-- 3. ��������� ����� �������� �� ��������� ������
select n_cases_014 from ����������.�12_�1000_2021 where n_str='2'
select sum(n_cases_014) from ����������.�12_�1000_2021 where 
	n_str in ('2.1','2.2','2.3','2.4')

select n_cases_014 from ����������.�12_�1000_2021 where n_str='3'
select sum(n_cases_014) from ����������.�12_�1000_2021 where 
	n_str in ('3.1','3.2','3.3')

select n_cases_014 from ����������.�12_�1000_2021 where n_str='4'
select sum(n_cases_014) from ����������.�12_�1000_2021 where 
	n_str in ('4.1','4.2','4.3','4.4')

select n_cases_014 from ����������.�12_�1000_2021 where n_str='5'
select sum(n_cases_014) from ����������.�12_�1000_2021 where 
	n_str in ('5.1','5.2','5.3','5.4','5.5','5.6','5.7','5.8','5.9','5.10','5.11','5.12','5.13','5.14','5.15','5.16')

select n_cases_014 from ����������.�12_�1000_2021 where n_str='6'
select sum(n_cases_014) from ����������.�12_�1000_2021 where 
	n_str in ('6.1','6.2','6.3')

select n_cases_014 from ����������.�12_�1000_2021 where n_str='7'
select sum(n_cases_014) from ����������.�12_�1000_2021 where 
	n_str in ('7.1','7.2','7.3','7.4','7.5','7.6','7.7','7.8','7.9','7.10','7.11','7.12')

select n_cases_014 from ����������.�12_�1000_2021 where n_str='8'
select sum(n_cases_014) from ����������.�12_�1000_2021 where 
	n_str in ('8.1','8.2','8.3','8.4','8.5','8.6','8.7','8.8','8.9','8.10','8.11','8.12','8.13')

select n_cases_014 from ����������.�12_�1000_2021 where n_str='9'
select sum(n_cases_014) from ����������.�12_�1000_2021 where 
	n_str in ('9.1','9.2','9.3','9.4','9.5')

select n_cases_014 from ����������.�12_�1000_2021 where n_str='10'
select sum(n_cases_014) from ����������.�12_�1000_2021 where 
	n_str in ('10.1','10.2','10.3','10.4','10.5','10.6','10.7','10.8','10.9')

select n_cases_014 from ����������.�12_�1000_2021 where n_str='11'
select sum(n_cases_014) from ����������.�12_�1000_2021 where 
	n_str in ('11.1','11.2','11.3','11.4','11.5','11.6','11.7','11.8','11.9','11.10','11.11','11.12')

select n_cases_014 from ����������.�12_�1000_2021 where n_str='12'
select sum(n_cases_014) from ����������.�12_�1000_2021 where 
	n_str in ('12.1','12.2','12.3','12.4','12.5','12.6','12.7','12.8','12.9','12.10')

select n_cases_014 from ����������.�12_�1000_2021 where n_str='13'
select sum(n_cases_014) from ����������.�12_�1000_2021 where 
	n_str in ('13.1','13.2','13.3','13.4','13.5','13.6','13.7')

select n_cases_014 from ����������.�12_�1000_2021 where n_str='14'
select sum(n_cases_014) from ����������.�12_�1000_2021 where 
	n_str in ('14.1','14.2','14.3','14.4','14.5','14.6','14.7')

select n_cases_014 from ����������.�12_�1000_2021 where n_str='15'
select sum(n_cases_014) from ����������.�12_�1000_2021 where 
	n_str in ('15.1','15.2','15.3','15.4','15.5','15.6','15.7','15.8','15.9','15.10','15.11')

select n_cases_014 from ����������.�12_�1000_2021 where n_str='18'
select sum(n_cases_014) from ����������.�12_�1000_2021 where 
	n_str in ('18.1','18.2','18.3','18.4','18.5','18.6','18.7','18.8','18.9','18.10')

select n_cases_014 from ����������.�12_�1000_2021 where n_str='20'
select sum(n_cases_014) from ����������.�12_�1000_2021 where 
	n_str in ('20.1','20.2')

-- 4. ��������� ������������ �����
select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds between 'A00' and 'B99.99'
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='2' or b.f12t1000str like '2.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='2'

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds between 'C00' and 'D48.99'
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='3' or b.f12t1000str like '3.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='3'

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds between 'D50' and 'D89.99'
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='4' or b.f12t1000str like '4.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='4'

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds between 'E00' and 'E89.99'
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='5' or b.f12t1000str like '5.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='5'

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (ds like 'F01%' or ds between 'F03' and 'F99.99')
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='6' or b.f12t1000str like '6.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='6' -- ���������� �� � ���, ����

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds between 'G00' and 'G98.99'
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='7' or b.f12t1000str like '7.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='7'

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds between 'H00' and 'H59.99'
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='8' or b.f12t1000str like '8.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='8'

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds between 'H60' and 'H95.99'
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='9' or b.f12t1000str like '9.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='9'

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds between 'I00' and 'I99.99'
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='10' or b.f12t1000str like '10.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='10'

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds between 'J00' and 'J98.99'
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='11' or b.f12t1000str like '11.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='11'

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds between 'K00' and 'K92.99'
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='12' or b.f12t1000str like '12.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='12'

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds between 'L00' and 'L98.99' -- 58828
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='13' or b.f12t1000str like '13.%') --588830
select n_cases_014 from ����������.�12_�1000_2021 where n_str='13'

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds between 'M00' and 'M99.99'
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='14' or b.f12t1000str like '14.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='14'

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds between 'N00' and 'N99.99'
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='15' or b.f12t1000str like '15.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='15'

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds between 'O00' and 'O99.99'
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='16' or b.f12t1000str like '16.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='16'

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds between 'P00' and 'P96.99'
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='17' or b.f12t1000str like '17.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='17'

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds between 'Q00' and 'Q99.99'
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='18' or b.f12t1000str like '18.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='18'

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds between 'R00' and 'R99.99'
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='19' or b.f12t1000str like '19.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='19'

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds between 'S00' and 'T98.99'
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='20' or b.f12t1000str like '20.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='20'

select count(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and ds in ('U07.1', 'U07.2')
select COUNT(*) from [��������������].[�����] a 
	left join dim.Ds b on a.ds=b.code where ages<=14 and (b.f12t1000str='21' or b.f12t1000str like '21.%')
select n_cases_014 from ����������.�12_�1000_2021 where n_str='21'

-- Unit tests
