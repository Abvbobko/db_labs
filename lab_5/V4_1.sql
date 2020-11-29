USE AdventureWorks2012;
GO

/*
	Создайте scalar-valued функцию, которая будет принимать в качестве входного 
	параметра id заказа (Sales.SalesOrderHeader.SalesOrderID) 
	и возвращать максимальную цену продукта из заказа (Sales.SalesOrderDetail.UnitPrice).
*/

CREATE FUNCTION Sales.GetMaxProductPrice(@SalesOrderID INT)
RETURNS money AS
BEGIN
	RETURN (
		SELECT MAX(UnitPrice) 
		FROM Sales.SalesOrderDetail 
		WHERE SalesOrderID=@SalesOrderID
	);
END;
GO

PRINT Sales.GetMaxProductPrice(43664);
GO

SELECT SalesOrderID, UnitPrice FROM Sales.SalesOrderDetail WHERE SalesOrderID=43664;
GO

/*
	Создайте inline table-valued функцию, 
	которая будет принимать в качестве входных параметров id продукта 
	(Production.Product.ProductID) и количество строк, которые необходимо вывести.

	Функция должна возвращать определенное количество инвентаризационных записей 
	о продукте с наибольшим его количеством (по Quantity) 
	из Production.ProductInventory. 
	Функция должна возвращать только продукты, хранящиеся в отделе А (Production.ProductInventory.Shelf).


*/

CREATE FUNCTION Production.GetRaws(@ProductID INT, @NumOfRaws INT)
RETURNS TABLE AS
	RETURN (
		SELECT TOP(@NumOfRaws) * 
		FROM Production.ProductInventory
		WHERE 
			Shelf='A' 
			AND ProductID=@ProductID
		ORDER BY Quantity DESC
	);
GO

SELECT * FROM Production.GetRaws(1, 3);
GO

/*
	Вызовите функцию для каждого продукта, применив оператор CROSS APPLY. 
	Вызовите функцию для каждого продукта, применив оператор OUTER APPLY.
*/

SELECT *
FROM Production.Product AS Product
	CROSS APPLY Production.GetRaws(Product.ProductID, 3);
GO

SELECT *
FROM Production.Product AS Product
	OUTER APPLY Production.GetRaws(Product.ProductID, 3);
GO

/* 
	Измените созданную inline table-valued функцию, 
	сделав ее multistatement table-valued 
	(предварительно сохранив для проверки код создания inline table-valued функции).
*/ 

CREATE FUNCTION Production.GetRaws(@ProductID INT, @NumOfRaws INT)
RETURNS @Raws TABLE(
	ProductID int, 	
	Quantity int,	
	Shelf nvarchar,
	ModifiedDate datetime
) AS
BEGIN
	INSERT INTO @Raws
		SELECT TOP(@NumOfRaws)
			ProductID, Quantity, Shelf, ModifiedDate
		FROM Production.ProductInventory
		WHERE 
			Shelf='A' 
			AND ProductID=@ProductID
		ORDER BY Quantity DESC
	RETURN;
END;
GO

SELECT *
FROM Production.Product AS Product
	CROSS APPLY Production.GetRaws(Product.ProductID, 3);
GO