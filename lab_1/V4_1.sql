-- �������� ���� ������
CREATE DATABASE ALEXEY_BOBKO;
GO

-- ��������� ������� ����
USE ALEXEY_BOBKO;
GO

-- �������� ����� sales
CREATE SCHEMA sales;
GO

-- �������� ����� persons
CREATE SCHEMA persons;
GO

-- �������� ������� Orders, ������������� ����� sales
CREATE TABLE sales.Orders (OrderNum Int NULL);
GO

-- �������� ������ ���� ������
BACKUP DATABASE ALEXEY_BOBKO
TO DISK = 'D:\�����\7 sem\DB\labs\lab_1\ALEXEY_BOBKO.bak';
GO

-- ��������� ������� ����
USE MASTER;
GO

-- �������� ���� ALEXEY_BOBKO
DROP DATABASE ALEXEY_BOBKO;
GO

-- �������������� ���� ALEXEY_BOBKO
RESTORE DATABASE ALEXEY_BOBKO
FROM DISK = 'D:\�����\7 sem\DB\labs\lab_1\ALEXEY_BOBKO.bak';
GO