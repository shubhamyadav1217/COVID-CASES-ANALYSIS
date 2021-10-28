CREATE DATABASE PROJECTPORTFOLIO

/* CREATING TABLE OF COVID DEATHS WHICH IS IMPORTED FROM CSV FILE */

CREATE TABLE COVID_DEATHSS
(   iso_code varchar(255),
	continent varchar(255),
    location  varchar(255),
    dates  varchar(255),
    population	int,
    total_cases int,
	new_cases int,
    new_cases_smoothed	int,
    total_deaths	int,
    new_deaths	int,
    new_deaths_smoothed	int,
    total_cases_per_million	float,
    new_cases_per_million	float,
    new_cases_smoothed_per_million	float,
    total_deaths_per_million	float,
    new_deaths_per_million	float,
    new_deaths_smoothed_per_million	float,
    reproduction_rate	int,
    icu_patients	int,
    icu_patients_per_million float,	
    hosp_patients	int,
    hosp_patients_per_million float,
    weekly_icu_admissions int,
    weekly_icu_admissions_per_million	float,
    weekly_hosp_admissions	int,
    weekly_hosp_admissions_per_million float )
    select new_deaths_per_million from covid_deaths
    
    /* CONVERTING DATE INTO DATE DATATYPE SINCE WHEN WE IMPORT DATA FROM EXCEL THE DATES ARE NOT IN RIGHT FORMAT AS PER SQL*/
    ALTER TABLE COVID_DEATHSs
    ADD COLUMN DATE DATE AFTER DATES;
    
    UPDATE covid_deathss
    SET DATE=str_to_date(LEFT(DATES,10),"%d-%m-%Y")
    

/* CREATING TABLE OF COVID VACCINATION WHICH IS IMPORTED FROM CSV FILE*/
CREATE TABLE COVID_VACCINATION
(   iso_code varchar(255),
    continent varchar(255),
    location varchar(255),
    dates varchar(255),
    new_tests int,
	total_tests int,
	total_tests_per_thousand float,
	new_tests_per_thousand	float,
    new_tests_smoothed int,
	new_tests_smoothed_per_thousand float,
	positive_rate float,
    tests_per_case	float,
    tests_units	varchar(255),
    total_vaccinations varchar(255),
    people_vaccinated varchar(255),	
    people_fully_vaccinated varchar(255),
	total_boosters varchar(255),
	new_vaccinations varchar(255),	
    new_vaccinations_smoothed float,
    total_vaccinations_per_hundred float,
	people_vaccinated_per_hundred	float,
    people_fully_vaccinated_per_hundred float,
	total_boosters_per_hundred	float,
    new_vaccinations_smoothed_per_million float,
	stringency_index float,
    population_density	float,
    median_age	float,
    aged_65_older float,
	aged_70_older float,
	gdp_per_capita float,	
    extreme_poverty	float,
    cardiovasc_death_rate float,
	diabetes_prevalence float,
	female_smokers	float,
    male_smokers	float,
    handwashing_facilities float,
	hospital_beds_per_thousand	float,
    life_expectancy	float,
    human_development_index	float,
    excess_mortality_cumulative_absolute float,
	excess_mortality_cumulative float,
	excess_mortality	float,
    excess_mortality_cumulative_per_million float)
    
	/* CONVERTING DATE WHICH WAS TEXT INTO DATE TYPE*/
    ALTER TABLE COVID_VACCINATION
    ADD COLUMN DATE DATE AFTER DATES;
    
    UPDATE covid_vaccination
    SET DATE=str_to_date(LEFT(DATES,10),"%d-%m-%Y")
    
     
              
                              /*[ USING SELECT STATEMENTS ALONG WITH AGGREGATE,IN,WHERE,ORDER BY,GROUP BY FUNCTIONS ] */
              
    
/* GLOBAL NUMBERS AS TOTAL [TOTAL INFECTED,TOTAL DIED,DEATH PERCENTAGE] WITH USE OF AGGREGATE FUNCTIONS */
 SELECT SUM(NEW_CASES) AS TOTAL_PEOPLE_AFFECTED,SUM(NEW_DEATHS) AS TOTAL_DEATHS,(SUM(NEW_DEATHS)/SUM(NEW_CASES))*100  AS TOTAL_DEATH_PERCENTAGE
FROM COVID_DEATHSS


/*  TOP 10 COUNTRIES IN TERMS OF HIGHEST NUMBER OF COVID CASES (WITH THE USE OF LIMIT) */

SELECT LOCATION AS COUNTRIES,MAX(TOTAL_CASES) AS TOTAL_CASES_TILL_23_10_2021
FROM COVID_DEATHSS
WHERE CONTINENT IS NOT NULL
GROUP BY LOCATION
ORDER BY MAX(TOTAL_CASES) DESC
LIMIT 10

