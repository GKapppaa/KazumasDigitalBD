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
-- Drops TABLE (orden: hijas primero para no violar FK)
DROP TABLE detalle_envio CASCADE CONSTRAINTS;
DROP TABLE detalle_venta CASCADE CONSTRAINTS;
DROP TABLE venta CASCADE CONSTRAINTS;
DROP TABLE cliente CASCADE CONSTRAINTS;
DROP TABLE producto CASCADE CONSTRAINTS;
DROP TABLE categoria CASCADE CONSTRAINTS;
DROP TABLE ciudad CASCADE CONSTRAINTS;
DROP TABLE region CASCADE CONSTRAINTS;

-- Region
CREATE TABLE region (
    id_region INT GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(50) NOT NULL,
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
INSERT INTO region (nombre) VALUES ('Región Metropolitana');
INSERT INTO region (nombre) VALUES ('Valparaíso');
INSERT INTO region (nombre) VALUES ('Los Rios');
INSERT INTO region (nombre) VALUES ('Arica y Parinacota');


-- poblando la tabla ciudad
INSERT INTO ciudad (nombre, id_region) VALUES ('Santiago', 1);
INSERT INTO ciudad (nombre, id_region) VALUES ('Valparaíso', 2);
INSERT INTO ciudad (nombre, id_region) VALUES ('Valdivia', 3);
INSERT INTO ciudad (nombre, id_region) VALUES ('Arica', 4);

-- poblando la tabla categorias
INSERT INTO categoria (nombre, descripcion) VALUES ('Gaming y Streaming', 'Equipos, accesorios y productos enfocados en videojuegos');
INSERT INTO categoria (nombre, descripcion) VALUES ('Computación', 'Notebooks, PC de escritorio y accesorios');
INSERT INTO categoria (nombre, descripcion) VALUES ('Componentes de PC', 'Placas madre, procesadores, GPU, RAM y almacenamiento');
INSERT INTO categoria (nombre, descripcion) VALUES ('Conectividad y Redes', 'Routers, adaptadores y soluciones de red');
INSERT INTO categoria (nombre, descripcion) VALUES ('Audio y Video', 'Monitores, audífonos, micrófonos y sonido');

-- poblando la tabla de productos
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Monitor Gamer 27"', 'Asus', 469990, 50, 1);
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Audifonos Gamer Cloud', 'Hyperx', 89990, 20, 5);
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Notebook Slim 15', 'Lenovo', 450000, 30, 2);
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Placa Madre B650', 'Asus', 180000, 40, 3);
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Router Wi-Fi 6', 'TP-Link', 65000, 50, 4);
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Teclado Mecánico RGB', 'Redragon', 45000, 25, 1);
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Procesador Ryzen 7', 'AMD', 290000, 15, 3);
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Memoria RAM 16GB', 'Kingston', 55000, 60, 3);
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Disco SSD 1TB', 'Crucial', 75000, 40, 3);
INSERT INTO producto (nombre, marca, precio, stock, id_categoria) VALUES ('Micrófono Condensador', 'Razer', 110000, 18, 5);

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
VALUES (19632578, '5', 'Setsuna', 'Freendom', 'Seiei', '', TO_DATE('20/08/2000', 'DD/MM/YYYY'), 'setsuna@gmail.com', 4);
INSERT INTO cliente (rut, digito_veri, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, email, id_ciudad)
VALUES (19456357, '6', 'Luis', 'Andres', 'Perez', 'Gonzalez', TO_DATE('10/05/1990', 'DD/MM/YYYY'), 'luis.perez@gmail.com', 1);
INSERT INTO cliente (rut, digito_veri, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, email, id_ciudad)
VALUES (20258852, '7', 'Lorena', 'Alejandra', 'Fuentes', 'Rojas', TO_DATE('25/11/1992', 'DD/MM/YYYY'), 'lorena.fuentes@gmail.com', 2);
INSERT INTO cliente (rut, digito_veri, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, email, id_ciudad)
VALUES (19159357, '8', 'Luisa', 'Freendom', 'Soto', 'Morales', TO_DATE('03/02/1988', 'DD/MM/YYYY'), 'luisa.soto@gmail.com', 3);
INSERT INTO cliente (rut, digito_veri, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, email, id_ciudad)
VALUES (19654456, '9', 'Luis', 'Ignacio', 'Castro', 'Vidal', TO_DATE('17/07/1995', 'DD/MM/YYYY'), 'luis.castro@gmail.com', 4);
INSERT INTO cliente (rut, digito_veri, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, email, id_ciudad)
VALUES (19951325, 'K', 'Lorena', 'Beatriz', 'Munoz', 'Silva', TO_DATE('29/09/1991', 'DD/MM/YYYY'), 'lorena.munoz@gmail.com', 1);

-- poblando la tabla de ventas
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('01/01/2024', 'DD/MM/YYYY'), 1);
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('01/02/2024', 'DD/MM/YYYY'), 2);
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('01/03/2024', 'DD/MM/YYYY'), 3);
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('01/04/2024', 'DD/MM/YYYY'), 4);
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('01/05/2024', 'DD/MM/YYYY'), 5);
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('01/06/2024', 'DD/MM/YYYY'), 6);
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('01/07/2024', 'DD/MM/YYYY'), 7);
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('01/08/2024', 'DD/MM/YYYY'), 8);
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('01/09/2024', 'DD/MM/YYYY'), 9);
INSERT INTO venta (fecha, id_cliente) VALUES (TO_DATE('01/10/2024', 'DD/MM/YYYY'), 10);

