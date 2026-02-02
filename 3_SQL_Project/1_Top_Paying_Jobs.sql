/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries (remove nulls).
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into empl
*/

SELECT 
    job_id,
    job_title,
    salary_year_avg ,
    job_location,
    job_country,
    name AS company_name,
    job_schedule_type
FROM
    job_postings_fact AS jpf
LEFT JOIN company_dim AS cd ON jpf.company_id = cd.company_id
WHERE
    (job_title_short LIKE '%Data%'
    AND
    job_title_short LIKE '%Analyst%') AND
    (salary_year_avg IS NOT NULL) AND
    (job_location LIKE '%Anywhere%')
ORDER BY 
    salary_year_avg DESC
LIMIT 10;


