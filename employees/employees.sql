--  Sample employee database 
--  See changelog table for details
--  Copyright (C) 2007,2008, MySQL AB
--  
--  Original data created by Fusheng Wang and Carlo Zaniolo
--  http://www.cs.aau.dk/TimeCenter/software.htm
--  http://www.cs.aau.dk/TimeCenter/Data/employeeTemporalDataSet.zip
-- 
--  Current schema by Giuseppe Maxia 
--  Data conversion from XML to relational by Patrick Crews
-- 
-- This work is licensed under the 
-- Creative Commons Attribution-Share Alike 3.0 Unported License. 
-- To view a copy of this license, visit 
-- http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to 
-- Creative Commons, 171 Second Street, Suite 300, San Francisco, 
-- California, 94105, USA.
-- 
--  DISCLAIMER
--  To the best of our knowledge, this data is fabricated, and
--  it does not correspond to real people. 
--  Any similarity to existing people is purely coincidental.
-- 

DROP DATABASE IF EXISTS employees;
CREATE DATABASE IF NOT EXISTS employees;
USE employees;

SELECT 'CREATING DATABASE STRUCTURE' as 'INFO';

DROP TABLE IF EXISTS dept_emp,
                     dept_manager,
                     titles,
                     salaries, 
                     employees, 
                     departments;

/*!50503 set default_storage_engine = InnoDB */;
/*!50503 select CONCAT('storage engine: ', @@default_storage_engine) as INFO */;

CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      ENUM ('M','F')  NOT NULL,    
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE  KEY (dept_name)
);

CREATE TABLE dept_manager (
   emp_no       INT             NOT NULL,
   dept_no      CHAR(4)         NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no)
); 

CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title, from_date)
) 
; 

CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
) 
; 

CREATE OR REPLACE VIEW dept_emp_latest_date AS
    SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM dept_emp
    GROUP BY emp_no;

# shows only the current department for each employee
CREATE OR REPLACE VIEW current_dept_emp AS
    SELECT l.emp_no, dept_no, l.from_date, l.to_date
    FROM dept_emp d
        INNER JOIN dept_emp_latest_date l
        ON d.emp_no=l.emp_no AND d.from_date=l.from_date AND l.to_date = d.to_date;

flush /*!50503 binary */ logs;

/*SELECT 'LOADING departments' as 'INFO';
source load_departments.dump ;
SELECT 'LOADING employees' as 'INFO';
source load_employees.dump ;
SELECT 'LOADING dept_emp' as 'INFO';
source load_dept_emp.dump ;
SELECT 'LOADING dept_manager' as 'INFO';
source load_dept_manager.dump ;
SELECT 'LOADING titles' as 'INFO';
source load_titles.dump ;
SELECT 'LOADING salaries' as 'INFO';
source load_salaries1.dump ;
source load_salaries2.dump ;
source load_salaries3.dump ;

source show_elapsed.sql ;*/
USE employees;
DROP DATABASE employees;

#1
SELECT first_name, last_name, gender, dept_name, TIMESTAMPDIFF(YEAR,birth_date,NOW()) AS age, TIMESTAMPDIFF(YEAR,hire_date,NOW()) AS years_in_the_company, dept_name, YEAR(de.from_date) AS year_of_entrance_in_the_department, title
FROM employees AS e
INNER JOIN dept_emp AS de
ON e.emp_no = de.emp_no
INNER JOIN departments AS d
ON de.dept_no = d.dept_no
INNER JOIN titles AS t
ON e.emp_no = t.emp_no
WHERE t.to_date > CURDATE() #include only current job title for those who had more than one job title in the company
AND de.to_date > CURDATE() #esclude the people who are now retired
ORDER BY 1, 2
LIMIT 10;

#2
SELECT dept_name, COUNT(*) AS nb_of_employes
FROM dept_emp AS de
INNER JOIN departments AS d
ON d.dept_no = de.dept_no
WHERE de.to_date > CURDATE() #exclude the people who are not anymore in the department (retired, who left the company, who changed the department...)
GROUP BY d.dept_no
ORDER BY 2 DESC;

