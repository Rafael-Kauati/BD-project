use [Routine View]
go

drop trigger if exists createTask
go

create trigger createTask on [Task] 
instead of insert 
as 
begin
	DECLARE @Title varchar(100), 
			@Description varchar(100), 
			@Importance int, 
			@Deadline datetime, 
			@UserID int;

	-- Definir o cursor
	DECLARE cursorTasks CURSOR FOR
	SELECT Title, [Description], Importance, Deadline, [UserID]
	FROM inserted;

	OPEN cursorTasks;

	FETCH NEXT FROM cursorTasks INTO @Title, @Description, @Importance, @Deadline, @UserID;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO [Task] (Title, [Description], Importance, Deadline, StackID ,[UserID])
		VALUES (@Title, @Description, @Importance, @Deadline,1 ,@UserID);

		UPDATE [Stack]
		SET CurrMaxTasks = CurrMaxTasks + 1
		WHERE StackID = 1;

		FETCH NEXT FROM cursorTasks INTO @Title, @Description, @Importance, @Deadline, @UserID;
	END;

	CLOSE cursorTasks;

	DEALLOCATE cursorTasks;

end;
go
