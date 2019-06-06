/*
	ESQUEMA PRACTICA BANCS
	******* mySql *******
*/


-- Netetja
drop user ADMIN_BANK;
drop schema `BANK`;


-- Creació de l'esquema
CREATE SCHEMA `BANK` DEFAULT CHARACTER SET utf8 ;
USE `bank`;


-- Creació de l'usuari
CREATE USER `ADMIN_BANK` IDENTIFIED BY '1234';


-- Creació de taules
CREATE TABLE BANCS (
	ID_BANC					INT			NOT NULL AUTO_INCREMENT,
	CODI_BANC				CHAR(5)		NOT NULL,
	DESCRIPCION				VARCHAR(30)	NOT NULL,
PRIMARY KEY(ID_BANC),
UNIQUE(CODI_BANC)
);


CREATE TABLE SUCURSALS (
	ID_SUCURSAL				INT			NOT NULL AUTO_INCREMENT,
	ID_BANC					INT			NOT NULL,
	DESCRIPCIO				VARCHAR(30)	NOT NULL,
PRIMARY KEY(ID_SUCURSAL),
FOREIGN KEY(ID_BANC) REFERENCES BANCS(ID_BANC)
);


CREATE TABLE TELEFONS (
	ID_TELEFON				INT			NOT NULL AUTO_INCREMENT,
	NUM_TELEFON				VARCHAR(9)	NOT NULL,
PRIMARY KEY(ID_TELEFON),
UNIQUE(NUM_TELEFON)
);


CREATE TABLE TIPUS_SERVEIS (
	ID_TIPUS_SERVEI		INT			NOT NULL AUTO_INCREMENT,
	CODI_TIPUS_SERVEI		CHAR(5)		NOT NULL,
	DESCRIPCIO				VARCHAR(30)	NOT NULL,
PRIMARY KEY(ID_TIPUS_SERVEI),
UNIQUE(CODI_TIPUS_SERVEI)
);


CREATE TABLE SERVEIS (
	ID_SERVEI				INT   		NOT NULL AUTO_INCREMENT,
	CODI_SERVEI				CHAR(5)		NOT NULL,
	ID_TIPUS_SERVEI		INT			NOT NULL,
	DESCRIPCIO				VARCHAR(30)	NOT NULL,
PRIMARY KEY(ID_SERVEI),
FOREIGN KEY(ID_TIPUS_SERVEI) REFERENCES TIPUS_SERVEIS(ID_TIPUS_SERVEI),
UNIQUE(CODI_SERVEI)
);


CREATE TABLE CLIENTS (
	ID_CLIENT				INT			NOT NULL AUTO_INCREMENT,
	EDAT						NUMERIC(3)	NOT NULL,
	CLIENTS_DEUTOR			CHAR(1)		CHECK (CLIENTS_DEUTOR IN ('S','N')),
	NOM						VARCHAR(30)	NOT NULL,
PRIMARY KEY(ID_CLIENT)
);


CREATE TABLE CONTRACTES (
	ID_CONTRACTE			INT			NOT NULL AUTO_INCREMENT,
	ID_TELEFON				INT			NOT NULL,
	ID_CLIENT				INT			NOT NULL,
	ACTIU						CHAR(1)		NOT NULL  CHECK (ACTIU in ('S','N')),
	REFERENCIA_CONTRACTE	CHAR(10)		NOT NULL,
	DATA_ALTA				DATE			NOT NULL,
	DATA_BAIXA				DATE,
PRIMARY KEY (ID_CONTRACTE),
FOREIGN KEY (ID_TELEFON)REFERENCES TELEFONS(ID_TELEFON),
FOREIGN KEY (ID_CLIENT) REFERENCES CLIENTS(ID_CLIENT),
UNIQUE (REFERENCIA_CONTRACTE)
);


CREATE TABLE DOMICILIACIONS_PAGAMENT (
	ID_CONTRACTE			INT			NOT NULL,
	ID_SUCURSAL				INT			NOT NULL,
	DESCRIPCIO				VARCHAR(30)	NOT NULL,
PRIMARY KEY(ID_CONTRACTE),
FOREIGN KEY(ID_SUCURSAL) REFERENCES SUCURSALS(ID_SUCURSAL),
FOREIGN KEY(ID_CONTRACTE) REFERENCES CONTRACTES(ID_CONTRACTE)
);


CREATE TABLE SERIES_FACTURA (
	ID_SERIE_FACTURA		INT			NOT NULL AUTO_INCREMENT,
	COD_SERIE_FACTURA		CHAR(5)		NOT NULL,
	DESCRIPCIO				VARCHAR(30)	NOT NULL,
PRIMARY KEY(ID_SERIE_FACTURA),
UNIQUE(COD_SERIE_FACTURA)
);


CREATE TABLE FACTURES (
	ID_FACTURA				INT			NOT NULL AUTO_INCREMENT,
	ID_SERIE_FACTURA		INT			NOT NULL,
	NUM_FACTURA				INT			NOT NULL,
	DATA						DATE			NOT NULL,
	ID_CONTRACTE			INT			NOT NULL,
PRIMARY KEY  (ID_FACTURA),
FOREIGN KEY(ID_CONTRACTE) REFERENCES CONTRACTES(ID_CONTRACTE),
FOREIGN KEY(ID_SERIE_FACTURA) REFERENCES SERIES_FACTURA(ID_SERIE_FACTURA),
UNIQUE(ID_SERIE_FACTURA, NUM_FACTURA)
);


