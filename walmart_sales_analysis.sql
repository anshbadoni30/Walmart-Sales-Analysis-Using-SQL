create database walmart;
use walmart;
create table sales (
invoice_id varchar(30) not null,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(10) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
vat float(6,4) not null,
total decimal(10,2) not null,
date datetime not null,
time time not null,
payment varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_pct float(11,9) not null,
gross_income decimal(12,4),
rating float(2,1)
);

select * from sales;


ALTER TABLE sales
MODIFY COLUMN invoice_id varchar(30) primary key;


-- ------------------------------------------Feature Engineering---------------------------------------------------------------------------- --


-- Checking of new column to add
SELECT time, 
(CASE 
				WHEN  time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"  
                WHEN time BETWEEN "12:00:01" AND "16:00:00" THEN "Afternoon" 
                ELSE "evening"
                END)
 AS time_of_day
FROM sales;

-- Adding new column
alter table sales
add column time_of_day varchar(30) not null;

-- Adding records in time_of_day
update sales
set time_of_day = (CASE 
				WHEN  time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"  
                WHEN time BETWEEN "12:00:01" AND "16:00:00" THEN "Afternoon" 
                ELSE "evening"
                END);


-- checking  for new column  to add
select date, dayname(date) as day from sales;

-- Adding new column
alter table sales
add day_name varchar(30) not null;

-- Adding records in new column
update sales
set day_name = dayname(date); 
                
			
 -- cheking for new column to add           
select date, monthname(date) as day from sales;


-- Adding new column
alter table sales
add month_name varchar(30) not null;

-- Adding records in new column
update sales
set month_name = monthname(date); 


-- Exploratory Data Analysis
-- ---------------------GENRIC-----------------------------
-- 1.How many unique cities does the data have?
select distinct(city) from sales;

-- 2.In which city is each branch?
SELECT DISTINCT city,branch FROM sales;

-- --------------------Product----------------------------
-- 1.How many unique product lines does the data have?
select distinct(product_line) from sales;

-- 2.What is the most common payment method?
select payment, count(payment) as count from sales
group by payment order by count desc;

-- 3.What is the most selling product line?
select product_line, count(quantity) cnt from sales group by product_line order by cnt desc;

-- 4.What is the total revenue by month?
select month_name, sum(total) from sales group by month_name;

-- 5.What month had the largest COGS?
select month_name, sum(cogs) as sum_of_cogs from sales group by month_name order by sum_of_cogs desc;

-- 6.What product line had the largest revenue?
select product_line, sum(total) as revenue from sales group by product_line order by revenue desc;

-- 7.What is the city with the largest revenue?
select city, sum(total) as revenue from sales group by city order by revenue desc;

-- 8.What product line had the largest VAT?
select product_line, avg(vat) as VAT from sales group by product_line order by VAT desc;

-- 9.Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select avg(total) from sales;
select product_line, avg(total),(case 
			when avg(total) > 322.499 then "Good"
            else "Bad"
   end) as  remarks from sales group by product_line;

-- 10.Which branch sold more products than average product sold?
select branch, sum(quantity) qty from  sales group by branch having qty> (select avg(quantity) from sales);

-- 11.What is the most common product line by gender?
select gender, product_line, sum(quantity) as sum from sales group by gender, product_line order by sum desc;

-- 12.What is the average rating of each product line?
select product_line, round(avg(rating),1) as rating from sales group by product_line order by rating desc;


-- ----------------------------Sales------------------------------
-- 1.Number of sales made in each time of the day per weekday?
select day_name, time_of_day, count(*) sales_total from sales group by day_name, time_of_day order by sales_total desc;

-- 2.Which of the customer types brings the most revenue?
select customer_type,sum(total) as revenue from sales group by customer_type order by revenue desc;

-- 3.Which city has the largest tax percent/ VAT (Value Added Tax)?
select city , avg(vat) VAT from sales group by city order by VAT desc; 

-- 4.Which customer type pays the most in VAT?
select customer_type , avg(vat) VAT from sales group by customer_type order by VAT desc;


-- -----------------------------------Customer-------------------------------------
-- 1.How many unique customer types does the data have?
select distinct(customer_type) from sales;

-- 2.How many unique payment methods does the data have?
select distinct(payment) from sales;

-- 3.What is the most common customer type?
select customer_type, count(customer_type) COUNT from sales group by customer_type order by COUNT desc;
 
-- 4.Which customer type buys the most?
select customer_type, sum(quantity) total_buy from sales group by customer_type order by total_buy desc;

-- 5.What is the gender of most of the customers?
select gender, count(gender) gender_count from sales group by gender order by gender_count desc;

-- 6.What is the gender distribution per branch?
select branch, gender, count(gender) from sales group by branch, gender ;

-- 7.Which time of the day do customers give most ratings?
select time_of_day, avg(rating) Rating from sales group by time_of_day order by Rating desc;

-- 8.Which time of the day do customers give most ratings per branch?
select branch,time_of_day, avg(rating) Rating from sales group by branch,time_of_day order by Rating desc;

-- 9.Which day fo the week has the best avg ratings?
select day_name, avg(rating) Rating from sales group by day_name order by Rating desc;

-- 10.Which day of the week has the best average ratings per branch?
select branch,day_name, avg(rating) Rating from sales group by branch,day_name order by Rating desc;

