USE AdventureWorks2012;
GO

/*
	a) �������� ������� Production.ProductModelHst, 
	������� ����� ������� ���������� �� ���������� � ������� Production.ProductModel.
	������������ ����, ������� ������ �������������� � �������: 
		ID � ��������� ���� IDENTITY(1,1); 
		Action � ����������� �������� (insert, update ��� delete); 
		ModifiedDate � ���� � �����, ����� ���� ��������� ��������; 
		SourceID � ��������� ���� �������� �������; 
		UserName � ��� ������������, ������������ ��������. 
	�������� ������ ����, ���� �������� �� �������.
*/

CREATE TABLE Production.ProductModelHst (
	ID INT IDENTITY(1,1) PRIMARY KEY,
	[Action] NVARCHAR(8) NOT NULL CHECK(
		[Action] IN (
			'insert',
			'update',
			'delete'
		)
	), 
	ModifiedDate DATETIME NOT NULL,
	SourceID INT NOT NULL,
	UserName NVARCHAR(25) NOT NULL
);
GO

/*
	b) �������� ���� AFTER ������� ��� ���� �������� INSERT, UPDATE, DELETE 
	��� ������� Production.ProductModel. 
	������� ������ ��������� ������� Production.ProductModelHst 
	� ��������� ���� �������� � ���� Action � ����������� �� ���������, 
	���������� �������.
*/

CREATE TRIGGER prod_model_operation_change_trigger
	ON Production.ProductModel
AFTER 
	INSERT, UPDATE, DELETE   
AS
	IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
		INSERT INTO Production.ProductModelHst 
		SELECT 
			'update',
			CURRENT_TIMESTAMP,
			ProductModelID,
			CURRENT_USER
		FROM inserted
	ELSE IF EXISTS (SELECT * FROM inserted)
		INSERT INTO Production.ProductModelHst 
		SELECT 
			'insert',
			CURRENT_TIMESTAMP,
			ProductModelID,
			CURRENT_USER
		FROM inserted
	ELSE IF EXISTS (SELECT * FROM deleted)
		INSERT INTO Production.ProductModelHst
		SELECT 
			'delete',
			CURRENT_TIMESTAMP,
			ProductModelID,
			CURRENT_USER
		FROM deleted;	
GO

/*
	c) �������� ������������� VIEW, ������������ ��� ���� ������� Production.ProductModel.
*/

CREATE VIEW ProductModelView AS 
	SELECT * FROM Production.ProductModel;
GO

/*
	d) �������� ����� ������ � Production.ProductModel ����� �������������. 
	�������� ����������� ������. ������� ����������� ������. 
	���������, ��� ��� ��� �������� ���������� � Production.ProductModelHst.
*/

SELECT * FROM ProductModelView

INSERT INTO ProductModelView (
	Name,	 
	rowguid,
	ModifiedDate
) VALUES (	
	'test',	
	'A35598F6-B413-4138-8081-5DC7D4C64B64',
	CURRENT_TIMESTAMP
);	
GO

UPDATE ProductModelView
SET Name = 'test2' 
WHERE rowguid = 'A35598F6-B413-4138-8081-5DC7D4C64B64';	
GO

DELETE FROM ProductModelView
WHERE rowguid = 'A35598F6-B413-4138-8081-5DC7D4C64B64';	
GO

SELECT * FROM Production.ProductModelHst
GO