<div align="center">

[![Python](https://img.shields.io/badge/Python-3.11+-blue.svg)](https://www.python.org/downloads/release/python-3110/)
[![Poetry](https://img.shields.io/endpoint?url=https://python-poetry.org/badge/v0.json)](https://python-poetry.org/)
![GitHub last commit](https://img.shields.io/github/last-commit/Bilbottom/sql-problems)

[![code style: prettier](https://img.shields.io/badge/code_style-prettier-ff69b4.svg?style=flat-square)](https://github.com/prettier/prettier)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/Bilbottom/sql-problems/main.svg)](https://results.pre-commit.ci/latest/github/Bilbottom/sql-problems/main)

</div>

---

# SQL Problems

Solutions to SQL problems.

I've only bother solving the hardest (free) problems, and I'll add some notes on what I thought of the platform below.

> [!WARNING]
>
> This repository will contain spoilers for the problems. If you want to solve them yourself, do not look at the solutions.

> [!NOTE]
>
> Some notes on terms/phrases I use here:
>
> - "_Recommended solution_" means a solution provided by the platform itself.
> - "_Community solution_" means a solution provided by the community.

---

## Data Lemur

> [!NOTE]
>
> The problems are available at:
>
> - https://datalemur.com/
>
> The platform uses PostgreSQL only (version 14.11 at the time of writing).

### Pros ✔️

The problems do get you to think and use some not-so-common logic, which is good!

The problem statements have sample data and expected results, which is great for testing your solutions -- feels a lot like LeetCode/TDD 😉

The platform is easy to use, has a fast response time, and the discussion tab has some good alternative community solutions.

The solutions tab sometimes provides alternative approaches too -- one even showed off a recursive CTE!

### Cons ❌

Some of the recommended solutions could be better:

- There are some database features that the solutions could use to make the queries more concise and readable.
- The recommended solution for the [updated-status](src/data-lemur/updated-status.sql) problem wraps all the business logic into a case statement. This is bad practice given that the solution could have used a lookup table<sup>\*</sup>, which is what SQL is all about!
- I frankly disagree with the approach for one solution ([median-search-freq](src/data-lemur/median-search-freq.sql)).

<sup>\*</sup>The DataLemur platform wasn't accepting several variant of the `VALUES` clause even though it was valid SQL. This feels like a bug in the platform.

I'm not sure about the premium hard questions, but based on the free ones, the problems are only moderately difficult -- I have to solve harder problems on a daily basis as an analytics engineer, so I don't think these are great preparation for a senior technical role.

## Lost at SQL

> [!NOTE]
>
> https://lost-at-sql.therobinlord.com/
