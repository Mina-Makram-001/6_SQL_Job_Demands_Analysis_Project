SELECT AVG(min_salary)
FROM (
SELECT
job_title_short,
MIN(salary_year_avg) AS min_salary
FROM job_postings_fact
GROUP BY job_title_short
) sub;

SELECT AVG(max_salary)
FROM (
SELECT
job_title_short,
MAX(salary_year_avg) AS max_salary
FROM job_postings_fact
GROUP BY job_title_short
) sub;

SELECT
    job_title_short,
    salary_year_avg,
    CASE
        WHEN salary_year_avg < 29350 THEN 'LOW'
        WHEN salary_year_avg BETWEEN 29350 AND 524246 THEN 'STANDARD'
        WHEN salary_year_avg > 524246 THEN 'HIGH'
        ELSE 'UNKNOWN'
    END AS salary_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
  AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC;
