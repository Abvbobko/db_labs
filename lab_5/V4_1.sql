USE AdventureWorks2012;
GO

/*
	�������� scalar-valued �������, ������� ����� ��������� � �������� �������� 
	��������� id ������ (Sales.SalesOrderHeader.SalesOrderID) 
	� ���������� ������������ ���� �������� �� ������ (Sales.SalesOrderDetail.UnitPrice).
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
	�������� inline table-valued �������, 
	������� ����� ��������� � �������� ������� ���������� id �������� 
	(Production.Product.ProductID) � ���������� �����, ������� ���������� �������.

	������� ������ ���������� ������������ ���������� ������������������ ������� 
	� �������� � ���������� ��� ����������� (�� Quantity) 
	�� Production.ProductInventory. 
	������� ������ ���������� ������ ��������, ���������� � ������ � (Production.ProductInventory.Shelf).


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
	�������� ������� ��� ������� ��������, �������� �������� CROSS APPLY. 
	�������� ������� ��� ������� ��������, �������� �������� OUTER APPLY.
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
	�������� ��������� inline table-valued �������, 
	������ �� multistatement table-valued 
	(�������������� �������� ��� �������� ��� �������� inline table-valued �������).
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