#3
SELECT first_name, last_name, dept_name, salary, title
FROM employees AS e
INNER JOIN dept_emp AS de
ON de.emp_no = e.emp_no
INNER JOIN departments AS d
ON de.dept_no = d.dept_no
INNER JOIN  salaries AS s 
ON e.emp_no = s.emp_no
INNER JOIN titles AS t
ON e.emp_no = t.emp_no
WHERE de.to_date > CURDATE() #exclude the people who are not anymore in the department (retired, who left the company, who changed the department...)
AND t.to_date > CURDATE() #include only current job title for those who had more than one job title in the company
AND s.to_date > CURDATE() #include only current salary
ORDER BY 3, 2, 1
LIMIT 10;

#4
SELECT title, ROUND(AVG(salary)) AS avg_salary
FROM salaries AS s
INNER JOIN titles AS t
ON  s.emp_no = t.emp_no
WHERE s.to_date > CURDATE() #include only current salary
AND t.to_date > CURDATE() #include only current job title for those who had more than one job title in the company
GROUP BY 1
ORDER BY 2 DESC;

#5.1
SELECT AVG(TIMESTAMPDIFF(year,birth_date,NOW())) AS avg_age
FROM employees AS e;

#5.2
SELECT dept_name, AVG(TIMESTAMPDIFF(year,birth_date,now())) AS avg_age
FROM employees AS e
INNER JOIN dept_emp AS de
ON e.emp_no = de. emp_no
INNER JOIN departments AS d
ON d.dept_no = de.dept_no
WHERE de.to_date > CURDATE()  #exclude the people who are not anymore in the department (retired, who left the company, who changed the department...)
GROUP BY 1
ORDER BY 2;

#5.3
SELECT title, AVG(TIMESTAMPDIFF(year,birth_date,now())) AS avg_age
FROM employees AS e
INNER JOIN titles AS t
ON e.emp_no = t. emp_no
WHERE t.to_date > CURDATE() #include only current job title for those who had more than one job title in the company
GROUP BY 1
ORDER BY 2;

#6.1
SELECT dept_name, SUM(CASE WHEN gender = "M" THEN 1 ELSE 0 END)/SUM(CASE WHEN gender = "F" THEN 1 ELSE 0 END) AS men_women_ratio
FROM employees AS e
INNER JOIN dept_emp AS de
ON e.emp_no = de. emp_no 
INNER JOIN departments AS d
ON d.dept_no = de.dept_no
WHERE de.to_date > CURDATE()  #exclude the people who are not anymore in the department (retired, who left the company, who changed the department...)
GROUP BY 1
ORDER BY 2;

#6.2
SELECT title, SUM(CASE WHEN gender = "M" THEN 1 ELSE 0 END)/SUM(CASE WHEN gender = "F" THEN 1 ELSE 0 END) AS men_women_ratio
FROM employees AS e
INNER JOIN titles AS t
ON e.emp_no = t.emp_no
WHERE t.to_date > CURDATE() #include only current job title for those who had more than one job title in the company
GROUP BY 1
ORDER BY 2;

#7.1
SELECT first_name, last_name, min_salary, gender, TIMESTAMPDIFF(YEAR,birth_date,NOW()) AS age, TIMESTAMPDIFF(YEAR,hire_date,NOW()) AS years_in_the_company
FROM employees AS e
INNER JOIN salaries AS s
ON e.emp_no = s.emp_no
INNER JOIN (SELECT MIN(salary) AS min_salary FROM salaries) AS m
ON s.salary = m.min_salary
WHERE s.to_date > CURDATE() #include only current salary
ORDER BY 3;

