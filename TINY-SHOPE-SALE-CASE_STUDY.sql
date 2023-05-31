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


