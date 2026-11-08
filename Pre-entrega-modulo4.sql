----Query 1
---Rentabilidad por categoria, esta consulta muestra las unidades vendidas
---y los ingresos generados por cada una. Mostrandonos cual categoria es mas rentable.
SELECT
    c.nombre_categoria AS Categoria,
    SUM(v.cantidad) AS unidades_vendidas,
    SUM(v.cantidad * p.precio) AS ingreso_total
FROM ventas v
INNER JOIN productos p
    ON v.producto_id = p.producto_id
INNER JOIN categorias c
    ON p.id_categoria = c.categoria_id
GROUP BY c.nombre_categoria
HAVING SUM(v.cantidad) > 1;


----Query 2
---'Clientes sin compras', esta consulta muesta clientes sin coincidencia de
--- compras.
SELECT c.nombre, 
coalesce(cantidad,'0') as cantidad 
FROM clientes c 
LEFT JOIN ventas v
ON v.cliente_id=c.cliente_id 
WHERE cantidad is null;

----Query 3
--- Esta query muestra el top de compras por cliente y cuando fue la última vez
--- que realizo esta compra, mostandonos las preferencias de los clientes.
SELECT c.nombre as nombre_cliente,
	(SELECT p2.nombre
        FROM ventas v2
        INNER JOIN productos p2
            ON v2.producto_id = p2.producto_id
        WHERE v2.cliente_id = c.cliente_id
        GROUP BY p2.producto_id, p2.nombre
        ORDER BY COUNT(*) DESC, p2.producto_id
        LIMIT 1
    ) AS producto_mas_comprado,
    
    MAX(v.fecha) AS ultima_transaccion
    
FROM clientes c
INNER JOIN ventas v 
	ON c.cliente_id= v.cliente_id
INNER JOIN productos p 
	ON v.producto_id= p.producto_id

GROUP BY c.cliente_id, c.nombre;




