# Mejoras a la base de datos creando la tabla salarios, 
# que se complementa con una tabla de registro de salarios anteriores y un trigger para guardar la fecha y el salario anterior:

USE carrentalx;

# Se va a crear una tabla de salarios actuales de los empleados 
# que va a permitir ver cuando se inicia el contrato y el valor del salario.

CREATE TABLE `salarios` (
  `idSalario` INT NOT NULL AUTO_INCREMENT,
  `idEmpleado` INT NOT NULL,
  `salario` DECIMAL(10,2) NOT NULL,
  `fechaInicio` DATE NOT NULL,
  PRIMARY KEY (`idSalario`),
  FOREIGN KEY (`idEmpleado`) REFERENCES `empleados`(`idEmpleado`) ON DELETE CASCADE
);

-- Y le metemos inserciones sobre el salario de los 4 empleados 

INSERT INTO `salarios` (`idEmpleado`, `salario`, `fechaInicio`)
VALUES 
(1, 1800.00, '2024-01-01'),
(2, 1950.50, '2023-11-15'),
(3, 2000.00, '2025-01-01'),
(4, 1500.90, '2022-09-09');

SELECT * FROM salarios;

# Vamos a mejorarla incluyendo un trigger que sirva para que cada vez que se cambia el salario, 
# se actualice una tabla de historia de salarios.
  
# El primer paso es crear otra tabla para almacenar los salarios antiguos.

CREATE TABLE IF NOT EXISTS `salarios_anterior` (
  `idSalarioAnt` INT NOT NULL AUTO_INCREMENT,
  `idEmpleado` INT NOT NULL,
  `salario` DECIMAL(10,2) NOT NULL,
  `fechaFin` DATE NOT NULL,
  PRIMARY KEY (`idSalarioAnt`),
  FOREIGN KEY (`idEmpleado`) REFERENCES `empleados`(`idEmpleado`) ON DELETE CASCADE
);

# Y ahora se crea el trigger para almacenar la fecha y el salario anterior en esta nueva tabla
# cuando se actualiza la tabla de salarios.

DELIMITER $$
CREATE TRIGGER `guardar_antes_de_actualizar_salario`
BEFORE UPDATE ON `salarios`
FOR EACH ROW
BEGIN
  -- Solo guarda si el salario realmente va a cambiar
  IF NEW.salario <> OLD.salario THEN
    INSERT INTO salarios_anterior (idEmpleado, salario, fechaFin)
    VALUES (OLD.idEmpleado, OLD.salario, DATE_SUB(OLD.fechaInicio, INTERVAL 1 DAY)); -- Ponemos que la fecha final sea del dia anterior con DATE_SUB.
  END IF;
END$$
DELIMITER ;

# Ahora probamos que funcione:

SELECT * FROM salarios;
UPDATE salarios
SET salario = 2800.00
WHERE idEmpleado = 1;

UPDATE salarios
SET salario = 2330.30
WHERE idEmpleado = 4;

SELECT * FROM salarios_anterior;
