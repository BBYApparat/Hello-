DELETE FROM items WHERE name = 'armbrace';
DELETE FROM items WHERE name = 'bandage';
DELETE FROM items WHERE name = 'bodybandage';
DELETE FROM items WHERE name = 'firstaid';
DELETE FROM items WHERE name = 'legbrace';
DELETE FROM items WHERE name = 'lucas3';
DELETE FROM items WHERE name = 'medicalbag';
DELETE FROM items WHERE name = 'medicinebox';
DELETE FROM items WHERE name = 'medikit';
DELETE FROM items WHERE name = 'morphine10';
DELETE FROM items WHERE name = 'morphine30';
DELETE FROM items WHERE name = 'neckbrace';
DELETE FROM items WHERE name = 'paracetamol';
DELETE FROM items WHERE name = 'saline';
DELETE FROM items WHERE name = 'stretcher';
DELETE FROM items WHERE name = 'syringe';
DELETE FROM items WHERE name = 'wheelchair';
DELETE FROM items WHERE name = 'xray';


INSERT INTO `items` (`name`, `label`, `weight`) VALUES
    ('armbrace', 'Armbrace', 1),
    ('bandage', 'Bandage', 1),
    ('bodybandage', 'Body Bandage', 1),
    ('firstaid', 'Firstaid', 1),
    ('legbrace', 'Legbrace', 1),
    ('lucas3', 'Lucas 3', 1),
    ('medicalbag', 'Medical Bag', 1),
    ('medicinebox', 'Medicine Box', 1),
    ('medikit', 'Medikit', 1),
    ('morphine10', 'Morphine 10mg', 1),
    ('morphine30', 'Morphine 30mg', 1),
    ('neckbrace', 'Neckbrace', 1),
    ('paracetamol', 'Paracetamol', 1),
    ('saline', 'Saline', 1),
    ('stretcher', 'Stretcher', 1),
    ('syringe', 'Syringe', 1),
    ('wheelchair', 'Wheelchair', 1),
    ('xray', 'X-Ray Scanner', 1)
;
