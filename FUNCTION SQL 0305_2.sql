﻿-- FUNÇÕES NO POSTGRESQL

--SINTAXE

--CREATE OR REPLACE FUNCTION <NOMEFUNCAO>(<PARAMETROS>) RETURNS <TIPO_RET> AS
--'
--	<COMANDOS PARA REALIZAR A FUNÇÃO ESPECÍCA>
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

CREATE OR REPLACE FUNCTION P_FUNCAO() RETURNS INTEGER AS
'
	SELECT (5+2)*3 AS CALCULO;
' LANGUAGE SQL;

SELECT P_FUNCAO();

DROP FUNCTION SOMAR(INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION SOMAR(INTEGER, INTEGER) RETURNS INTEGER AS
'
	SELECT $1+$2;
'LANGUAGE SQL;

SELECT SOMAR(7,8);

CREATE OR REPLACE FUNCTION SOMAR2(N1 INTEGER, N2 INTEGER) RETURNS NUMERIC(10,2) AS
'
	SELECT (N1+N2)/2.0;
'LANGUAGE SQL;

SELECT SOMAR2(7,8);

CREATE FUNCTION IMPRIME_NOME(VARCHAR(80)) RETURNS VARCHAR AS
'
	SELECT $1;
' LANGUAGE SQL;

SELECT IMPRIME_NOME('MARCOS ANTONIO ESTREMOTE');


CREATE TABLE A (
	COD SERIAL PRIMARY KEY,
	NOME VARCHAR(80) NOT NULL
);

CREATE OR REPLACE FUNCTION INSERE_DADOS(NOME VARCHAR(80)) RETURNS VARCHAR AS
$$
	INSERT INTO A(NOME) VALUES ('TESTE');
	SELECT NOME;
$$LANGUAGE SQL;

SELECT * FROM A;

SELECT INSERE_DADOS('MARCOS ANTONIO ESTREMOTE');


CREATE TABLE INSTRUTOR(
	COD SERIAL PRIMARY KEY,
	NOME VARCHAR(80) NOT NULL,
	SALARIO DECIMAL(10,2)
);

CREATE OR REPLACE FUNCTION INSERE_DADOS_INSTRUTOR(NOM VARCHAR(80), SAL DECIMAL(10,2)) 
RETURNS VARCHAR AS
$$
	INSERT INTO INSTRUTOR(NOME, SALARIO) VALUES (NOM, SAL);
	SELECT NOM;
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

SELECT NOME, DOBRA_SALARIO(INSTRUTOR.*) FROM INSTRUTOR;

CREATE FUNCTION AUMENTO_SALARIO(VALOR DECIMAL) RETURNS VOID AS
$$
	UPDATE INSTRUTOR SET SALARIO = SALARIO * (1+(VALOR/100.0));
$$LANGUAGE SQL;

SELECT * FROM INSTRUTOR;

SELECT AUMENTO_SALARIO(20);

DROP FUNCTION INSTRUTORES();
CREATE OR REPLACE FUNCTION INSTRUTORES(VALOR DECIMAL) RETURNS SETOF INSTRUTOR AS
$$
	SELECT * FROM INSTRUTOR WHERE SALARIO > VALOR;
$$LANGUAGE SQL;

SELECT * FROM INSTRUTORES(300);

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


-- AULA 03/05 - 2

CREATE OR REPLACE FUNCTION P_FUNCAOX() RETURNS INTEGER AS 
$$
	DECLARE
		valor integer;
	BEGIN
		valor := 15;
		RETURN valor*2;
	END;

$$ LANGUAGE PLPGSQL;

SELECT * FROM P_FUNCAOX();

CREATE OR REPLACE FUNCTION P_FUNCAOX() RETURNS INTEGER AS $$
	DECLARE
		valor integer DEFAULT 15;
		--valor integer := 15
		--valor integer = 15
	BEGIN
		RETURN valor*2;
	END;

$$ LANGUAGE PLPGSQL;

SELECT P_FUNCAOX();

create or replace FUNCTION soma_string(nome varchar, snome varchar) returns varchar as 
$$
	DECLARE

	BEGIN
		RETURN NOME || ' - ' || SNOME;
	END;
$$LANGUAGE plpgsql;

SELECT SOMA_STRING('UNIFUNEC', '2023');

CREATE OR REPLACE FUNCTION INSERE_DADOS2(NOME VARCHAR(80)) RETURNS VOID AS
$$
	BEGIN
		INSERT INTO A(NOME) VALUES (INSERE_DADOS2.NOME);
	END;
$$LANGUAGE plpgsql;

SELECT INSERE_DADOS2('TESTE DE FUNÇÃO USANDO PLPGSQL');

SELECT * FROM A;

drop function instrutores2(valor decimal);
CREATE OR REPLACE FUNCTION INSTRUTORES2(VALOR DECIMAL) RETURNS INSTRUTOR AS
$$
	DECLARE
		Retorno instrutor;
	BEGIN
		SELECT * FROM INSTRUTOR WHERE SALARIO > VALOR INTO retorno;
		RETURN retorno;
	END;
$$LANGUAGE plpgsql;

select * from instrutores2(240);

CREATE OR REPLACE FUNCTION INSTRUTORES3(VALOR DECIMAL) RETURNS SETOF INSTRUTOR AS
$$
	BEGIN
		RETURN QUERY SELECT * FROM INSTRUTOR WHERE SALARIO < VALOR;
	END;
$$LANGUAGE plpgsql;

select * from instrutores3(240);


CREATE FUNCTION salario_ok(instrutor instrutor) RETURNS VARCHAR AS 
$$
	BEGIN
		IF instrutor.salario > 299 THEN
			RETURN 'Salário Bom';
		ELSE
			RETURN 'Salário pode aumentar!';
		END IF;
	END;
$$ LANGUAGE plpgsql;

SELECT nome, salario_ok(instrutor) from instrutor;

SELECT * FROM INSTRUTOR;



CREATE or replace FUNCTION salario2_ok(valor integer) RETURNS VARCHAR AS $$
	DECLARE
		Instrutor instrutor;
	BEGIN
		SELECT * FROM instrutor where cod = valor INTO instrutor;

		IF instrutor.salario > 299 THEN
			RETURN 'Salário Bom';
			ELSE
				RETURN 'Salário pode aumentar!';
		END IF;
	END;
$$ LANGUAGE plpgsql;

SELECT nome, salario2_ok(instrutor.cod) from instrutor;



drop function salario3_ok(id_instrutor INTEGER);

CREATE or replace FUNCTION salario3_ok(id_instrutor INTEGER) RETURNS VARCHAR AS $$
	DECLARE
		Instrutor instrutor;
	BEGIN
		SELECT * FROM instrutor WHERE cod = id_instrutor INTO instrutor;

			IF instrutor.salario < 299 THEN
				RETURN 'Salário Bom';
			ELSEIF instrutor.salario = 360 THEN
				RETURN 'TALVEZ AUMENTE!!!';
			ELSE
				RETURN 'Salário pode aumentar!';
			END IF;
	END;
$$ LANGUAGE plpgsql;

SELECT nome,  salario3_ok(instrutor.cod) from instrutor;

select * from instrutor;
CREATE FUNCTION tabuada (numero INTEGER) RETURNS SETOF INTEGER AS $$
BEGIN
RETURN NEXT numero * 1;
RETURN NEXT numero * 2;
RETURN NEXT numero * 3;
RETURN NEXT numero * 4;
END;
$$ LANGUAGE plpgsql;

select tabuada(8);


--************************************

drop function tabuada2(numero INTEGER);
CREATE or replace FUNCTION tabuada2 (numero INTEGER) RETURNS SETOF varchar AS $$
	DECLARE
		I INTEGER := 0;
	BEGIN

		LOOP
			RETURN NEXT numero || ' x ' || i || ' = ' || i * numero;
			I := i + 1;
			EXIT WHEN I = 11;
		END LOOP;
	END;
$$ LANGUAGE plpgsql;

select tabuada2(5);

CREATE or replace FUNCTION tabuada3 (numero INTEGER) RETURNS SETOF varchar AS $$
	DECLARE
		I INTEGER := 0;
	BEGIN

		while i <= 10 LOOP
			RETURN NEXT numero || ' x ' || i || ' = ' || i * numero;
			I := i + 1;	
		END LOOP;
	END;
$$ LANGUAGE plpgsql;

select tabuada3(8);

CREATE OR REPLACE FUNCTION tabuada4 (numero INTEGER) RETURNS SETOF varchar AS $$
	
	BEGIN

		FOR i IN 1..10 LOOP
			RETURN NEXT numero || ' x ' || i || ' = ' || i * numero;
		END LOOP;
	END;
$$ LANGUAGE plpgsql;

select tabuada4(11);

DROP FUNCTION instrutor_com_salario(OUT XX varchar, OUT YY varchar);

CREATE OR REPLACE FUNCTION instrutor_com_salario(OUT XX varchar, OUT YY varchar) returns SETOF record as
$$
	DECLARE 
		instrutor instrutor;
	BEGIN
		FOR instrutor in select * from instrutor loop
			XX := instrutor.nome;
			YY := salario3_ok(instrutor.cod);
			return next;
		end loop;
	END;

$$LANGUAGE PLPGSQL;

SELECT * FROM INSTRUTOR;

select * from instrutor_com_salario();


-- FUNÇÕES PARA MANIPULAR BANCO DE DADOS

CREATE TABLE ALUNO2(
	ID_ALUNO SERIAL PRIMARY KEY,
	PRIMEIRO_NOME VARCHAR(100) NOT NULL,
	ULTIMO_NOME VARCHAR(100) NOT NULL,
	DATA_NASCIMENTO DATE NOT NULL
);

CREATE TABLE CATEGORIA(
	ID_CATEGORIA SERIAL PRIMARY KEY,
	NOMECATEGORIA VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE CURSO(
	ID_CURSO SERIAL PRIMARY KEY,
	NOMECURSO VARCHAR(100) NOT NULL UNIQUE,
	ID_CATEGORIA_FK INTEGER REFERENCES CATEGORIA(ID_CATEGORIA)
);

CREATE TABLE ALUNO_CURSO(
	ID_ALUNO_FK INTEGER REFERENCES ALUNO2(ID_ALUNO),
	ID_CURSO_FK INTEGER REFERENCES CURSO(ID_CURSO),
	PRIMARY KEY (ID_ALUNO_FK, ID_CURSO_FK)
);

drop function CRIA_CURSO(NOME_CURSO VARCHAR, NOME_CATEGORIA VARCHAR);

CREATE or replace FUNCTION CRIA_CURSO(NOME_CURSO VARCHAR, NOME_CATEGORIA VARCHAR) RETURNS VARCHAR AS
$$
	DECLARE
		id_cat integer;
	BEGIN
		select id_categoria into id_cat from categoria where nomecategoria = upper(nome_categoria);

		if not found then
			insert into categoria (nomecategoria) values (upper(nome_categoria)) returning id_categoria into id_cat;
		end if;

		insert into curso (nomecurso, id_categoria_fk) values (upper(nome_curso), id_cat);

		RETURN 'Dados Inseridos com Sucesso';
	END;

$$LANGUAGE PLPGSQL;

select * from curso;

select * from categoria;

select cria_curso('SQL', 'BANCO DE DADOS');
select cria_curso('NOSQL', 'BANCO DE DADOS');
SELECT CRIA_CURSO('php','programação');
SELECT CRIA_CURSO('c#','Programação');
SELECT CRIA_CURSO('medicina','sei la');

SELECT * FROM CURSO;
SELECT * FROM CATEGORIA;

INSERT INTO CATEGORIA (NOMECATEGORIA) VALUES ('PROGRAMAÇÃO');