CREATE TABLE REGLONS_FACTURA (
	ID_FACTURA				INT			NOT NULL,
	NUM_REGLO_FACTURA 	NUMERIC(3)	NOT NULL,
	ID_SERVEI				INT			NOT NULL,
	DESCRIPCIO				VARCHAR(50)	NOT NULL,
	QUANTITAT				NUMERIC		NOT NULL,
	IMPORT_UNITARI			NUMERIC(7,2) NOT NULL,
PRIMARY KEY(ID_FACTURA, NUM_REGLO_FACTURA),
FOREIGN KEY(ID_FACTURA) REFERENCES FACTURES(ID_FACTURA),
FOREIGN KEY(ID_SERVEI) REFERENCES SERVEIS(ID_SERVEI)
);


CREATE TABLE TRUCADES (
	ID_TRUCADA				INT			NOT NULL AUTO_INCREMENT,
	ID_CONTRACTE			INT			NOT NULL,
	ID_TELEFON_TRUCAT		INT			NOT NULL,
	DURACIO_SEGONS			NUMERIC		NOT NULL,
	DESCRIPCION				VARCHAR(30)	NOT NULL,
	DATA_TRUCADA			DATE			NOT NULL,
PRIMARY KEY(ID_TRUCADA),
FOREIGN KEY(ID_TELEFON_TRUCAT) REFERENCES TELEFONS(ID_TELEFON),
FOREIGN KEY(ID_CONTRACTE) REFERENCES CONTRACTES(ID_CONTRACTE)
);


CREATE TABLE PROMOCIONS (
	ID_PROMOCIO				INT			NOT NULL AUTO_INCREMENT,
	DESCRIPCIO				VARCHAR(30)	NOT NULL,
PRIMARY KEY(ID_PROMOCIO)
);


CREATE TABLE PROMOCIONS_OFERIDES (
	ID_FACTURA				INT			NOT NULL,
	ID_PROMOCIO				INT			NOT NULL,
PRIMARY KEY(ID_FACTURA),
FOREIGN KEY(ID_FACTURA) REFERENCES FACTURES(ID_FACTURA),
FOREIGN KEY(ID_PROMOCIO) REFERENCES PROMOCIONS(ID_PROMOCIO)
);


-- Dades d'exemple
INSERT INTO BANCS VALUES (1, 'CAIXA', 'La Caixa');
INSERT INTO BANCS VALUES (2, 'NOSTR', 'Sa Nostra');
INSERT INTO BANCS VALUES (3, 'SANTD', 'Banco de Santander');
INSERT INTO BANCS VALUES (4, 'CJMAD', 'Caja Madrid');
INSERT INTO BANCS VALUES (5, 'BCZAR', 'Banco de Zaragoza');
INSERT INTO BANCS VALUES (6, 'BANKT', 'Bankinter');
INSERT INTO BANCS VALUES (7, 'BARCL', 'Barclays');
INSERT INTO BANCS VALUES (8, 'INGDI', 'ING Direct');

INSERT INTO SUCURSALS VALUES (null, 1, 'Pça de San Pau, 4');
INSERT INTO SUCURSALS VALUES (null, 1, 'Pça de San Cosme, 12');
INSERT INTO SUCURSALS VALUES (null, 1, 'Av. Gral. Suau, s/n');
INSERT INTO SUCURSALS VALUES (null, 1, 'C/Roser, 32');
INSERT INTO SUCURSALS VALUES (null, 1, 'C/Ausies March, 7');
INSERT INTO SUCURSALS VALUES (null, 2, 'Santa Catalina, s/N');
INSERT INTO SUCURSALS VALUES (null, 2, 'C/Gral Riera, 123');
INSERT INTO SUCURSALS VALUES (null, 2, 'C/Taronger, s/n');
INSERT INTO SUCURSALS VALUES (null, 2, 'Av. Argentina, 144');
INSERT INTO SUCURSALS VALUES (null, 3, 'C/San Jaume, 2');
INSERT INTO SUCURSALS VALUES (null, 4, 'Pça. San Geroni, s/n');
INSERT INTO SUCURSALS VALUES (null, 5, 'C/Baluart, 1');


INSERT INTO tipus_serveis (`CODI_TIPUS_SERVEI`,`DESCRIPCIO`) VALUES ('MOVIL','Movil (Voz y Datos)');
INSERT INTO tipus_serveis (`CODI_TIPUS_SERVEI`,`DESCRIPCIO`) VALUES ('ADSL','Internet');
INSERT INTO tipus_serveis (`CODI_TIPUS_SERVEI`,`DESCRIPCIO`) VALUES ('COMBO','Paquetes servicios combinados');
INSERT INTO tipus_serveis (`CODI_TIPUS_SERVEI`,`DESCRIPCIO`) VALUES ('TV','TV por cable');

