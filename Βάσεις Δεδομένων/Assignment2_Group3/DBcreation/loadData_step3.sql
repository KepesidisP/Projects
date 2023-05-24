SET GLOBAL local_infile=1;
SET FOREIGN_KEY_CHECKS=0;
load data local infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Doctor.csv' 
INTO TABLE doctor
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
set F_name= @col1,L_name=@col2,ssn=@col3,phoneNo=@col5,Bdate=@col4,salary=@col10,specialty=@col11,streetN=@col6,streetName=@col7,city=@col8,postcode=@col9;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Nurse.csv' 
INTO TABLE nurse
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10)
set F_name=@col1, L_name=@col2, ssn=@col3, phoneNo=@col5, Bdate=@col4, streetN=@col6, streetName=@col7, city=@col8, postcode=@col9, salary=@col10;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Patient.csv' 
INTO TABLE patient
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11, @col12, @col13, @col14)
set F_name=@col1, L_name=@col2, ssn=@col3, phoneNo=@col5, Bdate=@col4, streetN=@col6, streetName=@col7, city=@col8, postcode=@col9, sex=@col10, diagnosis=@col11, admitDate=@col12, R_num=@col13 , C_code=@col14;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/General.csv' 
INTO TABLE general_staff
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11)
set F_name=@col1, L_name=@col2, ssn=@col3, phoneNo=@col5, Bdate=@col4, salary=@col10, r_type=@col11, streetN=@col6, streetName=@col7, city=@col8, postcode=@col9;

load data local infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Room.csv' 
INTO TABLE room
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@col1, @col2, @col3, @col4)
set RoomNum= @col1, C_code=@col2, size=@col3,floor=@col4, N_ssn=(SELECT ssn FROM nurse ORDER BY rand() limit 1);

load data local infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/operates.csv' 
INTO TABLE operates
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@col1, @col2, @col3)
set Op_name= @col1, Op_date=@col2, Op_type=@col3, Doc_ssn=(SELECT ssn FROM doctor ORDER BY rand() limit 1), Pat_ssn=(select ssn from patient order by rand() limit 1);

load data local infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prescribes.csv' 
INTO TABLE prescribes
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@col1, @col2, @col3, @col4, @col5)
set Med_name=@col1, Start_date=@col2, End_date=@col3, Dosage=@col4, Side_eff=@col5, Doc_ssn=(SELECT ssn FROM doctor ORDER BY rand() limit 1), Pat_ssn=(select ssn from patient order by rand() limit 1);

insert into clinic values('Cardiology','CRD313','164203528');
insert into clinic values('Pathology','PTH323','468477983');
insert into clinic values('Pulmonology','PLM333','440154834');
insert into clinic values('Radiology','RDL443','789543904');
insert into clinic values('Intensive_Care','INT453','084090129');
insert into clinic values('Primary_Care','PRM063','064497470');
insert into clinic values('Orthopedics','ORT173','390463079');
insert into clinic values('Dermatology','DRM183','284904122');
insert into clinic values('Neurology','NRL293','141081210');

SET FOREIGN_KEY_CHECKS=1;