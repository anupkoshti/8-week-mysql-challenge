# A. Pizza Metrics
#1 How many pizzas were ordered?

select count(*) as total_pizzas from customer_orders ;

# 2 How many unique customer orders were made?
select count(distinct customer_id) as unique_orders from customer_orders;

#3 How many successful orders were delivered by each runner?

select runner_id, count(order_id) as successful_orders
from runner_orders where cancellation is null
group by runner_id;

#4 How many of each type of pizza was delivered?

select pizza_name,
		count(order_id) as cnt
from customer_orders c
join pizza_names pn on pn.pizza_id=c.pizza_id
group by pizza_name;

# 5 How many Vegetarian and Meatlovers were ordered by each customer?

select customer_id,
		pizza_name,
		count(c.order_id) as cnt 
from customer_orders c join
pizza_names pn on pn.pizza_id=c.pizza_id
group by customer_id, pn.pizza_name
order by customer_id, pizza_name;


SELECT
    co.customer_id,
    SUM(CASE WHEN pn.pizza_name = 'Meatlovers' THEN 1 ELSE 0 END) AS meatlovers_count,
    SUM(CASE WHEN pn.pizza_name = 'Vegetarian' THEN 1 ELSE 0 END) AS vegetarian_count
FROM
    customer_orders co
JOIN
    pizza_names pn ON co.pizza_id = pn.pizza_id
GROUP BY
    co.customer_id
ORDER BY
    co.customer_id;
    
# 6 What was the maximum number of pizzas delivered in a single order?
select order_id,
		count(pizza_id) as cnt
from customer_orders
group by order_id
order by cnt desc limit 1;

# 7 For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

select 
		customer_id,
        sum(case
			when exclusions<> "none" OR extras<> "none"
			then 1 else 0
        end) as pizza_with_changes,
        sum(case
			when exclusions="none" AND extras="none" 
			then 1 else 0
        end) as pizza_without_changes
from customer_orders co
JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    ro.cancellation IS NULL
group by customer_id
ORDER BY
    co.customer_id;
    
# 8 How many pizzas were delivered that had both exclusions and extras?
select 
		customer_id,
        sum(case
			when exclusions<> "none" and extras<> "none"
			then 1 else 0
        end) as cnt
from customer_orders co
JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    ro.cancellation IS NULL
group by customer_id
ORDER BY
    co.customer_id;

# 9 What was the total volume of pizzas ordered for each hour of the day?
SELECT
    HOUR(co.order_time) AS order_hour,
    COUNT(co.order_id) AS total_pizzas_ordered
FROM
    customer_orders co
GROUP BY
    order_hour
ORDER BY
    order_hour;

# 10 What was the volume of orders for each day of the week?

SELECT
    DAY(co.order_time) AS order_day,
    COUNT(co.order_id) AS total_pizzas_ordered
FROM
    customer_orders co
GROUP BY
    order_day
ORDER BY
    order_day;
    
    
# B. Runner and Customer Experience
# 1 How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT
FLOOR((DATEDIFF(r.registration_date, '2021-01-01')) / 7) + 1 AS week_number,
COUNT(r.runner_id) AS runners_signed_up
	FROM
		runners r
	GROUP BY
		week_number
	ORDER BY
		week_number;
# 2 What was the average time in minutes it took for each runner
# to arrive at the Pizza Runner HQ to pickup the order?


	
# select time(order_time) from customer_orders;

select runner_id, 
		avg(TIMEDIFF(pickup_time, order_time)) / 60 as time_taken
from customer_orders co
join runner_orders ro
on ro.order_id=co.order_id
group by runner_id
order by time_taken desc;1


# A. Pizza Metrics
#1 How many pizzas were ordered?

select count(*) as total_pizzas from customer_orders ;

# 2 How many unique customer orders were made?
select count(distinct customer_id) as unique_orders from customer_orders;

#3 How many successful orders were delivered by each runner?

select runner_id, count(order_id) as successful_orders
from runner_orders where cancellation is null
group by runner_id;

#4 How many of each type of pizza was delivered?

select pizza_name,
		count(order_id) as cnt
from customer_orders c
join pizza_names pn on pn.pizza_id=c.pizza_id
group by pizza_name;

# 5 How many Vegetarian and Meatlovers were ordered by each customer?

select customer_id,
		pizza_name,
		count(c.order_id) as cnt 
from customer_orders c join
pizza_names pn on pn.pizza_id=c.pizza_id
group by customer_id, pn.pizza_name
order by customer_id, pizza_name;


