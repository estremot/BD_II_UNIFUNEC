create database projeto_final;

--2) SEXO = {CODSEXO, NOMESEXO}
CREATE TABLE sexo(
	codsexo serial primary key,
	nomesexo varchar(9) not null unique
);
--3) RUA = {CODRUA, NOMERUA}
create table rua(
	codrua serial primary key,
	nomerua varchar(80) not null unique
);

--4) BAIRRO = {CODBAIRRO, NOMEBAIRRO}
create table bairro(
	codbairro serial primary key,
	nomebairro varchar(80) not null unique
);

--5) CEP = {CODCEP, NUMEROCEP}
create table cep(
	codcep serial primary key,
	numerocep char(9) not null unique
);

--7) UF = {CODUF, NOMEUF, SIGLA}
create table uf(
	coduf serial primary key,
	nomeuf varchar(80) not null unique
);

--6) CIDADE = {CODCIDADE, NOMECIDADE, CODUF}
create table cidade(
	codcidade serial primary key,
	nomecidade varchar(80) not null,
	coduf_fk integer references uf(coduf) match simple on delete 
	cascade on update cascade
);

--8) TRABALHO = {CODTRABALHO, NOMETRABALHO}
create table trabalho(
	codtrabalho serial primary key,
	nometrabalho varchar(80) not null
);

--1) CLIENTE = {CODCLIENTE, NOMECLIENTE, FOTO, DATANASC, CODSEXO, CODRUA, CODBAIRRO, 
--CODCEP, CODCIDADE, SALARIO, CODTRABALHO, NUMEROCASA}

create table cliente(
	codcliente serial primary key,
	nomecliente varchar(80) not null,
	codsexofk integer references sexo(codsexo),
	codrua_fk integer references rua(codrua),
	codbairro_fk integer references bairro(codbairro),
	codcep_fk integer references cep(codcep),
	codcidade_fk integer references cidade(codcidade),
	salario numeric(10,2) not null,
	codtrabalho_fk integer references trabalho(codtrabalho),
	numerocasa varchar(10) not null 
	
);


CREATE or replace FUNCTION INSERE_CIDADE(NOME_CIDADE VARCHAR, NOME_ESTADO VARCHAR) RETURNS VARCHAR AS
$$
	DECLARE
		id_uf integer;
	BEGIN
		select coduf into id_uf from uf where nomeuf = upper(nome_estado);

		if not found then
			insert into uf (nomeuf) values (upper(nome_estado)) returning coduf into id_uf;
		end if;

		insert into cidade (nomecidade, coduf_fk) values (upper(nome_cidade), id_uf);

		RETURN 'Dados Inseridos com Sucesso';
	END;

$$LANGUAGE PLPGSQL;


--1) CLIENTE = {CODCLIENTE, NOMECLIENTE, FOTO, DATANASC, CODSEXO, CODRUA, 
--CODBAIRRO, CODCEP, CODCIDADE, SALARIO, CODTRABALHO, NUMEROCASA}

CREATE or replace FUNCTION INSERE_CLIENTE(NOME_CLI VARCHAR, NOME_SEXO VARCHAR, NOME_RUA VARCHAR,
NOME_BAIRRO VARCHAR, NUMERO_CEP CHAR, NOME_CIDADE VARCHAR, SAL NUMERIC, NOME_TRABALHO VARCHAR,
NUMERO VARCHAR) RETURNS VARCHAR AS
$$
	DECLARE
		id_sexo integer;
		id_rua integer;
		id_bairro integer;
		id_cep integer;
		id_cidade integer;
		id_trabalho integer;
	BEGIN
		-- verificar sexo
		select codsexo into id_sexo from sexo where nomesexo = upper(nome_sexo);

		if not found then
			insert into sexo (nomesexo) values (upper(nome_sexo)) returning codsexo into id_sexo;
		end if;

		-- verificar rua
		select codrua into id_rua from rua where nomerua = upper(nome_rua);

		if not found then
			insert into rua (nomerua) values (upper(nome_rua)) returning codrua into id_rua;
		end if;

		-- verificar bairro
		select codbairro into id_bairro from bairro where nomebairro = upper(nome_bairro);

		if not found then
			insert into bairro (nomebairro) values (upper(nome_bairro)) returning codbairro into id_bairro;
		end if;

		-- verificar cep
		select codcep into id_cep from cep where numerocep = upper(numero_cep);

		if not found then
			insert into cep (numerocep) values (upper(numero_cep)) returning codcep into id_cep;
		end if;

		-- verificar cidade
		select codcidade into id_cidade from cidade where nomecidade = upper(nome_cidade);

		if not found then
			insert into cidade (nomecidade) values (upper(nome_cidade)) returning codcidade into id_cidade;
		end if;

		-- verificar trabalho
		select codtrabalho into id_trabalho from trabalho where nometrabalho = upper(nome_trabalho);

		if not found then
			insert into trabalho (nometrabalho) values (upper(nome_trabalho)) returning codtrabalho into id_trabalho;
		end if;

--1) CLIENTE = {CODCLIENTE, NOMECLIENTE, FOTO, DATANASC, CODSEXO, CODRUA, 
--CODBAIRRO, CODCEP, CODCIDADE, SALARIO, CODTRABALHO, NUMEROCASA}

		insert into cliente (nomecliente, codsexofk, codrua_fk, codbairro_fk,
		codcep_fk, codcidade_fk, salario, codtrabalho_fk, numerocasa) 
		values (upper(nome_cli), id_sexo, id_rua, id_bairro, id_cep, 
		id_cidade, sal, id_trabalho, numero);

		RETURN 'Dados Inseridos com Sucesso';
	END;

$$LANGUAGE PLPGSQL;

select * from cidade

--1) CLIENTE = {CODCLIENTE, NOMECLIENTE, FOTO, DATANASC, CODSEXO, CODRUA, 
--CODBAIRRO, CODCEP, CODCIDADE, SALARIO, CODTRABALHO, NUMEROCASA}

select insere_cliente(
'MARCOS ANTONIO ESTREMOTE',
'masculino',
'passeio goiânia',
'norte',
'15385-000',
'ilha solteira',
855.00,
'unifunec',
'206'
);

select * from cliente



