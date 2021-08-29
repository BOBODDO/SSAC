#grade 테이블 : 중간고사, 기말고사 성적을 저장해야한다.

create table Grade(
	id int unsigned not null auto_increment primary key,
    midterm tinyint unsigned not null default 0,
    finalterm tinyint unsigned not null default 0,   
    enroll int unsigned,
    constraint foreign key fk_enroll(enroll) references Enroll(id)
);

show create table Grade;

insert into Grade(enroll,midterm,finalterm)
	select id, mod(id,50) + 50, mod(id,50) + 50 from Enroll;
    
select count(*), (select count(*) from Enroll) from Grade;

#과목명 학생명 중간 기말 총점 평균 학점 REPORT

select sub.*,
	(case when avr >= 90 then 'A'
		  when avr >= 80 then 'B'
          when avr >= 80 then 'C'
          else 'F' end) '평점'
	from (
select sbj.name '과목명', stu.name '학생명', g.midterm, g.finalterm, (g.midterm + g.finalterm) total, (g.midterm + g.finalterm)/2 avr
	from Grade g inner join Enroll e on g.enroll = e.id
				inner join Subject sbj on e.subject = sbj.id
                inner join Student stu on e.student = stu.id
		) sub;
                
select * from Enroll;
select * from Grade;