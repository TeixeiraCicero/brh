# SQL
Criação das tabelas
```

CREATE USER BRH 
	IDENTIFIED BY BRH
	DEFAULT TABLESPACE USERS
	QUOTA UNLIMITED ON USERS;

CREATE TABLE BRH.PAPEL (
	ID INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 8) NOT NULL,
	NOME VARCHAR2(255) NOT NULL,
	CONSTRAINT PK_PAPEL PRIMARY KEY (ID),
	CONSTRAINT PAPEL_UNICO UNIQUE (NOME)
);

CREATE TABLE BRH.DEPARTAMENTO (
	SIGLA VARCHAR2(6) NOT NULL,
	NOME VARCHAR2(255) NOT NULL,
	CHEFE VARCHAR2(10) NOT NULL,
	DEPARTAMENTO_SUPERIOR VARCHAR2(6),
	CONSTRAINT PK_DEPARTAMENTO PRIMARY KEY (SIGLA),
	CONSTRAINT FK_DEPARTAMENTO_SUPERIOR
		FOREIGN KEY (DEPARTAMENTO_SUPERIOR)
		REFERENCES BRH.DEPARTAMENTO (SIGLA)
);

CREATE TABLE BRH.ENDERECO (
	CEP VARCHAR2(10) NOT NULL,
	UF CHAR(2) NOT NULL,
	CIDADE VARCHAR2(255) NOT NULL,
	BAIRRO VARCHAR2(255) NOT NULL,
	LOGRADOURO VARCHAR2(255) NOT NULL,
	CONSTRAINT PK_ENDERECO PRIMARY KEY (CEP)
);

CREATE TABLE BRH.COLABORADOR (
	MATRICULA VARCHAR2(10) NOT NULL,
	CPF CHAR(14) NOT NULL,
	NOME VARCHAR2(255) NOT NULL,
	EMAIL_PESSOAL VARCHAR2(255) NOT NULL,
	EMAIL_CORPORATIVO VARCHAR2(255) NOT NULL,
	SALARIO DECIMAL(10,2) NOT NULL,
	DEPARTAMENTO VARCHAR2(6) NOT NULL,
	CEP VARCHAR2(10) NOT NULL,
	COMPLEMENTO_ENDERECO VARCHAR(255),
	CONSTRAINT PK_COLABORADOR PRIMARY KEY (MATRICULA),
	CONSTRAINT FK_DEPARTAMENTO_COLABORADOR
		FOREIGN KEY (DEPARTAMENTO)
		REFERENCES BRH.DEPARTAMENTO (SIGLA)
		DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT FK_ENDERECO_COLABORADOR 
		FOREIGN KEY (CEP)
		REFERENCES BRH.ENDERECO (CEP)
);

CREATE TABLE BRH.TELEFONE_COLABORADOR(
	NUMERO VARCHAR2(20) NOT NULL,
	COLABORADOR VARCHAR2(10) NOT NULL,
	TIPO CHAR(1) DEFAULT 'R' NOT NULL,
	CONSTRAINT PK_TELEFONE PRIMARY KEY (COLABORADOR, NUMERO),
	CONSTRAINT FK_TELEFONE_COLABORADOR
		FOREIGN KEY (COLABORADOR)
		REFERENCES BRH.COLABORADOR (MATRICULA),
	CONSTRAINT TIPO_TELEFONE_VALIDO CHECK (TIPO IN ('R', 'M', 'C'))
);

CREATE TABLE BRH.DEPENDENTE(
	CPF CHAR(14) NOT NULL,
	NOME VARCHAR2(255) NOT NULL,
	DATA_NASCIMENTO DATE NOT NULL,
	PARENTESCO VARCHAR2(20) NOT NULL,
	COLABORADOR VARCHAR2(10) NOT NULL,
	CONSTRAINT PK_DEPENDENTE PRIMARY KEY (CPF),
	CONSTRAINT FK_DEPENDENTE_COLABORADOR
		FOREIGN KEY (COLABORADOR)
		REFERENCES BRH.COLABORADOR (MATRICULA),
	CONSTRAINT PARENTESCO_VALIDO CHECK (PARENTESCO IN ('CÔNJUGE', 'FILHO(A)', 'PAI', 'MÃE'))
);

CREATE TABLE BRH.PROJETO (
	ID INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 5) NOT NULL,
	NOME VARCHAR2(255) NOT NULL,
	RESPONSAVEL VARCHAR2(10),
	INICIO DATE NOT NULL,
	FIM DATE,
	CONSTRAINT PK_PROJETO PRIMARY KEY (ID),
	CONSTRAINT FK_COLABORADOR_PROJETO
		FOREIGN KEY (RESPONSAVEL)
		REFERENCES BRH.COLABORADOR (MATRICULA),
	CONSTRAINT PROJETO_UNICO UNIQUE (NOME)
);

CREATE TABLE BRH.ATRIBUICAO (
	COLABORADOR VARCHAR2(10) NOT NULL,
	PROJETO INTEGER NOT NULL,
	PAPEL INTEGER NOT NULL,
	CONSTRAINT PK_ATRIBUICAO PRIMARY KEY (COLABORADOR, PROJETO, PAPEL)
);

ALTER TABLE BRH.DEPARTAMENTO 
	ADD CONSTRAINT FK_CHEFE_DEPARTAMENTO
	FOREIGN KEY (CHEFE) 
	REFERENCES BRH.COLABORADOR (MATRICULA)
	DEFERRABLE INITIALLY DEFERRED;
```
Inserção de dados
```
INSERT INTO BRH.PAPEL (ID, NOME) VALUES (1, 'DESENVOLVEDOR(A)'); 
INSERT INTO BRH.PAPEL (ID, NOME) VALUES (2, 'ARQUITETO(A) DE SOFTWARE');
INSERT INTO BRH.PAPEL (ID, NOME) VALUES (3, 'ENGENHEIRO(A) DEVOPS');
INSERT INTO BRH.PAPEL (ID, NOME) VALUES (4, 'PRODUCT OWNER');
INSERT INTO BRH.PAPEL (ID, NOME) VALUES (5, 'SCRUM MASTER');
INSERT INTO BRH.PAPEL (ID, NOME) VALUES (6, 'DBA');
INSERT INTO BRH.PAPEL (ID, NOME) VALUES (7, 'CIENTISTA DE DADOS');

INSERT INTO BRH.DEPARTAMENTO (SIGLA, NOME, CHEFE) VALUES ('DIR', 'DIRETORIA', 'A123');
INSERT INTO BRH.DEPARTAMENTO (SIGLA, NOME, CHEFE, DEPARTAMENTO_SUPERIOR) VALUES ('DEPTI', 'DEPARTAMENTO DE TECNOLOGIA DA INFORMAÇÃO', 'B123', 'DIR');
INSERT INTO BRH.DEPARTAMENTO (SIGLA, NOME, CHEFE, DEPARTAMENTO_SUPERIOR) VALUES ('SEDES', 'SEÇÃO DE DESENVOLVIMENTO DE SOLUÇÕES', 'C123', 'DEPTI');
INSERT INTO BRH.DEPARTAMENTO (SIGLA, NOME, CHEFE, DEPARTAMENTO_SUPERIOR) VALUES ('SEOPE', 'SEÇÃO DE OPERAÇÕES E MONITORAMENTO', 'D123', 'DEPTI');
INSERT INTO BRH.DEPARTAMENTO (SIGLA, NOME, CHEFE, DEPARTAMENTO_SUPERIOR) VALUES ('SESEG', 'SEÇÃO DE SEGURANÇA DA INFORMAÇÃO', 'E123', 'DEPTI');
INSERT INTO BRH.DEPARTAMENTO (SIGLA, NOME, CHEFE, DEPARTAMENTO_SUPERIOR) VALUES ('DEREH', 'DEPARTAMENTO DE RECURSOS HUMANOS', 'F123', 'DIR');
INSERT INTO BRH.DEPARTAMENTO (SIGLA, NOME, CHEFE, DEPARTAMENTO_SUPERIOR) VALUES ('SEFOL', 'SEÇÃO DE FOLHA DE PAGAMENTO', 'G123', 'DEREH');
INSERT INTO BRH.DEPARTAMENTO (SIGLA, NOME, CHEFE, DEPARTAMENTO_SUPERIOR) VALUES ('SECAP', 'SEÇÃO DE CAPACITAÇÃO CONTINUADA', 'H123', 'DEREH');

INSERT INTO BRH.ENDERECO (CEP, UF, CIDADE, BAIRRO, LOGRADOURO) VALUES ('71222-100', 'DF', 'BRASÍLIA', 'ÁGUAS CLARAS', 'AVENIDA DAS CASTANHEIRAS');
INSERT INTO BRH.ENDERECO (CEP, UF, CIDADE, BAIRRO, LOGRADOURO) VALUES ('71222-200', 'TO', 'PALMAS', 'PLANO DIRETOR NORTE', 'ÁREA RESIDENCIAL NORDESTE - ARNE');
INSERT INTO BRH.ENDERECO (CEP, UF, CIDADE, BAIRRO, LOGRADOURO) VALUES ('71222-300', 'AM', 'MANAUS', 'PRESIDENTE VARGAS', 'RUA DA LEGIÃO');
INSERT INTO BRH.ENDERECO (CEP, UF, CIDADE, BAIRRO, LOGRADOURO) VALUES ('71222-400', 'MG', 'PATOS DE MINAS', 'MAJOR PORTO', 'AVENIDA PRINCIPAL');
INSERT INTO BRH.ENDERECO (CEP, UF, CIDADE, BAIRRO, LOGRADOURO) VALUES ('71222-700', 'PB', 'JOÃO PESSOA', 'CABO BRANCO', 'AVENIDA COSTEIRA');

INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('A123', 'ANA', '376.574.270-86', 'ANA@EMAIL.COM', 'ANA@CORP.COM', '48666', 'DIR', '71222-100', 'CASA 1');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('B123', 'BIA', '325.066.470-74', 'BIA@EMAIL.COM', 'BIA@CORP.COM', '2967', 'DEPTI', '71222-200', 'APTO 101 - ED BONITÃO');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('C123', 'CAIO', '639.999.330-03', 'CAIO@EMAIL.COM', 'CAIO@CORP.COM', '6512', 'SEDES', '71222-300', 'CASA 4');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('D123', 'DANI', '735.960.820-13', 'DANI@EMAIL.COM', 'DANI@CORP.COM', '2784', 'SEOPE', '71222-700', 'COND. VILA REAL - CASA 3');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('E123', 'ELI', '215.347.960-61', 'ELI@EMAIL.COM', 'ELI@CORP.COM', '6233', 'SESEG', '71222-700', 'COND. VILA REAL - CASA 32');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('F123', 'FRED', '512.154.870-29', 'FRED@EMAIL.COM', 'FRED@CORP.COM', '6847', 'DEREH', '71222-200', 'APTO 202 - ED BONITÃO');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('G123', 'GABI', '750.471.040-79', 'GABI@EMAIL.COM', 'GABI@CORP.COM', '7220', 'SEFOL', '71222-400', 'CHÁCARA 12');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('H123', 'HUGO', '206.642.180-40', 'HUGO@EMAIL.COM', 'HUGO@CORP.COM', '6357', 'SECAP', '71222-300', 'CASA 7');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('I123', 'IVO', '239.264.900-63', 'IVO@EMAIL.COM', 'IVO@CORP.COM', '6854', 'SEDES', '71222-400', 'CHÁCARA 6');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('J123', 'JOÃO', '945.334.020-03', 'JOÃO@EMAIL.COM', 'JOÃO@CORP.COM', '2724', 'SEOPE', '71222-400', 'CHÁCARA 16');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('K123', 'KELLY', '529.049.230-55', 'KELLY@EMAIL.COM', 'KELLY@CORP.COM', '7500', 'SESEG', '71222-300', 'CASA 68');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('L123', 'LARA', '099.710.680-87', 'LARA@EMAIL.COM', 'LARA@CORP.COM', '6854', 'SEFOL', '71222-700', 'COND. VILA REAL - CASA 9');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('M123', 'MARIA', '943.762.640-59', 'MARIA@EMAIL.COM', 'MARIA@CORP.COM', '6999', 'SECAP', '71222-400', 'CHÁCARA 16');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('N123', 'NEI', '339.099.960-43', 'NEI@EMAIL.COM', 'NEI@CORP.COM', '5487', 'SEDES', '71222-700', 'COND. VILA REAL - CASA 15');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('O123', 'OLÍVIA', '620.476.920-08', 'OLIVIA@EMAIL.COM', 'OLÍVIA@CORP.COM', '6895', 'SEOPE', '71222-200', 'APTO 303 - ED BONITÃO');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('P123', 'PAULO', '609.136.270-46', 'PAULO@EMAIL.COM', 'PAULO@CORP.COM', '6456', 'SESEG', '71222-300', 'CASA 16');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('Q123', 'QUÊNIA', '300.976.320-40', 'QUENIA@EMAIL.COM', 'QUÊNIA@CORP.COM', '2869', 'SEFOL', '71222-400', 'CHÁCARA 2');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('R123', 'RUI', '203.460.970-02', 'RUI@EMAIL.COM', 'RUI@CORP.COM', '6778', 'SECAP', '71222-700', 'COND. VILA REAL - CASA 11');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('S123', 'SARA', '192.379.870-72', 'SARA@EMAIL.COM', 'SARA@CORP.COM', '2864', 'SEDES', '71222-200', 'APTO 404 - ED BONITÃO');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('T123', 'TATI', '007.563.930-00', 'TATI@EMAIL.COM', 'TATI@CORP.COM', '6555', 'SEOPE', '71222-400', 'CHÁCARA 4');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('U123', 'URI', '701.845.310-04', 'URI@EMAIL.COM', 'URI@CORP.COM', '49068', 'DIR', '71222-100', 'CASA 30');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('V123', 'VINI', '164.902.830-00', 'VINI@EMAIL.COM', 'VINI@CORP.COM', '5335', 'SEFOL', '71222-200', 'APTO 505 - ED BONITÃO');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('W123', 'WANDO', '638.965.680-78', 'WANDO@EMAIL.COM', 'WANDO@CORP.COM', '5621', 'SECAP', '71222-400', 'CHÁCARA 8');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('X123', 'XENA', '128.798.200-06', 'XENA@EMAIL.COM', 'XENA@CORP.COM', '6632', 'SEDES', '71222-700', 'COND. VILA REAL - CASA 23');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('Y123', 'YARA', '174.247.350-47', 'YARA@EMAIL.COM', 'YARA@CORP.COM', '5741', 'SEOPE', '71222-200', 'APTO 606 - ED BONITÃO');
INSERT INTO BRH.COLABORADOR (MATRICULA, NOME, CPF, EMAIL_PESSOAL, EMAIL_CORPORATIVO, SALARIO, DEPARTAMENTO, CEP, COMPLEMENTO_ENDERECO) VALUES ('Z123', 'ZICO', '103.845.160-41', 'ZICO@EMAIL.COM', 'ZICO@CORP.COM', '49944', 'DIR', '71222-400', 'CHÁCARA 19');

INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('A123', '(43) 97503-7342', 'M'); 
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('A123', '(43) 3334-4676', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('B123', '(43) 98730-7585', 'M'); 
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('B123', '(43) 2236-6847', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('C123', '(45) 98919-8791', 'M'); 
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('C123', '(45) 3213-7045', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('D123', '(42) 97115-7233', 'M'); 
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('D123', '(42) 3457-4737', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('E123', '(45) 98086-0216', 'M'); 
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('E123', '(45) 3894-6678', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('F123', '(41) 98226-6125', 'M'); 
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('G123', '(44) 99555-3353', 'M');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('G123', '(44) 2613-7831', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('H123', '(44) 98116-4624', 'M'); 
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('H123', '(44) 2613-7831', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('I123', '(44) 98490-1528', 'M');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('J123', '(44) 98662-3114', 'M');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('J123', '(44) 2711-6813', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('K123', '(44) 99418-5539', 'M');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('L123', '(44) 97945-1718', 'M');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('L123', '(44) 2613-7831', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('M123', '(43) 98783-3567', 'M'); 
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('M123', '(43) 3182-7732', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('N123', '(45) 99133-2271', 'M'); 
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('N123', '(45) 2987-4535', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('O123', '(44) 99153-3715', 'M'); 
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('O123', '(44) 2484-0846', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('P123', '(45) 97998-5727', 'M'); 
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('P123', '(45) 2713-5787', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('Q123', '(42) 99312-3648', 'M'); 
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('R123', '(46) 98135-6010', 'M');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('R123', '(46) 3622-4323', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('S123', '(43) 96711-4212', 'M'); 
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('S123', '(43) 2525-8373', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('T123', '(41) 99743-3624', 'M'); 
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('T123', '(41) 2739-7614', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('U123', '(43) 99948-6048', 'M'); 
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('U123', '(43) 2496-7601', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('V123', '(44) 97450-4926', 'M'); 
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('V123', '(44) 2880-8483', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('W123', '(42) 98329-7151', 'M'); 
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('X123', '(44) 98122-8742', 'M');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('X123', '(44) 2471-1542', 'R');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('Y123', '(45) 96825-7324', 'M'); 
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('Z123', '(42) 96782-4335', 'M');
INSERT INTO BRH.TELEFONE_COLABORADOR (COLABORADOR, NUMERO, TIPO) VALUES ('Z123', '(42) 3469-3136', 'R'); 
 
INSERT INTO BRH.PROJETO (NOME, RESPONSAVEL, INICIO, FIM) VALUES ('COMEX', 'G123', TO_DATE('2022-01-01', 'YYYY-MM-DD'), NULL);
INSERT INTO BRH.PROJETO (NOME, RESPONSAVEL, INICIO, FIM) VALUES ('ORACLE EXADATA', 'P123', TO_DATE('2020-08-01', 'YYYY-MM-DD'), TO_DATE('2021-08-31', 'YYYY-MM-DD'));
INSERT INTO BRH.PROJETO (NOME, RESPONSAVEL, INICIO, FIM) VALUES ('DIMENX', 'D123', TO_DATE('2021-01-01', 'YYYY-MM-DD'), TO_DATE('2021-12-31', 'YYYY-MM-DD'));
INSERT INTO BRH.PROJETO (NOME, RESPONSAVEL, INICIO, FIM) VALUES ('BRH', 'T123', TO_DATE('2022-05-01', 'YYYY-MM-DD'), NULL);

INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('243.361.552-67', 'A123', 'MAITÊ', 'FILHO(A)', TO_DATE('2015-01-01', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('673.340.136-38', 'A123', 'MIGUEL', 'FILHO(A)', TO_DATE('2015-08-02', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('437.814.540-53', 'A123', 'LUCAS', 'CÔNJUGE', TO_DATE('1985-06-07', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('136.155.762-17', 'B123', 'AURORA', 'FILHO(A)', TO_DATE('2021-01-14', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('185.252.486-30', 'C123', 'HEITOR', 'FILHO(A)', TO_DATE('2005-01-20', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('338.860.528-93', 'C123', 'LAURA', 'CÔNJUGE', TO_DATE('1975-06-30', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('737.572.374-55', 'C123', 'MAYA', 'FILHO(A)', TO_DATE('2018-01-07', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('772.141.271-48', 'D123', 'GABRIEL', 'CÔNJUGE', TO_DATE('1960-09-09', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('764.194.838-32', 'E123', 'BENÍCIO', 'CÔNJUGE', TO_DATE('1976-11-17', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('616.187.472-58', 'F123', 'SAMUEL', 'FILHO(A)', TO_DATE('2016-07-10', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('785.512.478-08', 'H123', 'DAVI', 'FILHO(A)', TO_DATE('2008-03-11', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('007.981.185-04', 'I123', 'ANTONELLA', 'FILHO(A)', TO_DATE('2019-05-05', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('936.335.601-90', 'I123', 'ELOÁ', 'FILHO(A)', TO_DATE('2003-08-18', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('371.508.442-19', 'J123', 'LIZ', 'CÔNJUGE', TO_DATE('1991-11-24', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('531.325.332-89', 'K123', 'GUILHERME', 'CÔNJUGE', TO_DATE('1995-06-06', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('648.420.453-53', 'L123', 'BENJAMIM', 'FILHO(A)', TO_DATE('2009-06-07', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('841.486.580-10', 'L123', 'GAEL', 'FILHO(A)', TO_DATE('2008-07-11', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('757.125.312-83', 'M123', 'REBECA', 'FILHO(A)', TO_DATE('2013-08-01', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('112.675.927-96', 'N123', 'LUNA', 'FILHO(A)', TO_DATE('2011-12-31', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('130.810.418-99', 'O123', 'AYLA', 'FILHO(A)', TO_DATE('2014-12-25', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('632.282.137-73', 'O123', 'BEATRIZ', 'FILHO(A)', TO_DATE('2014-04-01', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('248.372.338-13', 'Q123', 'RAVI', 'FILHO(A)', TO_DATE('2015-01-22', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('314.352.484-73', 'R123', 'NOAH', 'FILHO(A)', TO_DATE('2019-09-23', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('718.314.271-09', 'S123', 'LEVI', 'FILHO(A)', TO_DATE('2021-06-19', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('435.604.284-08', 'S123', 'ARTHUR', 'FILHO(A)', TO_DATE('2022-01-05', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('028.544.528-60', 'T123', 'ALICE', 'FILHO(A)', TO_DATE('2018-11-25', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('434.084.223-03', 'T123', 'CECÍLIA', 'FILHO(A)', TO_DATE('2016-12-07', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('374.874.270-30', 'V123', 'HELENA', 'CÔNJUGE', TO_DATE('1984-06-07', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('787.929.741-39', 'V123', 'JÚLIA', 'FILHO(A)', TO_DATE('2006-03-31', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('782.961.224-21', 'V123', 'TAINÁ', 'FILHO(A)', TO_DATE('1995-03-24', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('563.803.531-19', 'W123', 'CAMILA', 'CÔNJUGE', TO_DATE('1970-03-01', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('647.672.118-67', 'X123', 'ALEXANDRE', 'CÔNJUGE', TO_DATE('1974-08-04', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('164.363.845-96', 'X123', 'MILENA', 'FILHO(A)', TO_DATE('1996-06-13', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('930.064.462-91', 'Y123', 'JÉSSICA', 'FILHO(A)', TO_DATE('2002-02-22', 'YYYY-MM-DD'));
INSERT INTO BRH.DEPENDENTE (CPF, COLABORADOR, NOME, PARENTESCO, DATA_NASCIMENTO) VALUES ('333.716.787-09', 'Z123', 'RUI', 'FILHO(A)', TO_DATE('2009-04-15', 'YYYY-MM-DD'));

INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (1, 'B123', 2);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (2, 'C123', 2);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (3, 'E123', 2);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (1, 'F123', 5);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (3, 'H123', 1);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (2, 'I123', 5);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (3, 'J123', 5);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (4, 'K123', 2);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (1, 'L123', 1);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (2, 'M123', 3);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (3, 'N123', 1);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (1, 'O123', 1);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (4, 'Q123', 1);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (2, 'R123', 3);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (2, 'S123', 3);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (2, 'V123', 3);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (2, 'W123', 3);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (1, 'X123', 1);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (1, 'Y123', 1);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (1, 'R123', 1);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (3, 'R123', 5);
INSERT INTO BRH.ATRIBUICAO (PROJETO, COLABORADOR, PAPEL) VALUES (4, 'R123', 2);
 
COMMIT;
```
Relatórios
```

SELECT COLAB.NOME AS COLAB_NOME, DEP.NOME AS NOME_DEP, DEP.DATA_NASCIMENTO
FROM BRH.COLABORADOR COLAB
JOIN BRH.DEPENDENTE DEP
ON COLAB.MATRICULA = DEP.COLABORADOR
WHERE TO_CHAR(DEP.DATA_NASCIMENTO, 'MM')IN(04, 05, 06) or UPPER(DEP.NOME) LIKE '%H%'
ORDER BY COLAB.NOME, DEP.NOME

~~~~~~~~~~

SELECT COLAB.NOME, COLAB.SALARIO
FROM BRH.COLABORADOR COLAB
WHERE COLAB.SALARIO = 
(SELECT MAX (BRH.COLABORADOR.SALARIO)FROM BRH.COLABORADOR) 
ORDER BY COLAB.SALARIO DESC

~~~~~~~~~~

SELECT COLAB.MATRICULA, COLAB.NOME, COLAB.SALARIO,
(CASE WHEN COLAB.SALARIO <= 3000.00 THEN 'Júnior'
WHEN COLAB.SALARIO >=3000.01 
AND COLAB.SALARIO <= 6000.00  THEN 'Pleno'
WHEN COLAB.SALARIO >=6000.01 
AND COLAB.SALARIO <= 20000.00 THEN 'Sênior'
ELSE 'Corpo diretor'
END)AS SENIORIDADE
FROM BRH.COLABORADOR COLAB
ORDER BY SENIORIDADE, COLAB.NOME

~~~~~~~~~~

SELECT DEP.NOME AS DEPARTAMENTO, PROJ.NOME AS PROJETO, COUNT (*)AS NUMERO_COLAB
FROM BRH.DEPARTAMENTO DEP
INNER JOIN BRH.COLABORADOR COLAB 
ON DEP.SIGLA = COLAB.DEPARTAMENTO
INNER JOIN BRH.ATRIBUICAO ATT
ON COLAB.MATRICULA = ATT.COLABORADOR
INNER JOIN BRH.PROJETO PROJ
ON ATT.PROJETO = PROJ.ID
GROUP BY DEP.NOME,PROJ.NOME
ORDER BY DEP.NOME, PROJ.NOME
  
~~~~~~~~~~

SELECT COLAB.NOME,COUNT (*)AS DEPENDENTES
FROM BRH.DEPENDENTE DEP
INNER JOIN BRH.COLABORADOR COLAB
ON DEP.COLABORADOR = COLAB.MATRICULA
GROUP BY COLAB.NOME 
HAVING COUNT (*) >= 2
ORDER BY COLAB.NOME, DEPENDENTES DESC

~~~~~~~~~~

SELECT CPF,nome,data_nascimento,parentesco,colaborador,floor((SYSDATE - BRH.DEPENDENTE.DATA_NASCIMENTO)/365.0) AS IDADE, 
(CASE WHEN (SYSDATE - BRH.DEPENDENTE.DATA_NASCIMENTO)/365 < 18 THEN 'Menor de Idade'
ELSE 'Maior de Idade'
END)AS Faixa_Etaria
FROM BRH.DEPENDENTE
ORDER BY COLABORADOR,NOME

~~~~~~~~~~
CREATE OR REPLACE VIEW BRH.VW_DEP AS
SELECT CPF,nome as nome_dep,data_nascimento,parentesco,colaborador, floor((SYSDATE - BRH.DEPENDENTE.DATA_NASCIMENTO)/365.0) AS IDADE, 
(CASE WHEN (SYSDATE - BRH.DEPENDENTE.DATA_NASCIMENTO)/365 < 18 THEN 'Menor de Idade'
ELSE 'Maior de Idade'
END)AS Faixa_Etaria
FROM BRH.DEPENDENTE
ORDER BY COLABORADOR,NOME

~~~~~~~~~~

SELECT COLABORADOR, SUM(VALOR) AS TOTAL FROM (
SELECT D.COLABORADOR,100 AS VALOR
FROM BRH.VW_DEP D
WHERE D.PARENTESCO = 'Cônjuge'
UNION
SELECT D.COLABORADOR, 50 AS VALOR
FROM BRH.VW_DEP D
WHERE D.PARENTESCO = 'Filho(a)' AND D.FAIXA_ETARIA = 'Maior de Idade'
UNION ALL
SELECT D.COLABORADOR, 25 AS VALOR
FROM BRH.VW_DEP D
WHERE D.PARENTESCO = 'Filho(a)' AND D.FAIXA_ETARIA = 'Menor de Idade'
UNION ALL
SELECT COLAB.MATRICULA,
CASE
WHEN COLAB.SALARIO <3000 THEN COLAB.SALARIO * 0.01
WHEN COLAB.SALARIO <=6000 THEN COLAB.SALARIO * 0.02
WHEN COLAB.SALARIO <=20000 THEN COLAB.SALARIO * 0.03
ELSE COLAB.SALARIO * 0.05
END  
AS VALOR
FROM BRH.COLABORADOR COLAB
)
GROUP BY COLABORADOR
ORDER BY COLABORADOR

~~~~~~~~~~

SELECT * 
FROM (
SELECT ROWNUM AS NUMERO, COLAB.NOME
FROM  BRH.COLABORADOR COLAB
)PG
WHERE ROWNUM <11
ORDER BY NOME ;


SELECT * 
FROM (
SELECT ROWNUM AS NUMERO, COLAB.NOME
FROM  BRH.COLABORADOR COLAB
)PG
WHERE NUMERO > 10 AND NUMERO <= 20 
ORDER BY NOME ;


SELECT * 
FROM (
SELECT ROWNUM AS NUMERO, COLAB.NOME
FROM  BRH.COLABORADOR COLAB
)PG
WHERE NUMERO > 20 AND NUMERO <= 30 
ORDER BY NOME ;

~~~~~~~~~~

SELECT ATRIB.COLABORADOR, COUNT(ATRIB.PROJETO) AS PROJETOS
FROM BRH.ATRIBUICAO ATRIB
GROUP BY ATRIB.COLABORADOR
HAVING COUNT(ATRIB.PROJETO) = (SELECT COUNT(*) FROM BRH.PROJETO);

```
Procedures 
```

SET SERVEROUTPUT ON;
~~~~~~~~~~
CREATE OR REPLACE PROCEDURE BRH.INSERE_PROJETO(
P_NOME IN VARCHAR2,
P_RESPONSAVEL IN VARCHAR2,
P_INICIO IN DATE)
IS 
BEGIN
INSERT INTO BRH.PROJETO (NOME,RESPONSAVEL,INICIO) VALUES (P_NOME,UPPER(P_RESPONSAVEL),P_INICIO);
END;

EXECUTE BRH.INSERE_PROJETO('MCD','V123',SYSDATE);
```

