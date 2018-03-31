with emp_sal as (
	select	
		10 as deptno
		,'CLARK' as ename
		,2450 as sal
		,to_date('09.06.1981', 'dd.mm.yyyy') as hiredate
	from dual
	union all
	select	10, 'ANT', 1000, to_date('17.11.1981', 'dd.mm.yyyy') from dual
	union all
	select	10, 'JOE', 1500, to_date('17.11.1981', 'dd.mm.yyyy') from dual
	union all
	select	10, 'JIM', 1600, to_date('17.11.1981', 'dd.mm.yyyy') from dual
	union all
	select	10, 'JOHN', 1700, to_date('17.11.1981', 'dd.mm.yyyy') from dual
	union all
	select	10, 'KING', 5000, to_date('17.11.1981', 'dd.mm.yyyy') from dual
	union all
	select	10, 'MILLER', 1300, to_date('23.01.1982', 'dd.mm.yyyy') from dual
)
select
	t_1.deptno
	, t_1.ename
	, t_1.hiredate
	, t_1.sal
	, t_1.sal - lead(t_1.sal, t_1.cnt - t_1.rn + 1) 
		over (partition by t_1.deptno order by t_1.hiredate, t_1.ename) as sal_diff
from
    (select
        t.deptno as deptno
        , t.ename as ename
        , t.sal as sal
        , t.hiredate as hiredate
        , count(*) over(partition by t.deptno, t.hiredate) as cnt
        , row_number() over(partition by t.deptno, t.hiredate order by t.ename) as rn
        from emp_sal t) t_1
;