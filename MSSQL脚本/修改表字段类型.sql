
--修改表字段类型

IF EXISTS( SELECT *  FROM syscolumns WHERE [id] =object_id(N'表名') AND [name] = '字段名') 
	ALTER TABLE 表名 ALTER  COLUMN [字段名] [字段类型]   NULL 
GO
