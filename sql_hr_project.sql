create database hr_database;
select *  from hr_2;
drop table hr_1;
alter table hr_1
MODIFY COLUMN employeenumber int primary key;

#average attrition rate each department
select Department,avg(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)*100 AS Attrition_Rate 
 from hr_1 group by department order by Attrition_rate desc;
 
#Average Hourly rate of Male Research Scientist
select avg(hourlyrate) as avg_rate from hr_1 where jobrole = "Research Scientist" and gender = "male";

#average working year in the company
(select department,avg(TotalWorkingYears) as avg_working_year from hr_1 left join hr_2 on employeenumber = hr_2.Employee_ID group by Department) union 
(select department,avg(TotalWorkingYears) as avg_working_year from hr_1 right join hr_2 on employeenumber = hr_2.Employee_ID group by department);


#job profile vs worklife balance
(select jobrole, avg(WorkLifeBalance) as  Average_WorkLifeBalance from hr_1 left join hr_2 on employeenumber = hr_2.Employee_ID group by JobRole)union
(select jobrole, avg(WorkLifeBalance) as  Average_WorkLifeBalance from hr_1 right join hr_2 on employeenumber = hr_2.Employee_ID group by jobrole );


#attrition rate vs monthly income stats
(SELECT 
    CASE 
        WHEN MonthlyIncome < 3000 THEN 'Low Income'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Medium Income'
        WHEN MonthlyIncome BETWEEN 6001 AND 10000 THEN 'High Income'
        ELSE 'Very High Income'
    END AS Income_Group,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS Attrition_Rate_Percentage
FROM hr_1 left join hr_2 on employeenumber = hr_2.Employee_ID GROUP BY Income_Group ORDER BY Attrition_Rate_Percentage DESC )
union (SELECT 
    CASE 
        WHEN MonthlyIncome < 3000 THEN 'Low Income'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Medium Income'
        WHEN MonthlyIncome BETWEEN 6001 AND 10000 THEN 'High Income'
        ELSE 'Very High Income'
    END AS Income_Group,COUNT(*) AS Total_Employees,SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS Attrition_Rate_Percentage
FROM hr_1 right join hr_2 on employeenumber = hr_2.Employee_ID
GROUP BY Income_Group
ORDER BY Attrition_Rate_Percentage DESC);


#attrition rate vs year since promotion relation
(SELECT YearsSinceLastPromotion,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS Attrition_Rate_Percentage
FROM hr_1  left join hr_2 on employeenumber = hr_2.Employee_ID GROUP BY YearsSinceLastPromotion ORDER BY YearsSinceLastPromotion) union
 (SELECT YearsSinceLastPromotion,
	COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS Attrition_Rate_Percentage
FROM hr_1  right join hr_2 on employeenumber = hr_2.Employee_ID GROUP BY YearsSinceLastPromotion ORDER BY YearsSinceLastPromotion);