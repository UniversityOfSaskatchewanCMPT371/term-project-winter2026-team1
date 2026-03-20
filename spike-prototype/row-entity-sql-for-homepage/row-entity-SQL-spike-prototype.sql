--  I learned 
-- - that I had the ON keyword in the wrong spot
-- -  I needed to get rid of WHERE unless I want to filter it
-- - if multiple tables have a column with the same name, only the last one mentioned in SELECT will show up unless you specify a new name for the ones that conflict
-- - the output will be in the order listed in the select

SELECT
site.borden, site.name AS site_name,
unit.name AS unit_name,
level.name AS level_name, level.up_limit, level.low_limit

FROM site

LEFT JOIN unit
ON site.id = unit.site_id

LEFT JOIN level
ON unit.id = level.unit_id
