﻿-- FUNÇÕES NO POSTGRESQL

--SINTAXE

--CREATE OR REPLACE FUNCTION <NOMEFUNCAO>(<PARAMETROS>) RETURNS <TIPO_RET> AS
--'
--	<COMANDOS PARA REALIZAR A FUNÇÃO ESPECÍFICA>
--' LANGUAGE SQL;

--CREATE OR REPLACE FUNCTION <NOMEFUNCAO>(<PARAMETROS>) RETURNS <TIPO_RET> AS
--$$
--	<COMANDOS PARA REALIZAR A FUNÇÃO ESPECÍCA>
--$$ LANGUAGE SQL;

--CREATE OR REPLACE FUNCTION <NOMEFUNCAO>(<PARAMETROS>) RETURNS <TIPO_RET> AS
--$teste$
--	<COMANDOS PARA REALIZAR A FUNÇÃO ESPECÍCA>
--$teste$ LANGUAGE SQL;

-- EXEMPLO PRIMEIRA FUNÇÃO NO POSTGRESQL

CREATE DATABASE AULA0305;

CREATE OR REPLACE FUNCTION P_FUNCAO() RETURNS INTEGER AS
'
	SELECT (5+2)*3 AS CALCULO;
' LANGUAGE SQL;

SELECT P_FUNCAO();

DROP FUNCTION SOMAR(INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION P_FUNCAO_B(INTEGER, INTEGER) RETURNS INTEGER AS
'
	SELECT ($1+$2)*3;
'LANGUAGE SQL;

SELECT P_FUNCAO_B(8,3);

CREATE OR REPLACE FUNCTION SOMAR(INTEGER, INTEGER) RETURNS INTEGER AS
$XUXA$
	SELECT ($1+$2);
$XUXA$LANGUAGE SQL;

SELECT SOMAR(7,8);



CREATE OR REPLACE FUNCTION SOMAR2(N1 INTEGER, N2 INTEGER) RETURNS NUMERIC(10,2) AS
'
	SELECT (N1+N2)/2.0;
'LANGUAGE SQL;

SELECT SOMAR2(7,8);

CREATE OR REPLACE FUNCTION IMPRIME_NOME(NOME VARCHAR(80)) RETURNS VARCHAR AS
'
	SELECT NOME;
' LANGUAGE SQL;


SELECT IMPRIME_NOME('MARCOS ANTONIO ESTREMOTE');


CREATE TABLE A (
	COD SERIAL PRIMARY KEY,
	NOME VARCHAR(80) NOT NULL
);

CREATE OR REPLACE FUNCTION INSERE_DADOS(NOMEAUX VARCHAR(80)) RETURNS VARCHAR AS
$$
	INSERT INTO A(NOME) VALUES (NOMEAUX);
	SELECT NOMEAUX;
$$LANGUAGE SQL;

SELECT * FROM A;

SELECT INSERE_DADOS('MARCOS ANTONIO ESTREMOTE');
SELECT INSERE_DADOS('OLGA DA SILVA');


CREATE TABLE INSTRUTOR(
	COD SERIAL PRIMARY KEY,
	NOME VARCHAR(80) NOT NULL,
	SALARIO DECIMAL(10,2)
);

CREATE OR REPLACE FUNCTION INSERE_DADOS_INSTRUTOR(NOME VARCHAR(80), SAL DECIMAL(10,2)) 
RETURNS VARCHAR AS
$$
	INSERT INTO INSTRUTOR(NOME, SALARIO) VALUES (NOME, SAL);
	SELECT NOME;
$$LANGUAGE SQL;

SELECT INSERE_DADOS_INSTRUTOR('MARCOS ANTONIO', 100);
SELECT INSERE_DADOS_INSTRUTOR('JOSÉ PAULO', 200);
SELECT INSERE_DADOS_INSTRUTOR('FABIO BORIS', 300);
SELECT INSERE_DADOS_INSTRUTOR('JESSE FERA', 400);
SELECT INSERE_DADOS_INSTRUTOR('THAYS PREFEITA', 500);

SELECT * FROM INSTRUTOR;

CREATE FUNCTION DOBRA_SALARIO(INSTRUTOR) RETURNS DECIMAL AS
$$
	SELECT $1.SALARIO * 2 AS DOBRO;
$$LANGUAGE SQL;

SELECT DOBRA_SALARIO(INSTRUTOR.*) FROM INSTRUTOR;

SELECT COD, NOME, DOBRA_SALARIO(INSTRUTOR.*) AS DOBRO FROM INSTRUTOR;

CREATE FUNCTION AUMENTO_SALARIO(VALOR DECIMAL) RETURNS VOID AS
$$
	UPDATE INSTRUTOR SET SALARIO = SALARIO * (1+(VALOR/100.0));
$$LANGUAGE SQL;

SELECT * FROM INSTRUTOR;
SELECT AUMENTO_SALARIO(20);

CREATE FUNCTION AUMENTO_SALARIO2(VALOR DECIMAL, ID INTEGER) RETURNS VOID AS
$$
	UPDATE INSTRUTOR SET SALARIO = SALARIO * (1+(VALOR/100.0)) WHERE COD = ID ;
$$LANGUAGE SQL;

SELECT AUMENTO_SALARIO2(10, 1);

SELECT * FROM INSTRUTOR;

SELECT AUMENTO_SALARIO2(15, 1);
SELECT AUMENTO_SALARIO(5);

DROP FUNCTION INSTRUTORES();

CREATE OR REPLACE FUNCTION INSTRUTORES(VALOR DECIMAL) RETURNS SETOF INSTRUTOR AS
$$
	SELECT * FROM INSTRUTOR WHERE SALARIO > VALOR;
$$LANGUAGE SQL;

SELECT INSTRUTORES(150);

SELECT * FROM INSTRUTORES(400);

CREATE FUNCTION SOMA_E_PRODUTO(IN N1 INTEGER, IN N2 INTEGER, OUT SOMA INTEGER, 
OUT PRODUTO INTEGER) AS
$$
	select n1+n2 as soma, n1*n2 as produto;
$$LANGUAGE SQL;

select * from soma_e_produto(3,3);


CREATE TYPE dados_retorno AS (soma integer, produto integer);

CREATE FUNCTION SOMA_E_PRODUTO2(IN N1 INTEGER, IN N2 INTEGER) 
returns dados_retorno AS
$$
	select n1+n2 as soma, n1*n2 as produto;
$$LANGUAGE SQL;

select * from Soma_e_produto2(5,5);


