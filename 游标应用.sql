

--�α�Ӧ��

DECLARE @Id INT 
--�����α�  
DECLARE tempCursor CURSOR
FOR SELECT DISTINCT [�α���] FROM [��] WHERE [����]
 
OPEN tempCursor  --���α�
WHILE(1=1)
BEGIN 
	FETCH NEXT FROM tempCursor INTO @Id  --������
	IF(@@FETCH_STATUS!=0)  --�α�״̬������0ʱ�˳�
		BREAK 
	PRINT @Id  
	[��ش���]
END 

CLOSE tempCursor   --�ر��α�
DEALLOCATE tempCursor --�����α�

 
