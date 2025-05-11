ALTER TABLE `users` ADD COLUMN `jail_data` LONGTEXT NOT NULL DEFAULT '{"cell":0,"chest":[],"jailtime":0,"items":[],"clothes":[],"job":0,"breaks":0,"soli":0,"jobo":"nil","grade":0}';

INSERT INTO `jobs` (name, label) VALUES
	('prisoner', 'Prisoner')	
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('prisoner', 0, 'inmate', 'Inmate', 10, '{}', '{}')
;


INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES 
	('jail_jspoon', 'Broken Spoon', 0.5, 0, 1),
	('jail_spoon', 'Spoon', 0.5, 0, 1),
	('jail_bCloth', 'Broken Spoon With Wet Cloth', 0.5, 0, 1),
	('jail_wCloth', 'Wet Cloth', 0.5, 0, 1),
	('jail_cloth', 'Cloth', 0.5, 0, 1),
	('jail_cleaner', 'Cleaner', 0.5, 0, 1),
	('jail_file', 'File', 0.5, 0, 1),
	('jail_sMetal', 'Sharp Metal', 0.5, 0, 1),
	('jail_metal', 'Metal', 0.5, 0, 1),
	('jail_rock', 'Rock', 0.5, 0, 1),
	('jail_ladle', 'Ladle', 0.5, 0, 1),
	('jail_bLadle', 'Broken Ladle', 0.5, 0, 1),
	('jail_dLiquid', 'Dirty Liquid', 0.5, 0, 1),
	('jail_acid', 'Acid', 0.5, 0, 1),
	('jail_grease', 'Grease', 0.5, 0, 1),
	('jail_bottle', 'Bottle', 0.5, 0, 1),
	('jail_sChange', 'Spare Change', 0.5, 0, 1),
	('jail_shank', 'Shank', 0.5, 0, 1),
	('jail_miniH', 'Mini Hammer', -5, 0, 1),
	('jail_fPacket', 'Flavor Packet', 0.5, 0, 1),
	('jail_pPunch', 'Prison Punch', 0.5, 0, 1),
	('jail_iHeat', 'Immersion Heater', 0.5, 0, 1),
	('jail_plug', 'Plug', 0.5, 0, 1),
	('jail_booze', 'Booze', 0.5, 0, 1)
;