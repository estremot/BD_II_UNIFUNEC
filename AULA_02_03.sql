﻿--BANCO DE DADOS COMÉRCIO
CREATE DATABASE COMERCIO2;

-- CRIAR TABELAS DO BANCO DE DADOS

--CRIAR UM DOMÍNIO
CREATE DOMAIN C_NOMES VARCHAR(80) NOT NULL;

-- MARCA = {CODMARCA, NOMEMARCA}
CREATE TABLE MARCA(
	CODMARCA SERIAL PRIMARY KEY,
	NOMEMARCA C_NOMES UNIQUE
);

SELECT * FROM MARCA;

-- alter table <nometabela> alter column tipo;
--ALTERAR O TIPO DE UMA COLUNA
ALTER TABLE MARCA ALTER COLUMN NOMEMARCA TYPE VARCHAR(40);

-- CRIAR UMA NOVA COLUNA
ALTER TABLE MARCA ADD COLUMN DESCRICAO VARCHAR(80);
ALTER TABLE MARCA ADD COLUMN VALOR NUMERIC(10,2) NOT NULL DEFAULT 0.00;

INSERT INTO MARCA(NOMEMARCA) VALUES('NIKE');

UPDATE MARCA SET VALOR = 100.00 WHERE NOMEMARCA = 'NIKE';

-- REMOVENDO COLUNAS DE UMA TABELA (DROP)
ALTER TABLE MARCA DROP COLUMN DESCRICAO;

SELECT * FROM MARCA;

-- ALTERANDO MAIS DE COLUNA POR VEZ
ALTER TABLE MARCA
ALTER COLUMN NOMEMARCA TYPE VARCHAR(100),
ALTER COLUMN DESCRICAO TYPE VARCHAR(200);

-- INTEGER, NUMERIC(100,10), DOUBLE PRECISION, FLOAT, CHAR, CHAR[], VARCHAR,
-- VARCHAR[][], TEXT, BYTEA, DATE, TIME

ALTER TABLE MARCA DROP NOMEMARCA;
ALTER TABLE MARCA ADD COLUMN NOMEMARCA DATE;

--MUDANDO O NOME DE UMA COLUNA
ALTER TABLE MARCA RENAME COLUMN NOMEMARCA TO NOMES_MARCAS;

SELECT * FROM MARCA;

ALTER TABLE MARCA RENAME TO MARCAS;

SELECT * FROM MARCAS;

-- ADD RESTRIÇÕES
ALTER TABLE MARCAS DROP COLUMN DESCRICAO;
ALTER TABLE MARCAS DROP COLUMN NOMES_MARCAS;
--CRIANDO O CAMPO NOME MARCA
ALTER TABLE MARCAS ADD COLUMN NOMEMARCA VARCHAR(80);
ALTER TABLE MARCAS ADD COLUMN DESCRICAO TEXT;

SELECT * FROM MARCAS;
DELETE FROM MARCAS;
ALTER TABLE MARCAS ALTER COLUMN NOMEMARCA SET NOT NULL;
ALTER TABLE MARCAS ALTER COLUMN DESCRICAO SET NOT NULL;

INSERT INTO MARCAS(NOMEMARCA, DESCRICAO, VALOR) VALUES
('NIKE', 'ABC', 100.99);

--REMOVENDO RESTRIÇÃO DE ATRIBUTOS
ALTER TABLE MARCAS ALTER COLUMN DESCRICAO DROP NOT NULL;

-- VERIFICAR O TAMANHO DE UM CAMPO CHECK
ALTER TABLE MARCAS ADD CONSTRAINT CHK_DESCRICAO CHECK (char_length(DESCRICAO) >2);

-- APAGAR A RESTRIÇÃO CHECK
ALTER TABLE MARCAS DROP CONSTRAINT CHK_DESCRICAO;

-- ADICIONANDO CHAVE PRIMÁRIA
CREATE TABLE TESTE(
	CODTESTE SERIAL NOT NULL,
	NOMETESTE VARCHAR(80)
);

-- ADD CHAVE PRIMÁRIA
ALTER TABLE TESTE ADD PRIMARY KEY(CODTESTE);

--DEFININDO CAMPOS ÚNICOS
ALTER TABLE TESTE ALTER COLUMN NOMETESTE SET NOT NULL;
ALTER TABLE TESTE ADD CONSTRAINT UNQNOMETESTE UNIQUE (NOMETESTE);

