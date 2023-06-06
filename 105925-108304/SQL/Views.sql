--use [Routine View]
--go

drop view if exists high_Priority_Tasks
go

create view high_Priority_Tasks 
as

	select t.Title, t.Description, t.Deadline,t.Priority, t.Conclusion, t.TaskGroupCode ,s.[Name] as Stack
	from [Task] t
	join [Stack] s on t.StackID = s.StackID
	where t.Priority >= 3;
go


drop view if exists low_Priority_Tasks
go

create view low_Priority_Tasks 
as

	select t.Title, t.Description, t.Deadline,t.Priority, t.Conclusion, t.TaskGroupCode ,s.[Name] as Stack
	from [Task] t
	join [Stack] s on t.StackID = s.StackID
	where t.Priority < 3;
go

