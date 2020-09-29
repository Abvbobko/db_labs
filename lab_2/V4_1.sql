USE AdventureWorks2012;
GO

/*
	1. Вывести на экран неповторяющийся список должностей в каждом отделе, 
	отсортированный по названию отдела. 
	Посчитайте количество сотрудников, работающих в каждом отделе.
*/

SELECT DISTINCT
	d.Name as DepartmentName,
	JobTitle,
	COUNT(*) OVER(PARTITION BY d.Name) as EmpCount
FROM HumanResources.Department AS d
INNER JOIN HumanResources.EmployeeDepartmentHistory AS edh
ON d.DepartmentID = edh.DepartmentID
INNER JOIN HumanResources.Employee AS e
ON e.BusinessEntityID = edh.BusinessEntityID
ORDER BY d.Name;

/*
	2. Вывести на экран сотрудников, которые работают в ночную смену.
*/

SELECT 
		e.BusinessEntityID,
		JobTitle,
		Name,
		StartTime,
		EndTime
FROM HumanResources.Employee AS e
INNER JOIN HumanResources.EmployeeDepartmentHistory AS edh
ON e.BusinessEntityID = edh.BusinessEntityID
INNER JOIN HumanResources.Shift AS s
ON s.ShiftID = edh.ShiftID
WHERE Name = 'Night'

/*
	3. Вывести на экран почасовые ставки сотрудников. 
	Добавить столбец с информацией о предыдущей почасовой ставке для каждого сотрудника. 
	Добавить еще один столбец с указанием разницы между текущей ставкой и 
	предыдущей ставкой для каждого сотрудника.
*/

SELECT
	e.BusinessEntityID,
	JobTitle,
	eph.Rate,
	ISNULL(prev_eph.Rate, 0.00) as PrevRate,
	eph.Rate - ISNULL(prev_eph.Rate, 0.00) as Increased
FROM HumanResources.Employee as e
INNER JOIN HumanResources.EmployeePayHistory as eph
ON e.BusinessEntityID = eph.BusinessEntityID
LEFT JOIN HumanResources.EmployeePayHistory as prev_eph
ON e.BusinessEntityID = prev_eph.BusinessEntityID
AND prev_eph.RateChangeDate < eph.RateChangeDate;
