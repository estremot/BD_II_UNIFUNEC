create database exemplo_views;

create table marca(
	codmarca serial primary key,
	nomemarca varchar(80) not null unique
);
create table tipo(
	codtipo serial primary key,
	nometipo varchar(80) not null
);
create table produto(
	codproduto serial primary key,
	nomeproduto varchar(80) not null unique,
	valor numeric(10,2) not null,
	quantidade numeric(10,2) not null,
	codmarca_fk integer references marca(codmarca) match 
	simple on delete cascade on update cascade,
	codtipo_fk integer references tipo(codtipo) match 
	simple on delete cascade on update cascade
);
create table cliente(
	codcliente serial primary key,
	nomecliente varchar(80) not null
);
create table venda(
	codvenda serial primary key,
	datavenda date not null,
	codcliente_fk integer references cliente(codcliente)
	match simple on delete cascade on update cascade
);
create table itens_venda(
	codvenda_fk integer references venda(codvenda)
	match simple on delete cascade on update cascade,
	codproduto_fk integer references produto(codproduto)
	match simple on delete cascade on update cascade,
	valorvenda numeric(10,2) not null,
	quantv numeric(10,2) not null
);

alter table itens_venda add constraint pk_composta primary key
(codproduto_fk, codvenda_fk);


-- consultas simples
select * from produto;

select p.codproduto, p.nomeproduto, p.valor, p.quantidade, m.nomemarca,
	t.nometipo
from produto p, marca m, tipo t

where p.codmarca_fk = m.codmarca and p.codtipo_fk = t.codtipo;


-- CRIANDO UMA VIEW QUE RETORNA OS DADOS DO PRODUTOS
CREATE VIEW DADOS_PRODUTOS AS
select p.codproduto, p.nomeproduto, p.valor, p.quantidade, m.nomemarca,
	t.nometipo
from produto p, marca m, tipo t
where p.codmarca_fk = m.codmarca and p.codtipo_fk = t.codtipo;

SELECT * FROM DADOS_PRODUTOS;

-- RETORNE OS PRODUTOS VENDIDOS EM UMA VENDA COM O SUBTOTAL
SELECT (I.QUANTV * I.VALORVENDA) AS SUBTOTAL, P.NOMEPRODUTO
FROM ITENS_VENDA I, PRODUTO P
WHERE I.CODPRODUTO_FK = P.CODPRODUTO

-- CRIANDO A VIEW ITENS

CREATE VIEW ITENS AS
SELECT I.CODVENDA_FK,(I.QUANTV * I.VALORVENDA) AS SUBTOTAL, P.NOMEPRODUTO
FROM ITENS_VENDA I, PRODUTO P
WHERE I.CODPRODUTO_FK = P.CODPRODUTO

DROP VIEW ITENS

SELECT CODVENDA_FK FROM ITENS WHERE CODVENDA_FK =10;

SELECT * FROM ITENS_VENDA WHERE (QUANTV * VALORVENDA) = 
(SELECT SUBTOTAL FROM ITENS WHERE CODVENDA_FK = 10);