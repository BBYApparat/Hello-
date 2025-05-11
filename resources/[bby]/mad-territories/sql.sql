CREATE TABLE IF NOT EXISTS `graffitis` (
  `key` int(11) NOT NULL AUTO_INCREMENT,
  `gang` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `coords` varchar(200) DEFAULT NULL,
  `rotation` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `gangs_reputation` (
  `gang` varchar(255) NOT NULL,
  `rep` int(11) DEFAULT 0,
  PRIMARY KEY (`gang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- A despejar dados para tabela qboxproject_7306e5.gangs_reputation: ~3 rows (aproximadamente)
DELETE FROM `gangs_reputation`;
INSERT INTO `gangs_reputation` (`gang`, `rep`) VALUES
	('ballas', 0),
	('lostmc', 0),
	('vagos', 0);
