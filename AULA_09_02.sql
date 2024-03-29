﻿CREATE DATABASE ADS_3;

-- SEXO = {CODSEXO, NOMESEXO}
CREATE TABLE SEXO(
	CODSEXO SERIAL PRIMARY KEY,
	NOMESEXO VARCHAR(9) NOT NULL UNIQUE
);

-- CONSULTA SIMPLES
SELECT * FROM SEXO;

-- INSERINDO INFORMAÇÕES NA TABELA SEXO
INSERT INTO SEXO(NOMESEXO) VALUES 
('FEMININOS');
INSERT INTO SEXO(NOMESEXO) VALUES 
('MASCULINO');

-- CURSO = {CODCURSO, NOMECURSO}
CREATE TABLE CURSO(
	CODCURSO SERIAL PRIMARY KEY,
	NOMECURSO VARCHAR(80) NOT NULL UNIQUE
);

INSERT INTO CURSO(NOMECURSO) VALUES ('ADS');
INSERT INTO CURSO(NOMECURSO) VALUES ('ENFERMAGEM');

SELECT * FROM CURSO;

-- ALUNO = {CODALUNO, NOMEALUNO, CODSEXO_FK, CODCURSO_FK, APELIDO}
CREATE TABLE ALUNO(
	CODALUNO SERIAL PRIMARY KEY,
	NOMEALUNO VARCHAR(80) NOT NULL,
	CODSEXO_FK INTEGER REFERENCES SEXO(CODSEXO) MATCH SIMPLE ON
	DELETE CASCADE ON UPDATE CASCADE,
	CODCURSO_FK INTEGER REFERENCES CURSO(CODCURSO)  MATCH SIMPLE ON
	DELETE CASCADE ON UPDATE CASCADE,
	APELIDO VARCHAR(80) NOT NULL
);

INSERT INTO ALUNO(NOMEALUNO, CODSEXO_FK, CODCURSO_FK, APELIDO) VALUES
('JOAO DA SILVA', 2, 3, 'JHONY');

INSERT INTO ALUNO(NOMEALUNO, CODSEXO_FK, CODCURSO_FK, APELIDO) VALUES
('TEREZA', 1, 3, 'XUXA');

SELECT * FROM ALUNO;

-- AULA DO DIA 02_02
--COMANDO PARA ATUALIZAR DADOS DE UMA TABELA

-- CURSO = {CODCURSO, NOMECURSO}
SELECT * FROM CURSO;

UPDATE CURSO SET NOMECURSO = 'ANÁLISE E DESENVOLVIMENTO DE SISTEMAS' 
WHERE CODCURSO = 1;

-- ALUNO = {CODALUNO, NOMEALUNO, CODSEXO_FK, CODCURSO_FK, APELIDO}

SELECT * FROM ALUNO;
UPDATE ALUNO SET NOMEALUNO = 'TEREZINHA', APELIDO = 'TER' WHERE CODALUNO = 3;

UPDATE ALUNO SET CODCURSO_FK = 1 WHERE CODALUNO = 3;

-- COMANDO PARA APAGAR DADOS DE UMA TABELA

DELETE FROM CURSO WHERE NOMECURSO = 'ENFERMAGEM';

SELECT * FROM CURSO;

SELECT * FROM ALUNO;

UPDATE CURSO SET CODCURSO = 5 WHERE CODCURSO =1;

DELETE FROM CURSO WHERE CODCURSO = 5;


-- AULA 08/02/2023

--CONSULTAS EM BANCO DE DADOS

--SELECT (DETERMINA QUAIS CAMPOS VOU SELECIONAR) 
--FROM   (QUAIS TABELAS IREI USAR)
--WHERE  (CONDIÇÕES)

INSERT INTO CURSO(NOMECURSO)VALUES('ADS'),('ENFERMAGEM'),('ENGENHARIA CIVIL');

SELECT *
FROM CURSO;

SELECT CODCURSO, NOMECURSO FROM CURSO;

SELECT LOWER(NOMECURSO) FROM CURSO;

SELECT * FROM CURSO WHERE CODCURSO = 3;

SELECT * FROM CURSO WHERE CODCURSO = 3 OR CODCURSO = 4;

SELECT * FROM CURSO WHERE NOT(CODCURSO >= 3 AND CODCURSO <= 4);

SELECT * FROM CURSO WHERE NOMECURSO = 'ADs';

select * from curso where nomecurso like 'E%';

select * from curso where nomecurso like '%M';

select * from curso where nomecurso like '%RIA%';

-- CONTAR REGISTROS - COUNT
SELECT COUNT(CODCURSO) FROM CURSO WHERE NOMECURSO LIKE 'A%';

-- FUNÇÃO SOMA - SUM
SELECT SUM(CODCURSO) AS TOTAL FROM CURSO;

-- FUNÇÃO MÉDIA (AVG)

SELECT AVG(CODCURSO) AS MEDIA FROM CURSO;

SELECT 
(SELECT SUM(CODCURSO) AS TOTAL FROM CURSO) 
  / 
 (SELECT COUNT(CODCURSO) FROM CURSO)
  
-- MOSTRAR O MAIOR ELEMENTO - MAX
SELECT MAX(CODCURSO) FROM CURSO;

-- MOSTRARO MENOR ELEMENTO - MIN
SELECT MIN(CODCURSO) AS MENOR FROM CURSO;

--AULA 09/02/2023

SELECT * FROM ALUNO;

SELECT * FROM CURSO;

SELECT * FROM SEXO;

SELECT ALUNO.CODALUNO, ALUNO.NOMEALUNO, CURSO.NOMECURSO,
SEXO.NOMESEXO
FROM ALUNO, CURSO, SEXO
WHERE ALUNO.CODCURSO_FK = CURSO.CODCURSO 
AND SEXO.CODSEXO = ALUNO.CODSEXO_FK

-- CRIANDO APELIDOS PARA AS TABELAS
SELECT A.CODALUNO, A.NOMEALUNO, C.NOMECURSO, S.NOMESEXO
FROM ALUNO A, CURSO C, SEXO S
WHERE A.CODCURSO_FK = C.CODCURSO 
AND S.CODSEXO = A.CODSEXO_FK








