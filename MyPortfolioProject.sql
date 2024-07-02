
select *
from MyPortfolioProject..[Covid Deaths]

select location, date, total_cases, new_cases, total_deaths, population
from MyPortfolioProject..[Covid Deaths]
order by 1,2

--Tính tỷ lệ tử vong
select
	location,
	date,
	total_cases,
	total_deaths,
	(cast(total_deaths as float)/cast(total_cases as float))*100 as death_percentage
from MyPortfolioProject..[Covid Deaths]
order by 1,2

--Tỷ lệ tử vong của nước Mỹ
select
	location,
	date,
	total_cases,
	total_deaths,
	(cast(total_deaths as float)/cast(total_cases as float))*100 as death_percentage
from MyPortfolioProject..[Covid Deaths]
where location like '%States'
order by 1,2

-- Tỷ lệ tử vòng tính theo dân số nước Mỹ
select
	location,
	date,
	total_cases,
	total_deaths,
	(cast(total_deaths as float)/cast(population as float))*100 as death_percentage
from MyPortfolioProject..[Covid Deaths]
where location like '%States'
order by 1,2

--Tìm lục địa có tỷ lệ tử vong cao nhất
select 
	continent,
	Max(cast([total_deaths] AS int)) AS total_death_count
from MyPortfolioProject..[Covid Deaths]
group by continent
order by total_death_count DESC

-- Tra cứu những ca mắc và những ca tử vong theo ngày
select 
	date,
	SUM([new_deaths])AS Total_new_deaths,
	SUM(cast([new_cases] AS int)) AS Total_new_cases
from MyPortfolioProject..[Covid Deaths]
group by date
order by 1,2

-- Join 2 bẳng dữ liệu dựa trên location và date

select cd.continent,
	cd.location,
	cd.date,
	cd.population,
	cv.new_vaccinations
from MyPortfolioProject..[Covid Deaths] cd
join MyPortfolioProject..[Covid Vaccinations] cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent IS NOT NULL
order by 2,3
















