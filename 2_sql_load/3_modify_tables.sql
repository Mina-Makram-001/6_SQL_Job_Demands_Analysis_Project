COPY company_dim
FROM 'M:\2_projects\6_SQL_Job_Demands_Analysis_Project\csv_files\company_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_dim
FROM 'M:\2_projects\6_SQL_Job_Demands_Analysis_Project\csv_files\skills_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY job_postings_fact
FROM 'M:\2_projects\6_SQL_Job_Demands_Analysis_Project\csv_files\job_postings_fact.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_job_dim
FROM 'M:\2_projects\6_SQL_Job_Demands_Analysis_Project\csv_files\skills_job_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

SELECT *
FROM company_dim
LIMIT 10

-- =========================================================
-- COPY ... WITH (...) OPTIONS EXPLANATION
-- =========================================================
-- The WITH (...) clause tells PostgreSQL HOW to read and
-- interpret the input file during bulk data loading.
--
-- General syntax:
-- COPY table_name
-- FROM 'file_path'
-- WITH (option1, option2, option3, ...);
--
-- Everything inside WITH (...) controls file parsing.
-- =========================================================


-- ---------------------------------------------------------
-- FORMAT csv
-- ---------------------------------------------------------
-- Tells PostgreSQL that the input file is in CSV format
-- (Comma-Separated Values).
--
-- PostgreSQL supports multiple formats:
--   - text   (default)
--   - csv
--   - binary
--
-- Without FORMAT csv, PostgreSQL assumes plain text,
-- which leads to incorrect parsing for CSV files.
--
-- CSV format properly handles:
--   - quoted strings (e.g. "Data Analyst")
--   - commas inside text
--   - line breaks inside quoted fields
-- ---------------------------------------------------------


-- ---------------------------------------------------------
-- HEADER true
-- ---------------------------------------------------------
-- Indicates that the FIRST ROW of the CSV file contains
-- column names, not actual data.
--
-- Example CSV header:
-- company_id,name,link,link_google,thumbnail
--
-- If HEADER true is not specified:
--   - PostgreSQL will try to insert column names as data
--   - This causes type conversion errors (e.g. text into INT)
--
-- If the CSV file does NOT contain a header row:
--   - Use HEADER false (default behavior)
-- ---------------------------------------------------------


-- ---------------------------------------------------------
-- DELIMITER ','
-- ---------------------------------------------------------
-- Specifies the character used to separate columns in the file.
--
-- Common delimiters:
--   - ','  (standard CSV)
--   - ';'  (common in some regions)
--   - '|'  (pipe-delimited files)
--   - '\t' (tab-separated / TSV files)
--
-- If the delimiter does not match the file:
--   - Columns shift incorrectly
--   - Data loads into the wrong fields

-- HOW TO KNOW IF DATA IS SEPARATED CORRECTLY (DELIMITER)
-- ---------------------------------------------------------
--
-- 1) OPEN THE FILE IN A TEXT EDITOR (Not Excel)
-- ---------------------------------------------------------
-- Open the CSV file using:
--   - Notepad / Notepad++
--   - VS Code
--   - Any plain text editor
--
-- Look at ONE line of data and identify the character
-- that separates values.
--
-- Examples:
--   1,Google,https://google.com
--   → delimiter is ','
--
--   1;Google;https://google.com
--   → delimiter is ';'
--
--   1|Google|https://google.com
--   → delimiter is '|'
--
--   1\tGoogle\thttps://google.com
--   → delimiter is TAB
-- ---------------------------------------------------------
--
--
-- 2) COUNT DELIMITERS PER ROW
-- ---------------------------------------------------------
-- Each row should have the SAME number of delimiters.
--
-- Example (3 columns → 2 commas per row):
--   id,name,country
--   1,Google,USA
--   2,Amazon,Germany
--
-- If the number of delimiters is inconsistent:
--   - Data will shift into wrong columns
--   - COPY will fail or corrupt data
-- ---------------------------------------------------------

