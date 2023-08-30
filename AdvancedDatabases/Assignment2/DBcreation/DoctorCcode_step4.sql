SET SQL_SAFE_UPDATES = 0;
update doctor
set C_code=( select c.C_code
			from clinic c
			where c.C_name like 'int%')
where doctor.specialty like 'An%';

update doctor
set C_code=( select c.C_code
			from clinic c
			where c.C_name like 'int%')
where doctor.specialty like 'gen%';

update doctor
set C_code=( select c.C_code
			from clinic c
			where c.C_name like 'car%')
where doctor.specialty like 'car%';

update doctor
set C_code=( select c.C_code
			from clinic c
			where c.C_name like 'der%')
where doctor.specialty like 'der%';

update doctor
set C_code=( select c.C_code
			from clinic c
			where c.C_name like 'neu%')
where doctor.specialty like 'neu%';

update doctor
set C_code=( select c.C_code
			from clinic c
			where c.C_name like 'pri%')
where doctor.specialty like 'onc%';

update doctor
set C_code=( select c.C_code
			from clinic c
			where c.C_name like 'ort%')
where doctor.specialty like 'ort%';

update doctor
set C_code=( select c.C_code
			from clinic c
			where c.C_name like 'pat%')
where doctor.specialty like 'pat%';

update doctor
set C_code=( select c.C_code
			from clinic c
			where c.C_name like 'pul%')
where doctor.specialty like 'pul%';

update doctor
set C_code=( select c.C_code
			from clinic c
			where c.C_name like 'rad%')
where doctor.specialty like 'rad%';


