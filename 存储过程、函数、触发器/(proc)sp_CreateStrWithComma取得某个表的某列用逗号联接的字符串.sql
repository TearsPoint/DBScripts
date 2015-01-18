USE PinMeiCoreDB
EXEC dbo.spCheckSchema @schemaName = 'tool' -- nvarchar(30)
 

go
IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE ID = object_id(N'[tool].[sp_CreateStrWithComma]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROC [tool].[sp_CreateStrWithComma]
GO
/*============================================================
spName:		[tool].[spCreateStrWithComma]
Function:	取得某个表的某列用逗号联接的字符串
Input:		@tableName nvarchar(100),	表名
			@colName nvarchar(100) ,	列名
			@filter nvarchar(4000)		条件
OutPut:		
Author:		wh	2012-11-30  
日期        修改人                 修改说明 
=================================================================

测试
	DECLARE @t NVARCHAR(4000) 
	EXEC test.sp_CreateStrWithComma 'tb','姓名','',@t OUTput
	PRINT @t
*/
CREATE PROC [tool].[sp_CreateStrWithComma] (
	@tableName nvarchar(100),
	@colName nvarchar(100) ,
	@filter nvarchar(4000),
	@result nvarchar(4000) output
)
AS
BEGIN
SET NOCOUNT ON
	SET @result=''
	CREATE TABLE #table
	(
		col nvarchar(1000) NOT null
	)
	
	DECLARE @sql nvarchar(400)
	SET @sql = ' select distinct ' + @colName +' from  '+  @tableName
	IF(LEN(@filter)>0)
		SET @sql =@sql + ' where ' +@filter 
	
	 INSERT INTO #table(col)
	 EXEC (@sql) 
	 
	 SELECT @result = @result + col +','  FROM #table
	 SET @result = SUBSTRING(@result,0,LEN(@result)) 
	 
	 DROP TABLE #table
END
SET NOCOUNT OFF 
go


-------------------------------------------------------

--EXEC dbo.spCheckSchema @schemaName = 'test' -- nvarchar(30)

--IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE ID = object_id(N'test.spTestCreateStrWithComma') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)
--DROP PROC test.spTestCreateStrWithComma
--go
--CREATE PROC test.spTestCreateStrWithComma
--AS
--SET NOCOUNT ON
--  CREATE TABLE #jet
--  (
--		id INT PRIMARY KEY  IDENTITY(1,1),
--		NAME NVARCHAR(100) 
--  )   
  
--  INSERT INTO #jet (  NAME )
--  VALUES  ( 'hello')
--  INSERT INTO #jet (  NAME )
--  VALUES  ( 'merry')
--  INSERT INTO #jet (  NAME )
--  VALUES  ( 'baby')
  
--  DECLARE @out NVARCHAR(4000)
--  EXEC tool.spCreateStrWithComma 
--	  @tableName = '#jet', -- nvarchar(100)
--      @colName = 'name', -- nvarchar(100)
--      @filter = NULL, -- nvarchar(4000)
--      @result=@out OUTPUT 
--  PRINT @out
  
--  DROP TABLE #jet
--SET NOCOUNT OFF 
--GO
 

 
--EXEC test.spTestCreateStrWithComma
				  