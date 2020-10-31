USE AdventureWorks2012;
GO

/*
	a) —оздайте таблицу Production.ProductModelHst, 
	котора€ будет хранить информацию об изменени€х в таблице Production.ProductModel.
	ќб€зательные пол€, которые должны присутствовать в таблице: 
		ID Ч первичный ключ IDENTITY(1,1); 
		Action Ч совершенное действие (insert, update или delete); 
		ModifiedDate Ч дата и врем€, когда была совершена операци€; 
		SourceID Ч первичный ключ исходной таблицы; 
		UserName Ч им€ пользовател€, совершившего операцию. 
	—оздайте другие пол€, если считаете их нужными.
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
	b) —оздайте один AFTER триггер дл€ трех операций INSERT, UPDATE, DELETE 
	дл€ таблицы Production.ProductModel. 
	“риггер должен заполн€ть таблицу Production.ProductModelHst 
	с указанием типа операции в поле Action в зависимости от оператора, 
	вызвавшего триггер.
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
	c) —оздайте представление VIEW, отображающее все пол€ таблицы Production.ProductModel.
*/

CREATE VIEW ProductModelView AS 
	SELECT * FROM Production.ProductModel;
GO

/*
	d) ¬ставьте новую строку в Production.ProductModel через представление. 
	ќбновите вставленную строку. ”далите вставленную строку. 
	”бедитесь, что все три операции отображены в Production.ProductModelHst.
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