# Task 3 - SQL for Data Analysis

## Project Overview

This project demonstrates the use of SQL for data analysis using a sample E-commerce database in MySQL.

The project covers data retrieval, filtering, sorting, grouping, joining tables, subqueries, aggregate functions, views, and query optimization using indexes.

## Database

**Database Name:** `ecommerce_db`

### Tables Used

#### 1. Customers
Contains customer information such as:
- Customer ID
- Customer Name
- City
- Age
- Amount

#### 2. Products
Contains product information such as:
- Product ID
- Product Name
- Category
- Price

#### 3. Orders
Contains order information such as:
- Order ID
- Customer ID
- Product ID
- Quantity
- Order Date

## SQL Concepts Implemented

### A. Basic SQL Queries
- SELECT
- WHERE
- ORDER BY
- GROUP BY

### B. Joins
- INNER JOIN
- LEFT JOIN
- RIGHT JOIN

### C. Subqueries
- Products above the average price
- Customers who placed orders
- Customers above the average age
- EXISTS subquery

### D. Aggregate Functions
- SUM()
- AVG()
- COUNT()

### E. Views

Created an `ecommerce_analysis` view by combining the Customers, Products, and Orders tables.

The view is used for:
- Total revenue analysis
- Category-wise revenue
- Customer-wise spending

### F. Query Optimization

Indexes were created on frequently searched columns:

- `customers(city)`
- `orders(order_date)`
- `products(category)`

The `EXPLAIN` command was also used to analyze query execution plans.

## Tools Used

- MySQL
- MySQL Command Line Client / MySQL Workbench
- GitHub

## Project Files

- `ecommerce_task3_final.sql` - Complete SQL code and documented outputs
- `README.md` - Project documentation
- `screenshots/` - Screenshots of SQL query outputs

## Conclusion

This project demonstrates how SQL can be used to retrieve, filter, organize, combine, summarize, and analyze data in an E-commerce database.

It also demonstrates the use of views and indexes to support data analysis and query optimization.