INSERT INTO serveis values(null, 'MOV01', 1, 'Voz x segundos');
INSERT INTO serveis values(null, 'MOV02', 1, 'Establecimiento llamada');
INSERT INTO serveis values(null, 'MOV03', 1, 'Tarifa Plana');
INSERT INTO serveis values(null, 'ADSL1', 2, 'Fibra 100');
INSERT INTO serveis values(null, 'ADSL2', 2, 'Fibra 200');
INSERT INTO serveis values(null, 'ADSL3', 2, 'Fibra 300');
INSERT INTO serveis values(null, 'COMB1', 3, 'Fijo + ADSL');
INSERT INTO serveis values(null, 'COMB2', 3, 'Fijo + ADSL + TV');
INSERT INTO serveis values(null, 'TV1', 4, 'Contenido bajo demanda');


INSERT INTO TELEFONS (NUM_TELEFON) values ('971510001');
INSERT INTO TELEFONS (NUM_TELEFON) values ('971610002');
INSERT INTO TELEFONS (NUM_TELEFON) values ('971710003');
INSERT INTO TELEFONS (NUM_TELEFON) values ('971910004');
INSERT INTO TELEFONS (NUM_TELEFON) values ('971210005');
INSERT INTO TELEFONS (NUM_TELEFON) values ('971310006');
INSERT INTO TELEFONS (NUM_TELEFON) values ('971410007');
INSERT INTO TELEFONS (NUM_TELEFON) values ('971810008');
INSERT INTO TELEFONS (NUM_TELEFON) values ('971010009');
INSERT INTO TELEFONS (NUM_TELEFON) values ('971110010');
INSERT INTO TELEFONS (NUM_TELEFON) values ('971511011');
INSERT INTO TELEFONS (NUM_TELEFON) values ('971011012');
INSERT INTO TELEFONS (NUM_TELEFON) values ('971911013');
INSERT INTO TELEFONS (NUM_TELEFON) values ('971610014');


INSERT INTO CLIENTS VALUES(null, '45','S','Juan Ordoñez');
INSERT INTO CLIENTS VALUES(null, '47','S','Tolo Camuñas');
INSERT INTO CLIENTS VALUES(null, '35','S','Paco Ortiz');
INSERT INTO CLIENTS VALUES(null, '46','S','Jorge Calata');
INSERT INTO CLIENTS VALUES(null, '38','S','Javier Conde');
INSERT INTO CLIENTS VALUES(null, '50','N','Carlos Redondo');
INSERT INTO CLIENTS VALUES(null, '40','N','Eduardo Gonzalez');
INSERT INTO CLIENTS VALUES(null, '56','N','Miguel Ribot');
INSERT INTO CLIENTS VALUES(null, '57','S','Antonio Roblerillo');
INSERT INTO CLIENTS VALUES(null, '29','S','Jose Linares');
INSERT INTO CLIENTS VALUES(null, '30','S','David Frau');
INSERT INTO CLIENTS VALUES(null, '43','S','Jose Luis Torrente');
INSERT INTO CLIENTS VALUES(null, '35','S','Rafael Delgado');
INSERT INTO CLIENTS VALUES(null, '34','N','Felipe Coco');
INSERT INTO CLIENTS VALUES(null, '65','N','Manuel Garcia');
INSERT INTO CLIENTS VALUES(null, '36','N','Pablo Calvo');
INSERT INTO CLIENTS VALUES(null, '39','N','Michel Salgado');
INSERT INTO CLIENTS VALUES(null, '51','S','Raul Gonzalez');
INSERT INTO CLIENTS VALUES(null, '52','S','Jose Maria Gutierrez');
INSERT INTO CLIENTS VALUES(null, '55','S','Julio Baptista');


INSERT INTO CONTRACTES VALUES(null, 1, 1, 'N', 'CON_U01PT', str_to_date('31/01/2004','%d/%m/%Y'), str_to_date('12/03/2005', '%d/%m/%Y'));
INSERT INTO CONTRACTES VALUES(null, 1, 1, 'N', 'COxxU01PT', str_to_date('31/01/2004','%d/%m/%Y'), str_to_date( '12/03/2005','%d/%m/%Y'));
INSERT INTO CONTRACTES VALUES(null, 2, 2, 'N', 'CONyU01PT', str_to_date('15/07/2005','%d/%m/%Y'), str_to_date('22/10/2004','%d/%m/%Y'));
INSERT INTO CONTRACTES VALUES(null, 3, 3, 'N', 'CONzU01PT', str_to_date('31/01/2004','%d/%m/%Y'), str_to_date('12/03/2005','%d/%m/%Y'));
INSERT INTO CONTRACTES VALUES(null, 4, 4, 'N', 'CONpp01PT', str_to_date('15/07/2005','%d/%m/%Y'), str_to_date( '22/10/2004','%d/%m/%Y'));
INSERT INTO CONTRACTES VALUES(null, 5, 5, 'S', 'CONkk01PT', str_to_date('25/09/2002','%d/%m/%Y'), null);
INSERT INTO CONTRACTES VALUES(null, 6, 6, 'S', 'CONjh01PT', str_to_date('28/06/2003','%d/%m/%Y'), null);
INSERT INTO CONTRACTES VALUES(null, 7, 7, 'N', 'CONyy01PT', str_to_date('15/07/2005','%d/%m/%Y'), str_to_date('12/02/2004','%d/%m/%Y'));
INSERT INTO CONTRACTES VALUES(null, 8, 8, 'N', 'CONii01PT', str_to_date('13/12/2001','%d/%m/%Y'), null);
INSERT INTO CONTRACTES VALUES(null, 8, 9, 'S', 'COkkU01PT', str_to_date('30/03/2000','%d/%m/%Y'),  null);
INSERT INTO CONTRACTES VALUES(null, 9, 10, 'S', 'CONhh01PT', str_to_date('28/06/2003','%d/%m/%Y'),  null);
INSERT INTO CONTRACTES VALUES(null, 9, 10, 'N', 'COeee01PT', str_to_date('12/08/2003','%d/%m/%Y'), str_to_date('01/01/2004','%d/%m/%Y'));
INSERT INTO CONTRACTES VALUES(null,10, 5, 'S', 'COrrU01PT', str_to_date('31/01/2004','%d/%m/%Y'),  null);


