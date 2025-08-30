-- Add crowbar item to ox_inventory if it doesn't exist
INSERT IGNORE INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('crowbar', 'Crowbar', 500, 0, 1);

-- For ESX inventory systems, you might need this format instead:
-- INSERT IGNORE INTO `items` (`name`, `label`) VALUES
-- ('crowbar', 'Crowbar');