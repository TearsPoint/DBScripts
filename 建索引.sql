

--为某列创建索引
IF EXISTS (SELECT * FROM dbo.sysindexes WHERE NAME = N'idx_列名' AND ID = object_id(N'表名')) 
	DROP INDEX 表名.[idx_列名]
GO
	CREATE INDEX [idx_列名] ON 表名([列名]) ON [PRIMARY]
GO

--为某列创建聚集索引
IF EXISTS (SELECT * FROM dbo.sysindexes WHERE NAME = N'cidx_列名' AND ID = object_id(N'表名'))
	DROP INDEX 表名.[cidx_列名]
GO
	CREATE  CLUSTERED INDEX [cidx_列名] ON 表名([列名]) ON [PRIMARY]
GO

--SELECT object_id(N'config.ChineseCharacterCode')