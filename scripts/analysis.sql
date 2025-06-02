/*
================================================================================
> Script Name   : analysis.sql
> Purpose       : This script performs basic analysis on restaurant orders and menu items

> Actions Performed:
   - Analyzes the menu_items table for:
       • Total number of unique items
       • Most and least expensive items overall and within Italian category
       • Category-wise count and average price of items
   - Analyzes the order_details table for:
       • Range and duration of orders
       • Total orders and items served
       • Orders with high item counts (>12)
   - Joins menu_items with order_details to create a temporary table for further analysis
   - Identifies:
       • Most and least ordered items
       • Orders with the highest total bill amount
       • Top 5 customers by total bill and their itemized orders
================================================================================
*/

-- Analyzing menu_items table
----------------------------------------------------
-- Identifying total items
SELECT 
COUNT(DISTINCT item_name) AS Total_Item
FROM menu_items
;

-- Identifying least and most expensive item
SELECT 
'Least Expensive Item' AS Category,
item_name AS Item,
price AS Price
FROM menu_items
WHERE price = (SELECT MIN(price) FROM menu_items)

UNION

SELECT 
'Most Expensive Item' AS Category,
item_name AS Item,
price AS Price
FROM menu_items
WHERE price = (SELECT MAX(price) FROM menu_items) 
;

-- Identifying total italian items
SELECT 
COUNT(menu_item_id) AS Italian_Items
FROM menu_items
WHERE category = 'Italian'
;

-- Identifying least and most expensive italian item
SELECT 
'Least Expensive Italian Item' AS Category,
item_name AS Item,
price AS Price
FROM menu_items
WHERE category = 'Italian'
AND price = (SELECT MIN(price) FROM menu_items WHERE category = 'Italian')

UNION

SELECT 
'Most Expensive Italian Item' AS Category,
item_name AS Item,
price AS Price
FROM menu_items
WHERE category = 'Italian'
AND price = (SELECT MAX(price) FROM menu_items WHERE category = 'Italian') 
;

-- Calculating total count and average price of food item for each category
SELECT 
category AS Category ,
COUNT(menu_item_id) AS Count,
ROUND(AVG(price),2) AS Average_Price
FROM menu_items
GROUP BY category
ORDER BY 1
;

----------------------------------------------------
-- Analyzing order_details table
----------------------------------------------------
-- Identifying order range
SELECT 
MIN(order_date),
MAX(order_date)
FROM order_details
;

-- Calculating the number of days between the first and last order
SELECT 
DATEDIFF(MAX(order_date),MIN(order_date))
FROM order_details
;

-- Calculating the total number of orders and food items served
SELECT 
COUNT(DISTINCT order_id) AS Total_Orders,
COUNT(item_id) AS Total_Items_Served
FROM order_details
;

-- Counting number of items ordered for each order
SELECT 
order_id,
COUNT(item_id) AS Total_Items_Ordered
FROM order_details
GROUP BY order_id
ORDER BY Total_Items_Ordered DESC
;

-- Identifying orders where items ordered are greater than 12
SELECT 
order_id,
Total_Items_Ordered
FROM(SELECT
order_id,
COUNT(item_id) AS Total_Items_Ordered
FROM order_details
GROUP BY order_id) as tble
WHERE Total_Items_Ordered > 12
;

-------------------------------------------------------
-- Analyzing the joined table of menu and order details
-------------------------------------------------------
-- Joining order_details and menu_items tables
SELECT 
t1.order_details_id,
t1.order_id,
t1.order_date,
t1.order_time,
t2.item_name,
t2.category,
t2.price
FROM order_details t1
LEFT JOIN menu_items t2
	ON t1.item_id = t2.menu_item_id
;

-- Creating a temporary table by joining order details with menu items for further analysis
CREATE TEMPORARY TABLE joint_table AS 
SELECT 
t1.order_details_id,
t1.order_id,
t1.order_date,
t1.order_time,
t2.item_name,
t2.category,
t2.price
FROM order_details t1
LEFT JOIN menu_items t2
	ON t1.item_id = t2.menu_item_id
;

-- Identifying least and most ordered food item
SELECT 
category,
item_name,
COUNT(order_details_id) AS Total_Item_Ordered
FROM joint_table
GROUP BY category,item_name
ORDER BY 3
;

-- Calculate total bill amount per order and display top 5 orders by highest bill
SELECT 
order_id,
SUM(price) AS Total_Bill
FROM joint_table
GROUP BY order_id
ORDER BY 2 DESC
LIMIT 5
;

-- Analyzing top 5 customers by total bill amount
SELECT 
order_id,
item_name,
category,
price
FROM joint_table
WHERE order_id IN (440,2075,1957,330,2675)
ORDER BY 1,3
;
