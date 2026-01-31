CREATE TABLE JAN_JOBS AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1;


CREATE TABLE FEB_JOBS AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 2;


CREATE TABLE MAR_JOBS AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT job_posted_date
FROM JAN_JOBS;