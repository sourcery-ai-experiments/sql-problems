/* https://dataexpert.io/question/second-item-preferred-brand-match */

use memory.playground;

/* Sample data */
drop table if exists playground.users;
create table playground.users (
    user_id         int,
    join_date       date,
    preferred_brand varchar
);
insert into playground.users
values
    (1, cast('2023-01-01' as date), 'Puma'),
    (2, cast('2023-02-09' as date), 'Nike'),
    (3, cast('2023-01-19' as date), 'Fila'),
    (4, cast('2023-05-21' as date), 'Reebok')
;


drop table if exists playground.items;
create table playground.items (
    item_id    int,
    item_brand varchar
);
insert into playground.items
values
    (1, 'Nike'),
    (2, 'Puma'),
    (3, 'Reebok'),
    (4, 'Fila')
;


drop table if exists playground.orders;
create table playground.orders (
    order_id   int,
    order_date date,
    item_id    int,
    buyer_id   int,
    seller_id  int
);
insert into playground.orders
values
    (1, cast('2023-08-01' as date), 4, 1, 2),
    (2, cast('2023-08-02' as date), 2, 1, 3),
    (3, cast('2023-08-03' as date), 3, 2, 3),
    (4, cast('2023-08-04' as date), 1, 4, 2),
    (5, cast('2023-08-04' as date), 1, 3, 4),
    (6, cast('2023-08-05' as date), 2, 2, 4),
    (7, cast('2023-08-06' as date), 2, 2, 4)
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/* Definitely another "Medium" one */

/* Solution */
with

order_numbers as (
    select
        *,
        row_number() over (
            partition by seller_id
            order by order_date
        ) as order_number
    from playground.orders
),

second_orders as (
    select
        order_numbers.seller_id as user_id,
        items.item_brand
    from order_numbers
        left join playground.items
            using (item_id)
    where order_numbers.order_number = 2
)

select
    user_id as seller_id,
    if(users.preferred_brand = second_orders.item_brand, 'yes', 'no') as has_pref_brand
from playground.users
    left join second_orders
        using (user_id)
order by seller_id
;
