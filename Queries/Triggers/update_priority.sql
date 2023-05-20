USE [Routine View]
GO
DROP TRIGGER if exists update_priority  
go
CREATE TRIGGER update_priority ON Task
AFTER INSERT
AS
BEGIN
    DECLARE @urgency INT;
    DECLARE @urgencyRef varchar(10);
    DECLARE @deadlineRef DATETIME;
    
    DECLARE @taskID INT;
    DECLARE @title VARCHAR(100);
    DECLARE @description VARCHAR(100);
    DECLARE @importance INT;
    DECLARE @deadline DATETIME;
    DECLARE @state VARCHAR(10);
    DECLARE @priority INT;
    DECLARE @stackID INT;
    DECLARE @conclusion DATETIME;
    DECLARE @userID INT;

    DECLARE cursor_tasks CURSOR FOR
    SELECT Code, Title, [Description], Importance, Deadline, [State], [Priority], [StackID], [Conclusion], [UserID]
    FROM inserted;

    OPEN cursor_tasks;
    FETCH NEXT FROM cursor_tasks INTO @taskID, @title, @description, @importance, @deadline, @state, @priority, @stackID, @conclusion, @userID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @deadlineRef = Deadline FROM Task WHERE Code = @taskID;
        SET @urgency = DATEDIFF(MINUTE, GETDATE(), @deadlineRef) / 60;

        PRINT str(@urgency);

        IF 0 <= @urgency AND @urgency <= 24
            set @urgencyRef  = 'High'
        ELSE IF 24 <= @urgency AND @urgency <= 48
            set @urgencyRef  = 'Mid'
        ELSE IF 48 <= @urgency
            set @urgencyRef  = 'Low'

        FETCH NEXT FROM cursor_tasks INTO @taskID, @title, @description, @importance, @deadline, @state, @priority, @stackID, @conclusion, @userID;
    END;

    CLOSE cursor_tasks;
    DEALLOCATE cursor_tasks;
END;
