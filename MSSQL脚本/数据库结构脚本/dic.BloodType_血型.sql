 
USE CoreDB
go
CREATE SCHEMA dic 
go
--�û�������Ϣ��		 

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dic].[BloodType]') AND OBJECTPROPERTY(ID, N'IsUserTable') = 1)
	DROP TABLE dic.BloodType
GO
CREATE TABLE dic.BloodType
(
	ID int IDENTITY(1,1),			--�û�ID
	DisplayName nvarchar(100) null,	--�ǳ�	  
	WBCode nvarchar (10) COLLATE Chinese_PRC_CI_AS NOT NULL,
	SpellCode nvarchar (10) COLLATE Chinese_PRC_CI_AS NOT NULL
)
GO
ALTER TABLE dic.BloodType ADD CONSTRAINT [PK_BLOODTYPEID] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO

INSERT INTO dic.BloodType ( DisplayName, WBCode, SpellCode )
VALUES  ( 'A��', 'AGAJ',  ''  )
INSERT INTO dic.BloodType ( DisplayName, WBCode, SpellCode )
VALUES  ( 'AB��', 'ABGA',  ''  )
INSERT INTO dic.BloodType ( DisplayName, WBCode, SpellCode )
VALUES  ( 'O��', 'OGAJ',  ''  )
GO
SELECT * FROM dic.BloodType
										   
				    