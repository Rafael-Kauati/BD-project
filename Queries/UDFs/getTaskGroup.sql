use [Routine View]
go

drop function if exists getTaskGroup
go

create function getTaskGroup
	(@TaskGroupTitle varchar(50), @state varchar(10))
RETURNS TABLE
AS
RETURN(
	select 
		t.Code AS TaskCode,
        t.Title AS TaskTitle,
        t.Description AS TaskDescription,
        t.Importance AS TaskImportance,
        t.Deadline AS TaskDeadline,
        t.State AS TaskState,
        t.Priority AS TaskPriority,
        t.StackID,
        t.Conclusion AS TaskConclusion,
        t.UserID
	from 
		[Task_Group] g
		join [Task] t on g.Code =  t.TaskGroupCode
	where
		g.Title = @TaskGroupTitle AND t.[State] = @state
);
go
