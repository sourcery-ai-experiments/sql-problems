/* https://dataexpert.io/question/soccer-series-winner */

use memory.playground;

/* Sample data */
drop table if exists playground.scores;
create table playground.scores (
    match_id          int,
    first_team_score  int,
    second_team_score int,
    match_host        int
);
insert into playground.scores
values
    (1, 3, 2, 1),
    (2, 2, 1, 2),
    (3, 1, 2, 1),
    (4, 2, 1, 2)
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/* Solution */
with

team_details_per_match as (
        select
            match_id,
            match_host,
            1 as team_id,
            first_team_score as goals,
            second_team_score as conceded
        from playground.scores
    union
        select
            match_id,
            match_host,
            2 as team_id,
            second_team_score as goals,
            first_team_score as conceded
        from playground.scores
),

team_details as (
    select
        team_id,
        sum(if(goals > conceded, 1, 0)) as wins,
        sum(goals - conceded) as goal_difference,
        sum(if(match_host = team_id, 0, goals)) as away_goals
    from team_details_per_match
    group by team_id
),

ranking as (
    select *, rank() over winning_conditions as team_rank
    from team_details
    window winning_conditions as (
        order by
            wins desc,
            goal_difference desc,
            away_goals desc
    )
)

select coalesce(
    (
        select any_value(team_id)
        from ranking
        where team_rank = 1
        group by team_rank
        having count(*) = 1
    ),
    0
) as winner
;
