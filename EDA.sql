-- Exploratory Data Analysis

SELECT*
FROM layoff_staging2;

-- Maximum number of employees laid off in a single event

SELECT MAX(total_laid_off)
FROM layoff_staging2;

-- Companies with 100% layoffs 

SELECT *
FROM layoff_staging2
WHERE percentage_laid_off = 1
order by total_laid_off DESC;

SELECT *
FROM layoff_staging2
WHERE percentage_laid_off = 1
order by funds_raised_millions DESC;

-- Total laid off by a Company

SELECT company,SUM(total_laid_off) total_laid_off
FROM layoff_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Time frame of Data

SELECT MIN(`date`) , MAX(`date`)
FROM layoff_staging2;

-- Industries that laid off most 

SELECT industry,SUM(total_laid_off) total_laid_off
FROM layoff_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Countries that laid off most 

SELECT country,SUM(total_laid_off) total_laid_off
FROM layoff_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Total layoffs per year

SELECT YEAR(`date`),SUM(total_laid_off) total_laid_off
FROM layoff_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

-- Total layoffs by company stage
 
SELECT stage,SUM(total_laid_off) total_laid_off
FROM layoff_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT stage,ROUND(AVG(percentage_laid_off),2) percentage_laid_off
FROM layoff_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Monthly layoffs trend

SELECT 
    DATE_FORMAT(`date`, '%Y-%m') AS month,
    SUM(total_laid_off) AS total_laid
FROM layoff_staging2
WHERE `date` IS NOT NULL
GROUP BY month
ORDER BY month;

-- Rolling Total of Layoffs Per Month

WITH monthly_layoffs AS (
    SELECT 
        DATE_FORMAT(`date`, '%Y-%m') AS month,
        SUM(total_laid_off) AS total_laid
    FROM layoff_staging2
    WHERE `date` IS NOT NULL
    GROUP BY month
)

SELECT month,total_laid, SUM(total_laid) OVER (ORDER BY month) AS rolling_total
FROM monthly_layoffs;

-- Year-wise layoffs by company

SELECT company,YEAR(`date`),SUM(total_laid_off) total_laid_off
FROM layoff_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC ;

-- Top 5 companies by layoffs per year

WITH company_year(company, Years,total_laid_off) AS(
SELECT company,YEAR(`date`),SUM(total_laid_off) total_laid_off
FROM layoff_staging2
GROUP BY company, YEAR(`date`)
), Company_year_rank AS
(SELECT * , DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) RANKS
FROM company_year
WHERE years IS NOT NULL AND total_laid_off IS NOT NULL
)
SELECT * 
FROM Company_year_rank
WHERE RANKS<=5;

