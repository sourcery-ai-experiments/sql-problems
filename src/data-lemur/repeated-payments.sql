/* https://datalemur.com/questions/repeated-payments */

/* Sample data */
create table transactions (
    transaction_id        integer,
    merchant_id           integer,
    credit_card_id        integer,
    amount                integer,
    transaction_timestamp timestamp
);
truncate table transactions;
insert into transactions
values
    (1, 101, 1, 100, '2022-09-25 12:00:00'),
    (2, 101, 1, 100, '2022-09-25 12:08:00'),
    (3, 101, 1, 100, '2022-09-25 12:28:00'),
    (4, 102, 2, 300, '2022-09-25 12:00:00'),
    (6, 102, 2, 400, '2022-09-25 14:00:00')
;


/* Sample output */
select 1 as payment_count
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/* Solution */
with repeated_payments as (
    select count(*) over last_ten_minutes as repeated_transaction_count
    from transactions
    window last_ten_minutes as (
        partition by merchant_id, credit_card_id, amount
        order by transaction_timestamp
        range interval '10 minutes' preceding
    )
)

select count(*) as payment_count
from repeated_payments
where repeated_transaction_count > 1
;
