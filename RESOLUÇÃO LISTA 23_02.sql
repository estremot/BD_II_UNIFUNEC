﻿create database exercicio_fera;

-- marca = {codmarca, nomemarca}
create table marca(
	codmarca serial primary key,
	nomemarca varchar(80) not null unique
);

-- tipo = {codtipo, nometipo}
create table tipo(
	codtipo serial primary key,
	nometipo varchar(80) not null unique
);

--produto = {codproduto, nomeproduto, quantidade, valor, codmarca_fk,
--           codtipo_fk}

create table produto(
	codproduto serial primary key,
	nomeproduto varchar(80) not null unique,
	quantidade numeric(10,2) not null,
	valor numeric(10,2) not null,
	codmarca_fk integer references marca(codmarca) match simple on delete
	cascade on update cascade,
	codtipo_fk integer references tipo(codtipo) match simple on delete
	cascade on update cascade
);

-- inserindo as marcas dos produtos
-- marca = {codmarca, nomemarca}
insert into marca(nomemarca) values('ARISCO');
insert into marca(nomemarca) values('SIAMAR');
insert into marca(nomemarca) values('HELLMANS');
insert into marca(nomemarca) values('PIRACANJUBA');

-- TIPO = {CODTIPO, NOMETIPO}
INSERT INTO TIPO(NOMETIPO) VALUES('ALIMENTÍCIO');
INSERT INTO TIPO(NOMETIPO) VALUES('BEBIDAS');
INSERT INTO TIPO(NOMETIPO) VALUES('HIGIENE');
INSERT INTO TIPO(NOMETIPO) VALUES('LIMPEZA');

--produto = {codproduto, nomeproduto, quantidade, valor, codmarca_fk,
--           codtipo_fk}
INSERT INTO PRODUTO(NOMEPRODUTO, QUANTIDADE, VALOR, CODMARCA_FK, CODTIPO_FK)
VALUES('ARROZ AGULHINHA', 100, 26.99, 2, 1);

INSERT INTO PRODUTO(NOMEPRODUTO, QUANTIDADE, VALOR, CODMARCA_FK, CODTIPO_FK)
VALUES('FEIJÃO CARIOCA', 200, 12.89, 2, 1);

INSERT INTO PRODUTO(NOMEPRODUTO, QUANTIDADE, VALOR, CODMARCA_FK, CODTIPO_FK)
VALUES('COCA-COLA 600ML', 1000, 3.45, 3, 2);

INSERT INTO PRODUTO(NOMEPRODUTO, QUANTIDADE, VALOR, CODMARCA_FK, CODTIPO_FK)
VALUES('SABÃO EM PÓ OMO 2KG', 45, 18.90, 4, 4);

select * from produto;


--AUMENTE OS VALORES EM 10% DE TODOS OS PRODUTOS DO TIPO ALIMENTÍCIO

UPDATE PRODUTO SET VALOR = VALOR * 1.1 WHERE PRODUTO.CODTIPO_FK = 
(SELECT CODTIPO FROM TIPO WHERE NOMETIPO = 'ALIMENTÍCIO')

alter table marca add column descricao varchar(80) not null default 'DESCREVER';

SELECT * FROM MARCA;

DELETE MARCA WHERE NOMEMARCA LIKE 'E%';

SELECT COUNT(CODPRODUTO) 
FROM PRODUTO, MARCA
WHERE PRODUTO.CODMARCA_FK = MARCA.CODMARCA AND MARCA.NOMEMARCA = 'SIAMAR' AND 
PRODUTO.VALOR > 10; 

