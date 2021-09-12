-- 9/12일 (일) MYSQL 10 Stored Function & Procedure
DROP Procedure IF EXISTS sp_student_cnt; 
-- 존재하면 초기화하고 다시 생성
DELIMITER $$
CREATE Procedure sp_student_cnt(IN _subject_name varchar(31),
								OUT _stucnt smallint)
BEGIN
	select count(*) into _stucnt from Enroll
    where subject = (select id from Subject where name = _subject_name);
END $$
DELIMITER ;

call sp_student_cnt('역사',@cnt);

select * from Enroll;

# 변수 사용방법
# 아래에서는 v_sjb_id 변수를 만들어서 이용합니다.

DROP Procedure IF EXISTS sp_test;

DELIMITER $$
CREATE Procedure sp_test(_subject_name varchar(31))
BEGIN
	declare v_sbj_id smallint default 0;
    
    select id into v_sbj_id from Subject where name = _subject_name;
    
    select count(*) stu_cnt, avg(g.midterm + g.finalterm) avr
		from Enroll e inner join Grade g on e.id = g.enroll
        where e.subject = v_sbj_id; #위에서 정의한 v_sbj_id를 사용한다
        
END $$
DELIMITER ;


call sp_test('역사');
#함수와는 달리, 별도의 OUT부분을 잘 쓰지 않는다. 어차피 그냥 테이블로 결과를 출력하면 되니까

#정말 유용한 것 : SQL구문을 마치 String 처럼 저장하여 사용할 수 있다.

delimiter $$
create procedure sp_cnt(_table varchar(31))
begin
	set @sql = concat('select count(*) from ', _table);
    prepare myQuery from @sql; #컴파일을 진행하세요
	execute myQuery;
    deallocate prepare myQuery;
end $$
delimiter ;