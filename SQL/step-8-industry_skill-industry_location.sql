CREATE TABLE location_industry AS
SELECT mj.State, ind.industry_group, COUNT(*) AS industry_count
FROM job_scraping.marketing_jobs_linkedin AS mj
JOIN job_scraping.industry AS ind ON mj.industry = ind.industry
WHERE mj.State <> ""
GROUP BY mj.State, ind.industry_group;

SET SQL_SAFE_UPDATES = 0;

Alter table job_scraping.marketing_jobs_linkedin add column industry_group varchar(100);

Update job_scraping.marketing_jobs_linkedin as mj
set industry_group = (
	select industry_group from job_scraping.industry as ind
    where mj.industry = ind.industry
);

CREATE TABLE skill_industry AS
SELECT mj.industry_group, s.skill_group
FROM job_scraping.marketing_jobs_linkedin AS mj
JOIN job_scraping.skills AS s ON mj.Skills LIKE CONCAT("%", s.skill_name, "%")
WHERE mj.Skills <> "" and mj.industry_group <> ""
GROUP BY s.skill_group, mj.industry_group;

alter table job_scraping.skill_industry add column number_of_count int;

update job_scraping.skill_industry as si
set number_of_count = (
	Select Sum(Count(*)) from job_scraping.marketing_jobs_linkedin as mj
    join job_scraping.skills as s on mj.Skills Like Concat("%", s.skill_name, "%")
    where mj.industry_group = si.industry_group
);


CREATE TABLE skill_industry AS SELECT mj.industry_group,
    s.skill_name,
    s.skill_group,
    COUNT(*) AS skill_count FROM
    job_scraping.marketing_jobs_linkedin AS mj
        JOIN
    job_scraping.skills AS s ON mj.Skills LIKE CONCAT('%', s.skill_name, '%')
WHERE
    mj.Skills <> '' AND industry_group <> ''
GROUP BY s.skill_name , mj.industry_group;