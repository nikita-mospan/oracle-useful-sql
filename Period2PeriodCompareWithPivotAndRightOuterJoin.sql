--partition by right outer join with pivot for period to period comparisons
with
	fact as (
		select 12 as amount, 2013 as year_id, 1 as month_key from dual
		union all
		select 5 as amount, 2013 as year_id, 3 as month_key from dual
		union all
		select 14 as amount, 2014 as year_id, 2 as month_key from dual
		union all
		select 6 as amount, 2014 as year_id, 3 as month_key from dual
	),
	month_dim as (
		select 1 as month_key, 'January' as month_name from dual
		union all
		select 2 as month_key, 'February' as month_name from dual
        union all
        select 3 as month_key, 'March' as month_name from dual
    )
select
    t.month_name
    , t.AMT_2013
    , t.AMT_2014
from 
    (select
        f.year_id
        , d.month_name
        , d.month_key
        , f.amount
    from
        fact f
            partition by (f.year_id)
            right outer join month_dim d on f.month_key = d.month_key
    order by 
        f.year_id
        , d.month_key) 
        pivot ( sum(amount) for year_id in (2013 as AMT_2013, 2014 as AMT_2014)) t
order by t.month_key
;
