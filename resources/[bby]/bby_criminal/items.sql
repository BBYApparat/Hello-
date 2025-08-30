-- Add items to ox_inventory if they don't exist
INSERT IGNORE INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('crowbar', 'Crowbar', 500, 0, 1),
('lockpick', 'Lockpick', 50, 0, 1),
('envelope', 'Envelope', 10, 0, 1);

-- For ESX inventory systems, you might need this format instead:
-- INSERT IGNORE INTO `items` (`name`, `label`) VALUES
-- ('crowbar', 'Crowbar'),
-- ('lockpick', 'Lockpick'),
-- ('envelope', 'Envelope');