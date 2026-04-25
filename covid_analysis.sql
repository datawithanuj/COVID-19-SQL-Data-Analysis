-- =====================================================
-- COVID-19 DATA ANALYSIS PROJECT (SQL)
-- =====================================================

-- Using Database
USE covid_project;

-- =====================================================
-- 1. BASIC DATA VIEW
-- Shows total cases and deaths country-wise over time
-- =====================================================
SELECT
location,
date,
total_cases,
total_deaths
FROM covid_death_clean
WHERE continent IS NOT NULL
ORDER BY location, date;

-- =====================================================
-- 2. DEATH PERCENTAGE
-- Percentage of deaths out of total cases
-- =====================================================
SELECT
location,
date,
total_cases,
total_deaths,
ROUND((total_deaths / total_cases) * 100, 2) AS death_percentage
FROM covid_death_clean
WHERE continent IS NOT NULL
ORDER BY location, date;

-- =====================================================
-- 3. HIGHEST DEATH COUNT BY COUNTRY
-- Shows countries with highest total deaths
-- =====================================================
SELECT
location,
MAX(total_deaths) AS total_deaths
FROM covid_death_clean
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_deaths DESC;

-- =====================================================
-- 4. CONTINENT-WISE DEATH COUNT
-- Total deaths aggregated by continent
-- =====================================================
SELECT
continent,
MAX(total_deaths) AS total_deaths
FROM covid_death_clean
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_deaths DESC;

-- =====================================================
-- 5. GLOBAL NUMBERS
-- Total cases and deaths globally
-- =====================================================
SELECT
SUM(new_cases) AS total_cases,
SUM(total_deaths) AS total_deaths
FROM covid_death_clean
WHERE continent IS NOT NULL;

-- =====================================================
-- 6. JOIN: DEATH + VACCINATION DATA
-- Combining both datasets on location and date
-- =====================================================
SELECT
covid_death_clean.location,
covid_death_clean.date,
covid_death_clean.population,
covid_vaccination_clean.new_vaccinations
FROM covid_death_clean
JOIN covid_vaccination_clean
ON covid_death_clean.location = covid_vaccination_clean.location
AND covid_death_clean.date = covid_vaccination_clean.date;

-- =====================================================
-- 7. ROLLING VACCINATION (WINDOW FUNCTION)
-- Running total of vaccinations per country
-- =====================================================
SELECT
covid_death_clean.location,
covid_death_clean.date,
covid_death_clean.population,
covid_vaccination_clean.new_vaccinations,
SUM(covid_vaccination_clean.new_vaccinations) OVER (
PARTITION BY covid_death_clean.location
ORDER BY covid_death_clean.date
) AS rolling_vaccinated
FROM covid_death_clean
JOIN covid_vaccination_clean
ON covid_death_clean.location = covid_vaccination_clean.location
AND covid_death_clean.date = covid_vaccination_clean.date;

-- =====================================================
-- END OF PROJECT
-- =====================================================
