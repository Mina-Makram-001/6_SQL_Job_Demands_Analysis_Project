SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    jan_jobs

Union

SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    feb_jobs

Union

SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    mar_jobs;

-- Notice that at Union we should have the same amount of columns
-- at union we do not take reduplicates
-- at union all we take the reduplicates

SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    jan_jobs

Union ALL

SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    feb_jobs

Union ALL

SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    mar_jobs;

-- compare both total of outputs 