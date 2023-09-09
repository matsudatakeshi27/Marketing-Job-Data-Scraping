SELECT * FROM job_scraping.marketing_jobs_linkedin;

UPDATE job_scraping_database.marketing_jobs SET Location = 'Remote' WHERE Location = 'United States';

Alter table job_scraping.marketing_jobs_linkedin add column State varchar(10);

Update job_scraping.marketing_jobs_linkedin as s 
set State = (
	case 
		When Location = "Remote" then "Remote"
		When LENGTH(SUBSTRING_INDEX(Location, ', ', -1)) = 2 then SUBSTRING_INDEX(Location, ', ', -1)
        Else ""
	end
);