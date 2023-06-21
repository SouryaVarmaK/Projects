Use Project

Select location, continent, date, total_cases, new_cases, total_deaths, population 
from Deaths$
order by 1,3

Select location, continent,date, CAST(total_cases as float) as total_cases, total_deaths, (total_deaths/CAST(total_cases as float))*100 as Death_percentage, population
from Deaths$
Where continent is NOT NULL and location = 'India'
order by 1,3

Select location, continent,population, MAX(CAST(total_cases as float)) as total_cases, MAX((CAST(total_cases as float)/population))*100 as positive_percentage
from Deaths$
Where continent is NOT NULL
group by location,continent,population
order by positive_percentage DESC


Select location, population, MAX(Cast(total_deaths as Integer)) as total_deaths
From Deaths$
Where continent is NOT NULL
group by location,population
order by total_deaths DESC

select date, SUM(new_cases) as new_cases, SUM(new_deaths) as Total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 as death_percentage
from Deaths$
where continent is not null
group by date
order by date

select SUM(new_cases) as new_cases, SUM(new_deaths) as Total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 as death_percentage
from Project..Deaths$
where continent is not null


select dth.continent,dth.location,dth.date,dth.population,vac.new_vaccinations
from Project..Deaths$ dth
join Project..vaccine$ vac on dth.location=vac.location and dth.date=vac.date
where dth.continent is not null
order by 2,3

select dth.continent,dth.location,dth.date,dth.population,vac.new_vaccinations,SUM(Convert(float,vac.new_vaccinations)) OVER(Partition by dth.location order by dth.location,dth.date ) as Vaccination_Progress
from Project..Deaths$ dth
Join Project..vaccine$ vac on dth.location=vac.location and dth.date=vac.date
where dth.continent is not null
order by 2,3


With Newtable(continent,LOCATION,date,population,new_vaccinations,vaccination_progess)
as
(
select dth.continent,dth.location,dth.date,dth.population,vac.new_vaccinations,SUM(Convert(float,vac.new_vaccinations)) OVER(Partition by dth.location order by dth.location,dth.date ) as Vaccination_Progress
from Project..Deaths$ dth
Join Project..vaccine$ vac on dth.location=vac.location and dth.date=vac.date
where dth.continent is not null
)
Select *, (vaccination_progess/population)*100 as Percentage
from Newtable


--Temporary Table
Drop Table if exists PercentagePopulationVaccinated
Create Table PercentagePopulationVaccinated 
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_vaccination numeric,
vaccination_progress numeric
)
Insert into PercentagePopulationVaccinated 
select dth.continent,dth.location,dth.date,dth.population,vac.new_vaccinations,SUM(Convert(float,vac.new_vaccinations)) OVER(Partition by dth.location order by dth.location,dth.date ) as Vaccination_Progress
from Project..Deaths$ dth
Join Project..vaccine$ vac on dth.location=vac.location and dth.date=vac.date
where dth.continent is not null

Select *, (vaccination_progress/population)*100  as Vaccinated_percentage
from PercentagePopulationVaccinated


--Creating View

Create View PopulationVaccinated as
select dth.continent,dth.location,dth.date,dth.population,vac.new_vaccinations,SUM(Convert(float,vac.new_vaccinations)) OVER(Partition by dth.location order by dth.location,dth.date ) as Vaccination_Progress
from Project..Deaths$ dth
Join Project..vaccine$ vac on dth.location=vac.location and dth.date=vac.date
where dth.continent is not null

