DROP USER IF EXISTS flavio;
CREATE USER flavio WITH
	SUPERUSER
	CREATEROLE
	CREATEDB
	ENCRYPTED PASSWORD 'flavio';
	
DROP DATABASE IF EXISTS uvv;
CREATE database uvv  WITH
	owner =  'flavio'
	template = template0
	encoding = 'UTF-8'
	lc_collate = 'pt_BR.UTF-8'
	lc_ctype = 'pt_BR.UTF-8';

\c "dbname=uvv user=flavio password=flavio"

CREATE SCHEMA IF NOT EXISTS hr
    AUTHORIZATION flavio;

ALTER USER FLAVIO
SET SEARCH_PATH TO hr, "$user", public;


CREATE TABLE hr.cargos (
                id_cargo VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo NUMERIC(8,2),
                salario_maximo NUMERIC(8,2),
                CONSTRAINT id_cargos PRIMARY KEY (id_cargo)
);
COMMENT ON TABLE hr.cargos IS 'Tabela que informa qual os cargos existentes na empresa.';
COMMENT ON COLUMN hr.cargos.id_cargo IS 'Código que representa um determinado cargo.';
COMMENT ON COLUMN hr.cargos.cargo IS 'Representa o nome do cargo.';
COMMENT ON COLUMN hr.cargos.salario_minimo IS 'Menor valor possível de remuneração para um determinado cargo.';
COMMENT ON COLUMN hr.cargos.salario_maximo IS 'Valor máximo de remuneração para um determinado cargo.';


CREATE UNIQUE INDEX cargos_idx
 ON hr.cargos
 ( cargo );

CREATE TABLE hr.regioes (
                id_regiao INTEGER NOT NULL,
                nome VARCHAR(25) NOT NULL,
                CONSTRAINT id_regiao PRIMARY KEY (id_regiao)
);
COMMENT ON TABLE hr.regioes IS 'Tabela que contém as regiões que a empresa opera.';
COMMENT ON COLUMN hr.regioes.id_regiao IS 'Código que representa uma determinada região de operação.';
COMMENT ON COLUMN hr.regioes.nome IS 'Nome da região.';


CREATE UNIQUE INDEX regioes_idx
 ON hr.regioes
 ( nome );

CREATE TABLE hr.paises (
                id_pais CHAR(2) NOT NULL,
                nome VARCHAR(50),
                id_regiao INTEGER NOT NULL,
                CONSTRAINT id_pais PRIMARY KEY (id_pais)
);
COMMENT ON TABLE hr.paises IS 'Armazena os países que a empresa opera.';
COMMENT ON COLUMN hr.paises.id_pais IS 'Código que indica o país.';
COMMENT ON COLUMN hr.paises.nome IS 'Nome do país.';
COMMENT ON COLUMN hr.paises.id_regiao IS 'chave estrangeira que representa uma determinada região que a empresa opera.';


CREATE UNIQUE INDEX paises_idx
 ON hr.paises
 ( nome );

CREATE TABLE hr.localizacoes (
                id_localizacao INTEGER NOT NULL,
                endereco VARCHAR(50),
                cep VARCHAR(12),
                cidade VARCHAR(50),
                uf VARCHAR(25),
                id_pais CHAR(2) NOT NULL,
                CONSTRAINT id_localizacao PRIMARY KEY (id_localizacao)
);
COMMENT ON TABLE hr.localizacoes IS 'Tabela que contém as informações de localização de um corpo da empresa.';
COMMENT ON COLUMN hr.localizacoes.id_localizacao IS 'Representa o código da localização do corpo da empresa.';
COMMENT ON COLUMN hr.localizacoes.endereco IS 'Informa o endereço que está localizada o corpo da empresa.';
COMMENT ON COLUMN hr.localizacoes.cep IS 'Informa o cep  que está localizado o corpo da empresa.';
COMMENT ON COLUMN hr.localizacoes.cidade IS 'informa a cidade que esá localizado o corpo da empresa';
COMMENT ON COLUMN hr.localizacoes.uf IS 'Informa o Unidade Federal - Estado - em que funciona o corpo da empresa.';
COMMENT ON COLUMN hr.localizacoes.id_pais IS 'Chave estrangeira que informa o código da região que o corpo da empresa está localizado.';


