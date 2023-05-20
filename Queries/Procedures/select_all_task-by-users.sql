DROP PROCEDURE IF EXISTS GetTasksByUser;
GO

CREATE PROCEDURE GetTasksByUser
    @ID_user INT
AS
BEGIN
    SELECT Code, Title, [Description], Importance, Deadline
    INTO #Hello
    FROM Task
    WHERE Task.UserID = @ID_user
    ORDER BY Importance DESC;

    SELECT *
    FROM #Hello
    ORDER BY Importance DESC, ABS(DATEDIFF(day, GETDATE(), Deadline));
END
GO

EXEC GetTasksByUser 10;
