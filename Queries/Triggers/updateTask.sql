use [Routine View]
go

DROP TRIGGER IF EXISTS updateTask;
GO

CREATE TRIGGER updateTask ON [Task]
INSTEAD OF UPDATE
AS
BEGIN
    DECLARE @Title VARCHAR(100),
            @Description VARCHAR(100),
            @Importance INT,
            @Deadline DATETIME;

    DECLARE cursorTasks CURSOR FOR
        SELECT Title, [Description], Importance, Deadline
        FROM inserted;

    OPEN cursorTasks;

    FETCH NEXT FROM cursorTasks INTO @Title, @Description, @Importance, @Deadline;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE t
        SET t.Title = ISNULL(i.Title, t.Title),
            t.[Description] = ISNULL(i.[Description], t.[Description]),
            t.Importance = ISNULL(i.Importance, t.Importance),
            t.Deadline = ISNULL(i.Deadline, t.Deadline)
        FROM [Task] t
        INNER JOIN inserted i ON t.[Code] = i.[Code];

        FETCH NEXT FROM cursorTasks INTO @Title, @Description, @Importance, @Deadline;
    END;

    CLOSE cursorTasks;
    DEALLOCATE cursorTasks;
END;
GO
