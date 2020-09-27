-- Create new data base
CREATE DATABASE ALEXEY_BOBKO;
GO

-- Change work data base
USE ALEXEY_BOBKO;
GO

-- Create sales and persons schemas
CREATE SCHEMA sales;
GO

CREATE SCHEMA persons;
GO

-- Create table Orders in sales schema
CREATE TABLE sales.Orders (OrderNum Int NULL);
GO

-- Create data base backup
BACKUP DATABASE ALEXEY_BOBKO
	TO DISK = 'D:\Учеба\7 sem\DB\labs\lab_1\ALEXEY_BOBKO.bak';
GO

-- Delete database
USE MASTER;
GO

DROP DATABASE ALEXEY_BOBKO;
GO

-- Restore data base from saved backup
RESTORE DATABASE ALEXEY_BOBKO
   FROM DISK = 'D:\Учеба\7 sem\DB\labs\lab_1\ALEXEY_BOBKO.bak';
GO