/* Permormance analysis
 Comparing the current value to a terget value
 Helps measure success and compare performance

 current[measure] - target[measure]
 current sales - average sales
current year sales - previous year sales - YOY analysis
current sales - lowest sales
*/

-- analyze the yearly performance of products by comparing each product's sales
-- to both its average sales performance and the previous year's sales
WITH yearly_performance AS(
SELECT 
p.product_name,
YEAR(f.order_date) AS order_year, 
SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key 
WHERE f.order_date IS NOT NULL
GROUP BY p.product_name, YEAR(order_date)
) 
SELECT 
order_year,
product_name,
current_sales,
AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
	WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
	ELSE 'Avg'
END avg_change,
--- Year over Year Analysis --------
LAG(current_sales) OVER (Partition BY product_name ORDER BY order_year) as previous_year_sale,
current_sales - LAG(current_sales) OVER (Partition BY product_name ORDER BY order_year) as diff_py,
CASE WHEN LAG(current_sales) OVER (Partition BY product_name ORDER BY order_year) > 0 THEN 'Increase'
	WHEN LAG(current_sales) OVER (Partition BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
	ELSE 'No change'
END py_change
FROM yearly_performance
ORDER BY product_name, order_year
