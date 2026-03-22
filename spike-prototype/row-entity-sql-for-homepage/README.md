# Team 1 - sEARCH CMS/API

# Spike prototype for the SQL for getting a row for the home page table

To run, 
- move row-entity-SQL-spike-prototype.sql to /backend/supabase/snippets
- launch the backend using docker compose up -d
- go to the supabase dashboard SQL editor (http://127.0.0.1:54323/project/default/sql/732d4376-cec8-41e5-99a7-dcfae3770362)
- select row-entity-SQL-spike-prototype and click run


What I learned
- that I had the ON keyword in the wrong spot originally
-  I needed to get rid of WHERE unless I want to filter the output
- if multiple tables have a column with the same name, only the last one mentioned in SELECT will show up unless you specify a new name for the ones that conflict
- the output will be in the order listed in the select

