-- -- * means to select all columns
-- SELECT * FROM Customers

-- -- We can better define what we are looking for using WHERE
-- SELECT * FROM Customers c
--     WHERE c.City = 'Paris'
-- -- WHERE is used to filter the data 
-- City if the column, the = symbol is the operator, 'Paris' is the operator

-- Using COUNT(*) counts the number of the instances you defined 
-- Using AS "... " lets you name the table you defined, the name and table are temporary

SELECT COUNT(*) AS "London Employee Count" FROM Employees e WHERE e.City = 'London';
SELECT * FROM Employees e WHERE e.TitleOfCourtesy = 'Dr.';
SELECT COUNT(*) AS "Discontinued ProductCount" FROM Products p WHERE p.Discontinued = 1;

-- Data types that need apostrophes to search = BINARY, CHAR, VARCHAR, DATE, DATETIME
-- All other data types dont need quotes
-- An apostrophe is a reversed character, to use it in a quote is needs to be like this:
-- 'Simon''s way'

-- SELECT TOP will allow you to run test queries against very large tables without hitting performance issues

SELECT TOP 10 CompanyName, City FROM Customers WHERE Country = 'France'

SELECT ProductName, UnitPrice FROM Products WHERE CategoryID = 1 AND Discontinued = '0'

SELECT ProductName, UnitPrice FROM Products WHERE UnitsInStock > 0 AND UnitPrice > 29.99

-- DISTINCT removes duplicates from your data
SELECT DISTINCT Country FROM Customers WHERE ContactTitle = 'Owner'
SELECT COUNT(DISTINCT Country) FROM Customers WHERE ContactTitle = 'Owner'

-- Wildcards can be used as a substitute for any other characters in a string when using the LIKE operator
-- Starting with S
SELECT p.ProductName FROM Products p WHERE p.ProductName LIKE 'S%'
-- Ending with S
SELECT p.ProductName FROM Products p WHERE p.ProductName LIKE '%S'
-- Any starting with these letters
SELECT p.ProductName FROM Products p WHERE p.ProductName LIKE '[AS]%'
-- Any not starting with these letters
SELECT p.ProductName FROM Products p WHERE p.ProductName LIKE '[^ARPS]%'
-- Second letter is S
SELECT p.ProductName FROM Products p WHERE p.ProductName LIKE '_S%'


-- Is we needed to find customers in two specific named regions
-- IN specifies what values in that column to look for 
SELECT * FROM Customers WHERE Region IN ('WA', 'SP')

-- Between takes range from the boundary ranges
SELECT * FROM EmployeeTerritories WHERE TerritoryID BETWEEN 06800 AND 09999

-- QUESTIONS
SELECT p.ProductID, p.ProductName FROM Products p WHERE p.UnitPrice < 5.00
SELECT c.CategoryName FROM Categories c WHERE c.CategoryName LIKE '[BS]%'
SELECT COUNT(*) AS 'Number of Orders From Employees 5 and 7' FROM Orders WHERE EmployeeID IN (5,7)

--  Concatenate using + along with single quotes
-- Alias(rename) columns using AS and double quotes (If more than one word) to change column headerss
SELECT c.CompanyName AS "Company Name", c.City + ', ' + c.Country AS 'City' FROM Customers c

-- QUESTION
SELECT e.FirstName + ' ' + e.LastName AS 'Employee Name' FROM Employees e

SELECT * FROM Customers
SELECT DISTINCT c.Country FROM Customers c WHERE c.Region IS NOT NULL

SELECT TOP 2 o.OrderID, o.UnitPrice, o.Quantity, o.Discount, o.UnitPrice * o.Quantity AS 'Gross Total', 
o.UnitPrice * (1-o.Discount) * o.Quantity AS 'Net Total' FROM [Order Details] o ORDER BY 'Net Total' DESC;

SELECT PostalCode AS "Post Code", LEFT(PostalCode, CHARINDEX(' ',PostalCode) - 1) AS "Post Code Region", CHARINDEX(' ', PostalCode) AS 'Space Found',
Country FROM Customers WHERE Country = 'UK'

SELECT PostalCode FROM Customers WHERE Country = 'UK'

