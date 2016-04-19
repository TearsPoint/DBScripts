--
 
USE PinMeiCoreDB 
EXEC dbo.spCheckSchema @schemaName = 'tool' -- nvarchar(30)
go
IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE ID = object_id(N'tool.sp_FindDF_Constraints') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROC tool.sp_FindDF_Constraints
GO
/*============================================================
SPName:  tool.sp_FindDF_Constraints		
Function:    查询一个表中所有列存在的默认约束
Input:		 
OutPut:		
Author:		wh		2013-10-21
日期        修改人                 修改说明 
=================================================================

*/
CREATE PROC tool.sp_FindDF_Constraints 
	@tableName	nvarchar(60) 
AS
BEGIN 
 	SELECT c.NAME 列名, A.NAME 约束名,b.* FROM sysconstraints B
	JOIN sysobjects A ON a.id=b.constid
	JOIN sys.columns C ON  c.object_id=b.id AND c.column_id = B.colid
	WHERE B.id=OBJECT_ID(@tableName) 
		AND a.xtype = 'D' ;
END

 

 