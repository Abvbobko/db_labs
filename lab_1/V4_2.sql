USE AdventureWorks2012;
GO

/*  
	1. ������� �� ����� ������ �������, 
	������������� ������ �Executive General and Administration�.
*/

SELECT Name, GroupName 
FROM HumanResources.Department 
WHERE GroupName = 'Executive General and Administration';

/*  
	2. ������� �� ����� ������������ ���������� ���������� ����� ������� � �����������. 
	�������� ������� � ����������� �MaxVacationHours�.
*/

SELECT 
	MAX(VacationHours) AS MaxVacationHours 
FROM HumanResources.Employee;

/*  
	3. ������� �� ����� �����������, 
	�������� ������� ������� �������� ����� �Engineer�.
*/

SELECT 
	BusinessEntityID, JobTitle, Gender, BirthDate, HireDate 
FROM HumanResources.Employee 
WHERE JobTitle LIKE '%Engineer%';