INSERT INTO DOMICILIACIONS_PAGAMENT VALUES( 1, 1, 'dom. bancaria');
INSERT INTO DOMICILIACIONS_PAGAMENT VALUES( 2, 2, 'dom. bancaria');
INSERT INTO DOMICILIACIONS_PAGAMENT VALUES( 3, 2, 'dom. bancaria');
INSERT INTO DOMICILIACIONS_PAGAMENT VALUES( 4, 2, 'dom. bancaria');
INSERT INTO DOMICILIACIONS_PAGAMENT VALUES( 5, 6, 'dom. bancaria');
INSERT INTO DOMICILIACIONS_PAGAMENT VALUES( 6, 6, 'dom. bancaria');
INSERT INTO DOMICILIACIONS_PAGAMENT VALUES( 7, 7, 'dom. bancaria');
INSERT INTO DOMICILIACIONS_PAGAMENT VALUES( 8, 8, 'dom. bancaria');
INSERT INTO DOMICILIACIONS_PAGAMENT VALUES( 9, 8, 'dom. bancaria');
INSERT INTO DOMICILIACIONS_PAGAMENT VALUES( 10, 10, 'dom. bancaria');
INSERT INTO DOMICILIACIONS_PAGAMENT VALUES( 11, 11, 'dom. bancaria');


Insert into SERIES_FACTURA values (null, 'SF001','Serie 001');
Insert into SERIES_FACTURA values (null, 'SF002','Serie 002');
Insert into SERIES_FACTURA values (null, 'SF003','Serie 003');
Insert into SERIES_FACTURA values (null, 'SF004','Serie 004');
Insert into SERIES_FACTURA values (null, 'SF005','Serie 005');
Insert into SERIES_FACTURA values (null, 'AB006','Abono 006');
Insert into SERIES_FACTURA values (null, 'AB007','Abono 007');
Insert into SERIES_FACTURA values (null, 'AB008','Abono 008');
Insert into SERIES_FACTURA values (null, 'RF009','Rectificativa 009');
Insert into SERIES_FACTURA values (null, 'VA010','Varios 010');


INSERT INTO FACTURES values(NULL, 1, '01', STR_TO_DATE('01-01-2005','%d-%m-%Y'), 1);
INSERT INTO FACTURES values(NULL, 1, '02', STR_TO_DATE('01-02-2005','%d-%m-%Y'), 1);
INSERT INTO FACTURES values(NULL, 2, '03', STR_TO_DATE('01-03-2005','%d-%m-%Y'), 1);
INSERT INTO FACTURES values(NULL, 2, '04', STR_TO_DATE('01-04-2005','%d-%m-%Y'), 2);
INSERT INTO FACTURES values(NULL, 2, '05', STR_TO_DATE('01-05-2005','%d-%m-%Y'), 2);
INSERT INTO FACTURES values(NULL, 3, '06', STR_TO_DATE('01-06-2005','%d-%m-%Y'), 3);
INSERT INTO FACTURES values(NULL, 4, '07', STR_TO_DATE('01-07-2005','%d-%m-%Y'), 4);
INSERT INTO FACTURES values(NULL, 5, '08', STR_TO_DATE('01-08-2005','%d-%m-%Y'), 5);
INSERT INTO FACTURES values(NULL, 5, '09', STR_TO_DATE('01-09-2005','%d-%m-%Y'), 5);
INSERT INTO FACTURES values(NULL, 5, '10', STR_TO_DATE('01-10-2005','%d-%m-%Y'), 7);


