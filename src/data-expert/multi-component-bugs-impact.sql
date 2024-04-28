/* https://dataexpert.io/question/multi-component-bugs-impact */

use memory.playground;

/* Sample data */
drop table if exists playground.bug;
create table playground.bug (
    num   int,
    title varchar
);
insert into playground.bug
values
    (1, 'Quotes don''t work'),
    (2, 'Highlighting looks weird'),
    (3, 'Posts are not automatically updated'),
    (4, 'Author link doesn''t work')
;


drop table if exists playground.component;
create table playground.component (
    id    int,
    title varchar
);
insert into playground.component
values
    (1, 'Forum'),
    (2, 'Code editor')
;


drop table if exists playground.bug_component;
create table playground.bug_component (
    bug_num      int,
    component_id int
);
insert into playground.bug_component
values
    (1, 1),
    (2, 1),
    (2, 2),
    (3, 1),
    (4, 2),
    (4, 1)
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/*
Apparently this is wrong, but I'm not sure why...?
*/

/* Solution */
with

bug_components as (
    select
        bug_component.bug_num,
        bug_component.component_id,
        bug.title as bug_title,
        component.title as component_title
    from playground.bug_component
        left join playground.bug
            on bug_component.bug_num = bug.num
        left join playground.component
            on bug_component.component_id = component.id
),

bugs_aggregated as (
    select
        bug_title,
        component_title,
        count(*) as bugs_in_component,
        count(*) over (partition by bug_title) as impacted_components
    from bug_components
    group by bug_title, component_title
)

select
    bug_title,
    component_title,
    bugs_in_component
from bugs_aggregated
where impacted_components > 1
order by bugs_in_component desc, bug_title
;
