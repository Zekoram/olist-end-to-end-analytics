# 🏗️ Olist End-to-End Data Warehouse Project

This project demonstrates the design and implementation of a structured data warehouse using the Medallion Architecture (Bronze → Silver → Gold → Analytic) on Olist e-commerce data.

The objective was to transform raw transactional CSV data into a governed, business-ready model and generate analytical insights using SQL and BI dashboards.

**Dataset size:** 100k+ transactions

---

## 📌 Project Scope

Data sources were conceptually categorized for architectural clarity:

- **ERP** → Orders, Order Items, Payments, Products, Sellers  
- **CRM** → Customers, Reviews  
- **Reference Data** → Geolocation, Category Translation  

The focus areas:

- Clean architecture  
- Structured transformations  
- Dimensional modeling  
- Analytical reporting  

---

## 🏛️ Data Architecture

This project follows a strict Medallion structure:

### 🥉 Bronze Layer (Raw Ingestion)

- Raw CSV data loaded as-is  
- No transformations  
- Batch processing  
- Schema isolation (`bronze`)  

---

### 🥈 Silver Layer (Standardization)

- Data cleansing  
- Standardization  
- Derived columns  
- Business-ready formats  
- Schema: `silver`  

---

### 🥇 Gold Layer (Dimensional Model)

- Star Schema implementation  
- Fact & Dimension tables  
- Surrogate keys (`_key`)  
- Enforced PK–FK relationships  
- Schema: `gold`  

**Core Tables:**

- `fact_orders`  
- `fact_reviews`  
- `dim_customers`  
- `dim_products`  
- `dim_sellers`  

---

### 📊 Analytic Layer

Built strictly on top of the Gold layer.

Used for:

- KPI computation  
- Ranking analysis  
- Cumulative trend analysis  
- Segmentation  
- Change-over-time analysis  
- Business reports  

Schema: `analytic`

---

## 🔁 Data Flow Governance

Strict dependency rule enforced:


No backward references allowed.

<!-- INSERT DATA FLOW IMAGE BELOW -->
<!-- Example:
![Data Flow](docs/data_flow.png)
-->

---

## 🧱 Data Modeling

The Gold layer is structured using a Star Schema:

- Fact tables for transactional metrics  
- Dimension tables for descriptive attributes  
- Surrogate keys for referential integrity  
- Business-aligned naming conventions  

<!-- INSERT STAR SCHEMA IMAGE BELOW -->
<!-- Example:
![Data Model](docs/data_model.png)
-->

---

## ⚙️ ETL Implementation

- Stored procedures: `load_bronze`, `load_silver`, `load_gold`  
- Layer-specific SQL scripts  
- Controlled transformation logic  
- 24+ structured SQL files  

---

## 📊 Dashboards

Three dashboards were built using the Gold and Analytic layers:

### 📈 Sales Dashboard

- Revenue trends  
- Category contribution (Pareto)  
- Review score tracking  

<!-- INSERT SALES DASHBOARD IMAGE BELOW -->
<!-- Example:
![Sales Dashboard](dashboards/sales_dashboard.png)
-->

---

### 👥 Customer Dashboard

- Revenue consistency  
- Average order value  
- Regional density analysis  

<!-- INSERT CUSTOMER DASHBOARD IMAGE BELOW -->
<!-- Example:
![Customer Dashboard](dashboards/customer_dashboard.png)
-->

---

### 🚚 Logistics Dashboard

- Average delivery days  
- Late delivery rate  
- Delivery delay impact on reviews  

<!-- INSERT LOGISTICS DASHBOARD IMAGE BELOW -->
<!-- Example:
![Logistics Dashboard](dashboards/logistics_dashboard.png)
-->

---

## 🛠️ Tools Used

- SQL Server  
- SSMS  
- Draw.io  
- Tableau  
- GitHub  

---

## 🧠 Skills Demonstrated

- Data Warehouse Architecture  
- Dimensional Modeling  
- Advanced SQL (CTEs, Window Functions)  
- ETL Design  
- Data Governance  
- Business KPI Development  
- BI Dashboarding  

