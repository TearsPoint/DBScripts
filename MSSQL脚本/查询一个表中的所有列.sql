 SELECT s.name [SCHEMA], t.name [Table],c.name [Column],ty.name+'('+ CONVERT(NVARCHAR, ty.max_length) +')' [Type] FROM syscolumns AS c
	INNER JOIN (SELECT * FROM sys.tables WHERE name LIKE '%ClassMetadata%') AS t ON c.id=t.object_id
	INNER JOIN (SELECT * FROM sys.types) AS ty ON ty.system_type_id = c.xtype
	INNER JOIN (SELECT * FROM sys.schemas ) AS s ON s.schema_id=t.schema_id
 ORDER BY C.name
	 
