create table holidays (holiday date);

insert /*+ append */ into holidays select trunc(sysdate) + level from dual connect by level <= 1e4;

commit;

delete from holidays where holiday in 
    (trunc(sysdate) + 43, trunc(sysdate) + 56,  trunc(sysdate) + 12, trunc(sysdate) + 90, trunc(sysdate) +110);

commit;

create unique index  holiday_idx on holidays (holiday)  ;

alter table holidays add constraint holiday_pk primary key (holiday) using index holiday_idx;

begin
    dbms_stats.gather_table_stats(ownname => user,tabname => 'HOLIDAYS');
end;
/

SELECT MIN(dt) AS work_day
FROM (SELECT trunc(to_date('&tst_dt', 'dd.mm.yyyy')) AS dt
      FROM dual
      UNION ALL
      SELECT MIN(t.holiday) - 1 AS last_wk_day_before_hol
      FROM (SELECT t_1.holiday,
                    --group_id is the same for adjacent holidays
                   t_1.holiday - row_number() over(ORDER BY t_1.holiday) AS group_id
            FROM holidays t_1) t
      GROUP BY t.group_id
      HAVING trunc(to_date('&tst_dt', 'dd.mm.yyyy')) BETWEEN MIN(t.holiday) AND MAX(t.holiday)
      );
