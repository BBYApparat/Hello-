-- Create a table to track the next available state ID
CREATE TABLE IF NOT EXISTS `state_id_counter` (
    `id` INT PRIMARY KEY DEFAULT 1,
    `next_id` INT NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert initial counter value
INSERT IGNORE INTO `state_id_counter` (`id`, `next_id`) VALUES (1, 1);

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
    
    INDEX (`owner`),
    INDEX (`is_spawned`),
    INDEX (`last_seen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add missing columns for multicharacter and other systems
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `firstname` VARCHAR(50) DEFAULT NULL;
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `lastname` VARCHAR(50) DEFAULT NULL;
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `dateofbirth` VARCHAR(10) DEFAULT NULL;
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `sex` VARCHAR(1) DEFAULT 'M';
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `height` INT DEFAULT 180;
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `skin` LONGTEXT DEFAULT NULL;
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `disabled` TINYINT(1) DEFAULT 0;
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `status` LONGTEXT DEFAULT NULL;
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `is_dead` TINYINT(1) DEFAULT 0;
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `jail_data` LONGTEXT DEFAULT NULL;
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `strainrep` LONGTEXT DEFAULT NULL;

-- Multicharacter slots table
CREATE TABLE IF NOT EXISTS `multicharacter_slots` (
    `identifier` VARCHAR(60) NOT NULL,
    `slots` INT(11) NOT NULL,
    PRIMARY KEY (`identifier`) USING BTREE,
    INDEX `slots` (`slots`) USING BTREE
) ENGINE=InnoDB;

-- AL_MDT Tables
CREATE TABLE IF NOT EXISTS `mdt_char_profiles` (
    `identifier` varchar(255) COLLATE utf8mb4_bin NOT NULL,
    `firstName` tinytext COLLATE utf8mb4_bin NOT NULL,
    `lastName` tinytext COLLATE utf8mb4_bin NOT NULL,
    `dob` varchar(50) COLLATE utf8mb4_bin NOT NULL,
    `sex` varchar(10) COLLATE utf8mb4_bin NOT NULL,
    `photoId` text COLLATE utf8mb4_bin NOT NULL,
    `contact` text COLLATE utf8mb4_bin NOT NULL,
    `notes` text COLLATE utf8mb4_bin NOT NULL,
    PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `mdt_fines` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(255) COLLATE utf8mb4_bin NOT NULL,
    `fine` int(11) NOT NULL DEFAULT 0,
    `reference` int(11) NOT NULL,
    `date` bigint(20) NOT NULL,
    `due_date` bigint(20) NOT NULL,
    `paid` tinyint(4) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `mdt_criminal_record` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(255) COLLATE utf8mb4_bin NOT NULL,
    `type` varchar(10) COLLATE utf8mb4_bin NOT NULL,
    `description` text COLLATE utf8mb4_bin NOT NULL,
    `input` longtext COLLATE utf8mb4_bin NOT NULL,
    `data` longtext COLLATE utf8mb4_bin NOT NULL,
    `date` bigint(20) NOT NULL,
    `submittedBy` varchar(255) COLLATE utf8mb4_bin NOT NULL,
    PRIMARY KEY (`id`),
    KEY `char` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `mdt_users` (
    `identifier` varchar(255) COLLATE utf8mb4_bin NOT NULL,
    `name` tinytext COLLATE utf8mb4_bin NOT NULL,
    `callsign` varchar(20) COLLATE utf8mb4_bin NOT NULL,
    `job` varchar(50) COLLATE utf8mb4_bin NOT NULL,
    `settings` text COLLATE utf8mb4_bin NOT NULL,
    PRIMARY KEY (`identifier`),
    KEY `job` (`job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- BBY Jobs duty tracking table
CREATE TABLE IF NOT EXISTS `job_duty` (
    `identifier` VARCHAR(60) NOT NULL,
    `job` VARCHAR(50) NOT NULL,
    `on_duty` TINYINT(1) NOT NULL DEFAULT 0,
    `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY (`identifier`, `job`),
    INDEX (`job`),
    INDEX (`on_duty`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
