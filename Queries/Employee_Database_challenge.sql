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
--INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT DESC;

SELECT * FROM retiring_titles;

SELECT COUNT(ut.emp_no) as total_retiring_emps
FROM unique_titles as ut;

-- Filter the retirement_title data to get only the employee records with latest title and add dept name for each employee
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
							  rt.first_name,
							  rt.last_name,
							  rt.title,
							  d.dept_name
INTO unique_titles_dept
FROM retirement_titles as rt
INNER JOIN dept_emp as de
ON (rt.emp_no = de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
ORDER BY rt.emp_no, rt.to_date DESC;


-- Get the count of mentorship eligible employees further grouped by department
SELECT COUNT(utd.emp_no), utd.dept_name as ret_emp_dept, utd.title as ret_emp_title
INTO retirement_titles_by_dept
FROM unique_titles_dept as utd
GROUP BY utd.dept_name, utd.title 
ORDER BY utd.dept_name;


-- Get the employees eligible for mentor ship who are born between
-- January 01,1965 and December 31,1965. Display the last title they held.
-- Additional query: to get department for each eligible employee 
SELECT DISTINCT ON (e.emp_no) e.emp_no,
       e.first_name,
	   e.last_name,
	   e.birth_date,
	   de.from_date,
	   de.to_date,
	   ti.title,
	   d.dept_name
INTO mentorship_eligibilty_dept
FROM employees as e
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31' 
	   AND de.to_date = '9999-01-01')
ORDER BY e.emp_no, ti.to_date DESC;

-- Get the count of mentorship eligible employees further grouped by department
SELECT COUNT(med.emp_no), med.dept_name as mentor_dept, med.title as mentor_titles
INTO mentorship_titles_by_dept
FROM mentorship_eligibilty_dept as med
GROUP BY med.dept_name, med.title 
ORDER BY med.dept_name;

-- Get the count of mentorship eligible employees 
SELECT COUNT(me.emp_no), me.title as mentor_titles
FROM mentorship_eligibilty as me
GROUP BY me.title
ORDER BY COUNT DESC;


-- JOIN the retirement and mentorship table by title and dept_name
-- retirement_titles_by_dept
-- mentorship_titles_by_dept
SELECT rtd.ret_emp_dept as dept_name, 
	   rtd.ret_emp_title as title, 
	   rtd.count as no_of_retiring_emps,
	   mtd.count as no_of_mentors
FROM retirement_titles_by_dept as rtd
INNER JOIN mentorship_titles_by_dept as mtd
ON (rtd.ret_emp_dept = mtd.mentor_dept AND rtd.ret_emp_title = mtd.mentor_titles)
ORDER BY rtd.ret_emp_dept;


SELECT SUM(rtd.count) as total_ret_emps
FROM retirement_titles_by_dept as rtd;

SELECT SUM(mtd.count) as total_mentor_emps
FROM mentorship_titles_by_dept as mtd;


