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

	select * from [Stack]; 
	select * from [Task]; 
end
go
exec startTask 'Enviar relatório semanal';


