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
    DNI VARCHAR(9) NOT NULL,
    sueldo FLOAT NOT NULL,
    telefono INT NOT NULL,
    zona_identificador INT NOT NULL,
    zona_latitud_vivero FLOAT NOT NULL,
    zona_longitud_vivero FLOAT NOT NULL,
    PRIMARY KEY (DNI),
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
  PRIMARY KEY (codigo)
);


CREATE TABLE IF NOT EXISTS viveros.cliente_club (
  DNI VARCHAR(9) NOT NULL UNIQUE,
  credito_mensual FLOAT,
  bonificacion FLOAT,
  nombre VARCHAR(20),
  apellido1 VARCHAR(25),
  apellido2 VARCHAR(25),
  email VARCHAR(45),
  PRIMARY KEY (DNI));


CREATE TABLE IF NOT EXISTS viveros.cliente_club_pedido_empleado (
  DNI_cliente_club VARCHAR(9) NOT NULL UNIQUE,
  DNI_empleado VARCHAR(9) NOT NULL UNIQUE,
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

CREATE OR REPLACE FUNCTION crear_email()
  RETURNS trigger AS $email$
DECLARE
    correo VARCHAR(45);
BEGIN
    correo := CONCAT (NEW.DNI, '@', TG_ARGV[0]);
    IF NEW.nombre IS NOT NULL THEN
        IF NEW.apellido1 IS NOT NULL THEN
            correo := CONCAT (NEW.nombre, NEW.apellido1, '@', TG_ARGV[0]);
        ELSE
            IF NEW.apellido2 IS NOT NULL THEN
                correo := CONCAT (NEW.nombre, NEW.apellido2, '@', TG_ARGV[0]);
            ELSE
                RAISE NOTICE 'creado correo por defecto';
            END IF;
        END IF;
    ELSE 
        IF NEW.apellido1 IS NOT NULL THEN
            IF NEW.apellido2 IS NOT NULL THEN
                correo := CONCAT (NEW.apellido1, NEW.apellido2, '@', TG_ARGV[0]);
            ELSE
                RAISE NOTICE 'creado correo por defecto';
            END IF;
        ELSE
            RAISE NOTICE 'creado correo por defecto';
        END IF;
    END IF;
    NEW.email = correo;
    RETURN NEW;
END;
$email$ LANGUAGE 'plpgsql';

CREATE TRIGGER trigger_crear_email_before_insert
  BEFORE INSERT
  ON cliente_club
  FOR EACH ROW
  EXECUTE PROCEDURE crear_email('ull.edu.es');

INSERT INTO viveros.vivero (latitud, longitud, localidad) values (28.5225, -16.337944 , 'San Cristóbal de La Laguna');
INSERT INTO viveros.vivero (latitud, longitud, localidad) values (28.3556667, -16.370583 , 'Candelaria');

INSERT INTO viveros.zona (identificador, latitud_vivero, longitud_vivero) values (1, 28.5225, -16.337944);
INSERT INTO viveros.zona (identificador, latitud_vivero, longitud_vivero) values (2, 28.3556667, -16.370583);

INSERT INTO viveros.empleado (DNI, sueldo, telefono, zona_identificador, zona_latitud_vivero, zona_longitud_vivero) values ('02203658A', 1000, 614572983, 1, 28.5225, -16.337944);
INSERT INTO viveros.empleado (DNI, sueldo, telefono, zona_identificador, zona_latitud_vivero, zona_longitud_vivero) values ('09841512B', 1000, 614572984, 1, 28.3556667, -16.370583);
INSERT INTO viveros.empleado (DNI, sueldo, telefono, zona_identificador, zona_latitud_vivero, zona_longitud_vivero) values ('89645151C', 1000, 614572985, 1, 28.3556667, -16.370583);

INSERT INTO viveros.producto (codigo, stock, precio) values (0000, 20, 13.63);
INSERT INTO viveros.producto (codigo, stock, precio) values (0001, 10, 17.61);
INSERT INTO viveros.producto (codigo, stock, precio) values (0002, 50, 21.50);
INSERT INTO viveros.producto (codigo, stock, precio) values (0003, 22, 4.99);
INSERT INTO viveros.producto (codigo, stock, precio) values (0004, 17, 10.99);
INSERT INTO viveros.producto (codigo, stock, precio) values (0005, 3, 6.31);

INSERT INTO viveros.cliente_club (DNI, credito_mensual, bonificacion, nombre, apellido1, apellido2, email) values ('89465132Z', 34.65, 4.35, 'Jorge', 'Ronco', 'Moratilla', NULL);
INSERT INTO viveros.cliente_club (DNI, credito_mensual, bonificacion, nombre, apellido1, email) values ('89465133Y', 35.45, 5.25, 'Irene', 'Hernandez', NULL);
INSERT INTO viveros.cliente_club (DNI, credito_mensual, bonificacion, apellido1, apellido2, email) values ('89465134X', 36.35, 6.55, 'Sanz', 'Herranz', NULL);
INSERT INTO viveros.cliente_club (DNI, credito_mensual, bonificacion, email) values ('89465135W', 37.25, 7.15, NULL);
INSERT INTO viveros.cliente_club (DNI, credito_mensual, bonificacion, nombre, apellido2, email) values ('89465136V', 39.15, 9.15, 'Cristina', 'Batista', NULL);

INSERT INTO viveros.cliente_club_pedido_empleado (DNI_cliente_club, DNI_empleado, codigo_producto, fecha, cantidad) values ('89465132Z', '89645151C', 0004, '2021-06-21', 3);
INSERT INTO viveros.cliente_club_pedido_empleado (DNI_cliente_club, DNI_empleado, codigo_producto, fecha, cantidad) values ('89465136V', '09841512B', 0000, '2021-03-10', 4);
INSERT INTO viveros.cliente_club_pedido_empleado (DNI_cliente_club, DNI_empleado, codigo_producto, fecha, cantidad) values ('89465134X', '02203658A', 0001, '2020-11-03', 8);

INSERT INTO viveros.producto_has_zona (producto_codigo, zona_identificador, zona_latitud_vivero, zona_longitud_vivero) values (0003, 1, 28.5225, -16.337944);
INSERT INTO viveros.producto_has_zona (producto_codigo, zona_identificador, zona_latitud_vivero, zona_longitud_vivero) values (0004, 2, 28.3556667, -16.370583);
