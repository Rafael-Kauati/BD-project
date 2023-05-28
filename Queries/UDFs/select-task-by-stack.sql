USE [Routine View]
GO
drop function if exists GetAllTasksInStack
go

CREATE FUNCTION GetAllTasksInStack
    (@stackName VARCHAR(40))
RETURNS TABLE
AS
RETURN
(
    SELECT
        t.Code AS TaskCode,
        t.Title AS TaskTitle,
        t.TaskGroupCode AS TaskGroup,
        t.Description AS TaskDescription,
        t.Importance AS TaskImportance,
        t.Deadline AS TaskDeadline,
        t.State AS TaskState,
        t.Priority AS TaskPriority,
        t.StackID,
        t.Conclusion AS TaskConclusion,
        t.UserID
    FROM
        [Stack] s
        JOIN [Task] t ON s.StackID = t.StackID
    WHERE
        s.[Name] = @stackName 
        AND t.TaskGroupCode IS NULL
);
GO
/*
SELECT *
FROM dbo.GetAllTasksInStack('Doing');*/
