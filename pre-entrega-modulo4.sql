/* =============================================================================
   PRE-ENTREGA 4: Consultas multicapa para análisis de negocio
   Nota de ejecución: Este script extraido en clase crea las tablas e inserta datos.
   ============================================================================= */

CREATE SCHEMA IF NOT EXISTS practica_m4;
SET search_path TO practica_m4;

CREATE TABLE categorias (
    categoria_id SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL
);

CREATE TABLE productos (
    producto_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio NUMERIC(10,2) NOT NULL,
    id_categoria INT REFERENCES categorias(categoria_id)
);

CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE ventas (
    venta_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(cliente_id),
    producto_id INT REFERENCES productos(producto_id),
    cantidad INT NOT NULL,
    fecha DATE NOT NULL
);

INSERT INTO categorias (nombre_categoria) VALUES
('Tecnología'), ('Hogar'), ('Deportes');

INSERT INTO productos (nombre, precio, id_categoria) VALUES
('Notebook', 1200, 1), ('Mouse', 25, 1), ('Monitor', 300, 1),
('Licuadora', 80, 2), ('Sartén', 40, 2), ('Aspiradora', 150, 2),
('Pelota', 30, 3), ('Bicicleta', 500, 3), ('Mancuernas', 60, 3), ('Carpa', 200, 3);

INSERT INTO clientes (nombre) VALUES
('Ana'), ('Bruno'), ('Carla'), ('Diego'), ('Elena');

INSERT INTO ventas (cliente_id, producto_id, cantidad, fecha) VALUES
(1, 2, 2, '2024-03-01'), (1, 1, 1, '2024-03-05'), (1, 2, 1, '2024-04-10'),
(2, 4, 1, '2024-03-07'), (2, 8, 1, '2024-04-02'),
(3, 7, 3, '2024-03-15'), (3, 7, 2, '2024-04-20'), (3, 10, 1, '2024-05-01'),
(4, 3, 2, '2024-05-03'), (4, 5, 1, '2024-05-04');




/* =============================================================================
Query 1
Rentabilidad por categoria, esta consulta muestra las unidades vendidas
y los ingresos generados por cada una. Mostrandonos cual categoria es mas rentable.
El umbral definido en 5 muestra categorias con ingresos significativos y alto movimiento de stock.
 ============================================================================= */
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
HAVING SUM(v.cantidad) > 5;

/* =============================================================================
Query 2
'Clientes sin compras', esta consulta muesta clientes sin coincidencia de
compras.
 ============================================================================= */
SELECT c.nombre, 
coalesce(v.cantidad,0) as cantidad 
FROM clientes c 
LEFT JOIN ventas v
ON v.cliente_id=c.cliente_id 
WHERE v.cliente_id  is null;


/* =============================================================================
Query 3
Esta query muestra el top de compras por cliente y cuando fue la última vez
que realizo esta compra, mostandonos las preferencias de los clientes.
 ============================================================================= */
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




