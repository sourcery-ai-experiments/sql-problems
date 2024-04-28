/* https://datalemur.com/questions/yoy-growth-rate */

/* Sample data */
create table user_transactions (
    transaction_id   integer,
    product_id       integer,
    spend            decimal,
    transaction_date timestamp
);
truncate table user_transactions;
insert into user_transactions
values
    (1341, 123424, 1500.60, '2019-12-31 12:00:00'),
    (1423, 123424, 1000.20, '2020-12-31 12:00:00'),
    (1623, 123424, 1246.44, '2021-12-31 12:00:00'),
    (1322, 123424, 2145.32, '2022-12-31 12:00:00')
;


/* Sample output */
values
    /* year, product_id, curr_year_spend, prev_year_spend, yoy_rate */
    (2019, 123424, 1500.60, null, null),
    (2020, 123424, 1000.20, 1500.60, -33.35),
    (2021, 123424, 1246.44, 1000.20, 24.62),
    (2022, 123424, 2145.32, 1246.44, 72.12)
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/* Solution */
with prev_spend as (
    select
        extract('year' from transaction_date) as year,
        product_id,
        spend as curr_year_spend,
        lag(spend) over (
            partition by product_id
            order by transaction_date
        ) as prev_year_spend
    from user_transactions
)

select
    year,
    product_id,
    curr_year_spend,
    prev_year_spend,
    round((100 * curr_year_spend / prev_year_spend) - 100, 2) as yoy_rate
from prev_spend
order by product_id, year
;
