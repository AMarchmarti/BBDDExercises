DROP SCHEMA ejerciciocursores;

DROP DATABASE pedidos;

CREATE DATABASE IF NOT EXISTS pedidos CHARACTER SET LATIN1 COLLATE LATIN1_SPANISH_CI;

USE pedidos;

CREATE TABLE pedido(
	refped CHAR(5) PRIMARY KEY,
	fecped DATE NOT NULL
);

CREATE TABLE articulo(
	codart CHAR(5) PRIMARY KEY,
	desart VARCHAR(30) NOT NULL,
	pvpart FLOAT(6,2) UNSIGNED NOT NULL
);

CREATE TABLE lineapedido(
	refped CHAR(5),
	codart CHAR(5),
	cantart INT(4) UNSIGNED NOT NULL DEFAULT 1,
	INDEX (refped),
	FOREIGN KEY (refped) REFERENCES pedido(refped) ON UPDATE CASCADE,
	INDEX (codart),	
	FOREIGN KEY (codart) REFERENCES articulo(codart) ON UPDATE CASCADE,
	PRIMARY KEY (refped, codart)
);

INSERT INTO pedido VALUES ('P0001', '2014-02-16');
INSERT INTO pedido VALUES ('P0002', '2014-02-18'); 
INSERT INTO pedido VALUES ('P0003', '2014-02-23');
INSERT INTO pedido VALUES ('P0004', '2014-02-25');

INSERT INTO articulo VALUES ('A0043', 'Bolígrafo azul', 0.78);
INSERT INTO articulo VALUES ('A0078', 'Bolígrafo rojo normal', 1.05);
INSERT INTO articulo VALUES ('A0075', 'Lápiz 2B', 0.55);
INSERT INTO articulo VALUES ('A0012', 'Goma de borrar', 0.15);
INSERT INTO articulo VALUES ('A0089', 'Sacapuntas', 0.25);

INSERT lineapedido VALUES ('P0001', 'A0043', 10);
INSERT lineapedido VALUES ('P0001', 'A0078', 12);
INSERT lineapedido VALUES ('P0002', 'A0043', 5);
INSERT lineapedido VALUES ('P0003', 'A0075', 20); 
INSERT lineapedido VALUES ('P0004', 'A0012', 15); 
INSERT lineapedido VALUES ('P0004', 'A0043', 5); 
INSERT lineapedido VALUES ('P0004', 'A0089', 50);

    
    
    
-- 1. Crea un procedimiento llamado verPedido, que muestre sólo una fila de la tabla pedido,
-- debe de mostrar su referencia y fecha mediante el empleo de un cursor.
-- Ejemplo de salida:
-- +---------------------------------------------+
-- | Datos Pedidos |
-- +---------------------------------------------+
-- | Referencia: P0001 Fecha: 2014-02-16 |
-- +---------------------------------------------+

DELIMITER //
DROP PROCEDURE IF EXISTS verPedido;//
CREATE PROCEDURE verPedido() 
BEGIN
declare referencia varchar(10);
declare fecha date;
DECLARE cursor1 CURSOR FOR
SELECT p.refPed, p.fecped FROM pedido p;
OPEN cursor1;
FETCH cursor1 INTO referencia, fecha;
CLOSE cursor1;
SELECT concat('Referencia: ', referencia, ' Fecha: ', fecha) as 'Datos Pedidos';
end;//
DELIMITER ;
caLL verPedido();

-- 2. Modifica  verPedido, para que muestre cada una de las filas de la tabla pedido. 
-- Además, se debe de mostrar un mensaje dependiendo de la cantidad en años que tenga el pedido, 
-- siendo éste “vigente” si tienes menos de 2 años, “antiguo” si tiene 3 ó 4 años y “muy antiguo” 
-- si tiene 5 o más años.

delimiter //
drop procedure if exists verPedidoModificado; //
create procedure verPedidoModificado()
begin
declare temp date;
declare variable int;
declare fallo bool;
declare cursor1 cursor for select p.fecped from pedido p;
declare continue handler for not found set fallo=1;
set fallo=0;
open cursor1;
loop1: loop
fetch cursor1 into temp;
set variable = (datediff(now(), temp))/365;
if  variable > 0 and variable < 2 then 
select variable as 'vigente';
end if;
if variable < 4 and variable > 2 then
select variable as 'antiguo';
end if;
if variable >= 5 then 
select variable as 'muy antiguo';
end if;
if fallo=1 then leave loop1;
end if;
end loop loop1;
close cursor1;
select 'Hola';
end; //

delimiter ;

-- Llamada a la funcion
call verPedidoModificado(); 
 