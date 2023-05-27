use [Routine View]
go

insert into 
	[User] 
	( [Name], [Email], [Password],[DoB]) 
	values ( 'JSP', 'JSP@ua.pt', 'jayjay' ,'2011-01-01'),
	( 'Pedro Branches', 'PB@ua.pt', 'ManjaroTrash', '2019-01-01'),
	('Jane Smith', 'janesmith@example.com', 'anotherpassword', '1995-05-05'),
	('Bob Johnson', 'bobjohnson@example.com', 'supersecurepassword', '1985-12-31');;
go

insert into
	[Stack]
	( [Name]) values
	( 'To Do'), ( 'Doing'),( 'Done');
go

INSERT INTO [Task] (Title, [Description], Importance, Deadline,   [UserID])
VALUES ('Enviar relatório semanal', 'Preparar e enviar relatório de desempenho semanal da equipe', 2, '2023-06-19 09:00:00',   10),

('Atualizar planilha de vendas', 'Inserir os dados de vendas atualizados na planilha de acompanhamento', 4, '2023-07-20 14:30:00',   10),
 ('Realizar reunião de equipe', 'Agendar e conduzir uma reunião com a equipe para alinhar as metas do mês', 3, '2023-05-29 11:00:00',  10),

 ('Enviar convites para evento', 'Elaborar e enviar convites para os participantes do evento corporativo', 5, '2023-09-22 16:30:00',   10);
 


exec startTask 'Enviar relatório semanal';
select * from [Task];

exec concludeTask 'Enviar relatório semanal';
select * from [Task];


 /*
insert into [Task_Group_Assoc] (CriteriaType) values
('Importance'), ('Deadline'), ('Category');

insert into [Task_Group]  ([Assoc_code],[StackID], [Title], [DateOfCreation] ) values
(1, 1, 'Tarefas importantes', GETDATE()),(2, 1, 'Emitir folha de pagamento', GETDATE());

--EXECUTE addTaskToGroup @taskGroupTitle = 'Tarefas importantes', @taskCode = 4;

EXECUTE addTaskToGroup 
@TaskGroupTitle = 'Tarefas importantes', @TaskTitle = 'Enviar relatório semanal';

EXECUTE addTaskToGroup 
@TaskGroupTitle =  'Tarefas importantes', @TaskTitle = 'Atualizar planilha de vendas';
select * from [User]; 
select * from [Stack]; 
select * from [Reward]; 
*/

select * from [Task]; 

--select * from [Task_Group]; 
