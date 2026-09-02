-- Categoria
CREATE TABLE categoria (
    id_categoria NUMBER(3),
    nombre VARCHAR2(50) NOT NULL, --nombre de la categoria como gaming, computacion, conectividad
    descripcion VARCHAR2(100) NOT NULL, --El detalle de los productos que abarca
    CONSTRAINT pk_categoria PRIMARY KEY (id_categoria)
);

-- Los constraint son para definirles un nombre a las llaves para poder identificar mas facil algun error y que no lanze uno generico
-- Producto
CREATE TABLE producto (
    id_producto NUMBER(3),
    nombre VARCHAR2(100) NOT NULL,
    marca VARCHAR2(50) NOT NULL,
    precio NUMBER(10) NOT NULL,
    stock NUMBER(6) NOT NULL,
    id_categoria NUMBER(3),
    CONSTRAINT pk_producto PRIMARY KEY (id_producto),
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

/* El agrege el check para el codigo verificador del rut talvez podriamos usarlo para colocar
   una excepcion en con el RAISE si no esta en el rango del CHECK
*/
-- Cliente
CREATE TABLE cliente (
    id_cliente NUMBER(3),
    rut NUMBER(8) NOT NULL,
    digito_veri CHAR(1) NOT NULL,
    primer_nombre VARCHAR2(50) NOT NULL,
    segundo_nombre VARCHAR2(50),
    primer_apellido VARCHAR2(50) NOT NULL,
    segundo_apellido VARCHAR2(50),
    fecha_nacimiento DATE,
    email VARCHAR2(100),
    CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
    CONSTRAINT chk_digito_veri CHECK (UPPER(digito_veri) IN ('0','1','2','3','4','5','6','7','8','9','K'))
);

-- Venta
CREATE TABLE venta (
    id_venta NUMBER(3),
    fecha DATE NOT NULL,
    id_cliente NUMBER(3),
    CONSTRAINT pk_venta PRIMARY KEY (id_venta),
    CONSTRAINT fk_venta_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- Detalle Venta es la tabla intermedia de muchos a muchos
CREATE TABLE detalle_venta (
    id_detalle NUMBER(3),
    id_venta NUMBER(3),
    id_producto NUMBER(3),
    cantidad NUMBER(4) NOT NULL, -- Cantidad de productos que se llevara el cliente
    precio_unitario NUMBER(10) NOT NULL, -- precio representa el precio histórico real al que se vendió ese producto en esta transacción específica
    CONSTRAINT pk_detalle_venta PRIMARY KEY (id_detalle),
    CONSTRAINT fk_detalle_venta FOREIGN KEY (id_venta) REFERENCES venta(id_venta),
    CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- poblando la tabla categorias
INSERT INTO categoria VALUES (1, 'Gaming y Streaming', 'Equipos, accesorios y productos enfocados en videojuegos');
INSERT INTO categoria VALUES (2, 'Computación', 'Notebooks, PC de escritorio y accesorios');
INSERT INTO categoria VALUES (3, 'Componentes de PC', 'Placas madre, procesadores, GPU, RAM y almacenamiento');
INSERT INTO categoria VALUES (4, 'Conectividad y Redes', 'Routers, adaptadores y soluciones de red');
INSERT INTO categoria VALUES (5, 'Audio y Video', 'Monitores, audífonos, micrófonos y sonido');

INSERT INTO producto VALUES (1, '');

DROP TABLE categoria CASCADE CONSTRAINT;
DROP TABLE producto CASCADE CONSTRAINT;
DROP TABLE cliente CASCADE CONSTRAINT;
DROP TABLE venta CASCADE CONSTRAINT;
DROP TABLE detalle_venta CASCADE CONSTRAINT;
