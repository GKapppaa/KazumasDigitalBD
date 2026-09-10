-- Entraga del informe 9/9/26 en AVA el jueves 10 primera ronda de presentaciones
/* Presentacion:
    Problematica:
        El mayor dilema que presenta el negocio es la lenta gestión de usuarios que contiene, al hacer busqudas especificas
            a cierto cliente o usuario, suele tener una alta demora en las ejecuciones de consultas.
    Solucion general
        Nuestra solución es implementar el sistema de KazumaDigital el cual garantiza una velocidad totalmente necesario
            para la empresa, con respuestas rapidas y eficientes. Todo esto es con el proposito de satisfacer al cliente.

    Funciones y requisitos.
        Principal funcion será la agilizacion en proceso de consultas a la base de datos de nuestro cliente
    Componentes

    Justificacion

    Con codigo
    Record
    Varray
    Cursor simple
    Cursor anidado
    Excepcion oracle
    Excepcion personalizada

    Sin condigo
    Funcion
    Procedimiento
    Package
    Trigger

*/

-- Funciones

-- Procedimientos INSERT UPDATE DELETE
--
-- Drops TABLE
/*
DROP TABLE detalle_venta CASCADE CONSTRAINT;
DROP TABLE venta CASCADE CONSTRAINT;
DROP TABLE cliente CASCADE CONSTRAINT;
DROP TABLE producto CASCADE CONSTRAINT;
DROP TABLE categoria CASCADE CONSTRAINT;
DROP TABLE ciudad CASCADE CONSTRAINT;
DROP TABLE region CASCADE CONSTRAINT;
*/

-- Region
CREATE TABLE region (
    id_region INT GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(50) NOT NULL,
    id_pais INT NOT NULL,
    CONSTRAINT pk_region PRIMARY KEY (id_region)
);

-- Ciudad
CREATE TABLE ciudad (
    id_ciudad INT GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(50) NOT NULL,
    id_region INT NOT NULL,
    CONSTRAINT pk_ciudad PRIMARY KEY (id_ciudad),
    CONSTRAINT fk_region_id FOREIGN KEY (id_region) REFERENCES region(id_region)
);

-- Categoria
CREATE TABLE categoria (
    id_categoria INT GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(50) NOT NULL,
    descripcion VARCHAR2(100) NOT NULL, --El detalle de los productos que abarca
    CONSTRAINT pk_categoria PRIMARY KEY (id_categoria)
);

-- Los constraint son para definirles un nombre a las llaves para poder identificar mas facil algun error y que no lanze uno generico
-- Producto
CREATE TABLE producto (
    id_producto INT GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(100) NOT NULL,
    marca VARCHAR2(50) NOT NULL,
    precio NUMBER(10) NOT NULL,
    stock NUMBER(6) NOT NULL,
    id_categoria INT,
    CONSTRAINT pk_producto PRIMARY KEY (id_producto),
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

/* Le agrege el check para el codigo verificador del rut talvez podriamos usarlo para colocar
   una excepcion en con el RAISE si no esta en el rango del CHECK
*/
-- Cliente
CREATE TABLE cliente (
    id_cliente INT GENERATED ALWAYS AS IDENTITY,
    rut NUMBER(8) NOT NULL,
    digito_veri CHAR(1) NOT NULL,
    primer_nombre VARCHAR2(50) NOT NULL,
    segundo_nombre VARCHAR2(50),
    primer_apellido VARCHAR2(50) NOT NULL,
    segundo_apellido VARCHAR2(50),
    fecha_nacimiento DATE,
    email VARCHAR2(100),
    id_ciudad INT,
    CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
    CONSTRAINT chk_digito_veri CHECK (UPPER(digito_veri) IN ('0','1','2','3','4','5','6','7','8','9','K')),
    CONSTRAINT fk_id_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad)
);

