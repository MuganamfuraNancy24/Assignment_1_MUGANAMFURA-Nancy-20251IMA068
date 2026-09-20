
SQL
CREATE TABLE customers (
  customer_id NUMBER PRIMARY KEY,
  customer_name VARCHAR2(100),
  email VARCHAR2(100),
  city VARCHAR2(50)
);
INSERT INTO customers VALUES (1, 'Jean Pierre', 'jean@gmail.com', 'Kigali');
INSERT INTO customers VALUES (2, 'Alice Uwase', 'alice@gmail.com', 'Musanze');
INSERT INTO customers VALUES (3, 'Eric Niyonzima', 'eric@gmail.com', 'Huye');
INSERT INTO customers VALUES (4, 'Diane Mukamana', 'diane@gmail.com', 'Muhanga');
INSERT INTO customers VALUES (5, 'Patrick Habimana', 'patrick@gmail.com', 'Rubavu');
INSERT INTO customers VALUES (6, 'Grace Ingabire', 'grace@gmail.com', 'Kigali');

COMMIT;

CREATE TABLE products (
  product_id NUMBER PRIMARY KEY,
  product_name VARCHAR2(100),
  category VARCHAR2(50),
  price NUMBER(10,2)
);
INSERT INTO products VALUES (1, 'Rice 5kg', 'Food', 8500);
INSERT INTO products VALUES (2, 'Sugar 2kg', 'Food', 3000);
INSERT INTO products VALUES (3, 'Cooking Oil 1L', 'Food', 4500);

INSERT INTO products VALUES (4, 'Soap', 'Cleaning', 1500);
INSERT INTO products VALUES (5, 'Detergent', 'Cleaning', 5000);

INSERT INTO products VALUES (6, 'Milk 1L', 'Beverages', 1800);
INSERT INTO products VALUES (7, 'Juice 1L', 'Beverages', 2500);

INSERT INTO products VALUES (8, 'Notebook', 'Stationery', 1200);

COMMIT;
CREATE TABLE orders (
  order_id NUMBER PRIMARY KEY,
  customer_id NUMBER REFERENCES customers(customer_id),
  order_date DATE
);
INSERT INTO orders VALUES (1, 1, DATE '2026-01-05');
INSERT INTO orders VALUES (2, 2, DATE '2026-01-07');
INSERT INTO orders VALUES (3, 3, DATE '2026-01-10');
INSERT INTO orders VALUES (4, 1, DATE '2026-01-15');
INSERT INTO orders VALUES (5, 4, DATE '2026-01-18');

INSERT INTO orders VALUES (6, 5, DATE '2026-01-20');
INSERT INTO orders VALUES (7, 2, DATE '2026-01-23');
INSERT INTO orders VALUES (8, 3, DATE '2026-01-25');
INSERT INTO orders VALUES (9, 1, DATE '2026-02-01');
INSERT INTO orders VALUES (10, 4, DATE '2026-02-05');

INSERT INTO orders VALUES (11, 5, DATE '2026-02-10');
INSERT INTO orders VALUES (12, 2, DATE '2026-02-15');
INSERT INTO orders VALUES (13, 3, DATE '2026-02-20');
INSERT INTO orders VALUES (14, 1, DATE '2026-02-25');
INSERT INTO orders VALUES (15, 5, DATE '2026-03-01');

COMMIT;
CREATE TABLE order_items (
  order_item_id NUMBER PRIMARY KEY,
  order_id NUMBER REFERENCES orders(order_id),
  product_id NUMBER REFERENCES products(product_id),
  quantity NUMBER
);
INSERT INTO order_items VALUES (1, 1, 1, 2);
INSERT INTO order_items VALUES (2, 1, 6, 3);

INSERT INTO order_items VALUES (3, 2, 2, 2);
INSERT INTO order_items VALUES (4, 2, 4, 3);

INSERT INTO order_items VALUES (5, 3, 3, 2);
INSERT INTO order_items VALUES (6, 3, 7, 2);

INSERT INTO order_items VALUES (7, 4, 1, 1);
INSERT INTO order_items VALUES (8, 4, 5, 2);

INSERT INTO order_items VALUES (9, 5, 8, 5);
INSERT INTO order_items VALUES (10, 5, 6, 2);

INSERT INTO order_items VALUES (11, 6, 1, 3);
INSERT INTO order_items VALUES (12, 6, 2, 2);

INSERT INTO order_items VALUES (13, 7, 4, 4);
INSERT INTO order_items VALUES (14, 7, 7, 3);

INSERT INTO order_items VALUES (15, 8, 3, 1);
INSERT INTO order_items VALUES (16, 8, 6, 4);

INSERT INTO order_items VALUES (17, 9, 1, 2);
INSERT INTO order_items VALUES (18, 9, 3, 2);

INSERT INTO order_items VALUES (19, 10, 5, 2);
INSERT INTO order_items VALUES (20, 10, 8, 3);

INSERT INTO order_items VALUES (21, 11, 2, 4);
INSERT INTO order_items VALUES (22, 11, 7, 2);

INSERT INTO order_items VALUES (23, 12, 1, 1);
INSERT INTO order_items VALUES (24, 12, 4, 3);

INSERT INTO order_items VALUES (25, 13, 3, 2);
INSERT INTO order_items VALUES (26, 13, 6, 3);

INSERT INTO order_items VALUES (27, 14, 1, 2);
INSERT INTO order_items VALUES (28, 14, 5, 1);

INSERT INTO order_items VALUES (29, 15, 2, 3);
INSERT INTO order_items VALUES (30, 15, 7, 4);

COMMIT;
JOIN queries
1
List every order with the customer's name, city, and order date (INNER JOIN: orders + customers).
SELECT 
    o.order_id,
    c.customer_name,
    c.city,
    o.order_date
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
ORDER BY o.order_date;
2
List every order item with product name, category, price, and quantity (JOIN: order_items + products).
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
3
List all customers and their orders where they exist, including customers with no orders (LEFT JOIN: customers + orders).
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

CTE query
1
Calculate each customer's total spend (quantity x price) and return customers above average spend. Use a CTE to compute customer totals first.
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
Window-function queries
1
Rank customers by total amount spent, highest first.
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
2
Number each customer's orders in the order placed.
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
3
Show a running total of revenue over time, ordered by order date.
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
4
For each customer with more than one order, show days between the current and previous order. 
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