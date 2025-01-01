-- Create a SQL Server login
CREATE LOGIN gaurav WITH PASSWORD = 'Admin@123';


-- Create a database user for the login
USE Employees;
CREATE USER gaurav FOR LOGIN gaurav;


EXEC sp_addrolemember 'db_owner', 'gaurav';

ALTER SERVER ROLE sysadmin ADD MEMBER gaurav;