--TABLE CREATION
drop table if exists retail_sales;
create table retail_sales
	(
		transactions_id int primary key,
		sale_date date,
		sale_time time,
		customer_id int,
		gender varchar(10),
		age int,
		category varchar(15),
		quantity int,
		price_per_unit float,
		cogs float,
		total_sale float
	);

select count(*) from retail_sales;
--DATA CLEANING
--CHECKING NULL VALUES
select * from retail_sales
where transactions_id is null;
select * from retail_sales
where sale_date is null;
select * from retail_sales
where 
   transactions_id is null 
   or
   sale_date is null
   or
   sale_time is null
   or
   customer_id is null
   or
   gender is null
   or 
   category is null
   or
   quantity is null
   or 
   cogs is null
   or 
   total_sale is null;

--DELETING NULL VALUES
delete from retail_sales
where 
   transactions_id is null 
   or
   sale_date is null
   or
   sale_time is null
   or
   customer_id is null
   or
   gender is null
   or 
   category is null
   or
   quantity is null
   or 
   cogs is null
   or 
   total_sale is null;

--DATA EXPLORATION

--How many sales we have?
select count(*) as total_sales from retail_sales;
--How many customers we have?
select count(distinct customer_id) as total_customer from retail_sales;
--How many category we have?
select count(distinct category) as total_category from retail_sales;
--Name of categories
select distinct category from retail_sales;

--Key Problems and solution
-- Q1 Retrieve all columns for sales made on '2022-11-05
select * from retail_sales 
where sale_date='2022-11-05';

---Q2 Retrieve all transactions where the category is 'Clothing'
--and the quantity sold is more than 10 in the month of Nov-2022
select * from retail_sales
where 
	category ='Clothing'
	and
	quantity >= 4
	and
	to_char(sale_date,'YYYY-MM')='2022-11';

--Q3 Calculate the total sales (total_sale) for each category.
select category, 
       sum(total_sale) as Total_Sales, 
       count(*) as total_order
from retail_sales
group by category;

-- Q4 Find the average age of customers who purchased
--items from the 'Beauty' category.
select round(avg(age),2) as average_age 
from retail_sales
where category= 'Beauty';

--Q5 Find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale > 1000;

--Q6 Find the total number of transactions (transaction_id) made by each gender in each category.
select count(transactions_id) as total_transaction ,gender,category
from retail_sales
group by 2,3;

--Q7 Calculate the average sale for each month. Find out best selling month in each year
select year,month,avg_sale
from
(
	select 
		extract(year from sale_date) as year,
		extract(month from sale_date) as month,
    	avg(total_sale) as avg_sale,
		rank() over(partition by extract(year from sale_date)
	                order by avg(total_sale) desc)
	from retail_sales
	group by 1,2
) as temp_table
where rank=1;

--Q8 Find the top 5 customers based on the highest total sales
select customer_id, sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

--Q9 Find the number of unique customers who purchased items from each category.
select count(distinct customer_id)as unique_customers, category
from retail_sales
group by 2;

--Q10 Create each shift and number of orders (Example 
--Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sales
as(
select * ,
	case
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 16 then 'Afternoon'
		else 'Evenning'
	end as shift
from retail_sales
)
select count(*) as total_orders, shift
from hourly_sales
group by shift;

select extract(hour from current_time);
select extract(minute from current_time);
select extract(second from current_time);
select extract(day from current_date);
select extract(month from current_date);
select extract(year from current_date);
