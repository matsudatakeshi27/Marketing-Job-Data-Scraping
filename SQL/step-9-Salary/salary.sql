SET SQL_SAFE_UPDATES = 0;

-- Clean Salary in table marketing_jobs_linkedin
Update job_scraping.marketing_jobs_linkedin set Salary = Replace(Salary, " (from job description)", "");

-- Create table salary 
Create table salary (
	id int primary key auto_increment not null,
    salary_type varchar(100),
    salary_min decimal(10, 2),
    salary_max decimal(10, 2)
);



