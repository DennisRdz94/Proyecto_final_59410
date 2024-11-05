## Objetos

### Vistas
 
**vw_pagos_mensuales**

La vista tiene como objetivo mostrar los ingresos totales por mes

```sql
SELECT  * FROM vw_pagos_mensuales;
```

**vw_clases_asistidas**

Muestra un resumen de pagos para los estudios únicamente si se tuvo asistencia por parte de los usuarios con el objetivo de pagarle al estudio solo lo correspondiente.

```sql
SELECT  * FROM vw_clases_asistidas;
```

### Funciones

**fn_nombre_cliente**

Nos trae el nombre del cliente al momento de ingresar su id, esto puede ser útil para personalizar la comunicación que se les brinda a los usuarios. 

**TABLAS INVOLUCRADAS**
- Usuarios

```sql
SELECT fn_nombre_cliente(2) FROM dual;
```
**fn_ganacia_estudio**
Devuelve las ganancias totales del estudio específico que estes buscando de las clases que se realizaron para cada uno de los usuaios. 

**TABLAS INVOLUCRADAS**
- Estudios
- Reservas

```sql
SELECT fn_ganacia_estudio(10) FROM dual; 
```

### Procedimientos

**sp_filtrar_por_columna**

Para hacer un proceso correcto de filtrado por columna

**TABLAS INVOLUCRADAS**
- Puede interactuar con todas las tablas

```sql
DELIMITER ;
CALL sp_filtrar_por_columna ('usuarios','id_usuario'); 
```

**sp_producto_enterprise**

Con este proceso se busca crear una lista con las empresas a las cuales se les podrá ofrecer una membresía enterprise como un nuevo producto a futuro. 
Se almacena en la tabla *nuevo_producto_enterprise*

**TABLAS INVOLUCRADAS**
- empresas
- nuevo_producto_enterprise

```sql
CALL sp_producto_enterprise("GBA330115RH1");
```

### TRIGGERS

**before_insert**
Antes de recopilar la información de un nuevo usuario asegurarse que el RFC de la empresa tenga la longitud necesaria para ser válido, esto como un primer filtro al momento de dar nuevos usuarios de alta. 

**TABLAS INVOLUCRADAS**
- Usuarios

```sql
INSERT INTO membresias.usuarios (id_usuario, nombre, apellido, email, telefono, id_empresa) 
values (23, 'Yanie', 'Klaus', 'yosis@toplist.cz', '(265) 40055344', 'MFR210'); 
```

**after_update_pagos**
Se trata de un trigger de auditoría el cual nos indica si la información de pagos fue modificada, esto es muy valioso ya que la contabilidad de una empresa es esencial. 
Creación de tabla auditoria

**TABLAS INVOLUCRADAS**
- pagos
- auditoria

```sql
SET SQL_SAFE_UPDATES = 0;

UPDATE membresias.pagos
SET monto = '765006.93'
WHERE id_factura = '916kzPV239'; 
```






































