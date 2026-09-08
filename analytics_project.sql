
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id   INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(100) NOT NULL,
    email         VARCHAR(150) UNIQUE NOT NULL,
    city          VARCHAR(80),
    signup_date   DATE NOT NULL
);

CREATE TABLE products (
    product_id    INT PRIMARY KEY AUTO_INCREMENT,
    product_name  VARCHAR(150) NOT NULL,
    category      VARCHAR(80) NOT NULL,
    price         DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock         INT NOT NULL DEFAULT 0 CHECK (stock >= 0)
);

CREATE TABLE orders (
    order_id      INT PRIMARY KEY AUTO_INCREMENT,
    customer_id   INT NOT NULL,
    order_date    DATE NOT NULL,
    status        VARCHAR(30) NOT NULL DEFAULT 'PENDING'
                  CHECK (status IN ('PENDING','COMPLETED','CANCELLED','REFUNDED')),
    total_amount  DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (total_amount >= 0),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id      INT NOT NULL,
    product_id    INT NOT NULL,
    quantity      INT NOT NULL CHECK (quantity > 0),
    unit_price    DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id      INT PRIMARY KEY AUTO_INCREMENT,
    order_id        INT NOT NULL,
    payment_date    DATE NOT NULL,
    amount          DECIMAL(12,2) NOT NULL CHECK (amount >= 0),
    payment_status  VARCHAR(30) NOT NULL DEFAULT 'PENDING'
                    CHECK (payment_status IN ('PENDING','PAID','FAILED','REFUNDED')),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_order_date ON orders(order_date);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_payments_order_id ON payments(order_id);

INSERT INTO customers (name, email, city, signup_date) VALUES
('Aarav Sharma',     'aarav.sharma@example.com',     'Hyderabad', '2023-01-15'),
('Diya Patel',       'diya.patel@example.com',       'Mumbai',    '2023-02-20'),
('Rohan Mehta',      'rohan.mehta@example.com',      'Delhi',     '2023-03-05'),
('Ishita Verma',     'ishita.verma@example.com',     'Bengaluru', '2023-03-18'),
('Kabir Nair',       'kabir.nair@example.com',       'Chennai',   '2023-04-02'),
('Ananya Reddy',     'ananya.reddy@example.com',     'Hyderabad', '2023-05-10'),
('Vivaan Joshi',     'vivaan.joshi@example.com',     'Pune',      '2023-06-01'),
('Saanvi Iyer',      'saanvi.iyer@example.com',      'Chennai',   '2023-06-25'),
('Arjun Kapoor',     'arjun.kapoor@example.com',     'Mumbai',    '2023-07-14'),
('Myra Gupta',       'myra.gupta@example.com',       'Delhi',     '2023-08-09');

INSERT INTO products (product_name, category, price, stock) VALUES
('Wireless Mouse',         'Electronics', 799.00,  150),
('Mechanical Keyboard',    'Electronics', 3499.00, 80),
('USB-C Hub',              'Electronics', 1299.00, 120),
('Running Shoes',          'Footwear',    2999.00, 60),
('Yoga Mat',               'Fitness',     999.00,  200),
('Water Bottle 1L',        'Fitness',     499.00,  300),
('Office Chair',           'Furniture',   7999.00, 25),
('Study Desk',             'Furniture',   6499.00, 20),
('Bluetooth Speaker',      'Electronics', 2199.00, 90),
('Notebook Set (3-pack)',  'Stationery',  299.00,  400);

INSERT INTO orders (customer_id, order_date, status, total_amount) VALUES
(1, '2024-01-05', 'COMPLETED', 4298.00),
(2, '2024-01-12', 'COMPLETED', 999.00),
(3, '2024-01-20', 'CANCELLED', 3499.00),
(1, '2024-02-02', 'COMPLETED', 2199.00),
(4, '2024-02-10', 'COMPLETED', 7999.00),
(5, '2024-02-15', 'COMPLETED', 1798.00),
(2, '2024-03-01', 'COMPLETED', 6798.00),
(6, '2024-03-08', 'PENDING',   3499.00),
(7, '2024-03-15', 'COMPLETED', 998.00),
(3, '2024-03-22', 'COMPLETED', 2999.00),
(8, '2024-04-02', 'COMPLETED', 799.00),
(9, '2024-04-10', 'REFUNDED',  1299.00),
(1, '2024-04-18', 'COMPLETED', 5798.00),
(10,'2024-04-25', 'COMPLETED', 299.00),
(5, '2024-05-03', 'COMPLETED', 2199.00);

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 2, 1, 3499.00),
(1, 1, 1, 799.00),
(2, 5, 1, 999.00),
(3, 2, 1, 3499.00),
(4, 9, 1, 2199.00),
(5, 7, 1, 7999.00),
(6, 3, 1, 1299.00),
(6, 6, 1, 499.00),
(7, 8, 1, 6499.00),
(7, 6, 1, 299.00),
(8, 2, 1, 3499.00),
(9, 6, 2, 499.00),
(10, 4, 1, 2999.00),
(11, 1, 1, 799.00),
(12, 3, 1, 1299.00),
(13, 4, 1, 2999.00),
(13, 9, 1, 2199.00),
(13, 6, 1, 499.00),
(13, 10, 1, 299.00),
(14, 10, 1, 299.00),
(15, 9, 1, 2199.00);

