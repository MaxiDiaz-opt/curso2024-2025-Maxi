-- Usar la base de datos CarrentalX

USE carrentalx;

-- Voy a alterar varios campos de la base de datos o incluir nueva información:

-- Voy a alterar el campo disponibilidad de TYNYINT a ENUM de la tabla vehiculos para dejarla más clara y adecuada.
-- Como ya esta creada y rellenada, voy a crear una tabla temporal, cambiar algunos valores y pasarlos a la nueva columna.

ALTER TABLE vehiculos ADD COLUMN disponible_tmp ENUM('Disponible', 'No disponible') DEFAULT 'Disponible';
SELECT * FROM vehiculos;

-- Cambio dos campos a 0 para que haya variedad

UPDATE vehiculos SET disponible=0 WHERE tipo IN ('Moto','Furgoneta');

-- Paso la información de cero como No disponible y 1 como Disponible a la nueva columna con una sentencia CASE:

UPDATE vehiculos
SET disponible_tmp = CASE
    WHEN disponible = 1 THEN 'Disponible'
    WHEN disponible = 0 THEN 'No disponible'
END;

-- Borro la columna antigua y renombro la nueva

ALTER TABLE vehiculos DROP COLUMN disponible;
ALTER TABLE vehiculos CHANGE disponible_tmp disponible ENUM('Disponible', 'No disponible') DEFAULT 'Disponible';

-- Ahora, voy a incluir dos nuevas reservas para el mismo id de cliente:

INSERT INTO reservas (fechaInicio, fechaFin, precio, estado, metodoPago, observaciones, idCliente, idEmpleado, idVehiculo, idSucursalRecogida) VALUES
('2024-04-04 09:00:00', '2024-04-05 09:00:00', 300.00, 'Completada', 'Tarjeta', 'Cliente frecuente', 1, 2, 2, 1),
('2024-05-01 12:00:00', '2024-05-07 12:00:00', 315.00, 'Activa', 'PayPal', 'Solicita silla de bebé', 1, 3, 3, 2);

-- Y voy a borrar una del mismo cliente segun el periodo de tiempo de alquiler:

DELETE FROM reservas WHERE idCliente = 1 AND fechaInicio BETWEEN '2024-04-10 00:00:00' AND '2024-05-01 23:59:59';

-- Voy a modificar la cantidad de alquileres de dos clientes en tres reservas más de forma conjunta, y otros dos clientes por separado:

UPDATE clientes SET cantidadReservasCli = cantidadReservasCli + 3 WHERE idCliente IN (1, 2);
UPDATE clientes SET cantidadReservasCli = 2 WHERE idCliente= 3;
UPDATE clientes SET cantidadReservasCli = 1 WHERE idCliente= 4;

SELECT * FROM clientes;

-- Voy a realizar consulta simples en las tablas de la base de datos de CarrentaX:
-- Voy a listar los clientes

SELECT nombreCli, apellidosCli, emailCli FROM clientes;

-- Voy a ver  los vehículos disponibles para alquilar:

SELECT marca, modelo, tipo, precioDiario FROM vehiculos WHERE disponible = 'Disponible';

-- Voy a consultar los clientes con más de 2 reservas Y que tengan una L inicial en el nombre:

SELECT nombreCli, apellidosCli, cantidadReservasCli FROM clientes WHERE cantidadReservasCli > 2 AND nombreCli LIKE 'L%';

-- Clientes cuyo carnet vence en menos de 6 meses:

SELECT nombreCli, apellidosCli, vencimientoLicenciaCli FROM clientes
WHERE vencimientoLicenciaCli < CURDATE() + INTERVAL 6 MONTH;

# Vamos a sumar la cantidad real de alquileres según el número de reservas de cada 
# vehículo en la columna cantidadAlquileres de la tabla vehículos, con un un join.

UPDATE vehiculos v
JOIN (
    SELECT idVehiculo, COUNT(*) AS total
    FROM reservas
    GROUP BY idVehiculo
) r ON v.idVehiculo = r.idVehiculo
SET v.cantidadAlquileres = r.total;

SELECT * FROM vehiculos;

-- Ahora vamos a ver la cantidad de reservas por vehículo, por orden descendente, del top 3.

SELECT marca, modelo, cantidadAlquileres FROM vehiculos
ORDER BY cantidadAlquileres DESC LIMIT 3;

# Voy a contar las reservas por método de pago:

SELECT metodoPago, COUNT(*) AS totalReservas FROM reservas
GROUP BY metodoPago;

-- INNER JOIN – Voy a mostrar reservas con información del cliente y el vehículo alquilado:

SELECT r.idReserva, c.nombreCli, c.apellidosCli, v.marca, v.modelo, r.fechaInicio, r.fechaFin FROM reservas r
INNER JOIN clientes c ON r.idCliente = c.idCliente
INNER JOIN vehiculos v ON r.idVehiculo = v.idVehiculo;

-- LEFT JOIN – Voy a mostrar todos los vehículos con su última reserva:

SELECT v.marca, v.modelo, r.fechaInicio, r.estado FROM vehiculos v
LEFT JOIN reservas r ON v.idVehiculo = r.idVehiculo
ORDER BY v.idVehiculo;

-- Ejemplo de RANK(), consulto el ranking de reservas por cliente, de la más nueva a la más antigua.

SELECT c.nombreCli AS Cliente, r.fechaReserva AS Fecha_Reserva,
RANK() OVER (PARTITION BY c.idCliente ORDER BY r.fechaReserva DESC) AS Ranking
FROM clientes c
INNER JOIN reservas r ON c.idCliente = r.idCliente;

-- Voy a consultar con GROUP BY el total gastado por cliente con inner join:

SELECT c.nombreCli AS Cliente, SUM(r.precio) AS Total_Gastado
FROM clientes c
INNER JOIN reservas r ON c.idCliente = r.idCliente
GROUP BY c.idCliente;