-- Venta
CREATE TABLE venta (
    id_venta INT GENERATED ALWAYS AS IDENTITY,
    fecha DATE NOT NULL,
    id_cliente INT,
    CONSTRAINT pk_venta PRIMARY KEY (id_venta),
    CONSTRAINT fk_venta_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- Detalle Venta es la tabla intermedia de muchos a muchos
CREATE TABLE detalle_venta (
    id_detalle INT GENERATED ALWAYS AS IDENTITY,
    id_venta INT,
    id_producto INT,
    cantidad NUMBER(4) NOT NULL, -- Cantidad de productos que se llevara el cliente
    precio_unitario NUMBER(10) NOT NULL, -- precio representa el precio histórico real al que se vendió ese producto en esta transacción específica
    CONSTRAINT pk_detalle_venta PRIMARY KEY (id_detalle),
    CONSTRAINT fk_detalle_venta FOREIGN KEY (id_venta) REFERENCES venta(id_venta),
    CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE detalle_envio(
    id_detalle_envio INT GENERATED ALWAYS AS IDENTITY,
    id_venta INT,
    id_producto INT,
    id_ciudad INT,
    CONSTRAINT pk_detalle_envio PRIMARY KEY (id_detalle_envio),
    CONSTRAINT fk_detalle_envio_venta FOREIGN KEY (id_venta) REFERENCES venta(id_venta),
    CONSTRAINT fk_detalle_envio_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    CONSTRAINT fk_detalle_envio_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad)
);


-- Poblado de datos

-- poblando la tabla region
INSERT INTO region (nombre, id_ciudad) VALUES ('Región Metropolitana', 1);
INSERT INTO region (nombre, id_ciudad) VALUES ('Valparaíso', 2);

-- poblando la tabla ciudad
INSERT INTO ciudad (nombre, id_region) VALUES ('Santiago', 1);
INSERT INTO ciudad (nombre, id_region) VALUES ('Valparaíso', 2);
INSERT INTO ciudad (nombre, id_region) VALUES ('Valdivia', 3);
INSERT INTO ciudad (nombre, id_region) VALUES ('Concepción', 4);
INSERT INTO ciudad (nombre, id_region) VALUES ('La Serena', 5);

-- poblando la tabla categorias
INSERT INTO categoria (nombre, descripcion) VALUES ('Gaming y Streaming', 'Equipos, accesorios y productos enfocados en videojuegos');
INSERT INTO categoria (nombre, descripcion) VALUES ('Computación', 'Notebooks, PC de escritorio y accesorios');
INSERT INTO categoria (nombre, descripcion) VALUES ('Componentes de PC', 'Placas madre, procesadores, GPU, RAM y almacenamiento');
INSERT INTO categoria (nombre, descripcion) VALUES ('Conectividad y Redes', 'Routers, adaptadores y soluciones de red');
INSERT INTO categoria (nombre, descripcion) VALUES ('Audio y Video', 'Monitores, audífonos, micrófonos y sonido');

-- poblando la tabla de productos
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Monitor gamer', 'Asus', 469990, 50, 1);
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Audifonos Gamer', 'Hyperx', 89990, 20, 5);
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Producto 3', 'Marca 3', 300, 30, 2);
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Placa Madre B650', 'Asus', 400, 40, 3);
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Producto 5', 'Marca 5', 500, 50, 4);
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Monitor gamer', 'Asus', 469990, 10, 1);
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Producto 2', 'Marca 2', 200, 20, 2);
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Producto 3', 'Marca 3', 300, 30, 2);
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Placa Madre B650', 'Asus', 400, 40, 3);
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Producto 5', 'Marca 5', 500, 50, 4);

-- poblando la tabla de clientes
-- rut sin dígito verificador (los primeros 8 dígitos) y digito_veri aparte
INSERT INTO cliente (rut, digito_veri, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, email, id_ciudad)
VALUES (19654896, '1', 'Kazuma', 'Leo','Ryuki','Bidan',TO_DATE('02/07/1997', 'DD/MM/YYYY'),'celestialBeing@gmail.com', 1);
INSERT INTO cliente (rut, digito_veri, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, email, id_ciudad)
VALUES (20578963, '2', 'Leonardo', 'Wilhelm', 'DiCaprio', '', TO_DATE('11/11/1974', 'DD/MM/YYYY'), 'leonardo@dicaprio.com', 2);
INSERT INTO cliente (rut, digito_veri, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, email, id_ciudad)
VALUES (20589632, '3', 'Hernan', 'Ignacio','Garcia','Sanchez',TO_DATE('15/08/1999', 'DD/MM/YYYY'), 'hernangarcia@gmail.com', 3);
INSERT INTO cliente (rut, digito_veri, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, email, id_ciudad)
VALUES (20159357, '4', 'Daniel', '', 'Pinto', '', TO_DATE('20/08/2000', 'DD/MM/YYYY'), 'danielpinto@gmail.com', 4);
INSERT INTO cliente (rut, digito_veri, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, email, id_ciudad)
VALUES (19632578, '5', 'Setsuna', 'Freendom', 'Seiei', '', TO_DATE('20/08/2000', 'DD/MM/YYYY'), 'setsuna@gmail.com', 5);
INSERT INTO cliente (rut, digito_veri, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, email, id_ciudad)
VALUES (19456357, '6', 'Luis', '123456789');
INSERT INTO cliente (rut, digito_veri, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, email, id_ciudad)
VALUES (20258852, '7', 'Lorena', '987654321');
INSERT INTO cliente (rut, digito_veri, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, email, id_ciudad)
VALUES (19159357, '8', 'Luisa', 'Freendom', '123456789');
INSERT INTO cliente (rut, digito_veri, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, email, id_ciudad)
VALUES (19654456, '9', 'Luis', '123456789');
INSERT INTO cliente (rut, digito_veri, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, email, id_ciudad)
VALUES (19951325, 'K', 'Lorena', '123456789');

-- poblando la tabla de ventas
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('2024-01-01', 'YYYY-MM-DD'), 1);
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('2024-01-02', 'YYYY-MM-DD'), 2);
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('2024-01-03', 'YYYY-MM-DD'), 3);
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('2024-01-04', 'YYYY-MM-DD'), 4);
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('2024-01-05', 'YYYY-MM-DD'), 5);
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('2024-01-01', 'YYYY-MM-DD'), 6);
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('2024-01-02', 'YYYY-MM-DD'), 7);
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('2024-01-03', 'YYYY-MM-DD'), 8);
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('2024-01-04', 'YYYY-MM-DD'), 9);
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('2024-01-05', 'YYYY-MM-DD'), 10);

