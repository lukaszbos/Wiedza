/*
Created: 10/14/2021
Modified: 10/27/2021
Model: Logical model - zaawansowane bazy danych
Database: MS SQL Server 2019
*/

/*
Zadanie 03
Ad. 1

Index pogrupowany jest automatycznie generowany przez MS SQL Server na kluczu głównym każdej tabeli. 
Może istnieć tylko jeden taki klucz w danej tabeli więc nie możemy dodać kolejnego jednakże jest to najlepszy wybór biorąc pod uwagę
że klucz główny tabeli jest bardzo często używany w klauzuli WHERE zapytania SELECT

Indexy niepogrupowane zostały dodane na wszystkie klucze obce, gdyż są one używane przy wykonywaniu złączeń, a złączenia są operacją bardzo częstą w zapytaniach. 
Dzięki indeksom znacznie przyspieszymy wykonywanie zapytań wybierających dane z wielu tabel.
Ponadto indeks niepogrupowany został założony na kolumny orderDate oraz shipDate tabeli Order, 
która bedzie czesto znajdowała się w warunku WHERE - dzięki nim serwer nie bedzie przeszukiwał wszystkich danych, aby znaleźć szukane rekordy.

 Ad.2
 Indeks rzadki - przykładem indeksu rzadkiego (w którym wskaźniki wskazują na strony) są indeksy zgrupowane.
 Są one założone na kluczu głównym każdej tabeli poza tabelą Order.
 
 Indeks gęsty - przykładem indeksów gęstych są indeksy tabeli Order - są to indeksy niezgrupowane założone na stercie. 
 
 Ad.3
 Indeks kolumnowy jest przydatny do prowadzenia analityki na dużej ilości danych. 
 Indeks taki (niezgrupowany) będzie przydatny na kolumnach służących obliczenia dochodów z transportów:
 tabela OrderElement: kolumny (quantity, shiping cost, discount)
 tabela Product: kolumna (product cost)



*/

-- Create tables section -------------------------------------------------

-- Table Product

CREATE TABLE [Product]
(
 [productId] Varchar(30) NOT NULL,
 [productName] Varchar(30) NOT NULL,
 [productCost] Varchar(30) NOT NULL,
 [subCategoryId] Varchar(30) NULL
)
go

-- Create indexes for table Product

CREATE INDEX [IX_Relationship1] ON [Product] ([subCategoryId])
go

-- Add keys for table Product

ALTER TABLE [Product] ADD CONSTRAINT [productId] PRIMARY KEY ([productId])
go

-- Table SubCategory

CREATE TABLE [SubCategory]
(
 [subCategoryId] Varchar(30) NOT NULL,
 [subCategoryName] Varchar(30) NOT NULL,
 [categoryId] Varchar(30) NOT NULL
)
go

-- Create indexes for table SubCategory

CREATE INDEX [IX_Category might have many sub-categories] ON [SubCategory] ([categoryId])
go

-- Add keys for table SubCategory

ALTER TABLE [SubCategory] ADD CONSTRAINT [subCategoryId] PRIMARY KEY ([subCategoryId])
go

-- Table Adres

CREATE TABLE [Adres]
(
 [addressId] Varchar(30) NOT NULL,
 [postalCode] Varchar(30) NULL,
 [countryId] Varchar(30) NULL,
 [marketId] Varchar(30) NULL,
 [statetId] Varchar(30) NULL,
 [cityId] Varchar(30) NULL
)
go

-- Create indexes for table Adres

CREATE INDEX [IX_Relationship2] ON [Adres] ([countryId])
go

CREATE INDEX [IX_Relationship3] ON [Adres] ([marketId])
go

CREATE INDEX [IX_Relationship4] ON [Adres] ([statetId])
go

CREATE INDEX [IX_Relationship5] ON [Adres] ([cityId])
go

-- Add keys for table Adres

ALTER TABLE [Adres] ADD CONSTRAINT [addresId] PRIMARY KEY ([addressId])
go

-- Table OrderElement

CREATE TABLE [OrderElement]
(
 [orderElementId] Varchar(30) NOT NULL UNIQUE,
 [quantity] Int NOT NULL CONSTRAINT quantity_ck CHECK(quantity>0),
 [shippingCost] Money NOT NULL CONSTRAINT shippingCost_ck CHECK(shippingCost>=0),
 [discount] Float NOT NULL,
 [productId] Varchar(30) NOT NULL,
 [orderId] Varchar(30) NOT NULL
)
go

