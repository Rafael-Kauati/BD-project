use [Routine View]
go

DROP PROCEDURE IF EXISTS selectTasksByStack;
GO

/*
create procedure selectTasksByStack( @stackname  varchar(10) )
as	
begin
	SELECT StackID, [Name], NumMaxTasks, CurrMaxTasks
    INTO #temp
    FROM [Stack]
    WHERE [Stack].[Name] = @stackname
    --ORDER BY Importance DESC;

    SELECT Title, [Description], [Priority], [Deadline], [Importance],[Conclusion]
    FROM #temp
	INNER JOIN
	Task ON #temp.StackID = task.StackID
    ORDER BY Importance DESC, ABS(DATEDIFF(day, GETDATE(), Deadline));
end
go

exec selectTasksByStack 'Doing';
*/