-- poblando la tabla detalle_venta
-- (id_venta, id_producto, cantidad, precio_unitario)
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (1, 1, 1, 469990);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (2, 2, 2, 89990);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (3, 3, 3, 300);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (4, 4, 4, 400);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (5, 5, 5, 500);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (6, 6, 6, 469990);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (7, 7, 7, 200);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (8, 8, 8, 300);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (9, 9, 9, 400);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (10, 10, 10, 500);

--COMMIT;

--ROLLBACK;


-- Consultas con JOIN
SELECT *
FROM cliente c
JOIN venta v ON c.id_cliente = v.id_cliente
JOIN detalle_venta dv ON v.id_venta = dv.id_venta
JOIN producto p ON dv.id_producto = p.id_producto
ORDER BY id_cliente ASC;

-- Subconsulta
SELECT *
FROM cliente c
JOIN venta v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IN (
    SELECT id_venta
    FROM detalle_venta
    WHERE id_producto = 1
);

-- Varray
DECLARE
    TYPE p_categorias IS VARRAY (5)
    OF categoria.nombre_categoria%TYPE;



BEGIN

END;

-- Sentencias PL/SQL de Hernan
SET SERVEROUTPUT ON;

/* lo qie trato de hacer aca es un reporte de los clientes
para saber si un cliente compro un producto o  no y saber r cuanto gasto por la cantidad que lleva
entonces la idea es crear un cursor sin parametros para obtener la informacion del cliente y un cursosr con parametros para
recibir el id del cliente y asi filtar la venta con su id y hacerle join con las tablas detalle y productos */

DECLARE

 -- Record r_cliente
    TYPE r_cliente IS RECORD (
        id_cli      cliente.id_cliente%TYPE,
        nombre      VARCHAR2(100),
        monto_total NUMBER(8)
    );

v_info_cliente r_cliente; -- aca se guarda el record en la variable v_info_cliente para usarla despues

-- Obtener informacion clientes
CURSOR c_clientes IS
        SELECT id_cliente, primer_nombre || ' ' || primer_apellido
        FROM cliente;

-- Cursor con parametros es para traer la info de productos y cantidad por el precio
    CURSOR c_detalle_compras (p_id_cliente NUMBER) IS
        SELECT p.nombre, (dv.cantidad * dv.precio_unitario)
        FROM venta v
        JOIN detalle_venta dv ON v.id_venta = dv.id_venta
        JOIN producto p ON dv.id_producto = p.id_producto
        WHERE v.id_cliente = p_id_cliente;

BEGIN

END;
