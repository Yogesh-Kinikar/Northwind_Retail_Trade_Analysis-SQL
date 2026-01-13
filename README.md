
# 📊 Northwind Retail Sales Analytics (SQL) 

A modular **data analytics** project powered by **SQL** that leverages the classic Northwind Dataset. By structuring queries across 14 relational tables (Orders, Products, Customers), this project creates comprehensive business insights, transforming raw RDBMS data into actionable insights on revenue trends, market performance, and operational efficiency. 

> ⚙️ Tech focus: SQL modeling & transformations

---

## 🧭 Table of Contents
- Overview
- Business Context
- Dataset
  - Data Dictionary
- Tech Stack
- Insights & Visuals
- Appendix: Full SQL Queries
- License
- Contact


---

## ✅ Overview
<!-- Add a short summary of the project -->
This repository analyzes transactional sales data to:
- Build a consolidated **sales fact table** (`Total_Sales`)
- Produce BI-ready tables for top products, categories, customers, and shippers
- Generate **time-series revenue** (annual & monthly)
- Enable dashboards and ML experiments

**Key Questions**
- Which products drive the most revenue and volume?
- Which categories and customers contribute the most?
- How do revenue trends evolve over time?
- Which shippers handle the largest order volumes and at what average freight?

---

## 🧩 Business Context
<!-- Describe the business scenario -->
- **Domain**: Retail/Wholesale order management  
- **Use-cases**: Product optimization, revenue tracking, customer value analysis, logistics performance  
- **Stakeholders**: Business leadership, Category managers, BI teams  

---

## 🗂 Dataset
- **Source**: https://sqliteonline.com/#urldb=https://raw.githubusercontent.com/jpwhite3/northwind-SQLite3/master/dist/northwind.db
- **Tables**: `Categories`, `CustomerCustomerDemo`, `CustomerDemographics`, `Customers`, `Employees`, `EmployeeTerritories`, `Order_Details`, `Orders`, `Products`, `Regions`, `Shippers`, `sqlite_sequence`, `Suppliers`, `Territories`
- **Granularity**: Order line level  

### 🧾 Data Dictionary
**Orders**
- `OrderID`, `CustomerID`, `EmployeeID`, `OrderDate`, `RequiredDate`, `ShippedDate`, `ShipVia`, `Freight`, `ShipName`, `ShipAddress`, `ShipCity`, `ShipRegion`, `ShipPostalCode`, `ShipCountry`

**Order_Details**
- `OrderID`, `ProductID`, `UnitPrice`, `Quantity`, `Discount`

**Customers**
- `CustomerID`, `CompanyName`, `ContactName`, `ContactTitle`, `Address`, `City`, `Region`, `PostalCode`, `Country`, `Phone`, `Fax`

**Products**
- `ProductID`, `ProductName`, `SupplierID`, `CategoryID`, `QuantityPerUnit`, `UnitPrice`, `UnitsInStock`, `UnitsOnOrder`, `ReorderLevel`, `Discontinued`

**Categories**
- `CategoryID`, `CategoryName`, `Description`, `Picture`

**Shippers**
- `ShipperID`, `CompanyName`, `Phone`

---

