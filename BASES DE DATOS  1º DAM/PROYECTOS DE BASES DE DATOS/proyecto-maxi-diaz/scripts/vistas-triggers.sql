# Vamos a generar algunas vistas que pueden ser utiles para consultar tanto los clientes y vehiculos, 
# como  la parte de gestión de la flota y los empleados.
USE carrentalx;

-- Vista para ver los clientes y los vehículos alquilados

CREATE OR REPLACE VIEW `vista_clientes_vehiculos_alquilados` AS
SELECT c.idCliente, c.nombreCli,c.apellidosCli, v.matricula, v.tipo, v.marca, r.fechaInicio, r.fechaFin
FROM clientes c
JOIN reservas r ON c.idCliente = r.idCliente
JOIN vehiculos v ON r.idVehiculo = v.idVehiculo;

SELECT * FROM vista_clientes_vehiculos_alquilados;

-- Una vista para ver los vehículos más reservados

CREATE OR REPLACE VIEW `vista_vehiculos_mas_alquilados` AS
SELECT v.idVehiculo, v.matricula, v.tipo, v.marca, COUNT(r.idReserva) AS veces_reservado
FROM vehiculos v
JOIN reservas r ON v.idVehiculo = r.idVehiculo
GROUP BY v.idVehiculo
ORDER BY veces_reservado DESC;

SELECT * FROM vista_vehiculos_mas_alquilados;

-- Una vista para ver la cantidad de ingresos por vehículo

CREATE OR REPLACE VIEW `vista_ingresos_por_vehiculo` AS
SELECT  v.idVehiculo, v.matricula, v.tipo, v.marca, SUM(r.precio) AS total_ingresos
FROM vehiculos v
JOIN reservas r ON v.idVehiculo = r.idVehiculo
GROUP BY v.idVehiculo 
ORDER BY total_ingresos DESC;

# Me doy cuenta de que no puedo consultar los empleados que hay activos por sucursal y crear una vista, 
# por lo que voy a crear un campo idSucursal, rellenar los campos para que no haya conflictos 
# y crear una llave foranea en empleados que apunten a la sucursal donde trabajan,.
-- Creo la columna
ALTER TABLE `empleados` ADD COLUMN `idSucursal` INT NOT NULL;
-- Relleno los campos
UPDATE empleados SET idSucursal = 1 WHERE idEmpleado = 1;
UPDATE empleados SET idSucursal = 3 WHERE idEmpleado = 3;
UPDATE empleados SET idSucursal = 3 WHERE idEmpleado = 4; -- Esta sucursal tiene dos empleados (el 3 y el 4)
UPDATE empleados SET idSucursal = 4 WHERE idEmpleado = 2; -- No hay empleados actualmente en la sucursal 2
-- Creamos la llave foramnea
ALTER TABLE `empleados` ADD CONSTRAINT `fk_empleados_sucursales`
FOREIGN KEY (`idSucursal`) REFERENCES `sucursales`(`idSucursal`);

-- Ahora sí podemos crear la vista que consulta las sucursales con los empleados que están en activo.

CREATE OR REPLACE VIEW `vista_empleados_activos_por_sucursal` AS
SELECT s.nombreSuc AS sucursal, s.direccionSuc, e.idEmpleado, e.nombreEmp, e.apellidosEmp, e.cargoEmp
FROM sucursales s
LEFT JOIN empleados e ON s.idSucursal = e.idSucursal AND e.activo = 1;

SELECT * FROM vista_empleados_activos_por_sucursal; -- La sucursal de aeropuerto está en obras y no tiene empleados activos.

-- Vista de reservas completadas

CREATE OR REPLACE VIEW `vista_reservas_completadas` AS
SELECT  r.idReserva, c.nombreCli, c.apellidosCli, v.matricula, v.tipo, r.fechaInicio, r.fechaFin, r.precio
FROM reservas r
JOIN clientes c ON r.idCliente = c.idCliente
JOIN vehiculos v ON r.idVehiculo = v.idVehiculo
WHERE r.estado = 'Completada';

SELECT * FROM vista_reservas_completadas;

-- Y finalmente una vista de vehñiuclos disponibles

CREATE OR REPLACE VIEW `vista_vehiculos_disponibles` AS
SELECT v.idVehiculo, v.matricula, v.tipo, v.marca, v.modelo, v.precioDiario, s.nombreSuc AS sucursal
FROM vehiculos v
JOIN sucursales s ON v.idSucursal = s.idSucursal
WHERE v.disponible = 'Disponible';

SELECT * FROM vista_vehiculos_disponibles;

# Ahora vamos completar con dos trigger que complementan el que se 
# creó anteriormente en el script de "ampliación" con la tabla salarios y salarios_anterior.

-- Trigger para actualizar la disponibilidad del vehiculo cuando se completa la reserva

DELIMITER $$
CREATE TRIGGER liberar_vehiculo_al_completar
AFTER UPDATE ON reservas
FOR EACH ROW
BEGIN
-- Si el nuevo estado en reservas se actualiza a Completada se actualiza el vehiculo con campo disponible a Disponible.
  IF NEW.estado = 'Completada' AND OLD.estado <> 'Completada' THEN 
    UPDATE vehiculos
    SET disponible = 'Disponible'
    WHERE idVehiculo = NEW.idVehiculo;
  END IF;
END$$
DELIMITER ;

-- Vamos a hacer una prueva a ver si funciona.
SELECT * FROM reservas;
SELECT * FROM vehiculos;

-- Paso la moto Yamaha que esta No disponible a Disponible de la reserva 3, que esta Activa.

UPDATE reservas SET estado = 'Completada' WHERE idReserva = 3 AND estado = 'Activa'; -- El trigger Funciona, cambia el campo a Disponible!!

-- Dejo los registros como estaban antes del trigger:

UPDATE reservas SET estado = 'Activa' WHERE idReserva = 3;
UPDATE vehiculos SET disponible = 'No disponible' WHERE idVehiculo = 3;

-- Este proximo trigger, al registrar un mantenimiento, actualiza la columna ultimoMantenimiento del vehículo con la nueva fecha.

Select * FROM vehiculos;
SELECT * FROM mantenimientos;

-- Cuando se inserta una nueva fila en mantenimiento, se actualiza la columna de vehiculos con el ultimo mantenimiento.
DELIMITER $$
CREATE TRIGGER actualizar_mantenimiento
AFTER INSERT ON mantenimientos
FOR EACH ROW
BEGIN
UPDATE vehiculos 
SET ultimoMantenimiento = NEW.fechaMantenimiento WHERE idVehiculo = NEW.idVehiculo;
END$$
DELIMITER ;

-- Vamos a crear una nueva fila para probar el trigger

INSERT INTO mantenimientos (fechaMantenimiento, descripcion, costo, tipoMantenimiento, kilometraje, idVehiculo)
VALUES ('2025-04-13','Cambio de aceite y revisión de frenos', 120.50, 'Preventivo', 45000, 3);

SELECT * FROM vehiculos WHERE idVehiculo=3; -- Funciona el trigger!! La moto actualiza su ultimo mantenimiento.
