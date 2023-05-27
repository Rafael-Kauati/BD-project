use [Routine View]
go

drop procedure if exists startTask
go

create procedure startTask(@taskname varchar(30))
as
begin

	
	update [Task]
	set StackID = 2
	where Task.Title = @taskname;

	update [Stack]
	set CurrMaxTasks = CurrMaxTasks + 1
	where [Stack].StackID = 2;



	update [Stack]
	set CurrMaxTasks = CurrMaxTasks - 1
	where [Stack].StackID = 1;

	
end
go


