--Polybase logic from SQL to SQL
--Source =on-prem_sql, target= on prem-sql server

/*
Step1- create master key encryption password
Step2- Create a New Database scoped credential ploybase
Step3- Create a New external Datasource
Step4- Create a new External tables
Step5- Query the table

*/
--STEP 1- Create master key encryption with password
create master key encryption by password='Admin@123'

--STEP2- create new database scope credential
create database scoped credential gaurav@123  
with 
identity='gaurav',     ---This is the Username and password from Source side 
secret='Admin@123'

--STEP 3 Creating external datasource
create external data source ploy1 
with 
( 
type=rdbms, 
location='gaurav.database.windows.net', -----This is Server of the Source side 
database_name='gaurav_db_name', 
credential=gaurav@123) --scope credential name(step2)
                    
--STEP 3- Create external table
create external table empext1      
( 
E_ID int, 
E_NAME varchar(100)) 
with( 
data_source=ploy1, --copy datasource name(step3)
schema_name='dbo', 
object_name='EMP'       ------The table from the source side 
) 
--STEP 4  Run the query          
select * from empext1

--STEP 5- Update the table
update ploy1
set E_NAME = 'GAURAV'
where E_ID = 1;


select * into new_table_name from ploy1;
