USE AdventureWorks2012;
GO

/*
	a) выполните код, созданный во втором задании второй лабораторной работы. 
	Добавьте в таблицу dbo.StateProvince поля SalesYTD MONEY и SumSales MONEY. 
	Также создайте в таблице вычисляемое поле SalesPercent, 
	вычисляющее процентное выражение значения в поле 
	SumSales от значения в поле SalesYTD.
*/

ALTER TABLE dbo.StateProvince 
ADD
	SalesYTD MONEY,
	SumSales MONEY,
	SalesPercent AS SalesYTD/SumSales * 100 PERSISTED
GO

/*
	b) создайте временную таблицу #StateProvince, 
	с первичным ключом по полю StateProvinceID. 
	Временная таблица должна включать все поля таблицы 
	dbo.StateProvince за исключением поля SalesPercent.
*/