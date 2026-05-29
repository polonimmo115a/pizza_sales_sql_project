# Pizza Sales Analysis

![image alt](https://github.com/polonimmo115a/pizza_sales_sql_project/blob/my-new-branch/pizza%20sales%20image.png?raw=true)


## Overview

This project analyzes pizza sales data using SQL to uncover customer behavior, sales trends, and business opportunities. The dataset consists of four relational tables:

-**orders:** order-level information (order_id, order_date, customer_id)

-**order_details:** line items (order_id, pizza_id, quantity)

-**pizzas:** pizza attributes (pizza_id, size, price, type_id)

-**pizza_type:** pizza categories and ingredients

The goal is to apply SQL queries to generate actionable insights that can improve optimize promotions and maximize revenue

## Business Problem

Pizza chains face challenges such as

-**Sales optimization:** Finding peak ordering times, popular pizza types, and revenue drivers.


## Schema

```sql

create table order_details(
               order_details_id int8 primary key,
               order_id int8,
               pizza_id varchar(50),
               quantity int8
```

```sql

create table orders(
             order_id int8 primary key,
             date1 date, 
             time1 time

);
```

```sql

create table pizza_types(
             pizza_type_id varchar(100),             
			 name varchar(200),
             category varchar(100),
             ingredients varchar(1000)

);
```

```sql

create table pizzas(
           pizza_id varchar(100),
           pizza_type_id varchar(100),
           size varchar(10),
		   price float
);
```

## Business Problems and Solutions

### 1 find the total quantity of each pizza category ordered

```sql

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
```

**insight:** Shows which categories (Classic, Supreme, Veggie, etc.) are most popular

### 2 Determine the distribution of orders by hour of the day.

```sql

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
```

**insight:** Reveals peak ordering hours (e.g., dinner rush 6–9 PM)

### 3 find the category-wise distribution of pizzas

```sql

select category,count(name) as distribution_count
from pizza_types
group by 1
```

**insight:** Shows how many pizzas belong to each category

### 4 Group the orders by date and calculate the  number of pizzas ordered per day

```sql

select orders.date1,sum(order_details.quantity) as number_of_pizzas
from orders join order_details on orders.order_id=order_details.order_id
group by 1
order by 2 desc
```

**insight:** Tracks daily demand patterns.

### 5 Determine the top 3 most ordered pizza types based on revenue

```sql

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
```

**insight:**  Identifies the best‑selling pizzas driving revenue

### 6 Calculate the percentage contribution of each pizza type to total revenue.

```sql

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
```

**insight:**  Useful for sales mix analysis

### 7 Analyze the cumulative revenue generated over time

```sql

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
```

**insight:** Tracks how revenue grows over time

### 8 Determine the top 3 most ordered pizza types based on revenue for each pizza category

```sql

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
```

**insight:** Identifies top performers per category (e.g., best Classic, best Supreme).


##  Business Insights

-**Category demand:** Which pizza categories dominate sales.

-**Peak hours:** When to staff more employees or run promotions.

-**Revenue drivers:** Top pizzas contributing most to revenue.

-**Cumulative revenue:** Helps track growth and set sales targets.