#7.2
SELECT first_name, last_name, max_salary, gender, TIMESTAMPDIFF(YEAR,birth_date,NOW()) AS age, TIMESTAMPDIFF(YEAR,hire_date,NOW()) AS years_in_the_company
FROM employees AS e
INNER JOIN salaries AS s
ON e.emp_no = s.emp_no 
INNER JOIN (SELECT MAX(salary) AS max_salary FROM salaries) AS m
ON s.salary = m.max_salary
WHERE s.to_date > CURDATE() #include only current salary
ORDER BY 3 DESC;

#7.3
SELECT first_name, last_name, salary, gender, TIMESTAMPDIFF(YEAR,birth_date,NOW()) AS age, TIMESTAMPDIFF(YEAR,hire_date,NOW()) AS years_in_the_company
FROM employees AS e
INNER JOIN salaries AS s
ON e.emp_no = s.emp_no 
WHERE salary > (SELECT AVG(salary) FROM employees.salaries)
AND s.to_date > CURDATE() #include only current salary
ORDER BY 3 DESC
LIMIT 10;


#8
SELECT first_name, last_name, hire_date
FROM employees AS e
WHERE EXTRACT(MONTH FROM hire_date) = 12
ORDER BY 3 DESC
LIMIT 10;


#####
#9.1
SELECT first_name, last_name, dept_name, TIMESTAMPDIFF(YEAR,hire_date,NOW()) AS years_in_the_company
FROM employees AS e, departments AS d, dept_emp AS de
WHERE e.emp_no = de. emp_no AND d.dept_no = de.dept_no
AND de.to_date > CURDATE()  #exclude the people who are not anymore in the department (retired, who left the company, who changed the department...)
AND TIMESTAMPDIFF(YEAR,hire_date,NOW()) = 
(SELECT MAX(TIMESTAMPDIFF(YEAR,hire_date,NOW())) FROM employees.employees AS ee, employees.dept_emp AS dee WHERE de.dept_no = dee.dept_no AND ee.emp_no = dee.emp_no)
GROUP BY 3;	

#9.2
SELECT first_name, last_name, MAX(TIMESTAMPDIFF(YEAR,hire_date,NOW())) AS years_in_the_company
FROM employees.employees AS e;
#####

#9.1
SELECT first_name, last_name, dept_name, YEAR(CURDATE())-YEAR(hire_date) AS 'Years in the company'
FROM employees AS e
INNER JOIN dept_emp AS de
ON e.emp_no = de.emp_no
INNER JOIN departments AS d
ON de.dept_no = d.dept_no
WHERE de.to_date > CURDATE() 
AND ((dept_name, (YEAR(CURDATE())-YEAR(hire_date))) IN (
    SELECT dept_name, max(YEAR(CURDATE()) - YEAR(hire_date)) AS 'Most experimented'
    FROM employees AS e
    INNER JOIN dept_emp AS de
    ON e.emp_no = de.emp_no 
    INNER JOIN departments AS d
    ON de.dept_no = d.dept_no
    WHERE de.to_date > CURDATE() 
    GROUP BY 1
    ))
    ORDER BY 4 DESC
    LIMIT 10;

select employees.emp_no, first_name, 
		last_name, dept_name, 
        YEAR(CURDATE())-YEAR(hire_date) as 'Years in the company'
		from employees inner join dept_emp 
		on employees.emp_no = dept_emp.emp_no
		inner join departments
        on dept_emp.dept_no = departments.dept_no
        where dept_emp.to_date > CURDATE() 
        and ((dept_name, (YEAR(CURDATE())-YEAR(hire_date))) in (
			select dept_name, max(YEAR(CURDATE()) - YEAR(hire_date)) as 'Most experimented'
			from employees inner join dept_emp 
			on employees.emp_no = dept_emp.emp_no
			inner join departments 
			on dept_emp.dept_no = departments.dept_no
			where dept_emp.to_date > CURDATE() 
            group by dept_name
        ))
        order by YEAR(CURDATE())-YEAR(hire_date) desc, dept_name; 

