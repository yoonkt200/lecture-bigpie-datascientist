# 3일차 


-----------------------

#### **0-1. 3일차 학습 내용**

```
- 데이터 정의어(DDL) : 테이블 관계의 구조를 생성하는 등에 사용. CREATE, DROP 등이 있음.

- 데이터 조작어(DML) : 테이블에 데이터를 검색, 삽입, 수정, 삭제하는 등에 사용. (SELECT, INSERT, DELETE, UPDATE...)

- WHERE 조건 : 비교, 범위, 집합, 패턴, NULL등의 조건 술어를 사용하는 문법.

- 집계함수 : 테이블의 각 열에 대해 계산을 하는 함수. SUM, AVG, MIN, MAX, COUNT 등.

- GROUP BY : 속성의 공통값에 따라 그룹을 만드는데 사용하는 명령어.

- HAVING : group by 절의 결과 나타나는 그룹을 제한하는 역할. 검색조건 문법이라고 할수 있음.
```

-----------------------

#### **0-2. 개발환경 참고**

>1. 등록된 접속 계정 중 하나로 접속한 뒤, 다음과 같은 init SQL 쿼리를 실행 (ctrl + enter)

```sql
-- 이름: demo_madang_init.sql
-- Madang 서점의 모든 실습 데이터를 초기화 한다.

DROP table orders;
DROP table book;
DROP table customer;


CREATE TABLE Book (
  bookid      NUMBER(2) PRIMARY KEY,
  bookname    VARCHAR2(40),
  publisher   VARCHAR2(40),
  price       NUMBER(8) 
);

CREATE TABLE  Customer (
  custid      NUMBER(2) PRIMARY KEY,  
  name        VARCHAR2(40),
  address     VARCHAR2(50),
  phone       VARCHAR2(20)
);


CREATE TABLE Orders (
  orderid NUMBER(2) PRIMARY KEY,
  custid  NUMBER(2) REFERENCES Customer(custid),
  bookid  NUMBER(2) REFERENCES Book(bookid),
  saleprice NUMBER(8) ,
  orderdate DATE
);

-- Book, Customer, Orders 데이터 생성
INSERT INTO Book VALUES(1, '축구의 역사', '굿스포츠', 7000);
INSERT INTO Book VALUES(2, '축구아는 여자', '나무수', 13000);
INSERT INTO Book VALUES(3, '축구의 이해', '대한미디어', 22000);
INSERT INTO Book VALUES(4, '골프 바이블', '대한미디어', 35000);
INSERT INTO Book VALUES(5, '피겨 교본', '굿스포츠', 8000);
INSERT INTO Book VALUES(6, '역도 단계별기술', '굿스포츠', 6000);
INSERT INTO Book VALUES(7, '야구의 추억', '이상미디어', 20000);
INSERT INTO Book VALUES(8, '야구를 부탁해', '이상미디어', 13000);
INSERT INTO Book VALUES(9, '올림픽 이야기', '삼성당', 7500);
INSERT INTO Book VALUES(10, 'Olympic Champions', 'Pearson', 13000);

INSERT INTO Customer VALUES (1, '박지성', '영국 맨체스타', '000-5000-0001');
INSERT INTO Customer VALUES (2, '김연아', '대한민국 서울', '000-6000-0001');  
INSERT INTO Customer VALUES (3, '장미란', '대한민국 강원도', '000-7000-0001');
INSERT INTO Customer VALUES (4, '추신수', '미국 클리블랜드', '000-8000-0001');
INSERT INTO Customer VALUES (5, '박세리', '대한민국 대전',  NULL);

INSERT INTO Orders VALUES (1, 1, 1, 6000, TO_DATE('2014-07-01','yyyy-mm-dd')); 
INSERT INTO Orders VALUES (2, 1, 3, 21000, TO_DATE('2014-07-03','yyyy-mm-dd'));
INSERT INTO Orders VALUES (3, 2, 5, 8000, TO_DATE('2014-07-03','yyyy-mm-dd')); 
INSERT INTO Orders VALUES (4, 3, 6, 6000, TO_DATE('2014-07-04','yyyy-mm-dd')); 
INSERT INTO Orders VALUES (5, 4, 7, 20000, TO_DATE('2014-07-05','yyyy-mm-dd'));
INSERT INTO Orders VALUES (6, 1, 2, 12000, TO_DATE('2014-07-07','yyyy-mm-dd'));
INSERT INTO Orders VALUES (7, 4, 8, 13000, TO_DATE( '2014-07-07','yyyy-mm-dd'));
INSERT INTO Orders VALUES (8, 3, 10, 12000, TO_DATE('2014-07-08','yyyy-mm-dd')); 
INSERT INTO Orders VALUES (9, 2, 10, 7000, TO_DATE('2014-07-09','yyyy-mm-dd')); 
INSERT INTO Orders VALUES (10, 3, 8, 13000, TO_DATE('2014-07-10','yyyy-mm-dd'));

COMMIT;

```

>2. 계정 테이블에 book, customer, orders 테이블이 생성되었음

>3. 실행 시작!

