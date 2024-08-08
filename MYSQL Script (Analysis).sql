### IMPLEMENT A CALENDER MAP THAT SHOWS METRICS(SALES, ORDERS, QUANTITY) BASED ON SELECTED MONTH.
SELECT 
	CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1), 'K') AS Total_Sales,
    CONCAT(ROUND(SUM(transaction_qty)/1000,1), 'K') AS Total_Qty_Sold,
    CONCAT(ROUND(COUNT(transaction_id)/1000,1), 'K') AS Total_Orders
FROM COFFEE_SHOP_SALES
WHERE 
	transaction_date = '2023-03-27';
    
### SALES ANALYSIS BY WEEKDAYS AND WEEKENDS
/*
WEEKENDS - SAT AND SUN
WEEKDAYS - MON TO FRI
SUN = 1
MON = 2
.
.
SAT = 7
*/
SELECT 
    CASE WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
	ELSE 'Weekdays'
    END AS day_type,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1), 'K') AS total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5  -- May Month
GROUP BY 
    CASE WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
	ELSE 'Weekdays'
    END;

### SALES ANALYSIS BY STORE LOCATION
SELECT store_location, CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2),'K') as Total_Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5 -- MAY MONTH 
GROUP BY store_location 
ORDER BY SUM(unit_price * transaction_qty) DESC;

-- SELECT AVG(unit_price * transaction_qty) AS Avg_Sales
-- FROM coffee_shop_sales
-- WHERE MONTH(transaction_date) = 5;

### DAILY SALES ANALYSIS WITH AVERAGE LINE
# 1) SALES TREND OVER PERIOD
SELECT CONCAT(ROUND(AVG (total_sales)/1000,1), 'K') AS Avg_Sales
FROM 
	(
    SELECT SUM(transaction_qty * unit_price) AS total_sales
    FROM COFFEE_SHOP_SALES
    WHERE MONTH (transaction_date) = 4
    GROUP BY transaction_date
    ) AS Internal_query;

# 2) DAILY SALES FOR MONTH SELECTED    
SELECT 
	DAY(transaction_date) AS day_of_month,
    SUM(transaction_qty * unit_price) AS Total_Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5
GROUP BY DAY(transaction_date)
ORDER BY DAY(transaction_date);

# 3) COMPARING DAILY SALES WITH AVERAGE SALES – IF GREATER THAN “ABOVE AVERAGE” and LESSER THAN “BELOW AVERAGE”
SELECT 
    day_of_month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS sales_status,
    total_sales
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM 
        coffee_shop_sales
    WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;

### SALES ANALYSIS BY PRODUCT CATEGORY 
SELECT 
	product_category,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5 
GROUP BY product_category
ORDER BY SUM(unit_price * transaction_qty) DESC;

### SALES ANALYSIS BY PARTICULAR PRODUCT CATEGORY 
SELECT 
	product_type,
	SUM(unit_price * transaction_qty) as Total_Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5 AND product_category = 'Coffee' 
GROUP BY product_type
ORDER BY SUM(unit_price * transaction_qty) DESC;

### SALES BY PRODUCTS (TOP 10)
SELECT 
	product_type,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5 
GROUP BY product_type
ORDER BY SUM(unit_price * transaction_qty) DESC LIMIT 10;

### SALES BY DAY | HOUR
SELECT 
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales,
    SUM(transaction_qty) AS Total_Quantity,
    COUNT(*) AS Total_Orders
FROM 
    coffee_shop_sales
WHERE 
    DAYOFWEEK(transaction_date) = 3 -- Filter for Tuesday (1 is Sunday, 2 is Monday, ..., 7 is Saturday)
    AND HOUR(transaction_time) = 8 -- Filter for hour number 8
    AND MONTH(transaction_date) = 5; -- Filter for May (month number 5)

# 1)TO GET SALES FOR ALL HOURS FOR MONTH OF MAY
SELECT 
    HOUR(transaction_time) AS Hour_of_Day,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY HOUR(transaction_time)
ORDER BY HOUR(transaction_time);

# 2)TO GET SALES FROM MONDAY TO SUNDAY FOR MONTH OF MAY
SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;
