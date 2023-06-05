USE [Routine View]
GO

DROP PROCEDURE IF EXISTS finishGroupTask
GO

CREATE PROCEDURE finishGroupTask (@taskGroup varchar(50))
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @unfinishedTasks int;

        SELECT @unfinishedTasks = [Curr_undone_task_num]
        FROM Task_Group
        WHERE Task_Group.Title = @taskGroup;

        IF @unfinishedTasks = 0
        BEGIN
            UPDATE Task_Group
            SET Task_Group.isFinished = 'yes'
            WHERE Task_Group.Title = @taskGroup;

            DECLARE @sumPriority int;

            DECLARE @lastTaskCode int;
            DECLARE @lastTaskDeadline datetime;

            SELECT @sumPriority = sum(TaskPriority)
            FROM getTaskGroup(@taskGroup, 'Done');

            SELECT @lastTaskCode = t.TaskCode, @lastTaskDeadline = t.TaskDeadline
            FROM dbo.getTaskGroup(@taskGroup, 'Done') t
            WHERE t.TaskConclusion = (SELECT max(TaskConclusion) FROM dbo.getTaskGroup(@taskGroup, 'Done'));

            INSERT INTO [Reward] ([Task_code], [Task_Deadline], [Date_Time], [Reward_Value])
            VALUES (@lastTaskCode, ISNULL(@lastTaskDeadline, GETDATE()), GETDATE(), @sumPriority * 2);
        END
        ELSE
        BEGIN
            UPDATE Task_Group
            SET Task_Group.isFinished = 'no'
            WHERE Task_Group.Title = @taskGroup;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
			PRINT 'Error on finishing task group : '+@taskGroup;
            ROLLBACK TRANSACTION;
        END
    END CATCH;
END
GO
