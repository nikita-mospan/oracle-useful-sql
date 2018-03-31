select * 
  from ( select /*+ FIRST_ROWS(n) */ 
        a.*, ROWNUM rnum 
      from ( your_query_goes_here, 
      with order by ) a 
      where ROWNUM <= :MAX_ROW_TO_FETCH ) 
where rnum  >= :MIN_ROW_TO_FETCH;