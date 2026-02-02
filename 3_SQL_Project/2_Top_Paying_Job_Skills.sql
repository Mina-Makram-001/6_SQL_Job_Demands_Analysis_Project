/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
  helping job seekers understand which skills to develop that align with top salaries
*/

WITH TOP_10_PAYING_JOBS AS (
    SELECT 
        job_id,
        job_title,
        salary_year_avg ,
        job_country,
        name AS company_name
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
    LIMIT 10
)

SELECT
    sd.skills,
    COUNT(*) AS skill_count
FROM TOP_10_PAYING_JOBS tpj
INNER JOIN skills_job_dim sjd ON tpj.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
GROUP BY sd.skills
ORDER BY skill_count DESC;
