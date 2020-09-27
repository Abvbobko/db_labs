-- Создание базы данных
CREATE DATABASE ALEXEY_BOBKO;
GO

-- Изменение рабочей базы
USE ALEXEY_BOBKO;
GO

-- Создание схемы sales
CREATE SCHEMA sales;
GO

-- Создание схемы persons
CREATE SCHEMA persons;
GO

-- Создание таблицы Orders, принадлежащей схеме sales
CREATE TABLE sales.Orders (OrderNum Int NULL);
GO

-- Создание бекапа базы данных
BACKUP DATABASE ALEXEY_BOBKO
TO DISK = 'D:\Учеба\7 sem\DB\labs\lab_1\ALEXEY_BOBKO.bak';
GO

-- Изменение рабочей базы
USE MASTER;
GO

-- Удаление базы ALEXEY_BOBKO
DROP DATABASE ALEXEY_BOBKO;
GO

-- Восстановление базы ALEXEY_BOBKO
RESTORE DATABASE ALEXEY_BOBKO
FROM DISK = 'D:\Учеба\7 sem\DB\labs\lab_1\ALEXEY_BOBKO.bak';
GO