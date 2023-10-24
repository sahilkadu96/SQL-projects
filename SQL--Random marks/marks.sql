CREATE DATABASE res1;
USE res1;

CREATE TABLE student_marks (
name VARCHAR(20),
marks INT
)

INSERT INTO student_marks VALUES
('sujit', 58),
('sujit', 58),
('sujit', 63),
('rohan', 64),
('rohan', 57),
('rohan', 58),
('mohan', 36),
('mohan', 60),
('mohan', 61);

SELECT * FROM student_marks;
SELECT DISTINCT name FROM student_marks;

SELECT name, MIN(marks)
FROM student_marks
GROUP BY name;

SELECT name, marks,
ROW_NUMBER() OVER (PARTITION BY name ORDER BY RAND()) AS rn
FROM student_marks;

WITH cte1 AS 
(SELECT name, marks,
ROW_NUMBER() OVER (PARTITION BY name ORDER BY RAND()) AS rn
FROM student_marks)
SELECT name, marks FROM cte1 WHERE rn = 1;


