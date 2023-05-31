use [Routine View]
go

drop procedure if exists  addTaskToGroup
go

CREATE PROCEDURE addTaskToGroup
    @TaskGroupTitle varchar(50),
    @TaskTitle varchar(100)
AS
BEGIN
    SET NOCOUNT ON;

	--Update the task with the group code

    DECLARE @TaskGroupCode int;

    SELECT @TaskGroupCode = Code
    FROM Task_Group
    WHERE Title = @TaskGroupTitle;

	UPDATE Task_Group
    SET Curr_undone_task_num = Curr_undone_task_num + 1
    WHERE Title = @TaskGroupTitle;

    UPDATE Task
    SET TaskGroupCode = @TaskGroupCode, Task.[State] = 'ToDo'
    WHERE Title = @TaskTitle;




	--Update the overall priority of the group task
	DECLARE @overrallPrior int;

	select 
		 @overrallPrior = avg([Priority])
	from 
		[Task_Group] g
		join [Task] t on g.Code =  t.TaskGroupCode
	where
		g.Title = @TaskGroupTitle

	update Task_Group
	set Task_Group.OveralPriority = @overrallPrior
	where Task_Group.Title = @TaskGroupTitle;

END
