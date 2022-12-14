-- Форма 12 (УТВЕРЖДЕНА приказом Росстата от 20.12.2021 N 932, Актуальна на 2022 год)
-- СВЕДЕНИЯ О ЧИСЛЕ ЗАБОЛЕВАНИЙ, ЗАРЕГИСТРИРОВАННЫХ У БОЛЬНЫХ, 
-- ПРОЖИВАЮЩИХ В РАЙОНЕ ОБСЛУЖИВАНИЯ ЛЕЧЕБНОГО УЧРЕЖДЕНИЯ 
-- Таблица (1500) - дети первых трех лет жизни

DECLARE @people int = 7400000 -- это средняя численность населения по I3+R4+S7. На эту цифру делить!

-- создаем временную таблицу для генерации отчетов - называем, как в форме - таблица (1000)
IF OBJECT_ID('Статистика.Ф12_Т1500_2021') IS NOT NULL DROP TABLE Статистика.Ф12_Т1500_2021
create table Статистика.Ф12_Т1500_2021 (
	-- показывать в отчете?
	show bit default 1,
	-- Наименование классов и отдельных болезней
	name varchar(250),
	-- номер строки: 1,2,3 и т.д.
	_str tinyint default 0,
	-- номер субстроки в пределах строки, например 1 в 1.1, 2 в 1.2, 0 в 1.0
	_substr tinyint default 0,
	-- номер субстроки в субстроке, например 3 в 1.2.3
	_ssubstr tinyint default 0,
	-- N строки
	n_str varchar(10) collate Cyrillic_General_CI_AI not null primary key nonclustered,
	-- Код по МКБ-10 пересмотра
	ds varchar(50),
	-- Зарегистрировано заболеваний у детей от 0 до 3 лет включительно, всего
	n_cases_03 int default 0, 
	-- из них (из n_cases_03) у детей до года
	n_cases_01 int default 0, 
	-- из них (из n_cases_03) у детей от года до 3 лет
	n_cases_13 int default 0, 
	-- из них (из n_cases_014) взято под диспансерное наблюдение
	in_dsp int default 0, 
	-- из них (из n_cases_014) в том числе с диагнозом, установленным впервые в жизни
	n_primary int default 0,
	-- из заболеваний с впервые в жизни установленным диагнозом (из n_primary) взято под диспансерное наблюдение
	in_disp_prim int default 0,
	-- из заболеваний с впервые в жизни установленным диагнозом (из n_primary) выявлено при прифосмотре (посчитать не можем)
	n_primary_prof int default 0,
	-- снято с диспансерного учета (под вопросом расчет)
	out_disp int default 0,
	-- Состоит под диспансерным наблюдением на конец отчетного года (под вопросом расчет)
	n_disp int default 0
) 

