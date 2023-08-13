CREATE SCHEMA car;
USE car;
SELECT * FROM cardekho;

/*Total cars*/
SELECT COUNT(*) FROM cardekho;

/*Cars available in 2023*/
SELECT COUNT(*) FROM cardekho
WHERE year = 2023;

/*Cars available in 2020, 2021, 2022*/
SELECT year, COUNT(*) FROM cardekho
WHERE year BETWEEN 2020 AND 2022
GROUP BY year;

/*Diesel cars in 2020*/
SELECT COUNT(*) FROM cardekho
WHERE year = 2020 AND fuel = 'Diesel';

/*Print all fuel cars by all years*/
SELECT fuel, year, COUNT(fuel) FROM cardekho
WHERE fuel IN ('Petrol', 'Diesel', 'CNG')
GROUP BY fuel, year;

/*Which year has more than 100 cars?*/
SELECT year, COUNT(year) FROM cardekho
GROUP BY year
HAVING COUNT(year) > 100;