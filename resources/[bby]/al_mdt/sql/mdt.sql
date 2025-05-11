/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

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

CREATE TABLE IF NOT EXISTS `mdt_duty_tracker` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `job` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `start` bigint(20) NOT NULL,
  `end` bigint(20) NOT NULL,
  `duration` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
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

CREATE TABLE IF NOT EXISTS `mdt_person_bolos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator` tinytext COLLATE utf8mb4_bin NOT NULL,
  `name` tinytext COLLATE utf8mb4_bin NOT NULL,
  `lastSeen` tinytext COLLATE utf8mb4_bin NOT NULL,
  `reason` text COLLATE utf8mb4_bin NOT NULL,
  `description` text COLLATE utf8mb4_bin NOT NULL,
  `notes` text COLLATE utf8mb4_bin NOT NULL,
  `date` bigint(20) NOT NULL,
  `targetIdentifier` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`)
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

CREATE TABLE IF NOT EXISTS `mdt_veh_bolos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator` tinytext COLLATE utf8mb4_bin NOT NULL,
  `plate` varchar(10) COLLATE utf8mb4_bin NOT NULL,
  `model` tinytext COLLATE utf8mb4_bin NOT NULL,
  `lastSeen` tinytext COLLATE utf8mb4_bin NOT NULL,
  `color` tinytext COLLATE utf8mb4_bin NOT NULL,
  `description` text COLLATE utf8mb4_bin NOT NULL,
  `reason` text COLLATE utf8mb4_bin NOT NULL,
  `notes` text COLLATE utf8mb4_bin NOT NULL,
  `date` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `mdt_veh_profiles` (
  `plate` varchar(10) COLLATE utf8mb4_bin NOT NULL,
  `model` tinytext COLLATE utf8mb4_bin NOT NULL,
  `color` tinytext COLLATE utf8mb4_bin NOT NULL,
  `photoId` text COLLATE utf8mb4_bin NOT NULL,
  `notes` text COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `mdt_warrants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator` tinytext COLLATE utf8mb4_bin NOT NULL,
  `name` tinytext COLLATE utf8mb4_bin NOT NULL,
  `lastSeen` tinytext COLLATE utf8mb4_bin NOT NULL,
  `reason` text COLLATE utf8mb4_bin NOT NULL,
  `description` text COLLATE utf8mb4_bin NOT NULL,
  `notes` text COLLATE utf8mb4_bin NOT NULL,
  `date` bigint(20) NOT NULL,
  `targetIdentifier` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
