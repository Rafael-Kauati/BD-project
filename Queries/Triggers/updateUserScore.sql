use [Routine View]
go

drop trigger if exists updateUserScore
go

create trigger updateUserScore on [Reward] 
after insert 
as 
begin
	declare @newReward int; declare @userid int;
	
	select 
	@newReward = [Reward_Value],
	@userid = Task.UserID
	from inserted 
	inner join Task on inserted.Task_code = Task.Code;

	update [User]
	set [Score] = [Score] + @newReward
	where [User].ID = @userid;
	
end;