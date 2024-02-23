------------------------------------------
--JDBC�ǽ��� ����
------------------------------------------

--Java���� ù��° JDBC���α׷��� �غ���
--Ŭ������ : HRSelected.java
--HR�������� ���� 
select * from employees where department_id=90
order by employee_id desc;


--CRUD �۾��� ���� ���̺� ����
--Ŭ������ : MyConnection.java
--study�������� ����
create table member (
    id varchar2(30) not null,
    pass varchar2(40) not null,
    name varchar2(50) not null,
    regidate date default sysdate,
    primary key(id)
);
desc member;
select * from member;
select * from user_cons_columns;

--���ڵ� �Է��ϱ�
insert into member values ('avamys3','1234','testname',sysdate);
insert into member (id, pass, name) values
    ('test3','3333','�׽���3');
commit;

--���ڵ� �����ϱ�
update member set pass='9876', name='������'
where id='test1';
commit;

--���ڵ� �����ϱ�
delete from member where id='test1';
commit;

--���ڵ� ��ȸ�ϱ�1
select id, pass, name, regidate,
    to_char(regidate, 'yyyy.mm.dd hh24:mi') d1
from member;

--���ڵ� ��ȸ�ϱ�2(�˻�)
select * from member where name like '%����%';
select * from member where name like '%t%';

-----------------------------------------------------------------
--JDBC > CallableStatement �������̽� ����ϱ�
--study �������� �н��մϴ�. 
/*
�ó�����]  �Ű������� ȸ�����̵�(���ڿ�)�� ������ ù���ڸ� ������
    �������κ��� *�� ��ȯ�ϴ� �Լ��� �����Ͻÿ�
    ���࿹) oracle21c ->o********
*/
/* substr(���ڿ� Ȥ�� �÷���, �����ε���, ����) : �����ε������� ���̸�ŭ
          �߶󳽴�. */
select substr('hongildong',1,1) from dual;
/* rpad(���ڿ� Ȥ�� �÷���, ��ü����, ä�﹮��) : ���ڿ��� ���� ���̸�
        ������ ���ڷ� ä���ش�. */
select rpad('h', 10, '*') from dual;
/* ���ڿ��� ù���ڸ� ������ ������ �κ��� *�� ä�� �������� �ϼ��Ѵ�. */
select rpad(substr('hongildong',1,1), length('hongildong'), '*')
from dual;
    
--�Ű������� ���������� ����
create or replace function fillAsterik (idStr varchar2)
return varchar2 /* ��ȯŸ�Ե� ���������� ���� */
is retStr varchar2(50); /* ����ŷ ó���� ���̵� ������ ���� */
begin
    --���̵� ����ŷ ó���� ��ȯ
    retStr := rpad(substr(idStr,1,1),length(idStr),'*');
    return retStr;
end;
/
--���̵� ����ŷ ó�� �Ǵ��� Ȯ��
select fillAsterik('hongildong') from dual;
select fillAsterik('oracle21c') from dual;

/*
����2-1] ���ν��� : MyMemberInsert()
�ó�����] member ���̺� ���ο� ȸ�������� �Է��ϴ� ���ν����� �����Ͻÿ�
    �Ķ���� : In => ���̵�, �н�����, �̸�
                    Out => returnVal(����:1, ����:0)
*/
/* Java���� �Է��� ������ ���� ���Ķ���� ���� �� ���� ���� ���θ�
��ȯ�ϱ� ���� �ƿ��Ķ���� ���� */
create or replace procedure MyMemberInsert (
        p_id in varchar2,
        p_pass in varchar2,
        p_name in varchar2,
        returnVal out number
    )
is
begin
    --���Ķ���͸� ���� insert�������� �ۼ�
    insert into member (id, pass, name)
        values (p_id, p_pass, p_name);
        
    if sql%found then
        --�Է��� ����ó�� �Ǿ��ٸ� �Էµ� ���� ������ ���´�.
        returnVal := sql%rowcount;
        --���� ��ȭ�� �������Ƿ� �ݵ�� Ŀ���ؾ��Ѵ�. 
        commit;
    else
        --�Է¿� �����ϸ� 0�� ��ȯ�Ѵ�. 
        returnVal := 0;
    end if;
    /* ���ν����� ������ return���� �ƿ��Ķ���Ϳ� ���� �Ҵ��ϱ⸸ �ϸ�
    �ڵ����� ��ȯ�ȴ�. */
