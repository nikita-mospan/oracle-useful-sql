--Log table contains logon/logoff timings for a particular User session
--Write SELECT query that returns Maximum number of active sessions and minimum time when it happened

with log as
   (select 'U1' username, date '2013-08-08'+1/24 logon_time,
    date '2013-08-08'+10/24 logoff_time from dual
   union all select 'U1' username, date '2013-08-08'+6/24 logon_time,
    date '2013-08-08'+14/24 logoff_time from dual
   union all select 'U1' username, date '2013-08-08'+4/24 logon_time,
    date '2013-08-08'+12/24 logoff_time from dual
   union all select 'U1' username, date '2013-08-08'+8/24 logon_time,
    date '2013-08-08'+17/24 logoff_time from dual
   union all select 'U1' username, date '2013-08-08'+16/24 logon_time,
    date '2013-08-08'+18/24 logoff_time from dual
   union all select 'U1' username, date '2013-08-08'+9/24 logon_time,
    date '2013-08-08'+16/24 logoff_time from dual
   union all select 'U2' username, date '2013-08-08'+1/24 logon_time,
    date '2013-08-08'+3/24 logoff_time from dual
   union all select 'U2' username, date '2013-08-08'+2/24 logon_time,
    date '2013-08-08'+12/24 logoff_time from dual
   union all select 'U2' username, date '2013-08-08'+11/24 logon_time,
    date '2013-08-08'+13/24 logoff_time from dual
   union all select 'U2' username, date '2013-08-08'+10/24 logon_time,
    date '2013-08-08'+14/24 logoff_time from dual),
q1 as (
    select
        t.username,
        t.logon_time as time,
        t.logon_time,
        1 as weight
    from log t
    union all
    select
        t.username,
        t.logoff_time,
        t.logon_time,
        -1 as weight
    from log t
    ),
q2 as (
    select 
        t.username,
        sum(t.weight) over (partition by t.username order by t.time, weight desc) as cnt,
        t.logon_time
    from q1 t 
    ) 
select
    t.username,
    max(t.cnt) as cnt,
    max(t.logon_time) keep (dense_rank first order by t.cnt desc nulls last) as min_time_with_max_actv_sns
from q2 t
group by t.username
; 
