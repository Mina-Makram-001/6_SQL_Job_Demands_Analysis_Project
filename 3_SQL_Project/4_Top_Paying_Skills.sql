/*
Answer: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts and 
  helps identify the most financially rewarding skills to acquire or improve
*/

SELECT
    sd.skills,
    AVG(jpf.salary_year_avg) AS salary_avg_per_skill
FROM
    skills_dim AS sd
INNER JOIN skills_job_dim AS sjd
    ON sjd.skill_id = sd.skill_id
INNER JOIN job_postings_fact AS jpf
    ON jpf.job_id = sjd.job_id
WHERE
    jpf.job_title_short ILIKE '%data%'
    AND jpf.job_title_short ILIKE '%analyst%'
    AND jpf.salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    sd.skills
ORDER BY
    salary_avg_per_skill DESC
LIMIT 25;
