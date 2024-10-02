-- use sf_salary
#min, max, average, and median of the totalpaybenefit
-- WITH salary_with_ranks AS (
--     SELECT 
--         totalpaybenefits AS total_salary,
--         ROW_NUMBER() OVER (ORDER BY totalpaybenefits) AS row_num,
--         COUNT(*) OVER () AS total_count
--     FROM salary
-- )
-- SELECT
--     MIN(total_salary) AS min_salary,
--     MAX(total_salary) AS max_salary,
--     round(AVG(total_salary),2) AS avg_salary,
--     round(AVG(CASE 
--         WHEN total_count % 2 = 1 AND row_num = (total_count + 1) / 2 THEN total_salary
--         WHEN total_count % 2 = 0 AND row_num IN ((total_count / 2), (total_count / 2) + 1) THEN total_salary
--     END),2) AS median_salary
-- FROM salary_with_ranks;

# Pay disparities by job title
-- SELECT 
--     e.jobtitle AS job_title,
--     round(AVG(s.totalpaybenefits),2) AS average_salary,
--     round(MAX(s.totalpaybenefits),2) AS max_salary,
--     round(MIN(s.totalpaybenefits),2) AS min_salary
-- FROM 
--     employee AS e 
-- JOIN 
--     salary AS s 
-- ON 
--     e.id = s.employee_id
-- GROUP BY 
--     e.jobtitle
-- ORDER BY 
--     average_salary DESC
    
# Who earns the most by each year and what their jobs are
-- select 
-- s.year,
-- e.id as employee_id,
-- e.employeename as employee_name,
-- e.jobtitle as job,
-- s.totalpaybenefits as total_salary
-- from employee as e join salary as s on e.id=s.employee_id
-- WHERE 
--     (s.totalpaybenefits, s.year) IN (
--         SELECT 
--             MAX(totalpaybenefits), 
--             year 
--         FROM 
--             salary 
--         GROUP BY 2
--     )
-- order by 1

# Rank top 3 total salaries in each job title by year
-- WITH ranked_salaries AS (
--     SELECT 
--         e.jobtitle AS job_title,
--         e.employeename AS employee_name,
--         s.totalpaybenefits AS total_salary,
--         RANK() OVER (PARTITION BY e.jobtitle ORDER BY s.totalpaybenefits DESC) AS ranking,
--         s.year
--     FROM 
--         employee AS e 
--     JOIN 
--         salary AS s 
--     ON 
--         e.id = s.employee_id
-- )
-- SELECT *
-- FROM ranked_salaries
-- WHERE ranking <= 3
-- ORDER BY job_title, employee_name, total_salary DESC;

#bucketize 3 levels of totalpaybenefit by using NTILE
-- select
-- a.id as employee_id,
-- a.employeename as employee_name,
-- a.jobtitle as job_title,
-- a.year,
-- CASE WHEN a.bucket = 1 THEN 'Low'
-- 	 WHEN a.bucket = 2 THEN 'Medium'
--      WHEN a.bucket = 3 THEN 'High'
--     END AS salary_buckets
-- from(
-- select 
-- e.id,
-- e.employeename,
-- e.jobtitle,
-- s.year,
-- NTILE(3) OVER (ORDER BY s.totalpaybenefits ASC) AS bucket
--     FROM employee as e join salary as s on e.id=s.employee_id
-- ) AS a
-- order by year desc, salary_buckets, employee_name;

#window function for department