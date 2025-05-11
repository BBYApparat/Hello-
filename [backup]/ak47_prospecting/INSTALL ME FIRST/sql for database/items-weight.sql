DELETE FROM items WHERE name = 'actioncam';
DELETE FROM items WHERE name = 'brokenglasses';
DELETE FROM items WHERE name = 'brokenpendrive';
DELETE FROM items WHERE name = 'brokenphone';
DELETE FROM items WHERE name = 'dianecklace';
DELETE FROM items WHERE name = 'gem';
DELETE FROM items WHERE name = 'goldchain';
DELETE FROM items WHERE name = 'goldrolex';
DELETE FROM items WHERE name = 'detector';
DELETE FROM items WHERE name = 'rustygun';
DELETE FROM items WHERE name = 'rustedrod';
DELETE FROM items WHERE name = 'weddingring';


INSERT INTO `items` (`name`, `label`, `weight`) VALUES
	('actioncam', 'Action Camera', 1),
	('brokenglasses', 'Broken Glasses', 1),
	('brokenpendrive', 'Broken Pendrive', 1),
	('brokenphone', 'Broken Phone', 1),
	('dianecklace', 'Dia Necklace', 1),
	('gem', 'Gem', 1),
	('goldchain', 'Gold Chain', 1),
	('goldrolex', 'Gold Rolex', 1),
	('detector', 'Detector', 1),
	('rustygun', 'Rusty Gun', 1),
	('rustedrod', 'Rusted Rod', 1),
	('weddingring', 'Wedding Ring', 1)
;
