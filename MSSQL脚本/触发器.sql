


--����һ��������
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'��������'))
DROP TRIGGER ��������
GO
/*============================================================
��������:	tr_����_��������_�ֶ���
����:		
����:		wh  
����        �޸���                 �޸�˵�� 
=================================================================

=================================================================
--����  
*/ 
CREATE  TRIGGER tr_articles_update_insert_�ֶ��� ON dbo.Articles
FOR UPDATE,INSERT
AS
BEGIN
	SET NOCOUNT ON
	
	SET NOCOUNT OFF
END



SELECT * FROM dbo.Articles