use [Routine View]
go

CREATE TRIGGER update_priority ON Task
AFTER INSERT
AS
BEGIN
    UPDATE Task SET Priority = DATEDIFF(hour, Deadline, GETDATE())
    WHERE Code IN (SELECT Code FROM inserted);
END;

