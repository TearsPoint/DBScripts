


--创建一个触发器
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'触发器名'))
DROP TRIGGER 触发器名
GO
/*============================================================
触发器名:	tr_表名_触发操作_字段名
功能:		
作者:		wh  
日期        修改人                 修改说明 
=================================================================

=================================================================
--测试  
*/ 
CREATE  TRIGGER tr_articles_update_insert_字段名 ON dbo.Articles
FOR UPDATE,INSERT
AS
BEGIN
	SET NOCOUNT ON
	
	SET NOCOUNT OFF
END



SELECT * FROM dbo.Articles