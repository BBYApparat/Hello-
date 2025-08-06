CREATE TABLE IF NOT EXISTS `business_ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_identifier` varchar(50) NOT NULL,
  `business_name` varchar(50) NOT NULL,
  `rating` tinyint(1) NOT NULL CHECK (rating >= 1 AND rating <= 5),
  `comment` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_business` (`user_identifier`, `business_name`),
  INDEX `idx_business_name` (`business_name`),
  INDEX `idx_user_identifier` (`user_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;