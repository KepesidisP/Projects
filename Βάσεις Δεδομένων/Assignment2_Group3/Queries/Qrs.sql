#1
#select *
#from doctor
#where C_code=(select C_code from clinic where C_name='Cardiology');

#or
select *
from doctor
where C_code LIKE 'CRD%';

#2
select *
from patient
where patient.C_code like 'int%';

#3
select *
from patient
where admitDate between '2022-12-1' and '2022-12-31';

#4
insert into patient values ('John','Snow','142536798','3381687649','1972-11-26','Male','Angina','2022-08-14','NE05','NRL293',28, 'Winterfield St','North','NV 25831');

#5
update patient 
set postcode = 'MP 90230'
where ssn='032222707';

#6
select count(ssn)
from patient
where admitDate between '2022-12-1' and '2022-12-31';

#7
select *
from nurse
where ssn=(select N_ssn
			from room
			where RoomNum= 'CA03');
            
#8
update prescribes
set Med_name = 'Depon'
where Pat_ssn='268227876' and Doc_ssn='420327362';

#9
select count(*)
from patient
where diagnosis='Angina';

#10
select *
from general_staff 
where r_type='admin';


insert into doctor values('Kostas','Papadopoulos','251436788','2114563877','1998-2-25',278000,'Oncologist','PTH323','2738','Tsaldari','Keratsini','15568');
insert into patient values('Kostas','Mitroglou','255836788','2188563877','1980-10-30','Male','Headache','2022-10-29','PC03','PRM063','38','Saint George','Athens','18859');

update doctor set salary=150000 where ssn='251436788';
update patient set diagnosis='Broken leg' where ssn='255836788';

delete from doctor where ssn='251436788';
delete from patient where ssn='255836788';