# Introduction

📊 Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔍 SQL queries? Check them out here: [SQL_Project_Folder](/3_SQL_Project/).

# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

Data hails from my [SQL Course](https://lukebarousse.com/sql). It's packed with insights on job titles, salaries, locations, and essential skills.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used

For my deep dive into the data analyst job market, I harnessed the power of several key tools:

* **SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.
* **PostgreSQL**: The chosen database management system, ideal for handling the job posting data.
* **Visual Studio Code**: My go-to for database management and executing SQL queries.
* **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis

Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs

To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
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
```
Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
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
```

Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:
- **SQL** is leading with a bold count of 8.
- **Python** follows closely with a bold count of 7.
- **Tableau** is also highly sought after, with a bold count of 6.
Other skills like **R**, **Snowflake**, **Pandas**, and **Excel** show varying degrees of demand.

### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```
Here's the breakdown of the most demanded skills for data analysts in 2023
- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 7291         |
| Excel    | 4611         |
| Python   | 4330         |
| Tableau  | 3745         |
| Power BI | 2609         |

*Table of the demand for the top 5 skills in data analyst job postings*

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
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
```

Here's a breakdown of the results for top paying skills for Data Analysts:

* **Big Data & Machine Learning Skills Lead Salaries:** Skills such as PySpark, Databricks, TensorFlow, PyTorch, Keras, and DataRobot are associated with the highest average salaries, reflecting strong industry demand for expertise in large-scale data processing and predictive modeling.
* **Software Development & Collaboration Tools Matter:** Knowledge of development and deployment tools like Bitbucket, GitLab, FastAPI, Angular, Flask, and Swift highlights the premium placed on analysts who can contribute to software workflows, automation, and efficient data pipelines.
* **Core Analytical & Infrastructure Skills Remain Valuable:** Libraries and tools like Pandas, NumPy, Jupyter, Kafka, Cassandra, Linux, and Couchbase show that proficiency in core analytics and data engineering infrastructure continues to boost earning potential, emphasizing the advantage of combining data science with technical engineering skills in remote Data Analyst roles.

| Skills    | Average Salary ($) |
| --------- | -----------------: |
| bitbucket |            189,155 |
| angular   |            185,000 |
| fastapi   |            185,000 |
| keras     |            185,000 |
| pyspark   |            182,586 |
| golang    |            161,750 |
| couchbase |            160,515 |
| watson    |            160,515 |
| gitlab    |            154,500 |
| jupyter   |            151,138 |

*Table of the average salary for the top 10 paying skills for data analysts*

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 25;
```

| Skills     | Demand Count | Average Salary ($) |
| ---------- | -----------: | -----------------: |
| sql        |          398 |             97,237 |
| excel      |          256 |             87,288 |
| python     |          236 |            101,397 |
| tableau    |          230 |             99,288 |
| r          |          148 |            100,499 |
| power bi   |          110 |             97,431 |
| sas        |           63 |             98,902 |
| powerpoint |           58 |             88,701 |
| looker     |           49 |            103,795 |
| word       |           48 |             82,576 |
| snowflake  |           37 |            112,948 |
| oracle     |           37 |            104,534 |
| sql server |           35 |             97,786 |
| azure      |           34 |            111,225 |
| aws        |           32 |            108,317 |
| sheets     |           32 |             86,088 |
| flow       |           28 |             97,200 |
| go         |           27 |            115,320 |
| spss       |           24 |             92,170 |
| vba        |           24 |             88,783 |
| hadoop     |           22 |            113,193 |
| jira       |           20 |            104,918 |
| javascript |           20 |             97,587 |
| sharepoint |           18 |             81,634 |

*Table of the most optimal skills for data analyst sorted by salary*

Here's a breakdown of the most optimal skills for Data Analysts in 2023: 
* **High Demand Core Skills:** SQL, Excel, Python, and Tableau dominate in terms of job postings, reflecting their foundational role in daily data analysis tasks. These skills are not only widely required but also maintain strong salary potential, showing that mastery of core data manipulation, visualization, and programming tools remains essential for any Data Analyst. Other high-demand skills like R, Power BI, SAS, and Looker further emphasize the need for both statistical programming and business intelligence expertise in the market.

* **High-Paying Niche & Cloud Skills:** Skills like Go, Snowflake, Hadoop, Azure, and AWS are associated with higher salaries despite slightly lower demand. This highlights the premium for **data engineering, cloud computing, and distributed data processing skills**. Professionals who combine traditional analytical capabilities with cloud and big data expertise can command significantly higher compensation. Similarly, tools supporting workflow automation and advanced reporting, such as Jira, Flow, and advanced SQL Server usage, also contribute to higher earning potential, underscoring the advantage of hybrid analytics–engineering skill sets in remote and high-level Data Analyst roles.

# What I Learned

Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- **🧩 Complex Query Crafting:** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
- **📊 Data Aggregation:** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
- **💡 Analytical Wizardry:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusions

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.



