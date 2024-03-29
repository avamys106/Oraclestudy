/***************
파일명 : Or02Number.sql
숫자(수학) 관련 함수
설명 : 숫자데이터를 처리하기 위한 숫자관련 함수를 알아보자
    테이블 생성시 number 타입으로 선언된 칼럼에 저장된 데이터를
    대상으로 한다.
****************/
--현재 접속한 계정에 생성된 테이블, 뷰의 목록을 보여준다.
select * from tab;
--이와같이 테이블이 없는 경우에는 쿼리에러가 발생한다.
select * from tjoeun;

/* 
Dual테이블
: 하나의 행으로 결과를 출력하기 위해 제공되는 테이블로 오라클에서
자동으로 생성되는 논리적 테이블이다.
varchar2(1)로 정의된 dummy라는 단 하나의 컬럼으로 구성되어있다.
*/
desc dual;
select * from dual;

/*
abs() : 절대값 구하기
*/
select abs(12000) from dual;
select abs(-9000) from dual;
select abs(salary) "급여의절대값" from employees;

/*
trunc() : 소수점을 특정자리수에서 잘라낼때 사용하는 함수
    형식 : trunc(컬럼명 혹은 값, 소수점이하자리수)
        두번째 인자가
            양수일때 : 주어진 숫자만큼 소수점을 표현
            없을때 : 정수부만 표현. 즉 소수점 아래부분은 버림
            음수일때 : 정수부를 숫자만큼 잘라 나머지를 0으로 채움
*/
select trunc(12345.12345,2) from dual;
select trunc(12345.12345) from dual;
select trunc(12345.12345,-2) from dual;
--금액이라면 원단위 절삭과 같은 형태로 사용할 수 있다.

/*
시나리오] 사원테이블에서 영업사원의 1000불에 대한 커미션을 계산하여
    급여에 합한 결과를 출력하는 쿼리문을 작성하시오. 
    Ex) 급여:1000, 보너스율:0.1
        => 1000 + (1000*0.1) = 1100  
*/
--1. 영업사원을 찾아 인출한다. (영업사원의 job_id는 SA_XX로 되어있다)
select * from employees where job_id like 'SA_%';
--(영업사원은 커미션을 받기때문에 값이 입력되어있다.)
select * from employees where commission_pct is not null;

--2.커미션을 계산하여 이름과 함께 출력한다.
select first_name, salary, commission_pct, salary+(salary*commission_pct) as result
from employees where job_id like 'SA_%';

--3.커미션을 소수점 1자리까지만으로 금액 계산하기
select first_name, salary, trunc(commission_pct,1), salary+ (salary*trunc(commission_pct,1))
from employees where job_id like 'SA_%';

--4.계산식이 포함된 컬럼명에 별칭을 부여하기
select first_name, salary, trunc(commission_pct,1)comm_pct , salary+ (salary*trunc(commission_pct,1)) totalSalary
from employees where job_id like 'SA_%';

/*
소수점 관련함수
    ceil() : 소수점 이하를 무조건 올림처리
    floor() : 무조건 버림처리
    round(값, 자리수) : 반올림 처리
    두번째 인자가
        없는경우 : 소수점 첫번째 자리가 5이상이면 올림, 미만이면 버림
        있는경우 : 숫자만큼 소수점이 표현되므로 그 다음수가 5이상이면
            올림, 미만이면 버림
*/
select ceil(32.8) from dual;
select ceil(32.2) from dual;--둘다 33 인출

select floor(32.8) from dual;
select floor(32.2) from dual;--둘다 32 인출

--버림과 올림을 하여 0, 1이 인출됨
select round(0.123), round(0.543) from dual;
/*
첫번째항목 : 소수이하 6자리까지 표현하므로 7을 올림처리
두번째항목 : 소수이하 4자리까지 표현하므로 1을 버림처리
*/
select round(0.1234567,6), round(2.345612,4) from dual;

/*
mod() : 나머지를 구하는 함수
power() : 거듭제곱을 구하는 함수
sqrt() : 제곱근(루트)을 구하는 함수
*/
select mod(99, 4) "99를4로나눈나머지" from dual;
select power(2, 10) "2의10승" from dual;
select sqrt(49) "49의제곱근" from dual;
