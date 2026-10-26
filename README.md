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