#10
SELECT first_name, last_name, dept_name, YEAR(CURDATE())-YEAR(hire_date) AS 'Years in the company'
FROM employees AS e
INNER JOIN dept_emp AS de
ON e.emp_no = de.emp_no
INNER JOIN departments AS d
ON de.dept_no = d.dept_no
WHERE de.to_date > CURDATE() AND YEAR(CURDATE())-YEAR(hire_date) = (
		SELECT MIN(YEAR(CURDATE())-YEAR(hire_date))
		FROM employees)
ORDER BY 4, 3
LIMIT 10; 



select employees.emp_no, first_name, last_name, dept_name, 
	YEAR(CURDATE())-YEAR(hire_date) as 'Years in the company'
    from employees inner join dept_emp 
		on employees.emp_no = dept_emp.emp_no
		inner join departments 
        on dept_emp.dept_no = departments.dept_no
        where dept_emp.to_date > CURDATE() and YEAR(CURDATE())-YEAR(hire_date) = (
			select min(YEAR(CURDATE())-YEAR(hire_date))
            from employees); 

USE employees;

#11
## Percentage of job position in the company
SELECT title, COUNT(title) AS nb_of_employees, CONCAT(COUNT(title)*100/(SELECT COUNT(*) FROM titles WHERE to_date > CURDATE()), " %") AS percentage
FROM titles
WHERE to_date > CURDATE()
GROUP BY 1
ORDER BY 1;

#12
## Women/men and avg salary per position
SELECT title, gender, ROUND(AVG(salary)) AS avg_salary
FROM salaries AS s
INNER JOIN titles AS t
ON  s.emp_no = t.emp_no
INNER JOIN employees AS e
ON s.emp_no = e.emp_no
WHERE s.to_date > CURDATE() #include only current salary
AND t.to_date > CURDATE() #include only current job title for those who had more than one job title in the company
GROUP BY 1, 2
ORDER BY 1, 2; 

#13
## years in the company - avg salary
SELECT YEAR(CURDATE())-YEAR(hire_date) AS 'Years in the company', ROUND(AVG(salary)) AS avg_salary
FROM employees AS e
INNER JOIN titles AS t
ON  e.emp_no = t.emp_no
INNER JOIN salaries AS s
ON  s.emp_no = e.emp_no
GROUP BY 1
ORDER BY 1;


select e.emp_no, e.first_name, e.last_name, d.dept_no, d.from_date,
		d.to_date, avg(salary) 
        from dept_emp as d
		inner join employees as e on e.emp_no = d.emp_no
		inner join salaries as s on e.emp_no = s.emp_no and s.from_date = d.from_date and s.to_date = d.to_date
        where e.emp_no in (select emp_no from dept_emp group by 1 having count(emp_no) > 1)
		group by 1, 2, 3, 4, 5, 6
        order by 1
        limit 10;

select e.first_name, e.last_name, d.dept_no, salary, d.from_date,
		d.to_date
from dept_emp as d
inner join employees as e on e.emp_no = d.emp_no
inner join salaries as s on e.emp_no = s.emp_no #and s.from_date = d.from_date and s.to_date = d.to_date
where e.emp_no = 10018
order by 5, 6;

select emp_no, salary, from_date, to_date
from salaries
where emp_no = 10018;

SELECT title, d_name.dept_name, ROUND(MIN(salary)) AS min_salary, ROUND(MAX(salary)) AS max_salary, ROUND(AVG(salary)) AS avg_salary
FROM salaries AS s
INNER JOIN titles AS t
ON  s.emp_no = t.emp_no
INNER JOIN dept_emp AS d
ON d.emp_no = s.emp_no
INNER JOIN departments AS d_name ON d_name.dept_no = d.dept_no
WHERE d.to_date > CURDATE() #include onlu current d
AND s.to_date > CURDATE() #include only current salary
AND t.to_date > CURDATE() #include only current job title for those who had more than one job title in the company
GROUP BY 1, 2
ORDER BY 1, 2 DESC;

