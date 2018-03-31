with
	fib_el_indexes as (
		select level as i from dual
		connect by level <= to_number(&n))
	, nth_fib_el(idx, next_val, cur_val) as (
		select 1 as idx, 1 as next_val, 0 as cur_val from dual
		union all
		select
			(nth_fib_el.idx + 1) as idx
			, nth_fib_el.cur_val + nth_fib_el.next_val as cur_val
			, nth_fib_el.next_val as cur_val
        from
            nth_fib_el nth_fib_el
            , fib_el_indexes fib_idx
        where (nth_fib_el.idx + 1) = fib_idx.i
)    
select
    nth_fib_el.idx,
    nth_fib_el.cur_val
from nth_fib_el nth_fib_el
where nth_fib_el.idx = to_number(&n)
order by nth_fib_el.idx
;