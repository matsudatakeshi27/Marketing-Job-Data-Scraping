Create table skill_group (
	id int primary key auto_increment not null,
    skill_group varchar(100) not null,
    appearance_in_description int,
    appearance_in_skills int
);

Insert into job_scraping_database.skill_group (id, skill_group) values (1, "Sales"), (2, "Communication"), (3, "Brand"), (4, "Quantitative/Analytics"), (5, "Content/Writing"), (6, "Social Media/Digital"),
(7, "Technology"), (8, "Market Research"), (9, "Graphic Design/Visual"), (10, "Strategy/Planning/Management"), (11, "Other");


UPDATE job_scraping_database.skill_group AS sg
JOIN (
    SELECT skill_group, SUM(appearance_in_description) AS total_appearance_in_description
    FROM skills
    GROUP BY skill_group
) AS temp ON sg.skill_group = temp.skill_group
SET sg.appearance_in_description = temp.total_appearance_in_description;

UPDATE job_scraping_database.skill_group AS sg
JOIN (
    SELECT skill_group, SUM(appearance_in_skill) AS total_appearance_in_skill
    FROM skills
    GROUP BY skill_group
) AS temp ON sg.skill_group = temp.skill_group
SET sg.appearance_in_skills = temp.total_appearance_in_skill;