SELECT p.ProductName AS "Product Name" FROM Products p WHERE p.ProductName LIKE '%''%'
SELECT p.ProductName AS "Product Name" FROM Products p WHERE CHARINDEX('''', p.ProductName)!=0

SELECT DATEADD(d, 5, OrderDate) AS "Due Date", DATEDIFF(d, OrderDate, ShippedDate) AS "Ship Days" FROM Orders

SELECT e.FirstName + ' ' + e.LastName AS 'Name', DATEDIFF(YYYY, e.BirthDate, GETDATE()) AS 'Age' FROM Employees e


-- CASE statements can be useful when you need varying results output based on differing data
-- Pay close attention to WHEN THEN ELSE and END 
-- Use single quotes for data and double quotes for column aliases
SELECT TOP 100 CASE 
WHEN DATEDIFF(d, o.OrderDate, o.ShippedDate) < 10 THEN 'On Time'
ELSE 'Overdue'
-- Status gets double quotes as it is a column name
END AS 'Status'
FROM Orders o;

SELECT e.FirstName + ' ' + e.LastName AS 'Name', CASE  
WHEN DATEDIFF(YYYY, e.BirthDate, GETDATE()) > 65 THEN 'Retired'
WHEN DATEDIFF(YYYY, e.BirthDate, GETDATE()) > 60 THEN 'Retirement Due'
ELSE  'More than 5 years to go' 
END AS "Retirement Status" FROM Employees e;

SELECT SUM(p.UnitsOnOrder) AS "Total On Order", 
AVG(p.UnitsOnOrder) AS "Avg On Order",
MIN(p.UnitsOnOrder) AS "Min On Order",
MAX(p.UnitsOnOrder) AS "Max On Order"
FROM Products p GROUP BY SupplierID HAVING AVG(UnitsOnOrder) > 5

SELECT SUM(p.UnitsOnOrder) AS "Total On Order", 
AVG(p.UnitsOnOrder) AS "Avg On Order",
MIN(p.UnitsOnOrder) AS "Min On Order",
MAX(p.UnitsOnOrder) AS "Max On Order"
FROM Products p GROUP BY SupplierID


SELECT p.CategoryID AS "Category ID",  AVG(p.ReorderLevel) AS "Reorder Level" FROM Products p GROUP BY p.CategoryID ORDER BY "Reorder Level" DESC 

SELECT * FROM Customers 

SELECT * FROM student s FULL JOIN course c ON s.course_id = c.c_id

SELECT s.CompanyName, AVG(p.UnitsOnOrder) AS "Average Units On Order" FROM Products p 
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
GROUP BY s.CompanyName

SELECT s.CompanyName, AVG(p.UnitsOnOrder) AS "Units On Order" FROM Products p 
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
GROUP BY p.SupplierID, s.CompanyName

SELECT ProductName, UnitPrice, CompanyName AS "Supplier", CategoryName AS "Category"
FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
INNER JOIN Categories c ON p.CategoryID = c.CategoryID

SELECT * FROM Orders

SELECT o.OrderID, o.OrderDate, o.Freight,
e.FirstName + ' ' + e.LastName AS "Employee Name" ,  
o.EmployeeID , c.CompanyName AS "Customer Name",
o.CustomerID
FROM Orders o 
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID

SELECT CompanyName AS "Customer"
FROM Customers
WHERE CustomerID NOT IN 
(SELECT CustomerID FROM Orders)

SELECT c.CompanyName AS "Customer", c.CustomerID, o.CustomerID
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID WHERE o.OrderID IS NULL

SELECT OrderId, ProductID, UnitPrice, Quantity, Discount,
(SELECT MAX(UnitPrice) FROM [Order Details]) AS "Max Price"
FROM [Order Details] 

SELECT od.ProductID, sq1.totalamt AS "Total Sold For This Product", 
od.UnitPrice, od.UnitPrice/totalamt*100 AS "% of Total"
 FROM [Order Details] od
 INNER JOIN
    (SELECT od.ProductID, SUM(OD.UnitPrice*od.Quantity) 
    AS totalamt FROM [Order Details] od GROUP BY od.ProductID)
     sq1 ON sq1.ProductID = od.ProductID


SELECT od.OrderID, od.ProductID, od.UnitPrice, od.Quantity, od.Discount FROM [Order Details] od 
INNER JOIN Products p ON p.ProductID = od.ProductID WHERE p.Discontinued = 1  

SELECT od.OrderID, od.ProductID, od.UnitPrice, od.Quantity, od.Discount FROM [Order Details] od 
WHERE od.ProductID IN 
(SELECT p.ProductID FROM Products p WHERE p.Discontinued = 1)