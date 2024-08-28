# 1 What is the total amount each customer spent at the restaurant?

select customer_id, sum(price) as total_amount
from sales s
join menu m on m.product_id=s.product_id
group by customer_id;

select distinct customer_id,
	sum(price) over(partition by customer_id) as total_amount
from sales s
join menu m on m.product_id=s.product_id;

# 2 How many days has each customer visited the restaurant?
select customer_id,
	count(distinct order_date) as days_visited 
from sales
group by customer_id;

# 3 What was the first item from the menu purchased by each customer?
with cte1 as (select 
	customer_id,
    s.product_id,
    product_name,
    order_date,
    dense_rank() over(partition by customer_id order by order_date asc) as drnk
 from sales s
join menu m 
on m.product_id=s.product_id
)
select * from cte1 where drnk=1;

with cte1 as (select customer_id, min(order_date) as first_order
from sales
group by customer_id
)
select customer_id, s.product_id, product_name, order_date from sales s
join menu m on m.product_id=s.product_id
where order_date in (select first_order from cte1);

#4 What is the most purchased item on the menu and how many times was it purchased by all customers?

select s.product_id, m.product_name, count(s.product_id) as cnt from sales s
join menu m on m.product_id=s.product_id
group by product_id
order by cnt desc limit 1;

# 5 Which item was the most popular for each customer?

with cte1 as (select customer_id, 
	product_name, 
	count(s.product_id) as cnt,
    dense_rank() over(partition by customer_id order by count(s.product_id) desc) as drnk
    from sales s
join menu m on m.product_id=s.product_id
group by product_name, customer_id
)
select *
		from cte1 where drnk=1;
        
# 6 Which item was purchased first by the customer after they became a member?

with cte1 as (
select 
 s.customer_id,
 product_name,
 order_date,
 me.join_date as joining_date,
 dense_rank() over(partition by customer_id order by order_date) as drnk
 from sales s
join menu m on m.product_id=s.product_id
join members me on me.customer_id=s.customer_id
where order_date > me.join_date
) select * from cte1 where drnk=1;

#7 Which item was purchased just before the customer became a member?
with cte1 as (
select 
 s.customer_id,
 product_name,
 order_date,
 me.join_date as joining_date,
 dense_rank() over(partition by customer_id order by order_date desc) as drnk
 from sales s
join menu m on m.product_id=s.product_id
join members me on me.customer_id=s.customer_id
where order_date < me.join_date
) select * from cte1 where drnk=1;


# 8 What is the total items and amount spent for each member before they became a member?
select 
	s.customer_id,
    count(s.product_id) as total_items,
    sum(price) as amount_spent
from sales s
join menu m on m.product_id=s.product_id
join members me on me.customer_id=s.customer_id
where order_date < join_date
group by s.customer_id;

# 9 If each $1 spent equates to 10 points and sushi has a 2x points multiplier - 
# how many points would each customer have?

with cte1 as (select customer_id, 
	product_name,
	sum(price) as total_amount,
    if(product_name = "sushi", sum(price) * 20, sum(price) * 10) as points
from sales s 
join menu m on m.product_id=s.product_id
group by product_name, customer_id
)
select customer_id, 
sum(points) as total_points 
from cte1 
group by customer_id;


#10 In the first week after a customer joins the program (including their join date) they earn 2x points 
# on all items, not just sushi - how many points do customer A and B have at the end of January?

with cte1 as (
select 
	s.customer_id, 
	product_name,
	sum(price) as total_amount,
    # if(product_name = "sushi", sum(price) * 20, sum(price) * 10) as points
    case
		when day(order_date) - day(join_date) <= 7  
			then sum(price) * 20
		when product_name="sushi" then sum(price) * 20
        else sum(price) * 10
    end as points
from sales s 
join menu m on m.product_id=s.product_id
join members me on me.customer_id=s.customer_id
where month(order_date)=1
group by product_name, s.customer_id
)
select s.customer_id, 
sum(points) as total_points 
from cte1 
group by s.customer_id;


WITH points_calculation AS (
    SELECT 
        s.customer_id,
        m.product_name,
        s.order_date,
        me.join_date,
        m.price,
        CASE
            -- First week bonus on all items
            WHEN DATEDIFF(s.order_date, me.join_date) BETWEEN 0 AND 6 
                THEN m.price * 20
            -- Sushi bonus
            WHEN m.product_name = 'sushi' 
                THEN m.price * 20
            -- Regular points
            ELSE m.price * 10
        END AS points
    FROM 
        sales s
    JOIN 
        menu m ON s.product_id = m.product_id
    JOIN 
        members me ON s.customer_id = me.customer_id
    WHERE 
        MONTH(s.order_date) = 1 -- Filter for January
)
SELECT 
    customer_id,
    SUM(points) AS total_points
FROM 
    points_calculation
WHERE 
    customer_id IN ('A', 'B')
GROUP BY 
    customer_id;


# bonus questions

with cte1 as (select 
		s.customer_id,
        order_date,
        product_name,
        price,
        join_date,
        if (join_date is null or order_date < join_date, "N", "Y") as member
	from sales s
    join menu m on m.product_id=s.product_id
    left join members me on me.customer_id=s.customer_id
)
select 
		*,
        case
			when member="Y"
			then
				dense_rank() over(partition by customer_id, member  order by order_date)
			else null
        end as ranking
from cte1;