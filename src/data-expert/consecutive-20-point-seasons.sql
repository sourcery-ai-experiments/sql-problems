/* https://dataexpert.io/question/consecutive-20-point-seasons */

use memory.playground;

/* Sample data */
drop table if exists playground.nba_player_seasons;
create table playground.nba_player_seasons (
    player_name  varchar,
    age          int,
    height       varchar,
    weight       int,
    college      varchar,
    country      varchar,
    draft_year   varchar,
    draft_round  varchar,
    draft_number varchar,
    gp           double,
    pts          double,
    reb          double,
    ast          double,
    netrtg       double,
    oreb_pct     double,
    dreb_pct     double,
    usg_pct      double,
    ts_pct       double,
    ast_pct      double,
    season       int
);
insert into playground.nba_player_seasons
values
    ('A.C. Green',            33, '6-9',  225, 'Oregon State', 'USA',    '1985',      '1',         '23',        83, 7.2,  7.9, 0.8, -7.4, 8.9,  8.9,  18.4, 11.8, 4.5,  1996),
    ('Aaron McKie',           24, '6-5',  209, 'Temple',       'USA',    '1994',      '1',         '17',        83, 5.2,  2.7, 1.9, 3.7,  2.6,  2.6,  11.3, 14.2, 16.3, 1996),
    ('Aaron Williams',        25, '6-9',  225, 'Xavier',       'USA',    'Undrafted', 'Undrafted', 'Undrafted', 33, 6.2,  4.3, 0.5, -9.3, 11.3, 11.3, 14.4, 16.1, 5.1,  1996),
    ('Acie Earl',             27, '6-11', 240, 'Iowa',         'USA',    '1993',      '1',         '19',        47, 4,    2,   0.4, -6.4, 6.7,  6.7,  12.2, 22,   7.7,  1996),
    ('Adam Keefe',            27, '6-9',  241, 'Stanford',     'USA',    '1992',      '1',         '10',        62, 3.8,  3.5, 0.5, 7.2,  9.6,  9.6,  15.8, 12.4, 5.1,  1996),
    ('Adrian Caldwell',       30, '6-8',  265, 'Lamar',        'USA',    'Undrafted', 'Undrafted', 'Undrafted', 45, 2.2,  3.7, 0.3, -6.5, 9.4,  9.4,  18,   10.2, 3,    1996),
    ('Alan Henderson',        24, '6-9',  235, 'Indiana',      'USA',    '1995',      '1',         '16',        30, 6.6,  3.9, 0.8, -7.5, 9.6,  9.6,  16,   19.7, 7.8,  1996),
    ('Aleksandar Djordjevic', 29, '6-2',  198, 'None',         'Serbia', 'Undrafted', 'Undrafted', 'Undrafted', 8,  3.1,  0.6, 0.6, 5.1,  1.7,  1.7,  6.3,  16.8, 13.5, 1996),
    ('Allan Houston',         26, '6-6',  200, 'Tennessee',    'USA',    '1993',      '1',         '11',        81, 14.8, 3,   2.2, 2,    1.8,  1.8,  7.5,  21.8, 11.7, 1996),
    ('Allen Iverson',         22, '6-0',  165, 'Georgetown',   'USA',    '1996',      '1',         '1',         76, 23.5, 4.1, 7.5, -7.1, 3.5,  3.5,  6.4,  28.1, 32,   1996),
    ('Allen Iverson',         22, '6-0',  165, 'Georgetown',   'USA',    '1996',      '1',         '1',         76, 23.5, 4.1, 7.5, -7.1, 3.5,  3.5,  6.4,  28.1, 32,   1997),
    ('Allen Iverson',         22, '6-0',  165, 'Georgetown',   'USA',    '1996',      '1',         '1',         76, 13.5, 4.1, 7.5, -7.1, 3.5,  3.5,  6.4,  28.1, 32,   1998),
    ('Allen Iverson',         22, '6-0',  165, 'Georgetown',   'USA',    '1996',      '1',         '1',         76, 23.5, 4.1, 7.5, -7.1, 3.5,  3.5,  6.4,  28.1, 32,   1999),
    ('Allen Iverson',         22, '6-0',  165, 'Georgetown',   'USA',    '1996',      '1',         '1',         76, 23.5, 4.1, 7.5, -7.1, 3.5,  3.5,  6.4,  28.1, 32,   2000)
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/*
Since this is measuring consecutive sequences, this is a "gaps and
islands" problem
*/

/* Solution */
with

flags as (
    select
        player_name,
        season,
        pts >= 20 as twenty_point_season,
        /* Put the player and twenty-point-season rows into groups */
        row_number() over player_by_season - row_number() over player_by_twenty_point_season as consecutive_season_group
    from playground.nba_player_seasons
    window
        player_by_season as (
            partition by player_name
            order by season
        ),
        player_by_twenty_point_season as (
            partition by player_name, pts >= 20
            order by season
        )
),

consecutive_seasons as (
    select
        player_name,
        consecutive_season_group,
        count(*) as consecutive_seasons,
        rank() over (order by count(*) desc) as ranking
    from flags
    where twenty_point_season
    group by player_name, consecutive_season_group
)

select
    player_name,
    consecutive_seasons
from consecutive_seasons
where ranking <= 10
order by consecutive_seasons desc, player_name
;
