


USE PinMeiCoreDB 
go
IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE ID = object_id(N'spCheckSchema') 
	AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE spCheckSchema
GO
/*============================================================
SPName:		spCheckSchema	
Function:   ���ܹ�����������������Զ�����
Input:		 
OutPut:		
Author:		 
����        �޸���                 �޸�˵�� 
=================================================================
2013-1-4	wh			create
*/  
CREATE PROC spCheckSchema
@schemaName NVARCHAR(30)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name =@schemaName)
	BEGIN
		DECLARE @str NVARCHAR(200)
		SET @str = 'Create Schema ['+@schemaName + ']'
 		PRINT @str
		EXEC (@str)
	END
END
go


---------------------------------------------------------------------------
go
IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE ID = object_id(N'spAlterTableSchema') 
	AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE spAlterTableSchema
GO
/*============================================================
SPName:		spAlterTableSchema	
Function:   �޸Ķ��󣨱��洢���̣��ļܹ���
Input:		 
OutPut:		
Author:		 
����        �޸���                 �޸�˵�� 
=================================================================
2013-1-4	wh			create
*/  
CREATE PROC spAlterTableSchema
@currentSchemaName NVARCHAR(30),
@objetName NVARCHAR(30),
@needSchemaName NVARCHAR(30)
AS
BEGIN 
	IF @currentSchemaName IS NULL OR LEN(@currentSchemaName)=0
	BEGIN
		SET @currentSchemaName='dbo'
	END 
	IF @objetName IS NULL OR LEN(@objetName)=0
	BEGIN
		RAISERROR('����:��������Ϊ��',10,1,'')
		RETURN
	END
	
	EXEC dbo.spCheckSchema @schemaName = @needSchemaName 
	DECLARE @sql NVARCHAR(2000)
	SET @sql = 'ALTER SCHEMA ['+ @needSchemaName +'] TRANSFER ['+ @currentSchemaName+'].['+@objetName +']'
	PRINT @sql
	EXEC (@sql)
END
go

  