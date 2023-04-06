
select *
from PortfolioProject..CovidDeaths
order by 3,4


--Shows likelihood of dying if you contract covid in your country
select location,date, total_cases,new_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location ='Canada'
order by 1,2


--Looking at countries with highest infection Count
select location,MAX(total_cases) as HighestInfectionCount
from PortfolioProject..CovidDeaths
--where location ='Canada'
group by location
order by 1,2

--Showing countries with Highest Death Count.
select location,MAX(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

--Breaking it down By Continent
select continent,MAX(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

--Global Numbers
Select date ,sum(new_cases) as total_cases,sum (cast(new_deaths as int)),sum(cast(new_deaths as int))
/NUllif(sum(cast(new_cases as float))*100,0) as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2


--Looking at vaccinations[JOIN]
select dea.continent,dea.location,dea.date,vac.new_vaccinations,sum(convert(float,vac.new_vaccinations))
over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccination vac
on dea.location=vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2


--USE CTE*
with POPVSVAC (continent,location, date,new_vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent,dea.location,dea.date,vac.new_vaccinations,sum(convert(float,vac.new_vaccinations))
over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccination vac
on dea.location=vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *
from POPVSVAC



--#TEMPTABLE
Drop table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentVaccinated
select dea.continent,
dea.location,
dea.date,
vac.new_vaccinations
,sum(convert(float,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccination vac
on dea.location=vac.location
and dea.date = vac.date
where dea.continent is not null
 

 select *
from #PercentVaccinated

--Creating view to store data for visualization
create view PercentVaccinated as(
select dea.continent,
dea.location,
dea.date,
vac.new_vaccinations
,sum(convert(float,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccination vac
on dea.location=vac.location
and dea.date = vac.date
where dea.continent is not null
 )