ALTER TABLE users DROP COLUMN IF EXISTS `is_down`;
ALTER TABLE users DROP COLUMN IF EXISTS `is_dead`;
ALTER TABLE users ADD `is_down` TINYINT(1) DEFAULT 0, ADD `is_dead` TINYINT(1) DEFAULT 0;

DROP TABLE IF EXISTS `ak47_ambulancejob`;
CREATE TABLE `ak47_ambulancejob` (
  `identifier` varchar(100) NOT NULL,
  `damages` longtext DEFAULT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
