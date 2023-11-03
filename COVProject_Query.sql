SELECT * 
FROM PortfolioProject_Covid.dbo.deathdata
Where continent is not null
ORDER BY 3,4

-- Extracting the data that will be used

SELECT Location, date, population, total_cases, new_cases, total_deaths
FROM PortfolioProject_Covid.dbo.deathdata
ORDER BY 1,2


-- Examining Total Cases vs Total Deaths to determine percentage probability of death when contracting COVID

SELECT Location, date, population, total_cases, total_deaths,
       CASE 
          WHEN total_cases = 0 THEN NULL 
          ELSE CAST(total_deaths*100 AS float)/total_cases
       END AS death_percentage
FROM PortfolioProject_Covid.dbo.deathdata
WHERE location LIKE '%states%'
ORDER BY 1, 2;

-- Looking at the total cases when compared to the population

SELECT Location, date, population, total_cases, 
       CAST(total_cases*100 AS float) / CAST(population AS float) as cases_population_ratio
FROM PortfolioProject_Covid.dbo.deathdata
WHERE location LIKE '%canada%'
ORDER BY 1, 2;

-- Determining the countries with the highest percentage of infected people according to population size

SELECT Location, population, MAX(total_cases) AS HighestInfectPeople, 
       MAX(CAST(total_cases*100 AS float) / CAST(population AS float)) as cases_population_ratio
FROM PortfolioProject_Covid.dbo.DeathData
--WHERE location LIKE '%canada%'
GROUP BY Location, population
ORDER BY cases_population_ratio DESC

-- Determining the continents with the Highest Death Counth

SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM PortfolioProject_Covid.dbo.deathdata
--WHERE location LIKE '%canada%'
Where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Determining the countries with the Highest Death Counth per Population

SELECT Location, population, MAX(total_deaths) as TotalDeathCount
FROM PortfolioProject_Covid.dbo.deathdata
--WHERE location LIKE '%canada%'
Where continent is not null
GROUP BY Location, population
ORDER BY TotalDeathCount DESC

--Showing the global numbers of new cases in comparison to deaths

SELECT date, SUM(new_cases) as Total_cases, SUM(new_deaths) as Total_deaths, 
SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject_Covid.dbo.deathdata
--WHERE location LIKE '%canada%'
WHERE continent is not null
Group by date
Having date >= '2020-01-19'
ORDER BY 1, 2;

--Looking at the Percentage of populations that are fully vaccinated

Select
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.people_fully_vaccinated,
		(vac.people_fully_vaccinated/dea.population)*100 as VaccinationPercentage
    FROM
        PortfolioProject_Covid.dbo.deathdata dea
    JOIN
        PortfolioProject_Covid.dbo.vaccinationdata vac
    ON
        dea.location = vac.location AND dea.date = vac.date
    WHERE
        dea.continent IS NOT NULL
		order by 2,3

--Creating views for later visualizations

Use PortfolioProject_Covid
Go
Create View VaccinationPerPopulation as
Select
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.people_fully_vaccinated,
		(vac.people_fully_vaccinated/dea.population)*100 as VaccinationPercentage
    FROM
        PortfolioProject_Covid.dbo.deathdata dea
    JOIN
        PortfolioProject_Covid.dbo.vaccinationdata vac
    ON
        dea.location = vac.location AND dea.date = vac.date
    WHERE
        dea.continent IS NOT NULL

		
Use PortfolioProject_Covid
Go		
Create view DeathVSCases as
		SELECT date, SUM(new_cases) as Total_cases, SUM(new_deaths) as Total_deaths, 
SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject_Covid.dbo.deathdata
--WHERE location LIKE '%canada%'
WHERE continent is not null
Group by date
Having date >= '2020-01-19'