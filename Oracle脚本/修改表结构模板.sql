--�޸ı���
ALTER TABLE �ܹ���.���� RENAME  TO �±���;

--�޸ı��е���
ALTER TABLE ���� MODIFY  ����  ��������;

--�Ѵ��ڵı��е����޸�����
ALTER TABLE  �ܹ���.����  rename COLUMN ���� TO ������;

--�Ѵ��ڵı�������
ALTER TABLE  �ܹ���.����  ADD  ����  ��������   DEFAULT(Ĭ��ֵ) NOT NULL;