/* https://dataexpert.io/question/countries-drink-preferences */

use memory.playground;

/* Sample data */
drop table if exists playground.drinks;
create table playground.drinks (
    country                      varchar,
    beer_servings                int,
    spirit_servings              int,
    wine_servings                int,
    total_litres_of_pure_alcohol double
);
insert into playground.drinks
values
    ('Afghanistan', 0, 0, 0, 0),
    ('Albania', 89, 132, 54, 4.9),
    ('Algeria', 25, 0, 14, 0.7),
    ('Andorra', 245, 138, 312, 12.4),
    ('Angola', 217, 57, 45, 5.9),
    ('Antigua & Barbuda', 102, 128, 45, 4.9),
    ('Argentina', 193, 25, 221, 8.3),
    ('Armenia', 21, 179, 11, 3.8),
    ('Australia', 261, 72, 212, 10.4),
    ('Austria', 279, 75, 191, 9.7)
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/* This should absolutely definitely by "Medium", at most */

/* Solution */
with preferences as (
    select
        country,
        case
            when beer_servings = greatest(beer_servings, spirit_servings, wine_servings)
                then 'Beer'
            when spirit_servings = greatest(beer_servings, spirit_servings, wine_servings)
                then 'Spirit'
                else 'Wine'
        end as preferred_drink
    from playground.drinks
)

select *
from preferences
where preferred_drink != 'Beer'
order by country
;
