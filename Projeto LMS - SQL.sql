--CREATE TABLE


CREATE TABLE Usuario (
ID INT NOT NULL IDENTITY(1,1)
, [Login] VARCHAR(50) NOT NULL
, Senha VARCHAR(30) NOT NULL
, DataExpiracao DATE NOT NULL
	CONSTRAINT DF_DataExpiracao 
		DEFAULT ( '01/01/1900' )
CONSTRAINT PK_Usuario PRIMARY KEY (ID)
, CONSTRAINT UQ_Usuario_Login UNIQUE (Login)
)
GO


CREATE TABLE Coordenador (
ID	INT NOT NULL IDENTITY(1,1)
, ID_Usuario INT NOT NULL
, Nome VARCHAR(50) NOT NULL
, Email VARCHAR(50) NOT NULL
, Celular VARCHAR(16) NOT NULL
CONSTRAINT PK_Coordenador PRIMARY KEY (ID)
, CONSTRAINT UQ_Coordenador_Email UNIQUE (Email)
, CONSTRAINT UQ_Coordenador_Celular UNIQUE (Celular)
, CONSTRAINT FK_CoordenadorUsuario FOREIGN KEY (ID_Usuario) REFERENCES Usuario (ID)
)
GO

CREATE TABLE Aluno (
ID INT NOT NULL IDENTITY(1,1)
, ID_Usuario INT NOT NULL
, Nome VARCHAR(50) NOT NULL
, Email VARCHAR(50) NOT NULL
, Celular VARCHAR(16) NOT NULL
, RA INT NOT NULL
, Foto NVARCHAR(500) NULL
CONSTRAINT PK_Aluno PRIMARY KEY (ID)
, CONSTRAINT UQ_Aluno_Email UNIQUE (Email)
, CONSTRAINT UQ_Aluno_Celular UNIQUE (Celular)
, CONSTRAINT FK_AlunoUsuario FOREIGN KEY (ID_Usuario) REFERENCES Usuario (ID)
)
GO


CREATE TABLE Professor (
ID INT NOT NULL IDENTITY(1,1)
, ID_Usuario INT NOT NULL
, Email VARCHAR(50) NOT NULL
, Celular VARCHAR(16) NOT NULL
, Apelido VARCHAR(30) NOT NULL
CONSTRAINT PK_Professor PRIMARY KEY (ID)
, CONSTRAINT UQ_Professor_Email UNIQUE (Email)
, CONSTRAINT UQ_Professor_Celular UNIQUE (Celular)
, CONSTRAINT FK_ProfessorUsuario FOREIGN KEY (ID_Usuario) REFERENCES Usuario (ID)
)
GO


CREATE TABLE Disciplina (
ID INT NOT NULL IDENTITY(1,1)
, Nome VARCHAR(50) NOT NULL
, [Data] DATETIME NOT NULL
CONSTRAINT DF_Data DEFAULT (getdate())
, [Status] VARCHAR(20) NOT NULL
CONSTRAINT DF_StatusDisciplina DEFAULT ('Aberta')
, CONSTRAINT CK_StatusDisciplina
	CHECK ([Status]  IN ('Aberta', 'Fechada'))
, PlanodeEnsino VARCHAR(50) NOT NULL
, CargaHoraria INT NOT NULL
CONSTRAINT CK_CargaHorariaDisciplina
	CHECK (CargaHoraria IN ('40', '80'))
, Competencias TEXT NOT NULL
, Habilidades TEXT NOT NULL
, Ementa TEXT NOT NULL
, ConteudoProgramatico TEXT NOT NULL
, BibliografiaBasica TEXT NOT NULL
, BibliografiaComplementar TEXT NOT NULL
, PercentualPratico INT NOT NULL
CONSTRAINT CK_PercentualPraticoDisciplina
	CHECK (PercentualPratico>=00 and PercentualPratico<=100)
, PercentualTeorico INT NOT NULL
CONSTRAINT CK_PercentualTeoricoDisciplina
	CHECK (PercentualTeorico>=00 and PercentualTeorico<=100)
, ID_Coordenador INT NOT NULL CONSTRAINT PK_Disciplina PRIMARY KEY (ID)
, CONSTRAINT UQ_Disciplia_Nome UNIQUE (Nome)
, CONSTRAINT FK_DisciplinaCoordenador FOREIGN KEY (ID_Coordenador) REFERENCES Coordenador (ID)
)
GO


