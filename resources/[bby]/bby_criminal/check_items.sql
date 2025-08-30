-- Check if items exist in your database
-- Run this query to see if the items are registered:

SELECT * FROM items WHERE name IN ('envelope', 'lockpick', 'crowbar');

-- If they don't exist, run this to add them:
INSERT IGNORE INTO `items` (`name`, `label`, `weight`) VALUES
('envelope', 'Envelope', 10),
('lockpick', 'Lockpick', 50),
('crowbar', 'Crowbar', 500);

-- For ox_inventory, also check:
-- SELECT * FROM ox_inventory WHERE name IN ('envelope', 'lockpick', 'crowbar');