
USE PinMeiCoreDB
EXEC dbo.spCheckSchema @schemaName = 'tool' -- nvarchar(30)
 
GO

go
if object_id('[tool].[sp_Normalize]') is not null
 drop proc tool.sp_FindColumn 
GO
/*============================================================
SPName:    [tool].[sp_Normalize]
Function:  根据命名规则，生成默认值、外键、主键、索引、字符串列约束等不符合规范的更新脚本
			适用于SQL 2008
InPut:      
OutPut:    
Author:     WW	2013/04/15
修改记录：
  日期       修改人                修改说明
  
exec [tool].[sp_Normalize]
-------------------------------------------------------------

============================================================*/

CREATE PROCEDURE [tool].[sp_Normalize](
	@table varchar(128)='',
	@schema varchar(128)=''
)AS
SET NOCOUNT ON

CREATE TABLE #tTmp (
	ID int IDENTITY(1,1),
	objid int,
	indid int,
	objname varchar(128),
	prefix varchar(128),
	oldname varchar(128),
	newname varchar(128),
	isprimarykey bit
)

CREATE TABLE #tObjectIds(
	ID int,
	schemaname varchar(128) DEFAULT(''),
	fullname varchar(128) DEFAULT('')
)

IF(@table='')
	INSERT INTO #tObjectIds(ID, schemaname, fullname)
	SELECT [object_id],ss.NAME,ss.NAME+'.'+so.NAME
	FROM sys.objects so,sys.schemas ss
	WHERE so.schema_id = ss.schema_id AND type = 'U'
	AND so.NAME NOT LIKE '%删除%' AND so.NAME NOT LIKE '%备份%' AND CHARINDEX('_',so.NAME)<=0 AND CHARINDEX('(',so.NAME)<=0
