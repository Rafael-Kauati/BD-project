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

INSERT INTO [Task] (Title, Description, Importance, Deadline, Priority, StackID, UserID)
VALUES 
('Responder e-mails', 'Responder aos e-mails recebidos hoje', 2, '2023-05-13 17:00:00', 1, 1, 10),
('Enviar convites', 'Enviar convites para o evento de lançamento do produto Y', 3, '2023-05-20 18:00:00', 2, 1, 10),
('Analisar relatório', 'Analisar o relatório de vendas do último trimestre', 2, '2023-05-18 10:00:00', 1, 1, 10),
('Conferir estoque', 'Conferir o estoque de produtos para o próximo mês', 3, '2023-05-19 11:00:00', 2, 1, 10);
GO

UPDATE [Task] 
SET StackID = 3 
WHERE [Task].[Title] = 'Analisar relatório';


--select * from [User]; 
select * from [Stack]; 
select Code, Title,StackID from [Task]; 



