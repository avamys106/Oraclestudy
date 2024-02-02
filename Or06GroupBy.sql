/************************
파일명 : Or06GroupBy.sql
그룹함수(select문 2번째)
설명: 전체 레코드(로우)에서 통계적인 결과를 구하기
    위해 하나 이상의 레코드를 그룹으로 묶어서 연산후
    결과를 반환하는 함수 혹은 쿼리문
************************/
--사원테이블에서 담당업무 인출. 총107개가 인출된다.
select job_id from employees;
/* 
distinct
-동일한 값이 있는 경우 중복된 레코드를 제거한 후 하나의 레코드만 가져와서
보여준다.
-순수한 하나의 레코드이므로 통계적인 값을 계산할 수 없다. 
*/
select distinct job_id from employees;
/*
group by
-동일한 값이 있는 레코드를 하나의 그룹으로 묶어서 인출한다.
-보여지는건 하나의 레코드지만 다수의 레코드가 하나의 그룹으로 묶여진
결과이므로 통계적인 값을 계산할 수 있다.
-최대, 최소, 평균, 합산 등의 연산이 가능하다.
*/
select job_id from employees group by job_id;

--각 담당업무별 직원수는 몇명일까요??
select job_id, count(*) from employees group by job_id;
/* count() 함수를 통해 인출된 행의 갯수는 아래와 같이 일반적인 select문을
토앻 검증할 수 있다. */
select * from employees where job_id='IT_PROG';--5개
select * from employees where job_id='SH_CLERK';--20개

/*
group by 절이 포함된 select문의 형식
    select
        컬럼1, 컬럼2 ... 혹은 전체(*)
    from
        테이블명
    where
        조건1 and 조건2 or 조건3(물리적으로 존재하는 컬럼)
    group by
        레코드의 그룹화를 위한 컬럼명
    having
        그룹에서의 조건(논리적으로 생성된 컬럼)
    order by
        정렬을 위한 컬럼명과 정렬방식
*/

/*
sum() : 합계를 구할때 사용하는 함수
-number 타입의 컬럼에서만 사용할 수 있다.
-필드명이 필요한 경우 as를 이용해서 별칭을 부여할 수 있다.
*/
--전체직원의 급여의 합계를 출력하시오.
select ltrim(to_char(sum(salary),'999,999,000'))sumSalary
from employees;

--10번 부서에 근무하는 사원들의 급여 합계는 얼마인지 출력하시오.
select ltrim(to_char(sum(salary),'$999,000'))sumSalary
from employees where department_id=10;

--sum()과 같은 그룹함수는 number 타입인 컬럼에서만 사용할 수 있다.
select sum(first_name) from employees; --에러발생

/* 
count() : 그룹화된 레코드의 갯수를 카운트할때 사용하는 함수.
*/
select count(*) from employees;
select count(employee_id) from employees;
/*
    count() 함수를 사용할때는 위 2가지 방법 모두 가능하지만
    *를 사용할것을 권장한다. 컬럼의 특성 혹은 데이터에 따른
    방해를 받지 않으므로 실행속도가 빠르다.
*/
/*
count() 함수의
    사용법1 : count(all 컬럼명)
        => 디폴트 사용법으로 컬럼 전체의 레코드를 기준으로 카운트한다.
    사용법2 : count(disticnt 컬럼명)
        => 중복을 제거한 상태에서 카운트 한다.
*/
select
    count(job_id) "담당업무전체갯수1",
    count(all job_id) "담당업무전체갯수2",
    count(distinct job_id) "순수담당업무갯수"
from employees;

/*
avg() : 평균값을 구할때 사용하는 함수
*/
--전체사원의 평균급여는 얼마인지 출력하는 쿼리문을 작성하시오.
select 
    count(*) "전체사원수",
    sum(salary) "사원급여의합",
    ltrim(to_char(sum(salary) / count(*),'$999,000.00')) "평균급여(직접계산)",
    ltrim(to_char(avg(salary),'$999,000.00')) "숫자서식적용"
from employees;

--영업팀(SALES)의 평균급여는 얼마인가요??
select 
    count(department_id),
    sum(salary),
    ltrim(to_char(sum(salary)/count(department_id),'$999,000.00'))"SUM/COUNT",
    ltrim(to_char(avg(salary),'$999,000.00'))"AVG"
from employees where department_id = 80;

select * from departments where upper(department_name) = 'SALES';
select ltrim(to_char(avg(salary),'$999,000.00'))"AVG"
from employees where department_id = 80;

/*
min(), max() : 최대값, 최소값을 찾을때 사용하는 함수
*/
--전체 사원중 급여가 가장 적은 직원은 누구인가요??
/* 아래 쿼리문은 에러가 발생된다. 그룹함수는 일반컬럼에 바로 사용할 수 
없다. 이와 같은 경우에는 뒤에서 학습할 '서브쿼리'를 사용해야한다. */
select first_name, salary from employees
where salary=min(salary);

