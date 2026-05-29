drop table  if exists order_details; 
create table order_details(
               order_details_id int8 primary key,
               order_id int8,
               pizza_id varchar(50),
               quantity int8

);
select * from order_details

create table orders(
             order_id int8 primary key,
             date1 date, 
             time1 time

);
select * from orders
drop table if exists pizza_types;
create table pizza_types(
             pizza_type_id varchar(100),             
			 name varchar(200),
             category varchar(100),
             ingredients varchar(1000)

);

create table pizzas(
           pizza_id varchar(100),
           pizza_type_id varchar(100),
           size varchar(10),
		   price float
);

          
select * from pizzas
select * from order_details
--Retrieve the total number of orders placed
SELECT
	COUNT(ORDER_ID) AS NO_OF_ORDERS
FROM
	ORDERS
--Calculate the total revenue generated from pizza sales
SELECT
	SUM(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE) AS TOTAL_REVENUE
FROM
	ORDER_DETAILS
	JOIN PIZZAS ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID

--Identify the highest-priced pizza
SELECT
	pizzas.PIZZA_ID,
	pizzas.price,pizza_types.name
FROM
	PIZZAS join pizza_types on pizzas.pizza_type_id=pizza_types.pizza_type_id
ORDER BY
	2 DESC
LIMIT
	1

--Identify the most common pizza size ordered.

SELECT
	PIZZAS.SIZE,
	COUNT(ORDER_DETAILS.ORDER_DETAILS_ID)
FROM
	PIZZAS
	JOIN ORDER_DETAILS ON PIZZAS.PIZZA_ID = ORDER_DETAILS.PIZZA_ID
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT
	1


--List the top 5 most ordered pizza types along with their quantities.

SELECT
	SUM(O.QUANTITY),
	P.NAME
FROM
	ORDER_DETAILS O
	JOIN PIZZAS ON O.PIZZA_ID = PIZZAS.PIZZA_ID
	JOIN PIZZA_TYPES P ON PIZZAS.PIZZA_TYPE_ID = P.PIZZA_TYPE_ID
GROUP BY
	2
ORDER BY
	1 DESC
LIMIT
	5

--Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT
	SUM(O.QUANTITY) AS TOTAL_QUANTITY,
	P.CATEGORY
FROM
	ORDER_DETAILS O
	JOIN PIZZAS ON O.PIZZA_ID = PIZZAS.PIZZA_ID
	JOIN PIZZA_TYPES P ON PIZZAS.PIZZA_TYPE_ID = P.PIZZA_TYPE_ID
GROUP BY
	2
ORDER BY
	1 DESC

--Determine the distribution of orders by hour of the day.

SELECT
	EXTRACT(
		HOUR
		FROM
			TIME1
	) AS HOUR,
	COUNT(ORDER_ID) AS ORDER_COUNT
FROM
	ORDERS
GROUP BY
	1
ORDER BY
	2 DESC
--Join relevant tables to find the category-wise distribution of pizzas.
select * from order_details
select * from pizza_types
select * from orders
select * from pizzas
select category,count(name) as distribution_count
from pizza_types
group by 1

--Group the orders by date and calculate the  number of pizzas ordered per day
select * from order_details
select * from pizza_types
select * from orders
select * from pizzas
select orders.date1,sum(order_details.quantity) as number_of_pizzas
from orders join order_details on orders.order_id=order_details.order_id
group by 1
order by 2 desc

--Determine the top 3 most ordered pizza types based on revenue.
select * from order_details
select * from pizza_types
select * from orders
select * from pizzas
SELECT
	P.NAME,
	SUM(PIZZAS.PRICE * O.QUANTITY) AS REVENUE
FROM
	ORDER_DETAILS O
	JOIN PIZZAS ON O.PIZZA_ID = PIZZAS.PIZZA_ID
	JOIN PIZZA_TYPES P ON PIZZAS.PIZZA_TYPE_ID = P.PIZZA_TYPE_ID
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT
	3

--Calculate the percentage contribution of each pizza type to total revenue.
select * from order_details
select * from pizza_types
select * from orders
select * from pizzas
SELECT
	P.category,
	SUM(PIZZAS.PRICE * O.QUANTITY) AS REVENUE,
	(SUM(PIZZAS.PRICE * O.QUANTITY)*100/(SELECT
	SUM(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE) AS TOTAL_REVENUE
FROM
	ORDER_DETAILS
	JOIN PIZZAS ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID)) as revenue_pct

FROM
	ORDER_DETAILS O
	JOIN PIZZAS ON O.PIZZA_ID = PIZZAS.PIZZA_ID
	JOIN PIZZA_TYPES P ON PIZZAS.PIZZA_TYPE_ID = P.PIZZA_TYPE_ID
GROUP BY
	1
ORDER BY
	2 DESC


--Analyze the cumulative revenue generated over time.

SELECT
	DATE1,
	REVENUE,
	SUM(REVENUE) OVER (
		ORDER BY
			DATE1
	) AS CUM_REVENUE
FROM
	(
		SELECT
			ORDERS.DATE1,
			SUM(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE) AS REVENUE
		FROM
			ORDERS
			JOIN ORDER_DETAILS ON ORDERS.ORDER_ID = ORDER_DETAILS.ORDER_ID
			JOIN PIZZAS ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID
		GROUP BY
			1
	)

--Determine the top 3 most ordered pizza types based on revenue for each pizza category.

WITH
	RANKED_PIZZA AS (
		SELECT
			P.CATEGORY,
			P.NAME,
			SUM(O.QUANTITY * PIZZAS.PRICE) AS REVENUE,
			RANK() OVER (
				PARTITION BY
					P.CATEGORY
				ORDER BY
					SUM(O.QUANTITY * PIZZAS.PRICE) DESC
			) AS RNK
		FROM
			ORDER_DETAILS O
			JOIN PIZZAS ON O.PIZZA_ID = PIZZAS.PIZZA_ID
			JOIN PIZZA_TYPES P ON PIZZAS.PIZZA_TYPE_ID = P.PIZZA_TYPE_ID
		GROUP BY
			1,
			2
	)
SELECT
	*
FROM
	RANKED_PIZZA
WHERE
	RNK<=3
	