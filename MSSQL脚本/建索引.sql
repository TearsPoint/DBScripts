

--Ϊĳ�д�������
IF EXISTS (SELECT * FROM dbo.sysindexes WHERE NAME = N'idx_����' AND ID = object_id(N'����')) 
	DROP INDEX ����.[idx_����]
GO
	CREATE INDEX [idx_����] ON ����([����]) ON [PRIMARY]
GO

--Ϊĳ�д����ۼ�����
IF EXISTS (SELECT * FROM dbo.sysindexes WHERE NAME = N'cidx_����' AND ID = object_id(N'����'))
	DROP INDEX ����.[cidx_����]
GO
	CREATE  CLUSTERED INDEX [cidx_����] ON ����([����]) ON [PRIMARY]
GO

--SELECT object_id(N'config.ChineseCharacterCode')