SELECT first_name, last_name FROM employees  WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name FROM employees  WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name FROM employees  WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name FROM employees  WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name FROM employees  WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;
-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
    ri.first_name,
ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

SELECT * FROM current_emp;

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO empcount_by_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT e.emp_no,
       e.last_name,
	   e.first_name,
	   e.gender,
	   s.salary,
	   de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01')
;


SELECT d.dept_no,
       d.dept_name,
	   dm.emp_no,
	   ce.first_name,
	   ce.last_name,
	   dm.from_date,
	   dm.to_date
INTO mgr_info	   
FROM departments as d
INNER JOIN dept_manager as dm
ON (d.dept_no = dm.dept_no)
INNER JOIN current_emp as ce
ON (dm.emp_no = ce.emp_no);
--WHERE dm.to_date = '9999-01-01';

SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

SELECT de.emp_no,
       ce.first_name,
	   ce.last_name,
	   d.dept_name
FROM dept_emp as de
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
INNER JOIN current_emp as ce
ON (de.emp_no = ce.emp_no)
INNER JOIN retirement_info as ri
ON (de.emp_no = ri.emp_no)
WHERE (d.dept_name = 'Sales') AND 
(ce.first_name = ri.first_name) AND 
(ce.last_name = ri.last_name);

SELECT de.emp_no,
       ce.first_name,
	   ce.last_name,
	   d.dept_name
INTO sales_n_dev_retiring_emps	   
FROM dept_emp as de
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
INNER JOIN current_emp as ce
ON (de.emp_no = ce.emp_no)
INNER JOIN retirement_info as ri
ON (de.emp_no = ri.emp_no)
WHERE (d.dept_name IN ('Sales','Development')) AND 
(ce.first_name = ri.first_name) AND 
(ce.last_name = ri.last_name);