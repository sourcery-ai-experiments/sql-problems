/* https://dataexpert.io/question/optimal-gift-packaging */

use memory.playground;

/* Sample data */
drop table if exists playground.gifts;
create table playground.gifts (
    id        int,
    gift_name varchar,
    length    int,
    width     int,
    height    int
);
insert into playground.gifts
values
    (1, 'Water gun', 3, 1, 1),
    (2, 'Video game', 1, 1, 1),
    (3, 'Toy car', 4, 2, 2),
    (4, 'Toy car', 4, 2, 2),
    (5, 'Toy gun', 2, 1, 1)
;

drop table if exists playground.packages;
create table playground.packages (
    package_type varchar,
    length       int,
    width        int,
    height       int
);
insert into playground.packages
values
    ('small', 1, 1, 1),
    ('medium', 2, 2, 2),
    ('special', 4, 3, 1),
    ('big', 4, 4, 4),
    ('extra', 5, 5, 5),
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/*
Would like to use an ASOF join or a lateral join with a limit, but alas,
they're not in Trino 😭
*/

/* Solution */
with package_preferences as (
    select
        gifts.id,
        packages.package_type,
        row_number() over gift_package_sizes as package_preference
    from playground.gifts
        left join playground.packages
            on  gifts.length <= packages.length
            and gifts.width <= packages.width
            and gifts.height <= packages.height
    window gift_package_sizes as (
        partition by gifts.id
        order by (packages.length * packages.width * packages.height)
    )
)

select
    package_type,
    count(*) as number
from package_preferences
where package_preference = 1
group by package_type
order by package_type
;
