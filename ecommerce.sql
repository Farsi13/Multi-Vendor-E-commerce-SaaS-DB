CREATE DATABASE ecommerce;
USE ecommerce;

-- Subscription Plans table
CREATE TABLE IF NOT EXISTS subscription_plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(100) UNIQUE NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    duration_days INT NOT NULL,
    features TEXT
);

-- Vendors table
CREATE TABLE IF NOT EXISTS vendors (
    vendor_id INT AUTO_INCREMENT PRIMARY KEY,
    business_name VARCHAR(200) NOT NULL,
    contact_person VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(250),
    plan_id INT NOT NULL,
    FOREIGN KEY (plan_id) REFERENCES subscription_plans(plan_id)
);

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

-- Products table
CREATE TABLE IF NOT EXISTS products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id)
);

-- Product-Categories table
CREATE TABLE IF NOT EXISTS product_categories (
    product_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Customers table
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(250)
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    order_status ENUM('pending', 'processing', 'completed', 'cancelled', 'refunded'),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items table
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Payments table
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method ENUM('card', 'bkash', 'nagad', 'paypal', 'cod'),
    amount DECIMAL(12,2) NOT NULL,
    payment_date DATETIME NOT NULL,
    payment_status ENUM('pending', 'paid', 'failed', 'refunded'),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Insert subscription plans
INSERT INTO subscription_plans (plan_name, price, duration_days, features)
VALUES
('Basic', 500.00, 30, 'Basic vendor features'),
('Standard', 1200.00, 30, 'Analytics and priority support'),
('Premium', 2500.00, 30, 'Unlimited products and advanced analytics'),
('Enterprise', 5000.00, 30, 'Custom branding and API access'),
('Trial', 0.00, 7, 'Limited trial access');

-- Insert vendors
INSERT INTO vendors (business_name, contact_person, email, phone, address, plan_id)
VALUES 
('SmartTech Ltd.', 'Rahim Khan', 'rahim@smarttech.com', '01712312311', 'Dhaka, Bangladesh', 1),
('Faiz Electronics', 'Faiz Ahmed', 'faiz@gmail.com', '01711111111', 'Dhaka', 2),
('Muaz Gadgets', 'Muaz Karim', 'muaz@gmail.com', '01722222222', 'Chittagong', 3),
('Salman Stores', 'Salman Hossain', 'salman@gmail.com', '01733333333', 'Khulna', 4),
('Saeed Supplies', 'Saeed Khan', 'saeed@gmail.com', '01744444444', 'Rajshahi', 5);

-- Insert categories
INSERT INTO categories (name, description)
VALUES
('Electronics', 'Electronic devices and gadgets'),
('Clothing', 'Men and women clothing'),
('Books', 'Educational and fiction books'),
('Sports', 'Sports equipment and accessories'),
('Home Appliances', 'Appliances for home use');

-- Insert products
INSERT INTO products (vendor_id, name, description, price, stock_quantity, status)
VALUES
(1, 'Laptop', 'High performance laptop', 75000, 10, 'active'),
(2, 'Smartphone', 'Latest smartphone model', 35000, 20, 'active'),
(3, 'Headphones', 'Wireless headphones', 5000, 50, 'active'),
(4, 'T-shirt', 'Cotton T-shirt', 500, 100, 'active'),
(5, 'Microwave', '800W microwave oven', 12000, 15, 'active');

-- Link products to categories
INSERT INTO product_categories (product_id, category_id)
VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 5);

-- Update stock quantity for Laptop
UPDATE products
SET stock_quantity = 15
WHERE name = 'Laptop';

-- Insert customers
INSERT INTO customers (name, email, phone, address)
VALUES
('Karim Uddin', 'karim@gmail.com', '01718225916', 'Dhaka, Bangladesh'),
('Faiz Ahmed', 'faiz@gmail.com', '01711111111', 'Dhaka'),
('Muaz Karim', 'muaz@gmail.com', '01722222222', 'Chittagong'),
('Salman Hossain', 'salman@gmail.com', '01733333333', 'Khulna'),
('Saeed Khan', 'saeed@gmail.com', '01744444444', 'Rajshahi');

-- Insert & delete a test customer
INSERT INTO customers (name, email, phone, address)
VALUES ('Old Customer', 'oldcustomer@gmail.com', '01511111212', 'Dhaka');

DELETE FROM customers
WHERE email = 'oldcustomer@gmail.com';

-- Insert orders
INSERT INTO orders (customer_id, order_date, total_amount, order_status)
VALUES
(1, '2026-01-03 10:00:00', 150000, 'completed'),
(2, '2026-01-03 11:00:00', 35000, 'completed'),
(3, '2026-01-03 12:00:00', 5000, 'completed'),
(4, '2026-01-03 13:00:00', 1000, 'completed'),
(5, '2026-01-03 14:00:00', 12000, 'completed');

-- Insert order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal)
VALUES
(1, 1, 2, 75000, 150000),
(2, 2, 1, 35000, 35000),
(3, 3, 1, 5000, 5000),
(4, 4, 2, 500, 1000),
(5, 5, 1, 12000, 12000);

-- Insert payments
INSERT INTO payments (order_id, payment_method, amount, payment_date, payment_status)
VALUES
(1, 'card', 150000, '2026-01-03 10:05:00', 'paid'),
(2, 'bkash', 35000, '2026-01-03 11:05:00', 'paid'),
(3, 'paypal', 5000, '2026-01-03 12:05:00', 'paid'),
(4, 'cod', 1000, '2026-01-03 13:05:00', 'paid'),
(5, 'nagad', 12000, '2026-01-03 14:05:00', 'paid');

-- Vendors with subscription plan and price
SELECT v.business_name, s.plan_name, s.price
FROM vendors v
JOIN subscription_plans s
ON v.plan_id = s.plan_id;

-- Products under Electronics category
SELECT p.name, p.price, p.stock_quantity
FROM products p
JOIN product_categories pc ON p.product_id = pc.product_id
JOIN categories c ON pc.category_id = c.category_id
WHERE c.name = 'Electronics';

-- Orders by customer "Karim Uddin"
SELECT o.order_id, o.order_date, o.total_amount, o.order_status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.name = 'Karim Uddin';

-- Payment details for order_id = 1
SELECT payment_method, amount, payment_status
FROM payments
WHERE order_id = 1;

-- Top 5 best-selling products
SELECT p.name AS product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY total_sold DESC
LIMIT 5;