CREATE TABLE Curso (
ID INT NOT NULL IDENTITY(1,1)
, Nome VARCHAR(50) NOT NULL
CONSTRAINT PK_Curso PRIMARY KEY (ID)
)
GO

CREATE TABLE DisciplinaOfertada (
ID INT NOT NULL IDENTITY(1,1)
, ID_Coordenador INT NOT NULL
, DataInicioMatricula DATETIME NULL
, DataFimMatricula DATETIME NULL
, ID_Disciplina INT NOT NULL
, ID_Curso INT NOT NULL
, Ano INT NOT NULL
CONSTRAINT CK_AnoDisciplinaOfertada
	CHECK (Ano>=1900 and Ano<=2100)
, Semestre VARCHAR(6) NOT NULL
CONSTRAINT CK_SemestreDisciplinaOfertada
	CHECK (Semestre>=1 and Semestre<=2)
, Turma VARCHAR(4) NOT NULL
CONSTRAINT CK_TurmaDisciplinaOfertada
	CHECK (Turma LIKE '[A-Z]')
, ID_Professor INT NULL
, Metodologia TEXT NULL
, Recursos TEXT NULL
, CriteriodeAvalia��o TEXT NULL
, PlanodeAula TEXT NULL
CONSTRAINT PK_DisciplinaOfertada PRIMARY KEY (ID)
, CONSTRAINT UQ_DisciplinaOfertada UNIQUE (ID_Disciplina, ID_Curso, Ano, Semestre, Turma)
, CONSTRAINT FK_DisciplinaOfertadaCoordenador FOREIGN KEY (ID_Coordenador) REFERENCES Coordenador (ID)
, CONSTRAINT FK_DisciplinaOfertadaDisciplina FOREIGN KEY (ID_DIsciplina) REFERENCES Disciplina (ID)
, CONSTRAINT FK_DisciplinaOfertadaCurso FOREIGN KEY (ID_Curso) REFERENCES Curso (ID)
, CONSTRAINT FK_DisciplinaOfertadaProfessor FOREIGN KEY (ID_Professor) REFERENCES Professor (ID)
)
GO


CREATE TABLE SolicitacaoMatricula (
ID INT NOT NULL IDENTITY(1,1)
, ID_Aluno INT NOT NULL
, ID_DisciplinaOfertada INT NOT NULL
, DataSolicitacao DATETIME NOT NULL
CONSTRAINT DF_DataSolitacao DEFAULT ( getdate() )
, ID_Coordenador INT NULL
, [Status] VARCHAR(15) NULL
CONSTRAINT DF_StatusMatricula DEFAULT ('Solicitada')
, CONSTRAINT CK_StatusDisciplinaOfertada
	CHECK ([Status]  IN ('Solicitada', 'Aprovada', 'Rejeitada', 'Cancelada'))
, CONSTRAINT PK_SolicitacaoMatricula PRIMARY KEY (ID)
, CONSTRAINT FK_SolicitacaoMatriculaAluno FOREIGN KEY (ID_Aluno) REFERENCES Aluno (ID)
, CONSTRAINT FK_SolicitacaoMatriculaDisciplinaOfertada FOREIGN KEY (ID_DisciplinaOfertada) REFERENCES DisciplinaOfertada (ID)
, CONSTRAINT FK_SolicitacaoMatriculaCoordenador FOREIGN KEY (ID_Coordenador) REFERENCES Coordenador (ID)
)
GO

CREATE TABLE Atividade (
ID INT NOT NULL IDENTITY(1,1)
, Titulo VARCHAR(100) NOT NULL
, Descricao TEXT NULL
, Conteudo TEXT NOT NULL
, Tipo VARCHAR(20) NOT NULL
CONSTRAINT CK_TipoAtividade
	CHECK (Tipo  IN ('Resposta Aberta', 'Teste'))
, Extras NVARCHAR(1000) NULL
, ID_Professor INT NOT NULL
CONSTRAINT PK_Atividade PRIMARY KEY (ID)
, CONSTRAINT UQ_Atividade_Titulo UNIQUE (Titulo)
, CONSTRAINT FK_AtividadeProfessor FOREIGN KEY (ID_Professor) REFERENCES Professor (ID)
)
GO

