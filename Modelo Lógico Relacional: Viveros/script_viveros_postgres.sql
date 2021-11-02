DROP SCHEMA IF EXISTS viveros CASCADE; 

CREATE SCHEMA viveros;
SET search_path TO viveros;

CREATE TABLE viveros.vivero (
    latitud FLOAT NOT NULL UNIQUE,
    longitud FLOAT NOT NULL UNIQUE,
    localidad VARCHAR(50),
    PRIMARY KEY (latitud, longitud)
);

CREATE TABLE viveros.zona (
    identificador INT NOT NULL UNIQUE,
    latitud_vivero FLOAT NOT NULL UNIQUE,
    longitud_vivero FLOAT NOT NULL UNIQUE,
    PRIMARY KEY (identificador, latitud_vivero, longitud_vivero),
    CONSTRAINT fk_latitud_vivero
        FOREIGN KEY(latitud_vivero)
        REFERENCES viveros.vivero(latitud)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_longitud_vivero
        FOREIGN KEY(longitud_vivero)
        REFERENCES viveros.vivero(longitud)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE viveros.empleado (
    dni INT NOT NULL,
    sueldo FLOAT NOT NULL,
    telefono INT NOT NULL,
    zona_identificador INT NOT NULL,
    zona_latitud_vivero FLOAT NOT NULL,
    zona_longitud_vivero FLOAT NOT NULL,
    PRIMARY KEY (dni),
    CONSTRAINT fk_zona_identificador
    FOREIGN KEY (zona_identificador)
    REFERENCES viveros.zona (identificador)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT fk_zona_latitud_vivero
    FOREIGN KEY (zona_latitud_vivero)
    REFERENCES viveros.zona (latitud_vivero)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT fk_zona_longitud_vivero
    FOREIGN KEY (zona_longitud_vivero)
    REFERENCES viveros.zona (longitud_vivero)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS viveros.producto (
  codigo INT NOT NULL UNIQUE,
  stock INT,
  precio FLOAT,
  PRIMARY KEY (codigo));


CREATE TABLE IF NOT EXISTS viveros.cliente_club (
  DNI INT NOT NULL UNIQUE,
  email VARCHAR(45),
  credito_mensual FLOAT,
  bonificacion FLOAT,
  PRIMARY KEY (DNI));


CREATE TABLE IF NOT EXISTS viveros.cliente_club_pedido_empleado (
  DNI_cliente_club INT NOT NULL UNIQUE,
  DNI_empleado INT NOT NULL UNIQUE,
  codigo_producto INT NOT NULL UNIQUE,
  fecha DATE NOT NULL UNIQUE,
  cantidad INT,
  PRIMARY KEY (DNI_cliente_club, DNI_empleado, codigo_producto, fecha),

  CONSTRAINT fk_DNI_cliente_club
    FOREIGN KEY (DNI_cliente_club)
    REFERENCES viveros.cliente_club (DNI)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_DNI_empleado
    FOREIGN KEY (DNI_empleado)
    REFERENCES viveros.empleado (DNI)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_codigo_producto
    FOREIGN KEY (codigo_producto)
    REFERENCES viveros.producto (codigo)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS viveros.producto_has_zona (
  producto_codigo INT NOT NULL,
  zona_identificador INT NOT NULL,
  zona_latitud_vivero FLOAT NOT NULL,
  zona_longitud_vivero FLOAT NOT NULL,
  PRIMARY KEY (producto_codigo, zona_identificador, zona_latitud_vivero, zona_longitud_vivero),
  CONSTRAINT fk_producto_codigo
    FOREIGN KEY (producto_codigo)
    REFERENCES viveros.producto (codigo)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_zona_identificador
    FOREIGN KEY (zona_identificador)
    REFERENCES viveros.zona (identificador)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_zona_latitud_vivero
    FOREIGN KEY (zona_latitud_vivero)
    REFERENCES viveros.zona (latitud_vivero)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_zona_longitud_vivero
    FOREIGN KEY (zona_longitud_vivero)
    REFERENCES viveros.zona (longitud_vivero)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

INSERT INTO viveros.vivero (latitud, longitud, localidad) values (28.5225, -16.337944 , 'San Cristóbal de La Laguna');
INSERT INTO viveros.vivero (latitud, longitud, localidad) values (28.3556667, -16.370583 , 'Candelaria');

INSERT INTO viveros.zona (identificador, latitud_vivero, longitud_vivero) values (1, 28.5225, -16.337944);
INSERT INTO viveros.zona (identificador, latitud_vivero, longitud_vivero) values (2, 28.3556667, -16.370583);

INSERT INTO viveros.empleado (dni, sueldo, telefono, zona_identificador, zona_latitud_vivero, zona_longitud_vivero) values (02203658, 1000, 614572983, 1, 28.5225, -16.337944);
INSERT INTO viveros.empleado (dni, sueldo, telefono, zona_identificador, zona_latitud_vivero, zona_longitud_vivero) values (09841512, 1000, 614572984, 1, 28.3556667, -16.370583);
INSERT INTO viveros.empleado (dni, sueldo, telefono, zona_identificador, zona_latitud_vivero, zona_longitud_vivero) values (89645151, 1000, 614572985, 1, 28.3556667, -16.370583);

INSERT INTO viveros.producto (codigo, stock, precio) values (0000, 20, 13.63);
INSERT INTO viveros.producto (codigo, stock, precio) values (0001, 10, 17.61);
INSERT INTO viveros.producto (codigo, stock, precio) values (0002, 50, 21.50);
INSERT INTO viveros.producto (codigo, stock, precio) values (0003, 22, 4.99);
INSERT INTO viveros.producto (codigo, stock, precio) values (0004, 17, 10.99);
INSERT INTO viveros.producto (codigo, stock, precio) values (0005, 3, 6.31);

INSERT INTO viveros.cliente_club (DNI, email, credito_mensual, bonificacion) values (89465132, 'alu95965847526@ull.edu.es', 34.65, 4.35);
INSERT INTO viveros.cliente_club (DNI, email, credito_mensual, bonificacion) values (89465133, 'alu95965847525@ull.edu.es', 35.45, 5.25);
INSERT INTO viveros.cliente_club (DNI, email, credito_mensual, bonificacion) values (89465134, 'alu95965847524@ull.edu.es', 36.35, 6.55);
INSERT INTO viveros.cliente_club (DNI, email, credito_mensual, bonificacion) values (89465135, 'alu95965847523@ull.edu.es', 37.25, 7.15);
INSERT INTO viveros.cliente_club (DNI, email, credito_mensual, bonificacion) values (89465136, 'alu95965847522@ull.edu.es', 39.15, 9.15);

INSERT INTO viveros.cliente_club_pedido_empleado (DNI_cliente_club, DNI_empleado, codigo_producto, fecha, cantidad) values (89465132, 89645151, 0004, '2021-06-21', 3);
INSERT INTO viveros.cliente_club_pedido_empleado (DNI_cliente_club, DNI_empleado, codigo_producto, fecha, cantidad) values (89465136, 09841512, 0000, '2021-03-10', 4);
INSERT INTO viveros.cliente_club_pedido_empleado (DNI_cliente_club, DNI_empleado, codigo_producto, fecha, cantidad) values (89465134, 02203658, 0001, '2020-11-03', 8);

INSERT INTO viveros.producto_has_zona (producto_codigo, zona_identificador, zona_latitud_vivero, zona_longitud_vivero) values (0003, 1, 28.5225, -16.337944);
INSERT INTO viveros.producto_has_zona (producto_codigo, zona_identificador, zona_latitud_vivero, zona_longitud_vivero) values (0004, 2, 28.3556667, -16.370583);
