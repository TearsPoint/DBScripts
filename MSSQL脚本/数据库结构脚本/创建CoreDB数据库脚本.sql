

/*
	核心数据库建立
	创建人：王衡
	创建日期：2012-05-18
	---------------------------------------
	修改日期		修改人			详情
*/
USE master
go
--启动可执行windows命令
	EXEC sp_configure 'show advanced options', 1
	GO 
	RECONFIGURE
	GO 
	EXEC sp_configure 'xp_cmdshell', 1
	GO 
	RECONFIGURE
	GO 
-------------------------------------------

--如果存在当前数据库活动的进程 立马Kill  
DECLARE @spid INT
SELECT @spid = spid from master..sysprocesses where dbid=db_id('CoreDB')
IF(@spid>0)  EXEC (' KILL ' + @spid)   
--------------------------------------------

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='CoreDB')
	DROP DATABASE CoreDB
	
 CREATE DATABASE CoreDB
 ON
 (
	 NAME='PinMeiCoreDB',
	 FILENAME='E:\PinMei.Co\Bin\DataBase\PinMeiCoreDB_data.mdf' 
 )
 LOG ON
 (	  
	NAME='PinMeiCoreDB_log',
	FILENAME ='E:\PinMei.Co\Bin\DataBase\PinMeiCoreDB_log.ldf'
 )



--SELECT *  from master..sysprocesses where dbid=db_id('CoreDB')