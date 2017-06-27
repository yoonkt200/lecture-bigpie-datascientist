# 1주차 

- 1일차

## 1. [----설치----] 
1.1 Oracle download (Windosw 7 64bit 11gR2 ver.)\
www.oracle.com -> Menu -> Downloads -> Database -> Oracle Database -> 11gR2 ver File1,2 downloads. -> 두개의 압축폴더 하나의 폴더로 압축해제 -> 설치

1.2 Developer Tools download
download/developer download/Developer Tools--> SQL Developer --> 400MB Download

1.3 SQL Developer initioalize

![](https://raw.github.com/yoonkt200/DataScience/master/week1/week1_images/1.JPG)

![](https://raw.github.com/yoonkt200/DataScience/master/week1/week1_images/2.JPG)

## 2. [----데이터와 관련된 기본 정의----]

데이터 : 의미 없는 기록
정보 : 의미 있는 데이터
지식 : 가치 있는 정보
지혜 : 패턴화된 지식

데이터는 아무런 의미가 없는 기록을 말한다.
이러한 데이터가 모여 무언가 의미를 갖게 되면, 그것이 바로 정보이다.
만약 정보를 바탕으로 한 가지 유용한 사실을 발견하게 된다면, 이는 지식이 된다.
최종적으로 이러한 지식을 바탕으로 모든 데이터를 분석하여, 지식을 패턴에 적용시키게 되면 지혜가 된다.

## 3. [----k-ict----]
https://kbig.kr/ -> 인프라 -> 분석실습 관리

## 4. [----Data Modeling----]
- 4.1 개념적, 논리적 모델링

현실 세계의 개념을 기반으로 개념적 모델링을 하는것. -> ER다이어그램
개념적 모델이 성립된 후 논리적(관계 데이터 모델) 모델링을 함.

의사소통과 협업을 위해 이러한 속성들을 표현해 주는것. (문서화 작업의 일부)

- 4.2 데이터베이스 생명주기

요구사항 수집 및 분석 -> 설계 -> 구현 -> 운영 -> 감시 및 개선 -> 요구사항 수집 및 분석

요구사항 수집 및 분석 : 현실 세계의 대상 및 사용자의 요구 등을 정리하고 분석함.
개념적 모델링 : 핵심 엔티티 도출, ERD 작성
논리적 모델링 : 각 개념을 구체화함. 상세속성을 정의하고 정규화함. ERD-RDB 모델링.
물리적 모델링 : 생성 계획에 따라 DB개체를 정의하고 테이블과 인덱스를 설계함.

- 4.3 세부사항

4.3.1 요구사항 수집 및 분석 단계

1. 실제 문서를 수집하고 분석
2. 담당자와의 인터뷰나 설문조사로 요구사항 수렴
3. 비슷한 업무의 기존 DB를 분석함
4. 각 업무와 연관된 모든 부분을 살펴봄

4.3.2 개념적 모델링

개체(entity)를 추출하고 각 개체들간의 관계를 정의하여 ER다이어그램을 만드는 과정.

![](https://raw.github.com/yoonkt200/DataScience/master/week1/week1_images/3.JPG)

4.3.3 논리적 모델링

만들어진 ER 다이어그램을 바탕으로 사용하려는 DMBS에 맞게 매핑함.