-- poblando la tabla detalle_venta
-- (id_venta, id_producto, cantidad, precio_unitario)
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (1, 1, 1, 469990);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (2, 2, 2, 89990);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (3, 3, 1, 450000);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (4, 4, 1, 180000);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (5, 5, 2, 65000);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (6, 6, 1, 45000);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (7, 7, 1, 290000);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (8, 8, 2, 55000);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (9, 9, 1, 75000);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (10, 10, 1, 110000);

INSERT INTO detalle_envio(id_venta, id_producto, id_ciudad) VALUES (1, 1, 1);
INSERT INTO detalle_envio(id_venta, id_producto, id_ciudad) VALUES (2, 2, 2);
INSERT INTO detalle_envio(id_venta, id_producto, id_ciudad) VALUES (3, 3, 3);
INSERT INTO detalle_envio(id_venta, id_producto, id_ciudad) VALUES (4, 4, 4);
INSERT INTO detalle_envio(id_venta, id_producto, id_ciudad) VALUES (5, 5, 1);
INSERT INTO detalle_envio(id_venta, id_producto, id_ciudad) VALUES (6, 6, 2);
INSERT INTO detalle_envio(id_venta, id_producto, id_ciudad) VALUES (7, 7, 3);
INSERT INTO detalle_envio(id_venta, id_producto, id_ciudad) VALUES (8, 8, 4);
INSERT INTO detalle_envio(id_venta, id_producto, id_ciudad) VALUES (9, 9, 1);
INSERT INTO detalle_envio(id_venta, id_producto, id_ciudad) VALUES (10, 10, 2);



--COMMIT;

--ROLLBACK;


SET SERVEROUTPUT ON;
-- Consultas con JOIN
SELECT *
FROM cliente c
JOIN venta v ON c.id_cliente = v.id_cliente
JOIN detalle_venta d ON v.id_venta = d.id_venta
JOIN producto p ON d.id_producto = p.id_producto
ORDER BY c.id_cliente ASC;

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
    TYPE p_categorias IS VARRAY (5) OF VARCHAR(50);
    v_categorias p_categorias := p_categorias('categoria1', 'categoria2', 'categoria3', 'categoria4', 'categoria5');
BEGIN
    FOR i IN 1..v_categorias.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(v_categorias(i));
    END LOOP;
END;

-- Cursor explicito con filtro para el cliente con id 1
DECLARE
    CURSOR c_clientes IS
        SELECT id_cliente, primer_nombre || ' ' || primer_apellido AS nombre_completo
        FROM cliente c
        WHERE c.id_cliente = 1;
    v_info_cliente c_clientes%ROWTYPE;