## 🛠 Tech Stack
- **Database**: northwind.db  
- **SQL Client:** ![SQLite](https://img.shields.io/badge/SQLite-07405E?style=for-the-badge)
- **Charts**: Excel (Pivot table)

---

## Insight and Visuals

# 📊 Company Performance Insights

## 💰 Total Revenue (All-Time)
The company generated an impressive **$448.39 million** in total revenue over the recorded period.

---

## 📈 Revenue Trend Over Time
- **Peak Period:** Revenue peaked between **2014–2016** at around **$41M annually**.
- **Recent Decline:** A slight drop is observed after **2022**.
<img width="597" height="348" alt="3) Revenue by Year" src="https://github.com/user-attachments/assets/765cd548-4fce-465d-82ff-20330393172c" />

---

## 🏆 Top-Selling Product by Revenue
- **Côte de Blaye** dominates sales with **$53.26M**, more than double the second-highest product.
<img width="765" height="357" alt="2) Top 10 Products by sales" src="https://github.com/user-attachments/assets/8a693ac0-6537-4f09-8c2a-ad3c0adfdd7e" />

---

## 📦 Top Product by Quantity Sold
- **Louisiana Hot Spiced Okra** leads with **206,213 units**, followed closely by **Sir Rodney's Marmalade**.
<img width="775" height="352" alt="4) Top 10 Products by quantity sold" src="https://github.com/user-attachments/assets/bb3aa763-2665-4e07-ace6-8d163aa4e46c" />

---

## 🍹 Revenue by Category
- **Beverages:** $92.16M  
- Confections and Meat/Poultry follow closely behind.
<img width="591" height="351" alt="5) Revenue by Category" src="https://github.com/user-attachments/assets/da7b0f3c-5ac6-4785-a09f-b7d3f21876da" />

---

## 💳 Average Order Value (AOV)
- **Overall AOV:** $27,538.79 (Indicates high-value transactions)

---

## 👥 Top Customers by Sales
- **B's Beverages** is the largest customer, contributing **$6.15M** in sales with an average order value of **$29,305**.
<img width="1077" height="268" alt="7) Total Sales and Average Order Value by Customer" src="https://github.com/user-attachments/assets/7dfc0b51-c390-4b87-ace9-1655ea54f648" />

---

## 🏅 Top Employees by Revenue
- **Margaret Peacock** leads with **$51.48M** revenue from **1,908 orders**, closely followed by **Steven Buchanan** and **Janet Leverling**.
<img width="767" height="290" alt="8) Orders and Revenue by Employees" src="https://github.com/user-attachments/assets/a3c19d25-6f1e-4598-abd7-cf9e4f1d2fff" />
---

## 🚚 Shipper Performance
- **United Package** handled the most orders (**5,486**) with an average freight cost of **$247.64 per order**.
<img width="577" height="121" alt="10) Shipper Performance" src="https://github.com/user-attachments/assets/f4a9f4de-5cad-4da1-9d17-e4424ff0630c" />

---

## 📆 Seasonality Insight
- **Strong Months:** June, August and December consistently show strong performance across years.
- **Weakest Month:** February tends to be the weakest month.
<img width="1587" height="367" alt="9) Revenue by Month" src="https://github.com/user-attachments/assets/8e3919f2-464e-4fcc-afbb-a493b640912f" />

---
## 📚 Appendix: Full SQL Queries
### Creating a new table "Total_Sales" that contains detailed sales information by joining Order_Details, Orders, and Customers tables.

```sql
CREATE TABLE Total_Sales AS
select D.OrderID, C.CustomerID, C.CompanyName, C.ContactName, C.ContactTitle, D.ProductID, D.UnitPrice, D.Quantity, (D.UnitPrice*D.Quantity*(1-D.Discount)) AS Total_Sales
FROM Order_Details D
LEFT JOIN Orders O
ON D.OrderID = O.OrderID
LEFT JOIN Customers C
ON O.CustomerID = C.CustomerID
order by Total_Sales DESC
```


### Joining the Products table to the Total_Sales table to include product names in the final output.

```sql
CREATE TABLE TOTAL_SALES_BY_PRODUCTS AS
SELECT T.OrderID, T.CustomerID, T.CompanyName, T.ContactName, T.ProductID,P.ProductName, T.UnitPrice, T.Quantity, T.Total_Sales
FROM Total_Sales T
LEFT JOIN Products P
ON T.ProductID = P.ProductID
```

### Calculating the total revenue from the Order_Details table.

```sql
select round(Sum(unitprice * quantity *(1-discount)),2) AS Total_Revenue
from Order_Details
```

### Querying the top 10 products by total sales amount from the TOTAL_SALES_BY_PRODUCTS table.

```sql
SELECT productid, productname, SUM(ROUND(total_sales,2)) AS Total_Sales
FROM TOTAL_SALES_BY_PRODUCTS
GROUP BY productid, productname
order by Total_Sales DESC
LIMIT 10
```

### Calculating annual revenue from the Orders and Order Details tables.

```sql
SELECT 
    CAST(strftime('%Y', O.OrderDate) AS INTEGER) AS SalesYear,
    ROUND(SUM(D.UnitPrice * D.Quantity * (1 - COALESCE(D.Discount, 0))), 2) AS Revenue
FROM Orders O
JOIN Order_Details D ON D.OrderID = O.OrderID
GROUP BY SalesYear
ORDER BY SalesYear
```

### Querying the top 10 products by total quantity sold from the TOTAL_SALES_BY_PRODUCTS table.

```sql
SELECT productid, productname, Sum(quantity) AS Total_Quantity
FROM TOTAL_SALES_BY_PRODUCTS
GROUP BY productid, productname
ORDER BY Total_Quantity DESC
LIMIT 10
```

### Calculating total sales by category by joining Order_Details, Products, and Categories tables.

```sql
SELECT C.CategoryID, C.CategoryName, ROUND(SUM(D.UnitPrice*D.Quantity*(1-D.Discount)),2) AS Total_Sales
FROM ORDER_DETAILS D
LEFT JOIN Products P 
ON D.ProductID = P.ProductID
LEFT JOIN Categories C
ON C.CategoryID = P.CategoryID
group by c.CategoryID, c.CategoryName
Order by Total_Sales DESC
```

### Calculating customer sales metrics including total sales, order counts, and average order value.

```sql
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
```

### Calculating monthly revenue from the Orders and Order Details tables.

```sql
SELECT
  CAST(strftime('%Y', O.OrderDate) AS INTEGER) AS SalesYear,
  CAST(strftime('%m', O.OrderDate) AS INTEGER) AS SalesMonth,
  ROUND(SUM(D.UnitPrice * D.Quantity * (1 - COALESCE(D.Discount, 0))), 2) AS Revenue
FROM Orders AS O
JOIN Order_Details AS D ON D.OrderID = O.OrderID
GROUP BY CAST(strftime('%Y', O.OrderDate) AS INTEGER),
         CAST(strftime('%m', O.OrderDate) AS INTEGER)
ORDER BY SalesYear, SalesMonth
```

### Calculating shipping performance metrics by shipper including total orders and average freight per order.

```sql
SELECT
  S.ShipperID,
  S.CompanyName AS Shipper,
  COUNT(*) AS Orders,
  ROUND(AVG(O.Freight), 2) AS AvgFreightPerOrder
FROM Orders O
JOIN Shippers S ON S.ShipperID = O.ShipVia
GROUP BY S.ShipperID, S.CompanyName
ORDER BY Orders DESC
```
---
## 📬 Contact
For questions, feedback, or collaboration:

- **Author:** Yogesh Kinikar
- **Email:** yogeshsk19.pumba@gmail.com
  
---
## 📜 License
This project is licensed under the MIT License.

You are free to use, modify, and distribute this project under the terms of the license.



