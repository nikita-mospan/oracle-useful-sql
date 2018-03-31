select regexp_substr(:test_str,'[^\' || :delim || ']+', 1, level) as parsed_strings
from dual
connect by level <= REGEXP_COUNT(:test_str, '\' || :delim)  + 1;
		
