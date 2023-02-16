create database aula_1502;

--curso = {codcurso, nomecurso}
create table curso(
	codcurso serial primary key,
	nomecurso varchar(80) not null unique
);
--sexo = {codsexo, nomesexo}
create table sexo(
	codsexo serial primary key,
	nomesexo varchar(9) not null unique
);
--rua = {codrua, nomerua}
create table rua(
	codrua serial primary key,
	nomerua varchar(80) not null unique
);
--bairro = {codbairro, nomebairro}
create table bairro(
	codbairro serial primary key,
	nomebairro varchar(80) not null unique
);
-- cep = {codcep, numerocep}
create table cep(
	codcep serial primary key,
	numerocep char(9) not null unique
);
--estado = {codestado, nomeestado, sigla}
create table estado(
	codestado serial primary key,
	nomestado varchar(80) not null unique,
	sigla char(2) not null unique
);
--cidade = {codcidade, nomecidade, codestado_fk}
create table cidade(
	codcidade serial primary key,
	nomecidade varchar(80) not null,
	codestado_fk integer references estado(codestado)
	match simple on delete cascade on update cascade
);
--aluno = {codaluno, nomealuno, codsexo_fk,
-- codcurso_fk, codrua_fk, codbairro_fk, codcep_fk,
--codcidade_fk}

create table aluno(
	codaluno serial primary key,
	nomealuno varchar(80) not null,
	codsexo_fk integer references sexo(codsexo)
	match simple on delete cascade on update cascade,
	codcurso_fk integer references curso(codcurso)
	match simple on delete cascade on update cascade,
	codrua_fk integer references rua(codrua)
	match simple on delete cascade on update cascade,
	codbairro_fk integer references bairro(codbairro)
	match simple on delete cascade on update cascade,
	codcep_fk integer references cep(codcep)
	match simple on delete cascade on update cascade,
	codcidade_fk integer references cidade(codcidade)
	match simple on delete cascade on update cascade
);

--curso = {codcurso, nomecurso}
insert into curso(nomecurso) values('ADS');
insert into curso(nomecurso) values('ENFERMAGEM');
insert into curso(nomecurso) values('MEDICINA');
insert into curso(nomecurso) values('AGRONOMIA');

SELECT * FROM CURSO
--sexo = {codsexo, nomesexo}
INSERT INTO SEXO(NOMESEXO) VALUES('MASCULINO');
INSERT INTO SEXO(NOMESEXO) VALUES('FEMININO');

--rua = {codrua, nomerua}
INSERT INTO RUA(NOMERUA) VALUES ('XV DE NOVEMBRO');
INSERT INTO RUA(NOMERUA) VALUES ('PASSEIO GOIANIA');

--bairro = {codbairro, nomebairro}
INSERT INTO BAIRRO(NOMEBAIRRO) VALUES('CENTRO');
INSERT INTO BAIRRO(NOMEBAIRRO) VALUES('JARDIM AEROPORTO');
-- cep = {codcep, numerocep}
INSERT INTO CEP(NUMEROCEP) VALUES ('15385-000');
INSERT INTO CEP(NUMEROCEP) VALUES ('15775-000');
--estado = {codestado, nomeestado, sigla}
INSERT INTO ESTADO(NOMESTADO, SIGLA) VALUES('SÃO PAULO','SP');
INSERT INTO ESTADO(NOMESTADO, SIGLA) VALUES('MINAS GERAIS','MG');
--cidade = {codcidade, nomecidade, codestado_fk}
INSERT INTO CIDADE(NOMECIDADE, CODESTADO_FK) VALUES
('SANTA FÉ DO SUL', 1);
INSERT INTO CIDADE(NOMECIDADE, CODESTADO_FK) VALUES
('ILHA SOLTEIRA', 1);
INSERT INTO CIDADE(NOMECIDADE, CODESTADO_FK) VALUES
('ITURAMA', 2);

SELECT * FROM CIDADE

SELECT * FROM ESTADO
--aluno = {codaluno, nomealuno, codsexo_fk,
-- codcurso_fk, codrua_fk, codbairro_fk, codcep_fk,
--codcidade_fk}
INSERT INTO ALUNO
(NOMEALUNO, CODSEXO_FK, CODCURSO_FK, CODRUA_FK, 
CODBAIRRO_FK, CODCEP_FK, CODCIDADE_FK) VALUES
('ELAINE', 1, 2, 2, 1, 1, 30 );


SELECT C.CODCIDADE, C.NOMECIDADE, C.CODESTADO_FK,
E.CODESTADO, E.SIGLA
FROM CIDADE C, ESTADO E
WHERE C.CODESTADO_FK = E.CODESTADO