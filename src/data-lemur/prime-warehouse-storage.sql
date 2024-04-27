/* https://datalemur.com/questions/prime-warehouse-storage */

/* Sample data */
create table inventory (
    item_id        integer,
    item_type      varchar,
    item_category  varchar,
    square_footage decimal
);
truncate table inventory;
insert into inventory
values
    (1374, 'prime_eligible', 'mini refrigerator', 68.00),
    (4245, 'not_prime', 'standing lamp', 26.40),
    (2452, 'prime_eligible', 'television', 85.00),
    (3255, 'not_prime', 'side table', 22.60),
    (1672, 'prime_eligible', 'laptop', 8.50)
;


/* Sample output */
values
    /* item_type, item_count */
    ('prime_eligible', 9285),
    ('not_prime', 6)
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/* Solution */
with

footage as (
    select
        item_type,
        count(*) as item_count,
        sum(square_footage) as total_footage,
        500000 as warehouse_size
    from inventory
    group by item_type
),

calc as (
    select
        footage.item_type,
        footage.item_count,
        prime.prime_batches,
        div(
            footage.warehouse_size - (prime.prime_batches * prime.prime_footage),
            footage.total_footage
        ) as not_prime_batches
    from footage
        cross join (
            select total_footage, div(warehouse_size, total_footage)
            from footage
            where item_type = 'prime_eligible'
        ) as prime(prime_footage, prime_batches)
)

select
    item_type,
    item_count * case item_type
        when 'prime_eligible' then prime_batches
        when 'not_prime' then not_prime_batches
    end as item_count
from calc
order by item_type desc
;
