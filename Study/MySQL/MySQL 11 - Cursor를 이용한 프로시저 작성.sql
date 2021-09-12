#MySQL 11 - Cursor를 이용한 프로시저 작성

drop procedure if exists sp_club_members;
delimiter $$
create procedure sp_club_members(_club_name varchar(31))
begin
	select s.name,
    (case cm.level
		when 2 then '회장'
        when 1 then '간부'
        else '평회원' end) level_name
	from ClubMember cm inner join Student s on cm.student = s.id
    where club = (select id from Club where name = _club_name)
    order by cm.level desc;
end $$
delimiter ;

#case를 통해서 각 경우에 대해 보기좋게 출력하고 있고, inner join과 서브쿼리가 사용되었다.
#보기좋게 하기 위하여 order by 옵션을 사용

#Cursor Loop 의 시작
/*
select (*) 를 하더라도 전체 테이블의 모든 Row를 한꺼번에 읽어오지는 않는다.
한줄식 읽어오고(open) > Fetch해서 값을 각 공간에 가져오고 > 다음 Row를 읽는다

Declare > Declare Continue Handler > Open > Fetch > Close

Exception 처리 부분이 존재한다 : 파이썬에서의 Try n Catch 
만약 exit옵션이면 > 에러 발생 후 종료
Continue 옵션이면 > 에러 발생 후 exception 부분을 받아서 처리하고, 이어서 실행한다
*/

#뷰를 이용하지 말고, 그냥 쿼리를 이용해보자
/*select floor(avr / 10), group_concat(mod(avr,10)) from v_grade_enroll
	where subject = 1
    group by floor(avr / 10);*/

#group_concat 값을 orderby 하기 위해서 cursor을 사용해보자(프로시저 내부에서)
call sp_grade_stem_leaf('역사');
#끝


