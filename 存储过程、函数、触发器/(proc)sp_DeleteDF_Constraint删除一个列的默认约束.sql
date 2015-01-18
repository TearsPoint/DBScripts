--删除一个列的默认约束

USE PinMeiCoreDB
EXEC dbo.spCheckSchema @schemaName = 'tool' -- nvarchar(30)

go
IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE ID = object_id(N'[tool].[sp_DeleteDF_Constraint] ') 
	AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [tool].[sp_DeleteDF_Constraint]  
GO
/*============================================================
SPName:		sp_DeleteDF_Constraint
Function:   删除一个列的默认约束
Input:		 
OutPut:		
Author:		wh	2013-10-21	 
日期        修改人                 修改说明 
=================================================================

*/  
CREATE PROC [tool].[sp_DeleteDF_Constraint] 
@tablename nvarchar(60)  ,
@columnname nvarchar(60) 
AS
BEGIN 
	declare @defname varchar(100)

	SELECT @defname = A.name FROM sysconstraints B 
	JOIN sysobjects A ON a.id=b.constid 
	JOIN sys.columns C ON  c.object_id=b.id AND c.column_id = B.colid 
	WHERE B.id=OBJECT_ID(@tablename) 
		AND c.name = @columnname 
		AND a.xtype = 'D' 
		
	declare @cmd varchar(100) 
	select @cmd='alter table '+ @tablename+ ' drop constraint '+ @defname if @cmd is null print 'No default constraint to drop'
	PRINT @cmd
	EXEC (@cmd)
END

 
 