CREATE TABLE hr.departamentos (
                id_departamento INTEGER NOT NULL,
                nome VARCHAR(50),
                id_localizacao INTEGER,
                id_gerente INTEGER,
                CONSTRAINT id_departamento PRIMARY KEY (id_departamento)
);
COMMENT ON TABLE hr.departamentos IS 'Tabela que contem informações sobre os departamentos da empresa.';
COMMENT ON COLUMN hr.departamentos.id_departamento IS 'Código que representa o departamento.';
COMMENT ON COLUMN hr.departamentos.nome IS 'Nome do departamento.';
COMMENT ON COLUMN hr.departamentos.id_localizacao IS 'Chave estrangeira que representa o código da localização do departamento.';
COMMENT ON COLUMN hr.departamentos.id_gerente IS 'Código que representa o gerente do funcionário.';


CREATE UNIQUE INDEX departamentos_idx
 ON hr.departamentos
 ( nome );

CREATE TABLE hr.empregados (
                id_empregado INTEGER NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(35),
                telefone VARCHAR(20),
                data_contratacao DATE NOT NULL,
                id_cargo VARCHAR(10),
                salario NUMERIC(8,2),
                comissao NUMERIC(4,2),
                id_departamento INTEGER,
                id_supervisor INTEGER,
                CONSTRAINT id_empregado PRIMARY KEY (id_empregado)
);
COMMENT ON TABLE hr.empregados IS 'Tabela que contém informações sobre os funcionários da empresa.';
COMMENT ON COLUMN hr.empregados.id_empregado IS 'Código que representa algum determinado funcionário.';
COMMENT ON COLUMN hr.empregados.nome IS 'Informa o nome do funcionário.';
COMMENT ON COLUMN hr.empregados.email IS 'Informa o email do funcionário.';
COMMENT ON COLUMN hr.empregados.telefone IS 'Informa o telefone do funcionário.';
COMMENT ON COLUMN hr.empregados.data_contratacao IS 'Informa a data que o funcionário foi contratado.';
COMMENT ON COLUMN hr.empregados.id_cargo IS 'Chave estrangeira que informa qual o cargo do funcionário.';
COMMENT ON COLUMN hr.empregados.salario IS 'Informa o salário que o funcionário recebe atualmente.';
COMMENT ON COLUMN hr.empregados.comissao IS 'Informa a comissão do funcionário.';
COMMENT ON COLUMN hr.empregados.id_departamento IS 'Chave estrangeira que informa qual departamento o funcionário está trabalhando.';
COMMENT ON COLUMN hr.empregados.id_supervisor IS 'Chave estrangeira que informa qual o supervisor do funcionário.';


CREATE UNIQUE INDEX empregados_idx
 ON hr.empregados
 ( email );

CREATE TABLE hr.historico_cargos (
                id_empregado INTEGER NOT NULL,
                data_inicial DATE NOT NULL,
                data_final DATE,
                id_cargo VARCHAR(10) NOT NULL,
                id_departamento INTEGER NOT NULL,
                CONSTRAINT data_inicial PRIMARY KEY (id_empregado, data_inicial)
);
COMMENT ON TABLE hr.historico_cargos IS 'Tabela que armazena informações referentes a carreira - cargos/funções de uma determinado funcionário na empresa.';
COMMENT ON COLUMN hr.historico_cargos.id_empregado IS 'Código que representa o funcionário.';
COMMENT ON COLUMN hr.historico_cargos.data_inicial IS 'Data que indica o início da função desempenhada pelo funcionário.';
COMMENT ON COLUMN hr.historico_cargos.data_final IS 'Data que informa o fim da função desempenhada pelo funcionário.';
COMMENT ON COLUMN hr.historico_cargos.id_cargo IS 'Chave estrangeira que informa qual é o cargo que aquele funcionário está desempenhando.';
COMMENT ON COLUMN hr.historico_cargos.id_departamento IS 'Chave estrangeira que informa em qual departamento esse funcionário está desempenhando suas funções.';


