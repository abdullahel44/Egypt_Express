-- =================================================================================
-- PROJECT: EGYPT EXPRESS LOGISTICS ANALYSIS
-- DATABASE CREATION, DATA GENERATION (1000 ROWS LOOP), AND BUSINESS QUERIES
-- =================================================================================

-- 1) ENVIRONMENT SETUP: Creating Database securely if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'egypt_express_db')
BEGIN
    CREATE DATABASE egypt_express_db;
END
GO

USE egypt_express_db;
GO


-- 2) CLEANUP ENGINE: Dropping existing tables to ensure a fresh structure reload
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Couriers', 'U') IS NOT NULL DROP TABLE dbo.Couriers;
GO


-- 3) CORE STRUCTURES: Building the Relational Schema (Couriers & Orders)
-- Title: Creating the Couriers (Dimension) Table
CREATE TABLE Couriers (
    courier_id INT PRIMARY KEY,
    courier_name VARCHAR(100) NOT NULL,
    courier_city VARCHAR(50) NOT NULL
);

-- Title: Creating the Orders (Fact) Table with Foreign Key enforcement
CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY, 
    customer_city VARCHAR(50) NOT NULL,
    order_status VARCHAR(20) NOT NULL,
    order_value DECIMAL(10,2) NOT NULL,
    courier_id INT,
    order_date DATE NOT NULL,
    delivery_date DATE NULL,
    CONSTRAINT FK_Orders_Couriers FOREIGN KEY (courier_id) 
        REFERENCES Couriers(courier_id)
);
GO


-- 4) DATA INGESTION: Populating Courier Master Data
INSERT INTO Couriers (courier_id, courier_name, courier_city) VALUES
(101, 'Abdullah ali', 'Cairo'),
(102, 'Mohamed salah', 'Sharqia'),
(103, 'Ramy gamal', 'Giza'),
(104, 'Abdo mohamed', 'Mansoura'),
(105, 'Khaled ahmed', 'Alexandria'),
(106, 'Samy mahmoud', 'Ismaillia');
GO


-- 5) AUTOMATED SIMULATION ENGINE: Generating 1,000 Balanced Transactional Rows
SET NOCOUNT ON;
DECLARE @Counter INT = 1;
DECLARE @RandomCity VARCHAR(50);
DECLARE @RandomStatus VARCHAR(20);
DECLARE @RandomValue DECIMAL(10,2);
DECLARE @RandomCourier INT;
DECLARE @RandomDate DATE;

WHILE @Counter <= 1000
BEGIN
    -- Dynamic Assignment of Egyptian Governorates
    SET @RandomCity = CASE (ABS(CHECKSUM(NEWID())) % 6)
        WHEN 0 THEN 'Cairo'
        WHEN 1 THEN 'Sharqia'
        WHEN 2 THEN 'Giza'
        WHEN 3 THEN 'Mansoura'
        WHEN 4 THEN 'Alexandria'
        ELSE 'Ismaillia'
    END;

    -- Dynamic Assignment of Realistic Order Status Weights
    SET @RandomStatus = CASE (ABS(CHECKSUM(NEWID())) % 10)
        WHEN 0 THEN 'Delayed'
        WHEN 1 THEN 'Returned'
        WHEN 2 THEN 'Returned'
        ELSE 'Delivered'
    END;

    -- Dynamic Price Generation between 100 and 3000 EGP
    SET @RandomValue = (ABS(CHECKSUM(NEWID())) % 2901) + 100;

    -- Structural Mapping: Matching appropriate Courier ID based on Region
    SET @RandomCourier = CASE @RandomCity
        WHEN 'Cairo' THEN 101
        WHEN 'Sharqia' THEN 102
        WHEN 'Giza' THEN 103
        WHEN 'Mansoura' THEN 104
        WHEN 'Alexandria' THEN 105
        ELSE 106
    END;

    -- Temporal Simulation: Spreading dates across May 2026
    SET @RandomDate = DATEADD(day, (ABS(CHECKSUM(NEWID())) % 28), '2026-05-01');

    -- Executing safe transaction insertion
    INSERT INTO Orders (customer_city, order_status, order_value, courier_id, order_date, delivery_date)
    VALUES (@RandomCity, @RandomStatus, @RandomValue, @RandomCourier, @RandomDate, 
            CASE @RandomStatus WHEN 'Delivered' THEN DATEADD(day, 2, @RandomDate) ELSE NULL END);

    SET @Counter = @Counter + 1;
END;
GO


-- =================================================================================
-- PHASE 2: BUSINESS INTELLIGENCE & ANALYTICAL QUERIES
-- =================================================================================

-- Title: Quality Check - Verifying total rows generated
SELECT COUNT(*) AS Total_Generated_Orders FROM Orders;


-- Title: Query 1 - Sales Performance and Volumetric Breakdown by Order Status
SELECT 
    order_status, 
    SUM(order_value) AS Totel_Value, 
    COUNT(order_status) AS Totel_orders  
FROM Orders 
GROUP BY order_status;


-- Title: Query 2 - Regional Logistics Efficiency Check (Delivered vs Delayed Orders)
SELECT 
    customer_city, 
    COUNT(CASE WHEN order_status='Delivered' THEN 1 END) AS Delivered,
    COUNT(CASE WHEN order_status='Delayed' THEN 1 END) AS Delayed
FROM Orders 
GROUP BY customer_city 
ORDER BY Delivered DESC;


-- Title: Query 3 - Courier Performance Ranking Based on Total Cash Actually Collected
SELECT 
    c.courier_name,
    c.courier_city,
    COUNT(o.order_id) AS Total_Orders,
    SUM(CASE WHEN o.order_status = 'Delivered' THEN o.order_value ELSE 0 END) AS Real_Collected_Value
FROM Orders o
INNER JOIN Couriers c ON o.courier_id = c.courier_id
GROUP BY c.courier_name, c.courier_city
ORDER BY Real_Collected_Value DESC;


-- Title: Query 4 - High-Risk Zones: Identifying Top 3 Cities with Highest Returns
SELECT TOP 3 
    customer_city, 
    COUNT(order_status) AS TOP_3_Order_Returned
FROM Orders  
WHERE order_status = 'Returned'  
GROUP BY customer_city 
ORDER BY TOP_3_Order_Returned DESC;


-- Title: Data Audit - Snapshot view of full operational tables
SELECT * FROM Couriers;
SELECT * FROM Orders;
