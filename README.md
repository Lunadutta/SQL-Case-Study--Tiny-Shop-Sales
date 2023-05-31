# SQL-Case-Study--Tiny-Shop-Sales

This case study focuses on utilizing SQLSERVER, a popular relational database management system, to analyze sales data for Tiny Shop. By leveraging various SQL functionalities such as aggregations, CASE WHEN statements, window functions, joins, date-time functions, and Common Table Expressions (CTEs), we aim to extract valuable insights and answer key questions related to product prices, customer orders, revenue, and more.

Overview of the Data:

The Tiny Shop sales database contains tables such as Products, Customers, Orders, and Order_Items. The Products table includes information about the products, including their prices. The Customers table stores customer details, while the Orders table contains order-specific information. The Order_Items table links the orders with the products and includes quantity information.

TABLE DETAILS :
-- Customer Table
CREATE TABLE customers (
    customer_id integer PRIMARY KEY,
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100)
);

-- Products Table
CREATE TABLE products (
    product_id integer PRIMARY KEY,
    product_name varchar(100),
    price decimal
);

-- Orders Table
CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    customer_id integer,
    order_date date
);

-- Order Items Table 
CREATE TABLE order_items (
    order_id integer,
    product_id integer,
    quantity integer
);
Let’s insert data into tables

-- Customers Table
INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
(1, 'John', 'Doe', 'johndoe@email.com'),
(2, 'Jane', 'Smith', 'janesmith@email.com'),
(3, 'Bob', 'Johnson', 'bobjohnson@email.com'),
(4, 'Alice', 'Brown', 'alicebrown@email.com'),
(5, 'Charlie', 'Davis', 'charliedavis@email.com'),
(6, 'Eva', 'Fisher', 'evafisher@email.com'),
(7, 'George', 'Harris', 'georgeharris@email.com'),
(8, 'Ivy', 'Jones', 'ivyjones@email.com'),
(9, 'Kevin', 'Miller', 'kevinmiller@email.com'),
(10, 'Lily', 'Nelson', 'lilynelson@email.com'),
(11, 'Oliver', 'Patterson', 'oliverpatterson@email.com'),
(12, 'Quinn', 'Roberts', 'quinnroberts@email.com'),
(13, 'Sophia', 'Thomas', 'sophiathomas@email.com');

-- Products Table
INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Product A', 10.00),
(2, 'Product B', 15.00),
(3, 'Product C', 20.00),
(4, 'Product D', 25.00),
(5, 'Product E', 30.00),
(6, 'Product F', 35.00),
(7, 'Product G', 40.00),
(8, 'Product H', 45.00),
(9, 'Product I', 50.00),
(10, 'Product J', 55.00),
(11, 'Product K', 60.00),
(12, 'Product L', 65.00),
(13, 'Product M', 70.00);

-- Orders Table
INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2023-05-01'),
(2, 2, '2023-05-02'),
(3, 3, '2023-05-03'),
(4, 1, '2023-05-04'),
(5, 2, '2023-05-05'),
(6, 3, '2023-05-06'),
(7, 4, '2023-05-07'),
(8, 5, '2023-05-08'),
(9, 6, '2023-05-09'),
(10, 7, '2023-05-10'),
(11, 8, '2023-05-11'),
(12, 9, '2023-05-12'),
(13, 10, '2023-05-13'),
(14, 11, '2023-05-14'),
(15, 12, '2023-05-15'),
(16, 13, '2023-05-16');

-- Order Items
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 2, 1),
(2, 3, 3),
(3, 1, 1),
(3, 3, 2),
(4, 2, 4),
(4, 3, 1),
(5, 1, 1),
(5, 3, 2),
(6, 2, 3),
(6, 1, 1),
(7, 4, 1),
(7, 5, 2),
(8, 6, 3),
(8, 7, 1),
(9, 8, 2),
(9, 9, 1),
(10, 10, 3),
(10, 11, 2),
(11, 12, 1),
(11, 13, 3),
(12, 4, 2),
(12, 5, 1),
(13, 6, 3),
(13, 7, 2),
(14, 8, 1),
(14, 9, 2),
(15, 10, 3),
(15, 11, 1),
(16, 12, 2),
(16, 13, 3);

select * from customers;
select * from products;
select * from orders;
select * from order_items;

/* Which product has the highest price? Only return a single row.*/

select price,product_name from products where price = (select MAX(price) from products)

/* Which customer has made the most orders? */

select TOP 1 CONCAT(c.first_name,' ',c.last_name) as full_name ,COUNT(order_id)as order_count , C.customer_id from orders as o join customers as C on C.customer_id =o.customer_id
group by c.customer_id ,first_name,last_name  order by COUNT(order_id) desc

/* What’s the total revenue per product? */

select p.product_id , product_name, SUM(price* quantity) as total_revenue  from products as p  join order_items as o on p.product_id =o.product_id group by product_name, p.product_id ;

/* Find the day with the highest revenue.*/

select TOP 1 SUM(price* quantity) as total_revenue, order_date   from products as p  join order_items as o on p.product_id =o.product_id join orders as ord 
on o.order_id = ord.order_id group by order_date
order by total_revenue desc ;

/* Find the first order (by date) for each customer.*/

with cte_table as 
(select  customer_id,order_date , row_number() over(partition by customer_id order by order_date ) as rank from orders)
select ct.customer_id,concat(first_name,' ',last_name) as full_name,order_date from cte_table as ct join customers as c on ct.customer_id = c.customer_id  where rank=1

/* Find the top 3 customers who have ordered the most distinct products */

select TOP 3 (COUNT(distinct(order_items.order_id)))as distinct_products, Concat(first_name ,' ', last_name) as full_name , customers.customer_id   from order_items 
join orders on order_items.order_id = orders.order_id 
join customers on orders.customer_id =customers.customer_id  group by customers.customer_id,first_name, last_name

/* Which product has been bought the least in terms of quantity? */

select top 1 SUM(quantity) as total_number_product , product_id from order_items group by product_id order by total_number_product asc 

/* For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’. */

select sum (quantity*price) as total_revenue , order_id,
case 
when sum (quantity*price) > 300 then 'Expensive'
when sum (quantity*price) > 100 then 'Affordable'
else 'cheap' end as Expense_category from order_items join products on order_items.product_id = products.product_id group by order_id order by total_revenue

/* Find customers who have ordered the product with the highest price. */

select customers.customer_id, CONCAT(first_name , ' ',last_name) as full_name ,product_name, price   from order_items 
join orders on order_items.order_id = orders.order_id
join products on order_items.product_id = products.product_id 
join customers on customers.customer_id = orders.customer_id
where price = (select MAX(price) from products )
order by price desc
