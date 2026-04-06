drop table if exists sales;
create table sales (
Row_ID int,
Order_ID varchar(20),
Order_Date date,
Ship_Date date,
Ship_Mode varchar(20),
Customer_ID varchar(20),
Customer_Name varchar(30),
Segment varchar(20),
Country varchar(30),
City varchar(30),
State varchar(30),
Postal_Code int,
Region varchar(20),
Product_ID varchar(20),
Category varchar(30),
Sub_Category varchar(30),
Product_Name varchar(200),
Sales float,
Quantity int,
Discount float,
Profit float
)

Copy sales 
FROM 'C:/Users/pk778/Downloads/Superstore Dataset/superstore_dataset.csv' 
WITH (FORMAT csv, HEADER true, ENCODING 'LATIN1');

-- creating new column 
alter table sales
add column processing_days integer;

UPDATE sales 
SET processing_days = ship_date - order_date;

-- extracting months and years from table
SELECT 
    order_date,
    EXTRACT(YEAR FROM order_date) AS sales_year,
    EXTRACT(MONTH FROM order_date) AS sales_month,
    EXTRACT(DAY FROM order_date) AS sales_day
FROM sales;

-- creating new column for day, month and year
ALTER TABLE sales 
ADD COLUMN sales_days int,
ADD COLUMN sales_year int,
ADD COLUMN sales_month int

-- set value to the column 
UPDATE sales 
SET 
    sales_year = EXTRACT(YEAR FROM order_date),
    sales_month = EXTRACT(MONTH FROM order_date),
	sales_days = EXTRACT(DAY FROM order_date);


-- checking that  all multiple orders is done by the same customer_id in same day 

select count(*),count(distinct order_id)
from sales


select ship_date ,order_id,customer_name, count(customer_id) 
from sales
group by 1,2,3
having count(customer_id) >1;

select order_id , count(order_id)  
from sales
group by order_id
having count(order_id) >1;


-- Finding kpis and charts 

select * from sales

-- Total orders 
select count(order_id) as Total_orders
from sales


-- Total sales
select sum(sales) as total_sales from 
sales


-- Total profit
select sum(profit) as total_sales from 
sales


-- Total profit margin 
select sum(profit)/sum(sales)*100  as profit_margin from 
sales

-- AVG processing days
select avg(processing_days) as avg_processing_days from 
sales


-- chart analysis 

-- top 10 product performance analysis
select product_name, sum(sales) as sales
from sales
group by 1 
order by sales desc
limit 10;


-- Regional sales comparisons
select region, sum(sales) as sales
from sales
group by 1 
order by sales desc


-- Customer segment analysis
select segment, sum(sales) as sales
from sales
group by 1 
order by segment desc


-- Time-series sales trends
select sales_year, sales_month, sum(sales) as sales
from sales
group by 1 ,2
order by 1,2

-- Shipping performance evaluation
select ship_mode, sum(sales) as total_sales
from sales
group by 1
order by 2 desc


COPY sales TO 'C:/Users/pk778/Downloads/Superstore Dataset/cleaned_superstore_dataset.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',');







