CREATE DATABASE IF NOT EXISTS `es_extended`;

ALTER DATABASE `es_extended`
	DEFAULT CHARACTER SET UTF8MB4;
	
ALTER DATABASE `es_extended`
	DEFAULT COLLATE UTF8MB4_UNICODE_CI;

USE `es_extended`;

CREATE TABLE `users` (
	`identifier` VARCHAR(60) NOT NULL,
	`accounts` LONGTEXT NULL DEFAULT NULL,
	`group` VARCHAR(50) NULL DEFAULT 'user',
	`inventory` LONGTEXT NULL DEFAULT NULL,
	`job` VARCHAR(20) NULL DEFAULT 'unemployed',
	`job_grade` INT NULL DEFAULT 0,
	`gang` VARCHAR(20) NULL DEFAULT 'unemployed',
	`gang_grade` INT NULL DEFAULT 0,
	`loadout` LONGTEXT NULL DEFAULT NULL,
	`metadata` LONGTEXT NULL DEFAULT NULL,
	`position` longtext NULL DEFAULT NULL,
	`state_id` INT NULL DEFAULT NULL UNIQUE,

	PRIMARY KEY (`identifier`)
) ENGINE=InnoDB;

-- Create a table to track the next available state ID
CREATE TABLE IF NOT EXISTS `state_id_counter` (
    `id` INT PRIMARY KEY DEFAULT 1,
    `next_id` INT NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert initial counter value
INSERT IGNORE INTO `state_id_counter` (`id`, `next_id`) VALUES (1, 1);

CREATE TABLE `items` (
	`name` VARCHAR(50) NOT NULL,
	`label` VARCHAR(50) NOT NULL,
	`weight` INT NOT NULL DEFAULT 1,
	`rare` TINYINT NOT NULL DEFAULT 0,
	`can_remove` TINYINT NOT NULL DEFAULT 1,

	PRIMARY KEY (`name`)
) ENGINE=InnoDB;

CREATE TABLE `job_grades` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`job_name` VARCHAR(50) DEFAULT NULL,
	`grade` INT NOT NULL,
	`name` VARCHAR(50) NOT NULL,
	`label` VARCHAR(50) NOT NULL,
	`salary` INT NOT NULL,
	`skin_male` LONGTEXT NOT NULL,
	`skin_female` LONGTEXT NOT NULL,

	PRIMARY KEY (`id`)
) ENGINE=InnoDB;

INSERT INTO `job_grades` VALUES (1,'unemployed',0,'unemployed','Unemployed',200,'{}','{}');

CREATE TABLE `jobs` (
	`name` VARCHAR(50) NOT NULL,
	`label` VARCHAR(50) DEFAULT NULL,

	PRIMARY KEY (`name`)
) ENGINE=InnoDB;

INSERT INTO `jobs` VALUES ('unemployed','Unemployed');

CREATE TABLE `gang_grades` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`gang_name` VARCHAR(50) DEFAULT NULL,
	`grade` INT NOT NULL,
	`name` VARCHAR(50) NOT NULL,
	`label` VARCHAR(50) NOT NULL,
	`salary` INT NOT NULL,
	`skin_male` LONGTEXT NOT NULL,
	`skin_female` LONGTEXT NOT NULL,

	PRIMARY KEY (`id`)
) ENGINE=InnoDB;

INSERT INTO `gang_grades` VALUES (1,'unemployed',0,'unemployed','Unemployed',0,'{}','{}');

CREATE TABLE `gangs` (
	`name` VARCHAR(50) NOT NULL,
	`label` VARCHAR(50) DEFAULT NULL,

	PRIMARY KEY (`name`)
) ENGINE=InnoDB;

INSERT INTO `gangs` VALUES ('unemployed','Unemployed');

-- Vehicle Persistence System
CREATE TABLE IF NOT EXISTS `vehicle_persistence` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `plate` VARCHAR(12) NOT NULL UNIQUE,
    `owner` VARCHAR(60) NOT NULL,
    `vehicle_data` LONGTEXT NOT NULL,
    `last_position` LONGTEXT NOT NULL,
    `last_seen` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `is_spawned` TINYINT(1) NOT NULL DEFAULT 0,
    `network_id` INT DEFAULT NULL,
    `health_data` LONGTEXT DEFAULT NULL,
    `trunk_items` LONGTEXT DEFAULT NULL,
    `glovebox_items` LONGTEXT DEFAULT NULL,
    
    FOREIGN KEY (`owner`) REFERENCES `users`(`identifier`) ON DELETE CASCADE,
    INDEX (`owner`),
    INDEX (`is_spawned`),
    INDEX (`last_seen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
