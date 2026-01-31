-- What is the top 5 skills demanded

WITH TOP_5_Demanded_skills AS (
    SELECT 
        skill_id,
        count(skill_id) AS count
    FROM
        skills_job_dim
    GROUP BY
        skill_id
    ORDER BY
        count DESC
    LIMIT
        5
)

SELECT 
    skills_dim.skills,
    skills_dim.skill_id,
    TOP_5_Demanded_skills.count
FROM 
    skills_dim
left join 
    TOP_5_Demanded_skills on skills_dim.skill_id = TOP_5_Demanded_skills.skill_id
where skills_dim.skill_id = TOP_5_Demanded_skills.skill_id
