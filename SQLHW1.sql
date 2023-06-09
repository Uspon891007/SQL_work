--1
SELECT 
*
FROM Products 
WHERE CategoryID = (SELECT TOP 1 CategoryID FROM Products ORDER BY UnitPrice DESC)
--2
SELECT 
TOP 1 *
FROM Products 
WHERE CategoryID = (SELECT TOP 1 CategoryID FROM Products ORDER BY UnitPrice DESC)
ORDER BY UnitPrice
--3
SELECT 
MAX(UnitPrice)-MIN(UnitPrice) AS different
FROM Products 
WHERE CategoryID = (SELECT TOP 1 CategoryID FROM Products ORDER BY UnitPrice DESC)
--4
SELECT 
    CustomerID,
    City 
FROM Customers 
WHERE City IN (SELECT City FROM  Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID WHERE o.OrderID IS NULL)
--5
SELECT
CategoryID,CategoryName
FROM Categories
WHERE CategoryID IN
(
(
	SELECT CategoryID
	FROM Products
	ORDER BY UnitPrice DESC
	OFFSET 4 ROWS
	FETCH NEXT 1 ROWS ONLY
),
(
	SELECT CategoryID
	FROM Products
	ORDER BY UnitPrice
	OFFSET 7 ROWS
	FETCH NEXT 1 ROWS ONLY
)
)
--6
SELECT
c.ContactName,c.CustomerID,p.ProductName
FROM Orders o
JOIN Customers c on o.CustomerID = c.CustomerID
JOIN [Order Details] od on o.OrderID = od.OrderID
JOIN Products p on od.ProductID = p.ProductID
WHERE p.ProductName IN
(
(
	SELECT ProductName
	FROM Products
	ORDER BY UnitPrice DESC
	OFFSET 4 ROWS
	FETCH NEXT 1 ROWS ONLY
),
(
	SELECT ProductName
	FROM Products
	ORDER BY UnitPrice
	OFFSET 7 ROWS
	FETCH NEXT 1 ROWS ONLY
)
) 

--7
SELECT
SupplierID
FROM Products
WHERE SupplierID IN
(
(
	SELECT SupplierID
	FROM Products
	ORDER BY UnitPrice DESC
	OFFSET 4 ROWS
	FETCH NEXT 1 ROWS ONLY
),
(
	SELECT SupplierID
	FROM Products
	ORDER BY UnitPrice
	OFFSET 7 ROWS
	FETCH NEXT 1 ROWS ONLY
)
)

--8
SELECT
*
FROM Orders
WHERE DATEPART(day,OrderDate) = 13
AND DATEPART(weekday,OrderDate) = 6

--9
SELECT
CustomerID
FROM Orders
WHERE DATEPART(day,OrderDate) = 13
AND DATEPART(weekday,OrderDate) = 6

--10
SELECT
p.ProductName
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE DATEPART(day,o.OrderDate) = 13
AND DATEPART(weekday,o.OrderDate) = 6

--11
SELECT
ProductName
FROM Products
WHERE Discontinued ='False'

--12
SELECT DISTINCT
c.CustomerID,c.Country
FROM Customers c
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
INNER JOIN Products p ON p.ProductID = od.ProductID
INNER JOIN Suppliers s ON s.SupplierID = p.SupplierID
WHERE o.ShipCountry <> s.Country

--13
SELECT
c.CustomerID
FROM Customers c
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
INNER JOIN Employees e ON e.EmployeeID = o.EmployeeID
WHERE c.City = e.City

--14
SELECT
p.ProductID,od.OrderID
FROM Products p
INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
INNER JOIN Orders o ON od.OrderID = o.OrderID 
GROUP BY od.OrderID,p.ProductID
HAVING COUNT(*) = 0

--15
SELECT
*
FROM Orders
WHERE OrderDate = EOMONTH(OrderDate)

