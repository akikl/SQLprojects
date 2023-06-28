-- 1.	Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.
select distinct market from dim_customer where customer like "Atliq Exclusive" 
and region like 'APAC';

/*What is the percentage of unique product increase in 2021 vs. 2020? The final output contains these fields,
unique_products_2020 unique_products_2021 percentage_chg*/
with cte_2020 as
( 
select count(distinct(product_code)) as unique_products_2020
from fact_sales_monthly 
where fiscal_year =2020),
cte_2021 as
(select count(distinct(product_code))as unique_products_2021
from fact_sales_monthly 
where fiscal_year =2021
)
select *, round(((unique_products_2021-unique_products_2020)/unique_products_2020) *100 ,2) as percentage
from cte_2020,cte_2021;

/* 3.Provide a report with all the unique product counts for each segment and sort them in descending order of product counts. 
The final output contains 2 fields,
segment product_count */
select segment,count(distinct(product_code)) as product_count
from dim_product
group by segment
order by product_count desc;

/* 4.Which segment had the most increase in unique products in 2021 vs 2020? The final output contains these fields,
segment product_count_2020 product_count_2021 difference
*/
with seg_2020 as(
select p.segment,count(distinct(p.product_code)) as product_count_2020
from fact_sales_monthly s
join dim_product p
on s.product_code=p.product_code
where fiscal_year=2020
group by p.segment),
seg_2021 as
(
select p.segment,count(distinct(p.product_code)) as product_count_2021
from fact_sales_monthly s
join dim_product p
on s.product_code=p.product_code
where fiscal_year=2021
group by p.segment
)
select seg_2020.segment,product_count_2020,product_count_2021,product_count_2021-product_count_2020 as difference
from seg_2020 
join seg_2021
on seg_2020.segment=seg_2021.segment;

/*5.Get the products that have the highest and lowest manufacturing costs. The final output should contain these fields,
product_code product manufacturing_cost*/

select f.product_code,product,manufacturing_cost
from fact_manufacturing_cost f
join dim_product p
on f.product_code=p.product_code
where f.manufacturing_cost in((select max(manufacturing_cost) from fact_manufacturing_cost),
(select min(manufacturing_cost) from fact_manufacturing_cost));

/*6.Generate a report which contains the top 5 customers who received an 
average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market. The final output contains these fields,
customer_code customer
average_discount_percentage*/
select d.customer_code,c.customer,
round(avg(pre_invoice_discount_pct),2) as average_discount_percentage
from fact_pre_invoice_deductions d
join dim_customer c
on c.customer_code=d.customer_code
where fiscal_year=2021 and market="India"
group by d.customer_code,c.customer
order by average_discount_percentage desc
limit 5;


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
group by s.date,s.fiscal_year;

/*8.	In which quarter of 2020, got the maximum total_sold_quantity? The final output contains these fields sorted by the total_sold_quantity,
Quarter total_sold_quantity
*/
with cte2 as(
select sold_quantity,fiscal_year,case
when month(date) in (9,10,11) then 'Q1'
when month(date) in(12,1,2) then 'Q2'
when month(date) in (3,4,5) then 'Q3'
else 'Q4'
end as Quarter
from fact_sales_monthly)
select Quarter,sum(sold_quantity) as total_sold_quantity
from cte2
where fiscal_year=2020
group by Quarter
order by total_sold_quantity desc;
/* 9.Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution? The final output contains these fields,
channel gross_sales_mln percentage */
with cte_1 as(select c.channel,sum(round((g.gross_price*s.sold_quantity)/1000000,2)) as gross_sales_mln
from fact_sales_monthly s 
join fact_gross_price g 
on s.fiscal_year=g.fiscal_year
and s.product_code=g.product_code
join dim_customer c 
on s.customer_code=c.customer_code
where s.fiscal_year=2021
group by c.channel)
select *,
round(gross_sales_mln*100/sum(gross_sales_mln) over(),2) as percentage
from cte_1
order by percentage desc
limit 1;

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
