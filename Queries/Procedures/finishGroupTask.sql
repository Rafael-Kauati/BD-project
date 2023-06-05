use [Routine View]
go

drop procedure if exists finishGroupTask
go

create procedure finishGroupTask (@taskGroup varchar(50))
as
begin
	declare @unfinishedTasks int;

	select @unfinishedTasks = [Curr_undone_task_num]
	from Task_Group
	where Task_Group.Title = @taskGroup;

	-- Verificar se @unfinishedTasks é igual a zero
	if @unfinishedTasks = 0
	begin
		update Task_Group
		set Task_Group.isFinished = 'yes'
		where Task_Group.Title =  @taskGroup;

		declare @sumPriority int;

		declare @lastTaskCode int;
		declare @lastTaskDeadline datetime;

		select @sumPriority = sum(TaskPriority)
		from getTaskGroup(@taskGroup, 'Done');

		select @lastTaskCode = t.TaskCode, @lastTaskDeadline = t.TaskDeadline
		from dbo.getTaskGroup(@taskGroup, 'Done') t
		where t.TaskConclusion = (select max(TaskConclusion) from dbo.getTaskGroup(@taskGroup, 'Done'));

		INSERT INTO [Reward] ([Task_code], [Task_Deadline], [Date_Time], [Reward_Value])
        VALUES (@lastTaskCode, 
		ISNULL(@lastTaskDeadline, 
		GETDATE()), 
		GETDATE(), @sumPriority * 2);

	end
	else
	begin
		update Task_Group
		set Task_Group.isFinished = 'no'
		where Task_Group.Title =  @taskGroup;
	end
end
go
