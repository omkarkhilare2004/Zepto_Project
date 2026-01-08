/*SQL RETAIL ANALYSIS*/
drop table if exists retail_sales;
create table retail_sales (
transactions_id	int primary key,
sale_date	date,
sale_time	time,
customer_id	int,
gender	varchar(20),
age	int,
category varchar(25),
quantiy	int,
price_per_unit float,	
cogs	float,
total_sale float
);

select * from retail_sales # to see first 10 rows only
limit 10;

select count(*)  #to count how many rows we have
from retail_sales;

select * from retail_sales
where transactions_id is null;

select * from retail_sales
where sale_date is null;

select * from retail_sales
where sale_time is null;

-- DATA CLEANING
select * 
from retail_sales
where transactions_id is null
or 
sale_date is null
or 
sale_time is null
or 
customer_id is null
or 
gender is null
or 
age is null
or 
category is null 
or 
price_per_unit is null
or 
cogs is null
or 
total_sale is null;


-- DATA EXPLORATION

/*How many sales we have*/
select count(*) as total_sales
from retail_sales;

/*How many unique customers we have?*/
select  count(distinct customer_id) 
as total_sale  # we have to get unique customers detail i.e we use "distinct" keyword.
from retail_sales;  

select distinct category  #here also we use distinct keyword
from retail_sales; #because we have to get the unique values of category column

/* DATA ANALYSIS
 & BUSINESS KEY PROBLEMS & ANSWERS */
 
 /*Q1.WAQ to retrieve all column for sales made on '2022-11-05'*/
 select *  #we have to see sales made on 05-11-22 therefore we simply use where func.
 from retail_sales
 where sale_date = '2022-11-05';
 
 /*WAQ to retrieve all transactions where the category is 'Clothing' & 
 the quantity sold is more than 4 in the month of Nov-2022*/
select *
from retail_sales #1st we have to check the category column to get the 'Clothing'
where category = 'Clothing'
and DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'#We have to change the format of date 
and quantiy >= 4;#We have to get the data which is greater than 4

/*WAQ to calculate total_sales (total_sale) for each category.*/
select category,sum(total_sale) as net_sale,count(*) as total_orders
from retail_sales #We have to 'sum' up the value to get the net_sale as we use it as alias
group by category; #Then we have to count the total_numbers

/*WAQ to find the average age of customers 
who purchased items from the 'Beauty' category*/
select round(avg(age),2) #here we use 'avg' which is aggregrate function to get the average of the age
from retail_sales  # we use round(2) function to get the no. which has 2 points after decimal point
where category = 'Beauty';

/*WAQ to find all transactions where the total_sale is greater than 1000.*/
select * 
from retail_sales
where total_sale > 1000;

/*WAQ to find the 
total_number of transaction(transaction_id) 
made by each gender in each category*/
select category,gender,count(*) as total_trans
from retail_sales
group by category,gender
order by 1;

/*WAQ to calculate the average sale for each month.
find out best selling month in each year.*/
SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    SUM(total_sale),
    avg(total_sale)
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY YEAR(sale_date), SUM(total_sale) DESC;

/*WAQ to find the top 5 customers 
based on the highest total sales*/
select  customer_id,sum(total_sale)
from retail_sales
group by customer_id
order by sum(total_sale) desc
limit 5;

/*WAQ to find the number of 
unique customers who purchased items 
from each category*/
select distinct category,
count(distinct customer_id) as unique_customer
from retail_sales
group by category;

/*WAQ to create each shift and numbers of orders(Eg:-Morning < 12, Evening > 17)*/
with hourly_sale
as
(
select *,
case when 
extract(hour from sale_time) < 12 then 'Morning'
when
extract(hour from sale_time) between 12 and 17 then 'Afternoon'
else
'Evening'
end as shift
from retail_sales
)
select
shift,count(*) as total_orders
from hourly_sale
group by shift;



