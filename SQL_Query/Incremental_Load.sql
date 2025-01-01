/*
Tables
1. Product
2. Sales
3. Orders
*/
--Source Tables
--Product_Source
CREATE TABLE Product_Source(
ProductKey int,
PurchaseDate datetime,
Quantity int,
Price float
)

INSERT INTO Product_Source (ProductKey, PurchaseDate, Quantity, Price)
VALUES
(1, '2024-01-10', 50, 20.5),
(2, '2024-02-15', 30, 15.0),
(3, '2024-03-20', 40, 25.75),
(4, '2024-04-05', 60, 30.0),
(5, '2024-05-12', 35, 18.25);

CREATE TABLE Product_Target(
ProductKey int,
PurchaseDate datetime,
Quantity int,
Price float
)

select * from Product_Source;
select * from Product_Target;

--Sales_Source
CREATE TABLE Sales_Source(
ProductKey int,
SalesDate datetime,
SalesAmount float
)
INSERT INTO Sales_Source (ProductKey, SalesDate, SalesAmount)
VALUES
(1, '2024-01-15', 1025.50),
(2, '2024-02-20', 750.30),
(3, '2024-03-25', 1200.75),
(4, '2024-04-10', 900.60),
(5, '2024-05-05', 670.40);

--Sales_Target
CREATE TABLE Sales_Target(
ProductKey int,
SalesDate datetime,
SalesAmount float
)
select * from Sales_Source
select * from Sales_Target

--Orders_Source
CREATE TABLE Orders_Source(
ProductKey int,
OrderDate datetime,
Quantity int
)
INSERT INTO Orders_Source (ProductKey, OrderDate, Quantity)
VALUES
(1, '2024-01-10', 15),
(2, '2024-02-12', 20),
(3, '2024-03-15', 25),
(4, '2024-04-18', 30),
(5, '2024-05-20', 35);


CREATE TABLE Orders_Target(
ProductKey int,
OrderDate datetime,
Quantity int
)
SELECT * FROM Orders_Source;
select * from Orders_Target;


--Watermark table
create table table_watermark(
SourceTableName varchar(100),
TargetTableName varchar(100),
WaterMarkColumn varchar(100),
WaterMarkValue datetime,
SourceQuery varchar(1000),
IsActive int
)


INSERT INTO table_watermark (SourceTableName, TargetTableName, WaterMarkColumn, WaterMarkValue, SourceQuery, IsActive)
VALUES
('Product_Source', 'Product_Target', 'PurchaseDate', '1990-01-01 00:00:00.000', 
 'SELECT * FROM Product_Source WHERE PurchaseDate > 
 (SELECT WaterMarkValue FROM table_watermark WHERE SourceTableName = ''Product_Source'')', 1),

('Sales_Source', 'Sales_Target', 'SalesDate', '1990-01-01 00:00:00.000', 
 'SELECT * FROM Sales_Source WHERE SalesDate > 
 (SELECT WaterMarkValue FROM table_watermark WHERE SourceTableName = ''Sales_Source'')', 1),

('Orders_Source', 'Orders_Target', 'OrderDate', '1990-01-01 00:00:00.000', 
 'SELECT * FROM Orders_Source WHERE OrderDate > 
 (SELECT WaterMarkValue FROM table_watermark WHERE SourceTableName = ''Orders_Source'')', 1);
 
 select * from table_watermark;