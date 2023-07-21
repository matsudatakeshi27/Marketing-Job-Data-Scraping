Drop Table job_scraping.skills;

-- Create a temporary table to store the split values
CREATE TABLE skills (
	skill_name VARCHAR(255)
);

-- Insert the split values into the temporary table
INSERT INTO skills (skill_name)
SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Skills, ',', n), ',', -1)) AS skill
FROM marketing_jobs_linkedin
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
WHERE n <= 1 + (LENGTH(Skills) - LENGTH(REPLACE(Skills, ',', '')));

SET SQL_SAFE_UPDATES = 0;

Delete from skills where skill_name = " ";

Alter table job_scraping.skills add column skill_id int auto_increment primary key first;

DELETE t1
FROM skills t1
JOIN skills t2 ON t1.skill_name = t2.skill_name
where t1.skill_id > t2.skill_id;

Alter table job_scraping.skills add column appearance_in_description int;

Alter table job_scraping.skills add column appearance_in_skill int;

Alter table job_scraping.skills add column skill_group varchar(100);

UPDATE job_scraping.skills AS s
SET appearance_in_description = (
    SELECT COUNT(*)
    FROM job_scraping.marketing_jobs_linkedin AS mj
    WHERE mj.JobDescription LIKE CONCAT('%', s.skill_name, '%')
);


UPDATE job_scraping.skills AS s
SET appearance_in_skill = (
    SELECT COUNT(*)
    FROM job_scraping.marketing_jobs_linkedin AS mj
    WHERE mj.Skills LIKE CONCAT('%', s.skill_name, '%')
);

Select Location, Count(*) as Count from job_scraping.marketing_jobs
group by Location order by Count desc;



