use lpu 
select sum(s_all) from facts.Services where q='I3' and period='202101' and mcod='0343040'

-- просто копируем таблицу
select * into dim.Ds_2 from dim.Ds  

use i3
select * into dbo.pr4_2 from dbo.pr4

select * into facts.Cases_2 from facts.Cases

select top 1000  *, ROW_NUMBER() over (partition by sn_pol, ds order by d_u asc) as n_obr from [Заболеваемость].[Общая] 


