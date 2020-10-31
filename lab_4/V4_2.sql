USE AdventureWorks2012;
GO

/*
	a) —оздайте представление VIEW, 
	отображающее данные из таблиц 
		Production.ProductModel, 
		Production.ProductModelProductDescriptionCulture, 
		Production.Culture
		Production.ProductDescription. 
	—делайте невозможным просмотр исходного кода представлени€. 
	—оздайте уникальный кластерный индекс в представлении по пол€м ProductModelID, CultureID.
*/

CREATE VIEW dbo.ProductView
    WITH ENCRYPTION, SCHEMABINDING
AS
SELECT 
	culture.CultureID,
    culture.Name	AS CultName,
    culture.ModifiedDate	AS Cult_ModifiedDate,
    prod_model.CatalogDescription,
    prod_model.Instructions,
    prod_model.Name	AS ProdModelName,
    prod_model.ProductModelID,
    prod_model.ModifiedDate	AS ProdModel_ModifiedDate,
    prod_desc.[Description],
    prod_desc.ProductDescriptionID,
    prod_desc.rowguid,
    prod_desc.ModifiedDate AS ProdDesc_ModifiedDate,
    p_mod_p_desc_cult.ModifiedDate AS ProdModProdDescCult_ModifiedDate
FROM Production.ProductModel AS prod_model
	JOIN Production.ProductModelProductDescriptionCulture AS p_mod_p_desc_cult
		ON prod_model.ProductModelID = p_mod_p_desc_cult.ProductModelID
	JOIN Production.Culture AS culture
		ON culture.CultureID = p_mod_p_desc_cult.CultureID
	JOIN Production.ProductDescription AS prod_desc
		ON prod_desc.ProductDescriptionID = p_mod_p_desc_cult.ProductDescriptionID;
GO

CREATE UNIQUE CLUSTERED INDEX PRODUCT_MODEL_INDX
    ON dbo.ProductView(ProductModelID, CultureID);
GO 

/*
	b) —оздайте три INSTEAD OF триггера дл€ представлени€ 
	на операции INSERT, UPDATE, DELETE. 
	 аждый триггер должен выполн€ть соответствующие операции 
	в таблицах 
		Production.ProductModel, 
		Production.ProductModelProductDescriptionCulture, 
		Production.Culture и 
		Production.ProductDescription. 
	ќбновление не должно происходить в таблице 
		Production.ProductModelProductDescriptionCulture. 
		
	”даление строк из таблиц 
		Production.ProductModel, 
		Production.Culture и 
		Production.ProductDescription 
	производите только в том случае, если удал€емые строки 
	больше не ссылаютс€ на Production.ProductModelProductDescriptionCulture.
*/

--- insert trigger
CREATE TRIGGER ProductViewInsertTrigger
	ON dbo.ProductView
INSTEAD OF INSERT 
AS
BEGIN
	DECLARE @modified_date DATETIME = CURRENT_TIMESTAMP;
	INSERT INTO Production.Culture(CultureID, Name, ModifiedDate)
		SELECT 			
			CultureID,
			CultName, 
			@modified_date
		FROM inserted;
	INSERT INTO Production.ProductModel(Name, CatalogDescription, Instructions, rowguid, ModifiedDate)
		SELECT 
			
			ProdModelName,
			CatalogDescription,
			Instructions,
			rowguid,
			@modified_date
		FROM inserted;	
	INSERT INTO Production.ProductDescription([Description], rowguid, ModifiedDate)
		SELECT 
			[Description],
			rowguid,
			@modified_date
		FROM inserted;	
	INSERT INTO Production.ProductModelProductDescriptionCulture(
		CultureID, 
		ProductModelID, 
		ProductDescriptionID
	) VALUES (
		(SELECT CultureID FROM inserted),
        IDENT_CURRENT('Production.ProductModel'),
        IDENT_CURRENT('Production.ProductDescription')
	);
END;
GO

--- update trigger
CREATE TRIGGER ProductViewUpdateTrigger
	ON dbo.ProductView
INSTEAD OF UPDATE 
AS
BEGIN
	DECLARE @modified_date DATETIME = CURRENT_TIMESTAMP;
	
	UPDATE Production.Culture
	SET	Name = (SELECT CultName FROM inserted),
		ModifiedDate = @modified_date
	WHERE Name = (SELECT CultName FROM deleted);
	
	UPDATE Production.ProductModel
		SET Name = (SELECT ProdModelName FROM inserted),
		ModifiedDate = @modified_date
	WHERE Name = (SELECT ProdModelName FROM deleted)
	
	UPDATE Production.ProductDescription
		SET [Description] = (SELECT [Description] FROM inserted),
		ModifiedDate = @modified_date
	WHERE [Description] = (SELECT [Description] FROM deleted)
END;
GO

--- delete trigger
CREATE TRIGGER ProductViewDeleteTrigger
	ON dbo.ProductView
INSTEAD OF DELETE 
AS
BEGIN
	DECLARE @CultureID NCHAR(6);
	DECLARE @ProductDescriptionID [int];
	DECLARE @ProductModelID [int];
	SELECT 
		@CultureID = CultureID,
        @ProductDescriptionID = ProductDescriptionID,
        @ProductModelID = ProductModelID
	FROM deleted;	

	IF @CultureID NOT IN (SELECT CultureID FROM Production.ProductModelProductDescriptionCulture)
		DELETE FROM Production.Culture
		WHERE @CultureID = CultureID

	IF @ProductModelID NOT IN (SELECT @ProductModelID FROM Production.ProductModelProductDescriptionCulture)
		DELETE FROM Production.ProductModel
		WHERE @ProductModelID = ProductModelID

	IF @ProductDescriptionID NOT IN (SELECT ProductDescriptionID 
		FROM Production.ProductModelProductDescriptionCulture)

		DELETE FROM Production.ProductDescription
		WHERE @ProductDescriptionID = ProductDescriptionID
END;
GO

/*
	c) ¬ставьте новую строку в представление, 
	указав новые данные дл€ ProductModel, Culture и ProductDescription. 
	“риггер должен добавить новые строки в таблицы 
		Production.ProductModel, 
		Production.ProductModelProductDescriptionCulture, 
		Production.Culture и 
		Production.ProductDescription. 
	ќбновите вставленные строки через представление. ”далите строки.
*/

INSERT INTO ProductView(
	CultureID, CultName, ProdModelName, rowguid, [Description]
) VALUES (
	'test3', 'cult3', 'prod3', 'A51EED3A-1A82-4855-99CB-2AFE8290D641', 'hello'
)

UPDATE ProductView
SET
	CultureID = 'tes44'
WHERE CultureID = 'test3'

DELETE FROM ProductView
WHERE CultureID = 'tes44'