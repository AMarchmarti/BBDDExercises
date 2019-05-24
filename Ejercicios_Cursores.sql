-- DROP SCHEMA ejerciciocursores;

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

CREATE DATABASE empresa;
USE empresa;

CREATE TABLE depart(
	dept_no	INT(3) UNSIGNED PRIMARY KEY,
	dnombre VARCHAR(40) UNIQUE NOT NULL,
	loc		VARCHAR (40) NOT NULL
);

CREATE TABLE emple(
	emp_no	INT(4) UNSIGNED PRIMARY KEY,
	apellido VARCHAR(40) NOT NULL,
	oficio	ENUM ('EMPLEADO', 'VENDEDOR', 'DIRECTOR', 'ANALISTA', 'PROGRAMADOR', 'PRESIDENTE') NOT NULL,
	dir 	INT(4) UNSIGNED,
	fecha_alt	DATE NOT NULL,
	salario FLOAT(7,2) UNSIGNED NOT NULL,
	comision FLOAT(7,2) UNSIGNED,
	dept_no INT(3) UNSIGNED DEFAULT 10 NOT NULL,
	INDEX (dir),
	FOREIGN KEY(dir) REFERENCES emple(emp_no) ON UPDATE CASCADE,
	INDEX(dept_no),
	FOREIGN KEY(dept_no) REFERENCES depart(dept_no) ON UPDATE CASCADE
);

INSERT INTO depart VALUES (10,'CONTABILIDAD', 'SEVILLA');
INSERT INTO depart VALUES (20,'INVESTIGACIÓN', 'MADRID');
INSERT INTO depart VALUES (30,'VENTAS', 'BARCELONA');

INSERT INTO emple VALUES (7839,'REY', 'PRESIDENTE', NULL, '2010/11/17', 3900, 0, 10);
INSERT INTO emple VALUES (7698,'NEGRO', 'DIRECTOR', 7839, '2010/05/01', 2200, 0, 30);
INSERT INTO emple VALUES (7738,'CEREZO', 'DIRECTOR', 7839, '2010/09/06', 2210, 0, 10);
INSERT INTO emple VALUES (7566,'JIMÉNEZ', 'DIRECTOR', 7839, '2010/02/04', 2300, 0, 20);
INSERT INTO emple VALUES (7499,'ARROYO', 'VENDEDOR', 7698, '2009/02/20', 1200, 240, 30);
INSERT INTO emple VALUES (7521,'SALA', 'VENDEDOR', 7698, '2010/02/22', 960, 390, 30);
INSERT INTO emple VALUES (7654,'MARTÍN', 'VENDEDOR', 7698, '2010/09/29', 965, 1000, 30);
INSERT INTO emple VALUES (7844,'TOVAR', 'VENDEDOR', 7698, '2010/09/08', 1100, 0, 30);
INSERT INTO emple VALUES (7900,'JIMENO', 'EMPLEADO', 7698, '2010/12/03', 725, 0, 30);
INSERT INTO emple VALUES (7369,'SÁNCHEZ', 'EMPLEADO', 7900, '2012/12/12', 600, 0, 20);
INSERT INTO emple VALUES (7788,'GIL', 'ANALISTA', 7566, '2013/04/23', 2350, 0, 20);
INSERT INTO emple VALUES (7876,'ALONSO', 'EMPLEADO', 7788, '2013/08/09', 860, 0, 20);
    
    
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

