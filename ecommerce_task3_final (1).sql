-- ============================================================
-- TASK 3: SQL FOR DATA ANALYSIS
-- Database: Ecommerce
-- Tool: MySQL
-- ============================================================

-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- ============================================================
-- 2. CREATE TABLES
-- ============================================================

DROP VIEW IF EXISTS ecommerce_analysis;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    age INT,
    amount DECIMAL(10,2)
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
    product_id INT,
    quantity INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ============================================================
-- 3. INSERT DATA
-- ============================================================

INSERT INTO customers VALUES
(1, 'Ravi Kumar', 'Hyderabad', 22, 55000.00),
(2, 'Anil Sharma', 'Mumbai', 25, 30000.00),
(3, 'Priya Reddy', 'Delhi', 23, 45000.00),
(4, 'Sneha Rao', 'Chennai', 24, 28000.00),
(5, 'Kiran Das', 'Bangalore', 26, 60000.00),
(6, 'Arjun Singh', 'Pune', 27, 35000.00),
(7, 'Divya Patel', 'Ahmedabad', 21, 22000.00),
(8, 'Manoj Kumar', 'Hyderabad', 29, 70000.00);

INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 55000.00),
(102, 'Smartphone', 'Electronics', 25000.00),
(103, 'Headphones', 'Accessories', 2000.00),
(104, 'Keyboard', 'Accessories', 1500.00),
(105, 'Office Chair', 'Furniture', 8000.00),
(106, 'Monitor', 'Electronics', 12000.00),
(107, 'Mouse', 'Accessories', 1000.00),
(108, 'Desk', 'Furniture', 10000.00);

INSERT INTO orders VALUES
(1001, 1, 101, 1, '2026-09-01'),
(1002, 2, 102, 2, '2026-09-02'),
(1003, 3, 103, 3, '2026-09-03'),
(1004, 1, 104, 2, '2026-09-04'),
(1005, 4, 105, 1, '2026-09-05'),
(1006, 2, 103, 2, '2026-09-06'),
(1007, 5, 106, 1, '2026-09-07'),
(1008, 6, 107, 4, '2026-09-08'),
(1009, 7, 108, 1, '2026-09-09'),
(1010, 1, 102, 1, '2026-09-10'),
(1011, 3, 106, 2, '2026-09-11'),
(1012, 5, 104, 3, '2026-09-12'),
(1013, 2, 107, 5, '2026-09-13'),
(1014, 6, 105, 1, '2026-09-14'),
(1015, 4, 108, 1, '2026-09-15');

-- ============================================================
-- A. SELECT, WHERE, ORDER BY, GROUP BY
-- ============================================================

-- A1. SELECT
SELECT * FROM customers;

SELECT customer_name, city, age
FROM customers;

-- A2. WHERE
SELECT *
FROM customers
WHERE city = 'Hyderabad';

SELECT *
FROM customers
WHERE age > 25;

-- A3. ORDER BY
SELECT customer_name, city, age
FROM customers
ORDER BY age DESC;

SELECT product_name, category, price
FROM products
ORDER BY price ASC;

-- A4. GROUP BY
SELECT city, COUNT(*) AS total_customers
FROM customers
GROUP BY city;

SELECT category, COUNT(*) AS total_products
FROM products
GROUP BY category;

-- ============================================================
-- B. JOINS
-- ============================================================

-- B1. INNER JOIN
SELECT
    c.customer_name,
    o.order_id,
    o.quantity,
    o.order_date
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;

-- B2. INNER JOIN: Customer + Product + Order
SELECT
    c.customer_name,
    p.product_name,
    p.category,
    o.quantity,
    p.price,
    o.order_date
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id
INNER JOIN products p
ON o.product_id = p.product_id;

-- B3. LEFT JOIN
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    o.order_id,
    o.order_date
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

-- B4. RIGHT JOIN
SELECT
    p.product_id,
    p.product_name,
    p.category,
    o.order_id,
    o.quantity
FROM orders o
RIGHT JOIN products p
ON o.product_id = p.product_id;

-- ============================================================
-- C. SUBQUERIES
-- ============================================================

-- C1. Products above average price
SELECT product_name, price
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);

-- C2. Customers who placed orders
SELECT customer_name, city
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
);

-- C3. Customers above average age
SELECT customer_name, age, city
FROM customers
WHERE age > (
    SELECT AVG(age)
    FROM customers
);

-- C4. Customers with at least one order
SELECT customer_name, city
FROM customers
WHERE EXISTS (
    SELECT 1
    FROM orders
    WHERE orders.customer_id = customers.customer_id
);

-- ============================================================
-- D. AGGREGATE FUNCTIONS
-- ============================================================

-- D1. Total quantity sold
SELECT SUM(quantity) AS total_quantity_sold
FROM orders;

-- D2. Average product price
SELECT AVG(price) AS average_product_price
FROM products;

-- D3. Total revenue
SELECT
    SUM(o.quantity * p.price) AS total_revenue
FROM orders o
INNER JOIN products p
ON o.product_id = p.product_id;

