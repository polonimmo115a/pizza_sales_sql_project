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

  

