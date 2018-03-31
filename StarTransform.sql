drop table f;

drop table d;

drop table d1;

create table f nologging as select level + 100 as amt, mod(level, 10) as d_key, mod(level, 10) as d1_key from dual connect by level <= 1e5 * 5;

create table d as select level as d_key, 'desc' || to_char(level) as name, case when mod(level, 2) = 0 then 'Small' else 'Big' end as segment from dual connect by level <=10;

create table d1 as select level as d1_key, 'desc' || to_char(level) as d1_name, case when mod(level, 2) = 0 then 'Small' else 'Big' end as d1_segment from dual connect by level <=10;

create unique index d_idx on d (d_key);

alter table d add constraint d_pk primary key (d_key) using index d_idx;

create unique index d1_idx on d1 (d1_key);

alter table d1 add constraint d1_pk primary key (d1_key) using index d1_idx;

create bitmap index f_d_key on f (d_key) nologging compute statistics;

create bitmap index f_d1_key on f (d1_key)  nologging compute statistics;

begin
    dbms_stats.gather_table_stats(ownname => user, tabname => 'F');
    dbms_stats.gather_table_stats(ownname => user, tabname => 'D');
    dbms_stats.gather_table_stats(ownname => user, tabname => 'D1');
end; 
/

alter session set STAR_TRANSFORMATION_ENABLED=TRUE;

SELECT /*+ gather_plan_statistics star_transformation fact(f) id112 */
 SUM(f.amt)
FROM f, d, d1
WHERE f.d_key = d.d_key
      AND f.d1_key = d1.d1_key
      AND d.segment = 'Small'
      AND d1.d1_segment = 'Big';
