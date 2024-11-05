USE membresias;

-- SECCIÓN DE VISTAS --
DROP VIEW IF EXISTS vw_pagos_mensuales;
CREATE VIEW vw_pagos_mensuales
AS SELECT
YEAR (fecha_pago) AS ANIO
,MONTH (fecha_pago) AS MES
,SUM(monto) AS TOTAL
FROM pagos
WHERE YEAR (fecha_pago) = 2024
GROUP BY MONTH(fecha_pago) , YEAR(fecha_pago)
ORDER BY MES ASC ;

 SELECT  *
 FROM vw_pagos_mensuales;

DROP VIEW IF EXISTS vw_clases_asistidas;
CREATE VIEW vw_clases_asistidas
AS 
SELECT
    final.estudios AS ESTUDIOS,
    COUNT(final.reservas) AS RESERVAS_ASISTIDAS,
    SUM(final.precio_por_dia) AS PAGOS
FROM (
    SELECT 
        e.nombre_estudio AS estudios,
        r.id_reserva AS reservas,
        e.precio_por_dia
    FROM membresias.estudios AS e
    JOIN membresias.reservas AS r 
    ON e.id_estudio = r.id_estudio
    WHERE r.asistencia = 'ASISTIO'  
) AS final
GROUP BY final.estudios;

 SELECT  *
 FROM vw_clases_asistidas;

-- SECCIÓN DE FUNCIONES --
DROP FUNCTION IF EXISTS fn_nombre_cliente; 
DELIMITER //
CREATE FUNCTION membresias.fn_nombre_cliente (id INT) RETURNS VARCHAR(30)
READS SQL DATA
BEGIN
    DECLARE nombre_cliente VARCHAR(30);

    SELECT nombre INTO nombre_cliente
    FROM membresias.usuarios
    WHERE id_usuario = id;

    RETURN nombre_cliente;
END//
DELIMITER ;

SELECT fn_nombre_cliente(2)
FROM dual; 

DROP FUNCTION IF EXISTS fn_ganacia_estudio;
DELIMITER //
CREATE FUNCTION membresias.fn_ganacia_estudio (id INT) RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE ganancia_total INT;

    SELECT SUM(e.precio_por_dia) INTO ganancia_total
    FROM reservas r
    JOIN estudios e ON r.id_estudio = e.id_estudio
    WHERE r.id_estudio = id
    AND r.asistencia LIKE "ASISTIO";

    RETURN ganancia_total;
END//
DELIMITER ;

SELECT fn_ganacia_estudio(10)
FROM dual; 

-- SECCIÓN DE PROCEDIMIENTOS --

DROP PROCEDURE IF EXISTS sp_filtrar_por_columna;
DELIMITER //
CREATE PROCEDURE sp_filtrar_por_columna(
IN tab VARCHAR(200),
IN col VARCHAR(200)
)
BEGIN
	IF tab = '' OR col = '' THEN 
		SELECT 'NO CUMPLE CON LA REGLA'  AS falla_filtro FROM DUAL;
    ELSE
		SET @query = CONCAT('SELECT * FROM membresias.', tab, ' ORDER BY ', col);
		SELECT @query FROM DUAL;
		
		PREPARE query_value FROM @query;
		EXECUTE query_value ;
		DEALLOCATE PREPARE query_value;
	END IF;
END //

DELIMITER ;
CALL sp_filtrar_por_columna ('usuarios','id_usuario');

DROP TABLE IF EXISTS nuevo_producto_enterprise;
CREATE TABLE nuevo_producto_enterprise(
	id  INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    id_empresa INT ,
    tamanio_empresa VARCHAR (20)
);


DROP PROCEDURE IF EXISTS sp_producto_enterprise ;
DELIMITER //
CREATE PROCEDURE sp_producto_enterprise (IN id varchar(13))
BEGIN
DECLARE tamanio_empresa VARCHAR (20); 
SELECT tipo_empresa INTO tamanio_empresa FROM empresas
WHERE id_empresa = id; 
IF tamanio_empresa = "CORP" THEN
INSERT INTO nuevo_producto_enterprise (id_empresa, tamanio_empresa)
VALUES (id, tamanio_empresa);

SELECT 'SE OFRECERA NUEVA MEMBRESIA' AS mensaje;
ELSE 
SELECT 'LA EMPRESA NO ES DE TIPO CORP' AS mensaje;
    END IF;
END //

DELIMITER ;

CALL sp_producto_enterprise("GBA330115RH1");

-- SECCIÓN DE TRIGGERS --

DROP TRIGGER IF EXISTS before_insert;
DELIMITER //
CREATE
	TRIGGER membresias.before_insert
	BEFORE INSERT ON membresias.usuarios
    FOR EACH ROW
	BEGIN
		IF LENGTH(NEW.id_empresa) != 12 THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'RFC NO VALIDO';
		END IF;
    END //
DELIMITER ;

INSERT INTO membresias.usuarios (id_usuario, nombre, apellido, email, telefono, id_empresa) 
values (23, 'Yanie', 'Klaus', 'yosis@toplist.cz', '(265) 40055344', 'MFR210');

DROP TABLE auditoria;
CREATE TABLE membresias.auditoria
	(
        id_factura VARCHAR (20) ,
		fecha_pago DATE,
        monto DECIMAL(10,2),
        fecha_cuando_cambio DATETIME DEFAULT (CURRENT_TIMESTAMP)
    );
 
DROP TRIGGER IF EXISTS after_update_pagos;
    DELIMITER //
CREATE 
	TRIGGER membresias.after_update_pagos
    AFTER UPDATE ON membresias.pagos
    FOR EACH ROW
BEGIN
	INSERT INTO 
   membresias.auditoria
    (
	id_factura,
	fecha_pago,
	monto,
	fecha_cuando_cambio)
    VALUES
    (OLD.id_factura
    ,OLD.fecha_pago
    ,OLD.monto
    , NOW()
    );
END //
    
DELIMITER ;

SET SQL_SAFE_UPDATES = 0;

UPDATE membresias.pagos
SET monto = '765006.93'
WHERE id_factura = '916kzPV239';
