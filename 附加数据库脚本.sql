

USE master

DROP DATABASE HappyInteractionDB
DROP DATABASE db_HR
DROP DATABASE HotelManagerDB

Exec sp_attach_db @dbname=N'HappyInteractionDB', 
@filename1=N'E:\PinMei.Co\Demo\Y2毕业设计\DB\HappyInteractionDB_data.mdf', 
@filename2=N'E:\PinMei.Co\Demo\Y2毕业设计\DB\HappyInteractionDB_log.ldf'



Exec sp_attach_db @dbname=N'db_HR', 
@filename1=N'E:\PinMei.Co\Demo\S2毕业设计\DataBase\db_HR.mdf', 
@filename2=N'E:\PinMei.Co\Demo\S2毕业设计\DataBase\db_HR.ldf'

 

Exec sp_attach_db @dbname=N'HotelManagerDB', 
@filename1=N'E:\PinMei.Co\Demo\酒店管理系统\DB\HotelManagerDB_data.mdf', 
@filename2=N'E:\PinMei.Co\Demo\酒店管理系统\DB\HotelManagerDB_log.ldf'


Exec sp_attach_db @dbname=N'PinMeiCoreDB', 
@filename1=N'E:\PinMei.Co\Bin\DataBase\PinMeiCoreDB_data.mdf', 
@filename2=N'E:\PinMei.Co\Bin\DataBase\PinMeiCoreDB_log.ldf' 