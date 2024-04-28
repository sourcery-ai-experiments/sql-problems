/* https://www.analystbuilder.com/questions/temperature-fluctuations-ftFQu */

/* Sample data */
create table temperatures (
  date        date,
  temperature int
);
truncate table temperatures;
insert into temperatures
values
    ('2022-01-01', 65),
    ('2022-01-02', 70),
    ('2022-01-03', 55),
    ('2022-01-04', 58),
    ('2022-01-05', 90),
    ('2022-01-06', 88),
    ('2022-01-07', 76),
    ('2022-01-08', 82),
    ('2022-01-09', 88),
    ('2022-01-10', 72)
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/* Solution */
with temp_yesterday as (
    select
        *,
        lag(temperature) over (order by date) as temp_yeterday
    from temperatures
)

select date
from temp_yesterday
where temperature > temp_yeterday
order by date
;
