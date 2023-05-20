use [Routine View]
go

drop procedure if exists concludeTask
go

create procedure concludeTask(@taskname varchar(30))
as
begin
	update [Task]
	set StackID = 3
	where Task.Title = @taskname;

	select * from [Stack]; 
	select * from [Task]; 
end
go
exec concludeTask 'Enviar relatório semanal';


