USE PinMeiCoreDB
GO 
 
EXEC dbo.spCheckSchema @schemaName = 'tool' -- nvarchar(30)
 
IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE ID = object_id(N'[tool].[sp_RenameEx]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE tool.sp_RenameEx
go
/*   ------------------------------
Name:		 [tool].[sp_RenameEx]
Function:	 根据命名规则，生成重命名默认值、外键、主键及索引的脚本
Parameters:	  	 
Creator:	  WW 2008/11/25 
AlterList
-----------------------------------*/  
-- 
-- 
--
CREATE PROCEDURE [tool].[sp_RenameEx](
	@table varchar(128)='',
	@schema varchar(128)=''
)AS
SET NOCOUNT ON

CREATE Table #tTmp (
	id int identity(1,1),
	objid int,
	indid int,
	objname varchar(128),
	prefix varchar(128),
	oldname varchar(128),
	newname varchar(128),
	isprimarykey bit
)

CREATE Table #tObjectIds(
	id int,
	schemaname varchar(128) default(''),
	fullname varchar(128) default('')
)

IF(@table='')
	INSERT INTO #tObjectIds(id, schemaname, fullname)
	SELECT [object_id],ss.name,ss.name+'.'+so.name
	FROM sys.objects so,sys.schemas ss
	WHERE so.schema_id = ss.schema_id and type = 'U'
ELSE IF(charindex('%',@table)>-1)
	INSERT #tObjectIds
	EXECUTE ('SELECT [object_id], ss.name,ss.name+''.''+so.name
		FROM sys.objects so,sys.schemas ss 
		WHERE so.schema_id = ss.schema_id and so.type = ''U'' and so.[name] like''' + @table +'''')
ELSE
	INSERT INTO #tObjectIds(id,schemaname,fullname)
	SELECT [object_id],ss.name,ss.name+'.'+so.name
	FROM sys.objects so, sys.schemas ss
	WHERE so.schema_id = ss.schema_id and type = 'U' and so.[name]=@table

IF(@schema != '')
	DELETE FROM #tObjectIds where schemaname != @schema

insert into #tTmp(objid, indid, objname, oldname, newname, isprimarykey, prefix)
select [object_id], index_id, oi.fullname+'.'+[name], [name],[name],is_primary_key,
case [type] when 1 then 'c' else '' end + 
case when is_primary_key = 1 then 'pk' when is_unique = 1 then 'uix' else 'ix' end
from sys.indexes si, #tObjectIds oi
where [object_id] = oi.id
order by object_name([object_id])

--生成主键名称
update #tTmp
set newname = prefix +'_'+ object_name(objid)
where isprimarykey = 1

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
	SELECT top 1 @id = id, @objid = objid, @indid = indid, @newname = prefix
	FROM #tTmp WHERE isprimarykey = 0 and id > @id
	IF(@@rowcount=0) GOTO ExitHandle
	
	SET @keyno = -1
	WHILE 1=1
	BEGIN
			SELECT top 1 @keyno = ik.keyno, @FieldName = sc.[name]
			FROM sys.syscolumns sc, sys.sysindexkeys ik
			WHERE ik.keyno > @keyno
			and sc.id = ik.id and sc.colid = ik.colid and sc.id = @objid and ik.indid = @indid
			order by ik.keyno

			IF(@@rowcount=0) GOTO NextHandle
			
			SET @newname = @newname + '_' + @FieldName
	END
NextHandle:
	update #tTmp
	set newname = @newname
	where id = @id	
END
ExitHandle:

PRINT '--重命名索引和主键'
select 'EXEC sp_rename N''' + objname + ''', N''' + newname + ''', N''INDEX'';'
from #tTmp
where oldname != newname
order by object_name(objid), isprimarykey desc, newname


PRINT '-- 重命名外键'
select 'EXEC sp_rename N''' + oi.schemaname + '.' + so.name + ''', N''' + case sr.keycnt when 1 then 'FK_' + object_name(so.parent_obj) + '_' + sc.name + '_' + object_name(sr.rkeyid) else 'FK_' + object_name(so.parent_obj) + '_' + object_name(sr.rkeyid) end + ''';'
--select so.name,sc.name,sr.*
from sys.sysobjects so, sys.syscolumns sc, sys.sysreferences sr, #tObjectIds oi
where so.parent_obj = sc.id and so.parent_obj = sr.fkeyid and sc.colid = sr.fkey1
and sr.constid = so.id and so.xtype='F' 
and so.name != case sr.keycnt when 1 then 'FK_' + object_name(so.parent_obj) + '_' + sc.name + '_' + object_name(sr.rkeyid) else 'FK_' + object_name(so.parent_obj) + '_' + object_name(sr.rkeyid) end
and so.parent_obj = oi.id

PRINT '-- 重命名默认值'
select 'EXEC sp_rename N''' + oi.schemaname + '.' + so.name + ''', N''' + 'DF_' + object_name(so.parent_obj) + '_' + sc.name + ''';'
from sys.sysobjects so, sys.syscolumns sc, sys.sysconstraints st, #tObjectIds oi
where so.parent_obj = sc.id and so.parent_obj = st.id and sc.colid = st.colid
and st.constid = so.id and so.xtype='D' 
and so.name != 'DF_'+object_name(so.parent_obj) + '_' + sc.name
and so.parent_obj = oi.id

drop table #tTmp
drop table #tObjectIds

SET NOCOUNT OFF