SELECT * FROM TESTE;

-- ADD CAMPO CODMARCA_FK NA TABELA TESTE
ALTER TABLE TESTE ADD COLUMN CODMARCA_FK INTEGER;

ALTER TABLE TESTE ADD CONSTRAINT FK_CODMARCA FOREIGN KEY (CODMARCA_FK) 
REFERENCES MARCAS(CODMARCA)
MATCH SIMPLE ON DELETE CASCADE ON UPDATE CASCADE;

--ALTER TABLE TESTE ADD CONSTRAINT FK_CODMARCA FOREIGN KEY (CODMARCA_FK) REFERENCES MARCAS(CODMARCA)
--MATCH SIMPLE ON DELETE CASCADE;

--ALTER TABLE TESTE ADD CONSTRAINT FK_CODMARCA FOREIGN KEY (CODMARCA_FK) REFERENCES MARCAS(CODMARCA)
--MATCH SIMPLE ON UPDATE CASCADE;

--ALTER TABLE TESTE ADD CONSTRAINT FK_CODMARCA FOREIGN KEY (CODMARCA_FK) REFERENCES MARCAS(CODMARCA)
--MATCH FULL;


-- TIPO = {CODTIPO, NOMETIPO}
CREATE TABLE TIPO(
	CODTIPO SERIAL PRIMARY KEY,
	NOMETIPO C_NOMES UNIQUE
);

-- PRODUTO = {CODPRODUTO, NOMEPRODUTO, CODMARCA_FK, CODTIPO_FK, QUANTIDADE, VALORUNITARIO, QUANTMINIMA}
CREATE TABLE PRODUTO(
	CODPRODUTO SERIAL PRIMARY KEY,
	NOMEPRODUTO C_NOMES UNIQUE,
	CODMARCA_FK INTEGER REFERENCES MARCA(CODMARCA) MATCH SIMPLE ON UPDATE CASCADE,
	CODTIPO_FK INTEGER REFERENCES TIPO(CODTIPO) MATCH SIMPLE ON UPDATE CASCADE,
	QUANTIDADE NUMERIC(10,2) NOT NULL CHECK (QUANTIDADE >= 0),
	VALOR_UNITARIO NUMERIC(10,2) NOT NULL CHECK (VALOR_UNITARIO >=0),
	QUANTMINIMA NUMERIC(10,2) NOT NULL CHECK (QUANTMINIMA >=0)
);

-- SEXO = {CODSEXO, NOMESEXO}
CREATE TABLE SEXO(
	CODSEXO SERIAL PRIMARY KEY,
	NOMESEXO VARCHAR(9) NOT NULL UNIQUE
);

-- UF = {CODUF, NOMEUF, SIGLA}
CREATE TABLE UF(
	CODUF SERIAL PRIMARY KEY,
	NOMEUF C_NOMES UNIQUE,
	SIGLA CHAR(2) NOT NULL UNIQUE
);
-- CIDADE = {CODCIDADE, NOMECIDADE, CODUF_FK}
CREATE TABLE CIDADE(
	CODCIDADE SERIAL PRIMARY KEY,
	NOMECIDADE C_NOMES UNIQUE,
	CODUF_FK INTEGER REFERENCES UF(CODUF) MATCH SIMPLE ON UPDATE CASCADE
);

-- CLIENTE = {CODCLIENTE, NOMECLIENTE, CODSEXO_FK, RG, CODCIDADE_FK}
CREATE TABLE CLIENTE(
	CODCLIENTE SERIAL PRIMARY KEY,
	NOMECLIENTE C_NOMES UNIQUE,
	CODSEXO_FK INTEGER REFERENCES SEXO(CODSEXO) MATCH SIMPLE ON UPDATE CASCADE,
	RG C_NOMES,
	CODCIDADE_FK INTEGER REFERENCES CIDADE(CODCIDADE) MATCH SIMPLE ON UPDATE CASCADE
);
-- VENDA = {CODVENDA, DATAVENDA, CODCLIENTE_FK}
CREATE TABLE VENDA(
	CODVENDA SERIAL PRIMARY KEY,
	--DATAVENDA DATE NOT NULL CHECK (DATAVENDA = NOW()),
	DATAVENDA DATE NOT NULL,
	CODCLIENTE_FK INTEGER REFERENCES CLIENTE(CODCLIENTE) MATCH SIMPLE ON UPDATE CASCADE
);

