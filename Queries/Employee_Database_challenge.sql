-- Get employee details who are born between January 01, 1952 and December 31,1955
SELECT e.emp_no,
       e.first_name,
	   e.last_name,
	   ti.title,
	   ti.from_date,
	   ti.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- Filter the retirement_title data to get only the employee records with latest title
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
							  rt.first_name,
							  rt.last_name,
							  rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY rt.emp_no, rt.to_date DESC;

-- Get the count of employees grouped by titles
SELECT COUNT(ut.emp_no), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT DESC;

SELECT * FROM retiring_titles;

-- Get the employees eligible for mentor ship who are born between
-- January 01,1965 and December 31,1965. Display the last title they held.
SELECT DISTINCT ON (e.emp_no) e.emp_no,
       e.first_name,
	   e.last_name,
	   e.birth_date,
	   de.from_date,
	   de.to_date,
	   ti.title
INTO mentorship_eligibilty
FROM employees as e
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31' 
	   AND de.to_date = '9999-01-01')
ORDER BY e.emp_no, ti.to_date DESC;
