/************************
���ϸ� : Or06GroupBy.sql
�׷��Լ�(select�� 2��°)
����: ��ü ���ڵ�(�ο�)���� ������� ����� ���ϱ�
    ���� �ϳ� �̻��� ���ڵ带 �׷����� ��� ������
    ����� ��ȯ�ϴ� �Լ� Ȥ�� ������
************************/
--������̺��� ������ ����. ��107���� ����ȴ�.
select job_id from employees;
/* 
distinct
-������ ���� �ִ� ��� �ߺ��� ���ڵ带 ������ �� �ϳ��� ���ڵ常 �����ͼ�
�����ش�.
-������ �ϳ��� ���ڵ��̹Ƿ� ������� ���� ����� �� ����. 
*/
select distinct job_id from employees;
/*
group by
-������ ���� �ִ� ���ڵ带 �ϳ��� �׷����� ��� �����Ѵ�.
-�������°� �ϳ��� ���ڵ����� �ټ��� ���ڵ尡 �ϳ��� �׷����� ������
����̹Ƿ� ������� ���� ����� �� �ִ�.
-�ִ�, �ּ�, ���, �ջ� ���� ������ �����ϴ�.
*/
select job_id from employees group by job_id;

--�� �������� �������� ����ϱ��??
select job_id, count(*) from employees group by job_id;
/* count() �Լ��� ���� ����� ���� ������ �Ʒ��� ���� �Ϲ����� select����
��� ������ �� �ִ�. */
select * from employees where job_id='IT_PROG';--5��
select * from employees where job_id='SH_CLERK';--20��

/*
group by ���� ���Ե� select���� ����
    select
        �÷�1, �÷�2 ... Ȥ�� ��ü(*)
    from
        ���̺��
    where
        ����1 and ����2 or ����3(���������� �����ϴ� �÷�)
    group by
        ���ڵ��� �׷�ȭ�� ���� �÷���
    having
        �׷쿡���� ����(�������� ������ �÷�)
    order by
        ������ ���� �÷���� ���Ĺ��
*/

/*
sum() : �հ踦 ���Ҷ� ����ϴ� �Լ�
-number Ÿ���� �÷������� ����� �� �ִ�.
-�ʵ���� �ʿ��� ��� as�� �̿��ؼ� ��Ī�� �ο��� �� �ִ�.
*/
--��ü������ �޿��� �հ踦 ����Ͻÿ�.
select ltrim(to_char(sum(salary),'999,999,000'))sumSalary
from employees;

--10�� �μ��� �ٹ��ϴ� ������� �޿� �հ�� ������ ����Ͻÿ�.
select ltrim(to_char(sum(salary),'$999,000'))sumSalary
from employees where department_id=10;

--sum()�� ���� �׷��Լ��� number Ÿ���� �÷������� ����� �� �ִ�.
select sum(first_name) from employees; --�����߻�

/* 
count() : �׷�ȭ�� ���ڵ��� ������ ī��Ʈ�Ҷ� ����ϴ� �Լ�.
*/
select count(*) from employees;
select count(employee_id) from employees;
/*
    count() �Լ��� ����Ҷ��� �� 2���� ��� ��� ����������
    *�� ����Ұ��� �����Ѵ�. �÷��� Ư�� Ȥ�� �����Ϳ� ����
    ���ظ� ���� �����Ƿ� ����ӵ��� ������.
*/
/*
count() �Լ���
    ����1 : count(all �÷���)
        => ����Ʈ �������� �÷� ��ü�� ���ڵ带 �������� ī��Ʈ�Ѵ�.
    ����2 : count(disticnt �÷���)
        => �ߺ��� ������ ���¿��� ī��Ʈ �Ѵ�.
*/
select
    count(job_id) "��������ü����1",
    count(all job_id) "��������ü����2",
    count(distinct job_id) "��������������"
from employees;

/*
avg() : ��հ��� ���Ҷ� ����ϴ� �Լ�
*/
--��ü����� ��ձ޿��� ������ ����ϴ� �������� �ۼ��Ͻÿ�.
select 
    count(*) "��ü�����",
    sum(salary) "����޿�����",
    ltrim(to_char(sum(salary) / count(*),'$999,000.00')) "��ձ޿�(�������)",
    ltrim(to_char(avg(salary),'$999,000.00')) "���ڼ�������"
from employees;

--������(SALES)�� ��ձ޿��� ���ΰ���??
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
min(), max() : �ִ밪, �ּҰ��� ã���� ����ϴ� �Լ�
*/
--��ü ����� �޿��� ���� ���� ������ �����ΰ���??
/* �Ʒ� �������� ������ �߻��ȴ�. �׷��Լ��� �Ϲ��÷��� �ٷ� ����� �� 
����. �̿� ���� ��쿡�� �ڿ��� �н��� '��������'�� ����ؾ��Ѵ�. */
select first_name, salary from employees
where salary=min(salary);

--��ü ����� ���� ���� �޿��� ���ΰ���??
/* ���������� �����ϴ� salary �÷��߿��� ���� �������� ã�°��� �Ʒ���
���� ó���� �� �ִ�.*/
select min(salary) from employees;

