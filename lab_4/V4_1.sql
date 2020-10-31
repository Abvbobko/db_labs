USE AdventureWorks2012;
GO

/*
	a) Создайте таблицу Production.ProductModelHst, 
	которая будет хранить информацию об изменениях в таблице Production.ProductModel.
	Обязательные поля, которые должны присутствовать в таблице: 
		ID — первичный ключ IDENTITY(1,1); 
		Action — совершенное действие (insert, update или delete); 
		ModifiedDate — дата и время, когда была совершена операция; 
		SourceID — первичный ключ исходной таблицы; 
		UserName — имя пользователя, совершившего операцию. 
	Создайте другие поля, если считаете их нужными.
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
	b) Создайте один AFTER триггер для трех операций INSERT, UPDATE, DELETE 
	для таблицы Production.ProductModel. 
	Триггер должен заполнять таблицу Production.ProductModelHst 
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
	c) Создайте представление VIEW, отображающее все поля таблицы Production.ProductModel.
*/

CREATE VIEW ProductModelView AS 
	SELECT * FROM Production.ProductModel;
GO

/*
	d) Вставьте новую строку в Production.ProductModel через представление. 
	Обновите вставленную строку. Удалите вставленную строку. 
	Убедитесь, что все три операции отображены в Production.ProductModelHst.
*/

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