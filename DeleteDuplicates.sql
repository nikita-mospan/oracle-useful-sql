create table t_dup (id number);

insert into t_dup (id)
select mod(level, 2) from dual
connect by level <= 1000000;

commit;

begin
	DBMS_STATS.GATHER_TABLE_STATS(ownname => user
								, tabname => 'T_DUP'
								, estimate_percent => dbms_stats.auto_sample_size
								, degree => dbms_stats.default_degree);
end;

delete from t_dup
where rownum not in (
	select min(rowid)
	from t_dup t_1
	group by t_1.id
	);

commit;