INSERT INTO reglons_factura values(1, 1, 1, 'Segundos voz consumidos',320,0.35);
INSERT INTO reglons_factura values(1, 2, 2, 'LLamadas realizadas',120,0.20);
INSERT INTO reglons_factura values(1, 3, 9, 'La amenza fantasma',1,4);
INSERT INTO reglons_factura values(1, 4, 9, 'El ataque de los clones',1,4);
INSERT INTO reglons_factura values(1, 5, 9, 'El imperio contraataca',1,4);
INSERT INTO reglons_factura values(1, 6, 9, 'El retorno del Jedi',1,4);
INSERT INTO reglons_factura values(2, 1, 1, 'Segundos voz consumidos',78,0.35);
INSERT INTO reglons_factura values(2, 2, 2, 'LLamadas realizadas',32,0.20);
INSERT INTO reglons_factura values(3, 1, 1, 'Segundos voz consumidos',48,0.35);
INSERT INTO reglons_factura values(3, 2, 2, 'LLamadas realizadas',12,0.20);
INSERT INTO reglons_factura values(4, 1, 1, 'Segundos voz consumidos',170,0.35);
INSERT INTO reglons_factura values(4, 2, 2, 'LLamadas realizadas',88,0.20);
INSERT INTO reglons_factura values(5, 1, 3, 'Tarifa Plana',1,75);
INSERT INTO reglons_factura values(6, 1, 1, 'Segundos voz consumidos',86,0.35);
INSERT INTO reglons_factura values(6, 2, 2, 'LLamadas realizadas',38,0.20);
INSERT INTO reglons_factura values(6, 3, 4, 'Acceso Internet con Fibra 100Mbs',1,50);
INSERT INTO reglons_factura values(7, 1, 1, 'Segundos voz consumidos',73,0.35);
INSERT INTO reglons_factura values(7, 3, 5, 'Acceso Internet con Fibra 200Mbs',1,75);
INSERT INTO reglons_factura values(7, 2, 2, 'LLamadas realizadas',44,0.20);
INSERT INTO reglons_factura values(8, 1, 1, 'Segundos voz consumidos',125,0.35);
INSERT INTO reglons_factura values(8, 2, 2, 'LLamadas realizadas',12,0.20);
INSERT INTO reglons_factura values(9, 1, 1, 'Segundos voz consumidos',321,0.35);
INSERT INTO reglons_factura values(9, 2, 2, 'Llamadas realizadas',22,0.20);


INSERT INTO promocions values(null,'Adsl 30Mbs 10 durante 6 meses');
INSERT INTO promocions values(null,'Adsl + llamadas 10');
INSERT INTO promocions values(null,'Llamadas Europa 12 mes');
INSERT INTO promocions values(null,'Llamadas nacionales gratis');
INSERT INTO promocions values(null,'Números frecuentes gratis');
INSERT INTO promocions values(null,'Adsl máxima velocidad 39 mes');
INSERT INTO promocions values(null,'Llamadas Internacional 30 mes');


INSERT INTO promocions_oferides values(1, 1);
INSERT INTO promocions_oferides values(2, 1);
INSERT INTO promocions_oferides values(3, 1);
INSERT INTO promocions_oferides values(4, 1);
INSERT INTO promocions_oferides values(5, 5);
INSERT INTO promocions_oferides values(6, 5);
INSERT INTO promocions_oferides values(7, 5);
INSERT INTO promocions_oferides values(8, 7);
INSERT INTO promocions_oferides values(9, 7);
INSERT INTO promocions_oferides values(10,1);


INSERT INTO TRUCADES VALUES(null, 1, 1, 17,'local','12/03/05');
INSERT INTO TRUCADES VALUES(null, 1, 2, 17,'local','12/03/05');
INSERT INTO TRUCADES VALUES(null, 1, 3, 28,'interprov','1/10/05');
INSERT INTO TRUCADES VALUES(null, 1, 4, 34,'local','15/10/05');
INSERT INTO TRUCADES VALUES(null, 1, 5, 78,'prov','16/10/05');
INSERT INTO TRUCADES VALUES(null, 3, 6, 10,'prov','18/10/05');
INSERT INTO TRUCADES VALUES(null, 3, 7, 89,'local','15/10/05');
INSERT INTO TRUCADES VALUES(null, 3, 8, 30,'interprov','17/10/05');
INSERT INTO TRUCADES VALUES(null, 3, 9, 100,'local','21/10/05');
INSERT INTO TRUCADES VALUES(null, 5, 2, 120,'local','17/10/05');
INSERT INTO TRUCADES VALUES(null, 6, 10, 71,'local','16/10/05');
INSERT INTO TRUCADES VALUES(null, 9, 12, 30,'prov','18/10/05');



-- Relació de factures amb els seus reglons.
-- Inclou exemples de funcions de cadenes, dates i numeriques.
select 
	if(rf.num_reglo_factura=1, date_format(fa.data, "%d/%m/%y"), "") as "Data Emisió",
	if(rf.num_reglo_factura=1, concat_ws("-",sf.cod_serie_factura, lpad(fa.num_factura,6,"0")), "") as Factura,
	lpad(rf.num_reglo_factura,2,"0") as Reglo,
	concat_ws(" - ", ts.descripcio, rf.descripcio) as Concepte,
	rf.quantitat as Unitats,
	format(rf.import_unitari,2) as Preu,
	format(rf.quantitat * rf.import_unitari,2) as Import
from 
	series_factura as sf, 
	factures as fa, 
	reglons_factura as rf, 
	tipus_serveis as ts,  
	serveis as se
where
	sf.id_serie_factura = fa.id_serie_factura and
	fa.id_factura = rf.id_factura and
	ts.id_tipus_servei = se.id_tipus_servei and
	se.id_servei = rf.id_servei
order by 
	fa.data, 
	sf.cod_serie_factura, 
	fa.num_factura, 
	rf.num_reglo_factura;


