-- Create company_dim table with primary key
CREATE TABLE public.company_dim
(
    company_id INT PRIMARY KEY,
    name TEXT,
    link TEXT,
    link_google TEXT,
    thumbnail TEXT
);

-- Create skills_dim table with primary key
CREATE TABLE public.skills_dim
(
    skill_id INT PRIMARY KEY,
    skills TEXT,
    type TEXT
);

-- Create job_postings_fact table with primary key
CREATE TABLE public.job_postings_fact
(
    job_id INT PRIMARY KEY,
    company_id INT,
    job_title_short VARCHAR(255),
    job_title TEXT,
    job_location TEXT,
    job_via TEXT,
    job_schedule_type TEXT,
    job_work_from_home BOOLEAN,
    search_location TEXT,
    job_posted_date TIMESTAMP,
    job_no_degree_mention BOOLEAN,
    job_health_insurance BOOLEAN,
    job_country TEXT,
    salary_rate TEXT,
    salary_year_avg NUMERIC,
    salary_hour_avg NUMERIC,
    FOREIGN KEY (company_id) REFERENCES public.company_dim (company_id)
);

-- Create skills_job_dim table with a composite primary key and foreign keys
CREATE TABLE public.skills_job_dim
(
    job_id INT,
    skill_id INT,
    PRIMARY KEY (job_id, skill_id),
    FOREIGN KEY (job_id) REFERENCES public.job_postings_fact (job_id),
    FOREIGN KEY (skill_id) REFERENCES public.skills_dim (skill_id)
);

-- NOTE:
-- The table OWNER is the role that has full control over the table.
-- The owner can:
--   - DROP the table
--   - ALTER the table structure
--   - GRANT or REVOKE privileges
--   - Change the table owner
--   - Perform any operation on the table
--
-- Other users cannot perform these actions unless:
--   - The owner explicitly grants them permissions, or
--   - They are a superuser (e.g., postgres)


-- Set ownership of the tables to the postgres user
ALTER TABLE public.company_dim OWNER to postgres;
ALTER TABLE public.skills_dim OWNER to postgres;
ALTER TABLE public.job_postings_fact OWNER to postgres;
ALTER TABLE public.skills_job_dim OWNER to postgres;

-- Create indexes on foreign key columns for better performance
CREATE INDEX idx_company_id ON public.job_postings_fact (company_id);
CREATE INDEX idx_skill_id ON public.skills_job_dim (skill_id);
CREATE INDEX idx_job_id ON public.skills_job_dim (job_id);

-- =========================================================
-- PRIMARY KEY VS FOREIGN KEY SYNTAX IN POSTGRESQL
-- =========================================================
--
-- 1) PRIMARY KEY
-- ---------------------------------------------------------
-- A PRIMARY KEY is **defined inside the table** to uniquely
-- identify each row. You don’t need to reference another table.
--
-- Example:
--   CREATE TABLE company_dim (
--       company_id INT PRIMARY KEY,
--       name TEXT
--   );
--
-- Notes:
--   - The column itself becomes unique and NOT NULL automatically
--   - You can define PRIMARY KEY inline (column-level) or at table-level
--       Inline: company_id INT PRIMARY KEY
--       Table-level: PRIMARY KEY (company_id)
--
-- ---------------------------------------------------------
-- 2) FOREIGN KEY
-- ---------------------------------------------------------
-- A FOREIGN KEY is **used to reference a column in another table**.
-- It establishes a relationship between tables (referential integrity)
--
-- Example:
--   CREATE TABLE job_postings_fact (
--       job_id INT PRIMARY KEY,
--       company_id INT,
--       FOREIGN KEY (company_id) REFERENCES public.company_dim (company_id)
--   );
--
-- Key points about the syntax:
--   - FOREIGN KEY (column_name) → defines the column in THIS table
--   - REFERENCES other_table (other_column) → tells SQL
--       which table/column this foreign key points to
--   - This ensures that the value of company_id in job_postings_fact
--       must exist in company_dim.company_id
--
-- ---------------------------------------------------------
-- 3) WHY FOREIGN KEYS ARE DIFFERENT FROM PRIMARY KEYS
-- ---------------------------------------------------------
-- PRIMARY KEY:
--   - Uniquely identifies rows in **the same table**
--   - Syntax: PRIMARY KEY (column)
--
-- FOREIGN KEY:
--   - Links a column to **another table**
--   - Syntax: FOREIGN KEY (this_column) REFERENCES other_table (other_column)
--   - Can also have extra options:
--       ON DELETE CASCADE
--       ON UPDATE CASCADE
--   - Cannot be used alone without referencing another table
--
-- ---------------------------------------------------------
-- 4) EXAMPLE COMPARISON
-- ---------------------------------------------------------
-- PRIMARY KEY:
--   CREATE TABLE company_dim (
--       company_id INT PRIMARY KEY
--   );
--
-- FOREIGN KEY:
--   CREATE TABLE job_postings_fact (
--       job_id INT PRIMARY KEY,
--       company_id INT,
--       FOREIGN KEY (company_id) REFERENCES company_dim(company_id)
--   );
--
-- ---------------------------------------------------------
-- 5) MEMORY TIP
-- ---------------------------------------------------------
-- - PRIMARY KEY = unique + identifies THIS table
-- - FOREIGN KEY = references another table + enforces data integrity
-- =========================================================
