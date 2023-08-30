create database hospitalDB;
use hospitalDB;
 
create table doctor(F_name varchar(20) NOT NULL, L_name varchar(20) NOT NULL, ssn varchar(9) NOT NULL, phoneNo varchar(10), 
Bdate date, salary int NOT NULL, specialty varchar(50) NOT NULL, C_code varchar(20) NOT NULL, streetN int, streetName varchar(50), city varchar(50), postcode varchar(50),
PRIMARY KEY(ssn) ); 

create table nurse(F_name varchar(20) NOT NULL, L_name varchar(20) NOT NULL, ssn varchar(9) NOT NULL, phoneNo varchar(10), 
Bdate date, salary int NOT NULL, streetN int, streetName varchar(50), city varchar(50), postcode varchar(50), 
PRIMARY KEY(ssn));

create table room(RoomNum varchar(6) NOT NULL, C_code varchar(20) NOT NULL, Size int, Floor int, N_ssn varchar(9),
PRIMARY KEY(RoomNum,C_code)); 

create table patient(F_name varchar(20) NOT NULL, L_name varchar(20) NOT NULL, ssn varchar(9) NOT NULL, phoneNo varchar(10), 
Bdate date, sex enum('Female','Male'), diagnosis varchar(80), admitDate date, R_num varchar(6) NOT NULL, C_code varchar(20) NOT NULL,  
streetN int, streetName varchar(50), city varchar(50), postcode varchar(50),
PRIMARY KEY(ssn)); 

create table prescribes(Med_name varchar(20) NOT NULL, Start_date date, End_date date, Dosage varchar(20), Side_eff varchar(20), 
Pat_ssn varchar(9) NOT NULL, Doc_ssn varchar(9) NOT NULL, 
PRIMARY KEY(Pat_ssn,Doc_ssn));

create table operates(Op_name varchar(20) NOT NULL, Op_date date, Op_type varchar(20), 
Pat_ssn varchar(9) NOT NULL, Doc_ssn varchar(9) NOT NULL,
PRIMARY KEY(Pat_ssn,Doc_ssn));

create table clinic(C_name varchar(20), C_code varchar(20) NOT NULL, Mng_Doc_ssn varchar(9) NOT NULL,
PRIMARY KEY(C_code));

create table nurse_assigned_to(C_code varchar(20) NOT NULL, Nurse_ssn varchar(9) NOT NULL, 
PRIMARY KEY(C_code,Nurse_ssn)); 

create table staff_assigned_to(C_code varchar(20) NOT NULL, Gen_ssn varchar(9) NOT NULL, 
PRIMARY KEY(C_code,Gen_ssn));

create table general_staff(F_name varchar(20) NOT NULL, L_name varchar(20) NOT NULL, ssn varchar(9) NOT NULL, phoneNo varchar(10), 
Bdate date, salary int NOT NULL, r_type enum('admin','technician','caretaker','kitchen_staff') NOT NULL, streetN int, streetName varchar(50), city varchar(50), postcode varchar(50), 
PRIMARY KEY(ssn) );
 