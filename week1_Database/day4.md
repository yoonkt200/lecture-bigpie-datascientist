# 4일차 


-----------------------


#### **0-1. 4일차 학습 내용**

```
- 2개 이상의 테이블을 합체하는 조인


```

-----------------------


#### **1. 3일차 복습**


```sql
--그룹 지어진 부서별 평균 급여가 3000 이상인 부서의 번호와 부서별 평균 급여를 출력하는 쿼리문 
select deptno, avg(sal)
from emp
group by deptno
having avg(sal) > 3000;

--부서별 사원들의 급여 총합과 최소급여, 최대급여, 평균 급여를 구하시오.
select deptno, sum(sal), max(sal), min(sal), avg(sal)
from emp
group by deptno

--부서별 변호가 20인 사원들 중에서 급여가 1000 이상인 사원의 이름을 출력하시오.
select ename
from emp
where deptno = 20 and sal >= 1000


--Analyst인 부서인 사원들의 sal 합을 구하시오.
select job, sum(sal)
from emp
group by job
having job like 'ANALYST'

--사원 총원들중 급여가 가장 큰 사원의 이름을 출력하세요
select ename 
from emp
where sal = (select max(sal) from emp);
```

-----------------------


#### **2. 조인 실습**

> 조인 기초

```sql

-- 두 테이블에서 기본적으로 조인하는 방법.
select *
from customer, orders
where customer.custid = orders.custid

-- 조인에 정렬을 적용한 것
select *
from customer, orders
where customer.custid=orders.custid
order by customer.custid

-- projection으로 조인된 내용을 검색한 것
select name, saleprice
from customer, orders
where customer.custid = orders.custid

-- 고객별 주문한 모든 도서의 총 판매액을 구하고, 판매액순으로 정렬
select customer.custid, sum(saleprice)
from customer, orders
where customer.custid=orders.custid
group by customer.custid
order by sum(saleprice)

```

> 조인 응용

```sql

-- 3개 테이블 조인. orders는 관계 테이블인 경우.
select customer.name, book.bookname
from customer, orders, book
where customer.custid = orders.custid and orders.bookid = book.bookid

-- 가격이 2만원인 도서를 주문한 고객의 이름과 책 이름
select customer.name, book.bookname
from customer, orders, book
where customer.custid = orders.custid 
      and orders.bookid = book.bookid
      and book.price = 20000
      
-- 외부 조인 방법
select customer.name, saleprice
from customer left outer join orders
     on customer.custid = orders.custid

-- 위와 같은 방법
select customer.name, saleprice
from customer, orders
where customer.custid = orders.custid(+)

-- 이너조인 개념의 두가지 방법.
select *
from customer, orders
where customer.custid = orders.custid and saleprice >= 20000

select *
from customer inner join orders on customer.custid = orders.custid
where saleprice >= 20000;

```

#### **3. 부속 질의**

> 부속 질의 기본

```sql

-- 도서를 구매한 적이 있는 고객의 이름을 검색
select name
from customer
where custid in (select custid from orders)

-- 대한미디어에서 출판한 도서를 구매한 고객의 이름
select name
from customer
where custid in (select custid
                 from orders
                 where bookid in (select bookid
                                  from book
                                  where publisher='대한미디어'))

-- 상관 부속질의 : 상위 부속질의와 하위 부속질의가 독립적이지 않고 관계를 맺고 있는 것.
-- 출판사별로 출판사의 평균 도서 가격보다 비싼 도서를 구하시오
select b1.bookname
from book b1
where b1.price > (select avg(b2.price)
                  from book b2
                  where b2.publisher=b1.publisher)
                  
-- 도서를 주문하지 않은 고객의 이름을 보이시오 (minus보다는 주로 not in을 더 많이 사용함.)
select name
from customer

minus

select name
from customer
where custid in (select custid from orders)

-- 주문이 있는 고객의 이름과 주소를 보이시오
select name, address
from customer cs
where exists (select *
              from orders od
              where cs.custid=od.custid)

```