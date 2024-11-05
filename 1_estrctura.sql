DROP DATABASE IF EXISTS membresias;
CREATE DATABASE membresias;
USE membresias;

CREATE TABLE membresias.empresas (
	id_empresa	VARCHAR(13) NOT NULL PRIMARY KEY,
    razon_social VARCHAR(50) NOT NULL,
    giro VARCHAR(30) NOT NULL,
    ciudad VARCHAR(30) NOT NULL,
    tipo_empresa ENUM('PYME', 'CORP') NOT NULL
);

CREATE TABLE membresias.estudios (
	id_estudio	INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_estudio VARCHAR(50) NOT NULL,
    tipo_ejercicio VARCHAR(25),
    precio_por_dia DECIMAL(10,2) DEFAULT 1000.00 NOT NULL,
    dirección VARCHAR(100)
);

CREATE TABLE membresias.usuarios (
	id_usuario	INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    apellido VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL,
    telefono VARCHAR(15),
    id_empresa VARCHAR(13) NOT NULL
);

ALTER TABLE usuarios ADD 
CONSTRAINT fk_id_empresa
FOREIGN KEY (id_empresa) 
REFERENCES empresas (id_empresa);

CREATE TABLE membresias.reservas (
	id_reserva	INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fecha DATE DEFAULT (CURRENT_DATE) NOT NULL,
    horario TIME NOT NULL,
    asistencia ENUM ('ASISTIO','NO ASISTIO') NOT NULL,
    id_usuario INT NOT NULL,
    id_estudio INT NOT NULL
);

ALTER TABLE membresias.reservas ADD 
CONSTRAINT fk_id_usuario
FOREIGN KEY (id_usuario) 
REFERENCES membresias.usuarios (id_usuario);

ALTER TABLE membresias.reservas ADD 
CONSTRAINT fk_id_estudio
FOREIGN KEY (id_estudio) 
REFERENCES membresias.estudios (id_estudio);

CREATE TABLE membresias.pagos (
	id_factura	VARCHAR(20) NOT NULL PRIMARY KEY,
    fecha_pago DATE DEFAULT (CURRENT_DATE) NOT NULL,
    monto DECIMAL(10,2) DEFAULT 1000.00 NOT NULL,
    id_empresa VARCHAR(13) NOT NULL
);

ALTER TABLE membresias.pagos ADD 
CONSTRAINT fk_id_empresa_pagos
FOREIGN KEY (id_empresa) 
REFERENCES membresias.empresas (id_empresa);

CREATE TABLE membresias.instructores (
	id_estudio	INT NOT NULL,
    nombre_inst VARCHAR(20) NOT NULL,
    apellido_inst VARCHAR(20) NOT NULL,
    turno_clase ENUM ('Matutino','Vespertino') NOT NULL, 
    antiguedad DATE NOT NULL, 
    ine VARCHAR(13) NOT NULL
);

ALTER TABLE membresias.instructores ADD 
CONSTRAINT fk_id_estudio_inst
FOREIGN KEY (id_estudio) 
REFERENCES membresias.estudios (id_estudio);
