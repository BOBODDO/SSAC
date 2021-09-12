#call sp_grade_stem_leaf('역사');
#강의에서 사용된 프로시저를 만드는 전용 SQL 탭 하나 더 생성

delimiter $$
create procedure sp_grade_stem_leaf(_subject_name varchar(31))
begin
	#선언은 모두 상위에 위치해야한다
	declare _isdone boolean default False;
    declare _avr tinyint;
    declare _stem tinyint;
    declare _leaf tinyint;
    
	declare cur_avrs cursor for
		select avr from v_grade_enroll
            where subject = (select id from Subject where name = _subject_name)
            order by avr;
            
	declare continue handler
		for not found set _isdone = True;
        
        
    drop table if exists t_grade; #1회 실행 후 초기화를 위해서, 임시 테이블 생성 후에는 최초에 초기화를 시켜주는게 좋다 
	create temporary table t_grade (
		stem tinyint default 0 primary key,
        leaf varchar(1024) default ''
    );
	
    open cur_avrs;
    
		loop1 : LOOP
				FETCH cur_avrs into _avr;
				#FETCH해온 내용을 가지고 수행할 작업
                set _stem = floor(_avr / 10);
                set _leaf = mod(_avr, 10);
                
				IF exists(select * from t_grade where stem = _stem) THEN
					update t_grade set leaf = concat(leaf, _leaf)
						where stem = _stem; #이미 뿌리가 존재하면 단순 update
				ELSE
					insert into t_grade value(_stem,_leaf); #없을때는 stem과 leaf값을 새로 생성해서 추가
				END IF;
				#작업 끝
				
				IF _isdone THEN
					LEAVE loop1;
				END IF;
			
			
		END LOOP loop1;
    
    close cur_avrs; #위에서 연 커서를 닫는다
	select * from t_grade; #TABLE을 읽어서 출력
end $$
delimiter ;

#order by를 뷰에서 하면 인덱스가 없는 쿼리이므로 성능이 굉장히 나빠진다
#VIEW에서 뽑아내고 나서 orderr by를 하는게 낫다