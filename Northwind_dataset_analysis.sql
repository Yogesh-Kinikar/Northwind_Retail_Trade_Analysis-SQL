
-- Creating a new table "Total_Sales" that contains detailed sales information by joining Order_Details, Orders, and Customers tables.

CREATE TABLE Total_Sales AS
select D.OrderID, C.CustomerID, C.CompanyName, C.ContactName, C.ContactTitle, D.ProductID, D.UnitPrice, D.Quantity, (D.UnitPrice*D.Quantity*(1-D.Discount)) AS Total_Sales
FROM Order_Details D
LEFT JOIN Orders O
ON D.OrderID = O.OrderID
LEFT JOIN Customers C
ON O.CustomerID = C.CustomerID
order by Total_Sales DESC


-- Joining the Products table to the Total_Sales table to include product names in the final output.

CREATE TABLE TOTAL_SALES_BY_PRODUCTS AS
SELECT T.OrderID, T.CustomerID, T.CompanyName, T.ContactName, T.ProductID,P.ProductName, T.UnitPrice, T.Quantity, T.Total_Sales
FROM Total_Sales T
LEFT JOIN Products P
ON T.ProductID = P.ProductID


-- Calculating the total revenue from the Order_Details table.

select round(Sum(unitprice * quantity *(1-discount)),2) AS Total_Revenue
from Order_Details


-- Querying the top 10 products by total sales amount from the TOTAL_SALES_BY_PRODUCTS table.

SELECT productid, productname, SUM(ROUND(total_sales,2)) AS Total_Sales
FROM TOTAL_SALES_BY_PRODUCTS
GROUP BY productid, productname
order by Total_Sales DESC
LIMIT 10


-- Calculating annual revenue from the Orders and Order Details tables.

SELECT 
    CAST(strftime('%Y', O.OrderDate) AS INTEGER) AS SalesYear,
    ROUND(SUM(D.UnitPrice * D.Quantity * (1 - COALESCE(D.Discount, 0))), 2) AS Revenue
FROM Orders O
JOIN Order_Details D ON D.OrderID = O.OrderID
GROUP BY SalesYear
ORDER BY SalesYear


-- Querying the top 10 products by total quantity sold from the TOTAL_SALES_BY_PRODUCTS table.

SELECT productid, productname, Sum(quantity) AS Total_Quantity
FROM TOTAL_SALES_BY_PRODUCTS
GROUP BY productid, productname
ORDER BY Total_Quantity DESC
LIMIT 10


-- Calculating total sales by category by joining Order_Details, Products, and Categories tables.

SELECT C.CategoryID, C.CategoryName, ROUND(SUM(D.UnitPrice*D.Quantity*(1-D.Discount)),2) AS Total_Sales
FROM ORDER_DETAILS D
LEFT JOIN Products P 
ON D.ProductID = P.ProductID
LEFT JOIN Categories C
ON C.CategoryID = P.CategoryID
group by c.CategoryID, c.CategoryName
Order by Total_Sales DESC


-- Calculating customer sales metrics including total sales, order counts, and average order value.

SELECT 
	C.CustomerID, C.ContactName, C.CompanyName,
    ROUND(SUM(D.UnitPrice*D.Quantity*(1-D.Discount)),2) AS TOTAL_SALES,
    COUNT(DISTINCT O.OrderID) AS ORDER_COUNTS,
    ROUND(SUM(D.UnitPrice*D.Quantity*(1-D.Discount)) / NULLIF(COUNT(DISTINCT O.OrderID),0),
    2) AS AVERAGE_ORDER_VALUE
from Customers C
LEFT JOIN Orders O
ON C.CustomerID= O.CustomerID
LEFT JOIN Order_Details D
ON O.OrderID = D.OrderID
GROUP BY C.CustomerID, C.ContactName, C.CompanyName
ORDER BY TOTAL_SALES DESC
LIMIT 10


-- Calculating monthly revenue from the Orders and Order Details tables.

SELECT
  CAST(strftime('%Y', O.OrderDate) AS INTEGER) AS SalesYear,
  CAST(strftime('%m', O.OrderDate) AS INTEGER) AS SalesMonth,
  ROUND(SUM(D.UnitPrice * D.Quantity * (1 - COALESCE(D.Discount, 0))), 2) AS Revenue
FROM Orders AS O
JOIN Order_Details AS D ON D.OrderID = O.OrderID
GROUP BY CAST(strftime('%Y', O.OrderDate) AS INTEGER),
         CAST(strftime('%m', O.OrderDate) AS INTEGER)
ORDER BY SalesYear, SalesMonth


-- Calculating shipping performance metrics by shipper including total orders and average freight per order.

SELECT
  S.ShipperID,
  S.CompanyName AS Shipper,
  COUNT(*) AS Orders,
  ROUND(AVG(O.Freight), 2) AS AvgFreightPerOrder
FROM Orders O
JOIN Shippers S ON S.ShipperID = O.ShipVia
GROUP BY S.ShipperID, S.CompanyName
ORDER BY Orders DESC