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
        
#과목명 평균 최고득점자 총학생수
select max(sbj.name) sbj_name, avg(g.midterm + g.finalterm) / 2 avr, count(*) stu_cnt,
		(select ss.name
	from Grade gg inner join Enroll ee on gg.enroll = ee.id
				  inner join Student ss on ee.student = ss.id
    where ee.subject = 1
    order by (gg.midterm + gg.finalterm) desc, gg.finalterm desc limit 1) '최고득점자'
	    from Grade g inner join Enroll e on g.enroll = e.id
				     inner join Subject sbj on e.subject = sbj.id
group by sbj.id;

#최고득점자 
select e.student
	from Grade g inner join Enroll e on g.enroll = e.id
    where e.subject = 1
    order by (g.midterm + g.finalterm) desc, g.finalterm desc limit 1;


#문제3 클럽이랑, 학생이랑 관계를 갖음

create table ClubMember(
	id smallint unsigned not null auto_increment primary key,
    club smallint unsigned not null,
    student int not null,
    level tinyint(1) unsigned not null default 0,
    constraint foreign key fk_club(club) references Club(id),
    constraint foreign key fk_student(student) references Student(id)
);

select * from Club;

select id, leader, 2 from Club where leader is not null;

insert into ClubMember(club, student, level)
	select id, leader, 2 from Club where leader is not null;
    
select * from ClubMember;

alter table Club drop column leader;
#오류가 발생한다 -> 외래키, 인덱스 등의 관계를 가지고 있기 때문이

show create table Club;
alter table Club drop foreign key Club_ibfk_1;
alter table Club drop index fk_leader_student;
alter table Club drop column leader;

select * from Club;

insert into ClubMember(club, student)
	select 1, id from Student
		where id not in (select student from ClubMember where club = 1)
        order by rand() limit 50;
        
select club, count(*) from ClubMember group by club;

update ClubMember set level=2
	where club = 1
	order by rand() limit 1;
    
select * from ClubMember;

#4번 문제
#pk(id) 학과명(name) 지도교수(prof) 과대표(student)

create table Dept(
	id smallint unsigned not null auto_increment primary key,
    name varchar(31) not null,
    prof smallint unsigned null,
    student int null,
    constraint foreign key fk_prof(prof) references Prof(id) on delete set null,
    constraint foreign key fk_student(student) references Student(id) on delete set null
);

select * from Prof;

select * from Prof order by rand() limit 5;

select '국문학과', id from Prof order by rand() limit 5;

update Dept set name=substring('국문학과,영문학과,물리학과,사회학과,역사학과', (id - 1)*5 +1,4) where id > 0;

select * from Dept;

alter table Student add column dept smallint unsigned;
alter table Student add constraint foreign key fk_dept(dept) references Dept(id);

select * from Student;

update Student set dept=(select id from Dept order by rand() limit 1) where id > 0;


#과대표를 배정
update Dept d set student = (select id from Student where dept=d.id order by rand() limit 1) where id >0;

select * from Dept;


#문제 5번
create table Classroom(
	id smallint unsigned not null auto_increment primary key,
    name varchar(31) not null
);

select * from Subject;

insert into Classroom(name)
select concat(ceil(rand(id)*10),id,'호') from Subject;

select * from Classroom;

alter table Subject add column classroom smallint unsigned;
alter table Subject add constraint foreign key fk_classroom(classroom) references Classroom(id);

desc Classroom;

select * from Subject;
update Subject set classroom = (11 - id) where id > 0;

select

