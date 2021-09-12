-- 9/12일 (일) MYSQL 10 Stored Function & Procedure

Delimiter $$
Create function f_student_count(_name varchar(100))
	RETURNS smallint
Begin
	return (select count(*) from Enroll
		where subject = (select id from Subject where name = _name));

End $$
Delimiter ;

select f_student_count('역사');
