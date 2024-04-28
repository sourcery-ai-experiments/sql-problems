/* https://dataexpert.io/question/commonly-bought-product-pairs */

use memory.playground;

/* Sample data */
drop table if exists playground.product_transactions;
create table playground.product_transactions (
    transaction_id int,
    product_name   varchar
);
insert into playground.product_transactions
values
    (1, 'Pencil'),
    (1, 'Sharpner'),
    (1, 'Pen'),
    (2, 'Pencil'),
    (2, 'Sharpner'),
    (2, 'Eraser'),
    (3, 'Pencil'),
    (3, 'Pen'),
    (3, 'Textbook'),
    (4, 'Sharpner')
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/* Solution */
with

transaction_pairs as (
    select
        t1.transaction_id,
        t1.product_name as product1,
        t2.product_name as product2
    from playground.product_transactions as t1
        inner join playground.product_transactions as t2
            on  t1.transaction_id = t2.transaction_id
            and t1.product_name < t2.product_name
),

product_ranks as (
    select
        product1,
        product2,
        count(*) as freq,
        rank() over (order by count(*) desc) as product_rank
    from transaction_pairs
    group by product1, product2
)

select
    product1,
    product2,
    freq
from product_ranks
where product_rank <= 3
order by
    product1,
    product2,
    freq
;
