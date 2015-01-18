
--sql server
SELECT s.name [SCHEMA], t.name [Table],c.name [Column],ty.name+'('+ CONVERT(NVARCHAR, ty.max_length) +')' [Type] FROM syscolumns AS c
INNER JOIN (SELECT * FROM sys.tables WHERE name LIKE '%ClassMetadata%') AS t ON c.id=t.object_id
INNER JOIN (SELECT * FROM sys.types) AS ty ON ty.system_type_id = c.xtype
INNER JOIN (SELECT * FROM sys.schemas ) AS s ON s.schema_id=t.schema_id
ORDER BY C.name
 
 
--oracle   
select * from all_TAB_COLUMNS where  TABLE_NAME LIKE upper('%ClassMetadata%') order by COLUMN_NAME
select * from all_TAB_COLUMNS where  TABLE_NAME LIKE upper('%Nurse%') order by COLUMN_NAME
  
SELECT * FROM dba_tables where owner like '%ENTITY%'
SELECT * FROM dba_views where owner like '%ENTITY%'

SELECT * FROM core.ClassMetadata;


 