CREATE TABLE AtividadeVinculada (
ID INT NOT NULL IDENTITY(1,1)
, ID_Atividade INT NOT NULL
, ID_Professor INT NOT NULL
, ID_DisciplinaOfertada INT NOT NULL
, Rotulo VARCHAR(30) NOT NULL
, [Status] VARCHAR(30) NOT NULL
CONSTRAINT DF_AtividadeVinculada DEFAULT ('Disponibilizada')
, CONSTRAINT CK_StatusAtividadeVinculada
	CHECK ([Status]  IN ('Disponibilizada', 'Aberta', 'Fechada', 'Encerrada', 'Prorrogada'))
, DataInicioRespostas DATETIME NOT NULL
, DataFimRespostas DATETIME NOT NULL
CONSTRAINT PK_AtividadeVinculada PRIMARY KEY (ID)
, CONSTRAINT UQ_AtividadeVinculada UNIQUE (ID_Atividade, ID_DisciplinaOfertada, Rotulo)
, CONSTRAINT FK_AtividadeVinculadaAtividade FOREIGN KEY (ID_Atividade) REFERENCES Atividade (ID)
, CONSTRAINT FK_AtividadeVinculadaProfessor FOREIGN KEY (ID_Professor) REFERENCES Professor (ID)
, CONSTRAINT FK_AtividadeVinculadaDisciplinaOfertada FOREIGN KEY (ID_DisciplinaOfertada) REFERENCES DisciplinaOfertada (ID)
)
GO


CREATE TABLE Entrega (
ID INT NOT NULL IDENTITY(1,1)
, ID_Aluno INT NOT NULL
, ID_AtividadeVinculada INT NOT NULL
, Titulo VARCHAR(100) NOT NULL
, Resposta NVARCHAR(1000) NOT NULL
, DataEntrega  DATETIME NOT NULL
	CONSTRAINT df_DataEntrega DEFAULT ( getdate() )
, [Status]  VARCHAR(30) NOT NULL
CONSTRAINT DF_Entrega DEFAULT ('Entregue')
, CONSTRAINT CK_StatusEntrega
	CHECK ([Status]  IN ('Entregue', 'Corrigido'))
, ID_Professor INT NULL
, Nota DECIMAL(4,2) NULL
CONSTRAINT CK_NotaEntrega
	CHECK (Nota>=0.00 and Nota<=10.00)
, DataAvalia��o DATETIME NULL
, Obs VARCHAR (500) NULL
CONSTRAINT PK_Entrega PRIMARY KEY (ID)
, CONSTRAINT UQ_Entrega UNIQUE (ID_Aluno, ID_AtividadeVinculada)
, CONSTRAINT FK_EntregaAluno FOREIGN KEY (ID_Aluno) REFERENCES Aluno (ID)
, CONSTRAINT FK_EntregaAtividadeVinculada FOREIGN KEY (ID_AtividadeVinculada) REFERENCES AtividadeVinculada (ID)
, CONSTRAINT FK_EntregaProfessor FOREIGN KEY (ID_Professor) REFERENCES Professor (ID)
)
GO

CREATE TABLE Mensagem (
ID INT NOT NULL IDENTITY(1,1)
, ID_Aluno INT NOT NULL
, ID_Professor INT NOT NULL
, Assunto VARCHAR(500) NOT NULL
, Referencia VARCHAR(100) NOT NULL
, Conteudo VARCHAR(1000) NOT NULL
, [Status] VARCHAR(30) NOT NULL
CONSTRAINT DF_Status DEFAULT ('Enviado')
, CONSTRAINT CK_StatusMensagem
	CHECK ([Status] IN ('Enviado', 'Lido', 'Respondido'))
, DataEnvio DATETIME NOT NULL
	CONSTRAINT df_DataEnvio DEFAULT ( getdate() )
, DataResposta DATETIME NULL
, Resposta VARCHAR(1000) NULL
CONSTRAINT PK_Mensagem PRIMARY KEY (ID)
, CONSTRAINT FK_MensagemAluno FOREIGN KEY (ID_Aluno) REFERENCES Aluno (ID)
, CONSTRAINT FK_MensagemProfessor FOREIGN KEY (ID_Professor) REFERENCES Professor (ID)
)
GO


--INSERT

INSERT INTO Usuario( [Login], Senha, DataExpiracao )
VALUES ('camila.costa@faculdadebr.com.br', 'Faculdadebr123', '19/12/2022')
GO

