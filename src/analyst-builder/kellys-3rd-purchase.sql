/* https://www.analystbuilder.com/questions/kellys-3rd-purchase-kFaIE */

/* Sample data */
create table purchases (
    customer_id    int,
    transaction_id int,
    amount         int
);
truncate table purchases;
insert into purchases
values
    (1001, 339473, 89),
    (1002, 359433, 5),
    (1003, 43176, 52),
    (1004, 27169, 19),
    (1001, 530588, 4),
    (1004, 528902, 78),
    (1005, 584167, 72),
    (1003, 55479, 45),
    (1005, 500607, 98),
    (1004, 544617, 65),
    (1001, 374711, 94),
    (1002, 328456, 42),
    (1005, 412764, 43),
    (1001, 225602, 19),
    (1004, 642498, 55),
    (1002, 415562, 50),
    (1005, 272319, 78),
    (1001, 445346, 92),
    (1002, 458215, 30),
    (1004, 173711, 91),
    (1003, 102487, 39),
    (1005, 566617, 58)
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/* Solution */
with transactions as (
    select
        *,
        row_number() over (
            partition by customer_id
            order by transaction_id
        ) as transaction_number
    from purchases
)

select
    customer_id,
    transaction_id,
    amount,
    amount * 0.67 as discounted_amount
from transactions
where transaction_number = 3
order by customer_id
;
