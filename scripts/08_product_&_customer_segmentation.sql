/*
 Data Segmentation
Group the data based on a specific range
Helps understand the correlation between two measures
*/

--Segment products into cost ranges and count how many products fall into each segment
WITH product_segment AS(
SELECT 
product_key,
product_name,
cost,
CASE WHEN cost < 100 THEN 'Below 100'
	WHEN cost BETWEEN 100 AND 500  THEN '100-500'
	WHEN cost BETWEEN 500 and 1000  THEN '500-1000'
	ELSE 'Above 1000'
END cost_range
FROM gold.dim_products
)

SELECT cost_range,
COUNT(product_key) AS total_products
FROM product_segment
GROUP BY cost_range
ORDER BY total_products DESC

-- if your dimensions in the data set is not enough to create insights 
-- you can take one of your measures convert it into a dimention using case when
-- and then aggregate your other measures based on this new dimension  
-- so we sre now deriving new information and following this concept you can generate endless amt of reports 
-- even if your data set is small


/* Group customers into three segments bsed on their spending behavior 
		VIP : Customers with at least 12 months of history ans spending more than 5000
		Regular: Customers with at least 12 months of history but spending 5,000 or less
		New : Customers with a lifespan less then 12 months
  And find the total number of customers by each group 
*/
WITH customer_spending AS(
SELECT 
c.customer_key,
SUM(f.sales_amount) AS total_spending,
MIN(f.order_date) AS first_order,
MAX(f.order_date) AS last_order,
DATEDIFF(month , MIN(order_date) , MAX(order_date)) AS lifespan -- new measure from dim order_date
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
) 
SELECT 
customer_segment,
COUNT(customer_key) AS total_customers
FROM (
SELECT customer_key, 
total_spending,
lifespan,
CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
	WHEn lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
	ELSE 'New'
END customer_segment
FROM customer_spending
)t 
GROUP BY customer_segment 
ORDER BY total_customers DESC

 
