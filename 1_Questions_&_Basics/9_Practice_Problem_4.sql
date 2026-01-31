/*
Query Goal: Find Data Analyst job postings from the first quarter (Jan-Mar) 
with a salary above $70k. 
- Combine Q1 tables
- Filter for 'Data Analyst' and salary > 70,000
- Order by salary descending
*/
SELECT
    quarter1_job_postings.job_location,
    quasql_courserter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date::DATE,
    quarter1_job_postings.salary_year_avg
FROM (
    SELECT *
    FROM jan_jobs
    UNION ALL
    SELECT *
    FROM feb_jobs
    UNION ALL
    SELECT *
    FROM mar_jobs
) AS quarter1_job_postings
WHERE
    quarter1_job_postings.salary_year_avg > 70000 AND
    quarter1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    quarter1_job_postings.salary_year_avg DESC