--전체 사원중 가장 낮은 급여는 얼마인가요??
/* 물리적으로 존재하는 salary 컬럼중에서 가장 작은값을 찾는것은 아래와
같이 처리할 수 있다.*/
select min(salary) from employees;

--따라서 2100불은 받는 직원을 찾으면 첫번째 질문을 해결할 수 있다.
select (first_name || last_name) "NAME", salary
from employees where salary=2100;

--위 2개의 쿼리문을 합치면 아래와 같은 서브쿼리가 된다.
select (first_name || last_name) "NAME", salary
from employees where salary=(select min(salary) from employees);

/*
group by절 : 여러개의 레코드를 하나의 그룹으로 그룹화하여 묶여진
    결과를 반환하는 쿼리문.
    ※ distinct는 단순히 중복값을 제거함.
*/
--사원테이블에서 각 부서별 급여의 합계는 얼마인가요??
--IT 부서의 급여합계
select sum(salary) from employees where department_id=60;
--Finance 부서의 급여합계
select sum(salary) from employees where department_id=100;
/*
1단계 : 부서가 많은경우 일일이 부서별로 확인할 수 없으므로 부서를 그룹화
    한다. 중복이 제거된 결과로 보이지만 동일한 레코드가 하나의 그룹으로
    합쳐진 결과가 인출된다. 
*/
select department_id from employees group by department_id;
/*
2단계 : 각 부서별로 급여의 합계를 구할 수 있다.
*/
select department_id, sum(salary), ltrim(to_char(sum(salary),'$999,000'))
from employees group by department_id;
/* 아래 쿼리문은 부서번호를 그룹으로 묶어서 결과를 인출하므로, 이름을 
기술하면 에러가 발생된다. 각 레코드별로 서로 다른 이름이 저장되어 있으므로
그룹의 조건에 단일 컬럼을 사용할 수 없기 때문이다. */
select department_id, first_name from employees 
    group by department_id;--에러발생
    
/*
퀴즈] 사원테이블에서 각 부서별 사원수와 평균급여는 얼마인지 출력하는 
쿼리문을 작성하시오. 
출력결과 : 부서번호, 급여총합, 사원총합, 평균급여
출력시 부서번호를 기준으로 오름차순 정렬하시오. 
*/

select department_id "부서번호", trim(to_char(sum(salary),'999,000'))"급여총합", 
count(*)"사원수", trim(to_char(avg(salary),'999,000'))"평균급여"
from employees group by department_id order by department_id asc; 

/*
앞에서 사용했던 쿼리문을 아래와 같이 수정하면 에러가 발생한다.
group by 절에서 사용한 컬럼은 select절에서 사용할 수 있으나, 그 외의 
단일 컬럼은 사용할 수 없다.
그룹화된 상태에서 특정 레코드 하나만 선택하는것은 애매하기 때문이다. 
*/
select department_id "부서번호", trim(to_char(sum(salary),'999,000'))"급여총합", 
count(*)"사원수", trim(to_char(avg(salary),'999,000'))"평균급여",
first_name, last_name
from employees group by department_id order by department_id asc; 


/**************************************
과제
**************************************/
--해당 문제는 hr계정의 employees 테이블을 사용합니다.
/* 
1. 전체 사원의 급여최고액, 최저액, 평균급여를 출력하시오. 
컬럼의 별칭은 아래와 같이 하고, 평균에 대해서는 정수형태로 반올림 하시오.
별칭) 급여최고액 -> MaxPay
급여최저액 -> MinPay
급여평균 -> AvgPay 
*/

/* 
2. 각 담당업무 유형별로 급여최고액, 최저액, 총액 및 평균액을 출력하시오. 
컬럼의 별칭은 아래와 같이하고 모든 숫자는 to_char를 이용하여 세자리마다 
컴마를 찍고 정수형태로 출력하시오.
별칭) 급여최고액 -> MaxPay
급여최저액 -> MinPay
급여평균 -> AvgPay
급여총액 -> SumPay
참고) employees 테이블의 job_id컬럼을 기준으로 한다.
*/

/*
3. count() 함수를 이용하여 담당업무가 동일한 사원수를 출력하시오.
참고) employees 테이블의 job_id컬럼을 기준으로 한다.
*/

/*
4. 급여가 10000달러 이상인 직원들의 담당업무별 합계인원수를 출력하시오.
*/

/*
5. 급여최고액과 최저액의 차액을 출력하시오. 
*/

/*
6. 각 부서에 대해 부서번호, 사원수, 부서 내의 모든 사원의 
평균급여를 출력하시오. 평균급여는 소수점 둘째자리로 반올림하시오.
*/