BEGIN
    OPEN c_clientes;
    LOOP
        FETCH c_clientes INTO v_info_cliente;
        EXIT WHEN c_clientes%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID Cliente:' || ' ' || v_info_cliente.id_cliente || ' ' || v_info_cliente.nombre_completo);
    END LOOP;
    CLOSE c_clientes;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos para el cliente especificado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END;

-- Cursor con parametros

DECLARE
    CURSOR c_detalle (p_id NUMBER) IS
        SELECT v.id_venta, v.id_cliente
        FROM detalle_venta v
        WHERE v.id_cliente = p_id;
    v_info_detalle c_detalle%ROWTYPE;

BEGIN
    FOR fila IN c_detalle(1) LOOP
        DBMS_OUTPUT.PUT_LINE('ID Venta: ' || fila.id_venta || ' ID Cliente: ' || fila.id_cliente);
    END LOOP;
END;


--Cursor con parametros
DECLARE
    CURSOR c_detalle (p_id NUMBER) IS
        SELECT v.id_venta, dv.cantidad, dv.precio_unitario
        FROM venta v
        JOIN detalle_venta dv
        ON v.id_venta = dv.id_venta
        WHERE v.id_cliente = p_id;
    v_info_detalle c_detalle%ROWTYPE;

BEGIN
    FOR fila in c_detalle(1) LOOP
              DBMS_OUTPUT.PUT_LINE(
            'Venta: ' || fila.id_venta ||
            ' | Cantidad: ' || fila.cantidad ||
            ' | Precio: ' || fila.precio_unitario
        );
    END LOOP ;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM); -- Atrapamos cualquier tipo de error que se nos pasara antes
END;

/* lo qie trato de hacer aca es un reporte de los clientes
para saber si un cliente compro un producto o  no y saber r cuanto gasto por la cantidad que lleva
entonces la idea es crear un cursor sin parametros para obtener la informacion del cliente y un cursosr con parametros para
recibir el id del cliente y asi filtar la venta con su id y hacerle join con las tablas detalle y productos */

SET SERVEROUTPUT ON;
-- Hernan
DECLARE 
    -- Se declara la excepcion que se disparara si el cliente no a realizado compras
    ex_sin_compras EXCEPTION;
    
    -- Record r_cliente
    TYPE r_cliente IS RECORD (
        id_cli      cliente.id_cliente%TYPE, -- trae el tipo de dato exacto de la columna id_cliente de la tabla cliente
        rut_cliente VARCHAR2(20),
        nombre      VARCHAR2(100), -- aca no se colocael %TYPE ya que son variables combinas con otras columnas
        cant_productos NUMBER(8), -- cantidad de productos comprados 
        monto_total NUMBER(8)   -- dinero gastado por el cliente
    );
    
    v_info_cliente r_cliente; -- aca se guarda el record en la variable v_info_cliente para usarla despues
    
    -- Esta es la colecion para guardar hasta 5 nombres de los productos comprados por el cliente
    TYPE lista_prodcutos IS VARRAY(5) OF VARCHAR2(100);
    v_lista_productos lista_prodcutos := lista_prodcutos(); -- aca se declara la lista vacia y se gurada en una variable para usar despues
    
    -- Cursor simple sin parametros para obtener la informacion de clientes
    CURSOR c_clientes IS
        SELECT id_cliente, 
        rut|| '-' || digito_veri AS rut_cliente,
        primer_nombre || ' ' || primer_apellido AS nombre
        FROM cliente;
    
    -- Cursor con paramentros para obtener la informacion de los productos al introducir el id cliente
    CURSOR c_detalle_compras (p_id_cliente NUMBER) IS
        SELECT p.nombre AS nombre_producto,
        dv.cantidad,
        dv.precio_unitario,
        (dv.cantidad * dv.precio_unitario) AS subtotal
        FROM venta v
        JOIN detalle_venta dv ON v.id_venta = dv.id_venta
        JOIN producto p ON dv.id_producto = p.id_producto
        WHERE v.id_cliente = p_id_cliente; -- aqui se filtra la informacion por del id de cliente sea igual al del id que se encuentra registrado en ventas 
    
    -- Estas variables son para el segundo cursor en el segundo loop
    v_nombre_producto producto.nombre%TYPE;
    v_cantidad detalle_venta.cantidad%TYPE;
    v_precio_uni detalle_venta.precio_unitario%TYPE;
    v_subtotal NUMBER(8);
    v_contador NUMBER(8);
    
