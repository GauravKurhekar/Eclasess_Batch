--STEP 1
CREATE MASTER KEY encryption by password = 'Admin@123';

--STEP 2
CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredential -- anyname
WITH
    IDENTITY = 'gaurav',
    SECRET = '6hsnf4DV30iYb+CtnOh5Q8/el6jc5bpYaaONfx1LZcCQ1lu3PNbGuCj48wKUECooLQ0OMxi34Ki7+AStNUubmA=='
;

--STEP 3- 

CREATE EXTERNAL DATA SOURCE AzureStorage
WITH (
    TYPE = HADOOP,
    LOCATION = 'wasbs://gaurav-container@gauravstorageacc.blob.core.windows.net',--change container name and storage_acc_name
    CREDENTIAL = AzureStorageCredential	--same credential as database scope credential(step2)
);

--Step4 Create external file format

CREATE EXTERNAL FILE FORMAT TextFileFormat
WITH
(   FORMAT_TYPE = DELIMITEDTEXT
,    FORMAT_OPTIONS    (   FIELD_TERMINATOR = ','  --our field terminator is comma(,) thats the reason we give , change if | is there
                    ,    STRING_DELIMITER = ''
                    ,    DATE_FORMAT         = 'yyyy-MM-dd HH:mm:ss.fff'
                    ,    USE_TYPE_DEFAULT = FALSE
                    )
);

--Step5- 
CREATE EXTERNAL TABLE EXTCUSTOMER
(
	CNO INT,
	CNAME VARCHAR(100),
	SAL INT
)
WITH
(
    LOCATION='/polybase/'				--give folder location of storage account in which text file is present
,   DATA_SOURCE = AzureStorage		--replace data source by copying from external datasource name(step3)
,   FILE_FORMAT = TextFileFormat	--replace file format, our is text file(copy from step4)
,   REJECT_TYPE = VALUE
,   REJECT_VALUE = 1				--header 1 we want to reject
)
;


--Step6- Run the select command

insert into DIMCUSTOMER
Select * from EXTCUSTOMER;


--STEP 7--Validate the data
select * from DIMCUSTOMER;