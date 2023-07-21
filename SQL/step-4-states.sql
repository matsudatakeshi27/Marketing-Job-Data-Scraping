SELECT * FROM job_scraping.states;  

SET SQL_SAFE_UPDATES = 0;

Alter table job_scraping.states add column number_of_jobs int;

update job_scraping.states as s
set number_of_jobs = (
    SELECT COUNT(*)
    FROM job_scraping.marketing_jobs_linkedin AS mj
    WHERE mj.Location LIKE CONCAT('%, ',  s.code)
);