ELSE IF(charindex('%',@table)>-1)
	INSERT #tObjectIds
	EXECUTE ('SELECT [object_id], ss.name,ss.name+''.''+so.name
		FROM sys.objects so,sys.schemas ss 
		WHERE so.schema_id = ss.schema_id and so.type = ''U'' and so.[name] like''' + @table +'''')
ELSE
	INSERT INTO #tObjectIds(ID,schemaname,fullname)
	SELECT [object_id],ss.NAME,ss.NAME+'.'+so.NAME
	FROM sys.objects so, sys.schemas ss
	WHERE so.schema_id = ss.schema_id AND type = 'U' AND so.[name]=@table

IF(@schema != '')
	DELETE FROM #tObjectIds WHERE schemaname != @schema

INSERT INTO #tTmp(objid, indid, objname, oldname, newname, isprimarykey, prefix)
SELECT [object_id], index_id, oi.fullname+'.'+[name], [name],[name],is_primary_key,
CASE si.type WHEN 1 THEN 'c' ELSE '' END +
CASE is_primary_key WHEN 1 THEN 'pk' ELSE CASE is_unique WHEN 1 THEN 'uidx' ELSE 'idx' END END
FROM sys.indexes si, #tObjectIds oi
WHERE [object_id] = oi.ID
ORDER BY object_name([object_id])

--生成主键名称
UPDATE #tTmp
SET newname = prefix + '_' + object_name(objid)
WHERE isprimarykey = 1

--生成索引名称
DECLARE @id int
DECLARE @objid int
DECLARE @indid int
DECLARE @keyno smallint
DECLARE @FieldName varchar(128)
DECLARE @newname varchar(500)

SET @id = 0
WHILE 1=1
BEGIN
	SELECT TOP 1 @id = ID, @objid = objid, @indid = indid, @newname = prefix + '_' +object_name(objid)
	FROM #tTmp WHERE isprimarykey = 0 AND ID > @id
	IF(@@rowcount=0) GOTO ExitHandle
	
	SET @keyno = -1
	WHILE 1=1
	BEGIN
			SELECT TOP 1 @keyno = ik.keyno, @FieldName = sc.[name]
			FROM sys.syscolumns sc, sys.sysindexkeys ik
			WHERE ik.keyno > @keyno
			AND sc.ID = ik.ID AND sc.colid = ik.colid AND sc.ID = @objid AND ik.indid = @indid
			ORDER BY ik.keyno

			IF(@@rowcount=0) GOTO NextHandle
			
			SET @newname = @newname +'_' + @FieldName
	END
NextHandle:
	UPDATE #tTmp
	SET newname = @newname
	WHERE ID = @id	
END
ExitHandle:

PRINT '--超长表名称'
SELECT '--' + fullname + ','+str(len(object_name([id])))
FROM #tObjectIds 
WHERE len(object_name([id]))>30
ORDER BY fullname

PRINT '--超长字段名称'
SELECT '--' + oi.fullname + ':' + sc.NAME + ',' + str(len(sc.NAME))
FROM #tObjectIds oi, sys.syscolumns sc
WHERE oi.[id]=sc.[id] AND len(sc.NAME)>30
ORDER BY oi.fullname, sc.NAME


PRINT '--重命名主键'
SELECT 'EXEC sp_rename N''' + objname + ''', N''' + newname + ''', N''INDEX'';'
FROM #tTmp
WHERE oldname != newname AND isprimarykey=1
ORDER BY object_name(objid), newname

PRINT '--重命名索引'
SELECT 'EXEC sp_rename N''' + objname + ''', N''' + newname + ''', N''INDEX'';'
FROM #tTmp
WHERE oldname != newname AND isprimarykey=0
ORDER BY object_name(objid), newname


PRINT '-- 重命名外键fk+表名首字符+checksum(表名_列名)'
SELECT 'EXEC sp_rename N''' + oi.schemaname + '.' + so.NAME + ''', N''' + 'fk' + [dbo].[fnAcronyms](object_name(so.parent_obj)) + REPLACE(LTRIM(str(checksum(object_name(so.parent_obj)+'_'+sc.NAME),16)),'-','') + ''';'
--select so.name,sc.name,sr.*
FROM sys.sysobjects so, sys.syscolumns sc, sys.sysreferences sr, #tObjectIds oi
WHERE so.parent_obj = sc.ID AND so.parent_obj = sr.fkeyid AND sc.colid = sr.fkey1
AND sr.constid = so.ID AND so.xtype='F' 
AND so.NAME != 'fk' + [dbo].[fnAcronyms](object_name(so.parent_obj)) + REPLACE(LTRIM(str(checksum(object_name(so.parent_obj)+'_'+sc.NAME),16)),'-','')
AND so.parent_obj = oi.ID

PRINT '-- 重命名默认值DF_表名_列名'
SELECT 'EXEC sp_rename N''' + SCHEMA_NAME(so.uid) + '.' + so.NAME + ''', N''' + 'DF_' + object_name(so.parent_obj) + '_' + sc.NAME + ''';'
FROM sys.sysobjects so, sys.syscolumns sc, sys.sysconstraints st, #tObjectIds oi
WHERE so.parent_obj = sc.ID AND so.parent_obj = st.ID AND sc.colid = st.colid
AND st.constid = so.ID AND so.xtype='D' 
AND so.NAME != 'DF_' + object_name(so.parent_obj) + '_' + sc.NAME
AND so.parent_obj = oi.ID


PRINT '-- 设置字符列允许为空'
SELECT 'ALTER TABLE [' + ss.NAME + '].[' + so.NAME + '] ALTER COLUMN [' + sc.NAME + '] ' + st.NAME + '(' + 
LTRIM(str(CASE sc.user_type_id WHEN 231 THEN sc.max_length/2 WHEN 239 THEN sc.max_length/2 ELSE sc.max_length END)) + ') NULL'
-- select ss.name, so.name, sc.*, st.*,si.*
FROM sys.objects so,sys.schemas ss,sys.systypes st, sys.columns sc LEFT JOIN sys.sysindexkeys si
ON sc.object_id=si.ID AND sc.column_id=si.colid
WHERE so.schema_id = ss.schema_id AND so.type = 'U' AND sc.object_id=so.object_id
AND so.NAME NOT LIKE '%删除%' AND so.NAME NOT LIKE '%备份%' AND CHARINDEX('_',so.NAME)<=0 AND CHARINDEX('(',so.NAME)<=0
AND sc.is_nullable=0 AND sc.max_length>0
AND st.xusertype=sc.user_type_id AND sc.user_type_id IN(167,175,231,239)
AND COALESCE(si.colid,0)=0
ORDER BY ss.NAME, so.NAME, sc.NAME

DROP TABLE #tTmp
DROP TABLE #tObjectIds

SET NOCOUNT OFF
GO
