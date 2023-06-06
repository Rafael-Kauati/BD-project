--use [Routine View]
--go

drop function if exists GetAllTasksInStack
go

drop function if exists getTaskGroup
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
	where g.[userID] = @userid
);
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

drop function if exists GetAllTasksInStack
go

CREATE FUNCTION GetAllTasksInStack
    (@stackName VARCHAR(40), @userid int)
RETURNS TABLE
AS
RETURN
(
    SELECT
        t.Code AS TaskCode,
        t.Title AS TaskTitle,
        t.TaskGroupCode AS TaskGroup,
        t.Description AS TaskDescription,
        t.Importance AS TaskImportance,
        t.Deadline AS TaskDeadline,
        t.State AS TaskState,
        t.Priority AS TaskPriority,
        t.StackID,
        t.Conclusion AS TaskConclusion,
        t.UserID
    FROM
        [Stack] s
        JOIN [Task] t ON s.StackID = t.StackID
    WHERE
        s.[Name] = @stackName 
        AND t.TaskGroupCode IS NULL AND t.UserID = @userid
);
GO