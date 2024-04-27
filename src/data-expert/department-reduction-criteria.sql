/* https://dataexpert.io/question/department-reduction-criteria */

use memory.playground;

/* Sample data */
drop table if exists playground.dept;
create table playground.dept (
    id   int,
    name varchar
);
insert into playground.dept
values
    (1, 'IT'),
    (2, 'HR'),
    (3, 'Sales')
;

drop table if exists playground.emp;
create table playground.emp (
    id         int,
    full_name  varchar,
    salary     int,
    department int
);
insert into playground.emp
values
    (1, 'James Smith', 20, 1),
    (2, 'John Johnson', 13, 1),
    (3, 'Robert Jones', 15, 1),
    (4, 'Michael Williams', 15, 1),
    (5, 'Mary Troppins', 17, 1),
    (8, 'Penny Old', 14, 2),
    (9, 'Richard Young', 17, 2),
    (10, 'Drew Rich', 50, 3)
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/* Solution */
with

no_more_than_five_employees as (
    select
        department,
        count(*) as emp_number,
        sum(salary) as total_salary
    from playground.emp
    group by department
    having count(*) <= 5
),

ordered_departments as (
    select *, row_number() over salary_volume_id as dept_order
    from no_more_than_five_employees
    window salary_volume_id as (
        order by
            total_salary desc,
            emp_number desc,
            department
    )
)

select
    dept.name as dep_name,
    ordered_departments.emp_number,
    ordered_departments.total_salary
from ordered_departments
    left join playground.dept
        on ordered_departments.department = dept.id
where ordered_departments.dept_order % 2 != 0
order by ordered_departments.dept_order
;
