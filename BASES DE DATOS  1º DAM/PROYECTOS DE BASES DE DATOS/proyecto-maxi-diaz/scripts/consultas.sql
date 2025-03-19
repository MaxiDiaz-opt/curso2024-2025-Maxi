-- MySQL Workbench Synchronization
-- Generated: 2025-02-24 19:14
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Maximiliano L. Diaz Diaz

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `carrentalx` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;

CREATE TABLE IF NOT EXISTS `carrentalx`.`clientes` (
  `idCliente` INT(11) NOT NULL AUTO_INCREMENT,
  `numCarnet` VARCHAR(10) NOT NULL,
  `identidad` VARCHAR(10) NOT NULL,
  `telefono` INT(10) NULL DEFAULT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `apellidos` VARCHAR(50) NOT NULL,
  `direccion` TEXT NULL DEFAULT NULL,
  `email` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE INDEX `licenciaCli_UNIQUE` (`numCarnet` ASC) VISIBLE,
  UNIQUE INDEX `identidadCli_UNIQUE` (`identidad` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin;

CREATE TABLE IF NOT EXISTS `carrentalx`.`reservas` (
  `idReserva` INT(11) NOT NULL AUTO_INCREMENT,
  `idCliente` INT(11) NOT NULL,
  `idVehiculo` INT(11) NOT NULL,
  `fechaInicio` DATETIME NOT NULL,
  `fechaFin` DATETIME NOT NULL,
  `precioTotal` DECIMAL NOT NULL,
  `estado` ENUM('Activa', 'Pausada', 'Cancelada', 'Completada') NOT NULL,
  `notas` TEXT NULL DEFAULT NULL,
  `lugarDevolucion` TEXT NOT NULL,
  `lugarRecogida` TEXT NOT NULL,
  PRIMARY KEY (`idReserva`),
  INDEX `fk_reservas_clientes_idx` (`idCliente` ASC) VISIBLE,
  INDEX `fk_reservas_vehiculos1_idx` (`idVehiculo` ASC) VISIBLE,
  CONSTRAINT `fk_reservas_clientes`
    FOREIGN KEY (`idCliente`)
    REFERENCES `carrentalx`.`clientes` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reservas_vehiculos1`
    FOREIGN KEY (`idVehiculo`)
    REFERENCES `carrentalx`.`vehiculos` (`idVehiculo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin;

CREATE TABLE IF NOT EXISTS `carrentalx`.`vehiculos` (
  `idVehiculo` INT(11) NOT NULL AUTO_INCREMENT,
  `tipo` ENUM('Coche', 'Moto') NOT NULL,
  `marca` VARCHAR(50) NOT NULL,
  `modelo` VARCHAR(50) NOT NULL,
  `año` YEAR NOT NULL,
  `combustible` ENUM('Gasoil', 'Gasaolina', 'Electrico') NOT NULL,
  `transmision` ENUM('Manual', 'Automatico') NOT NULL,
  `kilometraje` FLOAT(11) NOT NULL,
  `precioDiario` DECIMAL NOT NULL,
  `matricula` INT(7) NOT NULL,
  PRIMARY KEY (`idVehiculo`),
  UNIQUE INDEX `matricula_UNIQUE` (`matricula` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
