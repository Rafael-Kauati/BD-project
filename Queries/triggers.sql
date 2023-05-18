use [Routine View]
go

CREATE TRIGGER update_priority ON Task
AFTER INSERT
AS
BEGIN
    UPDATE Task SET Priority = DATEDIFF(hour, Deadline, GETDATE())
    WHERE Code IN (SELECT Code FROM inserted);
END;

CREATE TRIGGER Task_Stack_Assing ON Task
AFTER INSERT
AS
BEGIN
	declare @stack_id int;
	select @stack_id = StackID from inserted;
	update Stack set CurrMaxTasks = CurrMaxTasks  + 1 where StackID = @stack_id;
END;