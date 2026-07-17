
CREATE TABLE online_retail (
    invoice_no VARCHAR(20),
    stock_code VARCHAR(30),
    description TEXT,
    quantity INT,
    invoice_date TIMESTAMP,
    unit_price NUMERIC(10,2),
    customer_id INT,
    country VARCHAR(100),
    sales NUMERIC(12,2),
    year INT,
    month VARCHAR(20),
    month_number INT,
    quarter VARCHAR(5),
    day VARCHAR(20),
    hour INT,
    customer_status VARCHAR(30),
    market_type VARCHAR(30)
);

--Data Validation & Quality Checks

SELECT * FROM online_retail;

SELECT * FROM online_retail
LIMIT 10;

SELECT COUNT(*) AS total_records
FROM online_retail;

SELECT COUNT(*) AS total_rows,
       COUNT(customer_id) AS customeer_count
FROM online_retail;

  
 SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'online_retail'
ORDER BY ordinal_position;  


SELECT
    COUNT(*) AS total_records,
    COUNT(invoice_no) AS invoice_no,
    COUNT(stock_code) AS stock_code,
    COUNT(description) AS description,
    COUNT(quantity) AS quantity,
    COUNT(invoice_date) AS invoice_date,
    COUNT(unit_price) AS unit_price,
    COUNT(customer_id) AS customer_id,
    COUNT(country) AS country,
    COUNT(sales) AS sales,
    COUNT(year) AS year,
    COUNT(month) AS month,
    COUNT(month_number) AS month_number,
    COUNT(quarter) AS quarter,
    COUNT(day) AS day,
    COUNT(hour) AS hour,
    COUNT(customer_status) AS customer_status,
    COUNT(market_type) AS market_type
FROM online_retail;

SELECT invoice_no,
        COUNT(*) AS transaction_count
FROM online_retail
GROUP BY invoice_no
HAVING COUNT(*) > 1
ORDER BY transaction_count DESC;

SELECT MIN(invoice_date) as first_order_date,
       MAX(invoice_date) as last_order_date
FROM online_retail;	 

SELECT DISTINCT year
FROM online_retail
ORDER BY year;

SELECT COUNT(*) AS nagative_quantity_records
FROM online_retail
WHERE quantity < 0;

SELECT
    COUNT(*) AS zero_quantity_records
FROM online_retail
WHERE quantity = 0;

SELECT
    COUNT(*) AS negative_unit_price_records
FROM online_retail
WHERE unit_price < 0;

SELECT
    COUNT(*) AS zero_unit_price_records
FROM online_retail
WHERE unit_price = 0;

DELETE FROM online_retail
WHERE unit_price = 0;

SELECT
    COUNT(*) AS incorrect_sales_records
FROM online_retail
WHERE sales <> (quantity * unit_price);

SELECT * FROM online_retail;

--Exploratory Data Analysis

-- KPI Analysis

--Q.1 Overall Business Performance KPIs

SELECT 
    SUM(sales) AS total_revenue,
    COUNT(DISTINCT invoice_no) AS unique_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(quantity) AS total_quantity
FROM online_retail;

--Q.2 What is the total revenue generated from all sales transactions?

SELECT SUM(sales) AS total_revenue
FROM online_retail;

--Q.3 How many unique orders were placed in the online retail store?

SELECT COUNT(DISTINCT invoice_no) AS unique_orders
FROM online_retail;

--Q.4 How many unique customers have made at least one purchase?

SELECT COUNT(DISTINCT customer_id) as unique_customers
FROM online_retail;

--Q.5 What is the total quantity of products sold?

SELECT SUM(quantity) AS total_quantity 
FROM online_retail;

--Q.6 What is the average order value (AOV)?

SELECT  ROUND(SUM(sales)/COUNT(DISTINCT invoice_no),2) AS avg_order_value
FROM online_retail;

--Q.7 What is the average revenue generated per customer?

SELECT ROUND(SUM(sales)/COUNT(DISTINCT customer_id),2) AS avg_revenue_per_cust
FROM online_retail;

--Q.8 What is the average quantity of products purchased per order?

SELECT ROUND(SUM(quantity)/COUNT(DISTINCT invoice_no),2) AS avg_quantity_per_order
FROM online_retail;

--Q.9 What is the average unit price of all products sold?

SELECT AVG(unit_price) AS avg_unit_price_per_product
FROM online_retail;

--Order Analysis

--Q.10 Which order (Invoice Number) has the highest total sales value?

SELECT invoice_no,
       SUM(sales) AS highest_total_sales
FROM online_retail
GROUP BY invoice_no
ORDER BY highest_total_sales DESC
LIMIT 1;

--Q.11 Which customer has generated the highest total revenue?

SELECT customer_id,
       SUM(sales) AS total_revenue
FROM online_retail
WHERE customer_id IS NOT NULL
Group BY customer_id
ORDER BY total_revenue DESC
LIMIT 1;

