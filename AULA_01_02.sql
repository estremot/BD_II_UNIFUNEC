CREATE DATABASE ADS_3;

-- SEXO = {CODSEXO, NOMESEXO}
CREATE TABLE SEXO(
	CODSEXO SERIAL PRIMARY KEY,
	NOMESEXO VARCHAR(9) NOT NULL UNIQUE
);

-- CONSULTA SIMPLES
SELECT * FROM SEXO;

-- INSERINDO INFORMAÇÕES NA TABELA SEXO
INSERT INTO SEXO(NOMESEXO) VALUES 
('FEMININO');
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
('JOAO DA SILVA', 2, 1, 'JHONY');

INSERT INTO ALUNO(NOMEALUNO, CODSEXO_FK, CODCURSO_FK, APELIDO) VALUES
('TEREZA', 1, 2, 'XUXA');

SELECT * FROM ALUNO;