/*1 CONTINENT WISE HIGHEST NUMBER OF CASES
 2 CONTINENT WISE HIGHEST NUMBER OF DEATHS */

/*1*/ 
select LOCATION ,max(TOTAL_CASES) AS HIGHEST_NO_OF_DEATHS from covid_Deathss
where continent is null and  location not in ("world")
group by location
order by max(total_cases) desc

/*2*/
 select LOCATION ,max(total_deaths) AS HIGHEST_NO_OF_DEATHS from covid_Deathss
where continent is null AND LOCATION NOT IN("WORLD")
group by location
order by max(total_deaths) desc



/*  TOP 10 COUNTRIES WITH HIGHEST INFECTION RATE COMPARED WITH POPULATION*/
SELECT LOCATION,MAX((TOTAL_CASES/POPULATION)*100) AS PERCENTPOPLULATION_INFECTED FROM COVID_DEATHSS
GROUP BY LOCATION,POPULATION
ORDER BY MAX((TOTAL_CASES/POPULATION)*100) DESC
LIMIT 10


/* LOOKING AT THE TOTAL CASES VS TOTAL DEATHS(DEATH PERCENTAGE OF EACH COUNTRY DAYWISE {HERE FOR EG INDIA} */
SELECT ISO_CODE,CONTINENT,LOCATION,DATES,TOTAL_DEATHS,TOTAL_CASES,(TOTAL_DEATHS/TOTAL_CASES)*100 AS DEATH_PERCENTAGE FROM COVID_DEATHSS
WHERE LOCATION IN ("india") AND CONTINENT IS NOT NULL
ORDER BY DATES ASC


/* WHAT PERCENTAGE OF POPULATION IN TOTAL GOT COVID EVERY DAY? (for eg INDIA) */
SELECT ISO_CODE,CONTINENT,LOCATION,DATES,POPULATION,TOTAL_CASES,(TOTAL_CASES/POPULATION)*100 AS  PERCENTAGE_OF_POPULATION_INFECTED_BY_COVID  FROM COVID_DEATHSS
WHERE LOCATION IN ("india") AND CONTINENT IS NOT NULL ORDER BY PERCENTAGE_OF_POPULATION_INFECTED_BY_COVID ASC



                                                           /* REGAL EXPRESSION */
                                                           
                                                           
                                                           
 /* FIND THE COUNTRIES WHO HAS THE HIGHEST COVID CASES AND ITS FIRST NAME STARTS WITH a ?  */       
 SELECT LOCATION AS COUNTRIES,SUM(NEW_CASES) AS TOTAL_CASES,POPULATION FROM COVID_DEATHSS 
 WHERE LOCATION REGEXP "^[a]" AND CONTINENT IS NOT NULL
 GROUP BY LOCATION
 ORDER BY TOTAL_CASES DESC
 
/* FIND THE COUNTRIES WHO HAS THE LEAST NUMBER OF VACCINATION TILL DATE AND WHOSE LAST NAME ENDS WITH R ?  */ 
 SELECT LOCATION AS COUNTRIES,SUM(NEW_VACCINATIONS) AS TOTAL_VACCINATIONS
 FROM COVID_VACCINATION
 WHERE LOCATION REGEXP "[R]$" AND CONTINENT IS NOT NULL
 GROUP BY LOCATION
 ORDER BY SUM(NEW_VACCINATIONS) ASC          
                  
                  
                  
                  
                  
                                                         /* USING JOINS */

/* NO OF PEOPLE GETTING VACCINATED EVERY DAY LOCATION WISE , USING JOINS SINCE OUR VACCINATION DETAILS ARE IN ANOTHER TABLE (for eg india)*/
SELECT DEA.DATES,DEA.CONTINENT,DEA.LOCATION,DEA.POPULATION,VACC.NEW_VACCINATIONS AS PEOPLE_VACINNATED_PER_DAY
FROM COVID_DEATHSS DEA
JOIN
COVID_VACCINATION VACC
ON DEA.LOCATION=VACC.LOCATION AND DEA.DATES=VACC.DATES
WHERE DEA.CONTINENT IS NOT NULL and dea.location="india"
ORDER BY DEA.DATES asc

/*TOP 10 DATES ON WHICH INDIA DID MAXIMUM NUMBER OF COVID TESTS [SINCE OUR TEST DETAILS ARE IN ANOTHER TABLE WE WILL USE INNER JOIN]*/
SELECT DEA.DATES,DEA.LOCATION,VACC.NEW_TESTS AS HIGHEST_NUMBER_OF_TESTS
FROM COVID_DEATHSS DEA
INNER JOIN
COVID_VACCINATION VACC
ON DEA.DATES=VACC.DATES
WHERE DEA.CONTINENT IS NOT NULL and dea.location="india"
ORDER BY VACC.NEW_TESTS DESC



                                                 /* WINDOWS FUNCTION AND COMMON TABLE EXPRESSIONS [CTE]*/
                                                 
                                                 
