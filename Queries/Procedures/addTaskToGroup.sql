USE [Routine View]
GO

DROP PROCEDURE IF EXISTS addTaskToGroup
GO

CREATE PROCEDURE addTaskToGroup
    @TaskGroupTitle varchar(50),
    @TaskTitle varchar(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @ErrorUpdates TABLE (
            TaskTitle varchar(100),
            TaskGroupTitle varchar(50)
        );

        BEGIN TRANSACTION;

        -- Update the task with the group code
        DECLARE @TaskGroupCode int;

        SELECT @TaskGroupCode = Code
        FROM Task_Group
        WHERE Title = @TaskGroupTitle;

        UPDATE Task_Group
        SET Curr_undone_task_num = Curr_undone_task_num + 1
        WHERE Title = @TaskGroupTitle;

        IF @@ROWCOUNT = 0
        BEGIN
            INSERT INTO @ErrorUpdates (TaskTitle, TaskGroupTitle)
            VALUES (@TaskTitle, @TaskGroupTitle);
        END

        UPDATE Task
        SET TaskGroupCode = @TaskGroupCode, Task.[State] = 'ToDo'
        WHERE Title = @TaskTitle;

        IF @@ROWCOUNT = 0
        BEGIN
            INSERT INTO @ErrorUpdates (TaskTitle, TaskGroupTitle)
            VALUES (@TaskTitle, @TaskGroupTitle);
        END

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
        BEGIN
            PRINT 'Error on adding task ' + @TaskTitle + ' to group ' + @TaskGroupTitle;
            ROLLBACK TRANSACTION;
        END
    END CATCH;
END
GO
