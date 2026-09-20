# Assignment_1_MUGANAMFURA-Nancy-20251IMA068
# PL/SQL Assignment One – Sunrise Supermarket
.Name: Muganamfura Nancy
Student ID: 20251IMA068
Database Management System i used : Oracle Database 21c & sql developer
## Summary of What I Did
I created a Sunrise Supermarket database using Oracle Database 21c. I created and populated tables for customers, products, orders, and order items. I used JOINs, a CTE, and a window function to analyze customer purchases, spending, and sales trends. I also interpreted the results from a business perspective.
## how to run it 
Open Oracle SQL Developer, connect to Oracle Database 21c, and run the SQL script provided in this repository. Execute the table creation, data insertion, and analysis queries to view the results.
## 5. Database Tables
The database contains the following tables:
Customers: Stores customer information such as customer ID, name, email, and city.[Screenshot](https://github.com/MuganamfuraNancy24/Assignment_1_MUGANAMFURA-Nancy-20251IMA068/blob/648c382a12c05dee97d0433ab47ba179a97a9d91/Screenshot%202026-09-18.png)
Products : Stores product information such as product ID, product name, category, and price.[Screenshot] (https://github.com/MuganamfuraNancy24/Assignment_1_MUGANAMFURA-Nancy-20251IMA068/blob/90882cef5f49778973e3e66dfecf985f6c2c7c86/Screenshot%202026-09-19%20140526.png)
Orders:Stores customer orders and the dates on which they were placed.
[Screenshot] (https://github.com/MuganamfuraNancy24/Assignment_1_MUGANAMFURA-Nancy-20251IMA068/blob/b975bae1bed03a8fb96519195f1ddd4f349bc946/Screenshot%202026-09-19%20140601.png)
Order Items:Stores the individual products included in each order, including the quantity. [Screenshot] (https://github.com/MuganamfuraNancy24/Assignment_1_MUGANAMFURA-Nancy-20251IMA068/blob/238f8210cc0aff09f819ad26c5f8472202675b6c/Screenshot%202026-09-19%20140643.png)
##JOIN Queries
Query 1:This query uses an INNER JOIN to display order information together with the customer who placed each order.
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
Query 2:
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
##CTE Query
