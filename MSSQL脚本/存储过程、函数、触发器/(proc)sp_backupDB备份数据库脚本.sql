
go
use master

go
  
if object_id('sp_backupDB') is not null
 drop proc sp_backupDB
go
/*   ------------------------------
Name:		 dbo.sp_backupDB
Function:	 �������ݿ�
Parameters:	 
			 @DBName sysname,--���ݿ���
			 @RestoreFiles nvarchar(1000)--·���磺c:\
Creator:	 wh      2012-08-05

AlterList
-----------------------------------

*/
create proc sp_backupDB(
 @DBName sysname,--���ݿ���
 @RestoreFiles nvarchar(1000)--·���磺c:\
)
as
declare @S nvarchar(4000),@BackName nvarchar(200)
set @BackName=''+@DBName+''+convert(varchar(8),getdate(),112)+'.bak'
set @S='BACKUP DATABASE ['+@DBName+'] TO  DISK = N'''+@RestoreFiles+@BackName+''' WITH NOFORMAT, NOINIT, SKIP, NOREWIND, NOUNLOAD,  STATS = 10'
exec(@S)
go


 