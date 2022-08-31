INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_blanchi','blanchi',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_blanchi','blanchi',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_blanchi', 'blanchi', 1)
;

INSERT INTO `jobs` (`name`, `label`) VALUES
('blanchi', "Blanchisseur")
;

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('blanchi', 0, 'novice', 'Débutant', 200, 'null', 'null'),
('blanchi', 1, 'expert', 'Expert', 400, 'null', 'null'),
('blanchi', 2, 'chef', "Bras droit", 600, 'null', 'null'),
('blanchi', 3, 'boss', 'Patron', 1000, 'null', 'null')
;
