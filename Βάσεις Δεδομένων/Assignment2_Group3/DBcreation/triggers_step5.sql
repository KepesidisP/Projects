CREATE TRIGGER nurse_assigned AFTER INSERT ON nurse FOR EACH ROW INSERT INTO nurse_assigned_to set C_code=(SELECT C_code FROM clinic ORDER BY rand() limit 1), Nurse_ssn=NEW.ssn;
CREATE TRIGGER general_assigned AFTER INSERT ON general_staff FOR EACH ROW INSERT INTO staff_assigned_to set C_code=(SELECT C_code FROM clinic ORDER BY rand() limit 1), Gen_ssn=NEW.ssn;