/* USING WINDOWS FUNCTIONS TO SUM THE TOTAL NO OF PEOPLE(CUMMULATIVE) VACCINATED ON A PARTICULAR DATE*/
SELECT DEA.DATES,DEA.CONTINENT,DEA.LOCATION,DEA.POPULATION,VACC.NEW_VACCINATIONS AS PEOPLE_VACINNATED_PER_DAY,SUM(VACC.NEW_VACCINATIONS) 
 OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.DATES ASC) AS TOTAL_PEOPLE_VACCINATED_TILL_DATE
FROM COVID_DEATHSS DEA
JOIN
COVID_VACCINATION VACC
ON DEA.LOCATION=VACC.LOCATION
AND DEA.DATES=VACC.DATES
WHERE DEA.CONTINENT IS NOT NULL

/* USING WINDOWS FUNCTIONS AND CTE - FIND THE RANKS OF THE COUNTRY WITH MAXIMUM NO OF PEOPLE VACCINATED (HIGHEST TO LOWEST) */
SELECT LOCATION,TOTAL_PEOPLE_VACCINATED_TILL_23_1_2021 ,RANK() OVER (ORDER BY TOTAL_PEOPLE_VACCINATED_TILL_23_1_2021 DESC) AS RANKS FROM ( 
select location,sum(new_vaccinations) AS TOTAL_PEOPLE_VACCINATED_TILL_23_1_2021 from covid_vaccination
where continent is not null
group by location
order by sum(new_vaccinations)desc) AS TEMPTABLE
  
  
                                            /*USE OF LAG AND LEAD ALONG WITH CONCAT AND IF FUNCTION*/
                                            
                                            
 /* USING LAG AND LEAD (WINDOWS FUNCTIONS) TO FIND OUT THE PREVIOUS DAY VACCINATION STATUS AND CURRENT DAY VACCINATION STATUS FOR ANALAYSIS */
 SELECT LOCATION,PREVIOUS_DAY_VACCINATION,CURRENT_DAY_VACCINATION_DONE,CONCAT(ABS(DIFFERENCE)," ",IF(DIFFERENCE<'0',"LESS VACCINES ADMINISTERED THAN YESTERDAY","MORE VACCINES ADMINISTERED THAN YESTERDAY")) AS STATUS_IN_WORDS
 FROM (
 SELECT LOCATION,LAG(NEW_VACCINATIONS) OVER (PARTITION BY LOCATION ORDER BY DATES ASC) AS PREVIOUS_DAY_VACCINATION ,NEW_VACCINATIONS AS CURRENT_DAY_VACCINATION_DONE,
 LEAD(NEW_VACCINATIONS) OVER ( PARTITION BY LOCATION ORDER BY DATES ASC ) AS NEXT_DAY_VACCINATION ,NEW_VACCINATIONS -LAG(NEW_VACCINATIONS) OVER 
 (PARTITION BY LOCATION ORDER BY DATES ASC) AS DIFFERENCE FROM COVID_VACCINATION WHERE CONTINENT IS NOT NULL) AS TEMPTABLE

                                                
                                                   /* USER DEFINED VARIABLES */
					
/*FIND THE DATES ON WHICH TOP 5 PERCENT OF VACCINES WERE ADMINISTERED */
set @rank:=0
set @totalrows:=  ceil(DATEDIFF('2021-10-23','2021-01-26')*'0.05')
select* from 
(select dates,location,new_vaccinations,@rank:=@rank+1 as rnk from covid_vaccination
where location="india" and continent is not null and new_vaccinations is not null
order by new_vaccinations desc) as temptable
where rnk<=@totalrows


                                                         /* CREATING VIEWS*/

CREATE VIEW GLOBALLY_TOTAL_NUMBERS AS

SELECT SUM(NEW_CASES) AS TOTAL_COVID_CASES,SUM(NEW_DEATHS) AS TOTAL_DEATHS,(SUM(NEW_DEATHS)/SUM(NEW_CASES))*100  AS TOTAL_DEATH_PERCENTAGE
FROM COVID_DEATHSS

						      /*CORRRELATED SUBQUERY*/
                                                    
/* FIND THE CONTINENT WHO HAS THE MAXIMUM NUMBER OF POPULATION USING CORRELATED SUBQUERY*/

SELECT C1.LOCATION AS CONTINENT FROM COVID_DEATHSS C1
WHERE CONTINENT IS  NULL AND NOT EXISTS (SELECT * FROM COVID_DEATHSS C2 WHERE (C2.POPULATION)>(C1.POPULATION)) 
LIMIT 1
