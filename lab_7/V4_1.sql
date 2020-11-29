USE AdventureWorks2012;
GO

/*
	Вывести значения полей [BusinessEntityID], [Name], [AccountNumber] из таблицы 
	[Purchasing].[Vendor] в виде xml, сохраненного в переменную.

		Создать хранимую процедуру, возвращающую таблицу, 
	заполненную из xml переменной представленного вида. 
	Вызвать эту процедуру для заполненной на первом шаге переменной.
*/

CREATE PROCEDURE dbo.XML_to_Table(@xml_var XML)
AS
BEGIN
	SELECT 
		xml_var.item.value('ID[1]', 'int') BusinessEntityID,
		xml_var.item.value('Name[1]', 'nvarchar(50)') Name,
		xml_var.item.value('AccountNumber[1]', 'nvarchar(15)') AccountNumber
	FROM @xml_var.nodes('Vendors/Vendor') xml_var(item);
END;
GO


DECLARE @xml XML;
SET @xml = ( 
	SELECT 
		BusinessEntityID AS ID, 
		Name, 
		AccountNumber 
	FROM Purchasing.Vendor
	FOR XML PATH('Vendor'), ROOT('Vendors')
);

SELECT @xml;
EXEC dbo.XML_to_Table @xml;
GO

