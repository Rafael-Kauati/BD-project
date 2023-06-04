DROP PROCEDURE IF EXISTS addTaskToGroup;
GO

CREATE PROCEDURE addTaskToGroup
    @TaskGroupTitle varchar(50),
    @TaskTitle varchar(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Update the task with the group code
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

        -- Update the overall priority of the group task
        DECLARE @overallPrior int;

        SELECT @overallPrior = AVG([Priority])
        FROM [Task_Group] g
        JOIN [Task] t ON g.Code = t.TaskGroupCode
        WHERE g.Title = @TaskGroupTitle;

        UPDATE Task_Group
        SET Task_Group.OveralPriority = @overallPrior
        WHERE Task_Group.Title = @TaskGroupTitle;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

    END CATCH;
END;
GO
------------------------------------------------
DROP PROCEDURE IF EXISTS concludeTaskOfTheGroup;
GO

CREATE PROCEDURE concludeTaskOfTheGroup
    @TaskTitle varchar(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @TaskGroupCode int;

        SELECT @TaskGroupCode = [TaskGroupCode]
        FROM Task
        WHERE Task.Title = @TaskTitle;

        UPDATE Task_Group
        SET Curr_undone_task_num = Curr_undone_task_num - 1
        WHERE Code = @TaskGroupCode;

        UPDATE Task
        SET Task.[State] = 'Done', Task.Conclusion = GETDATE()
        WHERE Title = @TaskTitle;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
    END CATCH;
END;
GO

-----------------------------------------------
DROP PROCEDURE IF EXISTS concludeTask;
GO

CREATE PROCEDURE concludeTask
(@taskname VARCHAR(30))
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @taskcode INT;
        DECLARE @taskdeadline DATETIME;
        DECLARE @taskpriority INT;

        SELECT @taskcode = Code, @taskdeadline = Deadline, @taskpriority = [Priority]
        FROM [Task]
        WHERE Title = @taskname;

        UPDATE [Task]
        SET StackID = 3, Task.Conclusion = GETDATE()
        WHERE Title = @taskname;

        UPDATE [Stack]
        SET CurrMaxTasks = CurrMaxTasks + 1
        WHERE [Stack].StackID = 3;

        UPDATE [Stack]
        SET CurrMaxTasks = CurrMaxTasks - 1
        WHERE [Stack].StackID = 2;

        INSERT INTO [Reward] ([Task_code], [Task_Deadline], [Date_Time], [Reward_Value])
        VALUES (@taskcode, ISNULL(@taskdeadline, GETDATE()), GETDATE(), @taskpriority * 2);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
    END CATCH;
END;
GO
-----------------------------------------------

DROP PROCEDURE IF EXISTS startTask;
GO

CREATE PROCEDURE startTask(@taskname varchar(30))
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [Task]
        SET StackID = 2
        WHERE Task.Title = @taskname;

        UPDATE [Stack]
        SET CurrMaxTasks = CurrMaxTasks + 1
        WHERE [Stack].StackID = 2;

        UPDATE [Stack]
        SET CurrMaxTasks = CurrMaxTasks - 1
        WHERE [Stack].StackID = 1;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
    END CATCH;
END;
GO
-----------------------------------------------

DROP PROCEDURE IF EXISTS finishGroupTask;
GO

CREATE PROCEDURE finishGroupTask(@taskGroup varchar(50))
AS
BEGIN
	declare @unfinishedTasks int;

	SELECT @unfinishedTasks = [Curr_undone_task_num]
	FROM Task_Group
	WHERE Task_Group.Title = @taskGroup;

	-- Verificar se @unfinishedTasks é igual a zero
	IF @unfinishedTasks = 0
	BEGIN
		UPDATE Task_Group
		SET Task_Group.isFinished = 'yes'
		WHERE Task_Group.Title =  @taskGroup;

		DECLARE @sumPriority int;

		DECLARE @lastTaskCode int;
		DECLARE @lastTaskDeadline datetime;

		SELECT @sumPriority = sum(TaskPriority)
		FROM getTaskGroup(@taskGroup, 'Done');

		SELECT @lastTaskCode = t.TaskCode, @lastTaskDeadline = t.TaskDeadline
		FROM dbo.getTaskGroup(@taskGroup, 'Done') t
		WHERE t.TaskConclusion = (SELECT max(TaskConclusion) FROM dbo.getTaskGroup(@taskGroup, 'Done'));

		INSERT INTO [Reward] ([Task_code], [Task_Deadline], [Date_Time], [Reward_Value])
        VALUES (@lastTaskCode, 
		ISNULL(@lastTaskDeadline, 
		GETDATE()), 
		GETDATE(), @sumPriority * 2);

	END
	ELSE
	BEGIN
		UPDATE Task_Group
		SET Task_Group.isFinished = 'no'
		WHERE Task_Group.Title =  @taskGroup;
	END
END;
GO


drop procedure if exists createTaskGroup
go


create procedure createTaskGroup
	(@title varchar(50),
	@desc varchar(100),
	@crit varchar(20)
	)
as
begin

	declare @asscode int;

	select @asscode = Assoc_Code
	from Task_Group_Assoc
	where Task_Group_Assoc.CriteriaType = @crit;

	insert into [Task_Group]
	([Title], [Description], [DateOfCreation], [Assoc_code])
	values 
	(@title,@desc, GETDATE(), @asscode );
end;
go


