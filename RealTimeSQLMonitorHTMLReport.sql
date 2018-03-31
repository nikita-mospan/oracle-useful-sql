set long 1000000 
set longchunksize 1000000 
set linesize 1000 
set pagesize 0 
set trim on 
set trimspool on 
set echo off 
set feedback off 
set serveroutput off   
set verify off 
  
spool "sql_monitor_&&1..html" 

select 
        dbms_sqltune.report_sql_monitor ( 
                        sql_id => (select max(sql_id) keep (dense_rank last order by last_active_time) as sql_id 
                                                from v$sql where upper(sql_text) like upper('%&&1%') 
                                                        and upper(sql_text) not like '%FROM V$SQL WHERE UPPER(SQL_TEXT) LIKE %' 
                                                ) 
                        , type => 'EM' 
                        , report_level => 'ALL +PLAN') as report_level 
from dual; 

spool off 
