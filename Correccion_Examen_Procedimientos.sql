-- Correción Examen Cursores y Handlers

/* Ejercicio 1 Mostrar por pantalla los empleados que se hayan dado de alta entre dos fechas que pasaremos por parametro
   con el nombre del departamente, que muestre los de un mismo departamento juntos, su jefe si tiene y el sueldo nos diga si es menor
   a 1200 bajo, si esta entre 1200 a 3000 medio y si es mayor a 3000 alto. */
   
   delimiter //
   drop procedure if exists verEmpleados //
   create procedure verEmpleados(fecha1 date, fecha2 date)
   begin
		-- Variables no utilizadas en el fetch
		-- DECLARE departViejo VARCHAR(40) DEFAULT '';
        -- Numerará los empleados que tiene cada departamento (se reinicia al empezar la cuenta de un nuevo departamento)
		DECLARE i INT(3) DEFAULT 0;
		-- Controlará el número total de empleados
		DECLARE total INT(3) DEFAULT 0;
		DECLARE	sueldo FLOAT(7,2);
		DECLARE jefe VARCHAR(40); 
        
        -- VAriables utilizadas pro el cursor
        DECLARE	departamento VARCHAR(40);
		DECLARE numEmple INT(4);
		DECLARE apeEmple VARCHAR(40);
		DECLARE oficioEmple	ENUM ('EMPLEADO', 'VENDEDOR', 'DIRECTOR', 'ANALISTA', 'PROGRAMADOR', 'PRESIDENTE') ;
		DECLARE numjefe INT(4);
		DECLARE fecha	DATE;
		DECLARE	salarioEmple FLOAT(7,2);
		DECLARE comisionEmple FLOAT(7,2);
        
        -- Variable para controlar el error(variable del handler) la inicializamos a 0 para ahorrarnos el set
        declare fallo bool default 0;
         
        -- Cursor
        declare datos cursor for 
			select d.dnombre, e.emp_no, e.apellido, e.oficio, e.dir, e.fecha_alt, e.salario, e.comision
			from depart d, emple e
            where  d.dept_no= e.dept_no AND e.fecha_alt BETWEEN fecha1 AND fecha2  -- El between se usa para hacer que el select este entre las dos fechas asi no tenemos que controlarlo en el cursor
            order by d.dept_no;  -- Usamos un order by para ordenar el código de los departamentos por orden, así provocamos que salgan por orden y todo los de un mismo tipo juntos.


		-- Handler
        declare continue handler for 1329 set fallo = 1; -- 1329 es el codigo del error not found, por tanto podemos poner not found o 1329.
        
        -- Lógica del programa
        open datos;
			fetch datos into departamento, numEmple, apeEmple, oficioEmple, numjefe, fecha, salarioEmple, comisionEmple; -- Lo ponemos fuera del while para que al introducir los valores nulos salte el error.
            
            while fallo = 0 do
				-- Lo primero de todo es efectuar la comprobación si tiene jefe.
				if numjefe is null then -- Comprobamos que el numero del jefe de la columna dir es nulo, asi vemos si ese empleado tiene jefe o no
					set jefe = "no tiene";
				else
					-- En caso de tener jefe, lo queremos mostrar por su apellido por tanto
                    select apellido into jefe from emple where emp_no = numjefe; -- Esto nos indica que una vez encontrado el jefe este lo va insertar dentro de la variable jefe.
				end if;
                
                SET i = i+1;
				SET total= total+1;
                -- Aqui vamos a exponer la lógica del programa sobre los sueldos, lo primero vamos a juntar la comision con el salario para saber el sueldo.
                set sueldo = salarioEmple + comisionEmple;
                
               IF sueldo<1200 THEN
					SELECT CONCAT(i,",Empleado: ",apeEmple,', Alta: ', fecha,', Oficio: ',oficioEmple, ', jefe: ',jefe, ', sueldo bajo: ', sueldo,'€',",Departamento: ", departamento) Empleado;
				ELSEIF sueldo < 3000 THEN
					SELECT CONCAT(i, ",Empleado: ",apeEmple,', Alta: ', fecha,', Oficio: ',oficioEmple, ', jefe: ',jefe, ', sueldo medio: ', sueldo,'€', ",Departamento: ", departamento) Empleado;
				ELSE			
					SELECT CONCAT(i, ",Empleado: ",apeEmple,', Alta: ', fecha,', Oficio: ',oficioEmple, ', jefe: ',jefe, ', sueldo alto: ', sueldo,'€', ",Departamento: ", departamento) Empleado;
				END IF;
                
                FETCH datos INTO departamento, numEmple, apeEmple, oficioEmple, numjefe, fecha, salarioEmple, comisionEmple; -- Necesario para evitar el bucle infinito, aqui ocurre el fallo = 1.
                -- Fin del while
			end while;
			
             -- Ahora vamos a insertar el select para poder ver el total de empleados dados de alta entre las fechas seleccionadas.
            IF fecha1=fecha2 THEN
				-- Este if no es necesario. Sólo cambia el texto a mostrar si las dos fechas son la misma (Para que quede más bonito si se le llama desde el ejercicio 2).
				SELECT CONCAT('Total de empleados de la empresa cuya fecha de alta es ',fecha1,': ', total) "TOTAL DE EMPLEADOS";
			ELSE
				SELECT CONCAT('Total de empleados de la empresa cuya fecha de alta es entre ',fecha1, ' y ',fecha2,': ', total) "TOTAL DE EMPLEADOS";
			END IF;
        
        -- fin del cursor
        close datos;
	
    -- Finalización del ejercicio
    end //
    
    -- Comprovamos que todo ha funcionado como esperamos.
    call verEmpleados('2010/05/01','2019/05/01') //
        
