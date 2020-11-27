USE Northwind
-- 1.1 --
SELECT c.CustomerID, c.CompanyName, c.Address, c.City, c.Country
FROM Customers c
WHERE c.City='Paris' OR c.City='London'

-- 1.2 --
SELECT p.ProductName 
FROM Products p
WHERE p.QuantityPerUnit LIKE '%bottles%'


-- 1.3 --
SELECT s.CompanyName, s.Country, p.ProductName, p.QuantityPerUnit
FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE p.QuantityPerUnit LIKE '%bottles%'

-- 1.4 -- 
SELECT c.CategoryName, COUNT(*) AS "Number of Products"
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName, p.CategoryID
ORDER BY "Number of Products" DESC

-- 1.5 --
SELECT CONCAT(e.TitleOfCourtesy, ' ', e.FirstName, ' ', e.LastName) AS "Full Name", e.City
FROM Employees e
WHERE e.Country='UK'

-- 1.6 --
SELECT FORMAT(SUM(od.UnitPrice * od.Quantity * (1-od.Discount)), '#,#') AS "Sum Total", 
        r.RegionDescription AS "Region Description"
FROM Region r
INNER JOIN Territories t ON r.RegionID = t.RegionID 
INNER JOIN EmployeeTerritories et ON t.TerritoryID = et.TerritoryID
INNER JOIN Employees e ON et.EmployeeID = e.EmployeeID
INNER JOIN Orders o ON et.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY r.RegionDescription
HAVING SUM(od.UnitPrice * od.Quantity * (1-od.Discount)) > 1000000

-- 1.7 -- 

SELECT COUNT(o.Freight) AS "Number of Order where Freight > 100 in UK or USA"
FROM Orders o
WHERE o.Freight>100 AND (o.ShipCountry='USA' OR o.ShipCountry='UK')

-- 1.8 --

SELECT TOP 1 od.OrderID, (od.UnitPrice*od.Quantity) - od.UnitPrice*od.Quantity*(1-od.Discount) AS "Discount Applied"
FROM [Order Details] od
ORDER BY "Discount Applied" DESC


-- 2.1 -- 

CREATE TABLE spartan_details
(
   spartan_id INT IDENTITY(1,1) PRIMARY KEY,
   seperate_title VARCHAR(6),
   first_name VARCHAR(20),
   last_name VARCHAR(20),
   university VARCHAR(30),
   course VARCHAR(30),
   grade VARCHAR(6),
)

-- 2.2 -- 

INSERT INTO spartan_details 
VALUES ('mr','ismail','kadir','oxford', 'computer systems engineering', '2:1'),
('miss','rashawn','henry','kings', 'philosophy', '2:2')


-- 3.1 --
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS "Employee Name", 
    CONCAT(em.FirstName, ' ',em.LastName) AS "Reports To"
FROM Employees e
LEFT JOIN Employees em ON e.ReportsTo = em.EmployeeID

-- 3.2 --
SELECT s.CompanyName, 
    SUM(od.Quantity*od.UnitPrice*(1-od.Discount)) AS "Supplier Total"
FROM Suppliers s
INNER JOIN Products p ON s.SupplierID = p.SupplierID 
INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY s.CompanyName 
HAVING SUM(od.Quantity*od.UnitPrice*(1-od.Discount)) >10000
ORDER BY "Supplier Total" DESC

-- 3.3 -- List the Top 10 Customers YTD for the latest year in the Orders file. Based on total value of orders shipped. 

SELECT TOP 10 c.CompanyName, ROUND(SUM(od.Quantity*od.UnitPrice*(1-od.Discount)),2) AS "sales"
FROM [Order Details] od
INNER JOIN Orders o ON o.OrderID = od.OrderID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CompanyName, o.ShippedDate
HAVING o.ShippedDate > '1997-12-31'
ORDER BY 2 DESC

-- 3.4 --
-- 3.4 Plot the Average Ship Time by month for all data in the Orders Table 
SELECT  FORMAT(o.OrderDate, 'MMM-yy') AS "Year-Month"
        , AVG(CAST(DATEDIFF(d, o.OrderDate, o.ShippedDate) AS Decimal(4,2))) AS "Average Number of Ship Days" -- Might need to format here as not sure if getting the correct answer with rounding
FROM Orders o
GROUP BY FORMAT(o.OrderDate, 'MMM-yy')
ORDER BY 1


-- 3.4 Plot the Average Ship Time by month for all data in the Orders Table 

SELECT MONTH(o.OrderDate) AS "Month", 
        YEAR(o.OrderDate) AS "Year", 
    AVG(CAST(DATEDIFF(d,o.OrderDate,o.ShippedDate)AS decimal(4,2))) AS "Average Ship Time in Days"
FROM Orders o
GROUP BY MONTH(o.OrderDate), YEAR(o.OrderDate)
ORDER BY 2