--16
SELECT DISTINCT
p.ProductID,p.ProductName
FROM Products p
INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
INNER JOIN Orders o ON od.OrderID = o.OrderID 
WHERE p.ProductID IN (
	SELECT
		p.ProductID
	FROM Orders
	WHERE OrderDate = EOMONTH(OrderDate)
)

--17
Select Distinct Top 3
  c.CustomerID,
  Sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) As SalesAmount
From Customers c
Inner Join Orders o On o.CustomerID = c.CustomerID
Inner Join [Order Details] od On od.OrderID = o.OrderID
WHERE od.ProductID IN (
	SELECT TOP 3
	ProductID
	FROM Products
	ORDER BY UnitPrice DESC
)
Group By c.CustomerID
Order By SalesAmount Desc

--18
Select Distinct Top 3
  c.CustomerID,
  Sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) As SalesAmount
From Customers c
Inner Join Orders o On o.CustomerID = c.CustomerID
Inner Join [Order Details] od On od.OrderID = o.OrderID
Where od.ProductID In (
    Select Top 3
        od.ProductID
    From [Order Details] od
    Group By od.ProductID
    Order By Sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) Desc
)
Group By c.CustomerID
Order By SalesAmount Desc

--19
Select Distinct Top 3
  c.CustomerID,
  Sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) As SalesAmount
From Customers c
Inner Join Orders o On o.CustomerID = c.CustomerID
Inner Join [Order Details] od On od.OrderID = o.OrderID
INNER JOIN Products p ON p.ProductID = od.ProductID
Where p.CategoryID  In (
    Select Top 3
        p.CategoryID
    From [Order Details] od
	INNER JOIN Products p ON p.ProductID = od.ProductID
    Group By p.CategoryID
    Order By Sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) Desc
)
Group By c.CustomerID
Order By SalesAmount Desc

--20
SELECT TOP 1
CustomerID,AVG(UnitPrice)
FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY CustomerID
ORDER BY AVG(UnitPrice) DESC

SELECT
CustomerID,SUM(UnitPrice) AS TotalOfPrice
FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE CustomerID = 'SPECD'
GROUP BY CustomerID

--21
SELECT TOP 1
p.ProductName,COUNT(od.Quantity),SUM(p.UnitPrice*od.Quantity)
FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY COUNT(o.OrderID) DESC

--22
select TOP 1 od.ProductID,p.ProductName,COUNT(OrderID) as total 
from [Order Details] od
INNER JOIN Products p ON p.ProductID = od.ProductID
group by od.ProductID,p.ProductName
order by total

--23
select TOP 1 p.CategoryID,c.CategoryName,COUNT(OrderID) as total 
from [Order Details] od
INNER JOIN Products p ON p.ProductID = od.ProductID
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
group by p.CategoryID,c.CategoryName
order by total

--24

SELECT TOP 1
c.CustomerID,o.EmployeeID,SUM(UnitPrice)
FROM [Order Details] od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE e.FirstName = (
SELECT TOP 1
e.FirstName
FROM [Order Details] od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
GROUP BY e.FirstName
ORDER BY COUNT(od.Quantity) DESC
)
GROUP BY c.CustomerID,o.EmployeeID
ORDER BY SUM(UnitPrice) DESC

--25
SELECT TOP 1
c.CustomerID,SUM(UnitPrice)
FROM [Order Details] od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE e.FirstName = (
SELECT TOP 1
e.FirstName
FROM [Order Details] od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
GROUP BY e.FirstName
ORDER BY COUNT(od.Quantity) DESC
)
GROUP BY c.CustomerID
ORDER BY SUM(UnitPrice) DESC

--26
SELECT
*
FROM Products p
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
LEFT JOIN Orders o ON od.OrderID = o.OrderID
WHERE od.Quantity IS NULL

--27
SELECT
c.CustomerID,SUM(od.UnitPrice) AS Total
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE c.CustomerID IN (
SELECT
CustomerID
FROM Customers
WHERE Fax IS NULL
)
GROUP BY c.CustomerID