UPDATE orders SET total_amount = 5996.00 WHERE order_id = 13;

INSERT INTO payments (order_id, payment_date, amount, payment_status) VALUES
(1, '2024-01-05', 4298.00, 'PAID'),
(2, '2024-01-12', 999.00,  'PAID'),
(3, '2024-01-20', 3499.00, 'REFUNDED'),
(4, '2024-02-02', 2199.00, 'PAID'),
(5, '2024-02-10', 7999.00, 'PAID'),
(6, '2024-02-15', 1798.00, 'PAID'),
(7, '2024-03-01', 6798.00, 'PAID'),
(8, '2024-03-08', 3499.00, 'PENDING'),
(9, '2024-03-15', 998.00,  'PAID'),
(10,'2024-03-22', 2999.00, 'PAID'),
(11,'2024-04-02', 799.00,  'PAID'),
(12,'2024-04-10', 1299.00, 'REFUNDED'),
(13,'2024-04-18', 5996.00, 'PAID'),
(14,'2024-04-25', 299.00,  'PAID'),
(15,'2024-05-03', 2199.00, 'PAID');


INSERT INTO customers (name, email, city, signup_date)
VALUES ('Neha Kulkarni', 'neha.kulkarni@example.com', 'Hyderabad', '2024-05-20');

INSERT INTO products (product_name, category, price, stock)
VALUES ('Laptop Stand', 'Electronics', 1899.00, 75);

INSERT INTO orders (customer_id, order_date, status, total_amount)
VALUES (LAST_INSERT_ID(), '2024-05-21', 'PENDING', 0.00);

SET @new_customer_id = (SELECT customer_id FROM customers WHERE email = 'neha.kulkarni@example.com');
SET @new_product_id  = (SELECT product_id FROM products WHERE product_name = 'Laptop Stand');

INSERT INTO orders (customer_id, order_date, status, total_amount)
VALUES (@new_customer_id, '2024-05-21', 'PENDING', 1899.00);

SET @new_order_id = LAST_INSERT_ID();

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (@new_order_id, @new_product_id, 1, 1899.00);

INSERT INTO payments (order_id, payment_date, amount, payment_status)
VALUES (@new_order_id, '2024-05-21', 1899.00, 'PENDING');

SELECT * FROM customers WHERE city = 'Hyderabad';

SELECT order_id, order_date, status, total_amount
FROM orders
WHERE customer_id = @new_customer_id
ORDER BY order_date DESC;

SELECT
    o.order_id,
    c.name AS customer_name,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total,
    o.status
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_id = @new_order_id;

SELECT product_name, stock
FROM products
WHERE stock < 30;

UPDATE payments
SET payment_status = 'PAID'
WHERE order_id = @new_order_id;

UPDATE orders
SET status = 'COMPLETED'
WHERE order_id = @new_order_id;

UPDATE products
SET stock = stock - 1
WHERE product_id = @new_product_id;

UPDATE customers
SET city = 'Pune'
WHERE customer_id = @new_customer_id;

DELETE FROM payments WHERE order_id = @new_order_id;

DELETE FROM order_items WHERE order_id = @new_order_id;

DELETE FROM orders WHERE order_id = @new_order_id;

SELECT
    o.order_id,
    c.name AS customer_name,
    c.city,
    o.order_date,
    o.status,
    o.total_amount
FROM orders o
INNER JOIN customers c ON c.customer_id = o.customer_id
ORDER BY o.order_date;

SELECT
    oi.order_id,
    p.product_name,
    p.category,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total