-- Import total per factura
-- inclou nombre de reglons
select 
	date_format(fa.data, "%d/%m/%y") as "Data Emisió",
	concat_ws("-",sf.cod_serie_factura, lpad(fa.num_factura,6,"0")) as Factura,
	format(sum(rf.quantitat * rf.import_unitari),2) as Import,
   count(*) as "Nombre Reglons"
from 
	series_factura as sf, 
	factures as fa, 
	reglons_factura as rf
where
	sf.id_serie_factura = fa.id_serie_factura and
	fa.id_factura = rf.id_factura 
group by
	fa.id_factura;

	
-- Import mitjà factura
-- Exemple de subconsulta al 'from'
select 
	avg(import)
from (
	select 
		sum(rf.quantitat * rf.import_unitari) as import
	from 
		reglons_factura as rf
	group by 
		rf.id_factura) as imports_factures;
		
-- Import mitjà factura
-- Exemple de count(distinct ...)) i de group by sense clausula 'group by'
select 
	sum(rf.quantitat * rf.import_unitari) / count(distinct(id_factura)) as import
from 
	reglons_factura as rf;	


-- Estadística de contractes
-- Exemple de Union
-- Exemple de count(<Exp>) per comptar els no nulls
select 
	"Contractes Totals" as Concepte, count(*) as Quantity
from 
	bank.contractes
union
select 
	"Contractes Actius", count(co.data_baixa)
from 
	bank.contractes co
union
select 
	"Contractes Cancel·lats", count(*)
from 
	bank.contractes co
where 
	co.DATA_BAIXA IS NULL;


-- Estadística mixta
-- Exemple de Union All
select 
	rpad("",20,"=") as Concepte,   "" as Quantitat
union all

select 
	"Contractes Totals" as Concepte, format(count(*),0) as Quantity
from 
	bank.contractes
union all

select 
	"Contractes Actius", format(count(co.data_baixa),0)
from 
	bank.contractes co
union all

select 
	"Contractes Cancel·lats", format(count(*),0)
from 
	bank.contractes co
where 
	co.DATA_BAIXA IS NULL
union all

select 
	rpad("",20,"="),  ""
union all

select 
	"Import Total Factures", 	format(sum(import),0)
from (
	select 
		sum(rf.quantitat * rf.import_unitari) as import
	from 
		reglons_factura as rf
	group by 
		rf.id_factura) as imports_factures
union all

select 
	"Import Mitjà Factures", 	format(avg(import),0)
from (
	select 
		sum(rf.quantitat * rf.import_unitari) as import
	from 
		reglons_factura as rf
	group by 
		rf.id_factura) as imports_factures
union all
select 
	rpad("",20,"="), "";
	
	
-- Grafic de barras de imports de factures
-- Exemple de subconsultes al "from"
select
	concat_ws("-", lpad(fac.NUM_FACTURA,5,"0"), ser.cod_serie_factura) as Factura, 
   concat(repeat("*", round(tot.import / max.import * 100)/4), " (", tot.import, ")") BarGraph
from 
	(	select 
			rf1.ID_FACTURA id_factura,
			sum(rf1.QUANTITAT * rf1.IMPORT_UNITARI) import
		from		
			bank.reglons_factura as rf1
		group by
			rf1.ID_FACTURA) tot, 
	(	select max(import_total)  import
		from
			(select 
				sum(rf2.QUANTITAT * rf2.IMPORT_UNITARI) import_total
			from		
				bank.reglons_factura as rf2
			group by
				rf2.ID_FACTURA) fact) as max,
	bank.factures fac,
   bank.series_factura ser
where
	tot.id_factura = fac.id_factura and
   fac.id_serie_factura = ser.id_serie_factura;
   
   

-- Mateix resultat que el select anterior: Grafic de barras de imports de factures
-- Exemple de subconsulta al "select"
select
	concat_ws("-", lpad(fac.NUM_FACTURA,5,"0"), ser.cod_serie_factura) as Factura, 
   concat(
		repeat(	"*", 
					round(
						tot.import / 
							(	select max(import_total)  import
								from
									(	select 
											sum(rf2.QUANTITAT * rf2.IMPORT_UNITARI) import_total
										from		
											bank.reglons_factura as rf2
										group by
											rf2.ID_FACTURA) fact) 
							 * 100)/4), 
						" (", tot.import, ")") BarGraph
from 
	(	select 
			rf1.ID_FACTURA id_factura,
			sum(rf1.QUANTITAT * rf1.IMPORT_UNITARI) import
		from		
			bank.reglons_factura as rf1
		group by
			rf1.ID_FACTURA) tot, 
	bank.factures fac,
   bank.series_factura ser
where
	tot.id_factura = fac.id_factura and
   fac.id_serie_factura = ser.id_serie_factura;
   

-- Factures emeses ENTRE dues dates   
-- Exemple de filtrat entre dues dates
select
	*
from 
	bank.factures fa
where
	fa.data >= str_to_date("01/01/2005", "%d/%m/%Y")  and
	fa.data <= str_to_date("01/02/2005", "%d/%m/%Y");

-- Factures emeses ENTRE dues dates
-- Exemple de conversió de tipus emprant la funció CAST
select
	*
from 
	bank.factures fa
