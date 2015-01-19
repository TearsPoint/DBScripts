
USE PinMeiCoreDB
EXEC dbo.spCheckSchema @schemaName = 'tool' -- nvarchar(30)
 
go
if object_id('tool.sp_FindColumnInViews') is not null
 drop proc tool.sp_FindColumnInViews 

go
/*   ------------------------------
Name:		 tool.sp_FindColumnInViews
Function:	 ����ͼ�в�ѯ��
Parameters:	 
			 
Creator:	 wh      2013-09-12

AlterList
-----------------------------------*/
CREATE PROC tool.sp_FindColumnInViews
@viewName VARCHAR(30),		--����  Ϊ''ʱ����ȫ����
@columnName NVARCHAR(30)	--����  Ϊ''ʱ����ȫ����
AS
BEGIN
	SELECT s.name [SCHEMA], t.name [View],c.name [Column],ty.name+'('+ CONVERT(NVARCHAR, ty.max_length) +')' [Type] FROM syscolumns AS c
	INNER JOIN (SELECT * FROM sys.views WHERE name LIKE '%' + @viewName +'%') AS t ON c.id=t.object_id 
	INNER JOIN (SELECT * FROM sys.types) AS ty ON ty.system_type_id = c.xtype
	INNER JOIN (SELECT * FROM sys.schemas ) AS s ON s.schema_id=t.schema_id
	AND c.name LIKE '%'+@columnName+'%' 
END
---------------------------------------

GO
