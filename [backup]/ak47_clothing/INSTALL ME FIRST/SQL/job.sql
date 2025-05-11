DELETE FROM `addon_account` WHERE `name` = 'society_nailsalon';
INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_nailsalon', 'nailsalon', 1)
;

DELETE FROM `jobs` WHERE `name` = 'nailsalon';
INSERT INTO `jobs` (name, label) VALUES
	('nailsalon', 'Nail Salon')
;

DELETE FROM `job_grades` WHERE `job_name` = 'nailsalon';
INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('nailsalon',0,'employee','employee',20,'{}','{}'),
	('nailsalon',1,'boss','Owner',100,'{}','{}')
;



DELETE FROM `addon_account` WHERE `name` = 'society_tattoo';
INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_tattoo', 'tattoo', 1)
;

DELETE FROM `jobs` WHERE `name` = 'tattoo';
INSERT INTO `jobs` (name, label) VALUES
	('tattoo', 'Tattoo')
;

DELETE FROM `job_grades` WHERE `job_name` = 'tattoo';
INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('tattoo',0,'employee','employee',20,'{}','{}'),
	('tattoo',1,'boss','Owner',100,'{}','{}')
;
