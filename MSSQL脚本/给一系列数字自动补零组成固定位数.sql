
--给一系列数字自动补零 组成固定位数的sql

declare @count int
set @count = 0
while (@count < 1000)
begin
    print right('000000'+cast(@count as varchar),6)
    set @count = @count +1
end
