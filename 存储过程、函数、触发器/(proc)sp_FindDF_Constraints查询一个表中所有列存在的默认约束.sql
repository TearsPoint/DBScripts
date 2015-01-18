--
 
USE PinMeiCoreDB 
EXEC dbo.spCheckSchema @schemaName = 'tool' -- nvarchar(30)
go
IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE ID = object_id(N'tool.sp_FindDF_Constraints') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROC tool.sp_FindDF_Constraints
GO
/*============================================================
SPName:  tool.sp_FindDF_Constraints		
Function:    ��ѯһ�����������д��ڵ�Ĭ��Լ��
Input:		 
OutPut:		
Author:		wh		2013-10-21
����        �޸���                 �޸�˵�� 
=================================================================

*/
CREATE PROC tool.sp_FindDF_Constraints 
	@tableName	nvarchar(60) 
AS
BEGIN 
 	SELECT c.NAME ����, A.NAME Լ����,b.* FROM sysconstraints B
	JOIN sysobjects A ON a.id=b.constid
	JOIN sys.columns C ON  c.object_id=b.id AND c.column_id = B.colid
	WHERE B.id=OBJECT_ID(@tableName) 
		AND a.xtype = 'D' ;
END

 

 