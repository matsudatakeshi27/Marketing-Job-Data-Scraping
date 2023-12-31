SELECT * FROM job_scraping_database.US_Cities;


Alter table job_scraping_database.US_Cities add column number_of_jobs int;

update job_scraping_database.US_Cities as s
set number_of_jobs = (
    SELECT COUNT(*)
    FROM job_scraping_database.marketing_jobs AS mj
    WHERE mj.Location COLLATE utf8mb4_general_ci LIKE CONCAT(s.city, ', ', s.state_id) or mj.Location COLLATE utf8mb4_general_ci like Concat(s.city, ', United States') or mj.Location COLLATE utf8mb4_general_ci like Concat("%", s.city, "%Metropolitan%")
);

Insert into job_scraping_database.US_Cities (city, state_id, state_name) value ("Remote", "Remote", "Remote");

Update job_scraping_database.US_Cities as s set number_of_jobs = (
	select Count(*) from job_scraping_database.marketing_jobs where location = "Remote"
) where s.city = "Remote";

Select * from job_scraping_database.US_Cities where city = "Remote";

-- select Sum(number_of_jobs) from job_scraping.us_cities;
-- select Count(*) from job_scraping.marketing_jobs_linkedin where location = "Remote";
-- select Count(*) from job_scraping.marketing_jobs_linkedin;

Select * from job_scraping_database.US_Cities where number_of_jobs <> 0;

Select Location, Skills from job_scraping_database.marketing_jobs where Skills <> " ";

SELECT * FROM job_scraping_database.location_skills;