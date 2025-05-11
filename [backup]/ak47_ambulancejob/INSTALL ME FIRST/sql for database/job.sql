DELETE FROM `addon_account` WHERE `name` = 'society_ambulance';
INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_ambulance', 'Ambulance', 1)
;
DELETE FROM `jobs` WHERE `name` = 'ambulance';
INSERT INTO `jobs` (name, label) VALUES
	('ambulance', 'Ambulance')
;
DELETE FROM `job_grades` WHERE `job_name` = 'ambulance';
INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('ambulance',0,'emt','EMT',20,'{}','{}'),
	('ambulance',1,'emtadvance','EMT Advance',40,'{}','{}'),
	('ambulance',2,'doctor','Doctor',60,'{}','{}'),
	('ambulance',3,'seniordoctor','Senior Doctor',100,'{}','{}'),
	('ambulance',4,'surgeon','Surgeon',100,'{}','{}'),
	('ambulance',5,'medicaladvisor','Medical Advisor',100,'{}','{}'),
	('ambulance',6,'assistantdirector','Assistant Director',100,'{}','{}'),
	('ambulance',7,'deputydirector','Deputy Director',100,'{}','{}'),
	('ambulance',8,'boss','Chief Director',100,'{}','{}')
;