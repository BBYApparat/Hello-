-- Company Reviews Database Schema

-- Companies table
CREATE TABLE IF NOT EXISTS `company_reviews_companies` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL UNIQUE,
    `description` TEXT,
    `category` VARCHAR(50) NOT NULL,
    `image_url` VARCHAR(255) DEFAULT NULL,
    `owner_identifier` VARCHAR(60) DEFAULT NULL, -- Player identifier who owns/manages the company
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_category` (`category`),
    INDEX `idx_owner` (`owner_identifier`)
);

-- Reviews table
CREATE TABLE IF NOT EXISTS `company_reviews_reviews` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `company_id` INT NOT NULL,
    `reviewer_identifier` VARCHAR(60) NOT NULL,
    `reviewer_name` VARCHAR(100) NOT NULL,
    `rating` TINYINT NOT NULL CHECK (`rating` >= 1 AND `rating` <= 5),
    `review_text` TEXT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`company_id`) REFERENCES `company_reviews_companies`(`id`) ON DELETE CASCADE,
    UNIQUE KEY `unique_review` (`company_id`, `reviewer_identifier`), -- One review per person per company
    INDEX `idx_company` (`company_id`),
    INDEX `idx_reviewer` (`reviewer_identifier`)
);

-- Company replies to reviews
CREATE TABLE IF NOT EXISTS `company_reviews_replies` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `review_id` INT NOT NULL,
    `company_id` INT NOT NULL,
    `reply_text` TEXT NOT NULL,
    `replied_by` VARCHAR(60) NOT NULL, -- Identifier of company owner/manager who replied
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`review_id`) REFERENCES `company_reviews_reviews`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`company_id`) REFERENCES `company_reviews_companies`(`id`) ON DELETE CASCADE,
    UNIQUE KEY `unique_reply` (`review_id`), -- One reply per review
    INDEX `idx_review` (`review_id`),
    INDEX `idx_company` (`company_id`)
);

-- Insert some sample data
INSERT IGNORE INTO `company_reviews_companies` (`name`, `description`, `category`, `image_url`, `owner_identifier`) VALUES 
('Joe\'s Diner', 'Classic American diner serving comfort food 24/7', 'restaurant', 'https://example.com/images/joes-diner.jpg', NULL),
('Tech Solutions Inc', 'Professional IT services and computer repair for businesses and individuals', 'services', 'https://example.com/images/tech-solutions.jpg', NULL),
('Downtown Auto Repair', 'Full service auto repair shop with certified mechanics', 'automotive', 'https://example.com/images/auto-repair.jpg', NULL),
('Metro Shopping Mall', 'Large shopping center with over 100 stores and restaurants', 'retail', 'https://example.com/images/shopping-mall.jpg', NULL),
('City General Hospital', 'Full-service hospital providing comprehensive healthcare services', 'healthcare', 'https://example.com/images/hospital.jpg', NULL);

-- Insert sample reviews
INSERT IGNORE INTO `company_reviews_reviews` (`company_id`, `reviewer_identifier`, `reviewer_name`, `rating`, `review_text`) VALUES 
(1, 'sample_user_1', 'John Doe', 5, 'Amazing burgers and great service! Will definitely come back.'),
(1, 'sample_user_2', 'Sarah Miller', 4, 'Good food but a bit slow during rush hours.'),
(1, 'sample_user_3', 'Mike Johnson', 5, 'Best pancakes in the city! Staff is super friendly.'),
(2, 'sample_user_1', 'John Doe', 5, 'Fixed my laptop quickly and professionally. Highly recommended!'),
(2, 'sample_user_4', 'Lisa Chen', 4, 'Good service but a bit expensive compared to other places.'),
(3, 'sample_user_2', 'Sarah Miller', 4, 'Fair prices and honest work. They explained everything clearly.'),
(3, 'sample_user_5', 'Tom Wilson', 3, 'Got the job done but took longer than expected.');

-- Insert sample company replies
INSERT IGNORE INTO `company_reviews_replies` (`review_id`, `company_id`, `reply_text`, `replied_by`) VALUES 
(2, 1, 'Thank you for your feedback! We are working on improving our service speed during peak hours. We appreciate your patience!', 'joes_diner_owner'),
(5, 2, 'Thank you for choosing Tech Solutions! We strive to provide quality service. Please contact us if you have any concerns about pricing.', 'tech_solutions_owner'),
(7, 3, 'We apologize for the delay. We always prioritize quality work, but we understand your time is valuable. Thank you for your business!', 'auto_repair_owner');