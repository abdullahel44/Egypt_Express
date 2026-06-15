# 🚚 Egypt Express: Logistics Database Engineering & Analytics Engine

## 📌 Project Overview
This project showcases an end-to-end relational database design built from scratch in SQL Server to simulate and analyze logistics operations for **Egypt Express**. Instead of relying on static spreadsheets, this project engineers a dynamic, robust environment that programs data relationships and auto-generates realistic business scenarios.

---

## 🏗️ Architecture & Core Features

### 1️⃣ Relational Database Design (Star Schema Concept)
* **Dimension Table:** `Couriers` (Tracks courier IDs, names, and operational zones like Cairo, Sharqia, Mansoura, etc.)
* **Fact Table:** `Orders` (Tracks order IDs, values, temporal metrics, delivery logs, and regional routing keys).
* Enforced structural data integrity through **Primary Keys** and **Foreign Keys** (`FK_Orders_Couriers`) to handle complex relational dependency mapping without breaking.

### 2️⃣ Automated Data Simulation Loop (1,000 Transactions)
* Implemented a programmatic **SQL WHILE Loop** driven by dynamic functions (`NEWID()`, `CHECKSUM()`, `ABS()`) to synthetically generate **1,000 realistic transactional records**.
* Formulated data weights where orders are dynamically distributed across Egyptian governorates, balanced order statuses (Delivered, Returned, Delayed), and calibrated shipping dates for May 2026.

---

## 📊 Analytical Business Queries Inside
The analysis engine answers critical operational business questions through advanced SQL scripting:
1. **Volumetric Breakdown:** Tracks sales performance and volumes group-mapped by transaction status.
2. **Logistics Efficiency Check:** Evaluates regional fulfillment capabilities (Delivered vs. Delayed per city).
3. **Financial Auditing:** Ranks courier efficiency based on actual cash collected (`Real_Collected_Value`).
4. **Risk & Loss Mitigation:** Highlights top 3 high-risk return zones (`High-Risk Zones`) to prevent logistical leaks.

---

## 🚀 How to Execute this Project
1. Open **Microsoft SQL Server Management Studio (SSMS)**.
2. Copy and paste the contents of `SQL_egypt_express.sql` into a new query window.
3. Press `F5` or click **Execute** to safely compile the database layout, run the 1,000-row simulator loop, and read the analytical dashboard reports instantly.
