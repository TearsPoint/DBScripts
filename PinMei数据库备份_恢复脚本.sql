
--
EXEC dbo.sp_backupDB @DBName = 'JX_30_HIS', -- sysname
    @RestoreFiles = N'E:\3.0库备份\' -- nvarchar(1000)
    
EXEC dbo.sp_backupDB @DBName = 'JX_30_CIS', -- sysname
    @RestoreFiles = N'E:\3.0库备份\' -- nvarchar(1000)
     
--RESTORE FILELISTONLY FROM DISK = 'I:\PinMei.Co\DataBase\Backup\PinMeiCoreDB20120809.bak'
EXEC sp_restoreDB @DBName='PinMeiCoreDB', @RestoreFiles ='I:\PinMei.Co\DataBase\Backup\PinMeiCoreDB20120809.bak'
     
       