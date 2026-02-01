

-- from snippets of what I've read, pgTAP has a bunch of assertions we can use  
-- was using this site to produce and learn pgTAP https://supabase.com/docs/guides/database/extensions/pgtap?queryGroups=database-method&database-method=dashboard#testing-tables

-- this site has more commands and details https://pgtap.org/documentation.html#potentialissues



begin; --begins a transaction, which I think is important for concurrency

select plan(5); -- says how many tests it will run
select has_table( 'NotMadeTable' ); --checks if a table was made, should fail because the table hasn't been made
select has_table( 'counters');


select has_column('counters', 'owner_id'); --does table counters have a column called id
select col_is_pk('counters', 'id'); --checks if id is the primary key (unique identifier for the row) in the counters table

INSERT into counters (id, count, owner_id) VALUES ('someID', 2, 'owners id'); --inserting a row (entry) into the database so I have something to test (each column) values (the colums' corrosponding values)

select results_eq('SELECT id, count, owner_id FROM counters WHERE id = ''someID'' ', $$VALUES ('someID', 2, 'owners id') $$, 'someMessage'); --this was painful, is is checking that thing, = thing and it has to match exactly, the timestamp was giving me trouble for the datatype or the syntax, so I just excluded it by specifying in the select to grab the id, count, and owner_id column from table counters, since there was some other entry in the table, I specified to grab the rows where id = 'someID', that way it is only the row I added right before. Apparently the $$ something $$ is like doing quotes so you can use '' inside it ?? (also it wasn't playing nice when I tried using "" inside '' for some reason),

-- there is also select results_ne() which is the not equals equivalent

select * from finish(); --from what I saw, when deleted, the error messagese were more specific, but they didn't could how many tests failed vs passed.


rollback; --undoes the actions in the transaction so the test doesn't affect the database



