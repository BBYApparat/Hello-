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

-- ----------------------------
-- Table structure for bby_housing_properties (Config Houses)
-- ----------------------------
DROP TABLE IF EXISTS `bby_housing_properties`;
CREATE TABLE `bby_housing_properties` (
  `house_id` int(11) NOT NULL,
  `coords_x` float NOT NULL,
  `coords_y` float NOT NULL,
  `coords_z` float NOT NULL,
  `garage_x` float NOT NULL,
  `garage_y` float NOT NULL,
  `garage_z` float NOT NULL,
  `house_type` enum('poor','medium','luxury') NOT NULL,
  `base_price` int(11) NOT NULL,
  PRIMARY KEY (`house_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- Insert all houses from config
INSERT INTO `bby_housing_properties` VALUES 
(1, -174.35, -1436.23, 31.24, -178.35, -1436.23, 31.24, 'poor', 35000),
(2, -127.31, -1457.54, 33.89, -131.31, -1457.54, 33.89, 'poor', 40000),
(3, 119.15, -1461.14, 29.14, 115.15, -1461.14, 29.14, 'poor', 30000),
(4, 312.24, -1956.26, 24.62, 308.24, -1956.26, 24.62, 'poor', 28000),
(5, 348.78, -1820.93, 28.89, 344.78, -1820.93, 28.89, 'poor', 32000),
(6, -9.53, -1438.54, 31.1, -13.53, -1438.54, 31.1, 'medium', 75000),
(7, 23.11, -1447.06, 30.89, 19.11, -1447.06, 30.89, 'medium', 70000),
(8, 1259.48, -1761.87, 49.66, 1255.48, -1761.87, 49.66, 'medium', 85000),
(9, 1379.58, -1515.85, 56.9, 1375.58, -1515.85, 56.9, 'medium', 90000),
(10, 1006.04, -1337.28, 31.90, 1002.04, -1337.28, 31.90, 'medium', 80000),
(11, 1210.73, -1228.35, 35.22, 1206.73, -1228.35, 35.22, 'luxury', 150000),
(12, 1323.18, -1651.88, 52.23, 1319.18, -1651.88, 52.23, 'luxury', 160000),
(13, -1149.71, -1520.83, 10.63, -1153.71, -1520.83, 10.63, 'luxury', 200000),
(14, -1308.05, -1228.68, 4.89, -1312.05, -1228.68, 4.89, 'luxury', 180000),
(15, -820.02, -1073.32, 11.33, -824.02, -1073.32, 11.33, 'luxury', 170000);

-- Insert sample entries for houses as available (unowned) in main bby_housing table
-- NOTE: Remove these if you want all houses to start unowned, or keep specific ones for testing
-- INSERT INTO `bby_housing` (house_id, identifier, house_type, purchased_at) VALUES 
-- (1, 'sample_player_id', 'poor', NOW());

SET FOREIGN_KEY_CHECKS = 1;