SELECT
    co.customer_id,
    SUM(CASE WHEN pn.pizza_name = 'Meatlovers' THEN 1 ELSE 0 END) AS meatlovers_count,
    SUM(CASE WHEN pn.pizza_name = 'Vegetarian' THEN 1 ELSE 0 END) AS vegetarian_count
FROM
    customer_orders co
JOIN
    pizza_names pn ON co.pizza_id = pn.pizza_id
GROUP BY
    co.customer_id
ORDER BY
    co.customer_id;
    
# 6 What was the maximum number of pizzas delivered in a single order?
select order_id,
		count(pizza_id) as cnt
from customer_orders
group by order_id
order by cnt desc limit 1;

# 7 For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

select 
		customer_id,
        sum(case
			when exclusions<> "none" OR extras<> "none"
			then 1 else 0
        end) as pizza_with_changes,
        sum(case
			when exclusions="none" AND extras="none" 
			then 1 else 0
        end) as pizza_without_changes
from customer_orders co
JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    ro.cancellation IS NULL
group by customer_id
ORDER BY
    co.customer_id;
    
# 8 How many pizzas were delivered that had both exclusions and extras?
select 
		customer_id,
        sum(case
			when exclusions<> "none" and extras<> "none"
			then 1 else 0
        end) as cnt
from customer_orders co
JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    ro.cancellation IS NULL
group by customer_id
ORDER BY
    co.customer_id;

# 9 What was the total volume of pizzas ordered for each hour of the day?
SELECT
    HOUR(co.order_time) AS order_hour,
    COUNT(co.order_id) AS total_pizzas_ordered
FROM
    customer_orders co
GROUP BY
    order_hour
ORDER BY
    order_hour;

# 10 What was the volume of orders for each day of the week?

SELECT
    DAY(co.order_time) AS order_day,
    COUNT(co.order_id) AS total_pizzas_ordered
FROM
    customer_orders co
GROUP BY
    order_day
ORDER BY
    order_day;
    
    
# B. Runner and Customer Experience
# 1 How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT
FLOOR((DATEDIFF(r.registration_date, '2021-01-01')) / 7) + 1 AS week_number,
COUNT(r.runner_id) AS runners_signed_up
	FROM
		runners r
	GROUP BY
		week_number
	ORDER BY
		week_number;
# 2 What was the average time in minutes it took for each runner
# to arrive at the Pizza Runner HQ to pickup the order?


	
# select time(order_time) from customer_orders;

SELECT
    ro.runner_id,
    AVG(TIMESTAMPDIFF(MINUTE, co.order_time, ro.pickup_time)) AS avg_pickup_time_minutes
FROM
    customer_orders co
JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    ro.pickup_time IS NOT NULL
    AND ro.cancellation IS NULL  -- Only consider successful pickups
GROUP BY
    ro.runner_id
ORDER BY
    ro.runner_id;
    
    
SELECT
    ro.runner_id,
    TIMESTAMPDIFF(MINUTE, co.order_time, ro.pickup_time) AS pickup_time_minutes
FROM
    customer_orders co
JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    ro.pickup_time IS NOT NULL
    AND ro.cancellation IS NULL  -- Only consider successful pickups
ORDER BY
    ro.runner_id;
    
# Is there any relationship between the number of pizzas and how long the order takes to prepare?

select 
		order_id,
        count(pizza_id) as cnt
from customer_orders
group by order_id;

SELECT
    ro.order_id,
    TIMESTAMPDIFF(MINUTE, co.order_time, ro.pickup_time) AS preparation_time
FROM
    runner_orders ro
JOIN
    customer_orders co ON ro.order_id = co.order_id
WHERE
    ro.pickup_time IS NOT NULL
    AND ro.cancellation IS NULL; 
    
with cte1 as (SELECT
	co.order_id,
	COUNT(co.pizza_id) AS total_pizzas,
    order_time
 FROM
	customer_orders co
 GROUP BY
	co.order_id
)
select total_pizzas,
		avg(TIMESTAMPDIFF(MINUTE, c1.order_time, ro.pickup_time)) AS preparation_time
	from runner_orders ro
JOIN
    cte1 c1 ON ro.order_id = c1.order_id
WHERE
    ro.pickup_time IS NOT NULL
    AND ro.cancellation IS NULL
group by total_pizzas
order by total_pizzas; 

#4 What was the average distance travelled for each customer?
