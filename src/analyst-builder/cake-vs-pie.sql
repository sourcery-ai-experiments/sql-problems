/* https://www.analystbuilder.com/questions/cake-vs-pie-rSDbF */

/* Sample data */
create table desserts (
    date_sold   date,
    product     varchar,
    amount_sold int
);
truncate table desserts;
insert into desserts
values
    ('2022-06-01', 'Cake', 6),
    ('2022-06-01', 'Pie', 18),
    ('2022-06-02', 'Pie', 3),
    ('2022-06-02', 'Cake', 2),
    ('2022-06-03', 'Pie', 14),
    ('2022-06-03', 'Cake', 15),
    ('2022-06-04', 'Pie', 15),
    ('2022-06-04', 'Cake', 6),
    ('2022-06-05', 'Cake', 16),
    ('2022-06-05', 'Pie', NULL)
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/* Solution */
with daily_sales as (
    select
        coalesce(cake.date_sold, pie.date_sold) as date_sold,
        coalesce(cake.amount_sold, 0) as amount_sold__cake,
        coalesce(pie.amount_sold, 0) as amount_sold__pie
    from desserts as cake
        full join desserts as pie
            on  cake.date_sold = pie.date_sold
            and pie.product = 'Pie'
    where cake.product = 'Cake'
)

select
    date_sold,
    abs(amount_sold__cake - amount_sold__pie) as difference,
    case
        when amount_sold__cake = amount_sold__pie
            then 'Same'
        when amount_sold__cake > amount_sold__pie
            then 'Cake'
            else 'Pie'
    end as sold_more
from daily_sales
order by date_sold
;
