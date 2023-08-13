CREATE DATABASE census;
DROP DATABASE census;
USE census;

SELECT * FROM dataset1p;
SELECT * FROM dataset2p;


/*dataset for Jharkhand & Bihar*/
SELECT * FROM dataset1p
WHERE state in ('Jharkhand', 'Bihar');

/*population of India*/
SELECT SUM(Population) as total_pop FROM dataset2p;

/*averge growth of India*/
SELECT AVG(growth) as avg_growth FROM dataset1p;

/* top3 average grouwth per state*/
SELECT state, AVG(growth) as avg_growth FROM dataset1p
GROUP BY state
ORDER BY avg_growth DESC LIMIT 3;

/*average sex ratio per state*/
SELECT state, ROUND(AVG(sex_ratio), 0) as avg_sex_ratio FROM dataset1p
GROUP BY state
ORDER BY avg_sex_ratio DESC;

/*average literacy above 90 per state*/
SELECT state, AVG(literacy) as avg_literacy FROM dataset1p
GROUP BY state
HAVING avg_literacy > 90
ORDER BY avg_literacy DESC;


/*top and bottom 3 states for literacy*/


