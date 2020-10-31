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