INSERT INTO Usuario( [Login], Senha, DataExpiracao )
VALUES ('guilherme.sousa@faculdadebr.com.br', 'Faculdadebr124', '18/12/2022')
,	   ('lucas.soares@faculdadebr.com.br', 'Faculdadebr125', '15/12/2022')
,	   ('gabriela.pontes@faculdadebr.com.br', 'Faculdadebr126', '31/12/2022')
,	   ('julia.oliveira@faculdadebr.com.br', 'Faculdadebr127', '09/11/2022')
,	   ('sergio.silva@faculdadebr.com.br', 'Faculdadebr128', '01/12/2022')
,	   ('caio.ferreira@faculdadebr.com.br', 'Faculdadebr129', '30/11/2022')
,	   ('barbara.santos@faculdadebr.com.br', 'Faculdadebr134', '05/12/2022')
,	   ('carolina.pereira@faculdadebr.com.br', 'Faculdadebr135', '07/12/2022')
,	   ('diego.alves@faculdadebr.com.br', 'Faculdadebr136', '30/12/2022')
,	   ('adriana.lima@faculdadebr.com.br', 'Faculdadebr137', '18/12/2022')
,        ('thais.gomes''@faculdadebr.com.br', 'Faculdadebr123','')
,        ('fernanda.castro@faculdadebr.com.br', 'Faculdadebr138', '')
,	   ('matheus.xavier@faculdadebr.com.br', 'Faculdadebr139', '18/12/2022')
,	   ('rodrigo.martins@faculdadebr.com.br', 'Faculdadebr141', '')
,	   ('bruna.prado@faculdadebr.com.br', 'Faculdadebr142', '31/12/2022')
GO

INSERT INTO Coordenador(ID_Usuario, Nome, Email, Celular )
VALUES (1, 'Camila Costa', 'camila.costa@faculdadebr.com.br', '11998123456')
GO

INSERT INTO Aluno(ID_Usuario, Nome, Email, Celular, RA, Foto)
VALUES (2, 'Guilherme Sousa', 'guilherme.sousa@faculdadebr.com.br', '11998123457', '2022124', '')
,	   (3, 'Lucas Soares' , 'lucas.soares@faculdadebr.com.br', '11998123458', '2022125', '')
,	   (4, 'Gabriela Pontes' , 'gabriela.pontes@faculdadebr.com.br', '11998123459', '2022126', '')
,	   (5, 'Julia Oliveira' , 'julia.oliveira@faculdadebr.com.br', '11998223456', '2022127', '')
,	   (6, 'Sergio Silva' , 'sergio.silva@faculdadebr.com.br', '11998223457', '2022128', '')
,	   (7, 'Caio Ferreira' , 'caio.ferreira@faculdadebr.com.br', '11998223458', '2022129', '')
,	   (8, 'Barbara Santos' , 'barbara.santos@faculdadebr.com.br', '11998223459', '2022134', '')
,	   (9, 'Carolina Pereira' , 'carolina.pereira@faculdadebr.com.br', '11998223455', '2022135', '')
,	   (10, 'Diego Alves' , 'diego.alves@faculdadebr.com.br', '11998223454', '2022136', '')
,	   (11, 'Adriana Lima' , 'adriana.lima@faculdadebr.com.br', '11998223453', '2022137', '')
GO

INSERT INTO Professor(ID_Usuario,Email, Celular, Apelido)
VALUES (12, 'thais.gomes''@faculdadebr.com.br', '11998323451','Tat�')
,      (13, 'fernanda.castro@faculdadebr.com.br', '11998323452','Fer')
,	   (14, 'matheus.xavier@faculdadebr.com.br', '11998323453','Xavier')
,	   (15, 'rodrigo.martins@faculdadebr.com.br', '11998323454','R�')
,	   (16, 'bruna.prado@faculdadebr.com.br', '11998323455','Prado')
GO

INSERT INTO Curso (Nome)
VALUES ('ADM')
,      ('BD')
,      ('SI')
GO

