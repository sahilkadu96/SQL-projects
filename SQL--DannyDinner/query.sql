USE danny;

SELECT s.customer_id, SUM(m.price) AS total_price
FROM sales s JOIN menu m
ON s.product_id = m.product_id
GROUP BY s.customer_id 
ORDER BY total_price DESC;


SELECT customer_id, COUNT(DISTINCT order_date) AS no_of_visiting_days
FROM sales GROUP BY customer_id
ORDER BY no_of_visiting_days DESC;

WITH cte1 AS (
SELECT s.customer_id, s.order_date, m.product_name, 
ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS rn
FROM sales s JOIN menu m
ON s.product_id = m.product_id)
SELECT customer_id, product_name, order_date FROM cte1 WHERE rn = 1;


SELECT m.product_name, COUNT(m.product_name) AS no_of_purchases
FROM menu m JOIN sales s
ON m.product_id = s.product_id
GROUP BY m.product_name
ORDER BY no_of_purchases DESC;

WITH cte1 AS (
SELECT s.customer_id, m.product_name, COUNT(m.product_name) AS product_count,
DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY COUNT(m.product_name) DESC) AS rn
FROM sales s JOIN menu m
ON s.product_id = m.product_id
GROUP BY s.customer_id, m.product_name)
SELECT customer_id, product_name, product_count FROM cte1 WHERE rn = 1;

WITH cte1 AS (
SELECT s.customer_id, s.order_date, m.product_name,
DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS rn
FROM sales s JOIN menu m
ON s.product_id = m.product_id
JOIN members mb
ON s.customer_id = mb.customer_id
WHERE mb.join_date >  s.order_date)
SELECT customer_id, order_date, product_name FROM cte1 WHERE rn = 1;

SELECT s.customer_id, COUNT(m.product_name) AS total_products, SUM(m.price) AS total_price
FROM sales s JOIN menu m
ON s.product_id = m.product_id
JOIN members mb
ON s.customer_id = mb.customer_id
WHERE mb.join_date < s.order_date
GROUP BY s.customer_id;
  
WITH cte1 AS (
SELECT *,
CASE 
	WHEN m.product_name = 'sushi' THEN  m.price*20
    WHEN m.product_name <> 'sushi' THEN m.price*10
END AS points
FROM sales s JOIN menu m
USING(product_id))
SELECT customer_id, SUM(points) AS total_points FROM cte1
GROUP BY customer_id
ORDER BY total_points DESC;
  

