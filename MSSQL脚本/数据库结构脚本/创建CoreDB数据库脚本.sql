

/*
	�������ݿ⽨��
	�����ˣ�����
	�������ڣ�2012-05-18
	---------------------------------------
	�޸�����		�޸���			����
*/
USE master
go
--������ִ��windows����
	EXEC sp_configure 'show advanced options', 1
	GO 
	RECONFIGURE
	GO 
	EXEC sp_configure 'xp_cmdshell', 1
	GO 
	RECONFIGURE
	GO 
-------------------------------------------

--������ڵ�ǰ���ݿ��Ľ��� ����Kill  
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