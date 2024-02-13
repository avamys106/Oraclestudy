create sequence serial_num
    increment by 1
    start with 1
    minvalue 1 
    nomaxvalue 
    nocycle
    nocache;

select * from user_sequences;


create table chat_talking (
    idx number primary key,
    nickName varchar2(20) unique not null,
    chatLog varchar2(200),
    chatDate date
);
drop table chat_talking;

drop sequence serial_num;

select * from user_sequences;

select * from chat_talking;

select to_char(chatdate, 'YYYY-MM-DD HH:MM:DD') from chat_talking;

insert into chat_talking(idx, nickName, chatLog, chatDate)
values(serial_num.NEXTVAL, 'avamys14', 'æ»≥Á«œººø‰',
to_char(to_date(sysdate,'YY-MM-DD'),'YY-MM-DD'));


select to_char(sysdate, 'YYYY-MM-DD HH:MM:DD') from dual;




