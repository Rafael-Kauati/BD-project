use [Routine View]
go

CREATE TRIGGER Task_Stack_Assing ON Task
AFTER INSERT, UPDATE
AS
BEGIN
	UPDATE Stack
    SET CurrMaxTasks = CurrMaxTasks + 1
    WHERE StackID IN (SELECT StackID FROM inserted);
END;