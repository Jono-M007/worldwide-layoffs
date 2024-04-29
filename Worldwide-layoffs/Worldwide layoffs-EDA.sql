-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

-- The total number of layoffs in the dataset
SELECT SUM(total_laid_off)
FROM layoffs_staging2;

-- Get the date range of the dataset
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- The highest number of people laid off
-- The companies with the highest laid off as a percentage of their work-force
SELECT MAX(total_laid_off) , MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Companies that laid-off 100% of their work-force , sorted by the millions raised in funding
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- The total number of layoffs by each company
SELECT company , sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- The total number of layoffs for each industry
SELECT industry , sum(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- The total number of layoffs for each country
SELECT country , sum(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Total number of layoffs per year
SELECT YEAR(`date`) , sum(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Total number of layoffs per company stage
SELECT stage , sum(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`,1,7) AS `MONTH` , SUM(total_laid_off)
FROM layoffs_staging2 
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC ;

-- Rolling total layoffs , showing month by month progression
WITH Rolling_total AS
(SELECT SUBSTRING(`date`,1,7) AS `MONTH` , SUM(total_laid_off) AS Total_off
FROM layoffs_staging2 
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC 
)
SELECT `MONTH`, Total_off ,
SUM(total_off) OVER(ORDER BY `MONTH`) AS Rolling_total
FROM Rolling_total;

SELECT company, YEAR(`date`) , sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company ,YEAR(`date`) 
ORDER BY 3 DESC;

-- Ranking the top 5 layoffs per year based on company
WITH Company_year (company , years, total_laid_off)  AS
(SELECT company, YEAR(`date`) , sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company ,YEAR(`date`) 
) , Company_Year_Rank AS
(SELECT * ,
 DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_year_rank
WHERE Ranking <=5;



-- Ranking the top 5 layoffs per year based on the industry
WITH Industry_year (industry , years, total_laid_off)  AS
(SELECT industry, YEAR(`date`) , sum(total_laid_off)
FROM layoffs_staging2
GROUP BY industry ,YEAR(`date`) 
) , Industry_Year_Rank AS
(SELECT * ,
 DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_year
WHERE years IS NOT NULL
)
SELECT *
FROM Industry_year
WHERE Ranking <=5;






