--Step 1: Create some new databases (in case you need any new database or you are just trying to do a PoC) 
--Run below query on Master datababse in Azure SQL

CREATE DATABASE OriginDB(EDITION='Standard', Service_Objective='S0');
CREATE DATABASE RemoteDB(EDITION='Standard', Service_Objective='S0');

--Step 2: Create a SQL Login in the logical server's master database (Use MASTER database)
CREATE LOGIN RemoteLogger WITH PASSWORD='Admin@123'; -- Please add a stronger password! (Run on Master database)


--Step 3: Create a SQL User in the remote database (Use RemoteDB)
CREATE USER RemoteLogger FOR LOGIN RemoteLogger;  --(Run this query on RemoteLogger database)

--Step 4: Create a Master Key in the Origin Database (Run below query on OriginDB datababse)
CREATE MASTER KEY ENCRYPTION BY PASSWORD='Admin@123' -- Add a stronger password here as well!

--Step 5: Create a Database Scoped Credential in the origin database
/*
We need to create a database scoped credential that has the user and password for the login we created in RemoteDB.

IDENTITY: It's the user that we created in RemoteDB from the RemoteLogger SQL Login.
SECRET: It's the password you assigned the SQL Login when you created it.
*/
CREATE DATABASE SCOPED CREDENTIAL AppCredential WITH IDENTITY = 'RemoteLogger', SECRET='Pa$$w0rd';
-- Use a stronger password!

--Step 6: Creating the external data source origin database
/*
Now we will be creating the remote data source reference. This reference will define where to look for the remote database, 
being it in the same server as OriginDB or in another server. The remote data source for this example will be called "RemoteDatabase".
*/
CREATE EXTERNAL DATA SOURCE RemoteDatabase
WITH
(
TYPE=RDBMS,
LOCATION='gaurav-server1.database.windows.net', -- Change the servername for your server name.
DATABASE_NAME='RemoteDB',
CREDENTIAL= AppCredential
);

--Step 7: Create the table in the remote source
/*
Now, of course, we need to have an existing physical table in our RemoteDB, which will be the one that we will be referencing from 
OriginDB further in this guide.
*/
CREATE TABLE RemoteTable  -- (run this command on RemoteDB)
(
ID INT IDENTITY PRIMARY KEY,
NAME VARCHAR(20) NOT NULL,
LASTNAME VARCHAR(30) NOT NULL,
CEL VARCHAR(12) NOT NULL,
EMAIL VARCHAR(60) NOT NULL,
USERID INT
);

--Step 8: Create the external table in the origin database
/*
Create a mapping table in OriginDB that references the fields in RemoteDB for table RemoteTable as intended in step 7.
*/
CREATE EXTERNAL TABLE RemoteTable
(
ID INT,
NAME VARCHAR(20) NOT NULL,
LASTNAME VARCHAR(30) NOT NULL,
CEL VARCHAR(12) NOT NULL,
EMAIL VARCHAR(60) NOT NULL,
USERID INT
)
WITH
(
DATA_SOURCE = RemoteDatabase
);

--Step 9: Granting the RemoteDB user SELECT permissions on RemoteTable (Use RemoteDB)
GRANT SELECT ON [RemoteTable] TO RemoteLogger;

--Step 10: Inserting data in RemoteTable
/*
Now all is left is to populate the RemoteTable in RemoteDB with some data and test out the remote call from OriginDB.
*/
INSERT INTO REMOTETABLE (Name, LastName, Cel, Email, UserId) VALUES
('Vlad', 'Borvski', '91551234567', 'email3@contoso.com', 5),
('Juan', 'Galvin', '95551234568', 'email2@contoso.com', 5),
('Julio', 'Calderon', '95551234569', 'email1@contoso.net',1),
('Fernando', 'Cobo', '88888888', 'email0@email.com', 5);

--Step 11: Querying the remote table from OriginDB
SELECT COUNT(*) FROM RemoteTable;

--Step 12: Check if the data is the same
/*
Then, lastly we can just do a normal SELECT on the RemoteTable table and see the same data that we have in RemoteDB.
*/
SELECT * FROM RemoteTable;