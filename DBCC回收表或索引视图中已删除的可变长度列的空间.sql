
USE PinMeiCoreDB;
GO
IF OBJECT_ID ('dbo.CleanTableTest', 'U') IS NOT NULL
    DROP TABLE dbo.CleanTableTest;
GO
CREATE TABLE dbo.CleanTableTest
    (
    [ID] int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[Character] nvarchar(10) NOT NULL, 
	[WBCode] nvarchar(10) NOT NULL, 
	[SpellCode] nvarchar(10) NOT NULL, 
	[WBCode1] nvarchar(10) NOT NULL,
	[SpellCode1] nvarchar(10) NOT NULL, 
	[RowVersion] datetime NOT NULL DEFAULT(GETDATE())
    );
GO 

--������Ŀɱ䳤���еĿռ�
DECLARE @db_id SMALLINT;
DECLARE @object_id INT;
SET @db_id = DB_ID(N'PinMeiCoreDB');
SET @object_id = OBJECT_ID(N'PinMeiCoreDB.dbo.CleanTableTest');
SELECT alloc_unit_type_desc, 
       page_count, 
       avg_page_space_used_in_percent, 
       record_count
FROM sys.dm_db_index_physical_stats(@db_id, @object_id, NULL, NULL , 'Detailed');
GO
------------------------------------------------------------------------------------------------

INSERT INTO dbo.CleanTableTest ( Character ,  WBCode , SpellCode ,WBCode1 ,SpellCode1 , RowVersion ) 
SELECT Character ,  WBCode , SpellCode ,WBCode1 ,SpellCode1 , RowVersion FROM config.ChineseCharacterCode
        
----�������ݺ�Ŀɱ䳤���еĿռ�
DECLARE @db_id SMALLINT;
DECLARE @object_id INT;
SET @db_id = DB_ID(N'PinMeiCoreDB');
SET @object_id = OBJECT_ID(N'PinMeiCoreDB.dbo.CleanTableTest');
SELECT alloc_unit_type_desc, 
       page_count, 
       avg_page_space_used_in_percent, 
       record_count
FROM sys.dm_db_index_physical_stats(@db_id, @object_id, NULL, NULL , 'Detailed');
GO

ALTER TABLE dbo.CleanTableTest
DROP COLUMN SpellCode
-- ���л���
DBCC CLEANTABLE (PinMeiCoreDB,"dbo.CleanTableTest"); 

--���л��պ�Ŀɱ䳤���еĿռ�
DECLARE @db_id SMALLINT;
DECLARE @object_id INT;
SET @db_id = DB_ID(N'PinMeiCoreDB');
SET @object_id = OBJECT_ID(N'PinMeiCoreDB.dbo.CleanTableTest');
SELECT alloc_unit_type_desc, 
       page_count, 
       avg_page_space_used_in_percent, 
       record_count
FROM sys.dm_db_index_physical_stats(@db_id, @object_id, NULL, NULL , 'Detailed');
GO



--DECLARE @db_id SMALLINT;
--DECLARE @object_id INT;
--SET @db_id = DB_ID(N'PinMeiCoreDB');
--SET @object_id = OBJECT_ID(N'PinMeiCoreDB.config.ChineseCharacterCode');
--SELECT alloc_unit_type_desc, 
--       page_count, 
--       avg_page_space_used_in_percent, 
--       record_count
--FROM sys.dm_db_index_physical_stats(@db_id, @object_id, NULL, NULL , 'Detailed');


 