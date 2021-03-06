USE PinMeiCoreDB
GO  
EXEC dbo.spCheckSchema @schemaName = 'tool' -- nvarchar(30)

go
IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE ID = object_id(N'tool.sp_FindString') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE tool.sp_FindString
go
/*   ------------------------------
Name:		 tool.[sp_FindString]
Function:	 查找包含目的字符串的表记录（工具存储过程） 
Parameters:	 
			 
Creator:	 wh      2012-08-22

AlterList
-----------------------------------*/
CREATE PROCEDURE [tool].[sp_FindString]
	@chvTarget varchar(128) = ''
AS
BEGIN

if @chvTarget = '' return

SET NOCOUNT ON

DECLARE @tabschema varchar(128), @tabname varchar(128), @colname varchar(128)
DECLARE @lasttabname varchar(128), @lastcolname varchar(128)
DECLARE @criteria varchar(4000), @columns varchar(4000), @sql varchar(8000)

DECLARE col_cursor CURSOR FOR 
SELECT '[' + c.TABLE_SCHEMA + ']', '[' + c.TABLE_NAME + ']', '[' + c.COLUMN_NAME + ']'
FROM INFORMATION_SCHEMA.COLUMNS c, INFORMATION_SCHEMA.TABLES t
WHERE c.TABLE_CATALOG = t.TABLE_CATALOG AND c.TABLE_SCHEMA = t.TABLE_SCHEMA AND c.TABLE_NAME = t.TABLE_NAME
	AND t.TABLE_TYPE = 'BASE TABLE' AND c.DATA_TYPE like '%char%' 
ORDER BY c.TABLE_SCHEMA, c.TABLE_NAME, c.COLUMN_NAME

OPEN col_cursor

FETCH NEXT FROM col_cursor 
INTO @tabschema, @tabname, @colname

SET @lasttabname = ''
SET @columns = ''
SET @criteria = ''

WHILE @@FETCH_STATUS = 0
BEGIN
	IF @lasttabname = '' OR @lasttabname <> @tabschema + '.' + @tabname 
	BEGIN
		IF @lasttabname != ''
		BEGIN
			SET @sql = 'IF EXISTS(SELECT * FROM ' + @lasttabname + ' WHERE ' + @criteria + ')'
				+ char(13)+char(10)+ '	SELECT ''' + @lasttabname + ''' TableName, ' + @columns + ' FROM ' + @lasttabname + ' WHERE ' + @criteria
			--print @sql
			exec(@sql)
		END

		SET @columns = @colname 
		SET @criteria = @colname + ' like ''%' + @chvTarget + '%'''
		SET @lasttabname = @tabschema + '.' + @tabname
	END
	ELSE
	BEGIN
		SET @criteria = @criteria + ' OR ' + @colname + ' like ''%' + @chvTarget + '%'''
		SET @columns = @columns + ', ' + @colname
	END

	-- Get the next col.
	FETCH NEXT FROM col_cursor 
	INTO @tabschema, @tabname, @colname
END 

CLOSE col_cursor
DEALLOCATE col_cursor

SET NOCOUNT OFF 

END
