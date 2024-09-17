CREATE DATABASE IF NOT EXISTS salesDataWalmart;

drop table sales;

CREATE TABLE IF NOT EXISTS sales(
invoice_id varchar(30) NOT NULL PRIMARY KEY,
  branch varchar(5) NOT NULL,
  city varchar(30) NOT NULL,
  customer_type varchar(30) NOT NULL,
  gender varchar(10) NOT NULL,
  product_line varchar(100) NOT NULL,
  unit_price decimal(10, 2) NOT NULL,
  quantity int NOT NULL,
  VAT float(6,4) NOT NULL,
  total decimal(10,2) NOT NULL,
  date DATETIME not null,
  time TIME not null,
  payment_method varchar(20) not null,
  cogs decimal(10,2) not null,
  gross_margin_percentage float(11,9),
  gross_income decimal(12,4) not null,
  rating float(2,1)
 );
 
 SELECT
   time,
   (CASE
	   WHEN  `time` BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
       WHEN  `time` BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON"
       ELSE "EVENING"
   END
   ) AS time_of_date
FROM sales; 


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

update sales
SET time_of_day = (CASE
	   WHEN  `time` BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
       WHEN  `time` BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON"
       ELSE "EVENING"
   END);

SELECT
    date,
    DAYNAME(date) as day_name
FROM sales;

alter table sales add column day_name varchar(10);

update sales
set day_name = DAYNAME(date);

SELECT
   date,
   MONTHNAME(date)
FROM sales;

ALTER table sales add column month_name varchar(10);

update sales
set month_name = MONthNAME(date);

-- How many unique cities does the data have?
SELECT
  distinct city
FROM sales;

-- In which city is each branch?
SELECT
  distinct branch
FROM sales;

SELECT
  distinct city, branch
FROM sales;

-- How many unique product lines does the data have?
select
 count(distinct product_line)
from sales;

-- What is the most common payment method?
select
 payment_method,
 count(payment_method) as cnt
from sales
group by payment_method;

-- What is the most selling product line?
select
 product_line,
 count(product_line) as cnt
from sales
group by product_line;

-- What is the total revenue by month?
select
      month_name as month,
      SUM(total) as total_revenue
from sales
group by month_name
order by total_revenue;

-- What month had the largest COGS?
select
  month_name as month,
  sum(cogs) as cogs
from sales
group by month_name
order by cogs desc;

-- What product line had the largest revenue?
select
 product_line as products,
 sum(total) as total_revenue
from sales
group by products
order by total_revenue desc;

-- What is the city with the largest revenue?
select
 city as city, 
 branch as branch,
 sum(total) as total_revenue
from sales
group by city, branch
order by total_revenue desc;

-- What product line had the largest VAT?
select
  product_line,
  avg(vat) as avg_tax
from sales
group by product_line
order by avg_tax desc;

-- Which branch sold more products than average product sold?
select
  branch, 
  sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- What is the most common product line by gender?
select
  gender,
  product_line,
count(gender) as total_cnt
from sales
group by gender, product_line
order by total_cnt desc;

-- What is the average rating of each product line?
select
 round(avg(rating), 2) as avg_rating,
 product_line
from sales
group by product_line
order by avg_rating desc;

-- Number of sales made in each time of the day per weekday
select
 time_of_day,
 count(*) as total_sales
 from sales
 where day_name = "Monday"
 group by time_of_day
 order by total_sales desc;

-- Which of the customer types brings the most revenue?
select
  customer_type,
  sum(total) as total_rev
 from sales
 group by customer_type
 order by total_rev desc;
 
-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select
   city,
   avg(vat) as tax_pct
   from sales
   group by city
   order by tax_pct desc;
   
-- Which customer type pays the most in VAT?
select
  customer_type,
  avg(vat) as vat
from sales
group by customer_type
order by vat desc; 

-- How many unique customer types does the data have?
select
  distinct customer_type
from sales;

-- How many unique payment methods does the data have?
select
  distinct payment_method
from sales;

-- Which customer type buys the most?
select
  customer_type,
  count(*) as cst_cnt
  from sales
  group by customer_type;

-- What is the gender of most of the customers?
select
  gender,
  count(*) as gender_cnt
from sales
group by gender
order by gender_cnt desc; 

-- What is the gender distribution per branch?
select
  gender,
  count(*) as gender_cnt
from sales
where branch = "C"
group by gender
order by gender_cnt desc; 

select
  gender,
  count(*) as gender_cnt
from sales
where branch = "A"
group by gender
order by gender_cnt desc; 

-- Which time of the day do customers give most ratings?
select
  time_of_day,
  avg(rating) as rating
from sales
group by time_of_day
order by rating desc;

-- Which time of the day do customers give most ratings per branch?
select
  time_of_day,
  avg(rating) as rating
from sales
where branch ="C"
group by time_of_day
order by rating desc;

select
  time_of_day,
  avg(rating) as rating
from sales
where branch ="A"
group by time_of_day
order by rating desc;

-- Which day fo the week has the best avg ratings?
select
   day_name,
   avg(rating) as rating
from sales
where branch = "B"
group by day_name
order by rating;

select
   day_name,
   avg(rating) as rating
from sales
where branch = "C"
group by day_name
order by rating;