-- ---------------------------------------------------------
-- ENCODING 'UTF8'
-- ---------------------------------------------------------
-- Specifies the character encoding of the input file.
--
-- UTF-8 supports:
--   - Arabic characters
--   - Accented letters (é, ü)
--   - Special symbols (©, ™)
--
-- If encoding is incorrect or unspecified:
--   - Text may appear corrupted
--   - Load may fail
--   - Characters may become ????
--
-- UTF-8 is the recommended and safest modern encoding.
-- ---------------------------------------------------------

-- ---------------------------------------------------------
-- WHEN TO USE ENCODING 'UTF8'
-- ---------------------------------------------------------
--
-- Use ENCODING 'UTF8' when the input file contains:
--   - Non-English characters (Arabic, Chinese, Cyrillic, etc.)
--   - Accented letters (é, ü, ñ, å)
--   - Special symbols (€, ©, ™)
--   - Mixed-language text
--
-- UTF-8 safely represents almost all characters used
-- in modern datasets.
-- ---------------------------------------------------------
--
--
-- ---------------------------------------------------------
-- USE ENCODING 'UTF8' IF:
-- ---------------------------------------------------------
-- 1) The CSV was created or edited using:
--    - Excel (modern versions)
--    - Google Sheets
--    - Python / Pandas
--    - Most modern applications
--
-- These tools usually export files in UTF-8.
-- ---------------------------------------------------------
--
-- 2) The database encoding is UTF-8
--    (most PostgreSQL databases are UTF-8 by default)
--
-- You can check database encoding using:
--   SHOW server_encoding;
-- ---------------------------------------------------------
--
--
-- ---------------------------------------------------------
-- USE ENCODING 'UTF8' TO AVOID THESE PROBLEMS:
-- ---------------------------------------------------------
--   - Arabic text turning into ?????
--   - Accented characters becoming corrupted
--   - COPY failing with encoding conversion errors
-- ---------------------------------------------------------
--
--
-- ---------------------------------------------------------
-- WHEN ENCODING 'UTF8' IS OPTIONAL:
-- ---------------------------------------------------------
-- If ALL of the following are true:
--   - Data is English-only (ASCII)
--   - No special characters
--   - Database encoding is UTF-8
--
-- Then PostgreSQL can usually auto-detect correctly,
-- and ENCODING 'UTF8' may be omitted safely.
-- ---------------------------------------------------------
--
--
-- ---------------------------------------------------------
-- WHEN YOU MUST SPECIFY ENCODING EXPLICITLY:
-- ---------------------------------------------------------
--   - When loading data from external systems
--   - When importing old files
--   - When loading data shared by others
--   - When COPY fails with encoding errors
--
-- Explicit encoding removes ambiguity.
-- ---------------------------------------------------------
--
--
-- ---------------------------------------------------------
-- BEST PRACTICE:
-- ---------------------------------------------------------
-- Always specify ENCODING 'UTF8' in production,
-- shared, or important data-loading scripts.
--
-- It ensures consistent behavior across machines
-- and operating systems.
-- ---------------------------------------------------------
--
--
-- MEMORY TIP:
-- ---------------------------------------------------------
-- If the file might contain non-English text,
-- always use ENCODING 'UTF8'.
-- ---------------------------------------------------------

-- ---------------------------------------------------------
-- What happens if WITH (...) is omitted?
-- ---------------------------------------------------------
-- PostgreSQL defaults to:
--   FORMAT text
--   DELIMITER = tab
--   HEADER = false
--   ENCODING = database default
--
-- These defaults almost NEVER match real CSV files,
-- which is why WITH (...) is strongly recommended.
-- ---------------------------------------------------------


-- ---------------------------------------------------------
-- Why COPY is used instead of INSERT
-- ---------------------------------------------------------
-- COPY is optimized for bulk data loading and is:
--   - Much faster than INSERT
--   - Designed for large datasets
--   - Commonly used in data engineering and analytics
--
-- INSERT is better suited for small, transactional operations,
-- not for loading entire CSV files.
-- ---------------------------------------------------------


-- ---------------------------------------------------------
-- Memory Tip:
-- ---------------------------------------------------------
-- WITH (...) tells PostgreSQL HOW to understand the file
-- ---------------------------------------------------------


