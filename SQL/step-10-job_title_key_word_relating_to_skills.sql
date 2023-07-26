SET SQL_SAFE_UPDATES = 0;

-- Create table to clean job title
create table title (
	JobId varchar(100) primary key not null,
	Title varchar(225)
);

-- Clean job title 
Insert into job_scraping.title Select JobId as JobId, Title as Title from job_scraping.marketing_jobs_linkedin;
update job_scraping.title 
set Title = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Title, ',', ''), '-', ''), '(', ''), ')', ''), ":", ""), "/", "");

-- Create table for job title key word
CREATE TABLE job_title_analyze (
	title_elem VARCHAR(255)
);

-- Insert the split values into the temporary table
INSERT INTO job_title_analyze (title_elem)
SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Title, ' ', n), ' ', -1)) AS elem
FROM title
JOIN
(
    SELECT 1 + units.i + tens.i * 10 AS n
    FROM
    (SELECT 0 AS i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
    SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) AS units
    CROSS JOIN
    (SELECT 0 AS i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
    SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) AS tens
) AS numbers
WHERE n <= 1 + (LENGTH(Title) - LENGTH(REPLACE(Title, ' ', '')));

-- add id as primary key
Alter table job_scraping.job_title_analyze add column id int auto_increment primary key first;

-- Clean job title key word
DELETE t1
FROM job_title_analyze t1
JOIN job_title_analyze t2 ON t1.title_elem = t2.title_elem
where t1.id > t2.id;
DELETE FROM job_scraping.job_title_analyze
WHERE title_elem REGEXP '^[^a-zA-Z]' or title_elem = "";

-- Add counting title key word
Alter table job_scraping.job_title_analyze add column count_key_word int;
Update job_scraping.job_title_analyze as jta
set count_key_word = (
	Select Count(*) From job_Scraping.title as t
    Where t.Title Like Concat("%", jta.title_elem, "%")
);

-- Creat table relate skill to title key word
CREATE TABLE title_skill AS 
Select t.title_elem, t.skill_group, count(skill_count) As skill_count from
(SELECT jta.title_elem, s.skill_name, s.skill_group, COUNT(*) AS skill_count
FROM job_scraping.marketing_jobs_linkedin AS mj
JOIN job_scraping.skills AS s ON mj.skills LIKE CONCAT("%", s.skill_name, "%")
Join job_scraping.job_title_analyze as jta on mj.title Like concat("%", jta.title_elem, "%")
WHERE mj.Skills <> ""
GROUP BY jta.title_elem, s.skill_name) as t
group by t.title_elem, t.skill_group;