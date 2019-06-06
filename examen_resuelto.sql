-- Examen Resolt

-- Nombre de trucades per banc.
-- Han d'apareixer tots els bancs, inclos els que no 
-- tenen cap trucada.

-- Primera solució
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


-- Segona alternativa 
SELECT 
	ba.descripcion Banc, 
   count(tr.id_trucada) Trucades 
FROM 
	trucades tr
		left join domiciliacions_pagament dp using (id_contracte)
		inner join sucursals su using (id_sucursal)
      right join bancs ba using (id_banc)
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

-- Dos soluciones que expresan lo mismo
select datos.num_telefon
from 
	(SELECT 
		te.num_telefon
	FROM 
		trucades tr
			right join telefons te on (tr.id_telefon_trucat=te.id_telefon)
	WHERE
		tr.id_contracte is null) datos, telefons tel, contractes c
where c.id_telefon = tel.id_telefon and datos.num_telefon = tel.num_telefon and c.data_baixa is null;

select datos.num_telefon
from 
	(SELECT 
		te.num_telefon
	FROM 
		trucades tr
			right join telefons te on (tr.id_telefon_trucat=te.id_telefon)
	WHERE
		tr.id_contracte is null) datos
        inner join telefons tl using (num_telefon)
        inner join contractes c using (id_telefon)
where c.data_baixa is null;

-- Solución alternativa
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
      
-- Otra solución alternativa
select no_truc.NombreTelefon
from
	(select
		t.id_telefon, t.num_telefon as NombreTelefon, tr.id_telefon_trucat
	from 
		telefons t
			left join trucades tr on t.id_telefon = tr.id_telefon_trucat
	where tr.data_trucada is null) as no_truc
    left join contractes co using (id_telefon)
where co.data_baixa is null and
	co.id_contracte is not null;
    

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
	-- Select per trobar el contractes que estan actius.
	(select 
		co.id_client id_client,
		co.id_contracte id_contracte 
	from
		contractes co
	where
		co.data_baixa is not null) co_baixa
        
		inner join
        
	-- Select per trobar els contractes que estan inactius.
			(select 
				co.id_client id_client,
				co.id_contracte id_contracte 
			from
				contractes co
			where
				co.data_baixa is null) co_actius using(id_client)
		inner join clients cl using (id_client);


-- Solucio alternativa
select  c.nom as Nom, c.edat as Edat 
from
	-- Select para filtrar los clientes por la cantidad de contratos que tienen si Alta siente más que baja es que tiene contratos activos.
	(select co.id_client, count(co.data_alta) as Alta, count(co.data_baixa) as Baja
		
	from 
		contractes co

	group by co.id_client
	having Alta > Baja and 
		Baja > 0) as ab
        
	left join clients c on ab.id_client = c.id_client;
	