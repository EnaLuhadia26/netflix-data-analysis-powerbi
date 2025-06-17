-- create Table
CREATE TABLE netflix_titles (
    show_id TEXT,
    type TEXT,
    title TEXT,
    director TEXT,
    "cast" TEXT,
    country TEXT,
    date_added TEXT,
    release_year INT,
    rating TEXT,
    duration TEXT,
	listed_in TEXT,
    description TEXT
);


-- DATA CLEANING
SELECT * FROM netflix_titles
WHERE director IS NULL OR "cast" IS NULL OR country IS NULL;

-- Check inconsistent countries or ratings
SELECT DISTINCT country FROM netflix_titles;
SELECT DISTINCT rating FROM netflix_titles;

-- Extract year/month from date_added
SELECT 
  title,
  TO_DATE(date_added, 'Month DD, YYYY') AS added_date,
  EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year_added,
  EXTRACT(MONTH FROM TO_DATE(date_added, 'Month DD, YYYY')) AS month_number,
  TO_CHAR(TO_DATE(date_added, 'Month DD, YYYY'), 'Month') AS month_name
FROM netflix_titles
WHERE date_added IS NOT NULL;



-- Questions
--Q.1 Count of Movies vs TV Shows
SELECT "type", COUNT(*) AS total FROM netflix_titles GROUP BY "type";


--Q.2 Get all shows that have ‘Comedy’ listed in their genre 
SELECT *
FROM netflix_titles
WHERE listed_in LIKE '%Comedy%';


--Q.3 Get all movies that have a duration longer than 120 minutes.
SELECT title, duration
FROM netflix_titles
WHERE type = 'Movie'
  AND CAST(REGEXP_REPLACE(duration, '[^0-9]', '', 'g') AS INTEGER) > 120;
  
/*Explanation:
REGEXP_REPLACE(duration, '[^0-9]', '', 'g') removes all non-numeric characters from the duration string.
CAST(... AS INTEGER) converts the result to a number.*/


--Q.4 How many titles added per year by type
SELECT 
  EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year_added,
  type,
  COUNT(*) AS count
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY year_added, type
ORDER BY year_added, type;


--Q.5 Find the Distribution of titles by rating
SELECT 
  rating,
  COUNT(*) AS count
FROM netflix_titles
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY count DESC;


--Q.6 Top 5 countries producing most content
SELECT 
  country,
  COUNT(*) AS titles_count
FROM netflix_titles
WHERE country IS NOT NULL
GROUP BY country
ORDER BY titles_count DESC
LIMIT 5;


--Q.7  How many titles were added each year?
SELECT 
  EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year_added,
  COUNT(*) AS titles_added
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added;


--Q.8  Find all shows whose titles start with the letter ‘S’.
SELECT title, type
FROM netflix_titles
WHERE title ILIKE 'S%';


--Q.9 Count how many shows have the word ‘Love’ in their description
SELECT COUNT(*) AS love_count
FROM netflix_titles
WHERE description LIKE '%Love%';


--Q.10 Find all shows that are available in India
SELECT title, country, type
FROM netflix_titles
WHERE country ILIKE '%India%';