BEGIN
    OPEN c_clientes;
    LOOP
        FETCH c_clientes INTO v_info_cliente.id_cli,
                              v_info_cliente.rut_cliente, 
                              v_info_cliente.nombre;
                              
        EXIT WHEN c_clientes%NOTFOUND;
        -- se inicializan las variables 
        v_info_cliente.cant_productos := 0;
        v_info_cliente.monto_total    := 0;
        
        -- para en contador de la lista
        v_contador := 0;
        -- Dejamos la lista de productos vacía para los productos
        v_lista_productos := lista_prodcutos('','','','',''); -- se inicializa la lista con 5 posiciones vacias para los nombres de los productos
        
        OPEN c_detalle_compras(v_info_cliente.id_cli);
        LOOP
            FETCH c_detalle_compras INTO v_nombre_producto,
                                         v_cantidad,
                                         v_precio_uni,
                                         v_subtotal;
            EXIT WHEN c_detalle_compras%NOTFOUND;
            
            v_info_cliente.cant_productos := v_info_cliente.cant_productos + v_cantidad;
            v_info_cliente.monto_total := v_info_cliente.monto_total + v_subtotal;
            
            IF v_contador < 5 THEN
                v_contador := v_contador + 1; -- Avanzas a la siguiente posicion (1, 2, 3 susesivamente)
                v_lista_productos(v_contador) := v_nombre_producto; -- Se guarda el nombre en la en la posicion actual 
            END IF;
            
        END LOOP;
        CLOSE c_detalle_compras;
            
        -- si tiene compras imprime de forma normal
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_info_cliente.id_cli || ' | RUT: ' || v_info_cliente.rut_cliente || ' | Cliente: ' || v_info_cliente.nombre);
        DBMS_OUTPUT.PUT_LINE('Cantidad de productos comprados : ' || v_info_cliente.cant_productos);
        DBMS_OUTPUT.PUT_LINE('Precio unitario de un producto : ' || v_precio_uni);
        DBMS_OUTPUT.PUT_LINE('Monto total  : $' || TO_CHAR(v_info_cliente.monto_total, '999G999G999'));
            
    END LOOP;
    CLOSE c_clientes;
    
        

END;
/



-- Cursor de Daniel
DECLARE
    -- Exception personalizado
    cantidad_invalida EXCEPTION;
    v_cantidad NUMBER := -1;
    CURSOR c_clientes IS
        SELECT c.id_cliente,
        c.id_cliente || '-' || c.digito_veri AS RUN,
            c.primer_nombre || ' ' || c.primer_apellido AS nombre
        FROM cliente c
        WHERE ROWNUM <= 5;

    CURSOR c_ventas_cliente (p_id_cliente IN cliente.id_cliente%TYPE)IS
        SELECT v.id_venta,
            dv.cantidad, dv.precio_unitario
        FROM venta v
        JOIN detalle_venta dv ON v.id_venta = dv.id_venta
        WHERE id_cliente = p_id_cliente;
BEGIN
    IF v_cantidad < 0 THEN
        RAISE cantidad_invalida;
    END IF;

    FOR r_cliente IN c_clientes LOOP
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
        DBMS_OUTPUT.PUT_LINE('Cliente: ' || r_cliente.nombre);
        DBMS_OUTPUT.PUT_LINE('---------------------------------');

        FOR r_ventas in c_ventas_cliente(r_cliente.id_cliente) LOOP
            DBMS_OUTPUT.PUT_LINE('ID VENTA:'||r_ventas.id_venta || ' ' ||  'Cantidad: '
            || r_ventas.cantidad ||' '||'Precio /U: ' || r_ventas.precio_unitario);
        END LOOP;
    END LOOP;
EXCEPTION
    WHEN cantidad_invalida THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Cantidad invalida!');
END;
