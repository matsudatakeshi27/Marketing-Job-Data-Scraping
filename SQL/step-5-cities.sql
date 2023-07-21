SELECT * FROM job_scraping.us_cities;


Alter table job_scraping.us_cities add column number_of_jobs int;

update job_scraping.us_cities as s
set number_of_jobs = (
    SELECT COUNT(*)
    FROM job_scraping.marketing_jobs_linkedin AS mj
    WHERE mj.Location LIKE CONCAT(s.city, ', ', s.state_id) or mj.Location like Concat(s.city, ', United States') or mj.Location like Concat("%", s.city, "%Metropolitan%")
);

Insert into job_scraping.us_cities (city, state_id, state_name) value ("Remote", "Remote", "Remote");

Update job_scraping.us_cities as s set number_of_jobs = (
	select Count(*) from job_scraping.marketing_jobs_linkedin where location = "Remote"
) where s.city = "Remote";

Select * from job_scraping.us_cities where city = "Remote";

select Sum(number_of_jobs) from job_scraping.us_cities;
select Count(*) from job_scraping.marketing_jobs_linkedin where location = "Remote";
select Count(*) from job_scraping.marketing_jobs_linkedin;

Select * from job_scraping.us_cities where number_of_jobs <> 0;

Select Location, Skills from job_scraping.marketing_jobs_linkedin where Skills <> " ";

SELECT * FROM job_scraping.location_skills;