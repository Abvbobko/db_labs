USE AdventureWorks2012;
GO

/*
	a) �������� � ������� dbo.StateProvince ���� CountryRegionName ���� nvarchar(50);
*/

ALTER TABLE dbo.StateProvince ADD CountryRegionName NVARCHAR(50);
GO

/*
	b) �������� ��������� ���������� � ����� �� ���������� 
		��� dbo.StateProvince � ��������� �� ������� �� dbo.StateProvince. 
		��������� ���� CountryRegionName ������� �� Person.CountryRegion ���� Name;
*/

DECLARE @StateProvince TABLE (
	StateProvinceID INT NOT NULL,
	StateProvinceCode NCHAR(3) NOT NULL,
	CountryRegionCode NVARCHAR(3) NOT NULL,
	Name dbo.Name NOT NULL,
	TerritoryID INT NOT NULL,
	ModifiedDate DATETIME NOT NULL,
	CountryNum INT NULL,
	CountryRegionName NVARCHAR(50) NULL	
)

INSERT INTO @StateProvince (
	StateProvinceID,
	StateProvinceCode,
	CountryRegionCode,
	Name,
	TerritoryID,
	ModifiedDate,
	CountryNum,
	CountryRegionName
) SELECT
	sp.StateProvinceID,
	sp.StateProvinceCode,
	sp.CountryRegionCode,
	sp.Name,
	sp.TerritoryID,
	sp.ModifiedDate,
	sp.CountryNum,
	cr.Name
FROM dbo.StateProvince AS sp
INNER JOIN Person.CountryRegion AS cr
ON sp.CountryRegionCode = cr.CountryRegionCode;

/*
	c) �������� ���� CountryRegionName � dbo.StateProvince ������� �� ��������� ����������;
*/

UPDATE dbo.StateProvince
SET CountryRegionName = sp.CountryRegionName
FROM @StateProvince AS sp
WHERE dbo.StateProvince.StateProvinceID = sp.StateProvinceID;
GO

/*
	d) ������� ����� �� dbo.StateProvince, ������� ����������� � ������� Person.Address;
*/

DELETE FROM dbo.StateProvince
WHERE StateProvinceID NOT IN (
	SELECT StateProvinceID FROM Person.Address
)
GO

/*
	e) ������� ���� CountryRegionName �� �������, 
	������� ��� ��������� ����������� � �������� �� ���������.
*/

--- ������� ����
ALTER TABLE dbo.StateProvince DROP COLUMN CountryRegionName;
GO

--- ������� �����������
ALTER TABLE dbo.StateProvince 
DROP CONSTRAINT name_is_unique, no_Digits;

--- ����� �������� �� ���������

SELECT name
FROM sys.objects 
WHERE [type] = 'D' AND parent_object_id = (
	SELECT object_id
	FROM sys.objects
	WHERE schema_Name(schema_id) = 'dbo' AND name = 'StateProvince'
)

--- ������� �������� �� ���������
ALTER TABLE dbo.StateProvince 
DROP CONSTRAINT modified_date_default;
GO

/*
	f) ������� ������� dbo.StateProvince
*/

DROP TABLE dbo.StateProvince;