-- Create indexes for table OrderElement

CREATE INDEX [IX_OrderElement has one product] ON [OrderElement] ([productId])
go

CREATE INDEX [IX_Order might have many OrderElements] ON [OrderElement] ([orderId])
go

-- Add keys for table OrderElement

ALTER TABLE [OrderElement] ADD CONSTRAINT [orderElementId] PRIMARY KEY ([orderElementId])
go

-- Table Category

CREATE TABLE [Category]
(
 [categoryId] Varchar(30) NOT NULL,
 [categoryName] Varchar(30) NOT NULL
)
go

-- Add keys for table Category

ALTER TABLE [Category] ADD CONSTRAINT [categoryId] PRIMARY KEY ([categoryId])
go

-- Table Consumer

CREATE TABLE [Consumer]
(
 [consumerId] Varchar(30) NOT NULL,
 [customerName] Varchar(30) NOT NULL,
 [customerSegment] Varchar(30) NOT NULL,
 [addressId] Varchar(30) NOT NULL
)
go

-- Create indexes for table Consumer

CREATE INDEX [IX_Address assigned to many consumers] ON [Consumer] ([addressId])
go

-- Add keys for table Consumer

ALTER TABLE [Consumer] ADD CONSTRAINT [customerId] PRIMARY KEY ([consumerId])
go

-- Table Order

CREATE TABLE [Order]
(
 [orderId] Varchar(30) NOT NULL,
 [orderDate] Date NOT NULL,
 [shipDate] Date NOT NULL,
 [shipMode] Varchar(30) NOT NULL,
 [consumerId] Varchar(30) NOT NULL
)
go


-- Create indexes for table Order

CREATE INDEX [orderDate_index] ON [Order] ([orderDate])
go

CREATE INDEX [shipDate_index] ON [Order] ([shipDate])
go

CREATE INDEX [IX_Consumer might have many orders] ON [Order] ([consumerId])
go

-- Add keys for table Order

ALTER TABLE [Order] ADD CONSTRAINT [orderId] PRIMARY KEY ([orderId])
go

-- Table Country

CREATE TABLE [Country]
(
 [countryId] Varchar(30) NOT NULL,
 [countryName] Varchar(30) NOT NULL
)
go

-- Add keys for table Country

ALTER TABLE [Country] ADD CONSTRAINT [PK_Country] PRIMARY KEY ([countryId])
go

-- Table Market

CREATE TABLE [Market]
(
 [marketId] Varchar(30) NOT NULL,
 [marketName] Varchar(30) NOT NULL
)
go

-- Add keys for table Market

ALTER TABLE [Market] ADD CONSTRAINT [PK_Market] PRIMARY KEY ([marketId])
go

-- Table State

CREATE TABLE [State]
(
 [statetId] Varchar(30) NOT NULL,
 [stateName] Varchar(30) NOT NULL
)
go

-- Add keys for table State

ALTER TABLE [State] ADD CONSTRAINT [PK_State] PRIMARY KEY ([statetId])
go

-- Table City

CREATE TABLE [City]
(
 [cityId] Varchar(30) NOT NULL,
 [cityName] Varchar(30) NOT NULL
)
go

-- Add keys for table City

ALTER TABLE [City] ADD CONSTRAINT [PK_City] PRIMARY KEY ([cityId])
go

-- Create foreign keys (relationships) section ------------------------------------------------- 