end;
/
--���ε庯���� ������ �� ���ν����� �����Ѵ�. 
var i_result varchar2(10);
execute MyMemberInsert('pro02', '1234', '���ν���1', :i_result);
execute MyMemberInsert('pro03', '2345', '���ν���2', :i_result);
--�ƿ� �Ķ���͸� ���� ��ȯ���� �� �������� Ȯ���Ѵ�. 
print i_result;

select * from member;

/*
����3-1] ���ν��� : MyMemberDelete()
�ó�����] member���̺��� ���ڵ带 �����ϴ� ���ν����� �����Ͻÿ�
    �Ķ���� : In => member_id(���̵�)
                    Out => returnVal(SUCCESS/FAIL ��ȯ)   
*/
/* in�Ķ���ʹ� ������ ���̵�, out�Ķ���ʹ� ���� ����� ���� */
create or replace procedure MyMemberDelete (
        member_id in varchar2,
        returnVal out varchar2
    )
is
begin
    --ȸ�����ڵ带 ������ delete������ �ۼ�
    delete from member where id=member_id;
    
    --������ ���� Ȥ�� ���и� �Ǵ��� �� ����� ��ȯ
    if SQL%Found then
        returnVal := 'SUCCESS';
        commit;
    else
        returnVal := 'FAIL';
    end if;
end;
/

set serveroutput on;
--���ε� ���� ���� �� ���� �׽�Ʈ
var delete_var varchar2(10);

execute MyMemberDelete('test4', :delete_var);
execute MyMemberDelete('pro01', :delete_var);

print delete_var;

select * from member;
/*
����4-1] ���ν��� : MyMemberAuth()
�ó�����] ���̵�� �н����带 �Ű������� ���޹޾Ƽ� ȸ������ ���θ� �Ǵ��ϴ� ���ν����� �ۼ��Ͻÿ�. 
    �Ű����� : 
        In -> user_id, user_pass
        Out -> returnVal
    ��ȯ�� : 
        0 -> ȸ����������(�Ѵ�Ʋ��)
        1 -> ���̵�� ��ġ�ϳ� �н����尡 Ʋ�����
        2 -> ���̵�/�н����� ��� ��ġ�Ͽ� ȸ������ ����
    ���ν����� : MyMemberAuth
*/

create or replace procedure MyMemberAuth (
    /* ���Ķ���� : Java���� �Է¹��� ���̵�, �н����� */
    user_id in varchar2,
    user_pass in varchar2,
    /* �ƿ��Ķ���� : ȸ������ ���� ��� */
    returnVal out number
)
is
    --count(*)�� ���� ��ȯ�Ǵ� ���� ����
    member_count number(1) := 0;
    --��ȸ�� �н����带 ���� 
    member_pw varchar(50);
begin
    --�ش� ���̵� �����ϴ��� �Ǵ��ϴ� select�� �ۼ�
    select count(*) into member_count
    from member where id=user_id;
    --ȸ�����̵� �����Ѵٸ�..
    if member_count=1 then
        --�н����� Ȯ���� ���� �ι�° �������� ����
        select pass into member_pw
            from member where id=user_id;
        --���Ķ���ͷ� ���޵� ���� DB�� �н����带 ���Ѵ�. 
        if member_pw=user_pass then
            --��� ��ġ�ϴ� ���
            returnVal := 2;
        else
            --����� Ʋ�� ���
            returnVal := 1;
        end if;
    else
        --���̵� Ʋ�� ���
        returnVal := 0;
    end if;
end;
/
--���ε� ���� ���� �� �׽�Ʈ�غ���. 
variable member_auth number;
--�Ѵ� �´� ��� : 2
execute MyMemberAuth('test2', '5114' ,:member_auth);
print member_auth;
--����� Ʋ�� ��� : 1
execute MyMemberAuth('test2', '1234' ,:member_auth);
print member_auth;
--���̵� Ʋ�� ��� : 0
execute MyMemberAuth('yugyeom', '1234' ,:member_auth);
print member_auth;

select * from member;


/***********************************************
JSP �� ���α׷��� - JDBC �ǽ�
***********************************************/
--���ο� ����� ���� ������ ���� system ���� ����

--���� ����
alter session set "_ORACLE_SCRIPT"=true;

--���� ����
create user musthave identified by 1234;

--���� �ο�
GRANT CONNECT, RESOURCE, unlimited tablespace TO musthave;

/*
CMDȯ�濡�� sqlplus�� ���� ������ ��쿡�� �ٸ� �������� ��ȯ�� �Ʒ��� ����
conn (Ȥ�� connect) ��ɾ ����� �� �ִ�. ������ SQL�𺧷��ۿ�����
����� �� ���� ��� ���� ����� ����Ʈ�ڽ��� ���� ������ ������ �� �ִ�.
*/
conn musthave/1234;
show user;

