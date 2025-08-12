-- Police MDT System Database Tables
-- Execute this SQL file to set up the required tables

-- Ensure the users table has state_id column (for compatibility with existing ESX setup)
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `state_id` INT(11) DEFAULT NULL;

-- Table for citizen notes added by officers
CREATE TABLE IF NOT EXISTS `police_mdt_notes` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizen_id` varchar(60) NOT NULL,
    `officer_id` varchar(60) NOT NULL,
    `officer_name` varchar(100) NOT NULL,
    `note` text NOT NULL,
    `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `citizen_id` (`citizen_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table for citizen violations added by officers
CREATE TABLE IF NOT EXISTS `police_mdt_violations` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizen_id` varchar(60) NOT NULL,
    `officer_id` varchar(60) NOT NULL,
    `officer_name` varchar(100) NOT NULL,
    `violation` text NOT NULL,
    `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `citizen_id` (`citizen_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table for current active crimes
CREATE TABLE IF NOT EXISTS `police_mdt_crimes` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `type` varchar(100) NOT NULL,
    `location` text NOT NULL,
    `description` text,
    `reported_by` varchar(60),
    `status` varchar(50) NOT NULL DEFAULT 'active',
    `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table for police records (comprehensive history)
CREATE TABLE IF NOT EXISTS `police_mdt_records` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizen_id` varchar(60) NOT NULL,
    `officer_id` varchar(60) NOT NULL,
    `officer_name` varchar(100) NOT NULL,
    `type` varchar(100) NOT NULL,
    `description` text NOT NULL,
    `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `citizen_id` (`citizen_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert some sample crimes for testing
INSERT IGNORE INTO `police_mdt_crimes` (`type`, `location`, `description`, `reported_by`, `status`) VALUES
('Vehicle Theft', 'Legion Square', 'Red sedan stolen from parking lot', 'Citizen Report', 'active'),
('Robbery', 'Fleeca Bank Downtown', 'Armed robbery in progress', '911 Call', 'active'),
('Assault', 'Grove Street', 'Fight reported outside bar', 'Anonymous Tip', 'active'),
('Drug Deal', 'Davis Avenue', 'Suspicious activity near alley', 'Police Patrol', 'active'),
('Burglary', 'Vinewood Hills', 'Break-in at residential property', 'Homeowner', 'active');