ALTER TABLE hr.historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES hr.cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES hr.cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.paises ADD CONSTRAINT regioes_paises_fk
FOREIGN KEY (id_regiao)
REFERENCES hr.regioes (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.localizacoes ADD CONSTRAINT paises_localizacoes_fk
FOREIGN KEY (id_pais)
REFERENCES hr.paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.departamentos ADD CONSTRAINT localizacoes_departamentos_fk
FOREIGN KEY (id_localizacao)
REFERENCES hr.localizacoes (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES hr.departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES hr.departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.departamentos ADD CONSTRAINT empregados_departamentos_fk
FOREIGN KEY (id_gerente)
REFERENCES hr.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES hr.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor)
REFERENCES hr.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- inserindo os dados
-- tabela "regioes"

INSERT INTO hr.regioes (id_regiao, nome) values (1,'Europe');
INSERT INTO hr.regioes (id_regiao, nome) values (2,'Americas');
INSERT INTO hr.regioes (id_regiao, nome) values (3,'Asia');
INSERT INTO hr.regioes (id_regiao, nome) values (4,'Middle East and Africa');

--tabelas paises

INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('AR','Argentina',2);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('AU','Australia',3);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('BE','Belgium',1);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('BR','Brazil',2);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('CA','Canada',2);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('CH','Switzerland',1); 
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('CN','China',3); 
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('DE','Germany',1);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('DK','Denmark',1);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('EG','Egypt',4);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('FR','France',1);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('IL','Israel',4);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('IN','India',3);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('IT','Italy',1);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('JP','Japan',3);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('KW','Kuwait',4);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('ML','Malaysia',3);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('MX','Mexico',2);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('NG','Nigeria',4);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('NL','Netherlands',1);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('SG','Singapore',3);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('UK','United Kingdom',1);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('US','United States of America',2);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('ZM','Zambia',4);
INSERT INTO hr.paises (id_pais, nome, id_regiao) values ('ZW','Zimbabwe',4);

--tabela localizacoes

INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (1000,'1297 Via Cola di Rie','00989','Roma',null,'IT');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (1100,'93091 Calle della Testa','10934','Venice',null,'IT');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (1200,'2017 Shinjuku-ku','1689','Tokyo','Tokyo Prefecture','JP');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (1300,'9450 Kamiya-cho','6823','Hiroshima',null,'JP');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (1400,'2014 Jabberwocky Rd','26192','Southlake','Texas','US');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (1500,'2011 Interiors Blvd','99236','South San Francisco','California','US');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (1600,'2007 Zagora St','50090','South Brunswick','New Jersey','US');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (1700,'2004 Charade Rd','98199','Seattle','Washington','US');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (1800,'147 Spadina Ave','M5V 2L7','Toronto','Ontario','CA');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (1900,'6092 Boxwood St','YSW 9T2','Whitehorse','Yukon','CA');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (2000,'40-5-12 Laogianggen','190518','Beijing',null,'CN');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (2100,'1298 Vileparle (E)','490231','Bombay','Maharashtra','IN');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (2200,'12-98 Victoria Street','2901','Sydney','New South Wales','AU');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (2300,'198 Clementi North','540198','Singapore',null,'SG');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (2400,'8204 Arthur St',null,'London',null,'UK');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (2500,'Magdalen Centre, The Oxford Science Park','OX9 9ZB','Oxford','Oxford','UK');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (2600,'9702 Chester Road','09629850293','Stretford','Manchester','UK');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (2700,'Schwanthalerstr. 7031','80925','Munich','Bavaria','DE');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (2800,'Rua Frei Caneca 1360 ','01307-002','Sao Paulo','Sao Paulo','BR');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (2900,'20 Rue des Corps-Saints','1730','Geneva','Geneve','CH');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (3000,'Murtenstrasse 921','3095','Bern','BE','CH');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (3100,'Pieter Breughelstraat 837','3029SK','Utrecht','Utrecht','NL');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) values (3200,'Mariano Escobedo 9991','11932','Mexico City','Distrito Federal,','MX');