--28
SELECT
o.ShipCountry,COUNT(p.CategoryID) AS TotalOfCategory
FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY o.ShipCountry

--29
SELECT
p.ProductName,SUM(od.Quantity) AS Total
FROM Products p
INNER join [Order Details] od on od.ProductID=p.ProductID
WHERE  p.UnitsInStock='0'
GROUP BY p.ProductName

--30
SELECT DISTINCT 
o.CustomerID
FROM Products p
inner join [Order Details] od ON od.ProductID=p.ProductID
inner join Orders o ON o.OrderID=od.OrderID
WHERE p.UnitsInStock='0'

--31
SELECT 
e.ReportsTo,SUM(od.Quantity*od.UnitPrice*(1-od.Discount)) Total
FROM Employees e
INNER JOIN Orders o ON o.EmployeeID = e.EmployeeID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
WHERE e.ReportsTo IS NOT NULL
GROUP BY e.ReportsTo

--32
WITH t1 AS (
    SELECT 
		s.ShipperID, c.CategoryName, SUM(od.Quantity) AS TotalQuantity,
        ROW_NUMBER() OVER (PARTITION BY s.ShipperID ORDER BY SUM(od.Quantity) DESC) AS RowNumber
    FROM [Order Details] od
    INNER JOIN Products p ON p.ProductID = od.ProductID
    INNER JOIN Categories c ON c.CategoryID = p.CategoryID
    INNER JOIN Orders o ON o.OrderID = od.OrderID
    INNER JOIN Shippers s ON s.ShipperID = o.ShipVia
    GROUP BY s.ShipperID, c.CategoryName
)
SELECT ShipperID, CategoryName, TotalQuantity
FROM t1
WHERE RowNumber = 1

--33
WITH t1 AS(
SELECT 
c.CustomerID,p.CategoryID,SUM(od.Quantity) AS Qty,SUM(od.UnitPrice*od.Quantity*(1-od.Discount))AS Price
FROM Customers c
inner join Orders o ON o.CustomerID=c.CustomerID
inner join [Order Details] od ON od.OrderID=o.OrderID
inner join Products p ON p.ProductID=od.ProductID
group by c.CustomerID,p.CategoryID
),
t2 AS(
SELECT *,RANK() OVER(PARTITION BY CustomerID ORDER BY Qty DESC)AS rk
FROM t1)
SELECT CustomerID,CategoryID,price
FROM t2
WHERE rk=1

--34
WITH t1 AS(SELECT o.CustomerID,od.ProductID,SUM(od.Quantity)AS Total
FROM Orders o
inner join [Order Details] od ON od.OrderID=o.OrderID
GROUP BY o.CustomerID,od.ProductID),
t2 AS(
SELECT *,RANK() OVER (PARTITION BY CustomerID ORDER BY Total DESC) AS a
FROM t1)
SELECT CustomerID,ProductID,Total
FROM t2
WHERE a=1

--35
SELECT 
ShipCity, MAX(ShippedDate) recentDate
FROM ORDERS 
WHERE ShipCity IS NOT NULL
GROUP BY ShipCity

--36
WITH t1 AS(
SELECT c.CustomerID, SUM((od.UnitPrice*od.Quantity)*(1-od.Discount)) SumPrice,
	ROW_NUMBER() OVER (
		ORDER BY SUM((od.UnitPrice*od.Quantity)*(1-od.Discount)) DESC
	) AS NoDesc
FROM Customers c
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.CustomerID
)
SELECT t1.CustomerID, t1.SumPrice SumPrice1,  t2.CustomerID, t2.SumPrice SumPrice2, ABS(t1.SumPrice - t2.SumPrice) gap
FROM t1 t1
INNER JOIN t1 t2 ON t1.NoDesc = 5 AND t2.NoDesc = 10
WHERE t1.NoDesc = 5 OR t2.NoDesc = 10;