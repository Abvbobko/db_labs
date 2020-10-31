USE AdventureWorks2012;
GO

/*
	a) добавьте в таблицу dbo.StateProvince поле CountryRegionName типа nvarchar(50);
*/

ALTER TABLE dbo.StateProvince ADD CountryRegionName NVARCHAR(50);
GO

/*
	b) объявите табличную переменную с такой же структурой 
		как dbo.StateProvince и заполните ее данными из dbo.StateProvince. 
		Заполните поле CountryRegionName данными из Person.CountryRegion поля Name;
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
	c) обновите поле CountryRegionName в dbo.StateProvince данными из табличной переменной;
*/

UPDATE dbo.StateProvince
SET CountryRegionName = sp.CountryRegionName
FROM @StateProvince AS sp
WHERE dbo.StateProvince.StateProvinceID = sp.StateProvinceID;
GO

/*
	d) удалите штаты из dbo.StateProvince, которые отсутствуют в таблице Person.Address;
*/

DELETE FROM dbo.StateProvince
WHERE StateProvinceID NOT IN (
	SELECT StateProvinceID FROM Person.Address
)
GO

/*
	e) удалите поле CountryRegionName из таблицы, 
	удалите все созданные ограничения и значения по умолчанию.
*/

--- удаляем поле
ALTER TABLE dbo.StateProvince DROP COLUMN CountryRegionName;
GO

--- удаляем ограничения
ALTER TABLE dbo.StateProvince 
DROP CONSTRAINT name_is_unique, no_Digits;

--- имена значений по умолчанию

SELECT name
FROM sys.objects 
WHERE [type] = 'D' AND parent_object_id = (
	SELECT object_id
	FROM sys.objects
	WHERE schema_Name(schema_id) = 'dbo' AND name = 'StateProvince'
)

--- удаляем значения по умолчанию
ALTER TABLE dbo.StateProvince 
DROP CONSTRAINT modified_date_default;
GO

/*
	f) удалите таблицу dbo.StateProvince
*/

DROP TABLE dbo.StateProvince;