INSERT INTO Disciplina (Nome, [Data], [Status], PlanodeEnsino, CargaHoraria, 
Competencias, Habilidades, Ementa, ConteudoProgramatico, 
BibliografiaBasica, BibliografiaComplementar, PercentualPratico, 
PercentualTeorico, ID_Coordenador)
VALUES ('Linguagem SQL', '01/02/2022 08:00', 'Fechada', 'PlanodeEnsinaSQL.pdf-2S', 80, 
'Arquitetar um Bancos de dados capaz de atender �s necessidades especificadas.
Desenvolvimento de rotinas de defini��o, manipula��o e recupera��o de dados.
Garantir a integridade dos dados armazenados utilizando-se de restri��es estruturais e funcionais.
Criar relat�rios para an�lise e consolida��o das informa��es armazenadas.', 
'Conhecimento das regras de mapeamento dos modelos l�gico/conceitual para o f�sico.
Conhecimento da sub-linguagem SQL de Defini��o de dados (DDL): Cria��o, altera��o e remo��o
de estruturas e regras de armazenamento.
Conhecimento da sub-linguagem SQL de Manipula��o de dados (DML): Inser��o, remo��o e
atualiza��o de dados.
Conhecimento da sub-linguagem SQL de Pesquisa de dados (DQL): Consulta de dados,
Predicados, Fun��es built-in, Agrupamento e Jun��es.
Conhecimento sobre conex�es, sess�es e transa��es em banco de dados.', 
'Introdu��o � Linguagem SQL. Conceitos B�sicos. Linguagem de Defini��o de dados ( tabelas e
vis�es ), Linguagem de Manipula��o de dados ( insert, delete, update ) e Linguagem de Consulta
aos Dados ( fun��es built-in, joins, agrupamentos e sub-selects ).', 
'Introdu��o: Hist�ria da Linguagem SQL.
Conceitos b�sicos: tabela, campo, tipos de dados, campos chave.
Linguagem de Defini��o de Dados: cria��o / altera��o / remo��o de objetos.
Linguagem de Manipula��o de Dados: inser��o / atualiza��o / remo��o de registros.
Linguagem de Pesquisa de dados:
Predicados (cl�usula where).
Fun��es de agrega��o e cl�usula group by.
Jun��es.
Subconsultas.
Fun��es built-in: Tratamento de Dados.
Controle de transa��es e sess�es.
Restri��es de Integridade: restri��es de atributo (campo), restri��es de entidade (tabela) e
restri��es referencial (entre tabelas).
No��es de Vis�es', 
'CORONEL, C.; MORRIS, S. Database Systems: design, implementation and management.
11
a
.ed. S�o Paulo: Cengage do Brasil, 2014.
DATE, C.J. SQL e Teoria Relacional: como escrever c�digos SQL precisos. 1.ed. S�o Paulo:
Novatec, 2015.
PRATT, P.; LAST, M. Concepts of Database Management. 8. Ed. Boston: Cengage, 2014.', 
'ELMASRI, R. E.; NAVATHE, S. B. Sistemas de Banco de Dados. 6. Ed. S�o Paulo: Pearson, 2011.
SILBERCHATZ, A.; KORTH, H. F. Sistema de Banco de Dados. 6.ed. Rio de Janeiro: Elsevier, 2012.
TEOREY, T. J.; LIGHSTONE, S.; NADEAU, T. Projeto e Modelagem de Banco de Dados. 2.ed. Rio
de Janeiro: Elsevier. 2014.
VIESCAS, J. L.; HERNANDEZ, M.J. SQL Queries for mere mortals: A hands-on guide to data
manipulation in SQL. 3rd. Ed. Upper Sadle River: Addison-Wesley, 2014.
DATE, C. J.; FERNANDES, A. Projeto de Banco de Dados e Teoria Relacional. 1. ed. S�o Paulo:
Novatec, 2015.', 
60, 40, 1)

