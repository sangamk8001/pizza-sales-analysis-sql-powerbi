use [Pizza DB];

-- insure the data duplicacy 
select count(distinct pizza_id) as unique_pizza_names, COUNT(pizza_id) as total_pizzas_sold from pizza_sales; 

select * from pizza_sales;

-- KPI's
-- total revenue generated from pizza sales
select sum(total_price) as total_revenue from pizza_sales;

-- Average order value : the avg amount spent per order
select total_rev/total_order as avg_order_value 
from (
	select sum(total_price) as total_rev, 
	count(distinct order_id) as total_order from pizza_sales ) t

-- total pizzas sold
select sum(quantity) as total_pizzas_sold from pizza_sales;

-- total orders
select COUNT(distinct order_id) as total_orders from pizza_sales;
select count(order_id) as total_orders from pizza_sales;

-- avg pizza per order
select cast(cast(sum(quantity) as decimal(10,2))/cast(count(distinct order_id) as decimal(10,2)) as decimal(10,2))  as avg_pizza_per_order from pizza_sales;

-- Chart requrments

 /* 1. daily trands for total orders
 create a bar chart that display the daily trands of total orders over a specific time line period.
this chart will hwlp us identify any pattern or fluctuation in order volume on a daily basis */
	select * from pizza_sales;

select datename(weekday, order_date) as day_of_week, 
	count(distinct order_id) as total_orders 
from pizza_sales
group by datename(weekday, order_date);

/* 2. Monthly Trend for Total Orders:
Create a line chart that illustrates the hourly trend of total orders throughout the day. 
This chart will allow us to identify peak hours or periods of high order activity. */

select datename(MONTH, order_date) as order_month, 
	count(distinct order_id) as total_orders
from pizza_sales
group by datename(month, order_date);

/* 3. Percentage of Sales by Pizza Category:
Create a pie chart that shows the distribution of sales across different pizza categories. 
This chart will provide insights into the popularity of various pizza categories and their contribution to overall sales. */

select pizza_category, 
	sum(total_price) as total_sales,
	round(SUM(total_price) * 100.0 / (select sum(total_price) from pizza_sales where month(order_date) = 1),2) as percentage_of_sales
from pizza_sales
where month(order_date) = 1
group by pizza_category;

/* 4. Percentage of Sales by Pizza Size:
Generate a pie chart that represents the percentage of sales attributed to different pizza sizes. 
This chart will help us understand customer preferences for pizza sizes and their impact on sales. */

select pizza_size, 
	sum(total_price) as total_sales,
	round(SUM(total_price) * 100.0 / (select sum(total_price) from pizza_sales ),2) as percentage_of_sales
from pizza_sales
group by pizza_size
order by percentage_of_sales desc;


 /*5. Total Pizzas Sold by Pizza Category:
Create a funnel chart that presents the total number of pizzas sold for each pizza category. 
This chart will allow us to compare the sales performance of different pizza categories. */

select pizza_category, 
	sum(quantity) as total_sold
from pizza_sales
group by pizza_category;

/* 6. Top 5 Best Sellers by Total Pizzas Sold:
Create a bar chart highlighting the top 5 best-selling pizzas based on the total number of pizzas sold. 
This chart will help us identify the most popular pizza options. */

select top 5 pizza_name, sum(quantity) as total_pizzas_sold
from pizza_sales
group by pizza_name
order by total_pizzas_sold desc;


/* 7. Bottom 5 Worst Sellers by Total Pizzas Sold:
Create a bar chart showcasing the bottom 5 worst-selling pizzas based on the total number of pizzas sold. 
This chart will enable us to identify underperforming or less popular pizza options. */

select top 5 pizza_name, sum(quantity) as total_pizzas_sold
from pizza_sales
group by pizza_name
order by total_pizzas_sold asc;

--select top 5 pizza_name, sum(total_price) as total_pizzas_sold
--from pizza_sales
--group by pizza_name
--order by total_pizzas_sold asc;


select  (select sum(total_price) from pizza_sales)/count(distinct order_id) as AOV from pizza_sales;

-- avg pizza sold per order
select cast(cast(sum(quantity) as decimal(10,2))/cast(count(distinct order_id) as decimal(10,2)) as decimal(10,2))  as avg_pizza_per_order from pizza_sales;
