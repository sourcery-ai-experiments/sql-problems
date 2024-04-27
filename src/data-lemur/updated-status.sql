/* https://datalemur.com/questions/updated-status */

/* Sample data */
create table advertiser (
    user_id varchar,
    status  varchar
);
truncate table advertiser;
insert into advertiser
values
    ('bing', 'NEW'),
    ('yahoo', 'NEW'),
    ('alibaba', 'EXISTING')
;


create table daily_pay (
    user_id varchar,
    paid    decimal
);
truncate table daily_pay;
insert into daily_pay
values
    ('yahoo', 45.00),
    ('alibaba', 100.00),
    ('target', 13.00)
;


/* Sample output */
values
    /* user_id, new_status */
    ('bing', 'CHURN'),
    ('yahoo', 'EXISTING'),
    ('alibaba', 'EXISTING')
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/* DataLemur isn't allowing SEVERAL aspects of a typical VALUES syntax??? */

/* Solution */
with

statuses(status_id, current_status, updated_status, payment_status) as (
    values
        (1, 'NEW', 'EXISTING', 'Paid'),
        (2, 'NEW', 'CHURN', 'Not paid'),
        (3, 'EXISTING', 'EXISTING', 'Paid'),
        (4, 'EXISTING', 'CHURN', 'Not paid'),
        (5, 'CHURN', 'RESURRECT', 'Paid'),
        (6, 'CHURN', 'CHURN', 'Not paid'),
        (7, 'RESURRECT', 'EXISTING', 'Paid'),
        (8, 'RESURRECT', 'CHURN', 'Not paid')
),

have_paid as (
    select
        advertiser.user_id,
        advertiser.status as current_status,
        case when daily_pay.user_id is null
            then 'Not paid'
            else 'Paid'
        end as payment_status
    from advertiser
        left join daily_pay
            using (user_id)
)

select
    have_paid.user_id,
    statuses.updated_status
from have_paid
    left join statuses
        using (current_status, payment_status)
;
