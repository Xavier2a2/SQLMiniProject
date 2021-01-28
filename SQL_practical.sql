SELECT c.CustomerID, c.CompanyName AS "Name",
 c.Address, c.City, c.Region, c.PostalCode, c.Country 
 FROM Customers c;

-- ----------------------------------

SELECT p.ProductName FROM Products p WHERE p.QuantityPerUnit LIKE '%bottles%'

-- -----------------------------------

SELECT p.ProductName, s.CompanyName, s.Country FROM Products p 
INNER JOIN Suppliers s ON s.SupplierID = p.SupplierID WHERE p.QuantityPerUnit LIKE '%bottles%'

-- ------------------------------------
-- Write an sql statement that shows how many products there are in each category. Include Category 
-- name and Highest number first

SELECT c.CategoryID, c.CategoryName, COUNT(*) AS "Amount in Category" FROM Products p 
LEFT JOIN Categories c ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName  ORDER BY "Amount in Category" DESC

-- --------------------------------------
-- Lst all UK employees using concatenation to join their name and title of courtesy. Include city of resisdence

SELECT e.TitleOfCourtesy + ' ' + e.FirstName + ' ' + e.LastName AS "Name",
 e.City FROM Employees e WHERE e.Country = 'UK'

-- ---------------------------------------
-- List sales totals for all sales regions (via the territories table using 4 joins) with a sales 
-- total greater than 1,000,000. Use rounding or FORMAT to present the numbers

SELECT r.RegionID, r.RegionDescription, SUM(od.UnitPrice * od.Quantity * (1-od.Discount)) AS "Total Sales"
 FROM Region r
INNER JOIN Territories t ON t.RegionID = r.RegionID
INNER JOIN EmployeeTerritories e ON t.TerritoryID = e.TerritoryID
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY r.RegionID, r.RegionDescription HAVING SUM(od.UnitPrice * od.Quantity * (1-od.Discount)) > 1000000
ORDER BY "Total Sales"


-- -------------------------------------------------------------
-- Count how many orders have a freight amount greater than 100 and either a UK or US as Ship Country

SELECT COUNT(DISTINCT sq1.OrderID) AS "Orders with Freight Over 100" FROM [Order Details] od
INNER JOIN
(SELECT OrderID, SUM(Freight) AS "Freight" FROM Orders o WHERE "Freight" > 100.00 AND ShipCountry IN ('UK', 'USA')
GROUP BY OrderID) sq1 ON od.OrderID = sq1.OrderID


-- ---------------------------------------------------------------
-- Write an SQL statement to identify the order number with the highest value amount of discount applied to that order

SELECT TOP 1 OrderID, 
SUM(od.UnitPrice * od.Quantity * od.Discount) AS "Total Discount" 
FROM [Order Details] od
GROUP BY OrderID
ORDER BY "Total Discount" DESC


---------------------------------------------------------------------
---------------------------------------------------------------------
CREATE DATABASE aaron_db
USE aaron_db

CREATE TABLE spartan_table (
    SpartanID INTEGER IDENTITY(1,1) PRIMARY KEY,
    Title VARCHAR(4),
    FirstName VARCHAR(15),
    LastName VARCHAR(15),
    UniAttended VARCHAR(100),
    Course VARCHAR(100),
    Mark DECIMAL(2,1)
)

INSERT INTO spartan_table (Title, FirstName, LastName, UniAttended, Course, Mark)
VALUES(
    ('Mr.' , 'Aaron', 'Banjoko', 'Uni of Sheffield', 'Electronic Engineering', 2.1),
    ('Mr.', 'Benjamin', 'Burns', 'Uni of Kent', 'Architecture', 1.0),
    ('Mr.', 'Mark', 'Smith', 'Uni of Bristol', 'Psychology', 2.1),
    ('Mrs.', 'Harriet', 'Tubman', 'Uni of Bath', 'History', 1.0),
    ('Ms.', 'Annabelle', 'Diary', 'Uni of Leeds', 'History', 2.2)
) 

DROP TABLE spartan_table 
-- 2.1


---------------------------------------------------------------------
---------------------------------------------------------------------

-- 3.1 List all employees from the employees table and who they report to 
SELECT e.EmployeeID, e.FirstName, e.LastName, e.ReportsTo, ee.FirstName +' ' + ee.LastName AS "Name of Supervisor" FROM Employees e
INNER JOIN Employees ee ON ee.EmployeeID = e.ReportsTo

-- 3.2 List all suppliers with sales over $10,000 in the order details table. Include company name from the suppliers table and present as a bar chart
SELECT s.CompanyName, SUM(od.UnitPrice * od.Quantity *(1-od.Discount)) AS "Total sales" FROM Suppliers s
INNER JOIN Products p ON p.SupplierID = s.SupplierID
INNER JOIN [Order Details] od ON od.ProductID = p.ProductID
GROUP BY  s.CompanyName HAVING SUM(od.UnitPrice * od.Quantity* (1-od.Discount)) > 10000
ORDER BY "Total Sales" DESC

-- 3.3 lIST THE top 10 customers Year to Date based on total value of orders shipped
-- Essentially rank the top 10 in the year 1998

SELECT TOP 10 c.CustomerID, FORMAT(SUM(od.UnitPrice * od.Quantity * (1-od.Discount)), 'C') AS "Total"
FROM Customers c
INNER JOIN 
    Orders o 
    ON o.CustomerID = c.CustomerID
INNER JOIN 
    [Order Details] od 
    ON od.OrderID = o.OrderID
WHERE 
    YEAR(o.OrderDate) = (SELECT MAX(YEAR(OrderDate)) AS max_year FROM Orders ) 
GROUP BY c.CustomerID
ORDER BY SUM(od.UnitPrice * od.Quantity * (1-od.Discount)) DESC


-- 3.4


SELECT MONTH(OrderDate) AS "Order Month", YEAR(OrderDate) AS "Order Year", 
AVG(CONVERT(DEC(8,2), DATEDIFF(d, OrderDate, ShippedDate)))
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY "Order Year", "Order Month"
