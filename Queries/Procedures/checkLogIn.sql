use [Routine View]
go

DROP PROCEDURE IF EXISTS checkLogIn;
GO

CREATE PROCEDURE checkLogIn
   ( @email varchar(40),
	@password varchar(40),
	 @confirmation int OUTPUT)
AS
BEGIN
	declare @matches  int ;
	select @matches =  count(*) from [User] 
	where [User].Email = @email and [User].[Password] = @password;
	
	IF @matches = 1
		set @confirmation = 1;
	ELSE
		set @confirmation = 0;

	return @confirmation;
		
END
GO



