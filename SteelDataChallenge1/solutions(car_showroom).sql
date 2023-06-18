-- 1.What are the details of all cars purchased in the year 2022? 
select s.sale_id,s.purchase_date,make,type,style,cost_$ from cars c 
inner join sales s on s.car_id=c.car_id
where year(s.purchase_date)=2022;
-- 2.What is the total number of cars sold by each salesperson? 
select sp.name,count(s.sale_id)"Total cars sold" from salespersons sp 
inner join sales s on s.salesman_id=sp.salesman_id
group by sp.name;
-- 3.What is the total revenue generated by each salesperson? 
select sp.name,sum(c.cost_$) as total_revenue_generated from cars c 
join sales s on c.car_id=s.Sale_id
inner join salespersons sp on s.salesman_id=sp.salesman_id
group by sp.name;
-- 4.What are the details of the cars sold by each salesperson? 
select sp.name,s.sale_id,s.purchase_date,make,type,style,cost_$ from cars c 
join sales s on c.car_id=s.car_id
inner join salespersons sp on s.salesman_id=sp.salesman_id;
-- 5.What is the total revenue generated by each car type? 
select type,sum(cost_$) as "total_revenue_generated" from cars c 
join sales s on c.car_id=s.car_id
group by type
order by total_revenue_generated desc;
-- 6. What are the details of the cars sold in the year 2021 by salesperson 'Emily Wong'? 
select s.sale_id,s.purchase_date,make,type,style,cost_$ from cars c 
join sales s on c.car_id=s.car_id
inner join salespersons sp on s.salesman_id=sp.salesman_id
where sp.name='Emily Wong'and year(purchase_date)=2021;
-- 7.What is the total revenue generated by the sales of hatchback cars? 
select style,sum(cost_$) as "total_revenue_generated" from cars c 
join sales s on c.car_id=s.car_id
where style like"hatchback"
group by style;
-- 8.What is the total revenue generated by the sales of SUV cars in the year 2022? 
select style,sum(cost_$) as "total_revenue_generated" from cars c 
join sales s on c.car_id=s.car_id
where style like"SUV" and year(s.purchase_date)=2022
group by style;
-- 9.What is the name and city of the salesperson who sold the most number of cars in the year 2023? 
with car_counts as(
select s.salesman_id,count(s.sale_id) car_count from
sales s 
where year(purchase_date)=2023
group by s.salesman_id
)
select sp.salesman_id,sp.name,sp.city 
from salespersons sp
inner join car_counts cc on cc.salesman_id=sp.salesman_id
where cc.car_count=(select max(car_count) from car_counts);
-- 10. What is the name and age of the salesperson who generated the highest revenue in the year 2022? 
with revenues as(
select s.salesman_id,sum(c.cost_$) revenue from
sales s 
join cars c on
s.car_id=c.car_id
where year(s.purchase_date)=2022
group by s.salesman_id
)
select sp.salesman_id,sp.name,sp.city 
from salespersons sp
inner join revenues r on r.salesman_id=sp.salesman_id
where r.revenue=(select max(revenue) from revenues)
