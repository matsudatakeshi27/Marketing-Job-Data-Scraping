import time
import mysql.connector
from bs4 import BeautifulSoup
import requests

# Connect to MySQL database
mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="job_scraping"
)

cursor = mydb.cursor()

# Create the table if it doesn't exist
cursor.execute('''
    CREATE TABLE IF NOT EXISTS Marketing_Jobs (
        JobId Varchar(20) PRIMARY KEY,
        Title VARCHAR(200),
        Company VARCHAR(100),
        Location VARCHAR(100),
        Apply VARCHAR(300),
        JobDescription TEXT,
        Date VARCHAR(50),
        CompanyLink VARCHAR(300)
    )
''')

def linkedin_scraper(webpage, page_number):
    next_page = webpage + str(page_number)
    print(str(next_page))
    response = requests.get(str(next_page))
    print(response.status_code)

    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        jobs = soup.find_all('div', class_='base-card relative w-full hover:no-underline focus:no-underline base-card--link base-search-card base-search-card--link job-search-card')

        for job in jobs:
            job_id = job.get('data-entity-urn').split(':')[3]

            # Check if the JobId already exists in the table
            select_query = "SELECT JobId FROM Marketing_Jobs WHERE JobId = %s"
            cursor.execute(select_query, (job_id,))
            result = cursor.fetchone()

            if result is None:
                job_title = job.find('h3', class_='base-search-card__title').text.strip()
                job_company = job.find('h4', class_='base-search-card__subtitle').text.strip()
                job_location = job.find('span', class_='job-search-card__location').text.strip()
                job_link = job.find('a', class_='base-card__full-link')['href']
                posted_date_elem = job.find('time', class_='job-search-card__listdate')
                posted_date = posted_date_elem['datetime'] if posted_date_elem else ''
                company_link = job.find('a', class_='hidden-nested-link')['href']

                job_res = requests.get(job_link)
                job_info = ""
                if job_res.status_code == 200:
                    job_soup = BeautifulSoup(job_res.text, 'html.parser')
                    job_info = job_soup.find('div', class_='show-more-less-html__markup').text.strip()

                # Insert the data into the MySQL table
                insert_query = '''
                    INSERT INTO Marketing_Jobs (JobId, Title, Company, Location, Apply, JobDescription, Date, CompanyLink)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                '''
                insert_values = (job_id, job_title, job_company, job_location, job_link, job_info, posted_date, company_link)
                cursor.execute(insert_query, insert_values)
                mydb.commit()
            else:
                print("Skipping duplicate JobId:", job_id)

        print('Data updated')

        if page_number < 1000:
            page_number += 25
            linkedin_scraper(webpage, page_number)
        else:
            cursor.close()
            mydb.close()
    elif response.status_code == 429:
        print('Rate limit exceeded. Retrying in 5 seconds...')
        time.sleep(5)
        linkedin_scraper(webpage, page_number)
    else:
        print('Error:', response.status_code)

linkedin_scraper('https://www.linkedin.com/jobs-guest/jobs/api/seeMoreJobPostings/search?keywords=Marketing&location=United%2BStates&locationId=&geoId=103644278&f_TPR=&f_E=2&start=', 0)
