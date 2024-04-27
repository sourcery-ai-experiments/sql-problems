/* https://datalemur.com/questions/user-retention */

/* Sample data */
create table user_actions (
    user_id    integer,
    event_id   integer,
    event_type varchar,
    event_date timestamp
);
truncate table user_actions;
insert into user_actions
values
    (445, 7765, 'sign-in', '2022-05-31 12:00:00'),
    (742, 6458, 'sign-in', '2022-06-03 12:00:00'),
    (445, 3634, 'like', '2022-06-05 12:00:00'),
    (742, 1374, 'comment', '2022-06-05 12:00:00'),
    (648, 3124, 'like', '2022-06-18 12:00:00')
;


/* Sample output */
values
    /* month, monthly_active_users */
    (6, 1)
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/*
I'd rather use `to_char(event_date, 'yyyy-mm')` so that we have the year
_and_ month together, but the solution just asks for the month.
*/

/* Solution */
with

users_with_month as (
    select
        user_id,
        extract('month' from event_date) as month
    from user_actions
    -- where event_date between '2022-05-01' and '2022-06-30'
    where event_date between '2022-06-01' and '2022-07-31'
),

monthly_active_users as (
    select
        user_id,
        max(month) as month
    from users_with_month
    group by user_id
    having count(distinct month) >= 2
)

select
    month,
    count(distinct user_id) as monthly_active_users
from monthly_active_users
group by month
;
