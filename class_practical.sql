show databases;
create database student;
create database students;
drop database students;
show databases;
use student;
create table stud_details(sid int primary key, sname varchar(20), sage int, sclass int);
show tables;
drop table stud_details;
select * from stud_details;
insert into stud_details values(1, "Sonali", 10, 4);
insert into stud_details values(2, "Miya", 10, 4), (3, "Diya", 11, 5), (4, "Jiya", 10, 4), (5, "Riya", 12, 6), (6, "Siya", 8, 2);

use student;
select sname,sclass from stud_details;
select * from stud_details where sclass=5;
select sname,sage from stud_details where sage=10;
update stud_details set sname="Vipul" where sid=2;
update stud_details set sage=8 where sname="Jiya";
delete from stud_details where sid=3;
select * from stud_details;
alter table stud_details add sloc varchar(30);
alter table stud_details drop column sloc;
desc stud_details;
alter table stud_details rename column sage to stud_age;
alter table stud_details modify sname varchar(50);
alter table stud_details rename to stud_data;
select * from stud_data;
drop table stud_data;
show tables;
truncate table stud_data;

-- Schema is nothing but database (collection of tables)
create schema classonl;
use classonl;
create table Learners(Studid int, Stud_name varchar(20), Department varchar(30), Marks int, Age int);
insert into Learners values(101, "Jhon", "ECE", 89, 21), (102, "Ram", "CSE", 78, 21), (103, "Sam", "ECE", 86, 21), (104, "Raj", "CSE", 76, 21), (105, "Mary", "ECE", 67, 21), (106, "Smith", "CSE", 87, 21), (107, "Sony", "ECE", 91, 21), (108, "Doj", "CSE", 97, 21);
select * from Learners;
select Stud_name from Learners;

-- Aggregate Functions
select count(*) from Learners;
select avg(Marks) from Learners;
select min(Marks) from Learners;
select max(Marks) from Learners;

update Learners set studid=102 where stud_name="Sam";
set sql_safe_updates = 0;
select * from Learners order by Marks desc limit 3;
select * from Learners order by Marks;
select count(*),department from Learners group by department;
select avg(Marks) as average from Learners group by department; -- Changes the column name of the output column with the given name
select min(Marks),department from Learners group by department;

-- delete s1 from students s1 join students s2 on s1.student_id=s2.student_id and s1.id>s2.id;
-- select stu_id , count(*) from students group by student_id having count(*)>1
-- alter table students add constraint unique_student_id unique (student_id);

-- where and having clause used for adding condition in the query but where clause can be used in any query but cannot be used in the query where group by function is used so having clause is used in the query where group by function is used.
select avg(salary),department from employee group by department having avg(salary)<50000;

-- Constraints

create schema constraints;
use constraints;
show schemas;
-- "not null" means does not allowed empty data and "unique" means does not allow duplicate data, "check" ensures that salary must be greater than 50000, it will not allow to enter data below the 50000.
create table employee(
	emp_id int primary key auto_increment,
    ename varchar(30) not null,
    job_des varchar(30) default "unassigned",
    salary int,
    pan varchar(30) unique,
    check(salary>50000)
);
insert into employee values(1, "William", "Dev", 60000, "9878987890PR");
select * from employee;
insert into employee values("", "Raj", "", 60000, "VS78987890PR");
drop table employee;

create table employee_w_const(
	emp_id int primary key,
    ename varchar(30),
    job_des varchar(30),
    salary int,
    pan varchar(30)
);

alter table employee_w_const modify ename varchar(50) not null;
alter table employee_w_const alter job_des set default 'unassigned';
alter table employee_w_const alter job_des drop default;
desc employee_w_const;


-- TCL (Translation Control Language) : save point, roll back, commit

-- Without savepoint:
-- When u use roll back without any savepoint , the database returns to the last
--  Committed state
-- U cannot undo only  a part - every thing will be rollbaced

-- With savepoint;
-- When u create a savepoint u mark a specific spot in the transaction.
-- Using roll back to save point only the changes made after that save point
-- Are undone

