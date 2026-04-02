/*
  How many census block groups does Penn's main campus fully contain?

  I use the phl.pwd_parcels dataset to define Penn's campus by filtering parcels
  where the owner name contains 'UNIVERSITY OF PENNSYLVANIA', then dissolving
  them into a single campus boundary using ST_Union.
*/

with penn_campus as (
    select
        st_union(geog::geometry)::geography as campus_geog
    from phl.pwd_parcels
    where upper(owner1) like '%UNIVERSITY OF PENNSYLVANIA%'
)

select
    count(*)::integer as count_block_groups
from census.blockgroups_2020 as bg, penn_campus
where st_within(bg.geog::geometry, penn_campus.campus_geog::geometry)
