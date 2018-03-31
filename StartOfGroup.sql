create table t123 (c int primary key) nologging;

insert /*+ append */ into t123 select level from dual connect by level <= 100;

commit;

delete from t123 where c in (select TRUNC (DBMS_RANDOM.VALUE (0, 100)) from dual connect by level <= 10);

commit;

--Get first element of contiguous sequences.
/* For example:
100
101
102
110
111
115
should return:
100
110
115
*/

--start of group method
--Firstly define start of each group (group_start flag)
--The we count cummulative sum to define the group of records (group_id)
--Then we can count min, max etc.
WITH 
    t_1 AS
        (SELECT t.c AS c,
             CASE
                 WHEN t.c - 1 = lag(t.c) over(ORDER BY t.c) THEN 0
                 ELSE 1
             END group_start
        FROM t123 t),
    t_2 AS
        (SELECT t_1.c, 
            SUM(t_1.group_start) over(ORDER BY t_1.c) AS group_id
        FROM t_1)
SELECT 
    MIN(t_2.c) 
FROM t_2 
GROUP BY t_2.group_id 
ORDER BY t_2.group_id;
