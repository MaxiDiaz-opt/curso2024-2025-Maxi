-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema carrentalx
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema carrentalx
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `carrentalx` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `carrentalx` ;

-- -----------------------------------------------------
-- Table `carrentalx`.`clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `carrentalx`.`clientes` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `licenciaCli` VARCHAR(20) NOT NULL,
  `identidadCli` VARCHAR(20) NOT NULL,
  `telefonoCli` VARCHAR(15) NULL DEFAULT NULL,
  `nombreCli` VARCHAR(50) NOT NULL,
  `apellidosCli` VARCHAR(50) NOT NULL,
  `direccionCli` TEXT NULL DEFAULT NULL,
  `cantidadReservasCli` INT NOT NULL DEFAULT '0',
  `emailCli` VARCHAR(100) NOT NULL,
  `vencimientoLicenciaCli` DATE NOT NULL,
  `fechaRegistro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idCliente`),
  UNIQUE INDEX `licenciaCli_UNIQUE` (`licenciaCli` ASC) VISIBLE,
  UNIQUE INDEX `identidadCli_UNIQUE` (`identidadCli` ASC) VISIBLE,
  UNIQUE INDEX `emailCli_UNIQUE` (`emailCli` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `carrentalx`.`empleados`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `carrentalx`.`empleados` (
  `idEmpleado` INT NOT NULL AUTO_INCREMENT,
  `identidadEmp` VARCHAR(20) NOT NULL,
  `nombreEmp` VARCHAR(50) NOT NULL,
  `apellidosEmp` VARCHAR(50) NOT NULL,
  `telefonoEmp` VARCHAR(15) NOT NULL,
  `cargoEmp` VARCHAR(50) NOT NULL,
  `emailEmp` VARCHAR(100) NOT NULL,
  `fechaContratacion` DATE NOT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`idEmpleado`),
  UNIQUE INDEX `identidadEmp_UNIQUE` (`identidadEmp` ASC) VISIBLE,
  UNIQUE INDEX `emailEmp_UNIQUE` (`emailEmp` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `carrentalx`.`sucursales`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `carrentalx`.`sucursales` (
  `idSucursal` INT NOT NULL AUTO_INCREMENT,
  `nombreSuc` VARCHAR(50) NOT NULL,
  `direccionSuc` TEXT NULL DEFAULT NULL,
  `horarioAperturaSuc` TIME NOT NULL,
  `horarioCierreSuc` TIME NOT NULL,
  `diasAperturaSuc` VARCHAR(50) NOT NULL,
  `totalReservasSuc` INT NOT NULL DEFAULT '0',
  `ingresoMensualSuc` DECIMAL(10,2) NOT NULL DEFAULT '0.00',
  `telefonoSuc` VARCHAR(15) NULL DEFAULT NULL,
  `emailSuc` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`idSucursal`),
  UNIQUE INDEX `nombreSuc_UNIQUE` (`nombreSuc` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `carrentalx`.`vehiculos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `carrentalx`.`vehiculos` (
  `idVehiculo` INT NOT NULL AUTO_INCREMENT,
  `tipo` ENUM('Coche', 'Moto', 'SUV', 'Furgoneta', 'Camión') NOT NULL,
  `marca` VARCHAR(50) NOT NULL,
  `modelo` VARCHAR(50) NOT NULL,
  `año` YEAR NOT NULL,
  `combustible` ENUM('Gasoil', 'Gasolina', 'Eléctrico', 'Híbrido') NOT NULL,
  `transmision` ENUM('Manual', 'Automático') NOT NULL,
  `kilometraje` FLOAT NOT NULL DEFAULT '0',
  `precioDiario` DECIMAL(10,2) NOT NULL,
  `matricula` VARCHAR(15) NOT NULL,
  `cantidadAlquileres` INT NOT NULL DEFAULT '0',
  `disponible` TINYINT(1) NOT NULL DEFAULT '1',
  `fechaAdquisicion` DATE NULL DEFAULT NULL,
  `ultimoMantenimiento` DATE NULL DEFAULT NULL,
  `idSucursal` INT NOT NULL,
  PRIMARY KEY (`idVehiculo`),
  UNIQUE INDEX `matricula_UNIQUE` (`matricula` ASC) VISIBLE,
  INDEX `fk_vehiculos_sucursales1_idx` (`idSucursal` ASC) VISIBLE,
  CONSTRAINT `fk_vehiculos_sucursales`
    FOREIGN KEY (`idSucursal`)
    REFERENCES `carrentalx`.`sucursales` (`idSucursal`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `carrentalx`.`mantenimientos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `carrentalx`.`mantenimientos` (
  `idMantenimiento` INT NOT NULL AUTO_INCREMENT,
  `fechaMantenimiento` DATE NOT NULL,
  `descripcion` TEXT NOT NULL,
  `costo` DECIMAL(10,2) NOT NULL,
  `tipoMantenimiento` ENUM('Preventivo', 'Correctivo', 'Revisión') NOT NULL,
  `kilometraje` FLOAT NOT NULL,
  `idVehiculo` INT NOT NULL,
  PRIMARY KEY (`idMantenimiento`),
  INDEX `fk_mantenimientos_vehiculos1_idx` (`idVehiculo` ASC) VISIBLE,
  CONSTRAINT `fk_mantenimientos_vehiculos1`
    FOREIGN KEY (`idVehiculo`)
    REFERENCES `carrentalx`.`vehiculos` (`idVehiculo`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `carrentalx`.`reservas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `carrentalx`.`reservas` (
  `idReserva` INT NOT NULL AUTO_INCREMENT,
  `fechaInicio` DATETIME NOT NULL,
  `fechaFin` DATETIME NOT NULL,
  `precio` DECIMAL(10,2) NOT NULL,
  `estado` ENUM('Activa', 'Pausada', 'Cancelada', 'Completada') NOT NULL DEFAULT 'Activa',
  `fechaReserva` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `metodoPago` ENUM('Efectivo', 'Tarjeta', 'Transferencia', 'PayPal') NULL DEFAULT NULL,
  `observaciones` TEXT NULL DEFAULT NULL,
  `idCliente` INT NOT NULL,
  `idEmpleado` INT NOT NULL,
  `idVehiculo` INT NOT NULL,
  `idSucursalRecogida` INT NOT NULL,
  PRIMARY KEY (`idReserva`),
  INDEX `fk_reservas_clientes_idx` (`idCliente` ASC) VISIBLE,
  INDEX `fk_reservas_empleados1_idx` (`idEmpleado` ASC) VISIBLE,
  INDEX `fk_reservas_vehiculos1_idx` (`idVehiculo` ASC) VISIBLE,
  INDEX `fk_reservas_sucursales1_idx` (`idSucursalRecogida` ASC) VISIBLE,
  CONSTRAINT `fk_reservas_clientes`
    FOREIGN KEY (`idCliente`)
    REFERENCES `carrentalx`.`clientes` (`idCliente`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_reservas_empleados1`
    FOREIGN KEY (`idEmpleado`)
    REFERENCES `carrentalx`.`empleados` (`idEmpleado`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_reservas_sucursales1`
    FOREIGN KEY (`idSucursalRecogida`)
    REFERENCES `carrentalx`.`sucursales` (`idSucursal`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_reservas_vehiculos1`
    FOREIGN KEY (`idVehiculo`)
    REFERENCES `carrentalx`.`vehiculos` (`idVehiculo`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
