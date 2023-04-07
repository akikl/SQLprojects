/*7.	Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month. This analysis helps to get an idea of low and high-performing months and take strategic decisions.
The final report contains these columns:
Month 
Year
Gross sales Amount*/

select s.date,s.fiscal_year,round(sum((g.gross_price*s.sold_quantity)),2)as gross_sales_amount
from fact_sales_monthly s
join 
fact_gross_price g
on s.product_code=g.product_code
and
s.fiscal_year=g.fiscal_year
join 
dim_customer c
on c.customer_code=s.customer_code
where customer like "Atliq Exclusive"
group by s.date,s.fiscal_year