#Crear la base Pre_entrega2 y ejecutar script.sql completo en pgAdmin o DBeaver.
[Sql-entrega2.sql](https://github.com/user-attachments/files/33991402/Sql-entrega2.sql)
create DATABASE Pre_entrega2

create table clientes (
id_cliente serial primary key ,
nombre_cliente varchar(200) not null,
mail  varchar(200) unique not null,
edad_cliente Decimal (10,2) check (edad_cliente > 18))

create table productos (
id_producto serial primary key,
nombre_producto varchar(200) not null,
precio DECIMAL(10,2) check (precio > 0))

create table ventas (
id_ventas serial primary key,
id_cliente INT NOT NULL REFERENCES clientes(id_cliente),
id_producto INT NOT NULL REFERENCES productos(id_producto),
cantidad Decimal(10,2) check (cantidad>0)),




BEGIN;

INSERT INTO clientes (nombre_cliente, mail, edad_cliente)
VALUES
    ('Juan', 'juan@gmail.com', 25),
    ('Maria', 'maria@gmail.com', 30),
    ('Pedro', 'pedro@gmail.com', 22),
    ('Lucia', 'lucia@gmail.com', 28),
    ('Maximo', 'maximo@gmail.com', 24);

INSERT INTO productos (nombre_producto, precio)
VALUES
    ('Ventilador', 150),
    ('Silla', 50),
    ('Escritorio', 200),
    ('Televisor', 300),
    ('Radio', 30);

INSERT INTO ventas (id_cliente, id_producto, cantidad)
VALUES
    (3, 2, 3),
    (4, 1, 1),
    (2, 5, 4),
    (3, 1, 1),
    (5, 2, 5);

COMMIT;

UPDATE productos
SET precio = 180
WHERE nombre_producto = 'Ventilador';




delete from ventas
where id_ventas=10;

select * from ventas

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
