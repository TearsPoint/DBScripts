
--��һϵ�������Զ����� ��ɹ̶�λ����sql

declare @count int
set @count = 0
while (@count < 1000)
begin
    print right('000000'+cast(@count as varchar),6)
    set @count = @count +1
end
