-- 1.	Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.
select distinct market from dim_customer where customer like "Atliq Exclusive" 
and region like 'APAC'