--���� 2100���� �޴� ������ ã���� ù��° ������ �ذ��� �� �ִ�.
select (first_name || last_name) "NAME", salary
from employees where salary=2100;

--�� 2���� �������� ��ġ�� �Ʒ��� ���� ���������� �ȴ�.
select (first_name || last_name) "NAME", salary
from employees where salary=(select min(salary) from employees);

/*
group by�� : �������� ���ڵ带 �ϳ��� �׷����� �׷�ȭ�Ͽ� ������
    ����� ��ȯ�ϴ� ������.
    �� distinct�� �ܼ��� �ߺ����� ������.
*/
--������̺��� �� �μ��� �޿��� �հ�� ���ΰ���??
--IT �μ��� �޿��հ�
select sum(salary) from employees where department_id=60;
--Finance �μ��� �޿��հ�
select sum(salary) from employees where department_id=100;
/*
1�ܰ� : �μ��� ������� ������ �μ����� Ȯ���� �� �����Ƿ� �μ��� �׷�ȭ
    �Ѵ�. �ߺ��� ���ŵ� ����� �������� ������ ���ڵ尡 �ϳ��� �׷�����
    ������ ����� ����ȴ�. 
*/
select department_id from employees group by department_id;
/*
2�ܰ� : �� �μ����� �޿��� �հ踦 ���� �� �ִ�.
*/
select department_id, sum(salary), ltrim(to_char(sum(salary),'$999,000'))
from employees group by department_id;
/* �Ʒ� �������� �μ���ȣ�� �׷����� ��� ����� �����ϹǷ�, �̸��� 
����ϸ� ������ �߻��ȴ�. �� ���ڵ庰�� ���� �ٸ� �̸��� ����Ǿ� �����Ƿ�
�׷��� ���ǿ� ���� �÷��� ����� �� ���� �����̴�. */
select department_id, first_name from employees 
    group by department_id;--�����߻�
    
/*
����] ������̺��� �� �μ��� ������� ��ձ޿��� ������ ����ϴ� 
�������� �ۼ��Ͻÿ�. 
��°�� : �μ���ȣ, �޿�����, �������, ��ձ޿�
��½� �μ���ȣ�� �������� �������� �����Ͻÿ�. 
*/

select department_id "�μ���ȣ", trim(to_char(sum(salary),'999,000'))"�޿�����", 
count(*)"�����", trim(to_char(avg(salary),'999,000'))"��ձ޿�"
from employees group by department_id order by department_id asc; 

/*
�տ��� ����ߴ� �������� �Ʒ��� ���� �����ϸ� ������ �߻��Ѵ�.
group by ������ ����� �÷��� select������ ����� �� ������, �� ���� 
���� �÷��� ����� �� ����.
�׷�ȭ�� ���¿��� Ư�� ���ڵ� �ϳ��� �����ϴ°��� �ָ��ϱ� �����̴�. 
*/
select department_id "�μ���ȣ", trim(to_char(sum(salary),'999,000'))"�޿�����", 
count(*)"�����", trim(to_char(avg(salary),'999,000'))"��ձ޿�",
first_name, last_name
from employees group by department_id order by department_id asc; 


/**************************************
����
**************************************/
--�ش� ������ hr������ employees ���̺��� ����մϴ�.
/* 
1. ��ü ����� �޿��ְ��, ������, ��ձ޿��� ����Ͻÿ�. 
�÷��� ��Ī�� �Ʒ��� ���� �ϰ�, ��տ� ���ؼ��� �������·� �ݿø� �Ͻÿ�.
��Ī) �޿��ְ�� -> MaxPay
�޿������� -> MinPay
�޿���� -> AvgPay 
*/

/* 
2. �� ������ �������� �޿��ְ��, ������, �Ѿ� �� ��վ��� ����Ͻÿ�. 
�÷��� ��Ī�� �Ʒ��� �����ϰ� ��� ���ڴ� to_char�� �̿��Ͽ� ���ڸ����� 
�ĸ��� ��� �������·� ����Ͻÿ�.
��Ī) �޿��ְ�� -> MaxPay
�޿������� -> MinPay
�޿���� -> AvgPay
�޿��Ѿ� -> SumPay
����) employees ���̺��� job_id�÷��� �������� �Ѵ�.
*/

/*
3. count() �Լ��� �̿��Ͽ� �������� ������ ������� ����Ͻÿ�.
����) employees ���̺��� job_id�÷��� �������� �Ѵ�.
*/

/*
4. �޿��� 10000�޷� �̻��� �������� �������� �հ��ο����� ����Ͻÿ�.
*/

/*
5. �޿��ְ�װ� �������� ������ ����Ͻÿ�. 
*/

/*
6. �� �μ��� ���� �μ���ȣ, �����, �μ� ���� ��� ����� 
��ձ޿��� ����Ͻÿ�. ��ձ޿��� �Ҽ��� ��°�ڸ��� �ݿø��Ͻÿ�.
*/