참고 : 데이터 베이스 접속 명령어 - conn


-----------------------


#### **1. 기본 실습**


>demo_madang_init 열기 한 후에

>>코드 ctrl + a -> ctrl + enter : 테이블 initialize


>>데이터베이스 접속 명령어 : conn

```sql
select *
from Book;
-- Book의 모든 것을 보여줌

select phone
FROM Customer
WHERE name='김연아'
-- Customer중 name을 검색하여 phone을 보여줌 (name, phone을 다 보여주고 싶으면 select phone, name)

select DISTINCT name 
-- 중복 제거 셀렉트문

select *
from book
where bookname like '_구%' 
-- 책의 이름에서 두번째 문자가 '구'인 책들 찾음.
```

> 여러 가지 예제들
```sql
select *
from book
order by price DESC, publisher ASC;

select *
from book
where price between 10000 and 20000;

select *
from book
where publisher not in ('굿스포츠', '대한미디어')

select *
from book
where publisher LIKE '굿스포츠' or publisher LIKE '대한미디어'

select bookname, publisher
from book
where bookname LIKE '축구의 역사'

select bookname, publisher
from book
where bookname LIKE '%축구%'

select *
from book
where price >= 20000 and bookname like '%축구%'

select *
from book
where publisher in ('굿스포츠', '대한미디어')

SELECT * 
FROM Book
WHERE Bookname LIKE '%억'
SELECT * 
FROM Book
WHERE Bookname LIKE '%억'

select name
from orders, customer
where saleprice between 15000 and 20000

select *
from book
order by price DESC, publisher ASC;
```

-----------------------


#### **2. 함수 사용등 응용 실습**

```sql
select saleprice, custid
from orders

select sum(saleprice)
from orders

select sum(saleprice) as 총매출
from orders
where custid=2;

select sum(saleprice) as Total,
        avg(saleprice) as Average,
        min(saleprice) as Minimum,
        max(saleprice) as Maximum
from orders

select count(*)
from orders

select sum(saleprice) as "총 매출" -- 쌍따옴표로 해야 가능. 속성의 string은 쌍따옴표로.
from orders

select custid, count(*) as 도서수량, sum(saleprice) as 총액
from orders
group by custid;

select custid, count(*) as 도서수량, sum(saleprice) as 총액
from orders
where saleprice >= 8000 -- saleprice가 8000 이상인것만 연산에 포함
group by custid
having count(*) >= 2; -- having 조건은 순서가 중요하다. 여기서는 뒤에 나오는게 중요.
-- having은 검색조건 문법.
```



연습

```sql

-- 가격이 10000원 이상인 도서를 구매한 고객에 대하여 총 도서 판매액을 구하시오.
select custid, sum(saleprice) as "총 도서 판매액"
from orders
where saleprice >= 10000
group by custid;

-- 고객별로 주문한 도서의 수량과 평균 판매액을 구하시오
select custid, count(*) as 도서수량, avg(saleprice)
from orders
group by custid

-- 가격이 10000원 이상인 도서를 구매한 고객에 대하여 고객별 주문 도서의 총 수량을 구하시오. 단, 고객ID를 기준으로 정렬하시오.
select custid, count(*) 총수량
from orders
where saleprice >= 10000
group by custid
order by custid;

-- 총 만원이상 구매한 사람의 목록을 구하시오
select custid, sum(saleprice)
from orders
where saleprice >= 10000
group by custid

-- 1번 박지성 고객이 주문한 도서의 총 판매액을 구하세용
select custid, sum(saleprice) as 판매액
from orders
where custid=1
group by custid;

-- 축구 관련 도서를 구매한 고객에 대하여 고객별 주문 도서의 총 수량을 구하시오. 단, 두 권 이상 구매한 고객만 구하시오
select custid, count(*) as 수량
from orders
where bookid in (1,2,3)
group by custid
having count(*) >= 2;

-- 도서번호가 1인 도서의 이름
select bookname
from book
where bookid=1

-- 가격이 20000원 이상인 도서의 이름
select bookname, price
from book
where price >= 20000

-- 서점 도서의 총 개수
select count(*) as "총 개수"
from book

-- 서점에 도서를 출고하는 출판사의 총 개수
select count(DISTINCT publisher) as "출판사 개수"
from book

-- 모든 고객의 이름, 주소
select name, address
from customer

-- 2014.7.4 ~ 7.7 사이에 주문받은 도서의 주문번호
select orderid
from orders
where orderdate between '14/07/04' and '14/07/07'

-- 2014.7.4 ~ 7.7 사이에 주문받지 않은 도서의 주문번호
select orderid
from orders
where orderdate not between '14/07/04' and '14/07/07'

-- 성이 김씨인 고객의 이름과 주소
select name, address
from customer
where name like '김%'

-- 성이 김씨이고 아로 끝나는 고객의 이름과 주소
select name, address
from customer
where name like '김%' and name like '%아' 
-- where name like '김%' and name like '김%아' : 이렇게 쓸 수도 있음

```

-----------------------

#### **4. ??**

> 게임을 하면 이겨야지!

```sql
??
```

-----------------------