--���̺� ��� ��ȸ
select * from tab;

--���̺� �� ������ ������ ���� musthave ���� ����
--������ ������ ���̺��� �ִٸ� ���� �� �ٽ� ���� �� �ִ�.
drop table member;
drop table board;
drop sequence seq_board_num;

--ȸ�� ���̺� ����
create table member (
    id varchar2(10) not null,
    pass varchar2(10) not null,
    name varchar2(30) not null,
    regidate date default sysdate not null,
    primary key (id)
);

--��1 ����� �Խ��� ���̺� ����
create table board(
    num number primary key,
    title varchar2(200) not null,
    content varchar2(2000) not null,
    id varchar2(10) not null, /* ȸ���� �Խ����̹Ƿ� ȸ�����̵� �ʿ� */
    postdate date default sysdate not null, /* �Խù��� �ۼ��� */
    visitcount number(6) /* �Խù��� ��ȸ�� */
);

--�ܷ�Ű ����
/*
�ڽ����̺��� board�� �θ����̺��� member�� �����ϴ� �ܷ�Ű�� �����Ѵ�.
board�� id�÷��� member�� �⺻Ű�� id�÷��� �����Ѵ�. 
*/
alter table board
    add constraint board_mem_fk foreign key (id)
    references member (id);

--������ ����
--board���̺� �ߺ����� �ʴ� �Ϸù�ȣ �ο��� ���� ���
create sequence seq_board_num
    increment by 1
    start with 1
    minvalue 1
    nomaxvalue 
    nocycle
    nocache;

--���� ������ �Է�
insert into member (id, pass, name) values ('musthave', '1234', '�ӽ�Ʈ�غ�');

insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '����1�Դϴ�', '����1�Դϴ�', 'musthave', sysdate, 0);
--�θ����̺� ���� ���̵� �̹Ƿ� �������� ����� �Էµ��� �ʴ´�.    
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '����2�Դϴ�', '����2�Դϴ�', 'tjoeun', sysdate, 0);    
--Ŀ��
commit;

/************************
��1 ����� ȸ���� �Խ��� �����ϱ�
************************/
--���̵����� �߰� �Է� 
insert into board values (seq_board_num.nextval, '������ ���Դϴ�',
    '���ǿ���', 'musthave', sysdate, 0);
insert into board values (seq_board_num.nextval, '������ �����Դϴ�',
    '�������', 'musthave', sysdate, 0);
insert into board values (seq_board_num.nextval, '������ �����Դϴ�',
    '������ȭ', 'musthave', sysdate, 0);
insert into board values (seq_board_num.nextval, '������ �ܿ��Դϴ�',
    '�ܿ￬��', 'musthave', sysdate, 0);
commit;
--DAO�� selectcount() �޼��� : board���̺��� �Խù� ���� ī��Ʈ
select count(*) from board;
select count(*) from board where title like '%�ܿ�%';
select count(*) from board where content like '%�ܿ�%';
delete from board where title like '%test%';

--selectList() �޼��� : �Խ��� ��Ͽ� ����� ���ڵ带 �����ؼ� ����
select * from board order by num desc;
select * from board where title like '%����%' order by num desc;
select * from board where title like '%����%' order by num desc;

--insertWrite() �޼��� : �۾��⸦ ���� insert������ ����
insert into board (num, title, content, id, visitcount)
values (seq_board_num.nextval, '����Test', '����Test', 'musthave', 0);
commit;

--selectView() : �Խù��� �Ϸù�ȣ�� ���� ���뺸�� ����
select * from board where num=7;
--��Ī�� �ο����� �ʾ� ���̺���� �״�� ����Ѵ�.
select * from board inner join member
    on board.id=member.id
where num=7;
--��Ī�� �ο��ؼ� �ʿ��� �÷��� select ���� ����Ѵ�.
select B.*, M.name from board B inner join member M
    on B.id=M.id
where num=7;

--updateVisitCount() : �Խù� ���뺸�� �� ��ȸ�� 1 ����
update board set visitcount = visitcount+1 where num=7;
commit;

--���뺸��� �ٸ� ����� �ۼ��� �Խù��� Ȯ���ϱ� ���� ���̵����� �߰�
insert into member (id, pass, name) values ('tjoeun', '1234', '������');
insert into member (id, pass, name) values ('avamys', '1234', '�ڼ���');
commit;

--updateEdit() : ������ �Խù��� ����
select * from board where num=7;
update board set title='����Test', content='�������Test'
    where num=7;

--deletePost() : �Խù� ����
delete from board where num=7;
select * from board;
commit;