-- ITENSVENDA = {CODVENDA_FK, CODPRODUTO_FK, QUANTV, VALORV}
CREATE TABLE ITENSVENDA(
	CODVENDA_FK INTEGER REFERENCES VENDA(CODVENDA) MATCH SIMPLE ON UPDATE CASCADE,
	CODPRODUTO_FK INTEGER REFERENCES PRODUTO(CODPRODUTO) MATCH SIMPLE ON UPDATE CASCADE,
	QUANTV NUMERIC(10,2) NOT NULL CHECK(QUANTV >= 0),
	VALORV NUMERIC(10,2) NOT NULL CHECK(VALORV >= 0)
);
ALTER TABLE ITENSVENDA ADD CONSTRAINT PK_CHAVE PRIMARY KEY (CODVENDA_FK, CODPRODUTO_FK);

-- SITUACAO = {CODSITUACAO, NOMESITUACAO}
CREATE TABLE SITUACAO(
	CODSITUACAO SERIAL PRIMARY KEY,
	SITUACAO C_NOMES UNIQUE
);

-- PARCELA = {CODPARCELA, VALORPARCELA, DATAVENCIMENTO, CODSITUACAO_FK}
CREATE TABLE PARCELA(
	CODPARCELA SERIAL PRIMARY KEY,
	VALORPARCELA NUMERIC(10,2) NOT NULL,
	DATAVENCIMENTO DATE NOT NULL,
	CODSITUACAO_FK INTEGER REFERENCES SITUACAO(CODSITUACAO) MATCH SIMPLE ON UPDATE CASCADE
);

-- QUESTÕES: ANTES DE SELECIONAR OS ELEMENTOS, INSIRA DADOS NO BANCO

-- MARCA = {CORMARCA, NOMEMARCA}


-- TIPO = {CODTIPO, NOMETIPO}

-- PRODUTO = {CODPRODUTO, NOMEPRODUTO, CODMARCA_FK, CODTIPO_FK, QUANTIDADE, VALOR_UNITARIO, QUANTMINIMA}

-- SEXO = {CODSEXO, NOMESEXO}

-- UF = {CODUF, NOMEUF, SIGLA}

-- CIDADE = {CODCIDADE, NOMECIDADE, CODUF_FK}

-- CLIENTE = {CODCLIENTE, NOMECLIENTE, CODSEXO_FK, RG, CODCIDADE_FK

--A) SELECIONE TODOS OS PRODUTOS DA MARCA "ARISCO"

--B) SELECIONE A QUANTIDADE DE CLIENTES CADASTRADOS NO BANCO DE DADOS.

--C) SELECIO A QUANTIDADE DE CLIENTES QUE MORAM NA CIDADE DE "SANTA FÉ DO SUL".

--D) SELECIONE A QUANTIDADE DE PRODUTOS NO ESTOQUE DO TIPO "ALIMENTÍCIO".

--E) SELECIONE TODAS AS INFORMAÇÕES DOS CLIENTES QUE MORAM NO ESTADO DE "MINAS GERAIS". 
-- nO LUGAR DE CÓDIGOS DE CHAVES ESTRANGEIRAS IMPRIMA O NOME DESTE CAMPO (CODSEXO -- NOMESEXO)

--F) SELECIONE O DADOS DO(S) PRODUTOS COM MAIOR VALOR UNITÁRIO CADASTRADO.

-- G) SELECIONE O NOME E O SUB-TOTAL DE TODOS OS PRODUTOS DA MARCA "COCA-COLA" E QUE TENHAM
-- EM ESTOQUE UMA DE QUANTIDADE DE 100 A 200 ELEMENTOS.

--H) SELECIONE O TOTAL DE TODAS AS PARCELAS VENCIDAS DO CLIENTE "MARCOS ANTONIO ESTREMOTE".

-- I) ATUALIZE O NOME PRODUTO "COCA-COLA" PARA "PEPSI-COLA";

-- J) REAJUSTE OS VALORES UNITÁRIOS EM 20% DE TODOS OS PRODUTOS DA MARCA "SEARA";

-- K) SELECIONE A QUANTIDADE DE MULHERES QUE COMPRARAM O PRODUTO "FANDANGOS".