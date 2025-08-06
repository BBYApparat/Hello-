-- Player mugshot cache table for okokBusinessApp
-- This table stores base64 encoded mugshots for fast loading

CREATE TABLE IF NOT EXISTS `player_mugshots` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `server_id` int(11) NOT NULL,
    `mugshot` LONGTEXT NOT NULL,
    `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `server_id` (`server_id`),
    INDEX `idx_server_id` (`server_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Clean up old mugshots (optional - run periodically to manage storage)
-- DELETE FROM player_mugshots WHERE updated_at < DATE_SUB(NOW(), INTERVAL 7 DAY);