ALTER TABLE [OrderElement] ADD CONSTRAINT [OrderElement includes one product] FOREIGN KEY ([productId]) REFERENCES [Product] ([productId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [OrderElement] ADD CONSTRAINT [Order might include many OrderElements] FOREIGN KEY ([orderId]) REFERENCES [Order] ([orderId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [SubCategory] ADD CONSTRAINT [Category might have many sub-categories] FOREIGN KEY ([categoryId]) REFERENCES [Category] ([categoryId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Order] ADD CONSTRAINT [Consumer order many times] FOREIGN KEY ([consumerId]) REFERENCES [Consumer] ([consumerId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Consumer] ADD CONSTRAINT [Address assigned to many consumers] FOREIGN KEY ([addressId]) REFERENCES [Adres] ([addressId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Product] ADD CONSTRAINT [Product have one sub category] FOREIGN KEY ([subCategoryId]) REFERENCES [SubCategory] ([subCategoryId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Adres] ADD CONSTRAINT [Relationship2] FOREIGN KEY ([countryId]) REFERENCES [Country] ([countryId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Adres] ADD CONSTRAINT [Relationship3] FOREIGN KEY ([marketId]) REFERENCES [Market] ([marketId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Adres] ADD CONSTRAINT [Relationship4] FOREIGN KEY ([statetId]) REFERENCES [State] ([statetId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Adres] ADD CONSTRAINT [Relationship5] FOREIGN KEY ([cityId]) REFERENCES [City] ([cityId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go


-- Zadanie 03
-- Podpunkt 2
---- Tworzenie indeksu gęstego
--przygotowanie sterty (usuniecie indeksu zgrupowanego)

alter table dbo.[OrderElement] drop constraint [OrderElement includes one product]
go
drop index [IX_Order might have many OrderElements] on dbo.[OrderElement]
go
alter table dbo.[OrderElement] drop constraint [Order might include many OrderElements]
go



-- Stwórz indeks gęsty
alter table dbo.[Order] drop constraint orderId
go
ALTER TABLE dbo.[Order] ADD CONSTRAINT PK_Order PRIMARY KEY NONCLUSTERED (orderId)
go

-- re-przygotowanie

ALTER TABLE dbo.[OrderElement] ALTER COLUMN orderId varchar(30) NOT NULL
go
ALTER TABLE [OrderElement] ADD CONSTRAINT [Order might include many OrderElements] FOREIGN KEY ([orderId]) REFERENCES [Order] ([orderId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go
CREATE INDEX [IX_Order might have many OrderElements] ON [OrderElement] ([orderId])
go
ALTER TABLE [OrderElement] ADD CONSTRAINT [OrderElement includes one product] FOREIGN KEY ([productId]) REFERENCES [Product] ([productId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go

------------------------------

-- Zadanie 03
-- Podpunkt 3 

create NONCLUSTERED COLUMNSTORE INDEX product_NCCI ON dbo.[Product] (productCost)
go
create NONCLUSTERED COLUMNSTORE INDEX orderElement_NCCI ON dbo.[OrderElement] (quantity, shippingCost, discount)
go

-- Zadanie 03
-- Podpunkt 4

CREATE PROCEDURE getOrdersByCountryAndSubcategory   
    @subCategory Varchar(30) ,   
    @country Varchar(30)    
AS   

SELECT o.[orderId]
	  ,o.orderDate
	  ,o.shipDate
	  ,p.productName
	  ,p.productCost
	  ,e.quantity
	  ,e.discount
	  ,e.shippingCost
	  ,ct.countryName
  FROM [dbo].[OrderElement] AS e
  INNER JOIN [Order] AS o ON e.orderId=o.orderId
  INNER JOIN [Product] AS p ON e.productId=p.productId
  INNER JOIN [SubCategory] AS s ON p.subCategoryId=s.subCategoryId
  INNER JOIN [Consumer] AS c ON o.consumerId=c.consumerId
  INNER JOIN [Adres] AS a ON c.addressId=a.addressId
  INNER JOIN [Country] AS ct ON a.countryId=ct.countryId
  
  WHERE ct.countryName=@country AND s.subCategoryName=@subCategory
GO


-- Zadanie 03
-- Podpunkt 5

CREATE PROCEDURE getLastTwoOrderOfClient AS
SELECT * from (
SELECT o.[orderId] as IDOrder
	  ,o.orderDate as DateOrded
	  ,p.productName as ProductName
	  ,p.productCost as Sales
	  ,c.customerName as CustomerName
	  ,c.customerSegment as CustomerSegment
	  ,ROW_NUMBER() OVER(PARTITION BY c.customerName ORDER BY o.orderDate desc) AS nsr
  FROM [dbo].[OrderElement] AS e
  INNER JOIN [Order] AS o ON e.orderId=o.orderId
  INNER JOIN [Product] AS p ON e.productId=p.productId
  INNER JOIN [Consumer] AS c ON o.consumerId=c.consumerId
  WHERE c.customerSegment = 'Consumer'
) AS a
WHERE nsr=1 OR nsr=2

EXECUTE getLastTwoOrderOfClient