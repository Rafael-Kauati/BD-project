use [Routine View]
go

drop procedure if exists  concludeTaskOfTheGroup
go

CREATE PROCEDURE concludeTaskOfTheGroup
    @TaskTitle varchar(100)
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @TaskGroupCode int;

	SELECT @TaskGroupCode = [TaskGroupCode]
	FROM Task
	WHERE Task.Title = @TaskTitle;


	UPDATE Task_Group
    SET Curr_undone_task_num = Curr_undone_task_num - 1
    WHERE Code = @TaskGroupCode;

    UPDATE Task
    SET  Task.[State] = 'Done'
    WHERE Title = @TaskTitle;

END
