SELECT * FROM COFFEE_SHOP_SALES;

/*  Safe mode in MySQL Workbench is designed to help prevent accidental data modifications that can lead to data loss or unintended consequences. 
    It provides an additional layer of protection by enforcing certain restrictions when executing potentially risky SQL statements, 
    especially those that could modify or delete large amounts of data without a clear specification.
*/
# Mostly 'UPDATE' and 'DELETE' clause need for safe mode when 'WHERE' clause is not used.
SET SQL_SAFE_UPDATES = 0; 
-- The safe mode is used because we do not use where clause which creates trouble for updating the table.

-- THIS QUERY IS USED TO CHANGE THE DATE FORMAT IN TABLE.
UPDATE COFFEE_SHOP_SALES
SET TRANSACTION_DATE = STR_TO_DATE(TRANSACTION_DATE, '%d-%m-%Y');

ALTER TABLE COFFEE_SHOP_SALES
MODIFY COLUMN transaction_date DATE;

# THIS QUERY IS USED TO CHANGE THE TIME FORMAT IN THE TABLE. 
UPDATE COFFEE_SHOP_SALES
SET TRANSACTION_TIME = STR_TO_DATE(TRANSACTION_TIME, '%H.%i.%s');

ALTER TABLE COFFEE_SHOP_SALES
MODIFY COLUMN transaction_time TIME;

# CHANGING NAME OF TRANSACTION_ID
ALTER TABLE COFFEE_SHOP_SALES
CHANGE COLUMN ï»¿transaction_id transaction_id INT;

### TOTAL SALES ANALYSIS
# 1) CALCULATE THE TOTAL SALES FOR EACH RESPECTIVE MONTH.
SELECT ROUND(SUM(unit_price * transaction_qty),1) AS Total_Sales
FROM COFFEE_SHOP_SALES
WHERE MONTH(transaction_date) = 3; -- March Month

# 2) CALCULATE THE DIFFERENCE IN SALES BETWEEN THE SELECTED MONTH AND THE PREVIOUS MONTH.
-- TOTAL SALES KPI - MONTH DIFFERENCE AND MONTH GROWTH
SELECT 
	MONTH(transaction_date) AS month, -- NUMBER OF MONTH
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales, -- TOTAL SALES COLUMN
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1) -- MONTH SALES DIFFERENCE
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) -- DIVISION BY PREVIOUS MONTH SALES
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS month_increase_percentage -- PERCENTAGE
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April(PREVIOUS MONTH) and May(CURRENT MONTH)
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);

### TOTAL ORDERS ANALYSIS
# 1) CALCULATE THE TOTAL NUMBER OF ORDERS FOR EACH RESPECTIVE MONTH.
SELECT COUNT(TRANSACTION_ID) AS TOTAL_ORDERS
FROM COFFEE_SHOP_SALES
WHERE MONTH(transaction_date) = 5; -- May Month

# 2) DETERMINE THE MONTH ON MONTH INCREASE OR DECREASE IN THE NUMBER OF ORDERS.
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(COUNT(transaction_id)) AS total_orders,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);

### TOTAL QUANTITY SOLD ANALYSIS
# 1) CALCULATE THE TOTAL QUANTITY SOLD FOR EACH RESPECTIVE MONTH.
SELECT SUM(transaction_qty) as Total_Quantity_Sold
FROM coffee_shop_sales 
WHERE MONTH(transaction_date) = 5; -- MAY MONTH

# 2) DETERMINE THE MONTH ON MONTH INCREASE OR DECREASE IN THE TOTAL QUANTITY SOLD.
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(transaction_qty)) AS total_quantity_sold,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5)   -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
    