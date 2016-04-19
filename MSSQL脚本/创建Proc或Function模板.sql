
--创建函数
IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE ID = object_id(N'[架构名].[函数名]') AND xtype IN (N'FN', N'IF', N'TF'))
DROP FUNCTION [架构名].[函数名]
GO
/*============================================================
FunctionName:		
Function:    
Input:		 
OutPut:		
Author:		
日期        修改人                 修改说明 
=================================================================

*/
CREATE FUNCTION [架构名].[函数名] (
	@Strs	varchar(8000),
	@Char	varchar(10)
)
RETURNS @tStr TABLE 
	([str] varchar(8000) )
AS
BEGIN

END


--创建存储过程
go
IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE ID = object_id(N'[架构名].[存储过程名]') 
	AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [架构名].[存储过程名] 
GO
/*============================================================
SPName:		
Function:   
Input:		 
OutPut:		
Author:		 
日期        修改人                 修改说明 
=================================================================

*/  
CREATE PROC [架构名].[存储过程名] 
@in_a int  
AS
BEGIN
	
END