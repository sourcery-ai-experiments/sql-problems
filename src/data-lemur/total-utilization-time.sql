/* https://datalemur.com/questions/total-utilization-time */

/* Sample data */
create table server_utilization (
    server_id      integer,
    status_time    timestamp,
    session_status varchar
);
truncate table server_utilization;
insert into server_utilization
values
    (1, '2022-08-02 10:00:00', 'start'),
    (1, '2022-08-04 10:00:00', 'stop'),
    (2, '2022-08-17 10:00:00', 'start'),
    (2, '2022-08-24 10:00:00', 'stop')
;


/* Sample output */
select 21 as total_uptime_days  /* This doesn't seem right...? */
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/* Solution */
with server_duration as(
    select
        server_id,
        status_time as start_time,
        case when session_status = 'start'
            then lead(status_time, 1, current_date) over server_times
        end as stop_time
    from server_utilization
    window server_times as (
        partition by server_id
        order by status_time
    )
)

select sum(stop_time::date - start_time::date) as total_uptime_days
from server_duration
where start_time is not null
;
