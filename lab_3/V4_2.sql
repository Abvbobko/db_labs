USE AdventureWorks2012;
GO

/*
	a) ��������� ���, ��������� �� ������ ������� ������ ������������ ������. 
	�������� � ������� dbo.StateProvince ���� SalesYTD MONEY � SumSales MONEY. 
	����� �������� � ������� ����������� ���� SalesPercent, 
	����������� ���������� ��������� �������� � ���� 
	SumSales �� �������� � ���� SalesYTD.
*/

ALTER TABLE dbo.StateProvince 
ADD
	SalesYTD MONEY,
	SumSales MONEY,
	SalesPercent AS SalesYTD/SumSales * 100 PERSISTED
GO

/*
	b) �������� ��������� ������� #StateProvince, 
	� ��������� ������ �� ���� StateProvinceID. 
	��������� ������� ������ �������� ��� ���� ������� 
	dbo.StateProvince �� ����������� ���� SalesPercent.
*/

CREATE TABLE #StateProvince (
	StateProvinceID INT NOT NULL PRIMARY KEY,        
	StateProvinceCode NCHAR(3) NOT NULL,
	CountryRegionCode NVARCHAR(3) NOT NULL, 	
	Name NVARCHAR(50) NOT NULL,
	TerritoryID INT NOT NULL,  
	ModifiedDate DATETIME NOT NULL,
	CountryNum INT NULL,
	SalesYTD MONEY,
	SumSales MONEY
);
GO

/*
	c) ��������� ��������� ������� ������� �� dbo.StateProvince. 
	���� SalesYTD ��������� ���������� �� ������� Sales.SalesTerritory. 
	���������� ����� ������ (SalesYTD) ��� ������ ���������� (TerritoryID) 
	� ������� Sales.SalesPerson � ��������� ����� ���������� ���� SumSales. 
	������� ����� ������ ����������� � Common Table Expression (CTE).
*/

WITH sales_cte AS (
	SELECT 
		sales_per.TerritoryID,
        SUM(sales_per.SalesYTD) AS SumSales
    FROM Sales.SalesPerson AS sales_per
		--JOIN Sales.SalesTerritory AS sales_terr
		--ON sales_per.TerritoryID = sales_terr.TerritoryID
    GROUP BY sales_per.TerritoryID
) 
INSERT INTO #StateProvince 
SELECT 
	state_prov.StateProvinceID,
	state_prov.StateProvinceCode,
	state_prov.CountryRegionCode,
	state_prov.Name,
	state_prov.TerritoryID,
	state_prov.ModifiedDate,
	state_prov.CountryNum,
	state_terr.SalesYTD,
	sales_cte.SumSales
FROM dbo.StateProvince AS state_prov
    JOIN Sales.SalesTerritory AS state_terr
ON state_prov.TerritoryID = state_terr.TerritoryID
    JOIN sales_cte
    ON sales_cte.TerritoryID = state_prov.TerritoryID;
GO

/*
	d) ������� �� ������� dbo.StateProvince ���� ������ (��� StateProvinceID = 5)
*/

DELETE FROM dbo.StateProvince
WHERE StateProvinceID = 5;
GO

/*
	e) �������� Merge ���������, ������������ dbo.StateProvince ��� target, 
	� ��������� ������� ��� source. 
	��� ����� target � source ����������� StateProvinceID. 
	�������� ���� SalesYTD � SumSales, ���� ������ ������������ � source � target. 
	���� ������ ������������ �� ��������� �������, 
	�� �� ���������� � target, �������� ������ � dbo.StateProvince. 
	���� � dbo.StateProvince ������������ ����� ������, 
	������� �� ���������� �� ��������� �������, ������� ������ �� dbo.StateProvince.
*/

MERGE dbo.StateProvince AS target_table 
USING #StateProvince AS source_table
ON target_table.StateProvinceID = source_table.StateProvinceID
WHEN MATCHED THEN
UPDATE 
	SET 
		target_table.SalesYTD = source_table.SalesYTD,
		target_table.SumSales = source_table.SumSales
WHEN NOT MATCHED THEN
INSERT VALUES (
	StateProvinceID,
	StateProvinceCode,
	CountryRegionCode,
    Name,
    TerritoryID,
    ModifiedDate,
    CountryNum,
    SalesYTD,
    SumSales
)
WHEN NOT MATCHED BY SOURCE THEN
DELETE;
GO