INSERT INTO Disciplina (Nome, [Data], [Status], PlanodeEnsino, CargaHoraria, 
Competencias, Habilidades, Ementa, ConteudoProgramatico, 
BibliografiaBasica, BibliografiaComplementar, PercentualPratico, 
PercentualTeorico, ID_Coordenador)
VALUES 
('Tec Web', 
'02/02/2022 08:00',
'Aberta', 
'PlanodeEnsinoTW-1S.pdf',
80, 
'Criar uma base s�lida em An�lise Explorat�ria de Dados.
Analisar, interpretar e comunicar os padr�es presentes nos dados por meio de diferentes t�cnicas
estat�sticas.', 
'Conhecer o processo de an�lise de dados, suas etapas e interdepend�ncias.
Conhecer os principais recursos da estat�stica descritiva para caracterizar universos ou amostras de
dados.
Saber organizar, sumarizar e descrever um conjunto de dados.
Conhecer os principais gr�ficos e determinar sua conveni�ncia para as an�lises de dados desejadas
e as propriedades dos tipos de dados.
Interpretar visualmente os dados e comunicar os diferentes padr�es identificados.', 
'Introdu��o � Web Data Aplipplication. Conceitos B�sicos. Bibliotecas. Linguagem de progama��o Python', 
'1. Fundamentos de Arquitetura de Sistema: entendimento e compara��o entre padr�es
arquiteturais de aplica��es; destaque para requisitos para aplica��es de dados com �nfase para
web.
2. Aplica��es Web para Dados, disposi��o de dados: aplica��es web dedicadas a prover dados;
aplica��o fim(Dados sobre HTML, CSS e JS); fonte de dados local e remoto(arquivos).
3. Aplica��es Web para Dados baseado em framework dedicado, disposi��o de dados:
arquitetura cliente servidor; framework especializado em visualiza��o de dados de forma
interativa; dados georreferenciados e nuvem de palavras.
4. Aplica��es Web para Dados de origem BD: organiza��o arquitetural; controles e modelagem de
dados de BD para REST.
5. Aplica��es de persist�ncia de dados da Web: varredura e persist�ncia de dados da web.
6. Aplica��es Web para Dados de origem modelos: disposi��o de predi��o e classifica��o de
modelos estat�sticos ou de aprendizado de m�quina.', 
'CERVANTES, H.; KAZMAN, R.; Designing Software Architectures: A Practical Approach. 1.ed. Addison-
Wesley Professional. 2016.
FOWLER, MARTIN. Patterns of Enterprise Application Architecture. 1� Ed: Prentice Hall, 2002.
CHANDRA, R. V.; VARANASI, B. S. Python Requests Essentials: Learn how to integrate your applications
seamlessly with web services using Python Requests; Packt Publishing, 2015.
ELMAN, J.; LAVIN, M. Django Essencial - Usando REST, websockets e Backbone. 1.ed. S�o Paulo:
Novatec, 2015.
JARMUL, K.; LAWSON, R. Python Web Scraping. 2nd. Birmingham: Packt Publishing, 2017.', 
'PATNI, S. Pro RESTful APIs. 1st. ed. New York: Apress, 2017.
MASS�, M. REST API Design Rulebook. 1st. ed. O�Reilly, 2011.', 
50, 50, 1
)

INSERT INTO DisciplinaOfertada (ID_Coordenador, ID_Disciplina, ID_Curso, 
Ano, Semestre, Turma)
VALUES (1, 1, 1, 2022, '1', 'C')

INSERT INTO DisciplinaOfertada (ID_Coordenador, ID_Disciplina, ID_Curso, 
Ano, Semestre, Turma)
VALUES (1, 1, 3, 2022, '1', 'C')

UPDATE DisciplinaOfertada SET ID_Professor = 4
WHERE ID_Curso = 1

UPDATE DisciplinaOfertada SET ID_Professor = 2
WHERE ID_Curso = 3

UPDATE DisciplinaOfertada SET Metodologia = 'Aulas expositivas utilizando projetor, lousa eletr�nica e computador nas quais se apresenta e discute os
t�picos da disciplina, bem como trabalhos em grupo com apresenta��o escrita e defesa oral,
apresenta��o de v�deos.
Cada per�odo de aula de 50 minutos ser� completado com atividades a serem realizadas via ambiente
virtual para um tempo de 10 minutos.
Atividades cont�nuas di�rias para acompanhamento do processo ensino aprendizagem, em duas
modalidades: em sala de aula ( AC presencial ) e em ambiente virtual ( AC TAE ).'
WHERE ID_Disciplina = 1

UPDATE DisciplinaOfertada SET Recursos = 'Servidor Microsoft SQL Server Database Engine 2014 (ou superior) Enterprise Edition
Cliente Microsoft SQL Server Management Studio 2014 (ou superior).'
WHERE ID_Disciplina = 1

UPDATE DisciplinaOfertada SET CriteriodeAvalia��o = 'Nota Final = 50% MAC + 50% Prova
ou
Nota Final = [30% MAC + 40% Prova + 30% MPAI]
SE (Nota Final >= 6,0 e Frequ�ncia >= 75%)
ENT�O Aprovado
SEN�O Reprovado
Em que: MAC (M�dia de Atividades Cont�nuas):
M�dia das 04 melhores m�dias de cada AC semanal em um total de 5 ACs.
Prova = Avalia��o Semestral
MPAI = M�dia das provas do PAI para Disciplinas Incidentes do PAI
O aluno tem direito a uma Prova Substitutiva, com todo o conte�do do semestre letivo, para substituir a
Prova Semestral. A Prova Substitutiva somente ser� utilizada se for maior que a Prova.'
WHERE ID_Disciplina = 1

