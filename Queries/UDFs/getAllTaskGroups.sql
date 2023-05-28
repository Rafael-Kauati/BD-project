use [Routine View]
go

drop function if exists getAllTaskGroups
go

create function getAllTaskGroups
	(@userid int)
RETURNS TABLE
AS
RETURN(
	select g.[Title], g.Code, g.Assoc_code
	from [Task_Group] g
	--join [Task] t on g.Code = t.TaskGroupCode 
	--where t.UserID = @userid
);
go
