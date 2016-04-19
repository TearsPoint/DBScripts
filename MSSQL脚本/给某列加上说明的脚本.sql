
 
--给数据库表的某列加上说明 
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'说明',
    @level0type = N'SCHEMA', @level0name = N'架构名', 
    @level1type = N'TABLE', @level1name = N'表名', 
    @level2type = N'COLUMN', @level2name = N'列名'
