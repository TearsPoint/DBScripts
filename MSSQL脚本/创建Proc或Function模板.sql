
--��������
IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE ID = object_id(N'[�ܹ���].[������]') AND xtype IN (N'FN', N'IF', N'TF'))
DROP FUNCTION [�ܹ���].[������]
GO
/*============================================================
FunctionName:		
Function:    
Input:		 
OutPut:		
Author:		
����        �޸���                 �޸�˵�� 
=================================================================

*/
CREATE FUNCTION [�ܹ���].[������] (
	@Strs	varchar(8000),
	@Char	varchar(10)
)
RETURNS @tStr TABLE 
	([str] varchar(8000) )
AS
BEGIN

END


--�����洢����
go
IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE ID = object_id(N'[�ܹ���].[�洢������]') 
	AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [�ܹ���].[�洢������] 
GO
/*============================================================
SPName:		
Function:   
Input:		 
OutPut:		
Author:		 
����        �޸���                 �޸�˵�� 
=================================================================

*/  
CREATE PROC [�ܹ���].[�洢������] 
@in_a int  
AS
BEGIN
	
END