USE AdventureWorks2012;
GO

/*  
	1. Вывести на экран список отделов, 
	принадлежащих группе ‘Executive General and Administration’.
*/

SELECT Name, GroupName 
FROM HumanResources.Department 
WHERE GroupName = 'Executive General and Administration';

/*  
	2. Вывести на экран максимальное количество оставшихся часов отпуска у сотрудников. 
	Назовите столбец с результатом ‘MaxVacationHours’.
*/

SELECT 
	MAX(VacationHours) AS MaxVacationHours 
FROM HumanResources.Employee;

/*  
	3. Вывести на экран сотрудников, 
	название позиции которых включает слово ‘Engineer’.
*/

SELECT 
	BusinessEntityID, JobTitle, Gender, BirthDate, HireDate 
FROM HumanResources.Employee 
WHERE JobTitle LIKE '%Engineer%';