
-- 1. Remove records with missing values
DELETE FROM sales_data
WHERE product_id IS NULL OR sales IS NULL OR profit IS NULL OR order_date IS NULL;

-- 2. Calculate Profit Margins by Category and Sub-Category
SELECT 
    category,
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0), 4) AS profit_margin
FROM sales_data
GROUP BY category, sub_category
ORDER BY profit_margin ASC;

-- 3. Inventory Turnover Calculation (Assumes daily_sales and inventory columns exist)
SELECT 
    product_id,
    category,
    sub_category,
    inventory,
    AVG(daily_sales) AS avg_daily_sales,
    ROUND(inventory / NULLIF(AVG(daily_sales), 0), 2) AS inventory_days
FROM sales_data
GROUP BY product_id, category, sub_category, inventory;

-- 4. Monthly/Seasonal Trend Analysis
SELECT 
    product_id,
    category,
    sub_category,
    EXTRACT(MONTH FROM order_date) AS order_month,
    SUM(sales) AS monthly_sales
FROM sales_data
GROUP BY product_id, category, sub_category, EXTRACT(MONTH FROM order_date)
ORDER BY product_id, order_month;

-- 5. Region-wise Profitability Summary
SELECT 
    region,
    category,
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0), 4) AS profit_margin
FROM sales_data
GROUP BY region, category, sub_category
ORDER BY region, profit_margin;

-- 6. Top and Bottom Performing Products by Profit
(SELECT product_id, product_name, SUM(profit) AS total_profit
 FROM sales_data
 GROUP BY product_id, product_name
 ORDER BY total_profit DESC
 LIMIT 5)
UNION ALL
(SELECT product_id, product_name, SUM(profit) AS total_profit
 FROM sales_data
 GROUP BY product_id, product_name
 ORDER BY total_profit ASC
 LIMIT 5);
