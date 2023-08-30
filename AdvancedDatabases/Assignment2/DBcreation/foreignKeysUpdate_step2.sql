alter table doctor add FOREIGN KEY(C_code) REFERENCES clinic(C_code);

alter table room add (FOREIGN KEY(C_code) REFERENCES clinic(C_code), FOREIGN KEY(N_ssn) REFERENCES nurse(ssn) on update cascade);

alter table patient add FOREIGN KEY(R_num, C_code) REFERENCES room(RoomNum, C_code) on update cascade;

alter table prescribes add (FOREIGN KEY(Pat_ssn) REFERENCES patient(ssn) on update cascade, FOREIGN KEY(Doc_ssn) REFERENCES doctor(ssn) on update cascade);

alter table operates add (FOREIGN KEY(Pat_ssn) REFERENCES patient(ssn) on update cascade, FOREIGN KEY(Doc_ssn) REFERENCES doctor(ssn) on update cascade);

alter table clinic add FOREIGN KEY(Mng_Doc_ssn) REFERENCES doctor(ssn) on update cascade;

alter table nurse_assigned_to add (FOREIGN KEY(C_code) REFERENCES clinic(C_code) on delete cascade on update cascade, FOREIGN KEY(Nurse_ssn) REFERENCES nurse(ssn) on delete cascade on update cascade);

alter table staff_assigned_to add (FOREIGN KEY(C_code) REFERENCES clinic(C_code) on delete cascade on update cascade, FOREIGN KEY(Gen_ssn) REFERENCES general_staff(ssn) on delete cascade on update cascade);
