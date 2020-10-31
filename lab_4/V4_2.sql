USE AdventureWorks2012;
GO

/*
	a) Создайте представление VIEW, 
	отображающее данные из таблиц 
		Production.ProductModel, 
		Production.ProductModelProductDescriptionCulture, 
		Production.Culture
		Production.ProductDescription. 
	Сделайте невозможным просмотр исходного кода представления. 
	Создайте уникальный кластерный индекс в представлении по полям ProductModelID, CultureID.
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

