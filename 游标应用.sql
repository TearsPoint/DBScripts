

--游标应用

DECLARE @Id INT 
--声明游标  
DECLARE tempCursor CURSOR
FOR SELECT DISTINCT [游标列] FROM [表] WHERE [条件]
 
OPEN tempCursor  --打开游标
WHILE(1=1)
BEGIN 
	FETCH NEXT FROM tempCursor INTO @Id  --往下游
	IF(@@FETCH_STATUS!=0)  --游标状态不等于0时退出
		BREAK 
	PRINT @Id  
	[相关处理]
END 

CLOSE tempCursor   --关闭游标
DEALLOCATE tempCursor --回收游标

 
