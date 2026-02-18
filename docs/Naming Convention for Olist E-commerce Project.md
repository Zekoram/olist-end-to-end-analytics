# Naming Convention for Olist E-commerce Project

This document outlines the naming convention used for schemas, tables, views, columns, and other objects in the data warehouse.

### Table Of Content

1. General Principles  
2. Schema Naming Convention
3. Table Naming Conventions  
   1. Bronze Layer  
   2. Silver Layer  
   3. Gold Layer  
   4. Analytic Layer
4. Column Naming Conventions  
   1. Surrogate Keys  
   2. Technical Columns  
5. View Naming Convention
6. Stored Procedures
7. Data Layer Dependency Rule

## General Principles

Naming Convention: Use snake\_case with letters in lowercase and underscores (‘\_’) to separate words.  
Language: Use English for all names.  
Avoid Reserved Words: Don’t use SQL reserved words for naming an object.
Consistency: Object names must follow a predictable and structured format across all layers.

## Schema Naming Convention

Each medallion layer must use a dedicated schema to clearly separate responsibilities.

| Schema Name | Purpose |
|-------------|----------|
| bronze      | Raw data ingestion (as-is from source) |
| silver      | Cleaned and standardized data |
| gold        | Business-ready dimensional models |
| analytic    | Reporting and business-facing views |

Rules:

- All schemas must use lowercase.
- No mixing tables from different layers in the same schema.
- Data must flow from bronze → silver → gold → analytic only.

Example:
- bronze.olist_orders  
- silver.olist_orders  
- gold.fact_orders  
- analytic.report_sales_summary  

## Table Naming Conventions

The following are the naming conventions for each of the Medallion Layer (Bronze, Silver, Gold):

### 1\. Bronze Rules

All names must start with the company name, and table names must match the name in the original document.  
Format: ‘\<companyname\>\_\<entity\>’

- ‘\<companyname\>’: Name of the company (e.g., Olist)  
- ‘\<entity\>’: Exact table name form source system  
- Example: ‘olist\_customer’ ➡️Customer info of Olist Company.

### 2\. Silver Rules

All names must start with the company name, andthe  table name should be the same as the original document.  
Format: ‘\<companyname\>\_\<entity\>’

- ‘\<companyname\>’: Name of the company (e.g., Olist)  
- ‘\<entity\>’: Exact table name form source system  
- Example: ‘olist\_customer’ ➡️Customer info of Olist Company.

### 3\. Gold Rules

All names must use meaningful, business-aligned names for tables, starting with the category prefix.   
Format: ‘\<category\>\_\<entity\>’

- ‘\< category\>’: Describe the role of the table, such as ‘dim’ (dimension) or ‘fact’ (fact) table.  
- ‘\<entity\>’: Describe the name of the table, aligned with the business domain (‘customers’, ‘products’, ‘sales’)  
- Examples:  
  - ‘dim\_customers’ ➡️ Dimension table for customer data  
  - ‘fact\_orders’ ➡️ fact table containing order information

Gold tables must be structured using dimensional modeling (Star Schema).

### 4. Analytic Layer Rules

The analytic layer is built on top of the gold layer and is used for analysis, reporting, and advanced calculations.

Unlike the gold layer (which contains standardized business views), the analytic layer contains materialized tables used for:

- Exploratory Data Analysis (EDA)  
- Advanced analytical calculations  
- KPI computation  
- Cumulative and ranking analysis  
- Segmentation and performance analysis  

Format: ‘analytic_<subject>’ or ‘report_<subject>’

- ‘analytic_’: Prefix for analytical or intermediate analysis tables.   

Examples:  
- ‘analytic_sales_trends’  
- ‘analytic_customer_segments’  

Analytic tables must reference only gold layer objects.

### Glossary of Category Pattern

| Pattern | Meaning | Examples |
| :---: | :---: | :---: |
| ‘dim\_’ | Dimension Table | ‘dim\_customers’, ‘dim\_products’ |
| ‘fact\_’ | Fact Table | ‘fact\_orders’ |
| ‘report\_’ | Report Table | ‘report\_customers’, ‘report\_products’ |

## Column Naming Conventions

### Surrogate Keys

All primary keys in the dimension table should use the suffix ‘\_key’.  
Format: ‘\<table\_name\>\_key’

- ‘\<table\_name\>’: Refers to the name of the table or entity the key belongs to.  
- ‘\_key’: A suffix indicating that this column is a surrogate key.  
- Example: ‘customer\_key’ ➡️ Surrogate key in the ‘dim\_customers’ table.

### Technical Columns

All technical columns must start with the prefix ‘dwh\_’, followed by a descriptive name indicating the column’s purpose.  
Format: ‘dwh\_\<column\_name\>’

- ‘dwh\_’: Prefix exclusively for system-generated metadata.  
- ‘\<column\_name\>’: Descriptive name indicating the column's purpose.  
- Example: ‘dwh\_load\_date’ ➡️ System-generated column used to store the date when record was loaded.

## Stored Procedure

All stored procedure used for loading data must follow the naming pattern: ‘load\_\<layer\>’

- ‘\<layer\>’: Represent the layer being loaded, such as ‘bronze’, ‘silver’, or ‘gold’.  
- Examples:  
  - ‘load\_bronze’: Stored procedure for loading data into the bronze layer.  
  - ;load\_silver’: Stored procedure for loading data into the silver layer.

## Data Layer Dependency Rule

Data must flow strictly in one direction:

Source → Bronze → Silver → Gold → Analytic

Rules:

- Bronze must not reference silver, gold, or analytic.  
- Silver must not reference gold or analytic.  
- Gold must not reference analytic.  
- Analytic must reference only gold.

Backward dependencies are not allowed.