--Customer Analysis

--Q.12 Find the Top 10 customers by total revenue.

SELECT customer_id,
       SUM(sales) AS total_revenue_per_customer
FROM online_retail
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY total_revenue_per_customer DESC
LIMIT 10;

--Q.13 Find the number of customers in each country.

SELECT country, 
       COUNT( DISTINCT customer_id) as customer_count
FROM online_retail
GROUP BY country
ORDER BY customer_count DESC;

--Q.14 Find the repeat customers who placed more than one order.

SELECT customer_id,
       COUNT( DISTINCT invoice_no) AS repeat_customers
FROM online_retail
WHERE customer_id IS NOT NULL
GROUP BY customer_id
HAVING COUNT( DISTINCT invoice_no) > 1
ORDER BY repeat_customers DESC;

--Product Analysis

--Q.15 Which are the Top 10 products by total revenue?

SELECT description, 
       SUM(sales) AS total_revenue_per_product
FROM online_retail
GROUP BY description 
ORDER BY total_revenue_per_product DESC
LIMIT 10;

--Q.16 Which are the Top 10 products by total quantity sold?

SELECT description, 
       SUM(quantity) AS total_quantity_sold
FROM online_retail
GROUP BY description 
ORDER BY total_quantity_sold DESC
LIMIT 10;

--Country Analysis

--Q.17 Which countries generated the highest total revenue? (Top 10 countries)

SELECT country,
       SUM(sales) AS total_revenue
FROM online_retail
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 10;

--Q.18 Which country placed the highest number of orders?

SELECT country,
       COUNT( DISTINCT invoice_no) AS total_orders
FROM online_retail
GROUP BY country
ORDER BY total_orders DESC
LIMIT 1;

--Q.19 Which are the Top 10 countries by number of orders?

SELECT country,
       COUNT( DISTINCT invoice_no) AS total_orders
FROM online_retail
GROUP BY country
ORDER BY total_orders DESC
LIMIT 10;

--Q.20 Find the average order value for each country.

SELECT country,
       ROUND(SUM(sales)/COUNT(DISTINCT invoice_no),2) AS country_avg_order_value
FROM online_retail
GROUP BY country
ORDER BY country_avg_order_value DESC;

--Q.21 Find the top 5 countries by average order value (AOV).

SELECT country,
       ROUND(SUM(sales)/COUNT(DISTINCT invoice_no),2) AS avg_order_value
FROM online_retail
GROUP BY country
ORDER BY avg_order_value DESC
LIMIT 5;

--Q.22 Find the countries that generated more than £100,000 in total revenue.

SELECT country,
       SUM(sales) AS total_revenue
FROM online_retail
GROUP BY country
HAVING SUM(sales) > 100000
ORDER BY total_revenue DESC;

--Q.23 Find the percentage contribution of each country to total revenue.

SELECT country,
       SUM(sales) AS country_revenue,
	   ROUND((SUM(sales)/(SELECT SUM(sales) FROM online_retail))*100,2) AS revenue_percentage
FROM online_retail
GROUP BY country
ORDER BY country_revenue DESC;

--Time-Based Analysis

--Q.24 Which month generated the highest total revenue?

SELECT month,
       SUM(sales) AS highest_month_revenue
FROM online_retail
GROUP BY month
ORDER BY highest_month_revenue DESC
LIMIT 1;

--Q.25 Which are the Top 10 months by total revenue?

SELECT month,
       SUM(sales) AS highest_month_revenue
FROM online_retail
GROUP BY month
ORDER BY highest_month_revenue DESC
LIMIT 10;

--Q.26 Which year generated the highest total revenue?

SELECT year,
       SUM(sales) highest_sales
FROM online_retail
GROUP BY year
ORDER BY highest_sales DESC
LIMIT 1;

--Q.27 Find the average order value (AOV) for each month.

SELECT month,
       ROUND(SUM(sales)/COUNT(DISTINCT invoice_no),2) AS monthly_avg_order_value
FROM online_retail
GROUP BY month
ORDER BY monthly_avg_order_value DESC;

--Q.28 Find the monthly sales trend with total orders and total revenue.

SELECT month,
       month_number,
       COUNT(DISTINCT invoice_no) AS total_orders,
	   SUM(sales) AS total_revenue
FROM online_retail
GROUP BY month,month_number
ORDER BY month_number;

--Q.29 Find the monthly revenue growth compared to the previous month.

WITH monthly_sales AS (
    SELECT 
        month,
        month_number,
        SUM(sales) AS total_revenue
    FROM online_retail
    GROUP BY month, month_number
)

SELECT 
    month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY month_number) AS previous_month_revenue,
    ROUND(
        ((total_revenue - LAG(total_revenue) OVER (ORDER BY month_number)) 
        / LAG(total_revenue) OVER (ORDER BY month_number)) * 100,
        2
    ) AS revenue_growth_percentage
FROM monthly_sales
ORDER BY month_number;
