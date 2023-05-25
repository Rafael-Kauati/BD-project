use [Routine View]
go

--DROP PROCEDURE IF EXISTS GetTasksByUser GO;

/* CREATE PROCEDURE GetTasksByUser
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

EXEC GetTasksByUser 10;*/

drop function  if exists GetTasksByUser 
go

CREATE FUNCTION GetTasksByUser (@ID_user INT)
RETURNS @table TABLE (
    Code INT,
    Title VARCHAR(50),
    [Description] VARCHAR(100),
    Importance INT,
    Deadline DATE
)
AS
BEGIN
    DECLARE @temp TABLE (
        Code INT,
        Title VARCHAR(50),
        [Description] VARCHAR(100),
        Importance INT,
        Deadline DATE
    );

    INSERT INTO @temp (Code, Title, [Description], Importance, Deadline)
    SELECT Code, Title, [Description], Importance, Deadline
    FROM [Task]
    WHERE [Task].UserID = @ID_user;

    INSERT INTO @table (Code, Title, [Description], Importance, Deadline)
    SELECT Code, Title, [Description], Importance, Deadline
    FROM @temp
    ORDER BY Importance DESC, ABS(DATEDIFF(day, GETDATE(), Deadline));

    RETURN;
END
GO

select * from GetTasksByUser(10);