where
	fa.data >= cast("2005-01-01" as date)  and
	fa.data <= cast("2005-02-01" as date);

-- Factures emeses EN dues dateS concretes
-- Exemple de com emprar IN
select
	*
from 
	bank.factures fa
where
	fa.data in (
		str_to_date("01/01/2005", "%d/%m/%Y"),
		str_to_date("01/02/2005", "%d/%m/%Y"));
 
-- Factures emeses ENTRE dues dates
-- Exemple de filtre emprant l'expressió BETWEEN    
select
	*
from 
	bank.factures fa
where
	fa.data between 
		cast("2005-01-01" as date)  and cast("2005-02-01" as date);
  

 -- Vista que permet vora totes les factures completes, incloses les seves linies
 -- Exemple de creacio de View
 -- Llegiu l'article següent: https://www.techonthenet.com/mysql/views.php
 create or replace view factures_completes as 
 select 
 	if(rf.num_reglo_factura=1, date_format(fa.data, "%d/%m/%y"), "") as "Data",
 	if(rf.num_reglo_factura=1, concat_ws("-",sf.cod_serie_factura, lpad(fa.num_factura,6,"0")), "") as Factura,
 	lpad(rf.num_reglo_factura,2,"0") as Reglo,
 	concat_ws(" - ", ts.descripcio, rf.descripcio) as Concepte,
 	rf.quantitat as Unitats,
 	format(rf.import_unitari,2) as Preu,
 	format(rf.quantitat * rf.import_unitari,2) as Import
 from 
 	bank.series_factura as sf, 
 	bank.factures as fa, 
 	bank.reglons_factura as rf, 
 	bank.tipus_serveis as ts,  
 	bank.serveis as se
 where
 	sf.id_serie_factura = fa.id_serie_factura and
 	fa.id_factura = rf.id_factura and
 	ts.id_tipus_servei = se.id_tipus_servei and
 	se.id_servei = rf.id_servei
 order by 
 	fa.data, 
 	sf.cod_serie_factura, 
 	fa.num_factura, 
	rf.num_reglo_factura;
	
-- Inner Join o join complet
-- Se pot apreciar que les factures sense reglons no apereixen
-- Llegiu l'article següent: https://www.techonthenet.com/mysql/joins.php
select
	*
from
	bank.factures fa, bank.reglons_facturare 
where
	fa.id_factura = re.id_factura and
	re.id_factura is null;

-- Inner Join o join complet amb la sintaxi específica per JOINS
-- Se pot apreciar que les factures sense reglons no apereixen
-- És exactament igual que la anterior sentencia
select 
	*
from 
	bank.factures fa
		inner join bank.reglons_factura re on fa.id_factura = re.id_factura
where
	re.id_factura is null;

-- Mostre totes les factures que no tenen cap regló.
-- Exemple de LEFT OUTER JOIN.
select 
	*
from 
	bank.factures fa
		left join bank.reglons_factura re on fa.id_factura = re.id_factura
where
	re.id_factura is null;

-- Mostre totes les factures que no tenen cap regló
-- Exactament com l'anterior select.
-- Exemple de RIGHT OUTER JOIN.
select 
	*
from 
	bank.reglons_factura re
		right join bank.factures fa on fa.id_factura = re.id_factura
where
	re.id_factura is null;



-- Exercici 1 Examen
-- Solució proposada
select 
	te.num_telefon Telefon, 
   co.ID_CONTRACTE Contracte, 
   cl.NOM Client, 
   dp.DESCRIPCIO Pagament,
   su.DESCRIPCIO,
   ba.DESCRIPCION Banc   
from 
	telefons te 
		left join (
			bank.contractes co 
				left join bank.clients cl  using (id_client)
				left join bank.domiciliacions_pagament dp using (id_contracte)
				left join bank.sucursals su using (id_sucursal)
				left join bank.bancs ba using (id_banc) ) 
		using (id_telefon) 
;

-- Exercici 2 Examen.
-- Resposta incorrecta
-- No contempla les possibles repeticions
select 
   cl.NOM Client, 
   ba.DESCRIPCION Banc,  
   su.DESCRIPCIO Sucursal
from 
	bank.contractes co 
		inner join bank.clients cl  using (id_client)
		inner join bank.domiciliacions_pagament dp using (id_contracte)
		inner join bank.sucursals su using (id_sucursal)
		inner join bank.bancs ba using (id_banc) 
;

-- Exercici 2 examen
-- Solució proposada
select 
   cl.NOM Client, 
   ba.DESCRIPCION Banc,  
   su.DESCRIPCIO Sucursal
from 
	bank.contractes co 
		inner join bank.clients cl  using (id_client)
		inner join bank.domiciliacions_pagament dp using (id_contracte)
		inner join bank.sucursals su using (id_sucursal)
		inner join bank.bancs ba using (id_banc) 
group by
	cl.nom, ba.descripcion, su.descripcio
;

-- Exercici 3 Examen
-- Solució incorrecte ja que compta domiciliacions no clients
select 
   ba.DESCRIPCION Banc,  
   count(*) Clients
from 
	bank.contractes co 
		inner join bank.clients cl  using (id_client)
		inner join bank.domiciliacions_pagament dp using (id_contracte)
		inner join bank.sucursals su using (id_sucursal)
		inner join bank.bancs ba using (id_banc) 
