# E-Commerce Sales & Customer Analytics

## 📌 Project Overview

This project focuses on analyzing e-commerce sales, customer behavior, product performance, order status, and geographic sales using **MySQL**.

The project demonstrates how raw CSV datasets can be imported into a relational database, checked for data-quality issues, cleaned, and analyzed using SQL to generate meaningful business insights.

---

## 🎯 Project Objectives

- Analyze overall sales and order performance
- Identify top-performing products and categories
- Analyze customer purchasing behavior
- Identify repeat and high-value customers
- Analyze cancelled and pending orders
- Compare sales across states and cities
- Perform customer segmentation based on delivered spending
- Use advanced SQL concepts such as **CTEs, Window Functions, RANK, and LAG**

---

## 🛠️ Tools & Technologies

- **MySQL**
- **MySQL Workbench**
- **SQL**
- CSV datasets

### SQL Concepts Used

- SELECT
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- JOIN
- LEFT JOIN
- CASE WHEN
- Aggregate Functions
- Subqueries
- CTEs
- Window Functions
- RANK()
- LAG()

---

## 📂 Dataset

The project uses four CSV datasets:

| Dataset | Records | Description |
|---|---:|---|
| Customers | 100 | Customer details such as name, city, state and signup date |
| Products | 30 | Product details including category and price |
| Orders | 300 | Order information including date, customer and order status |
| Order Items | 642 | Product-level details for each order |

---

## 🗂️ Database Structure

The project contains four relational tables:

```text
customers
    │
    │ customer_id
    ▼
orders
    │
    │ order_id
    ▼
order_items
    │
    │ product_id
    ▼
products
```

### Table Relationships

- `customers.customer_id` → `orders.customer_id`
- `orders.order_id` → `order_items.order_id`
- `products.product_id` → `order_items.product_id`

The `order_items` table allows one order to contain multiple products.

---

## 🔍 Data Quality & Cleaning

Before performing business analysis, the datasets were profiled to identify potential data-quality issues.

### Checks Performed

- Missing values
- Duplicate IDs
- Repeated customer names
- Invalid product prices
- Invalid quantities
- Invalid unit prices
- Invalid foreign-key references
- Date ranges
- Category and state distributions

### Data Cleaning Performed

Two missing city values were handled by replacing the blank city values with:

```text
Unknown
```

One missing state value was identified and corrected based on the available customer information.

The remaining datasets were found to be largely clean after validation.

---

## 📊 Business Analysis

The project answers several business questions, including:

1. How many customers are registered?
2. How many products are available?
3. How many orders were placed?
4. What is the order-status distribution?
5. What is the total delivered sales revenue?
6. What is the Average Order Value (AOV)?
7. What is the monthly sales trend?
8. Which are the top 5 products by sales revenue?
9. Which product categories generate the highest revenue?
10. Which customers generate the highest revenue?
11. How many customers are repeat customers?
12. What is the cancellation rate?
13. What is the pending-order rate?
14. Which states generate the highest sales?
15. Which cities generate the highest sales?
16. What is the relationship between order frequency and customer spending?
17. How can customers be segmented based on delivered spending?

---

## 📈 Key Insights

### 💰 Sales Performance

- Total delivered sales revenue: **₹820,049.35**
- Average Order Value: **₹4,316.05**
- Total orders: **300**

### 📦 Order Status

- Delivered: **190 orders (63.3%)**
- Cancelled: **59 orders (19.7%)**
- Pending: **51 orders (17.0%)**

### 📅 Monthly Sales

- Highest monthly sales: **July — ₹92,292.90**
- Second-highest: **April — ₹91,262.95**
- Lowest monthly sales: **January — ₹47,420.70**

### 🏆 Top Product

**Gaming Keyboard** generated the highest delivered sales revenue at approximately **₹59,476.20**.

### 🗂️ Top Category

**Electronics** was the highest-performing category with approximately **₹207,367.30** in delivered sales.

### 👤 Customer Performance

**Diya Kulkarni** generated the highest delivered sales at approximately **₹31,796.95**.

### 🔁 Customer Retention

**78 out of 100 customers** placed more than one order, giving a repeat-customer rate of **78%** based on placed orders.

### 🌍 Geographic Performance

**Maharashtra** generated the highest delivered sales at approximately **₹276,791.00**.

Among named cities, **Delhi** generated the highest delivered sales at approximately **₹95,598.25**.

### 👥 Customer Segmentation

Customers were segmented according to delivered spending:

- **High Value:** ₹20,000+
- **Medium Value:** ₹10,000–₹19,999
- **Low Value:** Below ₹10,000

The analysis showed a larger proportion of customers in the Low Value segment, with a smaller group of High Value customers.

---

## 🚀 Advanced SQL Analysis

The project also demonstrates advanced SQL techniques.

### CTE

A Common Table Expression was used to calculate customer-level delivered spending in a structured and readable way.

### RANK()

The `RANK()` window function was used to assign sales rankings to customers based on delivered spending.

### LAG()

The `LAG()` window function was used to compare monthly sales with the previous month and identify month-over-month increases and decreases.

---

## 💡 Business Recommendations

Based on the analysis:

- Focus on high-value customers through targeted retention strategies.
- Monitor the relatively high cancellation rate of **19.67%**.
- Monitor pending orders, which account for **17%** of total orders.
- Investigate factors contributing to monthly sales fluctuations.
- Continue focusing on strong-performing categories such as Electronics and Home & Kitchen.
- Collect additional information such as cancellation reasons to enable deeper operational analysis.

---

## 📁 Project Structure

```text
E-Commerce-Sales-Customer-Analytics/
│
├── dataset/
│   ├── customers.csv
│   ├── products.csv
│   ├── orders.csv
│   └── order_items.csv
│
├── sql/
│   └── ecommerce_sales_customer_analysis.sql
│
└── README.md
```

---

## 🎓 Key Learning Outcomes

Through this project, I practiced:

- Designing relational database tables
- Working with primary and foreign keys
- Importing CSV data into MySQL
- Performing data profiling and cleaning
- Writing multi-table JOIN queries
- Performing business-oriented SQL analysis
- Using subqueries and CASE statements
- Applying CTEs and window functions
- Converting raw data into actionable business insights

---

## 👩‍💻 Author

**Aboli Mahabole**

B.Tech Computer Science & Engineering  
Aspiring Data Analyst