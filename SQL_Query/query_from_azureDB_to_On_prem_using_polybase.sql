--Query data from Azure SQL to On-Prem
--Source =Azure database, sink = on prem-sql server
--STEP 1
create master key encryption by password='Kittu@123'  
--STEP 2                     
create database scoped credential ploybase  
with 
identity='manojeclasess',     ---This is the Username and password from Source side 
secret='Manoj@123'
--STEP 3        
create external data source ploy1 
with 
( 
type=rdbms, 
location='newservermanoj.database.windows.net', -----This is Server of the Source side 
database_name='manojkrishna', 
credential=ploybase) 
--STEP4       
create external table empext1      
( 
E_ID int, 
E_NAME varchar(100)) 
with( 
data_source=ploy1, 
schema_name='dbo', 
object_name='EMP'       ------The table from the source side 
)

--STEP 5- QUERY THE DATA       
select * from empext1
