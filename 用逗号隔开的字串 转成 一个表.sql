


ALTER FUNCTION [dbo].[fnIDInString] (
	@IDs	varchar(8000)
)
RETURNS @tID TABLE 
	([ID] int )
AS
BEGIN
	DECLARE @ID int
	DECLARE @Pos int
	
	set @IDs = replace(@IDs,' ','')

	while len(@IDs)>0
	begin
		set @Pos = charindex(',',@IDs)
		if @Pos=0
			begin
				set @ID = convert(int,@IDs)
				set @IDs=''
			end
		else
			begin
				set @ID = convert(int,left(@IDs, @Pos-1))
				set @IDs=right(@IDs, len(@IDs)-@Pos)
			end
		INSERT @tID([ID]) values (@ID)
	end
	RETURN 
END






