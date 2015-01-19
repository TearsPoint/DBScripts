USE PinMeiCoreDB
EXEC dbo.spCheckSchema @schemaName = 'tool' -- nvarchar(30)
 
go
if object_id('tool.sp_FindColumn') is not null
 drop proc tool.sp_FindColumn 
GO
/*   ------------------------------
Name:		 tool.sp_FindColumn
Function:	 ��ѯ��
Parameters:	 
			 
Creator:	 wh      2012-08-22

AlterList
-----------------------------------*/
CREATE PROC tool.sp_FindColumn
@tableName VARCHAR(30),		--����  Ϊ''ʱ����ȫ����
@columnName NVARCHAR(30)	--����  Ϊ''ʱ����ȫ����
AS
BEGIN
	SELECT s.name+'.' [SCHEMA], t.NAME [Table],c.name [Column],ty.name+'('+ CONVERT(NVARCHAR, ty.max_length) +')' [Type] FROM syscolumns AS c
	INNER JOIN (SELECT * FROM sys.tables WHERE name LIKE '%' + @tableName +'%') AS t ON c.id=t.object_id
	INNER JOIN (SELECT * FROM sys.types) AS ty ON ty.system_type_id = c.xtype
	INNER JOIN (SELECT * FROM sys.schemas ) AS s ON s.schema_id=t.schema_id
	AND c.name LIKE '%'+@columnName+'%' 
END
---------------------------------------

GO
