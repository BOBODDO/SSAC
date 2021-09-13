select f_rand1('김이박');

select f_rand1('123456789');

select f_randname();

insert into Emp(ename, dept, salary) values (f_randname(), f_rand1('34567'), f_rand1('123456789')*100);

select * from Emp;

call sp_test_emp(250);

select dept, count(*) from Emp group by dept;