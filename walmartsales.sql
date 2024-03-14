show databases;
create database walmart;
use walmart;
select * from walmartsalesdata;
desc walmartsalesdata;

-- Add the time_of_day column
ALTER TABLE walmartsalesdata
MODIFY COLUMN time TIME NOT NULL;

ALTER TABLE walmartsalesdata ADD COLUMN time_of_day VARCHAR(20);

UPDATE walmartsalesdata
SET time_of_day = 
    CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END;



-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM walmartsalesdata;

ALTER TABLE walmartsalesdata ADD COLUMN day_name VARCHAR(10);

UPDATE walmartsalesdata
SET day_name = DAYNAME(date);


-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM walmartsalesdata;

ALTER TABLE walmartsalesdata ADD COLUMN month_name VARCHAR(10);

UPDATE walmartsalesdata
SET month_name = MONTHNAME(date);

-- ---------------------------- Generic ------------------------------
-- How many unique cities does the data have?
select count(distinct(City)) from walmartsalesdata;

-- In which city is each branch?
select distinct city,branch from walmartsalesdata;

-- ---------------------------- Product -------------------------------

-- How many unique product lines does the data have?
select count(distinct product_line) from walmartsalesdata;

-- What is the most selling product line?
select distinct(product_line),
		count(product_line) 
from walmartsalesdata
group by product_line 
order by product_line desc 
limit 1;

-- What is the total revenue by month?
select month_name,sum(Total) 
from walmartsalesdata
group by month_name;

-- What month had the largest COGS?
select month_name 
from walmartsalesdata
group by month_name
order by sum(cogs) desc
limit 1;

-- What product line had the largest revenue?
select product_line
from walmartsalesdata
group by product_line
order by sum(total) desc
limit 1;

-- What is the city with the largest revenue?
select city
from walmartsalesdata
group by city
order by sum(total) desc
limit 1;

-- What product line had the largest VAT?
select product_line, Tax_5
from walmartsalesdata
group by product_line
order by Tax_5 desc
limit 1;

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales
SELECT 
	AVG(quantity) AS avg_qnty
FROM walmartsalesdata;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM walmartsalesdata
GROUP BY product_line;

-- Which branch sold more products than average product sold?
select Branch
from walmartsalesdata
group by Branch
order by count(product_line) desc 
limit 1;

-- What is the most common product line by gender?
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM walmartsalesdata
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line?
SELECT product_line, Round(Rating,2)
FROM walmartsalesdata
GROUP BY product_line;


-- -------------------------- Customers -------------------------------

-- How many unique customer types does the data have?
SELECT distinct Customer_type
FROM walmartsalesdata;

-- How many unique payment methods does the data have?
SELECT distinct Payment
FROM walmartsalesdata;

-- What is the most common customer type?
SELECT distinct Customer_type
FROM walmartsalesdata
GROUP BY Customer_type
ORDER BY count(Customer_type) desc
limit 1;

-- Which customer type buys the most?
SELECT Customer_type
FROM walmartsalesdata
GROUP BY Customer_type
ORDER BY COUNT(Customer_type) desc
limit 1;

-- What is the gender of most of the customers?
SELECT Gender
FROM walmartsalesdata
GROUP BY Gender
ORDER BY COUNT(Gender) desc
limit 1;

-- What is the gender distribution per branch?
SELECT Branch,Gender,COUNT(Gender)
FROM walmartsalesdata
GROUP BY Branch,Gender
ORDER BY Branch ;

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM walmartsalesdata
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT
	Branch,
	time_of_day,
	AVG(rating) AS avg_rating
FROM walmartsalesdata
GROUP BY Branch,time_of_day
ORDER BY avg_rating DESC;

-- Which day fo the week has the best avg ratings?
SELECT day_name,AVG(rating) AS avg_rating
FROM walmartsalesdata
GROUP BY day_name
ORDER BY avg_rating desc;

-- Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM walmartsalesdata
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;


-- ---------------------------- Sales ---------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT 
	day_name,
	sum(Total) as Totalsales
FROM walmartsalesdata
GROUP BY day_name
ORDER BY Totalsales DESC;

-- Which of the customer types brings the most revenue?
SELECT 
	Customer_type
FROM walmartsalesdata
GROUP BY Customer_type 
ORDER BY sum(Total) desc
limit 1;

-- Which city has the largest tax/VAT percent?
SELECT
	city,
    ROUND(AVG(Tax_5), 2) AS avg_tax_pct
FROM walmartsalesdata
GROUP BY city 
ORDER BY avg_tax_pct DESC
limit 1;

-- Which customer type pays the most in VAT?
SELECT
	Customer_type,
    ROUND(AVG(Tax_5), 2) AS avg_tax_pct
FROM walmartsalesdata
GROUP BY Customer_type 
ORDER BY avg_tax_pct DESC
limit 1;