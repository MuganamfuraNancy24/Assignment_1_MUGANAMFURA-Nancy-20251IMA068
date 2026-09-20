# Assignment_1_MUGANAMFURA-Nancy-20251IMA068
# PL/SQL Assignment One – Sunrise Supermarket
.Name: Muganamfura Nancy
Student ID: 20251IMA068
Database Management System i used : Oracle Database 21c & sql developer
## Summary of What I Did
I created a Sunrise Supermarket database using Oracle Database 21c. I created and populated tables for customers, products, orders, and order items. I used JOINs, a CTE, and a window function to analyze customer purchases, spending, and sales trends. I also interpreted the results from a business perspective.
## how to run it 
Open Oracle SQL Developer, connect to Oracle Database 21c, and run the SQL script provided in this repository. Execute the table creation, data insertion, and analysis queries to view the results.
## Database Tables
The database contains the following tables:
# Customers:
Stores customer information such as customer ID, name, email, and city. 
[Screenshot](https://github.com/MuganamfuraNancy24/Assignment_1_MUGANAMFURA-Nancy-20251IMA068/blob/abf7ab9fdb82835ec41fa5c61aa3c852e45fd2fb/Screenshot%202026-09-20%20092158.png)
# Products :
Stores product information such as product ID, product name, category, and price.
[Screenshot] (https://github.com/MuganamfuraNancy24/Assignment_1_MUGANAMFURA-Nancy-20251IMA068/blob/90882cef5f49778973e3e66dfecf985f6c2c7c86/Screenshot%202026-09-19%20140526.png)
# Orders:
Stores customer orders and the dates on which they were placed.
[Screenshot] (https://github.com/MuganamfuraNancy24/Assignment_1_MUGANAMFURA-Nancy-20251IMA068/blob/b975bae1bed03a8fb96519195f1ddd4f349bc946/Screenshot%202026-09-19%20140601.png)
# Order Items:
Stores the individual products included in each order, including the quantity. 
[Screenshot] (https://github.com/MuganamfuraNancy24/Assignment_1_MUGANAMFURA-Nancy-20251IMA068/blob/238f8210cc0aff09f819ad26c5f8472202675b6c/Screenshot%202026-09-19%20140643.png)
## JOIN Queries
# Query 1:This query uses an INNER JOIN to display order information together with the customer who placed each order.
SELECT 
    o.order_id,
    c.customer_name,
    c.city,
    o.order_date
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
ORDER BY o.order_date;
[Screenshot] (https://github.com/MuganamfuraNancy24/Assignment_1_MUGANAMFURA-Nancy-20251IMA068/blob/c48886f96dced326d4812616cfcb4ad816be819f/Screenshot%202026-09-20%20082718.png)
The query connects the orders table with the customers table using customer_id. This allows management to see which customer placed each order and the date of the order.
# Query 2:
SELECT
    oi.order_item_id,
    oi.order_id,
    p.product_name,
    p.category,
    p.price,
    oi.quantity
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
ORDER BY oi.order_id;
[Screenshot] (https://github.com/MuganamfuraNancy24/Assignment_1_MUGANAMFURA-Nancy-20251IMA068/blob/ad7953f55d3a84fe1ea01179532142116ff25524/Screenshot%202026-09-20%20084026.png)
This query connects order items with products so that the supermarket can see which products were purchased, their categories, prices, and quantities.
# Query 3:
SELECT
    c.customer_id,
    c.customer_name,
    c.email,
    c.city,
    o.order_id,
    o.order_date
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;
[Screenshot] (https://github.com/MuganamfuraNancy24/Assignment_1_MUGANAMFURA-Nancy-20251IMA068/blob/9f1cec6471e5fefdfccacbc7ab8554d08b8c8195/Screenshot%202026-09-20%20085116.png)
This query uses a LEFT JOIN to list all customers and their orders. Customers who have no orders are also included, with NULL values for the order information.
## CTE Query
WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_spend
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_spend
FROM customer_totals
WHERE total_spend > (
    SELECT AVG(total_spend)
    FROM customer_totals
)
ORDER BY total_spend DESC;
[Screenshot] (https://github.com/MuganamfuraNancy24/Assignment_1_MUGANAMFURA-Nancy-20251IMA068/blob/ad6f76b7ff726406ea708030165f1d45465dd496/Screenshot%202026-09-20%20085858.png)
This query uses a CTE to calculate the total spending of each customer by multiplying the quantity purchased by the product price. It then calculates the average customer spending and returns only customers whose total spending is above the average.
# Window-function queries
# Rank customers by total amount spent, highest first
SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * p.price) AS total_spend,
    RANK() OVER (
        ORDER BY SUM(oi.quantity * p.price) DESC
    ) AS spending_rank
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY spending_rank;
[Screenshot] (https://github.com/MuganamfuraNancy24/Assignment_1_MUGANAMFURA-Nancy-20251IMA068/blob/ed6a70f3024952b7a09ac7d6a0e83cf115436ad6/Screenshot%202026-09-20%20090804.png)
This calculates each customer's total spending and uses RANK() to rank customers from the highest spender to the lowest.
# Number each customer's orders in the order placed
SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date,
    ROW_NUMBER() OVER (
        PARTITION BY c.customer_id
        ORDER BY o.order_date, o.order_id
    ) AS order_number
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_id, order_number;
[Screenshot] (https://github.com/MuganamfuraNancy24/Assignment_1_MUGANAMFURA-Nancy-20251IMA068/blob/c87255a0add3bf130d5a55ac1acad08a2f98f3a5/Screenshot%202026-09-20%20085858.png)
ROW_NUMBER() assigns a sequential number to each customer's orders based on the order date.
# Show a running total of revenue over time
SELECT
    o.order_date,
    SUM(oi.quantity * p.price) AS daily_revenue,
    SUM(SUM(oi.quantity * p.price)) OVER (
        ORDER BY o.order_date
    ) AS running_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.order_date
ORDER BY o.order_date;
[Screenshot] (https://github.com/MuganamfuraNancy24/Assignment_1_MUGANAMFURA-Nancy-20251IMA068/blob/1e40851bc8cbff530d76fec2fb53bdc2ed41b096/Screenshot%202026-09-20%20090804.png)
The query calculates revenue for each order date and then uses a window function to calculate the cumulative revenue over time.
# Show days between the current and previous order for each customer
SELECT
    customer_id,
    customer_name,
    order_id,
    order_date,
    order_date - LAG(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date, order_id
    ) AS days_between_orders
FROM (
    SELECT
        c.customer_id,
        c.customer_name,
        o.order_id,
        o.order_date
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
)
ORDER BY customer_id, order_date;
[Screenshot] (https://github.com/MuganamfuraNancy24/Assignment_1_MUGANAMFURA-Nancy-20251IMA068/blob/63710f618f16cc225dc03eb77c4039ae2eb170ee/Screenshot%202026-09-20%20091042.png)
LAG() retrieves the previous order date for each customer. Subtracting the previous date from the current date gives the number of days between orders. The first order for each customer will have NULL because there is no previous order.
