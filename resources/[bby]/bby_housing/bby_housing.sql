SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for bby_housing
-- ----------------------------
DROP TABLE IF EXISTS `bby_housing`;
CREATE TABLE `bby_housing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `house_id` int(11) NOT NULL,
  `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `house_type` enum('poor','medium','luxury') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'poor',
  `purchased_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `house_id` (`house_id`) USING BTREE,
  KEY `identifier` (`identifier`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bby_housing_vehicles
-- ----------------------------
DROP TABLE IF EXISTS `bby_housing_vehicles`;
CREATE TABLE `bby_housing_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `house_id` int(11) NOT NULL,
  `plate` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `props` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `slot` int(1) NOT NULL DEFAULT 1,
  `stored_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `house_id` (`house_id`) USING BTREE,
  KEY `plate` (`plate`) USING BTREE,
  CONSTRAINT `bby_housing_vehicles_house_fk` FOREIGN KEY (`house_id`) REFERENCES `bby_housing` (`house_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bby_housing_raids
-- ----------------------------
DROP TABLE IF EXISTS `bby_housing_raids`;
CREATE TABLE `bby_housing_raids` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `house_id` int(11) NOT NULL,
  `officers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'JSON array of officer IDs',
  `evidence_found` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'JSON array of confiscated items',
  `raid_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `warrant_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Reference to warrant in MDT system',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `house_id` (`house_id`) USING BTREE,
  KEY `raid_date` (`raid_date`) USING BTREE,
  CONSTRAINT `bby_housing_raids_house_fk` FOREIGN KEY (`house_id`) REFERENCES `bby_housing` (`house_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bby_housing_doorbell
-- ----------------------------
DROP TABLE IF EXISTS `bby_housing_doorbell`;
CREATE TABLE `bby_housing_doorbell` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `house_id` int(11) NOT NULL,
  `visitor_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `visitor_identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ring_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `responded` tinyint(1) DEFAULT 0,
  `response_type` enum('invite','decline','no_response') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'no_response',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `house_id` (`house_id`) USING BTREE,
  KEY `ring_time` (`ring_time`) USING BTREE,
  KEY `visitor_identifier` (`visitor_identifier`) USING BTREE,
  CONSTRAINT `bby_housing_doorbell_house_fk` FOREIGN KEY (`house_id`) REFERENCES `bby_housing` (`house_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bby_housing_decorations
-- ----------------------------
DROP TABLE IF EXISTS `bby_housing_decorations`;
CREATE TABLE `bby_housing_decorations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `house_id` int(11) NOT NULL,
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'JSON coordinates {x, y, z}',
  `rotation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'JSON rotation {x, y, z}',
  `placed_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `house_id` (`house_id`) USING BTREE,
  KEY `model` (`model`) USING BTREE,
  CONSTRAINT `bby_housing_decorations_house_fk` FOREIGN KEY (`house_id`) REFERENCES `bby_housing` (`house_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;