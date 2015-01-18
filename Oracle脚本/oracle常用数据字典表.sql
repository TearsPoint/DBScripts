
select 
SYS_CONTEXT('USERENV','TERMINAL') terminal, 
SYS_CONTEXT('USERENV','LANGUAGE') language, 
SYS_CONTEXT('USERENV','SESSIONID') sessionid, 
SYS_CONTEXT('USERENV','INSTANCE') instance, 
SYS_CONTEXT('USERENV','ENTRYID') entryid, 
SYS_CONTEXT('USERENV','ISDBA') isdba, 
SYS_CONTEXT('USERENV','NLS_TERRITORY') nls_territory, 
SYS_CONTEXT('USERENV','NLS_CURRENCY') nls_currency, 
SYS_CONTEXT('USERENV','NLS_CALENDAR') nls_calendar, 
SYS_CONTEXT('USERENV','NLS_DATE_FORMAT') nls_date_format, 
SYS_CONTEXT('USERENV','NLS_DATE_LANGUAGE') nls_date_language, 
SYS_CONTEXT('USERENV','NLS_SORT') nls_sort, 
SYS_CONTEXT('USERENV','CURRENT_USER') current_user, 
SYS_CONTEXT('USERENV','CURRENT_USERID') current_userid, 
SYS_CONTEXT('USERENV','SESSION_USER') session_user, 
SYS_CONTEXT('USERENV','SESSION_USERID') session_userid, 
SYS_CONTEXT('USERENV','PROXY_USER') proxy_user, 
SYS_CONTEXT('USERENV','PROXY_USERID') proxy_userid, 
SYS_CONTEXT('USERENV','DB_DOMAIN') db_domain, 
SYS_CONTEXT('USERENV','DB_NAME') db_name, 
SYS_CONTEXT('USERENV','HOST') host, 
SYS_CONTEXT('USERENV','OS_USER') os_user, 
SYS_CONTEXT('USERENV','EXTERNAL_NAME') external_name, 
SYS_CONTEXT('USERENV','IP_ADDRESS') ip_address, 
SYS_CONTEXT('USERENV','NETWORK_PROTOCOL') network_protocol, 
SYS_CONTEXT('USERENV','BG_JOB_ID') bg_job_id, 
SYS_CONTEXT('USERENV','FG_JOB_ID') fg_job_id, 
SYS_CONTEXT('USERENV','AUTHENTICATION_TYPE') authentication_type, 
SYS_CONTEXT('USERENV','AUTHENTICATION_DATA') authentication_data 
from dual; 

select * from all_tables;
select   *   from   all_triggers ;

select username,default_tablespace from dba_users;
select * from dba_users;

--�鿴��ǰ�û���ȱʡ��ռ�
select username,default_tablespace from user_users;
--�鿴��ǰ�û��Ľ�ɫ
select * from user_role_privs;

--�鿴��ǰ�û���ϵͳȨ�޺ͱ�Ȩ��
select * from user_sys_privs;
select * from user_tab_privs;

--�鿴�û������еı�
select * from user_tables;

 --�鿴�û������еı��������
    select * from USER_TAB_COLUMNS where table_name=:table_Name;

--��ʾ�û���Ϣ(������ռ�)
select default_tablespace,temporary_tablespace 
from dba_users where username='GAME';

--1���û�

--�鿴��ǰ�û���ȱʡ��ռ�
select username,default_tablespace from user_users;

--�鿴��ǰ�û��Ľ�ɫ
select * from user_role_privs;

--�鿴��ǰ�û���ϵͳȨ�޺ͱ�Ȩ��
select * from user_sys_privs;
select * from user_tab_privs;

--��ʾ��ǰ�Ự�����е�Ȩ��
select * from session_privs;

--��ʾָ���û������е�ϵͳȨ��
select * from dba_sys_privs where grantee='GAME';

--��ʾ��Ȩ�û�
select * from v$pwfile_users;

--��ʾ�û���Ϣ(������ռ�)
select default_tablespace,temporary_tablespace 
from dba_users where username='GAME';

--��ʾ�û���PROFILE
select profile from dba_users where username='GAME';


--2����

--�鿴�û������еı�
select * from user_tables;

--�鿴���ư���log�ַ��ı�
select object_name,object_id from user_objects
where instr(object_name,'LOG')>0;

--�鿴ĳ��Ĵ���ʱ��
select object_name,created from user_objects where object_name=upper('&table_name');

--�鿴ĳ��Ĵ�С
select sum(bytes)/(1024*1024) as "size(M)" from user_segments
where segment_name=upper('&table_name');

--�鿴����Oracle���ڴ�����ı�
select table_name,cache from user_tables where instr(cache,'Y')>0;

--3������

--�鿴�������������
select index_name,index_type,table_name from user_indexes order by table_name;

--�鿴�������������ֶ�
select * from user_ind_columns where index_name=upper('&index_name');

--�鿴�����Ĵ�С
select sum(bytes)/(1024*1024) as "size(M)" from user_segments
where segment_name=upper('&index_name');

--4�����к�

--�鿴���кţ�last_number�ǵ�ǰֵ
select * from user_sequences;

--5����ͼ

--�鿴��ͼ������
select view_name from user_views;

--�鿴������ͼ��select���
set view_name,text_length from user_views;
set long 2000; ˵�������Ը�����ͼ��text_lengthֵ�趨set long �Ĵ�С
select text from user_views where view_name=upper('&view_name');

--6��ͬ���

--�鿴ͬ��ʵ�����
select * from user_synonyms;

--7��Լ������

--�鿴ĳ���Լ������
select constraint_name, constraint_type,search_condition, r_constraint_name
from user_constraints where table_name = upper('&table_name');

select c.constraint_name,c.constraint_type,cc.column_name
from user_constraints c,user_cons_columns cc
where c.owner = upper('&table_owner') and c.table_name = upper('&table_name')
and c.owner = cc.owner and c.constraint_name = cc.constraint_name
order by cc.position;

--8���洢�����͹���

--�鿴�����͹��̵�״̬
select object_name,status from user_objects where object_type='FUNCTION';
select object_name,status from user_objects where object_type='PROCEDURE';

--�鿴�����͹��̵�Դ����
select text from all_source where owner=user and name=upper('&plsql_name');