UPDATE DisciplinaOfertada SET PlanodeAula = 'PlanodeEnsinaSQL.pdf-2S'
WHERE ID_Disciplina = 1

UPDATE DisciplinaOfertada SET DataInicioMatricula = '01/07/2022 01:00'
WHERE ID = 1

UPDATE DisciplinaOfertada SET DataFimMatricula = '31/07/2022 23:59'
WHERE ID = 1

UPDATE DisciplinaOfertada SET DataInicioMatricula = '01/07/2022 01:00'
WHERE ID_Curso = 3

UPDATE DisciplinaOfertada SET DataFimMatricula = '31/07/2022 23:59'
WHERE ID_Curso = 3

INSERT INTO SolicitacaoMatricula(ID_Aluno, ID_DisciplinaOfertada
, DataSolicitacao, ID_Coordenador)
VALUES (1, 1, '02/07/2022 12:55', 1)

INSERT INTO SolicitacaoMatricula(ID_Aluno, ID_DisciplinaOfertada
, DataSolicitacao, ID_Coordenador)
VALUES (6, 1, '05/07/2022 15:32', 1)
,      (4, 2, '09/07/2022 10:22', 1)
,      (7, 2, '13/07/2022 08:37', 1)
,      (2, 1, '21/07/2022 21:07', 1)
,      (5, 2, '25/07/2022 13:44', 1)


UPDATE SolicitacaoMatricula SET Status = 'Aprovada'
WHERE ID_Aluno = 1

UPDATE SolicitacaoMatricula SET Status = 'Rejeitada'
WHERE ID_Aluno = 6

UPDATE SolicitacaoMatricula SET Status = 'Aprovada'
WHERE ID_Aluno = 4

UPDATE SolicitacaoMatricula SET Status = 'Aprovada'
WHERE ID_Aluno = 7

UPDATE SolicitacaoMatricula SET Status = 'Rejeitada'
WHERE ID_Aluno = 2

UPDATE SolicitacaoMatricula SET Status = 'Aprovada'
WHERE ID_Aluno = 5


-- Select 1 --
select Aluno.Nome, DisciplinaOfertada.Turma, DisciplinaOfertada.Semestre
from  Disciplina
			inner join DisciplinaOfertada
			on Disciplina.ID = DisciplinaOfertada.ID_Disciplina
			inner join SolicitacaoMatricula
			on DisciplinaOfertada.ID = SolicitacaoMatricula.ID_DisciplinaOfertada
			inner join Aluno
			on SolicitacaoMatricula.ID_Aluno = Aluno.ID
where SolicitacaoMatricula.Status = 'Aprovada'

--SELECT 2 --
select Disciplina.Nome
from Disciplina
where Disciplina.Status = 'Aberta'

--SELECT 3 --
select Aluno.Nome, Disciplina.Nome, Disciplina.CargaHoraria
from Disciplina
				inner join DisciplinaOfertada
				on Disciplina.ID = DisciplinaOfertada.ID_Disciplina
				inner join SolicitacaoMatricula
				on DisciplinaOfertada.ID = SolicitacaoMatricula.ID_DisciplinaOfertada
				inner join Aluno
				on SolicitacaoMatricula.ID_Aluno = Aluno.ID
where SolicitacaoMatricula.Status = 'Aprovada'

--SELECT 4 --
select Disciplina.Nome
from Disciplina
				inner join DisciplinaOfertada 
				on Disciplina.ID = DisciplinaOfertada.ID_Disciplina
where DisciplinaOfertada.ID_Professor = null


--SELECT 5 --
select count(SolicitacaoMatricula.Status) as Aprovadas
from SolicitacaoMatricula
group by SolicitacaoMatricula.Status
having SolicitacaoMatricula.Status = 'Aprovada'
 
select count(SolicitacaoMatricula.Status) as Aguardando
from SolicitacaoMatricula
group by SolicitacaoMatricula.Status
having SolicitacaoMatricula.Status = 'Solicitada'