USE carrentalx;
-- Insertar las sucursales
INSERT INTO `carrentalx`.`sucursales` 
(`nombreSuc`, `direccionSuc`, `horarioAperturaSuc`, `horarioCierreSuc`, `diasAperturaSuc`, `telefonoSuc`, `emailSuc`) VALUES
('Sucursal Centro', 'Av. Principal 123, Centro', '08:00:00', '20:00:00', 'Lunes-Sábado', '922-280234', 'centro@carrentalx.com'),
('Sucursal Aeropuerto', 'Terminal 2, Aeropuerto Internacional', '06:00:00', '23:00:00', 'Lunes-Domingo', '699-885544', 'aeropuerto@carrentalx.com'),
('Sucursal Norte', 'Plaza Comercial Norte, Local 45', '09:00:00', '21:00:00', 'Lunes-Domingo', '935-456789', 'norte@carrentalx.com'),
('Sucursal Playa', 'Blvd. Costero 789, Zona Turística', '07:00:00', '22:00:00', 'Lunes-Domingo', '691-386756', 'playa@carrentalx.com');

-- Insertar los empleados de CarRentx
INSERT INTO `carrentalx`.`empleados` 
(`identidadEmp`, `nombreEmp`, `apellidosEmp`, `telefonoEmp`, `cargoEmp`, `emailEmp`, `fechaContratacion`) VALUES
('78706463W', 'Carlos', 'Ramírez López', '922-280234', 'Gerente', 'carlos.ramirez@carrentalx.com', '2020-06-15'),
('78706465E', 'Ana', 'Martínez Sánchez', '935-456789', 'Recepcionista', 'ana.martinez@carrentalx.com', '2021-03-10'),
('78706478J', 'Roberto', 'González Pérez', '699-885544', 'Mecánico', 'roberto.gonzalez@carrentalx.com', '2022-01-05'),
('78706120T', 'Sofía', 'Hernández Díaz', '691-386756', 'Ejecutiva de Ventas', 'sofia.hernandez@carrentalx.com', '2021-09-20');

-- Insertar 4 registros de clientes
INSERT INTO `carrentalx`.`clientes` 
(`licenciaCli`, `identidadCli`, `telefonoCli`, `nombreCli`, `apellidosCli`, `direccionCli`, `emailCli`, `vencimientoLicenciaCli`) VALUES
('78706463W', '78706463W', '922-280234', 'Miguel', 'Torres García', 'Calle Roble 45, Colonia Vista', 'miguel.torres@email.com', '2026-05-20'),
('78706465E', '78706465E', '699-885544', 'Laura', 'Méndez Ruiz', 'Av. Pinos 78, Residencial Las Palmas', 'laura.mendez@email.com', '2025-11-15'),
('78706478J', '78706478J', '935-456789', 'Javier', 'Ortega Vega', 'Blvd. Central 120, Edificio Azul', 'javier.ortega@email.com', '2024-08-30'),
('78706120T', '78706120T', '691-386756', 'Patricia', 'Luna Castro', 'Calle Lirios 33, Fracc. Jardines', 'patricia.luna@email.com', '2025-03-25');

-- Insertar vehículos
INSERT INTO `carrentalx`.`vehiculos` 
(`tipo`, `marca`, `modelo`, `año`, `combustible`, `transmision`, `kilometraje`, `precioDiario`, `matricula`, `fechaAdquisicion`, `ultimoMantenimiento`, `idSucursal`) VALUES
('Coche', 'Toyota', 'Corolla', '2022', 'Gasolina', 'Automático', 15000.5, 45.00, 'ABC-123', '2022-01-15', '2023-06-10', 1),
('SUV', 'Honda', 'CR-V', '2021', 'Híbrido', 'Automático', 25000.8, 65.00, 'XYZ-789', '2021-03-20', '2023-07-05', 1),
('Moto', 'Yamaha', 'MT-07', '2023', 'Gasolina', 'Manual', 8000.2, 35.00, 'MOT-456', '2023-01-10', '2023-08-15', 2),
('Furgoneta', 'Mercedes', 'Sprinter', '2020', 'Gasoil', 'Manual', 45000.0, 85.00, 'FUR-789', '2020-05-15', '2023-05-20', 3);

-- Insertar mantenimiento de coches
INSERT INTO `carrentalx`.`mantenimientos` 
(`fechaMantenimiento`, `descripcion`, `costo`, `tipoMantenimiento`, `kilometraje`, `idVehiculo`) VALUES
('2023-06-10', 'Cambio de aceite y filtros', 120.50, 'Preventivo', 14500.0, 1),
('2023-07-05', 'Revisión sistema híbrido y frenos', 250.75, 'Revisión', 24000.0, 2),
('2023-08-15', 'Cambio de neumáticos y alineación', 350.00, 'Correctivo', 7500.0, 3),
('2023-05-20', 'Revisión general y cambio correa distribución', 580.25, 'Preventivo', 44000.0, 4);

-- Insertar 4 reservas
INSERT INTO `carrentalx`.`reservas` 
(`fechaInicio`, `fechaFin`, `precio`, `estado`, `metodoPago`, `observaciones`, `idCliente`, `idEmpleado`, `idVehiculo`, `idSucursalRecogida`) VALUES
('2023-09-15 10:00:00', '2023-09-20 10:00:00', 225.00, 'Completada', 'Tarjeta', 'Cliente frecuente', 1, 1, 1, 1),
('2023-10-01 14:00:00', '2023-10-05 14:00:00', 260.00, 'Activa', 'PayPal', 'Solicita GPS adicional', 2, 2, 2, 2),
('2023-10-10 09:00:00', '2023-10-12 09:00:00', 70.00, 'Activa', 'Efectivo', 'Primera vez que alquila moto', 3, 3, 3, 2),
('2023-11-05 12:00:00', '2023-11-12 12:00:00', 595.00, 'Pausada', 'Transferencia', 'Traslado de mercancías', 4, 4, 4, 3);

-- Comprobar que todo se ha insertado bien
USE carrentalx;
SELECT * FROM clientes;
SELECT * FROM empleados;
SELECT * FROM mantenimientos;
SELECT * FROM reservas;
SELECT * FROM sucursales;
SELECT * FROM vehiculos;
