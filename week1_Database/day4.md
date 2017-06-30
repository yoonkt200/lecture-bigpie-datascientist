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


-----------------------



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

-- exists : 조건에 맞으면 결과에 포함시킴.
-- 주문이 있는 고객의 이름과 주소를 보이시오
select name, address
from customer cs
where exists (select *
              from orders od
              where cs.custid=od.custid)

```

> 부속 질의 연습

```sql

-- 박지성의 총 구매액
select sum(saleprice)
from customer, orders
where customer.custid = orders.custid and customer.name like '박지성';

-- 지성팍의 구매 도서 수
select count(*)
from customer, orders
where customer.custid = orders.custid and customer.name like '박지성';

-- 박지성이 구매한 도서의 출판사 수
select count(DISTINCT publisher)
from book
where bookid in (select bookid
                 from customer, orders
                 where customer.custid = orders.custid 
                 and customer.name like '박지성');
                 
-- 박지성이 구매한 도서의 이름, 가격, 정가와 판매가격의 차이
select bookname, price, price-saleprice
from orders, book
where orders.bookid = book.bookid and
      orders.custid in (select custid 
                        from customer
                        where name like '박지성')

-- 박지성이 구매하지 않은 도서의 이름
select bookname
from book
where bookid not in (select bookid
                     from orders
                     where custid like ( select custid
                                         from customer
                                         where name like '박지성'))

-- 주문하지 않은 고객의 이름
select name
from customer cs
where cs.custid not in (select od.custid
                        from orders od)

-- 주문 금액의 총액과 주문의 평균 금액
select sum(saleprice), avg(saleprice)
from orders

-- 고객의 이름과 고객별 구매액
select name, sum(saleprice)
from customer, orders
where customer.custid = orders.custid
group by name

-- 고객의 이름과 고객이 구매한 도서 목록
select name, bookname
from customer cs, book b1
where exists (select *
              from orders od
              where od.custid = cs.custid and b1.bookid = od.bookid)

-- 도서의 가격과 판매가격의 차이가 가장 많은 주문
select max(price - saleprice)
from orders, book
where orders.bookid = book.bookid;

-- 도서의 판매액 평균보다 자신의 구매액 평균이 더 높은 고객의 이름
select name, avg(saleprice)
from customer, orders
where customer.custid = orders.custid
group by name
having avg(saleprice) > (select avg(saleprice)
                         from orders);
```


-----------------------



#### **4. 정의어**

> CREATE 문

```sql

-- 생성예제 1
CREATE TABLE NewBook(
bookid      NUMBER,
bookname    VARCHAR2(20),
publisher   VARCHAR2(20),
price       NUMBER
);

-- 생성예제 2
CREATE TABLE NewCustomer(
custid      NUMBER PRIMARY KEY,
name        VARCHAR2(40),
address     VARCHAR2(40),
phone       VARCHAR2(30)
);

-- 생성예제 3
CREATE TABLE NewOrders(
orderid     NUMBER PRIMARY KEY,
custid      NUMBER NOT NULL,
bookid      NUMBER NOT NULL,
saleprice   NUMBER,
orderdate   DATE,
FOREIGN KEY (custid) REFERENCES NewCustomer(custid) ON DELETE CASCADE
);


```

> ALTER, DROP 문

```sql

-- 속성추가 예제 1
ALTER TABLE NewBook ADD isbn VARCHAR2(13);

-- 속성추가 예제 2
ALTER TABLE NewBook MODIFY isbn NUMBER;

-- 속성추가 예제 3
ALTER TABLE NewBook DROP COLUMN isbn;

-- 속성추가 예제 4
ALTER TABLE NewBook MODIFY bookid NUMBER NOT NULL;

-- 속성추가 예제 5
ALTER TABLE NewBook ADD PRIMARY KEY(bookid);

-- 삭제 예제 1
DROP TABLE NewBook;

-- 삭제 예제 2
DROP TABLE NewCustomer; -- 에러가 날거임. 그 이유는 다른데서 얘를 참조하고 있기 때문.

DROP TABLE NewOrders;
DROP TABLE NewCustomer;

```

> INSERT, UPDATE, DELETE 문

```sql

-- insert 예제 1
INSERT INTO Book (bookid, bookname, publisher, price)
       VALUES (11, '스포츠 의학', '한솔의학서적', 90000);

-- insert 예제 2
INSERT INTO Book (bookid, bookname, publisher)
       VALUES (14, '스포츠 의학', '한솔의학서적');

-- insert 예제 3
INSERT INTO Book (bookid, bookname, price, publisher)
       SELECT bookid, bookname, price, publisher
       FROM Imported_book;

-- update 예제 1
UPDATE Customer
SET address='대한민국 부산'
WHERE custid=5;

-- update 예제 2
UPDATE Customer
SET address = (select address
               from customer
               where name='김연아')
where name like '박세리';

-- delete 예제 1
delete from customer
where custid=5;

-- delete 예제 2
delete from customer -- 다른데서 외래키로 참조하기때문에 안됨.

```