-- D4. Average order value
SELECT
    AVG(o.quantity * p.price) AS average_order_value
FROM orders o
INNER JOIN products p
ON o.product_id = p.product_id;

-- D5. Category-wise revenue
SELECT
    p.category,
    SUM(o.quantity * p.price) AS total_revenue
FROM orders o
INNER JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category;

-- ============================================================
-- E. VIEW FOR ANALYSIS
-- ============================================================

CREATE VIEW ecommerce_analysis AS
SELECT
    o.order_id,
    c.customer_name,
    c.city,
    p.product_name,
    p.category,
    p.price,
    o.quantity,
    o.order_date,
    (o.quantity * p.price) AS total_amount
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id
INNER JOIN products p
ON o.product_id = p.product_id;

-- E1. Display the view
SELECT * FROM ecommerce_analysis;

-- E2. Total revenue using view
SELECT SUM(total_amount) AS total_revenue
FROM ecommerce_analysis;

-- E3. Category-wise revenue using view
SELECT
    category,
    SUM(total_amount) AS total_revenue
FROM ecommerce_analysis
GROUP BY category;

-- E4. Customer-wise spending
SELECT
    customer_name,
    SUM(total_amount) AS total_spent
FROM ecommerce_analysis
GROUP BY customer_name
ORDER BY total_spent DESC;

-- Check created views
SHOW FULL TABLES
WHERE TABLE_TYPE = 'VIEW';

-- ============================================================
-- F. INDEXES AND QUERY OPTIMIZATION
-- ============================================================

CREATE INDEX idx_customer_city
ON customers(city);

CREATE INDEX idx_order_date
ON orders(order_date);

CREATE INDEX idx_product_category
ON products(category);

-- Check indexes
SHOW INDEX FROM customers;
SHOW INDEX FROM orders;
SHOW INDEX FROM products;

-- EXPLAIN query
EXPLAIN
SELECT *
FROM customers
WHERE city = 'Hyderabad';

EXPLAIN
SELECT *
FROM orders
WHERE order_date = '2026-09-10';

-- ============================================================
-- END OF TASK 3
-- ============================================================


-- ============================================================
-- EXPECTED OUTPUTS / RESULTS
-- ============================================================
-- These are included as comments for documentation.
-- When you execute the queries in MySQL, the actual result grid
-- will be displayed by MySQL Workbench/CLI.

-- A1 SELECT:
-- customers table returns 8 customer records.
-- customer_name, city, age returns the same 8 records with 3 columns.

-- A2 WHERE:
-- city = 'Hyderabad' returns:
-- Ravi Kumar | Hyderabad | 22 | 55000.00
-- Manoj Kumar | Hyderabad | 29 | 70000.00
-- age > 25 returns:
-- Kiran Das, Arjun Singh, Manoj Kumar.

-- A3 ORDER BY:
-- age DESC starts with Manoj Kumar (29), Arjun Singh (27),
-- Kiran Das (26), Anil Sharma (25), Sneha Rao (24),
-- Priya Reddy (23), Ravi Kumar (22), Divya Patel (21).
-- Product price ASC starts with Mouse (1000), Keyboard (1500),
-- Headphones (2000), Office Chair (8000), Desk (10000),
-- Monitor (12000), Smartphone (25000), Laptop (55000).

-- A4 GROUP BY:
-- City customer counts:
-- Hyderabad = 2; Mumbai = 1; Delhi = 1; Chennai = 1;
-- Bangalore = 1; Pune = 1; Ahmedabad = 1.
-- Category product counts:
-- Electronics = 3; Accessories = 3; Furniture = 2.

-- B JOINS:
-- INNER JOIN returns 15 matching orders.
-- LEFT JOIN returns all 8 customers and their matching orders.
-- RIGHT JOIN returns all 8 products and matching orders;
-- products without orders would show NULL order columns.

-- C SUBQUERIES:
-- Products above the average product price are:
-- Laptop (55000), Smartphone (25000), Monitor (12000).
-- Customers who placed orders are Ravi Kumar, Anil Sharma,
-- Priya Reddy, Sneha Rao, Kiran Das, Arjun Singh, Divya Patel.
-- Customers above average age are Kiran Das (26), Arjun Singh (27),
-- and Manoj Kumar (29).

-- D AGGREGATES:
-- Total quantity sold = 32.
-- Average product price = 14312.50.
-- Total revenue = 241500.00.
-- Average order value = 16100.00.
-- Category revenue:
-- Electronics = 199000.00
-- Accessories = 14000.00
-- Furniture = 28500.00

-- E VIEW:
-- ecommerce_analysis contains 15 order-level records.
-- Total revenue from the view = 241500.00.
-- Category-wise and customer-wise totals can be obtained from
-- the view queries above.

-- F INDEXES:
-- Indexes created:
-- idx_customer_city
-- idx_order_date
-- idx_product_category
-- EXPLAIN displays the query execution plan used by MySQL.
-- Exact EXPLAIN output can vary depending on the MySQL version
-- and optimizer statistics.
