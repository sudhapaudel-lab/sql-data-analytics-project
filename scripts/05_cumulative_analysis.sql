
-- Cumulative Analysis
-- Aggregate the data progressively over time.
-- Helps to understand whether our business is growing or declining

-- Running total_sales over time
SELECT 
*,
SUM(total_sales) OVER(PARTITION BY YEAR(order_date) ORDER BY order_date) AS running_total_sales
FROM(
SELECT 
DATETRUNC(month, order_date) AS order_date,
SUM(sales_amount) as total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
)t

  --  running_total_sales  and   moving_average_price
SELECT 
*,
SUM(total_sales) OVER( ORDER BY order_date) AS running_total_sales,
AVG(avg_price) OVER(ORDER BY order_date) AS moving_average_price
FROM(
SELECT 
DATETRUNC(month, order_date) AS order_date,
SUM(sales_amount) as total_sales,
AVG(price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
)t
