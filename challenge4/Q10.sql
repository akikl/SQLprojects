/*10.	Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021? 
The final output contains these fields,
division product_code
product total_sold_quantity rank_order
*/
with cte_3 as(
select  p.division,p.product_code,p.product,sum(s.sold_quantity) as total_sold_quantity,
rank() over(partition by p.division order by sum(s.sold_quantity) desc) as rank_order
from dim_product p 
join fact_sales_monthly s
on p.product_code=s.product_code
where fiscal_year =2021
group by p.division,p.product_code,p.product)
select * from cte_3 where rank_order<=3;