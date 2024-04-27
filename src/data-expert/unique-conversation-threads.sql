/* https://dataexpert.io/question/unique-conversation-threads */

use memory.playground;

/* Sample data */
drop table if exists playground.messenger;
create table playground.messenger (
    sender_id   int,
    receiver_id int
);
insert into playground.messenger
values
    (1, 2),
    (1, 2),
    (2, 1),
    (4, 2),
    (3, 2),
    (2, 3),
    (1, 3),
    (1, 4),
    (1, 4),
    (4, 3)
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/*
This should absolutely definitely by "Medium", maybe even an "Easy".
*/

/* Solution */
select
    count(distinct concat_ws('-',
        cast(least(sender_id, receiver_id) as varchar),
        cast(greatest(sender_id, receiver_id) as varchar)
    )) as "count"
from playground.messenger
;