-- desativa as Foreign Key, utilizado para povoar a tabela "departamentos"
ALTER TABLE hr.departamentos
  DISABLE TRIGGER ALL;
  
  --tabela departamentos

INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (10,'Administration',200,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (20,'Marketing',201,1800);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (30,'Purchasing',114,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (40,'Human Resources',203,2400);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (50,'Shipping',121,1500);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (60,'IT',103,1400);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (70,'Public Relations',204,2700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (80,'Sales',145,2500);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (90,'Executive',100,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (100,'Finance',108,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (110,'Accounting',205,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (120,'Treasury',null,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (130,'Corporate Tax',null,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (140,'Control And Credit',null,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (150,'Shareholder Services',null,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (160,'Benefits',null,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (170,'Manufacturing',null,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (180,'Construction',null,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (190,'Contracting',null,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (200,'Operations',null,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (210,'IT Support',null,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (220,'NOC',null,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (230,'IT Helpdesk',null,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (240,'Government Sales',null,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (250,'Retail Sales',null,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (260,'Recruiting',null,1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_gerente, id_localizacao) values (270,'Payroll',null,1700);

--tabela cargos

INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('AD_PRES','President',20080,40000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('AD_VP','Administration Vice President',15000,30000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('AD_ASST','Administration Assistant',3000,6000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('FI_MGR','Finance Manager',8200,16000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('FI_ACCOUNT','Accountant',4200,9000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('AC_MGR','Accounting Manager',8200,16000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('AC_ACCOUNT','Public Accountant',4200,9000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('SA_MAN','Sales Manager',10000,20080);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('SA_REP','Sales Representative',6000,12008);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('PU_MAN','Purchasing Manager',8000,15000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('PU_CLERK','Purchasing Clerk',2500,5500);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('ST_MAN','Stock Manager',5500,8500);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('ST_CLERK','Stock Clerk',2008,5000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('SH_CLERK','Shipping Clerk',2500,5500);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('IT_PROG','Programmer',4000,10000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('MK_MAN','Marketing Manager',9000,15000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('MK_REP','Marketing Representative',4000,9000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('HR_REP','Human Resources Representative',4000,9000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) values ('PR_REP','Public Relations Representative',4500,10500);

--tabela empregados

INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(100, 'Steven King', 'SKING', '515.123.4567', '2003-06-17', 'AD_PRES', 24000, null, null, 90);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(101, 'Neena Kochhar', 'NKOCHHAR', '515.123.4568', '2005-09-21', 'AD_VP', 17000, null, 100, 90);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(102, 'Lex De Haan', 'LDEHAAN', '515.123.4569', '2001-01-13', 'AD_VP', 17000, null, 100, 90);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(103, 'Alexander Hunold', 'AHUNOLD', '590.423.4567', '2006-01-03', 'IT_PROG', 9000, null, 102, 60);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(104, 'Bruce Ernst', 'BERNST', '590.423.4568', '2007-05-21', 'IT_PROG', 6000, null, 103, 60);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(105, 'David Austin', 'DAUSTIN', '590.423.4569', '2005-06-25', 'IT_PROG', 4800, null, 103, 60);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(106, 'Valli Pataballa', 'VPATABAL', '590.423.4560', '2006-02-05', 'IT_PROG', 4800, null, 103, 60);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(107, 'Diana Lorentz', 'DLORENTZ', '590.423.5567', '2007-02-07', 'IT_PROG', 4200, null, 103, 60);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(108, 'Nancy Greenberg', 'NGREENBE', '515.124.4569', '2002-08-17', 'FI_MGR', 12008, null, 101, 100);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(109, 'Daniel Faviet', 'DFAVIET', '515.124.4169', '2002-08-16', 'FI_ACCOUNT', 9000, null, 108, 100);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(110, 'John Chen', 'JCHEN', '515.124.4269', '2005-09-28', 'FI_ACCOUNT', 8200, null, 108, 100);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(111, 'Ismael Sciarra', 'ISCIARRA', '515.124.4369', '2005-09-30', 'FI_ACCOUNT', 7700, null, 108, 100);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(112, 'Jose Manuel Urman', 'JMURMAN', '515.124.4469', '2006-03-07', 'FI_ACCOUNT', 7800, null, 108, 100);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(113, 'Luis Popp', 'LPOPP', '515.124.4567', '2007-12-07', 'FI_ACCOUNT', 6900, null, 108, 100);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(114, 'Den Raphaely', 'DRAPHEAL', '515.127.4561', '2002-12-07', 'PU_MAN', 11000, null, 100, 30);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(115, 'Alexander Khoo', 'AKHOO', '515.127.4562', '2003-05-18', 'PU_CLERK', 3100, null, 114, 30);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(116, 'Shelli Baida', 'SBAIDA', '515.127.4563', '2005-12-24', 'PU_CLERK', 2900, null, 114, 30);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(117, 'Sigal Tobias', 'STOBIAS', '515.127.4564', '2005-07-24', 'PU_CLERK', 2800, null, 114, 30);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(118, 'Guy Himuro', 'GHIMURO', '515.127.4565', '2006-11-15', 'PU_CLERK', 2600, null, 114, 30);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(119, 'Karen Colmenares', 'KCOLMENA', '515.127.4566', '2007-08-10', 'PU_CLERK', 2500, null, 114, 30);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(120, 'Matthew Weiss', 'MWEISS', '650.123.1234', '2004-07-18', 'ST_MAN', 8000, null, 100, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(121, 'Adam Fripp', 'AFRIPP', '650.123.2234', '2005-04-10', 'ST_MAN', 8200, null, 100, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(122, 'Payam Kaufling', 'PKAUFLIN', '650.123.3234', '2003-05-01', 'ST_MAN', 7900, null, 100, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(123, 'Shanta Vollman', 'SVOLLMAN', '650.123.4234', '2005-10-10', 'ST_MAN', 6500, null, 100, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(124, 'Kevin Mourgos', 'KMOURGOS', '650.123.5234', '2007-11-16', 'ST_MAN', 5800, null, 100, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(125, 'Julia Nayer', 'JNAYER', '650.124.1214', '2005-07-16', 'ST_CLERK', 3200, null, 120, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(126, 'Irene Mikkilineni', 'IMIKKILI', '650.124.1224', '2006-09-28', 'ST_CLERK', 2700, null, 120, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(127, 'James Landry', 'JLANDRY', '650.124.1334', '2007-01-14', 'ST_CLERK', 2400, null, 120, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(128, 'Steven Markle', 'SMARKLE', '650.124.1434', '2008-03-08', 'ST_CLERK', 2200, null, 120, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(129, 'Laura Bissot', 'LBISSOT', '650.124.5234', '2005-08-20', 'ST_CLERK', 3300, null, 121, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(130, 'Mozhe Atkinson', 'MATKINSO', '650.124.6234', '2005-10-30', 'ST_CLERK', 2800, null, 121, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(131, 'James Marlow', 'JAMRLOW', '650.124.7234', '2005-02-16', 'ST_CLERK', 2500, null, 121, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(132, 'TJ Olson', 'TJOLSON', '650.124.8234', '2007-04-10', 'ST_CLERK', 2100, null, 121, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(133, 'Jason Mallin', 'JMALLIN', '650.127.1934', '2004-06-14', 'ST_CLERK', 3300, null, 122, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(134, 'Michael Rogers', 'MROGERS', '650.127.1834', '2006-08-26', 'ST_CLERK', 2900, null, 122, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(135, 'Ki Gee', 'KGEE', '650.127.1734', '2007-12-12', 'ST_CLERK', 2400, null, 122, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(136, 'Hazel Philtanker', 'HPHILTAN', '650.127.1634', '2008-02-06', 'ST_CLERK', 2200, null, 122, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(137, 'Renske Ladwig', 'RLADWIG', '650.121.1234', '2003-07-14', 'ST_CLERK', 3600, null, 123, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(138, 'Stephen Stiles', 'SSTILES', '650.121.2034', '2005-10-26', 'ST_CLERK', 3200, null, 123, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(139, 'John Seo', 'JSEO', '650.121.2019', '2006-02-12', 'ST_CLERK', 2700, null, 123, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(140, 'Joshua Patel', 'JPATEL', '650.121.1834', '2006-04-06', 'ST_CLERK', 2500, null, 123, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(141, 'Trenna Rajs', 'TRAJS', '650.121.8009', '2003-10-17', 'ST_CLERK', 3500, null, 124, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(142, 'Curtis Davies', 'CDAVIES', '650.121.2994', '2005-01-29', 'ST_CLERK', 3100, null, 124, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(143, 'Randall Matos', 'RMATOS', '650.121.2874', '2006-03-15', 'ST_CLERK', 2600, null, 124, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(144, 'Peter Vargas', 'PVARGAS', '650.121.2004', '2006-07-09', 'ST_CLERK', 2500, null, 124, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(145, 'John Russell', 'JRUSSEL', '011.44.1344.429268', '2004-10-01', 'SA_MAN', 14000, .4, 100, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(146, 'Karen Partners', 'KPARTNER', '011.44.1344.467268', '2005-01-05', 'SA_MAN', 13500, .3, 100, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(147, 'Alberto Errazuriz', 'AERRAZUR', '011.44.1344.429278', '2005-03-10', 'SA_MAN', 12000, .3, 100, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(148, 'Gerald Cambrault', 'GCAMBRAU', '011.44.1344.619268', '2007-10-15', 'SA_MAN', 11000, .3, 100, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(149, 'Eleni Zlotkey', 'EZLOTKEY', '011.44.1344.429018', '2008-01-29', 'SA_MAN', 10500, .2, 100, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(150, 'Peter Tucker', 'PTUCKER', '011.44.1344.129268', '2005-01-30', 'SA_REP', 10000, .3, 145, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(151, 'David Bernstein', 'DBERNSTE', '011.44.1344.345268', '2005-03-24', 'SA_REP', 9500, .25, 145, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(152, 'Peter Hall', 'PHALL', '011.44.1344.478968', '2005-08-20', 'SA_REP', 9000, .25, 145, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(153, 'Christopher Olsen', 'COLSEN', '011.44.1344.498718', '2006-03-30', 'SA_REP', 8000, .2, 145, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(154, 'Nanette Cambrault', 'NCAMBRAU', '011.44.1344.987668', '2006-12-09', 'SA_REP', 7500, .2, 145, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(155, 'Oliver Tuvault', 'OTUVAULT', '011.44.1344.486508', '2007-11-23', 'SA_REP', 7000, .15, 145, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(156, 'Janette King', 'JKING', '011.44.1345.429268', '2004-01-30', 'SA_REP', 10000, .35, 146, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(157, 'Patrick Sully', 'PSULLY', '011.44.1345.929268', '2004-03-04', 'SA_REP', 9500, .35, 146, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(158, 'Allan McEwen', 'AMCEWEN', '011.44.1345.829268', '2004-08-01', 'SA_REP', 9000, .35, 146, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(159, 'Lindsey Smith', 'LSMITH', '011.44.1345.729268', '2005-03-10', 'SA_REP', 8000, .3, 146, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(160, 'Louise Doran', 'LDORAN', '011.44.1345.629268', '2005-12-15', 'SA_REP', 7500, .3, 146, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(161, 'Sarath Sewall', 'SSEWALL', '011.44.1345.529268', '2006-11-03', 'SA_REP', 7000, .25, 146, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(162, 'Clara Vishney', 'CVISHNEY', '011.44.1346.129268', '2005-11-11', 'SA_REP', 10500, .25, 147, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(163, 'Danielle Greene', 'DGREENE', '011.44.1346.229268', '2007-03-19', 'SA_REP', 9500, .15, 147, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(164, 'Mattea Marvins', 'MMARVINS', '011.44.1346.329268', '2008-01-24', 'SA_REP', 7200, .1, 147, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(165, 'David Lee', 'DLEE', '011.44.1346.529268', '2008-02-23', 'SA_REP', 6800, .1, 147, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(166, 'Sundar Ande', 'SANDE', '011.44.1346.629268', '2008-03-24', 'SA_REP', 6400, .1, 147, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(167, 'Amit Banda', 'ABANDA', '011.44.1346.729268', '2008-04-21', 'SA_REP', 6200, .1, 147, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(168, 'Lisa Ozer', 'LOZER', '011.44.1343.929268', '2005-03-11', 'SA_REP', 11500, .25, 148, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(169, 'Harrison Bloom', 'HBLOOM', '011.44.1343.829268', '2006-03-23', 'SA_REP', 10000, .2, 148, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(170, 'Tayler Fox', 'TFOX', '011.44.1343.729268', '2006-01-24', 'SA_REP', 9600, .2, 148, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(171, 'William Smith', 'WSMITH', '011.44.1343.629268', '2007-02-23', 'SA_REP', 7400, .15, 148, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(172, 'Elizabeth Bates', 'EBATES', '011.44.1343.529268', '2007-03-24', 'SA_REP', 7300, .15, 148, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(173, 'Sundita Kumar', 'SKUMAR', '011.44.1343.329268', '2008-04-21', 'SA_REP', 6100, .1, 148, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(174, 'Ellen Abel', 'EABEL', '011.44.1644.429267', '2004-05-11', 'SA_REP', 11000, .3, 149, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(175, 'Alyssa Hutton', 'AHUTTON', '011.44.1644.429266', '2005-03-19', 'SA_REP', 8800, .25, 149, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(176, 'Jonathon Taylor', 'JTAYLOR', '011.44.1644.429265', '2006-03-24', 'SA_REP', 8600, .2, 149, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(177, 'Jack Livingston', 'JLIVINGS', '011.44.1644.429264', '2006-04-23', 'SA_REP', 8400, .2, 149, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(178, 'Kimberely Grant', 'KGRANT', '011.44.1644.429263', '2007-05-24', 'SA_REP', 7000, .15, 149, null);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(179, 'Charles Johnson', 'CJOHNSON', '011.44.1644.429262', '2008-01-04', 'SA_REP', 6200, .1, 149, 80);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(180, 'Winston Taylor', 'WTAYLOR', '650.507.9876', '2006-01-24', 'SH_CLERK', 3200, null, 120, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(181, 'Jean Fleaur', 'JFLEAUR', '650.507.9877', '2006-02-23', 'SH_CLERK', 3100, null, 120, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(182, 'Martha Sullivan', 'MSULLIVA', '650.507.9878', '2007-06-21', 'SH_CLERK', 2500, null, 120, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(183, 'Girard Geoni', 'GGEONI', '650.507.9879', '2008-02-03', 'SH_CLERK', 2800, null, 120, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(184, 'Nandita Sarchand', 'NSARCHAN', '650.509.1876', '2004-01-27', 'SH_CLERK', 4200, null, 121, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(185, 'Alexis Bull', 'ABULL', '650.509.2876', '2005-02-20', 'SH_CLERK', 4100, null, 121, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(186, 'Julia Dellinger', 'JDELLING', '650.509.3876', '2006-06-24', 'SH_CLERK', 3400, null, 121, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(187, 'Anthony Cabrio', 'ACABRIO', '650.509.4876', '2007-02-07', 'SH_CLERK', 3000, null, 121, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(188, 'Kelly Chung', 'KCHUNG', '650.505.1876', '2005-06-14', 'SH_CLERK', 3800, null, 122, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(189, 'Jennifer Dilly', 'JDILLY', '650.505.2876', '2005-08-13', 'SH_CLERK', 3600, null, 122, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(190, 'Timothy Gates', 'TGATES', '650.505.3876', '2006-07-11', 'SH_CLERK', 2900, null, 122, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(191, 'Randall Perkins', 'RPERKINS', '650.505.4876', '2007-12-19', 'SH_CLERK', 2500, null, 122, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(192, 'Sarah Bell', 'SBELL', '650.501.1876', '2004-02-04', 'SH_CLERK', 4000, null, 123, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(193, 'Britney Everett', 'BEVERETT', '650.501.2876', '2005-03-03', 'SH_CLERK', 3900, null, 123, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(194, 'Samuel McCain', 'SMCCAIN', '650.501.3876', '2006-07-01', 'SH_CLERK', 3200, null, 123, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(195, 'Vance Jones', 'VJONES', '650.501.4876', '2007-03-17', 'SH_CLERK', 2800, null, 123, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(196, 'Alana Walsh', 'AWALSH', '650.507.9811', '2006-04-24', 'SH_CLERK', 3100, null, 124, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(197, 'Kevin Feeney', 'KFEENEY', '650.507.9822', '2006-05-23', 'SH_CLERK', 3000, null, 124, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(198, 'Donald OConnell', 'DOCONNEL', '650.507.9833', '2007-06-21', 'SH_CLERK', 2600, null, 124, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(199, 'Douglas Grant', 'DGRANT', '650.507.9844', '2008-01-13', 'SH_CLERK', 2600, null, 124, 50);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(200, 'Jennifer Whalen', 'JWHALEN', '515.123.4444', '2003-09-17', 'AD_ASST', 4400, null, 101, 10);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(201, 'Michael Hartstein', 'MHARTSTE', '515.123.5555', '2004-02-17', 'MK_MAN', 13000, null, 100, 20);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(202, 'Pat Fay', 'PFAY', '603.123.6666', '2005-08-17', 'MK_REP', 6000, null, 201, 20);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(203, 'Susan Mavris', 'SMAVRIS', '515.123.7777', '2002-06-07', 'HR_REP', 6500, null, 101, 40);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(204, 'Hermann Baer', 'HBAER', '515.123.8888', '2002-06-07', 'PR_REP', 10000, null, 101, 70);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(205, 'Shelley Higgins', 'SHIGGINS', '515.123.8080', '2002-06-07', 'AC_MGR', 12008, null, 101, 110);
INSERT INTO hr.empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(206, 'William Gietz', 'WGIETZ', '515.123.8181', '2002-06-07', 'AC_ACCOUNT', 8300, null, 205, 110);

--tabela historico_cargos

INSERT INTO hr.historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) values
( 102,'2001-01-13', '2006-07-24', 'IT_PROG', 60
);
INSERT INTO hr.historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) values
( 101, '1997-09-21','2001-10-27', 'AC_ACCOUNT',  110
);
INSERT INTO hr.historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) values
( 101, '2001-10-28', '2005-03-15', 'AC_MGR',  110
);
INSERT INTO hr.historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) values
( 201, '2004-02-17','2007-12-19', 'MK_REP', 20
);
INSERT INTO hr.historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) values
( 114, '2006-03-24','2007-12-31', 'ST_CLERK', 50
);
INSERT INTO hr.historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) values
( 122, '2007-01-01','2007-12-31', 'ST_CLERK', 50
);
INSERT INTO hr.historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) values
( 200, '1995-09-17', '2001-06-17', 'AD_ASST', 90
);
INSERT INTO hr.historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) values
( 176, '2006-03-24', '2006-12-31', 'SA_REP', 80
);
INSERT INTO hr.historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) values
( 176, '2007-01-01', '2007-12-31', 'SA_MAN', 80
);
INSERT INTO hr.historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) values
( 200, '2002-07-01', '2006-12-31', 'AC_ACCOUNT', 90
);


ALTER TABLE hr.departamentos 
	ENABLE TRIGGER ALL;
-- volta com a funcionalidade prevista das CONSTRAINTS

