/*
Let's consider a simple example of a retail business that tracks sales.

Fact Table: Sales
This table stores information about each sales transaction.
Here, the Sales table is the fact table and contains quantitative data such as QuantitySold and SalesAmount.
*/
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    CustomerID INT,
    StoreID INT,
    DateID INT,
    QuantitySold INT,
    SalesAmount DECIMAL(10,2)
);
/*
Dimension Table: Products
This table stores information about the products, Customers, Stores, Dates
*/
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(50),
    ProductCategory NVARCHAR(50)
);
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName NVARCHAR(50),
    CustomerEmail NVARCHAR(50),
    CustomerPhone NVARCHAR(15)
);
CREATE TABLE Stores (
    StoreID INT PRIMARY KEY,
    StoreName NVARCHAR(50),
    StoreLocation NVARCHAR(50)
);
CREATE TABLE Dates (
    DateID INT PRIMARY KEY,
    Date DATE,
    DayOfWeek NVARCHAR(15),
    Month NVARCHAR(15),
    Quarter NVARCHAR(15),
    Year INT
);

INSERT INTO Products (ProductID, ProductName, ProductCategory) VALUES
(1, 'Laptop', 'Electronics'),
(2, 'Smartphone', 'Electronics'),
(3, 'Desk Chair', 'Furniture');

INSERT INTO Customers (CustomerID, CustomerName, CustomerEmail, CustomerPhone) VALUES
(1, 'Alice Smith', 'alice.smith@example.com', '123-456-7890'),
(2, 'Bob Johnson', 'bob.johnson@example.com', '098-765-4321'),
(3, 'Charlie Brown', 'charlie.brown@example.com', '555-123-4567');

INSERT INTO Stores (StoreID, StoreName, StoreLocation) VALUES
(1, 'Downtown Store', 'Downtown'),
(2, 'Mall Store', 'Shopping Mall'),
(3, 'Suburban Store', 'Suburbs');

INSERT INTO Dates (DateID, Date, DayOfWeek, Month, Quarter, Year) VALUES
(1, '2023-01-01', 'Sunday', 'January', 'Q1', 2023),
(2, '2023-02-15', 'Wednesday', 'February', 'Q1', 2023),
(3, '2023-03-20', 'Monday', 'March', 'Q1', 2023);

INSERT INTO Sales (SaleID, ProductID, CustomerID, StoreID, DateID, QuantitySold, SalesAmount) VALUES
(1, 1, 1, 1, 1, 2, 2000.00),
(2, 2, 2, 2, 2, 1, 1000.00),
(3, 3, 3, 3, 3, 4, 400.00);


select * from sales;
select * from products;
select * from Customers;
select * from Stores;
select * from Dates;




--Query to retrieve the data
--This query will give you the total sales amount for each product category, 
--utilizing the relationships between the fact and dimension tables.
SELECT 
    p.ProductCategory,
    SUM(s.SalesAmount) AS TotalSales
FROM 
    Sales s
JOIN 
    Products p ON s.ProductID = p.ProductID
GROUP BY 
    p.ProductCategory;


