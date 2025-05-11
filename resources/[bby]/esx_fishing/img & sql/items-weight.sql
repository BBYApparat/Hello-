DELETE FROM items WHERE name = 'catfish';
DELETE FROM items WHERE name = 'bluewhale';
DELETE FROM items WHERE name = 'goldfish';
DELETE FROM items WHERE name = 'largemouthbass';
DELETE FROM items WHERE name = 'redfish';
DELETE FROM items WHERE name = 'salmon';
DELETE FROM items WHERE name = 'stingray';
DELETE FROM items WHERE name = 'stripedbass';
DELETE FROM items WHERE name = 'whale';
DELETE FROM items WHERE name = 'fishingrod';
DELETE FROM items WHERE name = 'fishingbait';

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
	('catfish', 'Catfish', 0.5),
	('bluewhale', 'Bluewhale', 5),
	('goldfish', 'Goldfish', 0.1),
	('largemouthbass', 'Largemouth Bass', 1),
	('redfish', 'Redfish', 0.2),
	('salmon', 'Salmon', 0.4),
	('stingray', 'Stingray', 0.6),
	('stripedbass', 'Striped Bass', 0.8),
	('whale', 'Whale', 0.8),

	('fishingrod', 'Fishingrod', 1.2),
	('fishingbait', 'fishingbait', 0.1)
;