/*3. Realiza un procedimiento llamado verArticuloPedido, en que solicite por parámetro
el código de un producto y muestre cada uno de los pedidos que tiene asociado, así como el
número de unidades solicitadas del artículo.
Si el pedido tiene un número de unidades de 5 o menos, se indicará que es un pedido
pequeño, si tiene entre 6 y 10 unidades, será un pedido mediano y si tiene 15 o más
unidades, será un pedido grande.*/
delimiter //
drop procedure if exists verArticuloPedido //
create procedure verArticuloPedido(codigo varchar(10))
begin
	declare cantidad int(3);
    declare pedidoAsociado varchar(20);
    declare fallo bool;
    
    declare cursor1 cursor for
		select
			l.refped, l.cantart
		from
			lineapedido l
		where
			codigo = l.codart;
	
    declare continue handler for 1062 set fallo = 1;
    set fallo = 0;
    
    open cursor1;
		while fallo = 0 do
			fetch cursor1 into pedidoAsociado, cantidad;
			if cantidad <= 5 then
				select pedidoAsociado as 'Referencia del pedido', cantidad as 'pequeño';
			end if;
			
			if cantidad >= 6 and cantidad <= 10 then
				select pedidoAsociado as 'Referencia del pedido', cantidad as 'mediano';
			end if;
			
			if cantidad > 15 then
				select pedidoAsociado as 'Referencia del pedido', cantidad as 'grande' ;
			end if;
		end while;
    close cursor1;
end //
-- Llamada al procedimiento
delimiter ;
call verArticuloPedido('A0043');

/*4. Crea un procedimiento insertarPedido que se encargue de añadir un nuevo pedido a
la tabla PEDIDO, este procedimiento recibirá como parámetros la referencia del pedido que
se desea añadir y su fecha. Debe de mostrar un mensaje si se ha realizado correctamente.
Excepciones:*/
delimiter //
drop procedure if exists insertarPedido //
create procedure insertarPedido(refPedido varchar(20), fecha date)
modifies sql data
begin
	declare fallo bool;
    
    declare continue handler for 1062 set fallo = 1;
    insert into pedido (refped, fecped) values (refPedido, fecha);
    
    if fallo = 1 then
		select concat("Error en la inserción de ", refPedido, " clave referenciada duplicada") as 'Resultado';
	else
		select concat("Pedido ", refPedido, " añadido en ésta fecha: ", fecha) as 'Resultado';
	end if;
end //
-- LLamada al procedimiento
delimiter ;
call insertarPedido('P0005', now()); -- Éste va a insertarlo


/*5. Modifica el procedimiento insertarPedido para que, en el caso que se produzca la
excepción al insertar un pedido repetido (clave duplicada), no finalice anormalmente
mostrando la descripción por defecto del error por pantalla, y en su lugar, termine 
normalmente y guarde en una variable de salida estado, un mensaje con el tipo de error
“Clave duplicada”. Se debe de utilizar un manejador o handler.*/

delimiter //
drop procedure if exists insertarPedidoModificado //
create procedure insertarPedidoModificado(refPedido varchar(20), fecha date, inout estado bool)
modifies sql data
begin
    
    
    declare continue handler for 1062 set estado = 1;
    set estado = 0;
    insert into pedido (refped, fecped) values (refPedido, fecha);
    
    if estado = 1 then
		 select estado as estadoReferencia;
	else
		select concat("Pedido ", refPedido," añadido en ésta fecha: ",fecha) as "Resultado";
	end if;
end //

delimiter ;

call insertarPedidoModificado('P0005', now(),@estado); -- Éste va a dar error

/*6. Crea un procedimiento llamado insertar que se encargue de llamar a insertarPedido
y nos informe si la inserción se ha podido llevar a cabo o no. Nos debe de mostrar un
mensaje de error confeccionado por nosotros para el tipo de error que nos devuelve, por
ejemplo “ERROR. Ya hay un pedido con la referencia XXXX”.*/
delimiter //
drop procedure if exists insertar //
create procedure insertar(refPedido varchar(20), fecha date)
modifies sql data
begin
	declare variable bool;
    call insertarPedidoModificado(refPedido, fecha,variable);
    if variable = 1 then
		select concat("ERROR. Ya hay un pedido con la referencia ", refPedido) as "Resultado";
	end if;
end //
-- LLamada al procedimiento
delimiter ;
call insertar('P0006', now()); -- Éste va a insertarlo
call insertar('P0006', now()); -- Éste va a dar error.

