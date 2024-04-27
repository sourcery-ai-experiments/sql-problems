/* https://datalemur.com/questions/median-search-freq */

/* Sample data */
create table search_frequency (
    searches  integer,
    num_users integer
);
truncate table search_frequency;
insert into search_frequency
values
    (1, 2),
    (2, 2),
    (3, 3),
    (4, 1)
;


/* Sample output */
select 2.5 as median
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/*
Given an ordered series X of size n, the formula for the median is:

    X[(n + 1)/2]                 if n is odd
    (X[n/2] + X[(n/2) + 1])/2    if n is even

This solution purposefully doesn't expand out the underlying table into
a row per search. Isn't the point of this summary table that we _don't_
want to work with a table containing trillions of rows?
*/

/* Solution */
with

sizes as (
    select
        searches,
        num_users,
        sum(num_users) over (order by searches) as x,
        sum(num_users) over () as n
    from search_frequency
),

indexes as (
    select
        searches,
        num_users,
        1 + lag(x, 1, 0) over (order by searches) as x_low,
        x as x_high,
        case when mod(n, 2) != 0 then (n + 1)/2 else n/2       end as index_1,
        case when mod(n, 2) != 0 then null      else (n/2) + 1 end as index_2
    from sizes
)

select round(avg(searches), 1) as median
from indexes
where 0=1
    or index_1 between x_low and x_high
    or index_2 between x_low and x_high
;
