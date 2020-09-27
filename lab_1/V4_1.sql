-- Создать новую базу данных
CREATE DATABASE ALEXEY_BOBKO;
GO

-- Изменить рабочую базу данных
USE ALEXEY_BOBKO;
GO

-- Создать схемы sales и persons
CREATE SCHEMA sales;
GO

CREATE SCHEMA persons;
GO

-- Создать таблицу Orders в sales схеме
CREATE TABLE sales.Orders (OrderNum Int NULL);
GO

-- Создать бекап базы данных
BACKUP DATABASE ALEXEY_BOBKO
TO DISK = 'D:\Учеба\7 sem\DB\labs\lab_1\ALEXEY_BOBKO.bak';
GO

-- Удалить базу данных
USE MASTER;
GO

DROP DATABASE ALEXEY_BOBKO;
GO

-- Восстановить базу данных из сохраненного бекапа
RESTORE DATABASE ALEXEY_BOBKO
FROM DISK = 'D:\Учеба\7 sem\DB\labs\lab_1\ALEXEY_BOBKO.bak';
GO