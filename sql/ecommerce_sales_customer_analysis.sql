
-- =========================================
-- 1. DATABASE & TABLE SETUP
-- =========================================

CREATE DATABASE ecommerce_analytics;

use ecommerce_analytics;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);


CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(30),
    
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);


CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),

    FOREIGN KEY (order_id)
    REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);

-- =========================================
-- 2. DATA IMPORT
-- =========================================
-- Data imported from CSV files using MySQL Table Data Import Wizard.


SELECT
    COUNT(*) AS total_records,
    COUNT(customer_id) AS customer_id_filled,
    COUNT(customer_name) AS name_filled,
    COUNT(city) AS city_filled,
    COUNT(state) AS state_filled,
    COUNT(signup_date) AS signup_date_filled
FROM customers;

-- =========================================
-- 3. DATA QUALITY CHECKS & CLEANING
-- =========================================
SELECT
    customer_id,
    COUNT(*) AS record_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT
    customer_name,
    COUNT(*) AS name_count
FROM customers
GROUP BY customer_name
HAVING COUNT(*) > 1;

SELECT
    MIN(signup_date) AS earliest_signup,
    MAX(signup_date) AS latest_signup
FROM customers;

SELECT
    state,
    COUNT(*) AS customer_count
FROM customers
GROUP BY state
ORDER BY customer_count DESC;

SELECT *
FROM customers
WHERE state IS NULL OR state = '';

UPDATE customers
SET state = 'Karnataka'
WHERE customer_id = 1029;
   
   -- to check null value
SELECT
    customer_id,
    customer_name,
    city,
    state
FROM customers
WHERE city IS NULL
   OR city = '';

UPDATE customers
SET city = 'Unknown'
WHERE city IS NULL
   OR city = '';
   
   SELECT
    customer_id,
    customer_name,
    city,
    state
FROM customers
WHERE city = 'Unknown';

SELECT
    COUNT(*) AS total_records,
    COUNT(product_id) AS product_id_filled,
    COUNT(product_name) AS product_name_filled,
    COUNT(category) AS category_filled,
    COUNT(price) AS price_filled
FROM products;

SELECT
    product_id,
    COUNT(*) AS record_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT *
FROM products
WHERE price <= 0;

SELECT
    category,
    COUNT(*) AS product_count
FROM products
GROUP BY category
ORDER BY product_count DESC;

SELECT
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price,
    AVG(price) AS average_price
FROM products;

SELECT o.customer_id
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

SELECT
    MIN(order_date) AS earliest_order,
    MAX(order_date) AS latest_order
FROM orders;

SELECT
    order_id,
    COUNT(*) AS record_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS total_records,
    COUNT(order_item_id) AS order_item_id_filled,
    COUNT(order_id) AS order_id_filled,
    COUNT(product_id) AS product_id_filled,
    COUNT(quantity) AS quantity_filled,
    COUNT(unit_price) AS unit_price_filled
FROM order_items;

SELECT
    order_item_id,
    COUNT(*) AS record_count
FROM order_items
GROUP BY order_item_id
HAVING COUNT(*) > 1;

SELECT *
FROM order_items
WHERE quantity <= 0;

SELECT *
FROM order_items
WHERE unit_price <= 0;

SELECT oi.order_id
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- =========================================
-- 4. BUSINESS ANALYSIS
-- =========================================
-- 4.1 How many customers are registered on the platform?
SELECT COUNT(*) AS total_customers
FROM customers;

-- 4.2 How many products are available?
SELECT COUNT(*) AS total_products
FROM products;

-- 4.3 How many orders were placed?
SELECT COUNT(*) AS total_orders
FROM orders;

-- 4.4 What is the distribution of order statuses?
SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

-- 4.5 What is the total sales revenue generated from delivered orders?
SELECT
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered';

-- Average Order Value (AOV)
-- 4.6 On average, how much revenue does one delivered order generate?
SELECT
    SUM(oi.quantity * oi.unit_price) / COUNT(DISTINCT o.order_id) AS average_order_value
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered';

-- Monthly Sales Analysis
-- 4.7 What is the monthly sales trend?
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(oi.quantity * oi.unit_price) AS monthly_sales
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

-- 4.8 Which are the top 5 products generating the highest sales revenue?
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_sales DESC
LIMIT 5;

-- 4.9 Which product categories generate the highest sales revenue?
SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY total_sales DESC;

-- 4.10 Which customers generate the highest sales revenue?
SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_sales DESC;

-- 4.11 How many customers have placed more than one order?
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_orders DESC;

-- 4.12 How many orders are cancelled, and what percentage of total orders do they represent?
-- used subquerry
SELECT
    COUNT(*) AS cancelled_orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS cancellation_rate
FROM orders
WHERE order_status = 'Cancelled';

-- 4.13 How many orders are pending, and what percentage of total orders are pending?
SELECT
    COUNT(*) AS pending_orders,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders),
        2
    ) AS pending_rate
FROM orders
WHERE order_status = 'Pending';

-- 4.14 Which states generate the highest delivered sales revenue?
SELECT
    c.state,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.state
ORDER BY total_sales DESC;

-- 4.15 Which cities generate the highest delivered sales?
SELECT
    c.city,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.city
ORDER BY total_sales DESC;

-- 4.16 Which customers place more orders and generate higher delivered spending?
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(
        CASE
            WHEN o.order_status = 'Delivered'
            THEN oi.quantity * oi.unit_price
            ELSE 0
        END
    ) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_spent DESC;

-- 4.17 Can customers be segmented based on their delivered spending?
SELECT
    c.customer_id,
    c.customer_name,
    SUM(
        CASE
            WHEN o.order_status = 'Delivered'
            THEN oi.quantity * oi.unit_price
            ELSE 0
        END
    ) AS total_spent,
    CASE
        WHEN SUM(
            CASE
                WHEN o.order_status = 'Delivered'
                THEN oi.quantity * oi.unit_price
                ELSE 0
            END
        ) >= 20000 THEN 'High Value'
        
        WHEN SUM(
            CASE
                WHEN o.order_status = 'Delivered'
                THEN oi.quantity * oi.unit_price
                ELSE 0
            END
        ) >= 10000 THEN 'Medium Value'
        
        ELSE 'Low Value'
    END AS customer_segment
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_spent DESC;

-- =========================================
-- 5. ADVANCED SQL ANALYSIS
-- =========================================
-- 5.1 Calculate Customer-wise delivered sales in structured way 
WITH customer_sales AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(
            CASE
                WHEN o.order_status = 'Delivered'
                THEN oi.quantity * oi.unit_price
                ELSE 0
            END
        ) AS total_spent
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_spent
FROM customer_sales
ORDER BY total_spent DESC;

-- 5.2 Which customers generate the highest delivered sales?
WITH customer_sales AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(
            CASE
                WHEN o.order_status = 'Delivered'
                THEN oi.quantity * oi.unit_price
                ELSE 0
            END
        ) AS total_spent
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) AS sales_rank
FROM customer_sales
ORDER BY sales_rank;

-- 5.3 How much did sales increase/decrease each month compared to the previous month?

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(oi.quantity * oi.unit_price) AS total_sales
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)

SELECT
    month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY month) AS previous_month_sales,
    ROUND(
        total_sales - LAG(total_sales) OVER (ORDER BY month),
        2
    ) AS sales_change
FROM monthly_sales
ORDER BY month;