Faz a mesma coisa da Procedure acima porem com tratamento de erro

```
CREATE or replace PROCEDURE BRH.INSERE_PROJETO
(

P_NOME IN VARCHAR2,
P_RESPONSAVEL IN VARCHAR2,
P_INICIO IN DATE
)
IS 
BEGIN
INSERT INTO BRH.PROJETO (NOME,RESPONSAVEL,INICIO) VALUES (P_NOME,UPPER(P_RESPONSAVEL),P_INICIO);
IF LENGTH(P_NOME) < 2 OR LENGTH(P_NOME) = NULL THEN
     
        dbms_output.put_line( P_NOME || ' Nome de projeto inválido! Deve ter dois ou mais caracteres. ' );
    ELSE
        dbms_output.put_line('Cadastrado com Sucesso ' || P_NOME);
       
    END IF;
END;

EXECUTE BRH.INSERE_PROJETO ('X','V123',sysdate);
EXECUTE BRH.INSERE_PROJETO ('XX','V123',sysdate);
```
Functions
```
CREATE OR REPLACE FUNCTION BRH.FINALIZA_PROJETO(
P_ID IN BRH.PROJETO.ID%TYPE)
RETURN BRH.PROJETO.FIM%TYPE
IS
P_FIM PROJETO.FIM%TYPE;
BEGIN
P_FIM := SYSDATE;
UPDATE BRH.PROJETO
SET FIM = P_FIM
WHERE ID = P_ID;
RETURN P_FIM;
END;

DECLARE
P_FIM DATE;
BEGIN
P_FIM := BRH.FINALIZA_PROJETO(1);
DBMS_OUTPUT.PUT_LINE('DATA DE TERMINO DO PROJETO É ' || P_FIM);
END;

SELECT * FROM BRH.PROJETO;
~~~~~~~~~~
CREATE OR REPLACE FUNCTION BRH.CALCULA_IDADE (
P_NASCIMENTO IN DATE
)
RETURN NUMBER
IS  
  P_IDADE NUMBER;
BEGIN
    P_IDADE := TRUNC((MONTHS_BETWEEN(SYSDATE, P_NASCIMENTO)/12));
    RETURN P_IDADE;
END;

DECLARE
   P_NASCIMENTO DATE := TO_DATE('03-07-1961','DD-MM-YYYY');
BEGIN
   DBMS_OUTPUT.PUT_LINE('A PESSOA TEM ' || BRH.CALCULA_IDADE(P_NASCIMENTO) || ' ANOS DE IDADE.' );
END;

```
Faz a mesma coisa da Function acima porem com impossibilidade de data de nascimento ser maior que sysdate
```
CREATE OR REPLACE FUNCTION BRH.CALCULA_IDADE (
P_NASCIMENTO IN DATE
)
RETURN NUMBER
IS  
  P_IDADE NUMBER;
BEGIN
     IF P_NASCIMENTO > SYSDATE OR P_NASCIMENTO = NULL THEN
       dbms_output.put_line('Impossível calcular idade! Data inválida: ' || P_NASCIMENTO);
    ELSE
      P_IDADE := TRUNC((MONTHS_BETWEEN(SYSDATE, P_NASCIMENTO)/12));
    END IF;
    RETURN P_IDADE;

END;

DECLARE
   P_NASCIMENTO DATE := TO_DATE('15-09-2023','DD-MM-YYYY');
BEGIN
 DBMS_OUTPUT.PUT_LINE(BRH.CALCULA_IDADE(P_NASCIMENTO) );
END;

DECLARE
   P_NASCIMENTO DATE := TO_DATE('03-07-1961','DD-MM-YYYY');
BEGIN
 DBMS_OUTPUT.PUT_LINE(BRH.CALCULA_IDADE(P_NASCIMENTO) );
END;
```
