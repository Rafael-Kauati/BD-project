# Projeto BD - Routine View

<h2>Mudanças pós-apresentação do dia 01/06 </h2>

<h3>Funcionalidades Adicionadas</h3>

* Editar tasks 
* Criar  novo grupo de tasks 
* Passwords encriptografadas
* Validação e controlo de transactions (antes inexistentes) em 
Storage Procedures e Triggers
* Adaptção de SPs, Triggers intead of e UDFs (e algumas outras partes da interface de utilizador) para validarem e lidarem com possíveis problemas de vulneribilidades (SQL-injections)
* Novas Views

<br>
<br>
<br>

<h1>Demo</h1>

<p>A demo da aplicação sendo utilizada se encontra no root do projeto</p>
<p>Nota : no vídeo, nota-se que a aplicação foi encerrada e executada algumas vezes, devido que algumas funcionalidades que deveriam dar "reload" nos dados de uma determinada tabela (quando fosse clicado algum botão) não estarem perfeitamente funcionais (um problema da interface do utilizador). Portanto, a aplicação foi encerrada e executada novamente várias vezes para que a mesma executa se novamente os "loads" da base de dados, especificamente dados da tabela Task_Group ,com os valores mais atualizados
</p>

<br>
<br>
<br>

<h1>How to Run</h1>

<h2>Os scripts SQL  se encontram na pasta SQL/ do projeto(as tabelas, UDFs, SPs, Triggers, Views e Inserts foram previamente inseridos na DB das aulas) e aplicação feita em Windows Forms na pasta App/. Para abrir a aplicação WF, recomenda-se utilizar a opção “Abrir um projeto ou uma solução”,na  página inicial do “Visual Studio na página inicial do Visual Studio Enterprise e Navegar até a pasta App e selecionar a solução Routine-View-Forms.sln”. No ficheiro ConnectionStringHelper.cs mudar na variável stática "connectionString"  os campos ID e Password para os dos respectivos utilizadores.

Por fim, a aplicação estará pronta para conectar com a base de dados das aulas e operar com a camada de dados do projeto.</h2>