FROM order_items oi
INNER JOIN products p ON p.product_id = oi.product_id
ORDER BY oi.order_id;

SELECT
    c.customer_id,
    c.name,
    o.order_id,
    o.order_date,
    o.status
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
ORDER BY c.customer_id;

SELECT c.customer_id, c.name, c.email
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

SELECT
    p.product_id,
    p.product_name,
    COALESCE(SUM(oi.quantity), 0) AS total_units_ordered
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_units_ordered DESC;

SELECT
    o.order_id,
    o.status AS order_status,
    o.total_amount,
    pay.payment_status,
    pay.amount AS amount_paid
FROM orders o
LEFT JOIN payments pay ON pay.order_id = o.order_id;

SELECT
    c.name AS customer_name,
    c.city,
    o.order_id,
    o.order_date,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total,
    o.status AS order_status,
    pay.payment_status
FROM customers c
JOIN orders o        ON o.customer_id = c.customer_id
JOIN order_items oi  ON oi.order_id = o.order_id
JOIN products p      ON p.product_id = oi.product_id
LEFT JOIN payments pay ON pay.order_id = o.order_id
ORDER BY o.order_date, o.order_id;

SELECT
    c.city,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM customers c
JOIN orders o       ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'COMPLETED'
GROUP BY c.city
ORDER BY revenue DESC;

SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN products p  ON p.product_id = oi.product_id
JOIN orders o    ON o.order_id = oi.order_id
JOIN payments pay ON pay.order_id = o.order_id
WHERE pay.payment_status = 'PAID'
GROUP BY p.category
ORDER BY revenue DESC;

SELECT SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'COMPLETED';

SELECT
    YEAR(order_date) AS yr,
    MONTH(order_date) AS mo,
    COUNT(*) AS order_count,
    SUM(total_amount) AS revenue
FROM orders
WHERE status = 'COMPLETED'
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY yr, mo;

SELECT AVG(total_amount) AS avg_order_value
FROM orders
WHERE status = 'COMPLETED';

SELECT
    YEAR(order_date) AS yr,
    MONTH(order_date) AS mo,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders
WHERE status = 'COMPLETED'
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY yr, mo;

SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY order_count DESC;

SELECT
    MAX(total_amount) AS highest_order,
    MIN(total_amount) AS lowest_order
FROM orders
WHERE status = 'COMPLETED';

SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;

SELECT
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 5;

SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS revenue,
    SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY revenue DESC;

SELECT
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_name
HAVING SUM(oi.quantity * oi.unit_price) > 5000
ORDER BY revenue DESC;

SELECT
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS order_count,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.status = 'COMPLETED'
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

SELECT
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.status = 'COMPLETED'
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) > 1
ORDER BY order_count DESC;

SELECT
    c.city,
    COUNT(DISTINCT c.customer_id) AS customer_count,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value,
    SUM(o.total_amount) AS total_revenue
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.status = 'COMPLETED'
GROUP BY c.city
ORDER BY total_revenue DESC;

SELECT customer_id, name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    WHERE status = 'COMPLETED'
    GROUP BY customer_id
    HAVING SUM(total_amount) > (
        SELECT AVG(total_amount) FROM orders WHERE status = 'COMPLETED'
    )
);

SELECT product_name, category, price
FROM products p1
WHERE price > (
    SELECT AVG(price)
    FROM products p2
    WHERE p2.category = p1.category
);

SELECT order_id, order_date, status
FROM orders
WHERE order_id NOT IN (SELECT order_id FROM payments);

SELECT
    c.customer_id,
    c.name,
    (SELECT MAX(o.order_date)
     FROM orders o
     WHERE o.customer_id = c.customer_id) AS last_order_date
FROM customers c;

