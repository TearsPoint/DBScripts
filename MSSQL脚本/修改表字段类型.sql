
--�޸ı��ֶ�����

IF EXISTS( SELECT *  FROM syscolumns WHERE [id] =object_id(N'����') AND [name] = '�ֶ���') 
	ALTER TABLE ���� ALTER  COLUMN [�ֶ���] [�ֶ�����]   NULL 
GO
