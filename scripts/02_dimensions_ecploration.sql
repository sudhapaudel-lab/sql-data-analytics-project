--Exploring a dimensions
-- Explore All countries our customers come from
SELECT DISTINCT country 
FROM gold.dim_customers

SELECT DISTINCT category, sub_category, product_name
FROM gold.dim_products
ORDER BY 1,2,3
