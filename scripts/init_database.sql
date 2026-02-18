/*
=============================================================
Create Database & Schemas
=============================================================
Script Purpose:
	- This script purpose is to create a new database called 'OlistDataWarehouse' after checking if it already exist.
	- If database already exists than it is dropped and recreated. Additionally, the script creates three schemas within database: 'bronze', 'silver', 'gold'.

WARNING:
	Running this script will drop the entire database 'OlistDataWarehouse' if it exists.
	All data in the database will be permanently deleted. So, proceed with caution and ensure you have proper backup before running the script.
*/

-- Start with switching to master database
USE master;
GO

-- Dop and re-create the database 'OlistDataWarehouse'
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'OlistDataWarehouse')
BEGIN
	ALTER DATABASE OlistDataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE OlistDataWarehouse;
END

-- Create Database
CREATE DATABASE OlistDataWarehouse;

-- Switch to 'OlistDataWarehouse' from 'Master Database'
USE OlistDataWarehouse;
GO

-- Create the three schemas: 'bronze', 'silver', 'gold'
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

CREATE SCHEMA analytic;
GO