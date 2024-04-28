/* https://datalemur.com/questions/pizzas-topping-cost */

/* Sample data */
create table pizza_toppings (
    topping_name    varchar(255),
    ingredient_cost decimal(10, 2)
);
truncate table pizza_toppings;
insert into pizza_toppings
values
    ('Pepperoni', 0.50),
    ('Sausage', 0.70),
    ('Chicken', 0.55),
    ('Extra Cheese', 0.40)
;


/* Sample output */
values
    /* pizza, total_cost */
    ('Chicken,Pepperoni,Sausage', 1.75),
    ('Chicken,Extra Cheese,Sausage', 1.65),
    ('Extra Cheese,Pepperoni,Sausage', 1.60),
    ('Chicken,Extra Cheese,Pepperoni', 1.45)
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/* Solution */
select
    concat_ws(',',
        topping_1.topping_name,
        topping_2.topping_name,
        topping_3.topping_name
    ) as pizza,
    (0
        + topping_1.ingredient_cost
        + topping_2.ingredient_cost
        + topping_3.ingredient_cost
    ) as total_cost
from pizza_toppings as topping_1
    inner join pizza_toppings as topping_2
        on topping_1.topping_name < topping_2.topping_name
    inner join pizza_toppings as topping_3
        on topping_2.topping_name < topping_3.topping_name
order by
    total_cost desc,
    pizza
;
