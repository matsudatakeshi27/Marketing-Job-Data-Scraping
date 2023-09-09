Create table industry (
	id int primary key not null auto_increment,
    industry varchar(100), 
    industry_group varchar(100),
    industry_count int
);

Insert into industry (industry, industry_count) SELECT Industry AS industry, COUNT(*) AS industry_count
FROM job_scraping_database.marketing_jobs Where Industry <> ""
GROUP BY Industry;

Create table industry_group (
	id int primary key not null auto_increment,
    industry_group varchar(100),
    number_of_count int
);

-- Run Python Industry Classification

Insert into industry_group (industry_group) Select distinct industry_group from job_scraping_database.industry;

Update job_scraping_database.industry_group as i1 Set number_of_count = (
	Select Sum(industry_count) from industry as i2
    where i1.industry_group = i2.industry_group
	group by industry_group 
);