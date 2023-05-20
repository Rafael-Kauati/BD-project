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

INSERT INTO [Task] (Title, [Description], Importance, Deadline, [Priority], [StackID], [UserID])
VALUES ('Enviar relat�rio semanal', 'Preparar e enviar relat�rio de desempenho semanal da equipe', 2, '2023-06-19 09:00:00', 3, 1, 10),

('Atualizar planilha de vendas', 'Inserir os dados de vendas atualizados na planilha de acompanhamento', 1, '2023-07-20 14:30:00', 2, 2, 10),
 ('Realizar reuni�o de equipe', 'Agendar e conduzir uma reuni�o com a equipe para alinhar as metas do m�s', 3, '2023-05-21 11:00:00', 1, 1, 10),

 ('Enviar convites para evento', 'Elaborar e enviar convites para os participantes do evento corporativo', 2, '2023-09-22 16:30:00', 2, 2, 10)/*,
 
 ('Preparar apresenta��o de vendas', 'Criar uma apresenta��o persuasiva para a reuni�o com potenciais clientes', 1, '2023-05-23 13:00:00', 1, 1, 10),

 ('Realizar an�lise de dados', 'Analisar os dados de vendas do �ltimo trimestre e identificar padr�es', 3, '2023-05-24 10:30:00', 2, 2, 10),

 ('Enviar proposta comercial', 'Elaborar e enviar a proposta comercial para o cliente em potencial', 2, '2023-05-25 15:00:00', 3, 1, 10),

 ('Revisar contrato de fornecedor', 'Analisar e revisar o contrato de fornecimento antes de assinar', 1, '2023-05-26 12:30:00', 2, 2, 10),

 ('Realizar teste de software', 'Executar testes e identificar poss�veis bugs no novo software', 3, '2023-05-27 09:00:00', 1, 1, 10),

 ('Organizar treinamento interno', 'Agendar e organizar um treinamento para atualizar os colaboradores', 2, '2023-05-28 14:30:00', 2, 2, 10),

 ('Fazer backup dos arquivos', 'Realizar o backup dos arquivos importantes para evitar perda de dados', 1, '2023-05-29 11:00:00', 1, 1, 10),

 ('Atualizar redes sociais', 'Postar conte�do atualizado nas redes sociais da empresa', 3, '2023-05-30 16:30:00', 2, 2, 10),

 ('Realizar pesquisa de mercado', 'Conduzir uma pesquisa de mercado para identificar novas oportunidades', 2, '2023-05-31 13:00:00', 1, 1, 10),

 ('Preparar relat�rio financeiro', 'Analisar as finan�as da empresa e preparar um relat�rio detalhado', 1, '2023-06-01 10:30:00', 2, 2, 10),

 ('Enviar lembrete de pagamento', 'Enviar lembretes de pagamento aos clientes com faturas em atraso', 3, '2023-06-02 15:00:00', 3, 1, 10),

 ('Desenvolver novo produto', 'Iniciar o desenvolvimento de um novo produto inovador para o mercado', 2, '2023-06-03 12:30:00', 2, 2, 10),

 ('Realizar auditoria interna', 'Conduzir uma auditoria interna para garantir conformidade com os padr�es', 1, '2023-06-04 09:00:00', 1, 1, 10),

 ('Atualizar sistema de gest�o', 'Implementar atualiza��es no sistema de gest�o da empresa', 3, '2023-06-05 14:30:00', 2, 2, 10),

 ('Realizar pesquisa de satisfa��o', 'Enviar pesquisa de satisfa��o aos clientes e analisar os resultados', 2, '2023-06-06 11:00:00', 1, 1, 10),

 ('Preparar material de treinamento', 'Desenvolver materiais de treinamento para a equipe de vendas', 1, '2023-06-07 16:30:00', 2, 2, 10),

 ('Analisar concorr�ncia', 'Realizar uma an�lise detalhada dos principais concorrentes no mercado', 3, '2023-06-08 13:00:00', 1, 1, 10),

 ('Enviar relat�rio trimestral', 'Preparar e enviar o relat�rio de desempenho trimestral da empresa', 2, '2023-06-09 10:30:00', 2, 2, 10)*/;

UPDATE [Task] 
SET StackID = 3 
WHERE [Task].[Title] = 'Analisar relat�rio';


--select * from [User]; 
--select * from [Stack]; 
--select Code, Title,StackID from [Task]; 



