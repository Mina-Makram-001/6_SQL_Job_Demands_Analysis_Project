/*
SELECT 
job_title_short AS job,
job_location AS location,
job_posted_date AS date
FROM job_postings_fact
LIMIT 10;
*/

-- COMPARE BOTH
/*
SELECT 
job_title_short AS job,
job_location AS location,
job_posted_date::DATE AS date
FROM job_postings_fact
LIMIT 10;
*/
-- =========================================================
-- POSTGRESQL :: (TYPE CASTING) SUMMARY
-- =========================================================
--
-- The :: operator is used for EXPLICIT TYPE CASTING in PostgreSQL.
--
-- Syntax:
--   value :: target_type
--
-- Meaning:
--   Convert a value from its current data type to another data type.
--
-- Example:
--   job_posted_date::DATE
--   → Converts TIMESTAMP to DATE (drops the time part)
--
-- ---------------------------------------------------------
-- COMMON USE CASES
-- ---------------------------------------------------------
--
-- 1) DATE & TIME CASTING
--   timestamp_col::DATE        -- remove time
--   date_col::TIMESTAMP        -- add time (00:00:00)
--   timestamp_col::TIME        -- extract time only
--
-- 2) TEXT CASTING
--   any_column::TEXT           -- convert to text
--   Used for concatenation, debugging, exporting
--
-- 3) NUMBER CASTING
--   '100'::INT                 -- text → integer
--   '55000.5'::NUMERIC         -- text → numeric
--   int_col::NUMERIC           -- integer → numeric
--   numeric_col::INT           -- truncates decimals (no rounding)
--
-- 4) BOOLEAN CASTING
--   'true'::BOOLEAN, 'false'::BOOLEAN
--   1::BOOLEAN   -- true
--   0::BOOLEAN   -- false
--
-- 5) CALCULATIONS
--   salary_year_avg::NUMERIC / 12
--   -- avoids integer division errors
--
-- 6) WHERE CONDITIONS
--   WHERE salary_year_avg::NUMERIC > 50000
--   WHERE job_posted_date::DATE >= '2024-01-01'
--
-- 7) GROUP BY / ORDER BY
--   GROUP BY job_posted_date::DATE
--   ORDER BY salary_year_avg::NUMERIC DESC
--
-- 8) NULL CASTING
--   NULL::TEXT
--   NULL::INT
--   NULL::DATE
--   -- Required in UNION and CASE expressions
--
-- 9) CASE EXPRESSIONS
--   CASE
--     WHEN salary_year_avg IS NULL THEN 'Unknown'
--     ELSE salary_year_avg::TEXT
--   END
--
-- ---------------------------------------------------------
-- :: VS CAST()
-- ---------------------------------------------------------
-- These are equivalent:
--   column::TYPE
--   CAST(column AS TYPE)
--
-- :: is PostgreSQL-specific and shorter.
-- CAST() is standard SQL and more portable.
--
-- ---------------------------------------------------------
-- WHEN TO USE ::
-- ---------------------------------------------------------
-- Use :: when:
--   - Working only with PostgreSQL
--   - Writing analytics / reporting queries
--   - You want concise, readable SQL
--
-- Avoid :: when:
--   - Writing cross-database SQL (use CAST instead)
--
-- ---------------------------------------------------------
-- MEMORY TIP:
-- ---------------------------------------------------------
-- :: means "treat this value as another data type"
-- =========================================================

/*
SELECT 
job_title_short AS job,
job_location AS location,
job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date
FROM job_postings_fact
LIMIT 10;
*/
/*
SELECT 
job_title_short AS job,
job_location AS location,
job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date,
EXTRACT(MONTH FROM job_posted_date) AS MONTH,
EXTRACT(YEAR FROM job_posted_date) AS YEAR
FROM job_postings_fact
LIMIT 10;
*/


SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY month
ORDER BY job_posted_count DESC;
