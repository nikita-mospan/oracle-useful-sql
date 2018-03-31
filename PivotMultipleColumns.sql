with
	t as (
		select 1 as id, 20 as value, 'C' as col_name from dual
		union all
		select 1 as id, 10 as value, 'C' as col_name from dual
		union all
		select 2 as id, 100 as value, 'C' as col_name from dual
		union all
		select 3 as id, 20 as value, 'D' as col_name from dual
	)
select
	t.C_COL_1
	, t.C_COL_2
	, t.D_COL_3
from t pivot (sum(value) for (id, col_name) in ((1, 'C') as C_COL_1, (2, 'C') as C_COL_2, (3, 'D') as D_COL_3)) t
;