create database project;
use project;
select * from hr;
ALTER TABLE hr

CHANGE COLUMN ï»¿id emp_id VARCHAR(20);

DESCRIBE hr;

select birthdate from hr;
set sql_safe_updates=0;
set sql_mode='';

update hr
set birthdate=case
when birthdate like '%/%' then date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
when birthdate like '%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
else null
end;
ALTER TABLE HR
MODIFY COLUMN birthdate DATE;

update hr
set hire_date=case
when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
when hire_date like '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
else null
end;
select hire_date from hr;
alter table hr
modify column hire_date date;

update hr
set termdate=if(termdate is not null and termdate!='',date(str_to_date(termdate,'%Y-%m-%d %H:%i:%sUTC')),'0000-00-00')
WHERE true;
select termdate from hr;
set sql_mode='ALLOW_INVALID_DATES';
alter table hr
modify column termdate date;

alter table hr
add column age int;

update hr
set age=timestampdiff(Year,birthdate,curdate());

select 
min(age) as youngest,
max(age) as oldest
from hr;

-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?
select gender,count(*) as count from hr
where age>18
group by gender;

-- 2. What is the race/ethinicity breakdown of employess in the company?
select race,count(*) as count from hr
where age>18
group by race
order by count desc;

-- 3. What is the age distribution of employees in the company?
select
min(age) as minm,
max(age) as maxm
from hr;
select 
 case
    when age>=18 and age<=24 then '18-24'
    when age>=25 and age<=34 then '25-34'
    when age>=35 and age<=44 then '35-44'
    when age>=45 and age<=54 then '45-54'
    when age>=55 and age<=65 then '55-64'
    else '65+'
 end as age_group,
 count(*) as count
 from hr
 group by age_group
 order by age_group;
 
 select 
 case
    when age>=18 and age<=24 then '18-24'
    when age>=25 and age<=34 then '25-34'
    when age>=35 and age<=44 then '35-44'
    when age>=45 and age<=54 then '45-54'
    when age>=55 and age<=65 then '55-64'
    else '65+'
 end as age_group,gender,
 count(*) as count
 from hr
 group by age_group,gender
 order by age_group;
  
-- 4. How many employees work at headquarters versus remote location?
  select location,count(*)
  from hr
  where age>18
  group by location;
  
  -- 5.What is the average length of employment for the employees who have been terminated?
  select 
  round(avg(datediff(termdate,hire_date))/365,0) as avg_emp_len
  from hr
  where termdate<=curdate()  and age>18;
  
  -- 6. How does the gender distribution vary across departments and job titles?
  select
 department, gender,count(*) as count
 from hr
  where age>18
  group by department,gender
  order by department;
  
  -- 7. What is the distribution of job titles in the company?
  select
  jobtitle,count(*) as count
  from hr
  where age>18
  group by jobtitle
  order by jobtitle desc;
  
  -- 8. which department has the highest tuurnover rate?
  select department,
  total_count,
  terminated_count,
  terminated_count/total_count as termination_rate
  from(select department,
  count(*) as total_count,
  sum(case when termdate<>'0000-00-00' and termdate<=curdate() then 1 else 0 end) as terminated_count
  from hr
  where age>18
  group by department) as subquery
  order by termination_rate desc;
  
  -- 9. What is the distribution of employees across location by city and state?
  select location_state,
  count(*) as count
  from hr
  where age>=18 and termdate='0000-00-00'
  group by location_state
  order by count desc;
  
  -- 10.How has the company's employee count changed over time based on hire and term date?
  select
  year,
  hires,
  termination,
  hires-termination as count_change,
  round((hires-termination)/hires * 100,2) as net_change_percent
  from( select
  year(hire_date) as year,
  count(*) as hires,
  sum(case when termdate <> '0000-00-00' and termdate<=curdate() then 1 else 0 end) as termination
  from hr
  where age>=18
  group by year(hire_date)
  ) as subquery
  order by year;
  
  -- 11.What is the tenure distribution for each department?
  select department,round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
  from hr
  where termdate<> '0000-00-00' and termdate <= curdate() and age>=18
  group by department;
  



