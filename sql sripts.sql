select * from Loan_dataset;

-- overall approval rate 
select count(*) as Total_Application,
SUM(case when Loan_Status ="YES" THEN 1 ELSE 0 END) AS Accepted,
Sum(case when Loan_Status = "No" THEN 1 ELSE 0 END) AS Rejected,
ROUND(SUM(case when Loan_Status = "YES" THEN 1 ELSE 0 END) * 100 / COUNT(*),2) as Approval_rate_percent
from Loan_dataset;

-- Approval  by education, gender, property area
SELECT Education, 
Count(*) as total_Applications,
SUM(CASE WHEN Loan_status = 'YES' THEN 1 ELSE 0 END) as Approved,
ROUND(SUM(CASE WHEN Loan_status = 'Yes' Then 1 ELSE 0 END ) *  100.0/ COUNT(*), 2) as approval_rate_percent
FROM Loan_dataset
GROUP BY Education;

select gender,
count(*) as Total_Application, 
sum(case when Loan_status = 'Yes' then 1 ELSE 0 END) AS Approved,
ROUND(sum(case when Loan_status = 'Yes' then 1 ELSE 0 END) * 100.0/ COUNT(*),2) as approval_rate_percentage
from Loan_dataset
group by gender;


select Property_Area,
count(*) as Total_Application,
sum(case when Loan_Status = 'Yes' then 1 Else 0 END) as Approved,
ROUND(sum(case when Loan_Status = 'Yes' then 1 Else 0 END) * 100.0 / Count(*),2) as Approval_rate_percent
from Loan_dataset
GROUP BY Property_Area;

-- Average income by approval status
SELECT Loan_Status,
Round(AVG(Total_household_income),2) as Avergae_Income
from Loan_dataset
group by Loan_Status;

-- DEBT TO INCOME RATIO 
select loan_status,
round(AVG(Loan_Amount / (Total_household_income) ), 2) as Average_debt_to_income_ratio
from Loan_dataset
group by Loan_Status;

-- per customer
select loan_status,
round(Loan_Amount / Total_household_income, 2) as debt_to_income_ratio_per_customer
from Loan_dataset;

-- Approval recommendation model -[Approve,Review,Reject]

select count(*) as total_Application,
sum(case when credit_history = '1' THEN 1 ELSE 0 END) as Approve,
sum(case when credit_history = '0' AND Total_household_income >= 8000 THEN 1 ELSE 0 END) as Review,
sum(case when credit_history = '0' AND Total_household_income < 8000 THEN 1 ELSE 0 END) as Reject
from Loan_dataset;

select * from Loan_dataset;
