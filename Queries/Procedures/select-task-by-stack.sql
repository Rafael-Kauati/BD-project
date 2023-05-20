create procedure selectTasksByStack( @stackname  varchar(10) )
as	
	select Code, Title, [Description] 
	from Task 
	inner join Stack on Task.StackID = Stack.StackID
	where Stack.Name = @stackname;
	

exec selectTasksByStack 'Doing';