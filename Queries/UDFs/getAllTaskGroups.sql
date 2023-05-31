use [Routine View]
go

drop function if exists getAllTaskGroups
go

create function getAllTaskGroups
	(@userid int)
RETURNS TABLE
AS
RETURN(
	select distinct g.Code, g.[Title], g.[isFinished],a.CriteriaType
	from  [Task_Group] g 
	join [Task_Group_Assoc] a on g.Assoc_code = a.Assoc_Code
	join [Task] t on g.Code = t.TaskGroupCode 
	where t.UserID = @userid
	--where t.UserID = @userid
);
go
