USE PinMeiCoreDB
EXEC dbo.spCheckSchema @schemaName = 'tool' -- nvarchar(30)
 						    
IF EXISTS ( SELECT  * FROM    sys.objects  WHERE   object_id =  OBJECT_ID('tool.sp_ExportDataEx') ) 
    DROP PROC tool.sp_ExportDataEx
go
/*   ------------------------------
Name:		 tool.sp_ExportDataEx
Function:	 导出表中全部数据
Parameters:	 
			 @tablename sysname  --表名
Creator:	 wh      2012-08-05

AlterList
-----------------------------------
*/

CREATE PROCEDURE tool.sp_ExportDataEx 
	@tablename SYSNAME --表名
AS 
    DECLARE @column VARCHAR(1000) 
    DECLARE @columndata VARCHAR(1000) 
    DECLARE @sql VARCHAR(4000) 
    DECLARE @xtype TINYINT 
    DECLARE @name SYSNAME 
    DECLARE @objectId INT 
    DECLARE @objectname SYSNAME 
    DECLARE @ident INT 
    SET nocount ON 
    SET @objectId = OBJECT_ID(@tablename) 
    IF @objectId IS NULL -- 判断对象是否存在 
        BEGIN 
            PRINT ' The object not exists ' 
            RETURN 
        END 
    SET @objectname = RTRIM(OBJECT_NAME(@objectId)) 
    IF @objectname IS NULL
        OR CHARINDEX(@objectname, @tablename) = 0 -- 此判断不严密 
        BEGIN 
            PRINT ' object not in current database ' 
            RETURN 
        END 
    IF OBJECTPROPERTY(@objectId, ' IsTable ') < > 1 -- 判断对象是否是table 
        BEGIN 
            PRINT ' The object is not table ' 
            RETURN 
        END 
    SELECT  @ident = status & 0x80
    FROM    syscolumns
    WHERE   id = @objectid
            AND status & 0x80 = 0x80 
    IF @ident IS NOT NULL 
        PRINT ' SET IDENTITY_INSERT ' + @TableName + ' ON ' 
    DECLARE syscolumns_cursor CURSOR
    FOR
        SELECT  c.name ,
                c.xtype
        FROM    syscolumns c
        WHERE   c.id = @objectid
        ORDER BY c.colid 
    OPEN syscolumns_cursor 
    SET @column = '' 
    SET @columndata = '' 
    FETCH NEXT FROM syscolumns_cursor INTO @name, @xtype 
    WHILE @@fetch_status < > -1 
        BEGIN 
            IF @@fetch_status < > -2 
                BEGIN 
                    IF @xtype NOT IN ( 189, 34, 35, 99, 98 ) -- timestamp不需处理，image,text,ntext,sql_variant 暂时不处理 
                        BEGIN 
                            SET @column = @column
                                + CASE WHEN LEN(@column) = 0 THEN ''
                                       ELSE ' , '
                                  END + @name 
                            SET @columndata = @columndata
                                + CASE WHEN LEN(@columndata) = 0 THEN ''
                                       ELSE ' , '' , '' , '
                                  END
                                + CASE WHEN @xtype IN ( 167, 175 )
                                       THEN ''''''''' + ' + @name
                                            + ' + ''''''''' -- varchar,char 
                                       WHEN @xtype IN ( 231, 239 )
                                       THEN ''' N '''''' + ' + @name
                                            + ' + ''''''''' -- nvarchar,nchar 
                                       WHEN @xtype = 61
                                       THEN ''''''''' +convert(char(23), '
                                            + @name + ' ,121)+ ''''''''' -- datetime 
                                       WHEN @xtype = 58
                                       THEN ''''''''' +convert(char(16), '
                                            + @name + ' ,120)+ ''''''''' -- smalldatetime 
                                       WHEN @xtype = 36
                                       THEN ''''''''' +convert(char(36), '
                                            + @name + ' )+ ''''''''' -- uniqueidentifier 
                                       ELSE @name
                                  END 
                        END 
                END 
            FETCH NEXT FROM syscolumns_cursor INTO @name, @xtype 
        END 
    CLOSE syscolumns_cursor 
    DEALLOCATE syscolumns_cursor 
    SET @sql = ' set nocount on select '' insert ' + @tablename + ' ( '
        + @column + ' ) values( '' as '' -- '' , ' + @columndata
        + ' , '' ) '' from ' + @tablename 
    PRINT ' -- ' + @sql 
    EXEC ( @sql ) 
    IF @ident IS NOT NULL 
        PRINT ' SET IDENTITY_INSERT ' + @TableName + ' OFF ' 
GO

  