WITH monthly_revenue AS (
    SELECT
        YEAR(order_date) AS yr,
        MONTH(order_date) AS mo,
        SUM(total_amount) AS revenue
    FROM orders
    WHERE status = 'COMPLETED'
    GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT * FROM monthly_revenue
WHERE revenue > 3000
ORDER BY yr, mo;

WITH customer_spend AS (
    SELECT
        customer_id,
        SUM(total_amount) AS total_spent,
        COUNT(*) AS order_count
    FROM orders
    WHERE status = 'COMPLETED'
    GROUP BY customer_id
),
top_spenders AS (
    SELECT * FROM customer_spend
    WHERE total_spent > 3000
)
SELECT c.name, ts.total_spent, ts.order_count
FROM top_spenders ts
JOIN customers c ON c.customer_id = ts.customer_id
ORDER BY ts.total_spent DESC;

SELECT
    order_id,
    total_amount,
    CASE
        WHEN total_amount >= 5000 THEN 'High Value'
        WHEN total_amount >= 2000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS order_tier
FROM orders
WHERE status = 'COMPLETED';

SELECT
    c.name,
    SUM(o.total_amount) AS total_spent,
    CASE
        WHEN SUM(o.total_amount) >= 6000 THEN 'VIP'
        WHEN SUM(o.total_amount) >= 3000 THEN 'Regular'
        ELSE 'Occasional'
    END AS customer_segment
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.status = 'COMPLETED'
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

SELECT
    customer_id,
    SUM(total_amount) AS revenue,
    RANK() OVER (ORDER BY SUM(total_amount) DESC) AS revenue_rank
FROM orders
WHERE status = 'COMPLETED'
GROUP BY customer_id;

WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM order_items oi
    JOIN products p ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, p.category
)
SELECT
    product_name,
    category,
    revenue,
    RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rank_in_category
FROM product_revenue
ORDER BY category, rank_in_category;

WITH monthly_revenue AS (
    SELECT
        YEAR(order_date) AS yr,
        MONTH(order_date) AS mo,
        SUM(total_amount) AS revenue
    FROM orders
    WHERE status = 'COMPLETED'
    GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT
    yr,
    mo,
    revenue,
    SUM(revenue) OVER (ORDER BY yr, mo) AS running_total
FROM monthly_revenue
ORDER BY yr, mo;

WITH monthly_revenue AS (
    SELECT
        YEAR(order_date) AS yr,
        MONTH(order_date) AS mo,
        SUM(total_amount) AS revenue
    FROM orders
    WHERE status = 'COMPLETED'
    GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT
    yr,
    mo,
    revenue,
    LAG(revenue) OVER (ORDER BY yr, mo) AS prev_month_revenue,
    revenue - LAG(revenue) OVER (ORDER BY yr, mo) AS mom_change,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY yr, mo))
        / LAG(revenue) OVER (ORDER BY yr, mo) * 100, 2
    ) AS mom_pct_change
FROM monthly_revenue
ORDER BY yr, mo;

SELECT
    customer_id,
    order_id,
    order_date,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_sequence
FROM orders
WHERE status = 'COMPLETED';

WITH numbered_orders AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_sequence
    FROM orders
    WHERE status = 'COMPLETED'
)
SELECT * FROM numbered_orders
WHERE order_sequence > 1;

CREATE OR REPLACE VIEW vw_monthly_revenue AS
SELECT
    YEAR(order_date) AS yr,
    MONTH(order_date) AS mo,
    COUNT(*) AS order_count,
    SUM(total_amount) AS revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders
WHERE status = 'COMPLETED'
GROUP BY YEAR(order_date), MONTH(order_date);

CREATE OR REPLACE VIEW vw_product_performance AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category;

CREATE OR REPLACE VIEW vw_customer_summary AS
SELECT
    c.customer_id,
    c.name,
    c.city,
    COUNT(o.order_id) AS completed_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_spent,
    CASE
        WHEN COALESCE(SUM(o.total_amount), 0) >= 6000 THEN 'VIP'
        WHEN COALESCE(SUM(o.total_amount), 0) >= 3000 THEN 'Regular'
        ELSE 'Occasional'
    END AS customer_segment
FROM customers c
LEFT JOIN orders o
    ON o.customer_id = c.customer_id AND o.status = 'COMPLETED'
GROUP BY c.customer_id, c.name, c.city;

CREATE OR REPLACE VIEW vw_order_details AS
SELECT
    o.order_id,
    c.name AS customer_name,
    c.city,
    o.order_date,
    o.status AS order_status,
    p.product_name,
    p.category,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total,
    pay.payment_status
FROM orders o
JOIN customers c        ON c.customer_id = o.customer_id
JOIN order_items oi      ON oi.order_id = o.order_id
JOIN products p          ON p.product_id = oi.product_id
LEFT JOIN payments pay   ON pay.order_id = o.order_id;

EXPLAIN
SELECT c.name, o.order_id, o.total_amount
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_date >= '2024-03-01';

EXPLAIN ANALYZE
SELECT c.name, o.order_id, o.total_amount
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_date >= '2024-03-01';

CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);

CREATE INDEX idx_orders_covering ON orders(customer_id, order_date, total_amount);