-- скрипт ниже (ряд инсёртов) создает строки, соответствующие таблице отчетной формы
-- insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('', '', '')
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('Зарегистрировано заболеваний - всего', '1', 'А00-Т98',1,0,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('в том числе: некоторые инфекционные и паразитарные болезни', '2', 'А00-В99',2,0,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('из них: кишечные инфекции', '2.1', 'А00-А09',2,1,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('менингококковая инфекция', '2.2', 'А39',2,2,0)
insert into Статистика.Ф12_Т1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, 'прочие', '2.3','',2,3,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('новообразования', '3', 'С00-D48',3,0,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('злокачественные новообразования', '3.1', 'С00-С96',3,1,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('новообразования  лимфоидной, кроветворной и родственных им тканей', '3.1.1', 'С81-С96',3,1,1)
insert into Статистика.Ф12_Т1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, 'прочие', '3.1.2','',3,1,2)
insert into Статистика.Ф12_Т1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, 'прочие', '3.2','',3,2,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('болезни крови, кроветворных органов и отдельные нарушения, вовлекающие иммунный механизм', '4', 'D50-D89',4,0,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('анемии', '4.1', 'D50-D64',4,1,0)
insert into Статистика.Ф12_Т1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, 'прочие', '4.2','',4,2,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('болезни эндокринной системы, расстройства питания и нарушения обмена веществ', '5', 'E00-E89',5,0,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('болезни щитовидной железы', '5.1', 'E00-E07',5,1,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('из них: синдром врожденной йодной недостаточности', '5.1.1', 'E00',5,1,1)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('врожденный гипотериоз', '5.1.2', 'E03.1',5,1,2)
insert into Статистика.Ф12_Т1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, 'прочие', '5.1.3', '',5,1,3)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('сахарный диабет', '5.2', 'E10-E14',5,2,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('гиперфункция гипофиза', '5.3', 'E22',5,3,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('адреногенитальные расстройства', '5.6', 'E25',5,6,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('рахит', '5.9', 'E55.0',5,9,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('фенилкетонурия', '5.10', 'E70.0',5,10,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('нарушения обмена галактозы (галактоземия)', '5.11', 'E74.2',5,11,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('муковисцидоз', '5.14', 'E84',5,14,0)
insert into Статистика.Ф12_Т1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, 'прочие', '5.15','',5,15,0)
insert into Статистика.Ф12_Т1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, 'прочие', '5.2', '',5,2,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('психические расстройства и расстройства поведения', '6', 'F01, F03-F99',6,0,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('из них: умственная отсталость', '6.1', 'F70 - F79',6,1,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('специфические расстройства речи и языка', '6.2', 'F80',6,2,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('специфические расстройства развития моторной функции', '6.3', 'F82',6,3,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('общие расстройства психологического развития', '6.4', 'F84',6,4,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('из них: детский аутизм, атипичный аутизм, синдром Ретта, дезинтегративное расстройство детского возраста', '6.4.1', 'F84.03',6,4,1)
insert into Статистика.Ф12_Т1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, 'прочие', '6.4.2', '',6,4,2)
insert into Статистика.Ф12_Т1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, 'прочие', '6.5','',6,5,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('болезни нервной системы', '7', 'G00-G98',7,0,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('из них  детский церебральный паралич', '7.9.1', 'G80',7,9,1)
insert into Статистика.Ф12_Т1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, 'прочие', '7.9.2', '',7,9,2)
insert into Статистика.Ф12_Т1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, 'прочие', '7.10','',7,10,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('болезни глаза и его придаточного аппарата', '8', 'H00-H59',8,0,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('из них преретинопатия', '8.6', 'H35.1',8,6,0)
insert into Статистика.Ф12_Т1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, 'прочие', '8.7','',8,7,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('болезни уха и сосцевидного отростка', '9', 'H60-H95',9,0,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('кондуктивная и нейросенсорная потеря слуха', '9.4', 'Н90',9,4,0)
insert into Статистика.Ф12_Т1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, 'прочие', '9.5','',9,5,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('болезни системы кровообращения', '10', 'I00-I99',10,0,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('болезни органов дыхания', '11', 'J00-J98',11,0,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('из них: острые респираторные инфекции верхних дыхательных путей', '11.1', 'J00 - J06',11,1,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('грипп', '11.2', 'J09-J11',11,2,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('пневмонии', '11.3', 'J12-J16,J18',11,3,0)
insert into Статистика.Ф12_Т1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, 'прочие', '11.4','',11,4,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('болезни органов пищеварения', '12', 'K00-K92',12,0,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('болезни кожи и подкожной клетчатки', '13', 'L00-L98',13,0,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('болезни костно-мышечной системы и соединительной ткани', '14', 'M00-M99',14,0,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('болезни мочеполовой системы', '15', 'N00-N99',15,0,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('отдельные состояния, возникающие в перинатальном периоде', '17', 'P00-P96',17,0,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('из них: родовая травма', '17.1', 'P10 - P15',17,1,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('внутричерепное нетравматическое кровоизлияние у плода и новорожденного', '17.2', 'P52',17,2,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('другие нарушения церебрального статуса у новорожденного', '17.3', 'P91',17,3,0)
insert into Статистика.Ф12_Т1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, 'прочие', '17.4','',17,4,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('врожденные аномалии (пороки развития), деформации и хромосомные нарушения', '18', 'Q00-Q99',18,0,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('врожденные аномалии развития нервной системы  ', '18.1', 'Q00-Q07',18,1,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('врожденные аномалии системы кровообращения', '18.2', 'Q20-Q28',18,2,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('расщелина губы и неба (заячья губа и волчья пасть)', '18.3', 'Q35-Q37',18,3,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('хромосомные аномалии, не классифицированные в других рубриках', '18.4', 'Q90 - Q99',18,4,0)
insert into Статистика.Ф12_Т1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, 'прочие', '18.5','',18,5,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('симптомы, признаки и отклонения от нормы, выявленные при клинических и лабораторных исследованиях, не классифицированные в других рубриках', '19', 'R00-R99',19,0,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('травмы, отравления и некоторые другие последствия воздействия внешних причин', '20', 'S00-T98',20,0,0)
insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('из них: открытые укушенные раны (только с кодом внешней причины W54)', '20.1', 'S01, S11, S21, S31, S41, S51, S61, S71, S81, S91',20,1,0)
insert into Статистика.Ф12_Т1500_2021 (show, name, n_str, ds, _str, _substr, _ssubstr) values (0, 'прочие', '20.2','',20,2,0)

insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('COVID-19', '21', 'U07.1, U07.2',21,0,0)

-- Дети (до 14 лет включительно)
-- Факторы, влияющие на состояние здоровья населения и обращения в учреждения здравоохранения
-- Профосмоты, в таблице Первичные приемы не участвуют!
--insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('Всего', '1.0', 'Z00-Z99')
--insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('обращения в учреждения здравоохранения для медицинского осмотра и обследования ', '1.1', 'Z00-Z13')
--insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('потенциальная опасность для здоровья, связанная с инфекционными болезнями', '1.2', 'Z20-Z29')
--insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('обращения в учреждения здравоохранения в связи с обстоятельствами, относящимися к репродуктивной функции', '1.3', 'Z30-Z39')
--insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('обращения в учреждения здравоохранения в связи с необходимостью проведения специфических процедур и получения медицинской помощи', '1.4', 'Z40-Z54')
--insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('потенциальная опасность для здоровья, связанная с социально-экономическими и психосоциальными обстоятельствами', '1.5', 'Z55-Z65')
--insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('обращения в учреждения здравоохранения в связи с другими обстоятельствами', '1.6', 'Z70-Z76')
--insert into Статистика.Ф12_Т1500_2021 (name, n_str, ds, _str, _substr, _ssubstr) values ('потенциальная опасность для здоровья, связанная  с личным или семейным анамнезом и определенными обстоятельствами, влияющими на здоровье', '1.7', 'Z80-Z99')

select * from Статистика.Ф12_Т1500_2021
	
-- скрипт ниже предназначен для разовой модификации размерности диагнозов.
update dim.Ds set f12t1500str = '2.3' where code between 'A00' and 'B99.99' -- прочие
update dim.Ds set f12t1500str = '2.1' where code between 'A00' and 'A09.99'
update dim.Ds set f12t1500str = '2.2' where code like 'A39%'

update dim.Ds set f12t1500str = '3.2' where code between 'C00' and 'D48.99' -- прочие
update dim.Ds set f12t1500str = '3.1.2' where code between 'C00' and 'C96.99' -- прочие
update dim.Ds set f12t1500str = '3.1.1' where code between 'C81' and 'C96.99'

update dim.Ds set f12t1500str = '4.2' where code between 'D50' and 'D89.99' -- прочие
update dim.Ds set f12t1500str = '4.1' where code between 'D50' and 'D64.99'

--update dim.Ds set f12t1500str = '5' where code between 'E00' and 'E89.99'
update dim.Ds set f12t1500str = '5.15' where code between 'E00' and 'E89.99'  -- прочие
--update dim.Ds set f12t1500str = '5.1' where code between 'E00' and 'E07.99' 
update dim.Ds set f12t1500str = '5.1.3' where code between 'E00' and 'E07.99' -- прочие
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
update dim.Ds set f12t1500str = '6.5' where code like 'F01%' or code between 'F03' and 'F99.99' -- прочие
update dim.Ds set f12t1500str = '6.1' where code between 'F70' and 'F79.99'
update dim.Ds set f12t1500str = '6.2' where code like 'F80%'
update dim.Ds set f12t1500str = '6.3' where code like 'F82%'
-- update dim.Ds set f12t1500str = '6.4' where code between 'F10' and 'F19.99'
update dim.Ds set f12t1500str = '6.4.2' where code like 'F84%' -- прочие
update dim.Ds set f12t1500str = '6.4.1' where code between 'F84.0' and 'F84.39'

--update dim.Ds set f12t1500str = '7' where code between 'G00' and 'G98.99'
update dim.Ds set f12t1500str = '7.10' where code between 'G00' and 'G98.99' -- прочие
--update dim.Ds set f12t1500str = '7.9' where code between 'G80' and 'G83.99'
update dim.Ds set f12t1500str = '7.9.2' where code between 'G80' and 'G83.99' -- прочие
update dim.Ds set f12t1500str = '7.9.1' where code like 'G80%'

--update dim.Ds set f12t1500str = '8' where code between 'H00' and 'H59.99'
update dim.Ds set f12t1500str = '8.7' where code between 'H00' and 'H59.99'
update dim.Ds set f12t1500str = '8.6' where code like 'H35.1%'

--update dim.Ds set f12t1500str = '9' where code between 'H60' and 'H95.99'
update dim.Ds set f12t1500str = '9.5' where code between 'H60' and 'H95.99' -- прочие
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
-- проверено

-- и вот так будем ее заполнять
update Статистика.Ф12_Т1500_2021
	set n_cases_03 = outertable.cnt
	from 
		(select count(*) as cnt from [Заболеваемость].[Общая] a 
			left join dim.Ds b on a.ds=b.code where 
			ages<=3 and (ds between 'A00' and 'T98.99'or ds in ('U07.1', 'U07.2')) and b.f12t1500str is not null) as outertable
	where n_str='1'
update Статистика.Ф12_Т1500_2021
	set n_cases_01 = outertable.cnt
	from 
		(select count(*) as cnt from [Заболеваемость].[Общая] a 
			left join dim.Ds b on a.ds=b.code where 
			ages<=1 and (ds between 'A00' and 'T98.99'or ds in ('U07.1', 'U07.2')) and b.f12t1500str is not null) as outertable
	where n_str='1'
update Статистика.Ф12_Т1500_2021
	set n_cases_13 = outertable.cnt
	from 
		(select count(*) as cnt from [Заболеваемость].[Общая] a 
			left join dim.Ds b on a.ds=b.code where 
			(ages between 1 and 3) and (ds between 'A00' and 'T98.99'or ds in ('U07.1', 'U07.2')) and b.f12t1500str is not null) as outertable
	where n_str='1'
update Статистика.Ф12_Т1500_2021
	set n_cases_03 = outertable.cnt
	from 
		( select f12t1500str, count(*) as cnt from [Заболеваемость].[Общая] a 
			left join dim.Ds b on a.ds=b.code where ages<=3 and b.f12t1500str is not null group by f12t1500str) as outertable
	where n_str=outertable.f12t1500str
update Статистика.Ф12_Т1500_2021
	set n_cases_01 = outertable.cnt
	from 
		( select f12t1500str, count(*) as cnt from [Заболеваемость].[Общая] a 
			left join dim.Ds b on a.ds=b.code where 
			ages<=1 and b.f12t1500str is not null group by f12t1500str) as outertable
	where n_str=outertable.f12t1500str
update Статистика.Ф12_Т1500_2021
	set n_cases_13 = outertable.cnt
	from 
		( select f12t1500str, count(*) as cnt from [Заболеваемость].[Общая] a 
			left join dim.Ds b on a.ds=b.code where 
			ages between 1 and 3 and b.f12t1500str is not null group by f12t1500str) as outertable
	where n_str=outertable.f12t1500str
-- после заполнения заполенены только субстроки!

select * from Статистика.Ф12_Т1500_2021
go

-- Заполняем строки вида 1,2,3 и т.д.
with cte (_str, _substr, _ssubstr, qwerty) as
(select _str, _substr, _ssubstr, sum(n_cases_03) over (partition by _str) as qwerty from Статистика.Ф12_Т1500_2021)
update Статистика.Ф12_Т1500_2021 set n_cases_03 = cte.qwerty from cte
join Статистика.Ф12_Т1500_2021 on cte._str=Статистика.Ф12_Т1500_2021._str and 
	cte._substr=Статистика.Ф12_Т1500_2021._substr and 
	cte._ssubstr=Статистика.Ф12_Т1500_2021._ssubstr where Статистика.Ф12_Т1500_2021._str>0 and Статистика.Ф12_Т1500_2021._substr=0
go
-- Заполняем подстроки  вида 1.1,1.2,1.3 и т.д При наличии суб-субстрок должны появится цифры...
with cte (_str, _substr, _ssubstr, qwerty) as
(select _str, _substr, _ssubstr, sum(n_cases_03) over (partition by _str, _substr) as qwerty from Статистика.Ф12_Т1500_2021)
update Статистика.Ф12_Т1500_2021 set n_cases_03 = cte.qwerty from cte
join Статистика.Ф12_Т1500_2021 on cte._str=Статистика.Ф12_Т1500_2021._str and cte._substr=Статистика.Ф12_Т1500_2021._substr and cte._ssubstr=Статистика.Ф12_Т1500_2021._ssubstr 
	where Статистика.Ф12_Т1500_2021._str>0 and Статистика.Ф12_Т1500_2021._substr>0 and Статистика.Ф12_Т1500_2021._ssubstr=0
go

with cte (_str, _substr, _ssubstr, qwerty) as
(select _str, _substr, _ssubstr, sum(n_cases_01) over (partition by _str) as qwerty from Статистика.Ф12_Т1500_2021)
update Статистика.Ф12_Т1500_2021 set n_cases_01 = cte.qwerty from cte
join Статистика.Ф12_Т1500_2021 on cte._str=Статистика.Ф12_Т1500_2021._str and 
	cte._substr=Статистика.Ф12_Т1500_2021._substr and 
	cte._ssubstr=Статистика.Ф12_Т1500_2021._ssubstr where Статистика.Ф12_Т1500_2021._str>0 and Статистика.Ф12_Т1500_2021._substr=0
go
-- Заполняем подстроки  вида 1.1,1.2,1.3 и т.д При наличии суб-субстрок должны появится цифры...
with cte (_str, _substr, _ssubstr, qwerty) as
(select _str, _substr, _ssubstr, sum(n_cases_01) over (partition by _str, _substr) as qwerty from Статистика.Ф12_Т1500_2021)
update Статистика.Ф12_Т1500_2021 set n_cases_01 = cte.qwerty from cte
join Статистика.Ф12_Т1500_2021 on cte._str=Статистика.Ф12_Т1500_2021._str and cte._substr=Статистика.Ф12_Т1500_2021._substr and cte._ssubstr=Статистика.Ф12_Т1500_2021._ssubstr 
	where Статистика.Ф12_Т1500_2021._str>0 and Статистика.Ф12_Т1500_2021._substr>0 and Статистика.Ф12_Т1500_2021._ssubstr=0
go

with cte (_str, _substr, _ssubstr, qwerty) as
(select _str, _substr, _ssubstr, sum(n_cases_13) over (partition by _str) as qwerty from Статистика.Ф12_Т1500_2021)
update Статистика.Ф12_Т1500_2021 set n_cases_13 = cte.qwerty from cte
join Статистика.Ф12_Т1500_2021 on cte._str=Статистика.Ф12_Т1500_2021._str and 
	cte._substr=Статистика.Ф12_Т1500_2021._substr and 
	cte._ssubstr=Статистика.Ф12_Т1500_2021._ssubstr where Статистика.Ф12_Т1500_2021._str>0 and Статистика.Ф12_Т1500_2021._substr=0
go
-- Заполняем подстроки  вида 1.1,1.2,1.3 и т.д При наличии суб-субстрок должны появится цифры...
with cte (_str, _substr, _ssubstr, qwerty) as
(select _str, _substr, _ssubstr, sum(n_cases_13) over (partition by _str, _substr) as qwerty from Статистика.Ф12_Т1500_2021)
update Статистика.Ф12_Т1500_2021 set n_cases_13 = cte.qwerty from cte
join Статистика.Ф12_Т1500_2021 on cte._str=Статистика.Ф12_Т1500_2021._str and cte._substr=Статистика.Ф12_Т1500_2021._substr and cte._ssubstr=Статистика.Ф12_Т1500_2021._ssubstr 
	where Статистика.Ф12_Т1500_2021._str>0 and Статистика.Ф12_Т1500_2021._substr>0 and Статистика.Ф12_Т1500_2021._ssubstr=0
go

-- Юнит-тесты
-- 1. Сколько в dim.Ds осталось нераспределенных диагнозов?
select * from dim.ds where code between 'A00' and 'T98.%' and f12t1500str is null -- все норм

-- 2. Просуммируем строи (2.0, 3.0 и т.д.) - должно быть равно строке 1.0
select n_cases_01 from Статистика.Ф12_Т1500_2021 where _str=1
select count(*) as cnt from [Заболеваемость].[Общая] a 
			left join dim.Ds b on a.ds=b.code where 
				ages<=1 and (ds between 'A00' and 'T98.99' or ds in ('U07.1', 'U07.2')) and b.f12t1500str is not null
select sum(n_cases_01) from Статистика.Ф12_Т1500_2021 where 
	_str in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21) and _substr=0

select n_cases_03 from Статистика.Ф12_Т1500_2021 where _str=1
select count(*) as cnt from [Заболеваемость].[Общая] a 
			left join dim.Ds b on a.ds=b.code where 
				ages<=3 and (ds between 'A00' and 'T98.99' or ds in ('U07.1', 'U07.2')) and b.f12t1500str is not null
select sum(n_cases_03) from Статистика.Ф12_Т1500_2021 where 
	_str in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21) and _substr=0

select n_cases_13 from Статистика.Ф12_Т1500_2021 where _str=1
select count(*) as cnt from [Заболеваемость].[Общая] a 
			left join dim.Ds b on a.ds=b.code where 
				(ages between 1 and 3) and (ds between 'A00' and 'T98.99' or ds in ('U07.1', 'U07.2')) and b.f12t1500str is not null
select sum(n_cases_13) from Статистика.Ф12_Т1500_2021 where 
	_str in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21) and _substr=0
-- если три цифры совпали, дальше можно не проверять!

-- 3. Проверяем сумму подстрок на равестово строке
-- Unit tests
