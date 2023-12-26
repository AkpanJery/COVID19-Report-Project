select *
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

---Total Cases vs Total Deaths

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%Nigeria%'
order by 1,2

---Total cases vs Population

select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulation
From PortfolioProject..CovidDeaths
---where location like '%Nigeria%'
order by 1,2

--Countries with Heighest Infection Rate

select Location, population, Max(total_cases) as HeighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
---where location like '%Nigeria%'
Group by Location, population
order by PercentPopulationInfected desc


---Countries with heihhest death count per population


select Location, Max(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
---where location like '%Nigeria%'
where continent is null
Group by Location
order by TotalDeathCount desc


select Location, Max(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
---where location like '%Nigeria%'
where continent is not null
Group by Location
order by TotalDeathCount desc


--Let break things down by continent


select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
---where location like '%Nigeria%'
where continent is not null
Group by continent
order by TotalDeathCount desc

---contintents with heighest Death Count

select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
---where location like '%Nigeria%'
where continent is not null
Group by continent
order by TotalDeathCount desc


---Global Numbers


select date, population, total_cases, (total_cases/population)*100 as PercentPopulation
From PortfolioProject..CovidDeaths
---where location like '%Nigeria%'
order by 1,2

--Total Population vs Vaccination

SELECT Dea.continent, Dea.location, Dea.date, Dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated

From PortfolioProject..CovidDeaths Dea
join PortfolioProject..CovidVaccinations Vac
   on Dea.Location = Vac.location
   and Dea.date = vac.date
where Dea.continent is not null
order by 2,3
     

--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinatied)
as
(
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths Dea
join PortfolioProject..CovidVaccinations Vac
   on Dea.Location = Vac.location
   and Dea.date = vac.date
where Dea.continent is not null
--order by 2,3
)
--Select * , (RollingPeopleVaccinated/Population)*100
--From PopvsVac

---TEMPORARY TABLE


Drop Table if exists #percentpopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO  #percentpopulationVaccinated
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths Dea
join PortfolioProject..CovidVaccinations Vac
   on Dea.Location = Vac.location
   and Dea.date = vac.date
--where Dea.continent is not null
--order by 2,3

Select * , (RollingPeopleVaccinated/Population)*100
From #percentpopulationVaccinated


--CreatinG view to store data for later visualizations

Create View PercentpopulationVaccinated as
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths Dea
join PortfolioProject..CovidVaccinations Vac
   on Dea.Location = Vac.location
   and Dea.date = vac.date
where Dea.continent is not null


SELECT*
From PercentpopulationVaccinated