/*7. Crea un procedimiento que reciba como parámetro el código de un artículo y nos muestre su
descripción en caso de existir. En caso de que no exista ningún artículo con dicho código, se
mostrará un mensaje como el siguiente: “No existe ningún artículo con el código XXXXX”.
*/
delimiter //
drop procedure if exists mostrarDescripcion //
create procedure mostrarDescripcion(codigo varchar(20))
begin
	declare fallo bool;
    declare descripcion varchar(50);
        
    declare cursor1 cursor for
    select a.desart from articulo a where a.codart = codigo;
    
    declare continue handler for 1329 set fallo = 1;
    
    open cursor1;
    fetch cursor1 into descripcion;
    close cursor1;
    if fallo = 1 then
		select concat("No existe ningún artículo con el código: ", codigo) as 'Resultado';
	else
		select descripcion as 'Resultado';
	end if;
end //
-- Llamada al procedimiento
delimiter ;
call mostrarDescripcion('A0012');
call mostrarDescripcion('A0013'); -- Éste dará error  

/*8. Crea un procedimiento llamado cambiarJefe que cambie el director o jefe de un
empleado en la tabla emple de la base de datos Empresa.
Este procedimiento recibirá el apellido del empleado cuyo jefe se desea modificar y el
apellido de su nuevo empleado jefe.
En este procedimiento se pueden dar dos situaciones de error o excepciones (código 1329):
- Que no exista el empleado cuyo jefe se desea modificar.
- Que no exista el nuevo empleado jefe que se le quiere asignar.
Ejemplos de salida:
+-----------------------------------------+
| Mensaje |
+-----------------------------------------+
| El nuevo jefe de AAAA es BBBB |
+-----------------------------------------+
+--------------------------------------------------------------+
| Error jefe |
+--------------------------------------------------------------+
| No existe ningún empleado jefe apellidado CCCCC |
+--------------------------------------------------------------+
+----------------------------------------------------------+
| Error empleado |
+----------------------------------------------------------+
| No existe ningún empleado apellidado CCCCC |
+----------------------------- -------------------------------+*/

delimiter //
drop procedure if exists cambiarJefe //
create procedure cambiarJefe(apellidoEmpleado varchar(20), apellidoJefeACambiar varchar(20))
modifies sql data
begin
	declare tempNumeroJefe int;
    declare fallo bool;
    
    declare cursor1 cursor for
		select 
			e.emp_no 
		from 
			emple e
		where 
			apellidoJefeACambiar = e.apellido;
            
	declare continue handler for 1329 set fallo = 1;
    set fallo = 0;
    
    open cursor1;
		while1: while fallo = 0 do
			fetch cursor1 into tempNumeroJefe;
            
            if fallo = 1 then
				select concat("No existe ningún empleado jefe apellidado ", apellidoJefeACambiar) as 'Error Jefe';
                
            elseif exists (SELECT apellido FROM emple WHERE apellido=apellidoEmpleado) then
				update emple set dir = tempNumeroJefe where apellido=apellidoEmpleado;
				select concat("El nuevo jefe de ", apellidoEmpleado, " es ", apellidoJefeACambiar) as 'Mensaje';
                leave while1;
                
			else
				select concat("No existe ningún empleado apellidado ", apellidoEmpleado) as 'Error Empleado';
                leave while1;
			end if;
		end while while1;
    close cursor1;
end //
-- Llamada a la función
delimiter ;
call cambiarJefe("March", "Martínez"); -- Caso en el que no existe ningún jefe con ése apellido.

call cambiarJefe("MArch", "JIMÉNEZ"); -- Caso en el que sí existe un jefe con ése apellido pero no un empleado.

call cambiarJefe("SÁNCHEZ", "JIMÉNEZ"); -- Caso en el que existen tanto jefe com empleado.

    
    
   


 