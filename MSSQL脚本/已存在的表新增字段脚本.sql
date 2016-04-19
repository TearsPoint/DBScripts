
--已存在的表新增字段

IF NOT EXISTS( SELECT *  FROM syscolumns WHERE [id] =object_id(N'表名') AND [name] = '字段名') 
	ALTER TABLE 表名 ADD [字段名] [字段类型]   NULL 
GO
