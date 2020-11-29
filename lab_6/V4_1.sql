USE AdventureWorks2012;
GO

/*
	Создайте хранимую процедуру, которая будет возвращать сводную таблицу (оператор PIVOT), 
	отображающую данные о количестве работников, 
	нанятых в каждый отдел (HumanResources.Department) 
	за определённый год (HumanResources.EmployeeDepartmentHistory.StartDate). 
	Список лет передайте в процедуру через входной параметр.

	Таким образом, вызов процедуры будет выглядеть следующим образом:

	EXECUTE dbo.EmpCountByDep ‘[2003],[2004],[2005]’
*/

CREATE PROCEDURE dbo.EmpCountByDep @years varchar(MAX)
AS
BEGIN 
	DECLARE @query AS NVARCHAR(MAX);	
	SET @query = 'SELECT *
		FROM (
				SELECT 
					Department.DepartmentID,
					Department.Name,										
					YEAR (History.StartDate) as StartYear
				FROM HumanResources.Department AS Department
				JOIN HumanResources.EmployeeDepartmentHistory AS History
					ON Department.DepartmentID = History.DepartmentID
			) AS Employees
		PIVOT (
			COUNT (DepartmentID)
			FOR StartYear IN (' + @years + ')
		) AS NumOfEmployees
		ORDER BY Name;'
	execute sp_executesql @query;
END;
GO

EXECUTE dbo.EmpCountByDep '[2003],[2004],[2005]';