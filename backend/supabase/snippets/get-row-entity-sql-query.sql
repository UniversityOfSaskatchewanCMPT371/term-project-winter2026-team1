
SELECT

site.borden, site.name AS site_name, --if multiple tables have the same column name such as "name" they will overwrite each other in the final table, AS just means to give it the new name in the output
area.name AS area_name,
unit.name AS unit_name,
level.name AS level_name, level.up_limit, level.low_limit,
assemblage.name AS assemblage_name,
artifact_faunal.porosity, artifact_faunal.size_upper, artifact_faunal.size_lower, 
artifact_faunal.pre_excav_frags, artifact_faunal.post_excav_frags, artifact_faunal.elements,
artifact_faunal.comment

FROM site

LEFT JOIN unit
ON site.id = unit.site_id

LEFT JOIN level
ON unit.id = level.unit_id

LEFT JOIN assemblage
ON level.id = assemblage.level_id

LEFT JOIN artifact_faunal
ON assemblage.id = artifact_faunal.assemblage_id


LEFT JOIN site_area
ON site.id = site_area.site_id

LEFT JOIN area
ON site_area.area_id = area.id

-- LEFT JOIN tableName
-- ON id in the source table = foreign key in the table mentioned in the JOIN

ORDER BY site.name, area.name, unit.name, level.name, assemblage.name