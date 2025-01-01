CREATE TABLE FACTSALES (
    CNO INT,
    PID INT,
    QTY INT,
    LOCCODE VARCHAR(100)
) ;
insert into FACTSALES VALUES(1,10, 2, 'A');
insert into FACTSALES VALUES(2,20, 3, 'B');
insert into FACTSALES VALUES(3,10, 4, 'A');
insert into FACTSALES VALUES(4,30, 5, 'C');
insert into FACTSALES VALUES(5,20, 6, 'B');

SELECT * FROM FACTSALES;

--Analyzing LOCCODE:
SELECT LOCCODE, COUNT(*) as count_row
FROM FACTSALES
GROUP BY LOCCODE;

--Analyzing CNO
SELECT CNO, COUNT(*) as count_row
FROM FACTSALES
GROUP BY CNO;

--Analyzing PID:

SELECT PID, COUNT(*) as count_row
FROM FACTSALES
GROUP BY PID;

--Results:
/*
CNO has the least skew because each value appears exactly once.
LOCCODE and PID are slightly skewed, but less than highly skewed cases.
*/