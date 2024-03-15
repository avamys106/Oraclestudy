create user WebStudy identified by 1234;

alter session set "_ORACLE_SCRIPT"=true;

grant create session to WebStudy;

grant create table to WebStudy;

grant connect, resource to WebStudy;

GRANT CONNECT, RESOURCE, unlimited tablespace TO WebStudy;

create sequence board_number
    increment by 1
    start with 1
    minvalue 1
    nomaxvalue 
    nocycle
    nocache;
    
create table member (
    id varchar2(20) not null,
    pass varchar2(20) not null,
    name varchar2(20) not null,
    email varchar2(50) not null,
    newdate date default sysdate not null,
    phone varchar2(30) not null,
    primary key (id)
);

insert into member (id, pass, name, email)
values ('avamys', '1234', '박성현', 'avamys106@naver.com');

commit;

select * from member;

insert into member ( id, pass, name, email)
values ('avamys3', '1234', '성현', 'ava@naver.com');

insert into member ( id, pass, name, email, newdate)
values ('avamys4', '1234', '성현', 'ava@naver.com', sysdate);


select pass from member where id = 'avamys';

select * from member where id = 'avamys';
commit;

delete from member where id = '123456';

create table freeboard (
    idx number primary key,
    id varchar2(20) not null,
    name varchar2(50) not null,
    title varchar2(200) not null,
    content varchar2(2000) not null,
    postdate date default sysdate not null,
    pass varchar2(50) not null,
    visitcount number default 0 not null
);

insert into freeboard (idx, id, name, title, content, pass)
    values (board_number.nextval, 'avamys', '박성현', '게시판테스트', '내용입니다', 1234);

insert into freeboard (idx, id, name, title, content, pass)
    values (board_number.nextval, 'thejoeun', '더조은', '게시판테스트', '내용입니다', 1234);

insert into freeboard (idx, id, name, title, content, pass)
    values (board_number.nextval, 'avamys', '더조은', 'test3', '내용', 1234);

drop table freeboard;

insert into freeboard ( idx, id, title, content, pass)
    values ( board_number.nextval, '1234', '1234', '1234', '1234');

select * from (select tb.*, rownum rNum
from ( select * from freeboard order by idx desc ) tb )
where rNum between 1 and 1;

alter table freeboard drop column name;

delete from freeboard where title = '3232';

alter table freeboard
    add constraint freeboard_member_fk foreign key (id)
    references member (id);

select id, title from freeboard where pass='1234' and idx=17;

delete from boardfree where idx=17;