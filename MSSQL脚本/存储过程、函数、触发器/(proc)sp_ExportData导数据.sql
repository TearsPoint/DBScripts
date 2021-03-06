USE PinMeiCoreDB
EXEC dbo.spCheckSchema @schemaName = 'tool' -- nvarchar(30)

go
IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE ID = object_id(N'[sp_ExportData]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [tool].[sp_ExportData]
go
/*   ------------------------------
Name:		[tool].[sp_ExportData]
Function:	 导出指定数据 生成脚本
Parameters:	  	 
Creator:	  WW 2008/11/25 
AlterList
-----------------------------------*/  

CREATE PROCEDURE [tool].[sp_ExportData] 
	@chvTableName varchar(128), 
	@chvColumns varchar(1000)='',
	@chvWhere varchar(1000)='',
	@chvOrder varchar(1000)=''
AS
set nocount on
declare @intID int
declare @chvName varchar(128)
declare @intType int
declare @chvSQLField varchar(8000)
declare @chvSQLValue varchar(8000)
declare @intTemp int
declare @bitIdentity bit
declare @objid int
declare @identityColName varchar(128)

set @objid = object_id(@chvTableName)

create table #temp(
  	[id]  [int] IDENTITY (1, 1) NOT NULL,
	ColName [varchar] (128) NOT NULL,
	Type	[int] NOT NULL)
if @chvColumns=''
begin
	insert into #temp (ColName, Type) 
	select [name],xtype 
	from syscolumns 
	where id = @objid
	order by colid
end else begin
	set @chvColumns = replace(@chvColumns,' ','')
	set @chvColumns = replace(@chvColumns,'[','')
	set @chvColumns = replace(@chvColumns,']','')

	select @chvSQLValue='insert into #temp (ColName, Type) 
	select [name],xtype 
	from syscolumns 
	where id = object_id(''' + @chvTableName + ''')
	and name in (''' + replace(@chvColumns,',',''',''') + ''') order by colid'
	insert into #temp exec( @chvSQLValue )
end

select @bitIdentity = 0
select @identityColName = null
select @identityColName = col_name(@objid, column_id) from sys.identity_columns where object_id = @objid
if @identityColName is not null
	select @bitIdentity = 1

if ltrim(@chvWhere)<>'' select @chvWhere = ' Where ' + @chvWhere
if ltrim(@chvOrder)<>'' select @chvOrder = ' Order by ' + @chvOrder

select @intID = -1
select top 1 @intID = [id], @chvName = '['+ColName+']', @intType = Type from #temp order by [id]
select @chvSQLField = ''
select @chvSQLValue = ''

while coalesce( @intID, -1) > 0
begin
	select @intTemp = case @intType
	when 48  then 0  when  52  then 0  when  56  then 0  when  59  then 0  when  60  then 0  when  62  then 0  when  104  then 0  when  106  then 0  when  108  then 0  when  122  then 0  when  165  then 0  when  173 then 0
	when 36  then 1  when  167  then 1  when  175  then 1  when  231  then 1  when  239 then 1
	when  58  then 2  when  61  then 3  
	else -1 end
	
	if @intTemp > -1
	begin
		if @intTemp>-1 select @chvSQLField = @chvSQLField + ', ' + @chvName

		select @chvSQLValue = @chvSQLValue + case @intTemp
		when 0 then
			' + '', '' + IsNull(convert(varchar(50), ' + @chvName + '), ''Null'')'
		when 1 then
			' + '', '''''' + IsNull(ltrim(rtrim(replace(' + @chvName + ',char(39),char(39)+char(39)))), ''Null'') + '''''''''
		when 2 then
			' + '', '''''' + IsNull(rtrim(convert(char(17),' + @chvName + ',120)), ''Null'') + ''00'' + '''''''''
		when 3 then
			' + '', '''''' + IsNull(rtrim(convert(char(19),' + @chvName + ',120)), ''Null'') + '''''''''
		else
			''
		end
	end
	delete #temp where [id] = @intID
	select @intID = -1
	select top 1 @intID = [id], @chvName = '['+ColName+']', @intType = Type from #temp order by [id]
end

select @chvSQLField = 'insert into ' + @chvTableName + '( ' + substring( @chvSQLField , 2 , len(@chvSQLField)) + ' ) values '
select @chvSQLValue ='Select +''( ''' +  substring( @chvSQLValue , 8 , len(@chvSQLValue)) + ' + '' )'' as Value from ' + @chvTableName + @chvWhere + @chvOrder

create table #Value(
	[id]  [int] IDENTITY (1, 1) NOT NULL,
	[Value] varchar(4000) NOT NUll
)

--print @chvSQLField
--print @chvSQLValue

insert into #value exec( @chvSQLValue )

print '-- Record of ' + @chvTableName
if exists (select top 1 * from #Value)
begin
	if @bitIdentity = 1
		print 'SET IDENTITY_INSERT ' + @chvTableName + ' ON'
	
	select @intID = -1
	select top 1 @intID = [id], @chvSQLValue = [Value] from #Value order by [id]
	while coalesce( @intID, -1) > 0
	begin
		print @chvSQLField
		print '     ' + replace(@chvSQLValue, '''Null''', 'Null')
		delete #Value where [id] = @intID
		select @intID = -1
		select top 1 @intID = [id], @chvSQLValue = [Value] from #Value order by [id]
	end
	
	if @bitIdentity = 1
		print 'SET IDENTITY_INSERT ' + @chvTableName + ' OFF'
end
print ''


set nocount off
drop table #temp
drop table #Value

go

