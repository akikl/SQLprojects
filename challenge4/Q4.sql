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





