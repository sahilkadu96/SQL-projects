USE gdb023;

SELECT * FROM dim_customer;
SELECT * FROM dim_product;
SELECT * FROM fact_gross_price;
SELECT * FROM fact_manufacturing_cost;
SELECT * FROM fact_pre_invoice_deductions;
SELECT * FROM fact_sales_monthly;


SELECT DISTINCT market FROM dim_customer
WHERE customer = "Atliq Exclusive" AND region = "APAC";

SELECT segment, COUNT(DISTINCT product) AS product_count FROM dim_product
GROUP BY segment
ORDER BY product_count DESC;

WITH cte1 AS (
SELECT dp.segment, COUNT(DISTINCT dp.product_code) AS product_count_2020
FROM dim_product dp
JOIN  fact_sales_monthly fsm
ON dp.product_code = fsm.product_code
WHERE fsm.fiscal_year = 2020
GROUP BY segment),
cte2 AS (
SELECT dp.segment, COUNT(DISTINCT dp.product_code) AS product_count_2021
FROM dim_product dp
JOIN  fact_sales_monthly fsm
ON dp.product_code = fsm.product_code
WHERE fsm.fiscal_year = 2021
GROUP BY segment)
SELECT cte1.segment, cte1.product_count_2020, cte2.product_count_2021, 
ROUND(((cte2.product_count_2021 - cte1.product_count_2020)/cte1.product_count_2020)*100, 2) AS percent_change
FROM cte1 JOIN cte2
ON cte1.segment = cte2.segment 
GROUP BY segment
ORDER BY percent_change DESC; 



WITH cte1 AS (
SELECT dp.segment, COUNT(DISTINCT dp.product_code) AS product_count_2020
FROM dim_product dp
JOIN  fact_sales_monthly fsm
ON dp.product_code = fsm.product_code
WHERE fsm.fiscal_year = 2020
GROUP BY segment),
cte2 AS (
SELECT dp.segment, COUNT(DISTINCT dp.product_code) AS product_count_2021
FROM dim_product dp
JOIN  fact_sales_monthly fsm
ON dp.product_code = fsm.product_code
WHERE fsm.fiscal_year = 2021
GROUP BY segment)
SELECT cte1.segment, cte1.product_count_2020, cte2.product_count_2021, 
(cte2.product_count_2021 - cte1.product_count_2020) AS difference 
FROM cte1 JOIN cte2
ON cte1.segment = cte2.segment 
GROUP BY segment
ORDER BY difference DESC; 

(SELECT fmc.product_code, dp.product, MAX(fmc.manufacturing_cost) AS mfg_cost
FROM fact_manufacturing_cost fmc JOIN dim_product dp
ON fmc.product_code = dp.product_code
GROUP BY product_code 
ORDER BY mfg_cost DESC LIMIT 1)
UNION
(SELECT fmc.product_code, dp.product, MIN(fmc.manufacturing_cost) AS mfg_cost
FROM fact_manufacturing_cost fmc JOIN dim_product dp
ON fmc.product_code = dp.product_code
GROUP BY product_code
ORDER BY mfg_cost ASC LIMIT 1);

SELECT dc.customer_code, dc.customer, ROUND(AVG(fpid.pre_invoice_discount_pct)*100, 2) as avg_discount
FROM dim_customer dc JOIN fact_pre_invoice_deductions fpid
ON dc.customer_code = fpid.customer_code
WHERE fpid.fiscal_year = 2021 AND dc.market = "India"
GROUP BY dc.customer_code
ORDER BY avg_discount DESC LIMIT 5;

SELECT YEAR(fsm.date) as year, MONTH(fsm.date) as month,
SUM(fgp.gross_price*fsm.sold_quantity) AS sales_amount
FROM fact_sales_monthly fsm JOIN fact_gross_price fgp 
ON fsm.product_code = fgp.product_code
JOIN dim_customer dc
ON fsm.customer_code = dc.customer_code 
WHERE dc.customer =  "Atliq Exclusive"
GROUP BY year, month
ORDER BY year;

SELECT CASE 
WHEN MONTH(date) in (01, 02, 03) THEN "Q1"
WHEN MONTH(date) IN (04, 05, 06) THEN "Q2"
WHEN MONTH(date) IN (07, 08, 09) THEN "Q3"
WHEN MONTH(date) IN (10, 11, 12) THEN "Q4"
END AS Quarter, 
SUM(sold_quantity) 
FROM fact_sales_monthly
WHERE fiscal_year = 2020
GROUP BY Quarter;

SELECT QUARTER(date) AS Q, SUM(sold_quantity) AS total_sold_qty
FROM fact_sales_monthly
WHERE fiscal_year = 2020
GROUP BY Q
ORDER BY total_sold_qty DESC;

WITH cte1 AS
(SELECT dc.channel, SUM(fgp.gross_price*fsm.sold_quantity) AS total_sales_amount
FROM fact_gross_price fgp JOIN fact_sales_monthly fsm
ON  fgp.product_code = fsm.product_code
JOIN dim_customer dc
ON fsm.customer_code = dc.customer_code
WHERE fsm.fiscal_year = 2021
GROUP BY dc.channel
ORDER BY total_sales_amount DESC)
SELECT channel, total_sales_amount,
ROUND((total_sales_amount/(SUM(total_sales_amount) OVER())*100), 2) AS pct_sales
FROM cte1;

WITH cte1 AS
(SELECT dp.division, dp.product_code, dp.product, SUM(fsm.sold_quantity) AS total_sold_qty,
RANK() OVER(PARTITION BY dp.division ORDER BY SUM(fsm.sold_quantity) DESC) AS Top3ranks
FROM dim_product dp JOIN fact_sales_monthly fsm
ON dp.product_code = fsm.product_code
WHERE fsm.fiscal_year = 2021
GROUP BY dp.product_code)
SELECT * FROM cte1
WHERE Top3ranks IN (1,2,3);

