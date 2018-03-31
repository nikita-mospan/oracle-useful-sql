with 
    t as (
        select 1 as id, 'c1' as C, 'd1' as D, 'e1' as E from dual
        union all
        select 2 as id, 'c2' as C, 'd2' as D, 'e2' as E from dual
    ),
	t_1 as (
		select 1 as id, 'aaa' as name from dual
	)
select
	t.id
	, t.col_name
	, t.col_value
	, t_1.name
from 
	t 	unpivot ( col_value for col_name in (C, D, E) ) t
	join t_1 t_1 on t.id = t_1.id
;
	