
/*
从Excel导出的日期是数值问题
*/

DECLARE @out_dDate DATETIME
SET @out_dDate =CONVERT (DATETIME,CONVERT(DECIMAL(12,4) , '40946.0' )-2 ,120)
SELECT @out_dDate
