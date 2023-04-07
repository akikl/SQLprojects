/*5.Get the products that have the highest and lowest manufacturing costs. The final output should contain these fields,
product_code product manufacturing_cost*/

select f.product_code,product,manufacturing_cost
from fact_manufacturing_cost f
join dim_product p
on f.product_code=p.product_code
where f.manufacturing_cost in((select max(manufacturing_cost) from fact_manufacturing_cost),
(select min(manufacturing_cost) from fact_manufacturing_cost))
