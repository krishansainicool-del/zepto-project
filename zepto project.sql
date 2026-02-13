DROP table if exists zepto;

create table zepto(sku_id serial primary key,
category varchar(120),name varchar(120) not null,
mrp numeric(8,2),discount_per numeric(5,2),
available_quantity int,
discounted_sell_price numeric(8,2),
weightinGms int,outofstock boolean,quantity int);


--Data exploration

--Count of rows
select count(*) from zepto;

--Sample data
select* from zepto limi 10;

--Null values
select* from zepto where name is null
or
category is null
or
mrp is null
or
discount_per is null
or
available_quantity is null
or
discounted_sell_price is null
or
weightinGms is null
or
outofstock is null
or
quantity is null;


--Different product category
select distinct category 
from zepto
order by category;

--Products in stock/out of stock
select outofstock, count(sku_id)
from zepto 
group by outofstock;

--Product name present multiple times
select name ,count(sku_id) as "no of sku's"
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) desc;

--Data cleaning

--product with price zero
select * from zepto 
where mrp=0 or discounted_sell_price=0;

delete from zepto
where mrp=0 and discounted_sell_price=0;

--Convert paise into Rs
Update zepto
set mrp=mrp/100.0,
discounted_sell_price=discounted_sell_price/100.0;

Select mrp,discounted_sell_price from zepto;


--Found top 10 best-value products based on discount percentage
SELECT distinct name,discount_per,mrp from zepto
order by discount_per desc
limit 10;


--Identified high-MRP products that are currently out of stock
Select distinct name, outofstock,mrp from zepto
where outofstock=true
order by mrp desc;

--Estimated potential revenue for each product category
select category,
sum(discounted_sell_price*available_quantity) as total_revenue
from zepto
group by category
order by total_revenue;



--Filtered expensive products (MRP > ₹500) with minimal discount
select  distinct name,mrp,discount_per from zepto
where mrp>500 and discount_per<5
order by discount_per asc;


--Ranked top 5 categories offering highest average discounts
select category,
avg(discount_per) as average from zepto
group by category
order by average desc 
limit 5;


--Calculated price per gram to identify value-for-money products
select distinct name,
mrp/weightingms as total from zepto
where weightingms>0
order by total asc ;


--Grouped products based on weight into Low, Medium, and Bulk categories
select distinct name,weightingms,
case when weightingms<1000 then 'low'
when weightingms<5000 then 'medium'
else 'bulk'
end as weight_category
from zepto;

--Measured total inventory weight per product category
select  category,
sum(weightingms*available_quantity) as total from zepto
group by category
order by total ;