group by
	ba.id_banc
;

-- Exercici 3 Examen
-- Solució proposada
select
   ba.DESCRIPCION Banc,  
   count(distinct(cl.id_client)) Clients
from 
	bank.contractes co 
		inner join bank.clients cl  using (id_client)
		inner join bank.domiciliacions_pagament dp using (id_contracte)
		inner join bank.sucursals su using (id_sucursal)
		inner join bank.bancs ba using (id_banc) 
group by
	ba.id_banc
having Clients > 5
;

-- Exercici 4 Examen
-- Hi ha que considerar que hi por haver bancs sense sucursals i
-- També hi pot haver sucursals sense domiciliacions.
-- Els bancs sense sucursals i el que no tenen cap sucursals amb domiciliacions 
-- són els que se demanen.
-- sucursals sensa domiciliacions.
-- Solució proposada.
select 
   ba.descripcion Banc, 
   sum(if(dp.id_sucursal is not null, 1, 0)) Domiciliacions
from 
	bank.bancs ba 
      left join bank.sucursals su using(id_banc)
		left join bank.domiciliacions_pagament dp using (id_sucursal)
group by
	ba.id_banc
having
	Domiciliacions = 0
;

-- Exercici 4 Examen
-- Solució alternativa també correcta
select 
   ba.descripcion Banc, 
	count(dp.id_sucursal) Domiciliacions
from 
	bank.bancs ba 
      left join bank.sucursals su using(id_banc)
		left join bank.domiciliacions_pagament dp using (id_sucursal)
group by
	ba.id_banc
having
	Domiciliacions =0
;

-- Exercici 4 Examen
-- Sentencia per ajudar a la comprensió de la solució proposada
select 
   ba.descripcion Banc, su.*, 
   dp.ID_SUCURSAL, 
   if(dp.id_sucursal is not null, 1, 0) Domiciliacions
from 
	bank.bancs ba 
      left join bank.sucursals su using(id_banc)
		left join bank.domiciliacions_pagament dp using (id_sucursal)
;


-- Nombre de trucades per banc.
-- Han d'apareixer tots els bancs, inclos els que no 
-- tenen cap trucada.
use bank;

SELECT 
	ba.descripcion Banc, 
   count(tr.id_trucada) Trucades 
FROM 
	trucades tr
		inner join domiciliacions_pagament dp using (id_contracte)
		inner join sucursals su using (id_sucursal)
      right join bancs ba using (id_banc)
GROUP BY
	ba.descripcion;

-- Alternativa del ej 1 del examen
    
SELECT 
	ba.descripcion Banc, 
   count(tr.id_trucada) Trucades 
FROM 
	bancs ba
		left join sucursals su using (id_banc)
        left join domiciliacions_pagament dp using (id_sucursal)
        left join trucades tr using (id_contracte)
GROUP BY
	ba.descripcion;
   
-- Comptar les trucades realitzades per cadascun dels telefons.
-- També han d'apareixer els telefons amb 0 trucades.
SELECT 
	te.num_telefon Telefon, 
   count(tr.id_contracte) Contractes
FROM 
	trucades tr
		inner join contractes co using (id_contracte)
		right join telefons te using (id_telefon)      
GROUP BY
	te.id_telefon;

-- Telefons que no han rebut cap trucada.
SELECT 
	te.num_telefon
FROM 
	trucades tr
		right join telefons te on (tr.id_telefon_trucat=te.id_telefon)
WHERE
	tr.id_contracte is null;

-- Telefons que han no han rebut trucades pero que si tenen contracte
-- actiu
select 
	te_nt.num_telefon Telefon
from (
	SELECT 
		te.id_telefon as id_telefon,
      te.num_telefon as num_telefon
	FROM 
		trucades tr
			right join telefons te on (tr.id_telefon_trucat=te.id_telefon)
	WHERE
		tr.id_contracte is null) te_nt
      inner join contractes co using (id_telefon);

-- Estadistica de quantitat de telefon que han realitzat trucades i
-- quantitat de telefon que han rebut trucades i
-- quantitat total de nombres de telefons enregistrats
SELECT 
	"Quantitat telefons que han rebut trucades" Concepte, 
   count(distinct tr.id_telefon_trucat) Quantitat
FROM 
	trucades tr UNION   
SELECT
	"Quantitat telefons han realitzat trucades" Concepte,
   count(distinct co.id_telefon) Quantitat
FROM
	contractes co UNION
SELECT
	"Quantitat telefons enregistrats" Concepte,
   count(*)
FROM
	Telefons te;
   
-- Clients que tenen coma a mínim un contracte actiu i 
-- un que esta de baixa.
select 
	cl.nom, cl.edat
from
	(select 
		co.id_client id_client,
		co.id_contracte id_contracte 
	from
		contractes co
	where
		co.data_baixa is not null) co_baixa
		inner join
			(select 
				co.id_client id_client,
				co.id_contracte id_contracte 
			from
				contractes co
			where
				co.data_baixa is null) co_actius using(id_client)
		inner join clients cl using (id_client);

select id_client, data_baixa
from contractes
order by 1;