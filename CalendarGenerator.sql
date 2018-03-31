with 
    fst_lst_day as (
        select
            trunc(:sample_date, 'mm') as fst
            , trunc(last_day(:sample_date)) as lst
        from dual
    ),
	month_info as (
        select
            to_char(t.fst + level -1, 'dd') as day_num_in_month
            ,to_number(to_char(t.fst + level -1, 'd')) as day_num_in_week
            ,to_char(t.fst + level -1, 'iw') as week_num_in_year
        from fst_lst_day t
        connect by level <= t.lst - t.fst + 1)
select
	max(case mon_inf.day_num_in_week when 2 then mon_inf.day_num_in_month end) Monday
	, max(case mon_inf.day_num_in_week when 3 then mon_inf.day_num_in_month end) Tuesday
	, max(case mon_inf.day_num_in_week when 4 then mon_inf.day_num_in_month end) Wednesday
	, max(case mon_inf.day_num_in_week when 5 then mon_inf.day_num_in_month end) Thursday
	, max(case mon_inf.day_num_in_week when 6 then mon_inf.day_num_in_month end) Friday
	, max(case mon_inf.day_num_in_week when 7 then mon_inf.day_num_in_month end) Saturday
	, max(case mon_inf.day_num_in_week when 1 then mon_inf.day_num_in_month end) Sunday
from month_info mon_inf
group by mon_inf.week_num_in_year
order by mon_inf.week_num_in_year
;