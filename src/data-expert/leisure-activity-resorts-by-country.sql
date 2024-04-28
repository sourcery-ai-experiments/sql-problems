/* https://dataexpert.io/question/leisure-activity-resorts-by-country */

use memory.playground;

/* Sample data */
drop table if exists playground.country_activities;
create table playground.country_activities (
    id                    int,
    country               varchar,
    region                varchar,
    leisure_activity_type varchar,
    number_of_places      int
);
insert into playground.country_activities
values
    (1, 'France', 'Normandy', 'River cruise', 2),
    (2, 'Germany', 'Bavaria', 'Golf', 5),
    (3, 'Germany', 'Berlin', 'Adventure park', 2),
    (4, 'France', 'Ile-de-France', 'River cruise', 1),
    (5, 'Sweden', 'Stockholm', 'River cruise', 3),
    (6, 'France', 'Normandy', 'Kart racing', 4)
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/*
This should absolutely definitely by "Medium", at most.

Since we need a default value of 0 instead of NULL, using SUM and IF is
easier than using the FILTER clause.
*/

/* Solution */
select
    country,
    sum(if(leisure_activity_type = 'Adventure park', number_of_places, 0)) as adventure_park,
    sum(if(leisure_activity_type = 'Golf',           number_of_places, 0)) as golf,
    sum(if(leisure_activity_type = 'River cruise',   number_of_places, 0)) as river_cruise,
    sum(if(leisure_activity_type = 'Kart racing',    number_of_places, 0)) as kart_racing
from playground.country_activities
group by country
order by country
;
