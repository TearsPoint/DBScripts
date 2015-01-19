 
USE CoreDB
go
CREATE SCHEMA role 
go
--�û�������Ϣ��					   

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[role].[UserBaseInfo]') AND OBJECTPROPERTY(ID, N'IsUserTable') = 1)
	DROP TABLE role.UserBaseInfo
GO
CREATE TABLE role.UserBaseInfo
(
	UserId int PRIMARY KEY IDENTITY(1,1),			--�û�ID
	DisplayName nvarchar(100) null,	--�ǳ�
	VerityName nvarchar(10) NULL,	--��ʵ����
	BirthDay DATETIME NULL,
	Age INT NOT NULL CONSTRAINT DF_UAGE DEFAULT(0),
	BloodTypeCodeId int NOT NULL CONSTRAINT DF_UBLOODTYPECODEID	DEFAULT(0)
)

SELECT * FROM role.UserBaseInfo
								  
 



