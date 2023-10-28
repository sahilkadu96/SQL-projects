CREATE database visitorsdf;
USE visitorsdf;

select * from domestic_visitors;

SELECT district, SUM(visitors) FROM domestic_visitors
GROUP BY district
ORDER BY SUM(visitors) DESC LIMIT 10;

WITH cte1 AS(
SELECT district, SUM(visitors) AS vis2016 FROM all_visitors
WHERE year = 2016
GROUP BY district),
cte2 AS(
SELECT district, SUM(visitors) AS vis2019 FROM all_visitors
WHERE year = 2019
GROUP BY district)
SELECT cte1.district, cte1.vis2016, cte2.vis2019,
ROUND((cte2.vis2019-cte1.vis2016)/cte1.vis2016, 2) AS pct_change
FROM cte1 JOIN cte2
ON cte1.district = cte2.district
ORDER BY pct_change DESC LIMIT 3;


(SELECT month, SUM(visitors) AS vis FROM all_visitors
WHERE district = 'Hyderabad'
GROUP BY month
ORDER BY vis DESC LIMIT 1)
UNION 
(SELECT month, SUM(visitors) AS vis FROM all_visitors
WHERE district = 'Hyderabad'
GROUP BY month
ORDER BY vis ASC LIMIT 1);

WITH cte1 AS(
SELECT district, SUM(visitors) AS visdom FROM all_visitors
WHERE type = 'domestic'
GROUP BY district),
cte2 AS(
SELECT district, SUM(visitors) AS visfor FROM all_visitors
WHERE type = 'foreign'
GROUP BY district)
(SELECT cte1.district, cte1.visdom, cte2.visfor,
ROUND(cte1.visdom/cte2.visfor, 2) AS ratio
FROM cte1 JOIN cte2
ON cte1.district = cte2.district
ORDER BY ratio DESC LIMIT 3)
UNION 
(SELECT cte1.district, cte1.visdom, cte2.visfor,
ROUND(cte1.visdom/cte2.visfor, 2) AS ratio
FROM cte1 JOIN cte2
ON cte1.district = cte2.district
ORDER BY ratio ASC LIMIT 3);
