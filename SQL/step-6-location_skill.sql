CREATE TABLE location_skills AS
SELECT mj.State, s.skill_name, COUNT(*) AS skill_count
FROM job_scraping.marketing_jobs_linkedin AS mj
JOIN job_scraping.skills AS s ON mj.skills LIKE CONCAT("%", s.skill_name, "%")
WHERE mj.State <> ""
GROUP BY mj.State, s.skill_name;

SELECT * FROM job_scraping.location_skills;

Alter table job_scraping.location_skills add column skill_group varchar(100);

Update job_scraping.location_skills as ls
Set skill_group = (
	Select skill_group 
    From job_scraping.skills as s
    where ls.skill_name = s.skill_name
);

Select State, skill_group, sum(skill_count) from job_scraping.location_skills as ls
group by skill_group, State