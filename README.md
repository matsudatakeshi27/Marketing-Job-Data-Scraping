# Marketing Job Data Scraping

This repository contains a project developed during my final year of Bachelor's Degree, aimed at scraping marketing job listings from popular job platforms, including LinkedIn. The project focuses on collecting, processing, and analyzing job postings for roles in marketing to understand trends, required skills, job titles, and other relevant insights. This project has helped Beloit College's decision to open the Marketing Minor and courses at its School of Business.

## Project Overview

The Marketing Jobs Scraper is designed to:
1. **Scrape job listings** related to marketing roles from LinkedIn and other job platforms.
2. **Clean and process the collected data** for easy analysis.
3. **Analyze trends** in job requirements, keywords, company demand, and geographical distribution.

This project showcases web scraping techniques, data cleaning, and preliminary data analysis in Python.

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Data Collection](#data-collection)
- [Results and Insights](#results-and-insights)
- [Future Improvements](#future-improvements)

## Features

- **Web Scraping**: Uses BeautifulSoup and Selenium to collect job postings.
- **Data Cleaning and Processing**: Handles text data for better analysis.
- **Data Storage**: Stores data in a structured format in SQL.
- **Trend Analysis**: Basic analysis on skills demand, job location trends, and job types.

## Data Collection

The project collects the following fields (where available) from job postings:

- **Job Title**
- **Company Name**
- **Location**
- **Date Posted**
- **Job Description**
- **Skills Required**

These fields help in identifying trends and understanding the requirements for marketing jobs across different locations and companies.

## Results and Insights

The data analysis and insights is summarized in this report: 

## Future Improvements

- **Automate CAPTCHA Handling**: Improve scraper reliability on LinkedIn by implementing CAPTCHA-solving solutions.
- **Database Storage**: Store them in a sharable database for better scalability.
- **Advanced Analysis**: Implement NLP techniques to analyze job descriptions in greater depth.
- **Extended Platform Coverage**: Expand the scraper to gather job listings from additional platforms.
- **Real-Time Data Collection**: Schedule scrapes at regular intervals to capture dynamic trends and changes in the job market.
