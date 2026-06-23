Create database HospitalData
Use HospitalData 
Go
Select * from hospital_data

--1. How many patient are in the data set
Select Count(*) As Total_patients From hospital_data

--2. What is the average age of patients?
Select Round(Avg(Cast(Age as Float)), 2) As Average_Patient_Age From hospital_data

--3. What is the gender distribution of patients?
Select Gender, Count(*) As Total_Patients, Round(Count(*) * 100.0 / Sum(Count(*)) over (), 2) As percentage_of_Patients
From hospital_data
Group by Gender
Order by Total_Patients Desc

--4. which medical condition are most common
Select Condition, Count(*) As Total_Patients From hospital_data
Group by Condition
Order by Total_Patients Desc

--5. Which Procedure are performed the most often?
Select "Procedure", Count(*) As Total_Procedure From hospital_data
Group by "Procedure"
Order by Total_Procedure Desc

--6. What is the total treatment cost across all patients?
select Format(sum(cost), 'N2') As Total_Treatment_Cost From hospital_data

--7. What is the average treatment cost per patient?
Select Format(Avg(Cast(Cost as Float)), 'N2') As Average_Treatment_Cost from hospital_data
 
--8 Which medical conditions generate the highest total treatment cost?
Select 
    Condition,
    SUM(Cost) AS Total_Cost,
    ROUND(AVG(CAST(Cost AS FLOAT)), 2) AS Average_Cost_Per_Patient
From hospital_data
Group By Condition
Order By Total_Cost Desc;

--9. Which procedures have the highest average treatment cost
Select 
    "Procedure",
    ROUND(AVG(CAST(Cost AS FLOAT)), 2) AS Average_Procedure_Cost,
    SUM(Cost) AS Total_Procedure_Cost
From hospital_data
Group By "Procedure"
Order By Average_Procedure_Cost Desc

--10. What is the average lenght of stay for patients?
Select
    ROUND(AVG(CAST(Length_of_Stay AS FLOAT)), 2) AS Average_Length_Of_Stay_Days
From hospital_data

--11.Which medical conditions have th elongest average hospital stay?
Select
    Condition,
    ROUND(AVG(CAST(Length_of_Stay AS FLOAT)), 2) AS Average_Length_Of_Stay,
    MAX(Length_of_Stay) AS Longest_Stay
From hospital_data
Group By Condition
Order By Average_Length_Of_Stay Desc

--12. What is the readmission rate?
Select 
    COUNT(*) AS Total_Patients,
    SUM(CASE WHEN Readmission = 1 THEN 1 ELSE 0 END) AS Readmitted_Patients,
    ROUND(
        SUM(CASE WHEN Readmission = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Readmission_Rate_Percentage
From hospital_data

--13. Which medical conditions have the highest readmission rate?
Select
    Condition,
    COUNT(*) AS Total_Patients,
    SUM(CASE WHEN Readmission = 1 THEN 1 ELSE 0 END) AS Readmitted_Patients,
    ROUND(
        SUM(CASE WHEN Readmission = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Readmission_Rate_Percentage
FROM hospital_data
GROUP BY Condition
ORDER BY Readmission_Rate_Percentage Desc

--14. Does readmission differ by gender? Ans: Yes
Select 
    Gender,
    COUNT(*) AS Total_Patients,
    SUM(CASE WHEN Readmission = 1 THEN 1 ELSE 0 END) AS Readmitted_Patients,
    ROUND(
        SUM(CASE WHEN Readmission = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Readmission_Rate_Percentage
From hospital_data
Group By Gender
Order By Readmission_Rate_Percentage Desc

--15. What is the overall outcome distribution?
Select 
    Outcome,
    COUNT(*) AS Total_Patients,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS Outcome_Percentage
From hospital_data
Group By Outcome
Order By Total_Patients Desc

--16. Which conditions have the highest recovery rate?
Select 
    Condition,
    COUNT(*) AS Total_Patients,
    SUM(CASE WHEN Outcome = 'Recovered' THEN 1 ELSE 0 END) AS Recovered_Patients,
    ROUND(
        SUM(CASE WHEN Outcome = 'Recovered' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Recovery_Rate_Percentage
From hospital_data
Group by Condition
Order by Recovery_Rate_Percentage Desc

--17.What is the average satisfaction score by medical condition
Select 
    Condition,
    ROUND(AVG(CAST(Satisfaction AS FLOAT)), 2) AS Average_Satisfaction_Score,
    COUNT(*) AS Total_Patients
From hospital_data
Group by Condition
Order by Average_Satisfaction_Score Desc

--18. Which procedures have the lowest patient satisfaction scores? Ans: Cardiac catheterization
Select 
    "Procedure",
    ROUND(AVG(CAST(Satisfaction AS FLOAT)), 2) AS Average_Satisfaction_Score,
    COUNT(*) AS Total_Patients
From hospital_data
Group By "Procedure"
Order By Average_Satisfaction_Score ASC

--19. Does a longer hospital stay affect patient satisfaction? Ans: yes longer stay affect patient satisfaction
Select 
    CASE 
        WHEN Length_of_Stay <= 3 THEN 'Short Stay (1-3 Days)'
        WHEN Length_of_Stay BETWEEN 4 AND 7 THEN 'Medium Stay (4-7 Days)'
        ELSE 'Long Stay (8+ Days)'
    END AS Stay_Category,
    COUNT(*) AS Total_Patients,
    ROUND(AVG(CAST(Satisfaction AS FLOAT)), 2) AS Average_Satisfaction_Score,
    ROUND(AVG(CAST(Cost AS FLOAT)), 2) AS Average_Treatment_Cost
From hospital_data
Group by 
    CASE 
        WHEN Length_of_Stay <= 3 THEN 'Short Stay (1-3 Days)'
        WHEN Length_of_Stay BETWEEN 4 AND 7 THEN 'Medium Stay (4-7 Days)'
        ELSE 'Long Stay (8+ Days)'
    END
Order by Average_Satisfaction_Score Desc

--20. Which patient are high-cost, long-stay and readmitted?
Select 
    Patient_ID,
    Age,
    Gender,
    Condition,
    "Procedure",
    Cost,
    Length_of_Stay,
    Readmission,
    Outcome,
    Satisfaction
From hospital_data
Where Cost >= 10000
  AND Length_of_Stay >= 7
  AND Readmission = 1
Order by Cost Desc, Length_of_Stay Desc


