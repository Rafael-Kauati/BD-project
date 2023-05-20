use [Routine View]
go

DROP PROCEDURE IF EXISTS GetTasksByUser;
GO

CREATE PROCEDURE GetTasksByUser
    @ID_user INT
AS
BEGIN
    SELECT Code, Title, [Description], Importance, Deadline
    INTO #temp
    FROM [Task]
    WHERE Task.UserID = @ID_user
    --ORDER BY Importance DESC;

    SELECT *
    FROM #temp
    ORDER BY Importance DESC, ABS(DATEDIFF(day, GETDATE(), Deadline));
END
GO

EXEC GetTasksByUser 10;
