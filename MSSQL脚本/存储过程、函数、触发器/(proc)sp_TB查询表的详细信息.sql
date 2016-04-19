
USE PinMeiCoreDB
EXEC dbo.spCheckSchema @schemaName = 'tool' -- nvarchar(30)

GO

if object_id('tool.sp_TB') is not null
 drop proc tool.sp_TB
go
/*   ------------------------------
Name:		 dbo.sp_tb
Function:	 查询表详细信息
Parameters:	  
Creator:	 wh      2013-10-21

AlterList
-----------------------------------
*/ 
CREATE procedure [tool].[sp_TB] (@tb varchar(100))        
as        
set @tb=ltrim(rtrim(@tb))        
SELECT        
 --架构=case when a.colorder=1 then ss.name else '----' end,        
 表名=case when a.colorder=1 then ss.name+'.'+rtrim(d.name) else '----' end,        
 说明=case when a.colorder=1 then isnull(f.value,'') else '----' end,        
 --架构= ss.name  ,        
 --表名= d.name  ,        
 --说明=isnull(f.value,''),        
 序=a.colorder,        
 字段名=a.name,        
 ident=case when COLUMNPROPERTY( a.id,a.name,'IsIdentity')=1 then '√'else '' end,        
 主键=case when exists(SELECT 1 FROM sysobjects where xtype='PK' and name in (        
 SELECT name FROM sysindexes WHERE indid in(        
 SELECT indid FROM sysindexkeys WHERE id = a.id AND colid=a.colid        
 ))) then '√' else '' end,        
 类型=b.name,        
 --占用字节数=a.length,        
 长度=COLUMNPROPERTY(a.id,a.name,'PRECISION'),        
 小数位数=isnull(COLUMNPROPERTY(a.id,a.name,'Scale'),0),        
 [NULL]=case when a.isnullable=1 then '√'else '' end,        
 默认值=isnull(e.text,''),        
 字段说明=isnull(g.[value],''),    
 创建=case when a.colorder=1 then (case when d.crdate='1900-1-1' then '' else convert(varchar(111),d.crdate,111) end) else '' end,        
 最后修改=case when a.colorder=1 then (case when d.crdate='1900-1-1' then '' else convert(varchar(111),d.refdate,111) end) else '' end    
FROM syscolumns a        
left join systypes b on a.xusertype=b.xusertype        
inner join sysobjects d on a.id=d.id and d.xtype='U' and d.name<>'dtproperties'        
left join syscomments e on a.cdefault=e.id        
left join sys.extended_properties g on a.id=g.major_id and a.colid=g.minor_id        
left join sys.extended_properties f on d.id=f.major_id and f.minor_id=0        
inner join sys.objects so on a.id=so.object_id and so.type='U'        
inner join sys.schemas ss on so.schema_id=ss.schema_id        
where d.name like (case @tb when '' then d.name else '%'+@tb+'%'  end )        
order by ss.schema_id,d.name,a.colorder        
        
--select uid ,* from  sys.objects  where xtype='u'        
-- select * from syscolumns        
-- select   * from  sys.objects    
-- select   * from  sysobjects         
---- select   * from sys.schemas 
-- select convert(varchar(111),getdate(),111)
--select convert(varchar(111),null,100)
