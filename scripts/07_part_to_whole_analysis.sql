/* Part to Whole Analysis
 Proportional Analysis
 Allows us to understand which category has the greatest impact on the business.
*/

-- Which category contributes most to the overall sales
WITH total_sales AS(
SELECT 
category,
SUM(sales_amount) AS total_sales_by_category
FROM gold.fact_sales  f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY category
) 
SELECT TOP 1
category ,
total_sales_by_category,
SUM(total_sales_by_category) OVER() AS overall_sales,
CONCAT(ROUND(CAST(total_sales_by_category AS FLOAT) /SUM(total_sales_by_category) OVER() * 100, 2), '%')  AS per_contribution
FROM total_sales 
ORDER BY total_sales_by_category DESC