create table patient_info (p_id int, p_name varchar(30), bp float, p_age int, gender varchar(30));
insert into patient_info values(121, "Riya", 98.6, 26, "Female"), (122, "Priya", 112.6, 34, "Female"), (123, "Ram", 118.6, 45, "Male");
select * from patient_info;
start transaction; -- Need to start first to save the points
savepoint sp1; -- Saves the work until executing this, when u use roll back without any savepoint the database returns to the last commited state.
insert into patient_info values(124, "Piya", 100.6, 30, "Female");
rollback to sp1; -- rollback/revert the work until the last savepoint
savepoint sp2;
delete from patient_info where p_id = 124;
rollback to sp2;

commit; -- commit the changes in the current transaction, after this cannot do rollback, changes saves permanently

-- DCL (Data Control Language)
-- DCL→data control language
-- It is used to control access to data stored in a database 
-- Dcl commands manage permissions, security levels, and user 
-- Privileges so that only authorized users can access or perform 
-- Operations on the database.

show databases;
-- user management -
-- select user --
select user from mysql.user;
-- create new user --
create user DSONL identified by "p@ss";
-- what are the permission he have --
show grants for DSONL;
-- using grant
grant select on mydb.* to DSONL; 
grant update,insert on mydb.* to DSONL;
grant all privileges on mydb.* to DSONL;
-- using revoke
revoke all privileges on mydb.* from DSONL;

-- Show current user
select user();
select current_user();

-- show current logged user
select user,host,db,command from information_schema.processlist;

-- change password using below two methods
set password for DSONL="admin";
alter user DSONL identified by "1234";

-- SQL JOINS:
-- Joins are used to combine data or row from two or more tables based
-- On a common column between them

-- Inner join:  returns only matching rows from both tables.

create schema joins;
use joins;
create table students(id int, s_name varchar(20));
insert into students values(1, "Alias"), (2, "Jhony"), (3, "Henry");
create table grades(id int, grade varchar(20));
insert into grades values(1, "A"), (2, "B"), (3, "C");

select students.s_name, grades.grade from students inner join grades on students.id = grades.id;
-- select students.s_name, grades.grade from students full outer join grades on students.id = grades.id; -- outer join not supported by mysql instead we can use left and right joins
select students.s_name, grades.grade from students left join grades on students.id = grades.id union select students.s_name, grades.grade from students right join grades on students.id = grades.id;

-- Sql subqueries:
-- A subquery is a sql query inside another sql query.

-- You use subqueries to:
-- 1.filter results
-- 2.compare values
-- 3.use one query’s result inside another.

use classonl;
show tables;
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    salary INT,
    department VARCHAR(30),
    role VARCHAR(50)
);

INSERT INTO employees (emp_id, employee_name, salary, department, role) VALUES
(1, 'Arjun', 50000, 'HR', 'HR Executive'),
(2, 'Meera', 60000, 'IT', 'Software Engineer'),
(3, 'Rahul', 50000, 'Finance', 'Accountant'),
(4, 'Kavya', 70000, 'IT', 'Senior Developer'),
(5, 'Varun', 45000, 'Sales', 'Sales Associate'),
(6, 'Priya', 60000, 'HR', 'HR Manager'),
(7, 'Sanjay', 45000, 'Marketing', 'Marketing Executive'),
(8, 'Divya', 70000, 'IT', 'Senior Developer'),
(9, 'Rohit', 55000, 'Finance', 'Financial'),
(8, 'Divya', 70000, 'IT', 'Senior Developer'),
(9, 'Rohit', 55000, 'Finance', 'Financial Analyst'),
(10, 'Sneha', 50000, 'Sales', 'Sales Executive');

select max(salary)as max_sal from employees;
select employee_name, salary from employees where salary=70000;
select employee_name,salary from employees where salary=(select min(salary) as minimum_sal from employees);
select employee_name,salary from employees where salary=(select max(salary) as maximum_sal from employees);
select * from employees;

-- Definition
-- MongoDB is an open-source, NoSQL database that stores data in flexible, JSON-like documents instead of tables. It is designed for high performance, horizontal scalability, and the ability to handle unstructured or semi-structured data.












