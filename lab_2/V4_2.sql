USE AdventureWorks2012;
GO


/*
	a) создайте таблицу dbo.StateProvince с такой же структурой как Person.StateProvince, 
	кроме поля uniqueidentifier, не включая индексы, ограничения и триггеры;
*/

CREATE TABLE dbo.StateProvince (
	StateProvinceID INT NOT NULL,        
	StateProvinceCode NCHAR(3) NOT NULL,
	CountryRegionCode NVARCHAR(3) NOT NULL, 
	IsOnlyStateProvinceFlag dbo.Flag NOT NULL,
	Name dbo.Name NOT NULL,
	TerritoryID INT NOT NULL,  
	ModifiedDate DATETIME NOT NULL
);
GO

/*
	b) используя инструкцию ALTER TABLE, 
	создайте для таблицы dbo.StateProvince ограничение UNIQUE для поля Name;
*/	

ALTER TABLE dbo.StateProvince 
ADD CONSTRAINT name_is_unique UNIQUE (Name);
GO

/*
	c) используя инструкцию ALTER TABLE, 
	создайте для таблицы dbo.StateProvince ограничение 
	для поля CountryRegionCode, запрещающее заполнение этого поля цифрами;
*/

ALTER TABLE dbo.StateProvince 
ADD CONSTRAINT no_Digits 
	CHECK (StateProvinceCode NOT LIKE '%[0-9]%')

/*
	d) используя инструкцию ALTER TABLE, 
	создайте для таблицы dbo.StateProvince ограничение DEFAULT 
	для поля ModifiedDate, задайте значение по умолчанию текущую дату и время;
*/

ALTER TABLE dbo.StateProvince 
ADD CONSTRAINT modified_date_default
	DEFAULT GETDATE() FOR ModifiedDate;

/*
	e) заполните новую таблицу данными из Person.StateProvince. 
	Выберите для вставки только те данные, 
	где имя штата/государства совпадает с именем страны/региона 
	в таблице CountryRegion;
*/

INSERT INTO dbo.StateProvince 
SELECT 
	st.StateProvinceID,
	st.StateProvinceCode,
	st.CountryRegionCode,
	st.IsOnlyStateProvinceFlag,
	st.Name,
	st.TerritoryID,
	st.ModifiedDate
FROM Person.StateProvince AS st
INNER JOIN Person.CountryRegion AS cr
ON st.Name = cr.Name;
GO

/*
	f) удалите поле IsOnlyStateProvinceFlag, 
	а вместо него создайте новое CountryNum типа int допускающее null значения.
*/

ALTER TABLE dbo.StateProvince DROP COLUMN IsOnlyStateProvinceFlag;

ALTER TABLE dbo.StateProvince ADD CountryNum INT NULL;


