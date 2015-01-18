
go
use master
go
    
if object_id('sp_restoreDB') is not null
 drop proc sp_restoreDB
go
/*   ------------------------------
Name:		 dbo.sp_restoreDB
Function:	 �ָ����ݿ�
Parameters:	 
			 @DBName sysname,--���ݿ���
			 @toFilePath nvarchar(1000)--·���磺c:\
			 
Creator:	 wh      2013-03-14

AlterList
-----------------------------------

*/
create proc sp_restoreDB(
 @DBName sysname,--���ݿ���
 @fromFilePath nvarchar(1000) ,--·���磺c:\
 @toFilePath NVARCHAR(1000)
)
as
declare @S nvarchar(4000),@BackName nvarchar(200) 
declare @dataName nvarchar(4000), @logName nvarchar(4000) 
declare @dataFileName nvarchar(4000), @logFileName nvarchar(4000) 
set @dataName = @DBName;
set @logName = @DBName + '_log';
set @dataFileName = @dataName + '.mdf';
set @logFileName = @logName + '.ldf';
set @S='Restore DATABASE ['+@DBName+'] From  DISK = N'''+@fromFilePath+''' WITH  Recovery, REPLACE, Move '''+ @dataName+ ''' To N''' +@toFilePath + @dataFileName + ''' 
				,Move  '''+ @logName+ ''' To N''' +@toFilePath + @logFileName + '''  '
				PRINT @S;
exec(@S)
go
 
 
 